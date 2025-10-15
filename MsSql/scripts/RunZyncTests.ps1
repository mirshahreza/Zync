[CmdletBinding()]
param(
    [string]$ServerName = ".\\SQL2022",
    [string]$Database = "ZyncTest",
    [ValidateSet('Windows','Sql')]
    [string]$Auth = 'Windows',
    [string]$User,
    [string]$Password,
    [switch]$ContinueOnError,
    [string]$TestFilter = '*.sql',
    [switch]$NoOleAutomation
)

# --- Helpers ---
function Write-Section($title) {
    Write-Host ("`n===== " + $title + " =====") -ForegroundColor Cyan
}

function Ensure-SqlServerModule {
    if (-not (Get-Module -ListAvailable -Name SqlServer)) {
        Write-Host "SqlServer PowerShell module not found. Attempting to install..." -ForegroundColor Yellow
        try {
            $prev = Get-PSRepository -Name 'PSGallery' -ErrorAction SilentlyContinue
            if (-not $prev) { Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue | Out-Null }
            Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
            Write-Host "SqlServer module installed." -ForegroundColor Green
        }
        catch {
            throw "Failed to install SqlServer module. Install it manually: Install-Module SqlServer -Scope CurrentUser"
        }
    }
    Import-Module SqlServer -ErrorAction Stop | Out-Null
}

function Invoke-Sql($Query, $InputFile) {
    $params = @{
        ServerInstance = $ServerName
        Database = $Database
        ErrorAction = 'Stop'
    }
    # Handle common TLS issues with local SQL Server by trusting server certificate and using optional encryption
    $params['TrustServerCertificate'] = $true
    $params['Encrypt'] = 'Optional'
    if ($Auth -eq 'Sql') {
        if (-not $User -or -not $Password) { throw "SQL auth requires -User and -Password" }
        $params['Username'] = $User
        $params['Password'] = $Password
    }
    if ($Query) { return Invoke-Sqlcmd @params -Query $Query } else { return Invoke-Sqlcmd @params -InputFile $InputFile }
}

function Test-ConnectionSql {
    try {
        Invoke-Sql -Query 'SELECT TOP 1 GETDATE() AS Now' | Out-Null
        return $true
    } catch { return $false }
}

function Ensure-Database {
    $params = @{
        ServerInstance = $ServerName
        ErrorAction = 'Stop'
    }
    $params['TrustServerCertificate'] = $true
    $params['Encrypt'] = 'Optional'
    if ($Auth -eq 'Sql') { $params['Username'] = $User; $params['Password'] = $Password }
    $exists = $false
    try {
        $dbs = Invoke-Sqlcmd @params -Query "SELECT name FROM sys.databases WHERE name = '$Database'"
        if ($dbs) { $exists = $true }
    } catch {}
    if (-not $exists) {
        Write-Host "Creating database '$Database'..." -ForegroundColor Yellow
        Invoke-Sqlcmd @params -Query "CREATE DATABASE [$Database];"
        Write-Host "Database created." -ForegroundColor Green
        # Wait until ONLINE
        $tries = 0
        do {
            Start-Sleep -Milliseconds 500
            $state = Invoke-Sqlcmd @params -Query "SELECT state_desc FROM sys.databases WHERE name = '$Database'" | Select-Object -First 1 -ExpandProperty state_desc
            $tries++
        } while ($state -ne 'ONLINE' -and $tries -lt 20)
        Write-Host "Database state: $state" -ForegroundColor Gray
        # Attempt to ensure access for current login (Windows auth only)
        if ($Auth -eq 'Windows') {
            $currentLogin = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Replace("'","''")
            $tsql = @"
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'$currentLogin')
    CREATE LOGIN [$currentLogin] FROM WINDOWS;
IF DB_ID(N'$Database') IS NOT NULL
BEGIN
    EXEC('USE [$Database]; IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N''' + REPLACE(N'$currentLogin','''','''''') + N''')
        CREATE USER [' + N'$currentLogin' + N'] FOR LOGIN [' + N'$currentLogin' + N']; EXEC sp_addrolemember ''db_owner'',''' + REPLACE(N'$currentLogin','''','''''') + N'''');
END
"@
            try { Invoke-Sqlcmd @params -Query $tsql | Out-Null } catch { Write-Verbose $_ }
        }
    }
}

# --- Main ---
$ErrorActionPreference = 'Stop'
$msSqlDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)  # points to MsSql
$zyncSql = Join-Path $msSqlDir 'Zync.sql'
$testsDir = Join-Path $msSqlDir 'Test'
$logsDir = Join-Path $msSqlDir 'TestLogs'
New-Item -ItemType Directory -Force -Path $logsDir | Out-Null

Write-Section "Preparation"
Ensure-SqlServerModule

Write-Host "Target server: $ServerName" -ForegroundColor Gray
Write-Host "Target database: $Database" -ForegroundColor Gray
if (-not (Test-Path $zyncSql)) { throw "Zync.sql not found at $zyncSql" }
if (-not (Test-Path $testsDir)) { throw "Tests folder not found at $testsDir" }

