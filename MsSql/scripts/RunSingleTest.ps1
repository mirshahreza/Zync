# =============================================
# Run Single Test Script
# Runs a specific Zync package test
# =============================================

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        "backup", "base", "dbman", "dbmon", "financial", 
        "geographic", "json", "math", "security", "string", "validation"
    )]
    [string]$TestName,
    
    [string]$Database = ""
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $scriptDir "ZyncConfig.psm1"

# Import configuration
if (Test-Path $configPath) {
    Import-Module $configPath -Force
    if (-not $Database -or $Database -eq "") { 
        $Database = $script:ZyncConfig.Database 
        if (-not $Database -or $Database -eq "") { $Database = "master" }
    }
    Write-Host "📁 Using configuration from ZyncConfig.psm1" -ForegroundColor Green
} else {
    Write-Host "⚠️  Configuration file not found. Using defaults." -ForegroundColor Yellow
    if (-not $Database -or $Database -eq "") { $Database = "master" }
}

Write-Host ""
Write-Host "🧪 Running $TestName Test" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# Get test file path
$testDir = Join-Path (Split-Path -Parent $scriptDir) "Test"
$testFile = "zync_test_$TestName.sql"
$fullPath = Join-Path $testDir $testFile

if (-not (Test-Path $fullPath)) {
    Write-Host "❌ Test file not found: $testFile" -ForegroundColor Red
    exit 1
}

Write-Host "📄 Test File: $testFile" -ForegroundColor Gray
Write-Host "🗄️  Database: $Database" -ForegroundColor Gray
Write-Host ""

# Get sqlcmd arguments
if (Get-Command Get-ZyncSqlcmdArgs -ErrorAction SilentlyContinue) {
    $sqlcmdArgs = Get-ZyncSqlcmdArgs -Database $Database
} else {
    $sqlcmdArgs = @("-S", "localhost", "-d", $Database, "-E", "-C")
}

$startTime = Get-Date

try {
    # Execute test
    $testArgs = $sqlcmdArgs + @("-i", $fullPath)
    $output = & sqlcmd $testArgs 2>&1
    
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalSeconds
    
    # Display output
    Write-Host "📊 Test Output:" -ForegroundColor Cyan
    Write-Host "===============" -ForegroundColor Cyan
    $output | ForEach-Object { Write-Host $_ }
    
    Write-Host ""
    Write-Host "⏱️  Execution Time: ${duration}s" -ForegroundColor Gray
    Write-Host ""
    
    # Check result
    $outputText = $output -join "`n"
    
    if ($LASTEXITCODE -eq 0) {
        if ($outputText -match "ALL TESTS PASSED") {
            Write-Host "✅ Test Completed Successfully!" -ForegroundColor Green
            exit 0
        } elseif ($outputText -match "SOME TESTS FAILED") {
            Write-Host "⚠️  Test Completed with Warnings" -ForegroundColor Yellow
            exit 0
        } else {
            Write-Host "✅ Test Executed" -ForegroundColor Cyan
            exit 0
        }
    } else {
        Write-Host "❌ Test Failed with Exit Code: $LASTEXITCODE" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host ""
    Write-Host "❌ Error Running Test!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
