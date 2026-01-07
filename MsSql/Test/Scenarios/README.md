# Zync Scenario Tests

[![Test Coverage](https://img.shields.io/badge/Scenarios-10%20Tests-blue.svg)](./)
[![Test Type](https://img.shields.io/badge/Type-Integration%20%26%20E2E-orange.svg)](./)

**Comprehensive scenario-based tests for Zync package manager lifecycle operations.**

## 📋 Overview

These scenario tests verify end-to-end workflows and edge cases in Zync package management. Unlike functional tests that verify individual object behavior, scenario tests simulate real-world usage patterns including:

- Fresh installations and bootstrapping
- Package updates and versioning
- Table schema evolution
- Removal and rollback operations
- Dependency management
- Error handling and recovery
- Complex multi-step operations

## 🎯 Test Categories

### 1. Fresh Installation (`zync_scenario_01_fresh_install.sql`)
Tests initial setup and first-time installation scenarios:
- **1.1:** Database with no Zync installed
- **1.2:** Database with Zync but no packages
- **1.3:** First package installation
- **1.4:** Installation verification
- **1.5:** Clean state validation

**Use Case:** Setting up Zync on a new database or fresh environment.

---

### 2. Update Operations (`zync_scenario_02_update.sql`)
Tests package update and evolution scenarios:
- **2.1:** Package with new objects added to repository
- **2.2:** Package with objects removed from repository
- **2.3:** Package with modified object definitions
- **2.4:** Manual objects created by user (not in package)
- **2.5:** Auto-update detection and execution

**Use Case:** Updating packages when new versions are released.

---

### 3. Table Operations (`zync_scenario_03_tables.sql`)
Tests table schema evolution and DDL operations:
- **3.1:** Adding new table to existing package
- **3.2:** Adding column to existing table
- **3.3:** Dropping column from existing table
- **3.4:** Changing column data type
- **3.5:** Adding Foreign Key constraints
- **3.6:** Adding Indexes
- **3.7:** Adding CHECK/UNIQUE/DEFAULT constraints
- **3.8:** Preserving data during schema changes

**Use Case:** Evolving database schema while maintaining data integrity.

---

### 4. Removal & Rollback (`zync_scenario_04_removal_rollback.sql`)
Tests package removal and version rollback:
- **4.1:** Removing single package
- **4.2:** Removing all packages (clean command)
- **4.3:** Rolling back to previous version
- **4.4:** Rollback with data preservation
- **4.5:** Removal with dependency checks

**Use Case:** Uninstalling packages or reverting problematic updates.

---

### 5. Dependencies (`zync_scenario_05_dependencies.sql`)
Tests package dependency management:
- **5.1:** Installing package with dependencies
- **5.2:** Installing packages in correct order
- **5.3:** Attempting to remove package with dependents
- **5.4:** Dependency chain resolution
- **5.5:** Circular dependency detection (if applicable)

**Use Case:** Managing packages that depend on each other (e.g., Base → Financial).

---

### 6. Error Handling (`zync_scenario_06_errors.sql`)
Tests error conditions and recovery:
- **6.1:** Installing non-existent package
- **6.2:** Package with syntax errors
- **6.3:** Network/Repository access failure (simulated)
- **6.4:** Insufficient permissions
- **6.5:** Ole Automation Procedures disabled
- **6.6:** Naming conflicts

**Use Case:** Validating error messages and graceful failure handling.

---

### 7. Combined Operations (`zync_scenario_07_combined_ops.sql`)
Tests complex multi-step workflows:
- **7.1:** Install → Update → Rollback → Reinstall chain
- **7.2:** Installing multiple packages simultaneously
- **7.3:** Concurrent session operations (if applicable)
- **7.4:** Clean and reinstall workflow
- **7.5:** Partial installation recovery

**Use Case:** Real-world workflows involving multiple operations.

---

### 8. Query & List Operations (`zync_scenario_08_query_list.sql`)
Tests information retrieval and listing:
- **8.1:** List all packages (`ls`)
- **8.2:** List with search filter (`ls DateTime`)
- **8.3:** List installed objects (`lo`)
- **8.4:** Version tracking queries
- **8.5:** Package status verification
- **8.6:** Object ownership validation

**Use Case:** Inspecting installed packages and tracking changes.

---

### 9. Base Package Specific (`zync_scenario_09_base_package.sql`)
Tests Base package-specific features:
- **9.1:** Installing Base with seed data
- **9.2:** Foreign Key relationships (BaseUsers ↔ BaseRoles)
- **9.3:** ActivityLog tracking
- **9.4:** CRUD operations on Base tables
- **9.5:** Seed data idempotency
- **9.6:** Default admin user and roles

**Use Case:** Validating Base package special requirements.

---

### 10. Performance & Scale (`zync_scenario_10_performance.sql`)
Tests performance and scalability:
- **10.1:** Package with 100+ objects
- **10.2:** Table with millions of rows
- **10.3:** Stored procedure with thousands of lines
- **10.4:** Installation performance benchmarks
- **10.5:** Update performance with large datasets

**Use Case:** Ensuring Zync performs well with large packages/data.

---

## 🚀 Running Scenario Tests

### Run All Scenarios

Using PowerShell:
```powershell
cd c:\Workspace\Projects\Zync\MsSql\scripts

# Run all scenario tests
.\RunAllTests.ps1 -TestPattern "Scenarios\*.sql"
```

### Run Individual Scenario

```powershell
# Using RunSingleTest.ps1
.\RunSingleTest.ps1 -TestName "Scenarios\zync_scenario_01_fresh_install"

# Using sqlcmd directly
sqlcmd -S localhost -d TestDatabase -E -i "..\Test\Scenarios\zync_scenario_01_fresh_install.sql"
```

### Run Specific Scenario Category

```bash
# Run only update scenarios
sqlcmd -S localhost -d TestDatabase -E -i "..\Test\Scenarios\zync_scenario_02_update.sql"
```

---

## 📊 Test Output Format

Each scenario test produces structured output:

```
=========================================
ZYNC SCENARIO XX: <Category Name>
=========================================
Test Date: 2026-01-06 10:30:00

----------------------------------------
Scenario X.Y: <Test Description>
----------------------------------------
✓ PASS: Step description
✗ FAIL: Step description - Reason
⚠ WARN: Warning message

========================================
TEST SUMMARY
========================================
Total Tests: 15
Passed: 14
Failed: 1
Warnings: 2
Duration: 1.23 seconds
Status: ❌ FAILED
========================================
```

---

## 🔧 Test Environment Requirements

### Prerequisites
- SQL Server 2016 or higher
- Ole Automation Procedures enabled
- Zync.sql installed (MsSql/Zync.sql)
- Appropriate permissions (CREATE, DROP, ALTER)

### Setup
```sql
-- Enable Ole Automation if needed
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ole Automation Procedures', 1;
RECONFIGURE;

-- Install Zync
-- Run MsSql/Zync.sql in your test database
```

### Cleanup
Each scenario test includes its own cleanup section, but you can manually clean:
```sql
EXEC [dbo].[Zync] 'clean';
```

---

## 📝 Test Execution Order

**Recommended execution order:**
1. Scenario 01 (Fresh Install) - Validates basic setup
2. Scenario 08 (Query/List) - Validates monitoring capabilities
3. Scenario 02 (Update) - Validates update mechanisms
4. Scenario 03 (Tables) - Validates schema evolution
5. Scenario 05 (Dependencies) - Validates package relationships
6. Scenario 04 (Removal/Rollback) - Validates cleanup
7. Scenario 07 (Combined Ops) - Validates complex workflows
8. Scenario 09 (Base Package) - Validates special package
9. Scenario 06 (Errors) - Validates error handling
10. Scenario 10 (Performance) - Validates scalability

---

## 🐛 Troubleshooting

### Common Issues

**Issue:** "Ole Automation Procedures not enabled"
```sql
-- Solution: Enable Ole Automation
EXEC sp_configure 'Ole Automation Procedures', 1;
RECONFIGURE;
```

**Issue:** "Zync procedure not found"
```sql
-- Solution: Install Zync first
-- Run MsSql/Zync.sql
```

**Issue:** "Package not found in repository"
```sql
-- Solution: Check repository configuration
EXEC [dbo].[Zync] 'ls'; -- Verify available packages
```

---

## 🎯 Test Philosophy

These scenario tests follow principles of:

- **Isolation:** Each scenario is self-contained
- **Idempotency:** Tests can run multiple times safely
- **Clarity:** Clear pass/fail criteria with descriptive messages
- **Realism:** Tests simulate actual usage patterns
- **Coverage:** All major features and edge cases covered

---

## 📈 Test Maintenance

### Adding New Scenarios

When adding new scenarios:
1. Follow naming convention: `zync_scenario_XX_description.sql`
2. Include comprehensive header with scenario list
3. Implement cleanup section
4. Add to this README with description
5. Update test count badge at top

### Updating Existing Scenarios

When modifying scenarios:
1. Maintain backward compatibility when possible
2. Update scenario description in header
3. Update this README if behavior changes
4. Run full test suite to verify no regressions

---

## 📚 Related Documentation

- **Functional Tests:** `../zync_test_*.sql` - Test individual object functionality
- **Integration Tests:** `../zync_test_comprehensive.sql` - Basic integration test
- **Debug Tools:** `../zync_debug_*.sql` - Diagnostic utilities
- **Main Documentation:** `../../README.md` - Project overview

---

## ✅ Success Criteria

A scenario test is considered **PASSED** when:
- All sub-scenarios pass without errors
- Database state is verified after each operation
- Expected objects exist/don't exist as designed
- Data integrity is maintained
- Cleanup completes successfully

---

**Last Updated:** 2026-01-06  
**Status:** ✅ Active Development  
**Maintainer:** Zync Development Team
