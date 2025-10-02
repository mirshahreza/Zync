# =============================================
# Zync Test Runner Script
# Author: Mohsen Mirshahreza
# Date: 2025-10-02
# Description: Runs all Zync package tests and generates a report
# =============================================

param(
    [string]$ServerInstance = "",
    [string]$Database = "",
    [switch]$UseWindowsAuth = $true,
    [string]$Username = "",
    [string]$Password = "",
    [switch]$UseConfig = $true
)

# Import configuration if available
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $scriptDir "ZyncConfig.psm1"

if ($UseConfig -and (Test-Path $configPath)) {
    Import-Module $configPath -Force
    
    # Use config values if parameters not provided
    if (-not $ServerInstance) { $ServerInstance = $script:ZyncConfig.ServerInstance }
    if (-not $Database) { $Database = $script:ZyncConfig.Database }
    
    Write-Host "📁 Using configuration from ZyncConfig.psm1" -ForegroundColor Green
}

# Fallback to defaults if still empty
if (-not $ServerInstance) { $ServerInstance = "localhost" }
if (-not $Database) { $Database = "master" }

Write-Host "🧪 ZYNC COMPREHENSIVE TEST SUITE" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Define test files
$testFiles = @(
    "zync_test_backup.sql",
    "zync_test_base.sql",
    "zync_test_dbman.sql",
    "zync_test_dbmon.sql",
    "zync_test_financial.sql",
    "zync_test_geographic.sql",
    "zync_test_json.sql",
    "zync_test_math.sql",
    "zync_test_security.sql",
    "zync_test_string.sql",
    "zync_test_validation.sql"
)

# Test results array
$results = @()
$totalTests = $testFiles.Count
$passedTests = 0
$failedTests = 0
$errorTests = 0

# Get test directory
$scriptParentDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$testDir = Join-Path $scriptParentDir "Test"

if (-not (Test-Path $testDir)) {
    Write-Host "❌ Test directory not found: $testDir" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Test Directory: $testDir" -ForegroundColor Gray
Write-Host "🗄️  Server: $ServerInstance" -ForegroundColor Gray
Write-Host "💾 Database: $Database" -ForegroundColor Gray
Write-Host ""

# Build connection string
if ($UseConfig -and (Get-Command Get-ZyncSqlcmdArgs -ErrorAction SilentlyContinue)) {
    $sqlcmdArgs = Get-ZyncSqlcmdArgs -Database $Database
} elseif ($UseWindowsAuth) {
    $sqlcmdArgs = @("-S", $ServerInstance, "-d", $Database, "-E", "-C")
} else {
    $sqlcmdArgs = @("-S", $ServerInstance, "-d", $Database, "-U", $Username, "-P", $Password, "-C")
}

# Run each test
$testNumber = 1
foreach ($testFile in $testFiles) {
    $fullPath = Join-Path $testDir $testFile
    
    if (-not (Test-Path $fullPath)) {
        Write-Host "[$testNumber/$totalTests] ⚠️  SKIP: $testFile (File not found)" -ForegroundColor Yellow
        $errorTests++
        $results += [PSCustomObject]@{
            Test = $testFile
            Status = "SKIP"
            Message = "File not found"
            Duration = "N/A"
        }
        $testNumber++
        continue
    }
    
    Write-Host "[$testNumber/$totalTests] 🔄 Running: $testFile..." -ForegroundColor White -NoNewline
    
    $startTime = Get-Date
    
    try {
        # Execute SQL test file
        $testArgs = $sqlcmdArgs + @("-i", $fullPath)
        $output = & sqlcmd $testArgs 2>&1
        
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        
        # Check output for results
        $outputText = $output -join "`n"
        
        if ($outputText -match "ALL TESTS PASSED") {
            Write-Host "`r[$testNumber/$totalTests] ✅ PASS: $testFile (${duration}s)" -ForegroundColor Green
            $passedTests++
            $results += [PSCustomObject]@{
                Test = $testFile
                Status = "PASS"
                Message = "All tests passed"
                Duration = "${duration}s"
            }
        }
        elseif ($outputText -match "SOME TESTS FAILED") {
            Write-Host "`r[$testNumber/$totalTests] ⚠️  WARN: $testFile (${duration}s)" -ForegroundColor Yellow
            $failedTests++
            $results += [PSCustomObject]@{
                Test = $testFile
                Status = "WARN"
                Message = "Some tests failed"
                Duration = "${duration}s"
            }
        }
        elseif ($outputText -match "ERROR|Error|exception") {
            Write-Host "`r[$testNumber/$totalTests] ❌ ERROR: $testFile (${duration}s)" -ForegroundColor Red
            $errorTests++
            $results += [PSCustomObject]@{
                Test = $testFile
                Status = "ERROR"
                Message = "Execution error"
                Duration = "${duration}s"
            }
        }
        else {
            Write-Host "`r[$testNumber/$totalTests] ✅ DONE: $testFile (${duration}s)" -ForegroundColor Cyan
            $passedTests++
            $results += [PSCustomObject]@{
                Test = $testFile
                Status = "DONE"
                Message = "Executed successfully"
                Duration = "${duration}s"
            }
        }
    }
    catch {
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        
        Write-Host "`r[$testNumber/$totalTests] ❌ ERROR: $testFile - $($_.Exception.Message)" -ForegroundColor Red
        $errorTests++
        $results += [PSCustomObject]@{
            Test = $testFile
            Status = "ERROR"
            Message = $_.Exception.Message
            Duration = "${duration}s"
        }
    }
    
    $testNumber++
}

# Print summary
Write-Host ""
Write-Host "📊 TEST SUMMARY" -ForegroundColor Cyan
Write-Host "===============" -ForegroundColor Cyan
Write-Host ""

$results | Format-Table -AutoSize

Write-Host ""
Write-Host "Total Tests:  $totalTests" -ForegroundColor White
Write-Host "✅ Passed:    $passedTests" -ForegroundColor Green
Write-Host "⚠️  Warnings:  $failedTests" -ForegroundColor Yellow
Write-Host "❌ Errors:    $errorTests" -ForegroundColor Red
Write-Host ""

# Calculate success rate
$successRate = [math]::Round(($passedTests / $totalTests) * 100, 2)
Write-Host "Success Rate: $successRate%" -ForegroundColor $(if ($successRate -ge 80) { "Green" } elseif ($successRate -ge 50) { "Yellow" } else { "Red" })

# Save results to file
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logDir = Join-Path $scriptParentDir "TestLogs"
$reportFile = Join-Path $logDir "test_run_$timestamp.log"

# Ensure TestLogs directory exists
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

$reportContent = @"
ZYNC TEST SUITE EXECUTION REPORT
=================================
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Server: $ServerInstance
Database: $Database

RESULTS:
--------
Total Tests: $totalTests
Passed: $passedTests
Warnings: $failedTests
Errors: $errorTests
Success Rate: $successRate%

DETAILED RESULTS:
-----------------
$($results | Format-Table -AutoSize | Out-String)
"@

$reportContent | Out-File -FilePath $reportFile -Encoding UTF8
Write-Host ""
Write-Host "📄 Report saved to: $reportFile" -ForegroundColor Gray
Write-Host ""

if ($errorTests -eq 0 -and $failedTests -eq 0) {
    Write-Host "🎉 ALL TESTS COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    exit 0
} elseif ($errorTests -gt 0) {
    Write-Host "⚠️  SOME TESTS ENCOUNTERED ERRORS" -ForegroundColor Red
    exit 1
} else {
    Write-Host "⚠️  SOME TESTS NEED ATTENTION" -ForegroundColor Yellow
    exit 0
}
