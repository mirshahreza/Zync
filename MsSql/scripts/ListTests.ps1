# =============================================
# Quick Test List
# Shows all available test files
# =============================================

Write-Host ""
Write-Host "🧪 Available Zync Test Files:" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

$testDir = "c:\Workspace\Projects\Zync\MsSql\Test"
$testFiles = Get-ChildItem -Path $testDir -Filter "zync_test_*.sql" | Sort-Object Name

$count = 1
foreach ($file in $testFiles) {
    $packageName = $file.Name -replace "zync_test_", "" -replace ".sql", ""
    Write-Host "$count. " -NoNewline -ForegroundColor Yellow
    Write-Host "$($file.Name)" -NoNewline -ForegroundColor White
    Write-Host " ($packageName)" -ForegroundColor Gray
    $count++
}

Write-Host ""
Write-Host "Total test files: $($testFiles.Count)" -ForegroundColor Green
Write-Host ""
Write-Host "To run a specific test:" -ForegroundColor Cyan
Write-Host "  sqlcmd -S localhost -d YourDatabase -E -i `"$testDir\zync_test_<package>.sql`"" -ForegroundColor Gray
Write-Host ""
Write-Host "To run all tests:" -ForegroundColor Cyan
Write-Host "  .\RunAllTests.ps1 -ServerInstance localhost -Database YourDatabase" -ForegroundColor Gray
Write-Host ""
