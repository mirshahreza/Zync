# How to Run Zync Scenario Tests

## 📋 Quick Summary

✅ **10 scenario test files created** (Total size: ~105 KB)  
✅ **RunScenarioTests.ps1 script created** for automated execution  
✅ **All tests ready to run** when SQL Server is available

---

## 🚀 Running Tests

### Option 1: Run All Scenario Tests (Recommended)

Using the automated script:

```powershell
cd c:\Workspace\Projects\Zync\MsSql\scripts

# Run all tests with default settings (.\SQL2022, ZyncTest)
.\RunScenarioTests.ps1

# Run with custom server and database
.\RunScenarioTests.ps1 -ServerInstance "localhost" -Database "MyTestDB"

# Run with SQL Server authentication
.\RunScenarioTests.ps1 -ServerInstance "localhost" -Database "MyTestDB" `
    -UseWindowsAuth:$false -Username "sa" -Password "YourPassword"

# Stop on first failure
.\RunScenarioTests.ps1 -StopOnError

# Show detailed output for all tests
.\RunScenarioTests.ps1 -ShowOutput
```

### Option 2: Run Individual Tests

Using sqlcmd directly:

```powershell
cd c:\Workspace\Projects\Zync\MsSql\Test\Scenarios

# Run a specific scenario
sqlcmd -S localhost -d TestDB -E -i zync_scenario_01_fresh_install.sql

# Run with SQL Server auth
sqlcmd -S localhost -d TestDB -U sa -P YourPassword -i zync_scenario_01_fresh_install.sql
```

### Option 3: Run Specific Tests in Sequence

```powershell
cd c:\Workspace\Projects\Zync\MsSql\Test\Scenarios

# Run first 3 tests
sqlcmd -S localhost -d TestDB -E -i zync_scenario_01_fresh_install.sql
sqlcmd -S localhost -d TestDB -E -i zync_scenario_02_update.sql
sqlcmd -S localhost -d TestDB -E -i zync_scenario_03_tables.sql
```

### Option 4: Run Tests from SSMS

1. Open SQL Server Management Studio (SSMS)
2. Connect to your SQL Server instance
3. Open any scenario test file from `MsSql\Test\Scenarios\`
4. Execute the script (F5 or Execute button)
5. Review results in Messages tab

---

## 📦 Test Files Overview

| # | Test File | Description | Size |
|---|-----------|-------------|------|
| 01 | zync_scenario_01_fresh_install.sql | Fresh installation tests | 10 KB |
| 02 | zync_scenario_02_update.sql | Package update operations | 12 KB |
| 03 | zync_scenario_03_tables.sql | Table schema evolution | 14 KB |
| 04 | zync_scenario_04_removal_rollback.sql | Removal & rollback | 10 KB |
| 05 | zync_scenario_05_dependencies.sql | Dependency management | 8 KB |
| 06 | zync_scenario_06_errors.sql | Error handling | 9 KB |
| 07 | zync_scenario_07_combined_ops.sql | Combined operations | 9 KB |
| 08 | zync_scenario_08_query_list.sql | Query & list operations | 10 KB |
| 09 | zync_scenario_09_base_package.sql | Base package features | 12 KB |
| 10 | zync_scenario_10_performance.sql | Performance & scale | 11 KB |

---

## 🔧 Prerequisites

Before running tests, ensure:

1. **SQL Server is running**
   - Check SQL Server service status
   - Verify instance name (e.g., `.\SQL2022`, `localhost`, etc.)

2. **Database exists**
   - Create test database if needed: `CREATE DATABASE ZyncTest`
   - Or use existing database like `master`

3. **Zync is installed**
   - Run `MsSql\Zync.sql` first to install Zync core
   - Each test will verify Zync is present

4. **Ole Automation enabled** (for package installation)
   ```sql
   EXEC sp_configure 'show advanced options', 1;
   RECONFIGURE;
   EXEC sp_configure 'Ole Automation Procedures', 1;
   RECONFIGURE;
   ```

5. **Permissions**
   - User needs CREATE/DROP/ALTER permissions
   - DBO or db_owner role recommended for testing

---

## 📊 Expected Test Output

Each test produces structured output:

```
=========================================
ZYNC SCENARIO XX: Test Name
=========================================
Test Date: 2026-01-06 18:00:00

----------------------------------------
Scenario X.Y: Test Description
----------------------------------------
✓ PASS: Test step description
✗ FAIL: Test step description - Reason
⚠ WARN: Warning message

========================================
TEST SUMMARY
========================================
Total Tests: 15
Passed: 14
Failed: 1
Warnings: 2
Duration: 1.23 seconds
Status: ❌ SOME TESTS FAILED
========================================
```

---

## 🐛 Troubleshooting

### SQL Server Not Found

```
Error: Could not connect to SQL Server
```

**Solutions:**
- Check SQL Server service is running
- Verify server name: `.\SQL2022`, `localhost`, `(localdb)\MSSQLLocalDB`, etc.
- Use SQL Server Configuration Manager to check instance names
- Test connection: `sqlcmd -S YourServer -Q "SELECT @@VERSION"`

### Database Does Not Exist

```
Error: Cannot open database requested by login
```

**Solution:**
```sql
-- Create test database
CREATE DATABASE ZyncTest;
GO

-- Or use existing database
USE master;
GO
```

### Permission Denied

```
Error: CREATE PROCEDURE permission denied
```

**Solution:**
```sql
-- Grant permissions to test user
USE ZyncTest;
GO
ALTER ROLE db_owner ADD MEMBER [YourUsername];
GO
```

### Zync Not Installed

```
PREREQUISITE FAILED: Zync not installed
```

**Solution:**
```powershell
# Install Zync first
sqlcmd -S localhost -d TestDB -E -i "c:\Workspace\Projects\Zync\MsSql\Zync.sql"
```

### Ole Automation Disabled

```
WARN: Ole Automation Procedures not enabled
```

**Solution:**
```sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ole Automation Procedures', 1;
RECONFIGURE;
```

---

## 📈 Recommended Test Workflow

### For Development

```powershell
# 1. Run specific scenario during development
.\RunScenarioTests.ps1 -ServerInstance "localhost" -Database "DevDB" `
    -StopOnError

# 2. If test fails, run individually with output
sqlcmd -S localhost -d DevDB -E -i "Test\Scenarios\zync_scenario_01_fresh_install.sql"

# 3. Fix issues and re-run
```

### For CI/CD

```powershell
# Run all tests and capture exit code
.\RunScenarioTests.ps1 -ServerInstance $Env:SQL_SERVER -Database $Env:TEST_DB
if ($LASTEXITCODE -ne 0) {
    Write-Error "Scenario tests failed"
    exit 1
}
```

### For QA/Testing

```powershell
# Run all tests with detailed output
.\RunScenarioTests.ps1 -ShowOutput > TestResults.log

# Review results
Get-Content TestResults.log | Select-String "FAIL|ERROR|WARN"
```

---

## 📞 Next Steps

1. **Start SQL Server** if not running
2. **Create test database** or use existing one
3. **Install Zync core** (`MsSql\Zync.sql`)
4. **Run scenario tests** using `RunScenarioTests.ps1`
5. **Review results** and fix any issues

---

## 📚 Additional Resources

- [Test/Scenarios/README.md](../Test/Scenarios/README.md) - Detailed scenario documentation
- [Test/README.md](../Test/README.md) - Full test suite documentation
- [MsSql/README.md](../README.md) - Zync project overview

---

**Created:** 2026-01-06  
**Status:** ✅ Ready to Run  
**Total Tests:** 10 scenarios (42+ sub-scenarios)
