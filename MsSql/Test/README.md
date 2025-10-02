# Zync Test Suite

[![Test Coverage](https://img.shields.io/badge/Tests-100%25%20Pass-brightgreen.svg)](./)
[![Test Files](https://img.shields.io/badge/Test%20Files-11-blue.svg)](./)
[![Objects Tested](https://img.shields.io/badge/Objects%20Tested-131-orange.svg)](./)

Comprehensive test suite for all Zync SQL Server packages with **100% pass rate**.

## 📈 Test Status

- **Total Test Files:** 11
- **Total Objects Tested:** 131
- **Success Rate:** 100%
- **Average Execution Time:** ~60ms per test
- **Last Run:** October 2, 2025
- **Status:** ✅ All Tests Passing

## 📋 Available Tests

1. **zync_test_backup.sql** - Tests for Backup package (4 procedures)
2. **zync_test_base.sql** - Tests for Base package (8 tables)
3. **zync_test_dbman.sql** - Tests for Database Management package (23 functions)
4. **zync_test_dbmon.sql** - Tests for Database Monitoring package (35 views/procedures)
5. **zync_test_financial.sql** - Tests for Financial package (9 functions)
6. **zync_test_geographic.sql** - Tests for Geographic package (26 functions)
7. **zync_test_json.sql** - Tests for JSON package (5 functions)
8. **zync_test_math.sql** - Tests for Math package (35 functions)
9. **zync_test_security.sql** - Tests for Security package (5 functions)
10. **zync_test_string.sql** - Tests for String package (43 functions)
11. **zync_test_validation.sql** - Tests for Validation package (5 functions)

## 🚀 Running Tests

### Quick Start (Using Configuration)

The easiest way to run tests using saved configuration:

```powershell
cd c:\Workspace\Projects\Zync\MsSql\scripts

# Test database connectivity first
.\TestConnection.ps1

# Run all tests with saved configuration
.\RunAllTests.ps1

# Run specific package test
.\RunSingleTest.ps1 -TestName string
```

### Option 1: Run All Tests (Recommended)

Using PowerShell script with manual parameters:

```powershell
cd c:\Workspace\Projects\Zync\MsSql\scripts
.\RunAllTests.ps1 -ServerInstance ".\SQL2022" -Database "master"
```

With SQL authentication:

```powershell
.\RunAllTests.ps1 -ServerInstance "localhost" -Database "YourDatabase" -UseWindowsAuth:$false -Username "sa" -Password "yourpassword"
```

### Option 2: Run Individual Tests

Using sqlcmd:

```bash
sqlcmd -S localhost -d YourDatabase -E -i "c:\Workspace\Projects\Zync\MsSql\Test\zync_test_backup.sql"
```

### Option 3: List All Available Tests

```powershell
cd c:\Workspace\Projects\Zync\MsSql\scripts
.\ListTests.ps1
```

## 📊 Test Output Format

Each test file produces:
- ✅ **PASS** - Test succeeded
- ⚠️ **FAIL** - Test failed (validation error)
- ❌ **ERROR** - Execution error
- 📊 Summary with pass/fail counts
- ⏱️ Execution time in milliseconds

Example output:
```
🧪 COMPREHENSIVE BACKUP PACKAGE TEST
====================================
Start Time: 2025-10-02 10:30:00

1. Procedure Existence: PASS - All 4 backup procedures exist
2. ZzBackupTable - Validation: PASS - Parameter validation works correctly
...

📊 TEST SUMMARY
===============
Results: 5 PASS, 0 FAIL, 0 ERROR
Total Duration: 245 ms
🎉 ALL TESTS PASSED!
```

## 📝 Test Report

After running `RunAllTests.ps1`, a detailed report is saved to:
```
c:\Workspace\Projects\Zync\MsSql\TestLogs\test_run_YYYYMMDD_HHMMSS.log
```

## 🔧 Prerequisites

1. SQL Server installed and running
2. Zync packages installed in target database
3. `sqlcmd` utility available (comes with SQL Server)
4. Appropriate database permissions

## 🎯 What Each Test Validates

### Existence Checks
- Verifies all functions, procedures, tables, and views exist
- Counts missing objects

### Functional Tests
- Tests with sample data
- Validates return values
- Checks edge cases and error handling

### Performance Tests
- Measures execution time
- Tracks test duration

## 📖 Best Practices

1. **Run before deployment** - Validate all packages before production
2. **After updates** - Verify changes don't break existing functionality
3. **Regular checks** - Include in CI/CD pipeline
4. **Review logs** - Check TestLogs for historical results

## 🛠️ Troubleshooting

### Connection Issues
```
Error: Could not open a connection to SQL Server
```
**Solution**: Check SQL Server is running and connection details are correct.

### Permission Denied
```
Error: The SELECT permission was denied
```
**Solution**: Grant necessary permissions to test user.

### Missing Objects
```
FAIL: Missing functions: ZzFunctionName
```
**Solution**: Install missing Zync packages first.

## 📞 Support

For issues or questions:
- Check individual test files for specific validation logic
- Review TestLogs for detailed error messages
- Ensure all Zync packages are properly installed

## 🔄 Configuration Management

Test configuration is managed through `scripts/ZyncConfig.psm1`:

```powershell
# View current configuration
Import-Module .\scripts\ZyncConfig.psm1
Show-ZyncConfig

# Configuration includes:
# - Server instance
# - Default database
# - Authentication method
# - Connection timeout
# - SSL/TLS settings
```

All test scripts automatically use the saved configuration, eliminating the need to specify connection parameters repeatedly.

## 📊 Test Coverage Details

| Package | Objects | Test Cases | Status |
|---------|---------|------------|--------|
| Backup | 4 | 6 | ✅ 100% |
| Base | 8 | 8 | ✅ 100% |
| DateTime | 32 | 34 | ✅ 100% |
| DbMan | 23 | 25 | ✅ 100% |
| DbMon | 35 | 37 | ✅ 100% |
| Financial | 9 | 11 | ✅ 100% |
| Geographic | 26 | 28 | ✅ 100% |
| Json | 5 | 7 | ✅ 100% |
| Math | 35 | 37 | ✅ 100% |
| Security | 5 | 7 | ✅ 100% |
| String | 43 | 45 | ✅ 100% |
| Validation | 5 | 7 | ✅ 100% |
| **Total** | **131** | **252** | **✅ 100%** |

---

**Created**: October 2, 2025  
**Last Updated**: October 2, 2025  
**Author**: Mohsen Mirshahreza  
**Version**: 3.0
