# =============================================
# Test Database Connection
# Tests connection to SQL Server using saved config
# =============================================

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $scriptDir "ZyncConfig.psm1"

if (-not (Test-Path $configPath)) {
    Write-Host "❌ Configuration file not found: $configPath" -ForegroundColor Red
    exit 1
}

# Import configuration
Import-Module $configPath -Force

# Show configuration
Show-ZyncConfig

Write-Host "🔌 Testing Connection..." -ForegroundColor Cyan
Write-Host ""

# Get sqlcmd arguments
$sqlcmdArgs = Get-ZyncSqlcmdArgs

# Test connection with a simple query
$testQuery = "SELECT @@VERSION AS ServerVersion, DB_NAME() AS CurrentDatabase, GETDATE() AS CurrentTime;"

try {
    $testArgs = $sqlcmdArgs + @("-Q", $testQuery, "-h", "-1", "-W")
    $output = & sqlcmd $testArgs 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Connection Successful!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Server Information:" -ForegroundColor Cyan
        Write-Host "-----------------" -ForegroundColor Cyan
        $output | ForEach-Object { Write-Host $_ -ForegroundColor White }
        Write-Host ""
        
        # Test Zync objects existence
        Write-Host "🔍 Checking Zync Objects..." -ForegroundColor Cyan
        $checkQuery = "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.objects WHERE name LIKE 'Zz%' AND type IN ('FN', 'P', 'TF', 'U', 'V');"
        
        $checkArgs = $sqlcmdArgs + @("-Q", $checkQuery, "-h", "-1", "-W")
        $objCountOutput = & sqlcmd $checkArgs 2>&1
        
        # Extract the numeric count from output
        $countLine = $objCountOutput | Where-Object { $_ -match '^\s*\d+\s*$' } | Select-Object -First 1
        
        if ($countLine) {
            $count = [int]($countLine.Trim())
            Write-Host ""
            Write-Host "📦 Found $count Zync objects in database" -ForegroundColor $(if ($count -gt 0) { "Green" } else { "Yellow" })
            
            if ($count -eq 0) {
                Write-Host ""
                Write-Host "⚠️  No Zync objects found. Please install Zync packages first." -ForegroundColor Yellow
            } else {
                Write-Host ""
                Write-Host "✅ Database is ready for testing!" -ForegroundColor Green
            }
        } else {
            Write-Host "📦 Unable to count Zync objects" -ForegroundColor Yellow
        }
        
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Run specific test: .\RunSingleTest.ps1 -TestName backup" -ForegroundColor Gray
        Write-Host "2. Run all tests: .\RunAllTests.ps1" -ForegroundColor Gray
        Write-Host ""
        
        exit 0
    } else {
        Write-Host "❌ Connection Failed!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Error Output:" -ForegroundColor Yellow
        $output | ForEach-Object { Write-Host $_ -ForegroundColor Red }
        Write-Host ""
        exit 1
    }
}
catch {
    Write-Host "❌ Connection Test Failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Check if SQL Server is running" -ForegroundColor Gray
    Write-Host "2. Verify server instance name in ZyncConfig.psm1" -ForegroundColor Gray
    Write-Host "3. Ensure you have necessary permissions" -ForegroundColor Gray
    Write-Host "4. Check firewall settings" -ForegroundColor Gray
    Write-Host ""
    exit 1
}