Write-Section "Server connectivity"
if (-not (Test-ConnectionSql)) {
    # Try connecting to master to verify server then create DB
    $params = @{
        ServerInstance = $ServerName
        ErrorAction = 'Stop'
    }
    $params['TrustServerCertificate'] = $true
    $params['Encrypt'] = 'Optional'
    if ($Auth -eq 'Sql') { $params['Username'] = $User; $params['Password'] = $Password }
    Write-Host "Testing connection to server on master..." -ForegroundColor Gray
    Invoke-Sqlcmd @params -Query 'SELECT @@VERSION' | Out-Null
}

Write-Section "Database setup"
Ensure-Database

Write-Section "Install Zync (MsSql/Zync.sql)"
Invoke-Sql -InputFile $zyncSql | Out-Null
Write-Host "Zync installed/updated." -ForegroundColor Green

if (-not $NoOleAutomation) {
    Write-Section "Enable OLE Automation (required for HTTP fetch)"
    try {
        $params = @{
            ServerInstance = $ServerName
            ErrorAction = 'Stop'
        }
        $params['TrustServerCertificate'] = $true
        $params['Encrypt'] = 'Optional'
        if ($Auth -eq 'Sql') { $params['Username'] = $User; $params['Password'] = $Password }
        Invoke-Sqlcmd @params -Query "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE;" | Out-Null
        Write-Host "OLE Automation Procedures enabled." -ForegroundColor Green
    }
    catch {
        Write-Warning "Couldn't enable OLE Automation. Some tests that fetch from GitHub may fail. Use -NoOleAutomation to skip this step intentionally."
    }
}

# Test ordering: start with syntax/diagnostics, then install/remove flows, then cleanups
$preferredOrder = @(
    'zync_check_syntax.sql',
    'zync_debug_parsing.sql',
    'zync_debug_existence.sql',
    'zync_debug_diagnostic.sql',
    'zync_test_comprehensive.sql',
    'zync_debug_simulation.sql',
    'zync_test_cleanup.sql',
    'zync_test_cleanup_quick.sql',
    'zync_cleanup_simple.sql',
    'zync_test_removal.sql',
    'zync_test_removal_fix.sql',
    'zync_cleanup_dbman_complete.sql',
    'zync_cleanup_manual.sql',
    # DateTime function tests
    'zync_check_datetime_existence.sql',
    'zync_test_datetime_simple.sql',
    'zync_test_datetime_advanced.sql',
    'zync_test_datetime_comprehensive.sql'
)

$allTests = Get-ChildItem -Path $testsDir -Filter $TestFilter -File | Sort-Object Name
# Merge with preferred order: pick those that exist in order, then append remaining
$ordered = @()
foreach ($name in $preferredOrder) {
    $match = $allTests | Where-Object { $_.Name -ieq $name }
    if ($match) { $ordered += $match }
}
$remaining = $allTests | Where-Object { $preferredOrder -notcontains $_.Name }
$ordered += $remaining

Write-Section "Discovered tests"
$ordered | ForEach-Object { Write-Host (" - " + $_.Name) -ForegroundColor Gray }

$results = @()

foreach ($test in $ordered) {
    Write-Section ("Running: " + $test.Name)
    $logPath = Join-Path $logsDir ($test.BaseName + '.log')
    $ok = $true
    $errMsg = $null
    try {
        # Ensure a clean context before each test to reduce cross-test interference
        try { Invoke-Sql -Query "IF OBJECT_ID('[dbo].[Zync]','P') IS NOT NULL EXEC dbo.Zync 'clean'" | Out-Null } catch {}
        Invoke-Sql -InputFile $test.FullName *>&1 | Tee-Object -FilePath $logPath | Out-Null
        Write-Host ("✔ Passed: " + $test.Name) -ForegroundColor Green
    }
    catch {
        $ok = $false
        $errMsg = $_.Exception.Message
        $_ | Out-File -FilePath $logPath -Append
        Write-Host ("✘ Failed: " + $test.Name) -ForegroundColor Red
        Write-Host ("  -> " + $errMsg) -ForegroundColor DarkRed
        if (-not $ContinueOnError) { break }
    }
    $results += [PSCustomObject]@{ Name = $test.Name; Passed = $ok; Log = $logPath; Error = $errMsg }
}

Write-Section "Summary"
$passed = $results | Where-Object { $_.Passed } | Measure-Object | Select-Object -ExpandProperty Count
$failed = $results | Where-Object { -not $_.Passed } | Measure-Object | Select-Object -ExpandProperty Count
Write-Host ("Total: " + ($results.Count) + ", Passed: $passed, Failed: $failed") -ForegroundColor Cyan
if ($failed -gt 0) {
    Write-Host "Failed tests:" -ForegroundColor Yellow
    $results | Where-Object { -not $_.Passed } | ForEach-Object { Write-Host (" - " + $_.Name + " (log: " + $_.Log + ")") -ForegroundColor Yellow }
}

# Exit code for CI
if ($failed -gt 0) { exit 1 } else { exit 0 }
