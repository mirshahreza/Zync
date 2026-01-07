# =============================================
# Zync Scenario Test Runner
# Author: Zync Development Team
# Date: 2026-01-06
# Description: Runs all scenario tests sequentially with detailed reporting
# =============================================

[CmdletBinding()]
param(
    [string]$ServerInstance = ".\SQL2022",
    [string]$Database = "ZyncTest",
    [switch]$UseWindowsAuth = $true,
    [string]$Username = "",
    [string]$Password = "",
    [switch]$StopOnError = $false,
    [switch]$ShowOutput = $false
)

# Colors
$ColorHeader = "Cyan"
$ColorSuccess = "Green"
$ColorError = "Red"
$ColorWarning = "Yellow"
$ColorInfo = "Gray"

# Summary counters
$TotalTests = 0
$PassedTests = 0
$FailedTests = 0
$TestResults = @()

# Start time
$StartTime = Get-Date

Write-Host ""
Write-Host "=========================================" -ForegroundColor $ColorHeader
Write-Host "   ZYNC SCENARIO TEST SUITE RUNNER" -ForegroundColor $ColorHeader
Write-Host "=========================================" -ForegroundColor $ColorHeader
Write-Host ""
Write-Host "Configuration:" -ForegroundColor $ColorInfo
Write-Host "  Server Instance: $ServerInstance" -ForegroundColor $ColorInfo
Write-Host "  Database: $Database" -ForegroundColor $ColorInfo
Write-Host "  Authentication: $(if($UseWindowsAuth){'Windows'}else{'SQL Server'})" -ForegroundColor $ColorInfo
Write-Host "  Stop on Error: $StopOnError" -ForegroundColor $ColorInfo
Write-Host ""

# Get test directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TestDir = Join-Path (Split-Path -Parent $ScriptDir) "Test\Scenarios"

if (-not (Test-Path $TestDir)) {
    Write-Host "Error: Scenarios directory not found at: $TestDir" -ForegroundColor $ColorError
    exit 1
}

# Get all scenario test files
$TestFiles = Get-ChildItem -Path $TestDir -Filter "zync_scenario_*.sql" | Sort-Object Name

if ($TestFiles.Count -eq 0) {
    Write-Host "Warning: No scenario test files found in: $TestDir" -ForegroundColor $ColorWarning
    exit 1
}

Write-Host "Found $($TestFiles.Count) scenario tests" -ForegroundColor $ColorSuccess
Write-Host ""

# Build sqlcmd arguments
$SqlCmdArgs = @("-S", $ServerInstance, "-d", $Database)
if ($UseWindowsAuth) {
    $SqlCmdArgs += "-E"
} else {
    if ([string]::IsNullOrEmpty($Username) -or [string]::IsNullOrEmpty($Password)) {
        Write-Host "Error: Username and Password required for SQL Server authentication" -ForegroundColor $ColorError
        exit 1
    }
    $SqlCmdArgs += @("-U", $Username, "-P", $Password)
}

