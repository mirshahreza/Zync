param(
    [string]$ServerName = ".\SQL2022",
    [string]$Database = "AppEndV2",
    [string]$User = "sa",
    [string]$Password = "1",
    [string]$NamePrefix = "Base",
    [string]$OutputDir = "c:\Workspace\Projects\Zync\MsSql\Packages\Base"
)


$ErrorActionPreference = 'Stop'

Write-Host "[Zync] Loading SMO assemblies..."
# Try loading SMO from installed assemblies first
$assemblies = @(
    'Microsoft.SqlServer.Smo',
    'Microsoft.SqlServer.ConnectionInfo',
    'Microsoft.SqlServer.SmoExtended',
    'Microsoft.SqlServer.Management.Sdk.Sfc'
)
$smoLoaded = $true
foreach ($asm in $assemblies) {
    $loaded = [System.Reflection.Assembly]::LoadWithPartialName($asm)
    if (-not $loaded) { $smoLoaded = $false }
}

if (-not $smoLoaded) {
    Write-Host "[Zync] SMO assemblies not fully available. Trying to import 'SqlServer' PowerShell module..."
    try {
        Import-Module SqlServer -ErrorAction Stop
        $smoLoaded = $true
    }
    catch {
        Write-Warning "[Zync] Could not import 'SqlServer' PowerShell module. If this script fails, install it with: Install-Module -Name SqlServer -Scope CurrentUser"
    }
}

if (-not $smoLoaded) {
    throw "SMO not available. Install the 'SqlServer' PowerShell module or SQL Server Management Objects, then retry."
}

# Connect to SQL Server using SMO
Write-Host "[Zync] Connecting to $ServerName / DB: $Database ..."
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server $ServerName
$srv.ConnectionContext.LoginSecure = $false
$srv.ConnectionContext.Login = $User
$srv.ConnectionContext.Password = $Password

$db = $srv.Databases[$Database]
if (-not $db) { throw "Database not found: $Database" }

