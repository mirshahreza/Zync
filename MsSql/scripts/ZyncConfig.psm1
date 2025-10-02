# =============================================
# Zync Database Configuration
# This file stores database connection settings
# =============================================

# SQL Server Connection Settings
$script:ZyncConfig = @{
    ServerInstance = ".\SQL2022"
    IntegratedSecurity = $true
    Database = "master"  # Default database, can be changed
    ConnectTimeout = 30
    CommandTimeout = 0
    Encrypt = $true
    TrustServerCertificate = $true
    PacketSize = 4096
    ApplicationName = "Zync Test Suite"
    MultipleActiveResultSets = $false
    Pooling = $false
    PersistSecurityInfo = $false
}

# Build Connection String
function Get-ZyncConnectionString {
    param(
        [string]$Database = $script:ZyncConfig.Database
    )
    
    $connString = "Data Source=$($script:ZyncConfig.ServerInstance);"
    
    if ($script:ZyncConfig.IntegratedSecurity) {
        $connString += "Integrated Security=True;"
    } else {
        $connString += "User Id=$($script:ZyncConfig.Username);Password=$($script:ZyncConfig.Password);"
    }
    
    $connString += "Initial Catalog=$Database;"
    $connString += "Persist Security Info=$($script:ZyncConfig.PersistSecurityInfo.ToString());"
    $connString += "Pooling=$($script:ZyncConfig.Pooling.ToString());"
    $connString += "Multiple Active Result Sets=$($script:ZyncConfig.MultipleActiveResultSets.ToString());"
    $connString += "Connect Timeout=$($script:ZyncConfig.ConnectTimeout);"
    $connString += "Encrypt=$($script:ZyncConfig.Encrypt.ToString());"
    $connString += "TrustServerCertificate=$($script:ZyncConfig.TrustServerCertificate.ToString());"
    $connString += "Packet Size=$($script:ZyncConfig.PacketSize);"
    $connString += "Application Name=`"$($script:ZyncConfig.ApplicationName)`";"
    
    return $connString
}

# Build sqlcmd Arguments
function Get-ZyncSqlcmdArgs {
    param(
        [string]$Database = $script:ZyncConfig.Database
    )
    
    $sqlcmdArgs = @(
        "-S", $script:ZyncConfig.ServerInstance,
        "-d", $Database
    )
    
    if ($script:ZyncConfig.IntegratedSecurity) {
        $sqlcmdArgs += "-E"
    } else {
        $sqlcmdArgs += @("-U", $script:ZyncConfig.Username, "-P", $script:ZyncConfig.Password)
    }
    
    # Additional options
    $sqlcmdArgs += @(
        "-l", $script:ZyncConfig.ConnectTimeout,
        "-t", $script:ZyncConfig.CommandTimeout
    )
    
    # Trust server certificate (for SQL Server 2022+)
    if ($script:ZyncConfig.TrustServerCertificate) {
        $sqlcmdArgs += "-C"
    }
    
    return $sqlcmdArgs
}

# Display current configuration
function Show-ZyncConfig {
    Write-Host ""
    Write-Host "🔧 Zync Database Configuration" -ForegroundColor Cyan
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Server Instance:      $($script:ZyncConfig.ServerInstance)" -ForegroundColor White
    Write-Host "Default Database:     $($script:ZyncConfig.Database)" -ForegroundColor White
    Write-Host "Authentication:       $(if ($script:ZyncConfig.IntegratedSecurity) { 'Windows Authentication' } else { 'SQL Authentication' })" -ForegroundColor White
    Write-Host "Encrypt:              $($script:ZyncConfig.Encrypt)" -ForegroundColor White
    Write-Host "Trust Certificate:    $($script:ZyncConfig.TrustServerCertificate)" -ForegroundColor White
    Write-Host "Connect Timeout:      $($script:ZyncConfig.ConnectTimeout)s" -ForegroundColor White
    Write-Host "Command Timeout:      $($script:ZyncConfig.CommandTimeout)s" -ForegroundColor White
    Write-Host ""
}

# Export functions and config
Export-ModuleMember -Variable ZyncConfig
Export-ModuleMember -Function Get-ZyncConnectionString, Get-ZyncSqlcmdArgs, Show-ZyncConfig