# Test connection first
Write-Host "Testing database connection..." -ForegroundColor $ColorInfo
$TestQuery = "SELECT GETDATE() AS CurrentTime"
$ConnectionTest = $null
try {
    $ConnectionTestArgs = $SqlCmdArgs + @("-Q", $TestQuery, "-h", "-1")
    $ConnectionTest = & sqlcmd @ConnectionTestArgs 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Connection successful" -ForegroundColor $ColorSuccess
    } else {
        throw "Connection failed"
    }
} catch {
    Write-Host "Error: Could not connect to SQL Server" -ForegroundColor $ColorError
    Write-Host "   Server: $ServerInstance" -ForegroundColor $ColorError
    Write-Host "   Database: $Database" -ForegroundColor $ColorError
    Write-Host ""
    Write-Host "Please ensure:" -ForegroundColor $ColorWarning
    Write-Host "  1. SQL Server is running" -ForegroundColor $ColorWarning
    Write-Host "  2. Server instance name is correct" -ForegroundColor $ColorWarning
    Write-Host "  3. Database exists" -ForegroundColor $ColorWarning
    Write-Host "  4. You have necessary permissions" -ForegroundColor $ColorWarning
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor $ColorHeader
Write-Host "   RUNNING TESTS" -ForegroundColor $ColorHeader
Write-Host "=========================================" -ForegroundColor $ColorHeader
Write-Host ""

# Run each test
$TestNumber = 1
foreach ($TestFile in $TestFiles) {
    $TotalTests++
    $TestName = $TestFile.Name
    $TestPath = $TestFile.FullName
    
    Write-Host "[$TestNumber/$($TestFiles.Count)] Running: " -NoNewline -ForegroundColor $ColorInfo
    Write-Host $TestName -ForegroundColor $ColorHeader
    Write-Host "  Path: $TestPath" -ForegroundColor $ColorInfo
    
    $TestStartTime = Get-Date
    
    # Run the test
    $TestArgs = $SqlCmdArgs + @("-i", $TestPath)
    $Output = & sqlcmd @TestArgs 2>&1
    $ExitCode = $LASTEXITCODE
    
    $TestEndTime = Get-Date
    $Duration = ($TestEndTime - $TestStartTime).TotalSeconds
    
    # Check result
    $TestPassed = $false
    if ($ExitCode -eq 0) {
        # Check output for test status
        $OutputString = $Output -join "`n"
        
        if ($OutputString -match "Status:\s*✅\s*ALL TESTS PASSED") {
            $TestPassed = $true
            $PassedTests++
            Write-Host "  PASSED" -ForegroundColor $ColorSuccess
        } elseif ($OutputString -match "Status:\s*❌") {
            $TestPassed = $false
            $FailedTests++
            Write-Host "  FAILED (Some tests failed)" -ForegroundColor $ColorError
        } else {
            # Check for errors in output by looking at the summary line
            # Match "Failed: X" where X > 0
            if ($OutputString -match "Failed:\s*[1-9]\d*") {
                $TestPassed = $false
                $FailedTests++
                Write-Host "  FAILED (Errors detected)" -ForegroundColor $ColorError
            } else {
                $TestPassed = $true
                $PassedTests++
                Write-Host "  PASSED" -ForegroundColor $ColorSuccess
            }
        }
    } else {
        $TestPassed = $false
        $FailedTests++
        Write-Host "  FAILED (Exit code: $ExitCode)" -ForegroundColor $ColorError
    }
    
    Write-Host "  Duration: $("{0:N2}" -f $Duration) seconds" -ForegroundColor $ColorInfo
    
    # Store result
    $TestResults += [PSCustomObject]@{
        Number = $TestNumber
        Name = $TestName
        Status = if($TestPassed){"PASSED"}else{"FAILED"}
        Duration = $Duration
        ExitCode = $ExitCode
    }
    
    # Show output if verbose or if failed
    if ($ShowOutput -or -not $TestPassed) {
        Write-Host ""
        Write-Host "  --- Test Output ---" -ForegroundColor $ColorInfo
        $Output | ForEach-Object {
            Write-Host "  $_" -ForegroundColor $ColorInfo
        }
        Write-Host "  --- End Output ---" -ForegroundColor $ColorInfo
    }
    
    Write-Host ""
    
    # Stop on error if requested
    if (-not $TestPassed -and $StopOnError) {
        Write-Host "Stopping test execution due to failure (StopOnError flag set)" -ForegroundColor $ColorWarning
        break
    }
    
    $TestNumber++
}

# End time
$EndTime = Get-Date
$TotalDuration = ($EndTime - $StartTime).TotalSeconds

# Print summary
Write-Host ""
Write-Host "=========================================" -ForegroundColor $ColorHeader
Write-Host "   TEST SUMMARY" -ForegroundColor $ColorHeader
Write-Host "=========================================" -ForegroundColor $ColorHeader
Write-Host ""
Write-Host "Total Tests Run: $TotalTests" -ForegroundColor $ColorInfo
Write-Host "Passed: $PassedTests" -ForegroundColor $ColorSuccess
Write-Host "Failed: $FailedTests" -ForegroundColor $ColorError
Write-Host "Success Rate: $("{0:N1}" -f (($PassedTests / $TotalTests) * 100))%" -ForegroundColor $(if($FailedTests -eq 0){$ColorSuccess}else{$ColorWarning})
Write-Host "Total Duration: $("{0:N2}" -f $TotalDuration) seconds" -ForegroundColor $ColorInfo
Write-Host ""

# Detailed results table
Write-Host "Detailed Results:" -ForegroundColor $ColorInfo
Write-Host ""
$TestResults | Format-Table -Property @(
    @{Label="Test"; Expression={$_.Number}; Width=4},
    @{Label="Name"; Expression={$_.Name}; Width=40},
    @{Label="Status"; Expression={$_.Status}; Width=10},
    @{Label="Duration"; Expression={"{0:N2}" -f $_.Duration}; Width=12}
) -AutoSize

# Final status
Write-Host ""
if ($FailedTests -eq 0) {
    Write-Host "=========================================" -ForegroundColor $ColorSuccess
    Write-Host "   ALL TESTS PASSED" -ForegroundColor $ColorSuccess
    Write-Host "=========================================" -ForegroundColor $ColorSuccess
    exit 0
} else {
    Write-Host "=========================================" -ForegroundColor $ColorError
    Write-Host "   SOME TESTS FAILED" -ForegroundColor $ColorError
    Write-Host "=========================================" -ForegroundColor $ColorError
    Write-Host ""
    Write-Host "Failed tests:" -ForegroundColor $ColorWarning
    $TestResults | Where-Object { $_.Status -eq "FAILED" } | ForEach-Object {
        Write-Host "  - $($_.Name)" -ForegroundColor $ColorError
    }
    exit 1
}