# Prepare output directory
if (-not (Test-Path -LiteralPath $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null }

# Collect Base* tables (dbo schema only by default, but include all schemas to be safe)
$tables = $db.Tables | Where-Object { $_.IsSystemObject -eq $false -and $_.Name -like "$NamePrefix*" }
if (-not $tables -or $tables.Count -eq 0) { throw "No tables found matching prefix '$NamePrefix' in $Database." }

Write-Host "[Zync] Found $($tables.Count) table(s) starting with '$NamePrefix'"

# Build dependency graph between Base* tables using foreign keys
$allNames = @{}
foreach ($t in $tables) { $allNames["$($t.Schema).$($t.Name)"] = $t }

$deps = @{}         # table -> set of referenced tables (within Base*)
$revDeps = @{}      # table -> set of dependents
$inDegree = @{}

foreach ($key in $allNames.Keys) {
    $deps[$key] = New-Object System.Collections.Generic.HashSet[string]
    $revDeps[$key] = New-Object System.Collections.Generic.HashSet[string]
    $inDegree[$key] = 0
}

foreach ($t in $tables) {
    foreach ($fk in $t.ForeignKeys) {
        $ref = "$($fk.ReferencedTableSchema).$($fk.ReferencedTable)"
        $cur = "$($t.Schema).$($t.Name)"
        if ($allNames.ContainsKey($ref)) {
            if ($deps[$cur].Add($ref)) {
                $inDegree[$cur] = [int]$inDegree[$cur] + 1
                $revDeps[$ref].Add($cur) | Out-Null
            }
        }
    }
}

# Kahn topological sort
$queue = New-Object System.Collections.Generic.Queue[System.String]
foreach ($k in $allNames.Keys) { if ($inDegree[$k] -eq 0) { $queue.Enqueue($k) } }
$ordered = @()
while ($queue.Count -gt 0) {
    $n = $queue.Dequeue(); $ordered += $n
    foreach ($m in $revDeps[$n]) {
        $inDegree[$m] = [int]$inDegree[$m] - 1
        if ($inDegree[$m] -eq 0) { $queue.Enqueue($m) }
    }
}
# If cycle exists, append remaining in arbitrary order
if ($ordered.Count -lt $allNames.Count) {
    Write-Host "[Zync] Warning: Cycles detected among tables. Appending remaining tables arbitrarily."
    foreach ($k in $allNames.Keys) { if (-not ($ordered -contains $k)) { $ordered += $k } }
}

# First pass: script tables without foreign keys (to avoid ordering issues)
$scripter = New-Object Microsoft.SqlServer.Management.Smo.Scripter ($srv)
$opt = New-Object Microsoft.SqlServer.Management.Smo.ScriptingOptions
$opt.ScriptDrops = $false
$opt.IncludeIfNotExists = $true
$opt.SchemaQualify = $true
$opt.DriAll = $false
$opt.DriPrimaryKey = $true
$opt.DriUniqueKeys = $true
$opt.DriChecks = $true
$opt.DriDefaults = $true
$opt.DriForeignKeys = $false
$opt.Indexes = $true
$opt.Triggers = $true
$opt.Default = $true
$opt.NoCollation = $true
$opt.Bindings = $true
$opt.ClusteredIndexes = $true
$opt.NonClusteredIndexes = $true
$opt.FullTextIndexes = $true
$opt.NoFileGroup = $false
$scripter.Options = $opt

# Script each table into its own .sql (without FKs)
$scriptFiles = @()
foreach ($name in $ordered) {
    $t = $allNames[$name]
    $urn = $t.Urn
    $parts = $name.Split('.')
    $schema = $parts[0]; $tname = $parts[1]
    $file = Join-Path $OutputDir "$tname.sql"

    $sc = $scripter.Script($urn)
    $body = ($sc -join [Environment]::NewLine)

    $header = @(
        '-- =============================================',
        "-- Author:      SMO scripted",
        "-- Create date: $(Get-Date -Format 'yyyy-MM-dd')",
        "-- Description: Create table [$schema].[$tname] with keys, defaults, and indexes.",
        '-- ============================================='
    ) -join [Environment]::NewLine

    $content = "$header`r`n$body`r`n"
    Set-Content -LiteralPath $file -Value $content -Encoding UTF8
    $scriptFiles += $tname
    Write-Host "[Zync] Wrote: $file"
}

# Second pass: script foreign keys separately into a single file
$fkUrns = @()
foreach ($t in $tables) {
    foreach ($fk in $t.ForeignKeys) {
        $ref = "$($fk.ReferencedTableSchema).$($fk.ReferencedTable)"
        if ($allNames.ContainsKey($ref)) {
            $fkUrns += $fk.Urn
        }
    }
}

if ($fkUrns.Count -gt 0) {
    $fkScripter = New-Object Microsoft.SqlServer.Management.Smo.Scripter ($srv)
    $fkOpt = New-Object Microsoft.SqlServer.Management.Smo.ScriptingOptions
    $fkOpt.ScriptDrops = $false
    $fkOpt.IncludeIfNotExists = $true
    $fkOpt.SchemaQualify = $true
    $fkOpt.DriForeignKeys = $true
    $fkOpt.DriPrimaryKey = $false
    $fkOpt.DriUniqueKeys = $false
    $fkOpt.DriChecks = $false
    $fkOpt.DriDefaults = $false
    $fkOpt.Indexes = $false
    $fkOpt.Triggers = $false
    $fkOpt.NoCollation = $true
    $fkOpt.NoFileGroup = $true
    $fkScripter.Options = $fkOpt

    $fkScripts = $fkScripter.Script(@($fkUrns))
    $fkHeader = @(
        '-- =============================================',
        "-- Author:      SMO scripted",
        "-- Create date: $(Get-Date -Format 'yyyy-MM-dd')",
        "-- Description: Add foreign keys for $NamePrefix* tables.",
        '-- ============================================='
    ) -join [Environment]::NewLine
    $fkBody = ($fkScripts -join [Environment]::NewLine)
    $fkContent = "$fkHeader`r`n$fkBody`r`n"
    $fkFile = Join-Path $OutputDir "_ForeignKeys.sql"
    Set-Content -LiteralPath $fkFile -Value $fkContent -Encoding UTF8
    Write-Host "[Zync] Wrote: $fkFile"
}

# Create package index .sql (tables first, then foreign keys)
$indexPath = Join-Path $OutputDir ".sql"
$indexHeader = @(
    '/*',
    "Generated by GenerateZyncPackageFromDb.ps1 on $(Get-Date -Format 'yyyy-MM-dd HH:mm')",
    "Package: $NamePrefix",
    '*/'
) -join [Environment]::NewLine

$indexLines = foreach ($tname in $scriptFiles) { "EXEC DBO.Zync 'i $NamePrefix/$tname.sql';" }
if (Test-Path (Join-Path $OutputDir "_ForeignKeys.sql")) {
    $indexLines += "EXEC DBO.Zync 'i $NamePrefix/_ForeignKeys.sql';"
}
$indexContent = ($indexHeader + [Environment]::NewLine + ($indexLines -join [Environment]::NewLine))
Set-Content -LiteralPath $indexPath -Value $indexContent -Encoding UTF8
Write-Host "[Zync] Wrote package index: $indexPath"

Write-Host "[Zync] Done. Tables scripted: $($scriptFiles.Count). Output: $OutputDir"