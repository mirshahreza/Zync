# =============================================
# Validate Test Files Structure
# Checks if all test files are properly formatted
# =============================================

Write-Host ""
Write-Host "🔍 Validating Zync Test Files..." -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

$testDir = "c:\Workspace\Projects\Zync\MsSql\Test"

# Our new test files
$expectedTests = @(
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

$validationResults = @()
$allValid = $true

foreach ($testFile in $expectedTests) {
    $fullPath = Join-Path $testDir $testFile
    $packageName = $testFile -replace "zync_test_", "" -replace ".sql", ""
    
    Write-Host "Checking: $testFile... " -NoNewline
    
    if (-not (Test-Path $fullPath)) {
        Write-Host "❌ NOT FOUND" -ForegroundColor Red
        $validationResults += [PSCustomObject]@{
            Package = $packageName
            File = $testFile
            Status = "Missing"
            Size = "N/A"
            Lines = "N/A"
        }
        $allValid = $false
        continue
    }
    
    # Get file info
    $fileInfo = Get-Item $fullPath
    $content = Get-Content $fullPath -Raw
    $lineCount = (Get-Content $fullPath | Measure-Object -Line).Lines
    
    # Check for required elements
    $hasTestResults = $content -match "@TestResults"
    $hasTestName = $content -match "@TestName"
    $hasPrint = $content -match "PRINT"
    $hasSummary = $content -match "TEST SUMMARY"
    
    if ($hasTestResults -and $hasTestName -and $hasPrint -and $hasSummary) {
        Write-Host "✅ VALID" -ForegroundColor Green
        $validationResults += [PSCustomObject]@{
            Package = $packageName
            File = $testFile
            Status = "Valid"
            Size = "$([math]::Round($fileInfo.Length / 1KB, 1)) KB"
            Lines = $lineCount
        }
    } else {
        Write-Host "⚠️  INCOMPLETE" -ForegroundColor Yellow
        $validationResults += [PSCustomObject]@{
            Package = $packageName
            File = $testFile
            Status = "Incomplete"
            Size = "$([math]::Round($fileInfo.Length / 1KB, 1)) KB"
            Lines = $lineCount
        }
        $allValid = $false
    }
}

Write-Host ""
Write-Host "📊 VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host ""

$validationResults | Format-Table -AutoSize

$validCount = ($validationResults | Where-Object { $_.Status -eq "Valid" }).Count
$totalCount = $validationResults.Count

Write-Host ""
Write-Host "Total Tests:   $totalCount" -ForegroundColor White
Write-Host "✅ Valid:      $validCount" -ForegroundColor Green
Write-Host "⚠️  Issues:     $($totalCount - $validCount)" -ForegroundColor $(if ($validCount -eq $totalCount) { "Green" } else { "Yellow" })
Write-Host ""

if ($allValid) {
    Write-Host "🎉 All test files are valid and ready to run!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Ensure SQL Server is running" -ForegroundColor Gray
    Write-Host "2. Install Zync packages in your database" -ForegroundColor Gray
    Write-Host "3. Run: .\RunAllTests.ps1 -ServerInstance localhost -Database YourDatabase" -ForegroundColor Gray
} else {
    Write-Host "⚠️  Some test files need attention" -ForegroundColor Yellow
}

Write-Host ""
