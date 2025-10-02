# 🗄️ Zync for SQL Server

[![SQL Server](https://img.shields.io/badge/SQL%20Server-Supported-blue.svg)](https://www.microsoft.com/en-us/sql-server/)
[![Test Coverage](https://img.shields.io/badge/Tests-100%25%20Pass-brightgreen.svg)](Test/)
[![Objects](https://img.shields.io/badge/Objects-131-blue.svg)](Packages/)
[![Packages](https://img.shields.io/badge/Packages-12-orange.svg)](Packages/)

Complete SQL Server implementation of Zync database package manager. Install and manage database objects with automatic dependency resolution and comprehensive test coverage.

## 🚀 Quick Start

### 1. Setup Database

Run the `Zync.sql` script to initialize the package management system:

```powershell
# Initialize Zync core (run once)
sqlcmd -S .\SQL2022 -d master -E -C -i "Zync.sql"
```

Or execute directly in SQL Server Management Studio (SSMS).

### 2. Install Packages (Automated)

Use PowerShell scripts for automated installation and testing:

```powershell
# Navigate to scripts directory
cd MsSql\scripts

# Test database connection
.\TestConnection.ps1

# Install all packages at once
.\InstallLocalPackages.ps1

# Run comprehensive test suite
.\RunAllTests.ps1

# Run specific package test
.\RunSingleTest.ps1 -TestName string
```

### 3. Explore Commands

View help and available commands:

```sql
EXEC dbo.Zync '?'
```

By default, Zync fetches from:

```
https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/
```

You can override the repository/branch by passing it as the second parameter, for example:

```sql
EXEC dbo.Zync 'i String', 'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';
```

### 3. Deploy Packages or Scripts

Install a complete package (e.g., database utilities):

```sql
EXEC dbo.Zync 'i DbMan'
EXEC dbo.Zync 'i DbMon'
```

Install a specific script from a package:

```sql
EXEC dbo.Zync 'i String/ZzSplitString.sql'
```

Install all available packages listed by the index (Packages/.sql):

```sql
EXEC dbo.Zync 'i'
```

## 📚 Available Packages

### � Backup (4 objects)
Database backup and restore utilities:
- Table backup creation
- Backup verification
- Old backup cleanup
- Backup script generation

```sql
EXEC dbo.Zync 'i Backup'
```

### 🏗️ Base (8 objects)
Foundation tables for common application needs:
- BaseInfo, BasePerson, BaseUser
- BaseRole, BaseUserRole
- BaseActivityLog, BaseUserAttribute
- Role-based permissions system

```sql
EXEC dbo.Zync 'i Base'
```

### 🔧 DbMan (23 objects)
Database management utilities:
- Table and column management (create, alter, drop)
- Foreign key management  
- Object existence checking
- Dependency analysis
- Schema exploration tools

```sql
EXEC dbo.Zync 'i DbMan'
```

### 📊 DbMon (35 objects)
Database monitoring and diagnostics:
- Performance monitoring views
- System health checks
- Index analysis
- Query statistics
- Session monitoring

```sql
EXEC dbo.Zync 'i DbMon'
```

### � DateTime (32 objects)
Comprehensive date and time utilities:
- Hijri, Shamsi, and Lunar converters
- Date formatting and validation
- Start/end of period calculations
- Working day and business day calculations
- Holiday checking and quarter functions
- Time zone conversion

```sql
EXEC dbo.Zync 'i DateTime'
```

### 💰 Financial (9 objects)
Financial calculations and utilities:
- Currency conversion
- Interest calculations
- Loan amortization
- Tax calculations
- Financial formatting

```sql
EXEC dbo.Zync 'i Financial'
```

### 🌍 Geographic (26 objects)
Geographic calculations and utilities:
- Distance calculations (Haversine formula)
- Coordinate conversions
- Geographic point operations
- Area calculations
- Bearing and direction

```sql
EXEC dbo.Zync 'i Geographic'
```

### � Json (5 objects)
JSON manipulation and processing:
- JSON parsing and validation
- JSON path queries
- JSON transformation
- JSON array operations

```sql
EXEC dbo.Zync 'i Json'
```

### 🔢 Math (35 objects)
Mathematical functions and utilities:
- Advanced calculations (factorial, fibonacci)
- Statistical functions
- Unit conversions
- Number formatting (KB, MB, GB)
- Mathematical constants

```sql
EXEC dbo.Zync 'i Math'
```

### � Security (5 objects)
Security and encryption utilities:
- Hashing functions (MD5, SHA)
- Password encryption
- Data masking
- Token generation
- Secure random generation

```sql
EXEC dbo.Zync 'i Security'
```

### 🔤 String (43 objects)
Comprehensive string manipulation:
- String splitting and trimming
- Character and word counting
- Text formatting (camelCase, snake_case, slugify)
- Persian text normalization
- Base64 encoding/decoding
- URL encoding/decoding
- Email and text validation

```sql
EXEC dbo.Zync 'i String'
```

### ✅ Validation (5 objects)
Data validation functions:
- Email validation
- URL validation
- Credit card validation
- Iranian National ID validation
- IP address validation

```sql
EXEC dbo.Zync 'i Validation'
```

## 🏗️ Project Structure

```
MsSql/
├── README.md                    # This file
├── Zync.sql                     # Core package manager (v3.0)
├── Packages/                    # 12 packages with 131 objects
│   ├── Backup/                  # 4 backup utilities
│   ├── Base/                    # 8 foundation tables
│   ├── DateTime/                # 32 date/time functions
│   ├── DbMan/                   # 23 database management tools
│   ├── DbMon/                   # 35 monitoring utilities
│   ├── Financial/               # 9 financial calculations
│   ├── Geographic/              # 26 geographic functions
│   ├── Json/                    # 5 JSON utilities
│   ├── Math/                    # 35 mathematical functions
│   ├── Security/                # 5 security utilities
│   ├── String/                  # 43 string operations
│   └── Validation/              # 5 validation functions
├── scripts/                     # PowerShell automation
│   ├── TestConnection.ps1       # Test database connectivity
│   ├── InstallLocalPackages.ps1 # Install all packages
│   ├── RunAllTests.ps1          # Run comprehensive test suite
│   ├── RunSingleTest.ps1        # Run individual package test
│   ├── ListTests.ps1            # List available tests
│   ├── ValidateTests.ps1        # Validate test file structure
│   ├── ZyncConfig.psm1          # Configuration module
│   └── GenerateZyncPackageFromDb.ps1  # Generate package from DB
├── Test/                        # Comprehensive test suite
│   ├── zync_test_backup.sql     # Backup package tests
│   ├── zync_test_base.sql       # Base package tests
│   ├── zync_test_datetime.sql   # DateTime tests (legacy)
│   ├── zync_test_dbman.sql      # DbMan package tests
│   ├── zync_test_dbmon.sql      # DbMon package tests
│   ├── zync_test_financial.sql  # Financial package tests
│   ├── zync_test_geographic.sql # Geographic package tests
│   ├── zync_test_json.sql       # Json package tests
│   ├── zync_test_math.sql       # Math package tests
│   ├── zync_test_security.sql   # Security package tests
│   ├── zync_test_string.sql     # String package tests
│   ├── zync_test_validation.sql # Validation package tests
│   └── README.md                # Test documentation
├── TestLogs/                    # Test execution logs
│   ├── test_run_*.log           # Timestamped test reports
│   └── EXECUTION_SUMMARY.md     # Latest execution summary
└── Doc/                         # Documentation
    ├── ARTICLE_EN.md            # English article
    ├── ARTICLE_FA.md            # Persian article
    ├── CONTRIBUTING_EN.md       # English contribution guide
    └── CONTRIBUTING_FA.md       # Persian contribution guide
```

## 📖 Usage Examples

### Listing and Searching (ls)

The `ls` command lists available packages and their contents. It supports a simple search filter.

Behavior:
- `ls` lists all packages and their scripts (names only; fast overview from Packages/.sql).
- `ls <package>` lists scripts inside a package with per-script descriptions.
- `ls ?term` searches across all packages (case-insensitive). Use `%` or `*` as wildcard.
- `ls <package> ?term` searches inside a package and matches on filename or description.

Examples:
```sql
-- Global listing (names only)
EXEC dbo.Zync 'ls'

-- List DateTime package with descriptions
EXEC dbo.Zync 'ls DateTime'

-- Search everywhere for "week" (e.g., WeekOfYear)
EXEC dbo.Zync 'ls ?week'

-- Search inside DbMon for items matching agent%status
EXEC dbo.Zync 'ls DbMon ?agent%status'

-- You can also use * as wildcard
EXEC dbo.Zync 'ls DateTime ?start*of'
```

### Deploy Specific Functionality

```sql
-- Install string splitting function
EXEC dbo.Zync 'i String/ZzSplitString.sql'

-- Install table creation utilities
EXEC dbo.Zync 'i DbMan/ZzCreateTableGuid.sql'
```

### Deploy Complete Solutions

```sql
-- Install all string utilities
EXEC dbo.Zync 'i String'

-- Install everything
EXEC dbo.Zync 'i'
```

### Maintenance

```sql
-- List all Zync-managed objects (names start with Zz)
EXEC dbo.Zync 'lo'

-- Remove a package or a specific script
EXEC dbo.Zync 'rm String'
EXEC dbo.Zync 'rm DbMan/ZzCreateTableGuid.sql'

-- Roll back a package to its previous version
EXEC dbo.Zync 'rb String'

-- Clean ALL Zync-managed objects and tracking data
EXEC dbo.Zync 'clean'
```

## 🧪 Testing

Zync includes a comprehensive test suite with **100% pass rate** covering all 131 database objects.

### Automated Testing

```powershell
# Test database connectivity
.\scripts\TestConnection.ps1

# Run all package tests (recommended)
.\scripts\RunAllTests.ps1

# Run specific package test
.\scripts\RunSingleTest.ps1 -TestName string
.\scripts\RunSingleTest.ps1 -TestName math
.\scripts\RunSingleTest.ps1 -TestName datetime

# List available tests
.\scripts\ListTests.ps1

# Validate test file structure
.\scripts\ValidateTests.ps1
```

### Test Coverage

Each package has dedicated tests covering:
- ✅ Object existence verification
- ✅ Functional tests with real data
- ✅ Edge case handling
- ✅ Error handling
- ✅ Performance validation

**Test Results Summary:**
- **Total Packages:** 12
- **Total Objects:** 131
- **Test Files:** 11
- **Success Rate:** 100%
- **Average Execution Time:** ~60ms per test

See [Test/README.md](Test/README.md) for detailed test documentation.

### Configuration

Connection settings are stored in `scripts/ZyncConfig.psm1`:

```powershell
# View current configuration
Import-Module .\scripts\ZyncConfig.psm1
Show-ZyncConfig

# Configuration is automatically used by all test scripts
# Modify ZyncConfig.psm1 to change connection settings
```

## 🤝 Contributing
For development and contribution workflow, please see the dedicated guides in the `Doc` folder:
- [CONTRIBUTING_EN.md](Doc/CONTRIBUTING_EN.md)
- [CONTRIBUTING_FA.md](Doc/CONTRIBUTING_FA.md)




