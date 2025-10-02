# =============================================
# Install Local Packages
# Installs all Zync packages from local directory
# =============================================

param(
    [string]$Database = "master"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $scriptDir "ZyncConfig.psm1"

# Import configuration
if (Test-Path $configPath) {
    Import-Module $configPath -Force
    if (-not $Database) { $Database = $script:ZyncConfig.Database }
}

Write-Host "🔧 Installing Zync Packages" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

# Get package directory
$packagesDir = Join-Path (Split-Path -Parent $scriptDir) "Packages"

if (-not (Test-Path $packagesDir)) {
    Write-Host "❌ Packages directory not found: $packagesDir" -ForegroundColor Red
    exit 1
}

# Get all package directories
$packages = Get-ChildItem -Path $packagesDir -Directory | Sort-Object Name

Write-Host "📦 Found $($packages.Count) packages to install" -ForegroundColor Green
Write-Host ""

$installedCount = 0
$failedCount = 0
$skippedCount = 0

# Get sqlcmd arguments
if (Get-Command Get-ZyncSqlcmdArgs -ErrorAction SilentlyContinue) {
    $sqlcmdArgs = Get-ZyncSqlcmdArgs -Database $Database
} else {
    $sqlcmdArgs = @("-S", ".\SQL2022", "-d", $Database, "-E", "-C")
}

foreach ($package in $packages) {
    $packageName = $package.Name
    $packageIndexFile = Join-Path $package.FullName ".sql"
    
    if (-not (Test-Path $packageIndexFile)) {
        Write-Host "  ⚠️  Skipped: $packageName (no .sql index file)" -ForegroundColor Yellow
        $skippedCount++
        continue
    }
    
    Write-Host "📥 Installing: $packageName" -ForegroundColor Cyan
    
    try {
        # Execute the package index file
        $installArgs = $sqlcmdArgs + @("-i", $packageIndexFile)
        $output = & sqlcmd $installArgs 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Installed successfully" -ForegroundColor Green
            $installedCount++
        } else {
            Write-Host "  ❌ Installation failed (Exit code: $LASTEXITCODE)" -ForegroundColor Red
            if ($output) {
                $output | ForEach-Object { Write-Host "     $_" -ForegroundColor Red }
            }
            $failedCount++
        }
    }
    catch {
        Write-Host "  ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        $failedCount++
    }
    
    Write-Host ""
}

Write-Host ""
Write-Host "📊 Installation Summary" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan
Write-Host "  ✅ Installed:  $installedCount" -ForegroundColor Green
Write-Host "  ❌ Failed:     $failedCount" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Gray" })
Write-Host "  ⚠️  Skipped:   $skippedCount" -ForegroundColor $(if ($skippedCount -gt 0) { "Yellow" } else { "Gray" })
Write-Host "  📦 Total:      $($packages.Count)" -ForegroundColor Cyan
Write-Host ""

# Verify installation by counting objects
$countQuery = "SELECT COUNT(*) FROM sys.objects WHERE name LIKE 'Zz%' AND type IN ('FN', 'P', 'TF', 'U', 'V');"
$countArgs = $sqlcmdArgs + @("-Q", $countQuery, "-h", "-1", "-W")
$objCountOutput = & sqlcmd $countArgs 2>&1

$countLine = $objCountOutput | Where-Object { $_ -match '^\s*\d+\s*$' } | Select-Object -First 1
if ($countLine) {
    $count = [int]($countLine.Trim())
    Write-Host "🔍 Verification:" -ForegroundColor Cyan
    Write-Host "   Found $count Zync objects in database" -ForegroundColor Green
    Write-Host ""
}

if ($failedCount -eq 0 -and $installedCount -gt 0) {
    Write-Host "✅ All packages installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Run tests: .\RunAllTests.ps1" -ForegroundColor Gray
    Write-Host "  2. Run specific test: .\RunSingleTest.ps1 -TestName <name>" -ForegroundColor Gray
} elseif ($failedCount -gt 0) {
    Write-Host "⚠️  Installation completed with errors" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "⚠️  No packages were installed" -ForegroundColor Yellow
    exit 1
}
