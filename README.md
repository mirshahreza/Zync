# 🗄️ Zync - Database Package Manager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.txt)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-Supported-blue.svg)](https://www.microsoft.com/en-us/sql-server/)

**Zync** is a database package manager similar to npm for Node.js or NuGet for .NET. It helps you easily install, manage, and deploy database objects (stored procedures, functions, views, tables) from standardized repositories with automatic dependency resolution.

## ✨ Core Concepts

Zync simplifies database development by applying modern package management principles to SQL:

- 📦 **Package Management**: Manage database objects (procedures, functions, etc.) as modular packages.
- 🔄 **Dependency Resolution**: Automatically install dependencies in the correct order.
- 🎯 **Simple Commands**: Use single commands to deploy entire packages or individual scripts.
- 🛡️ **Safe Deployment**: Handle object creation and updates safely without manual intervention.
- 🏗️ **Standard Repositories**: Use a built-in library of utilities or create your own.

## 🚀 Getting Started

Zync currently supports only **SQL Server** (MsSql). All scripts, tests, and docs live under the `MsSql/` folder.

### 📊 SQL Server
> ✅ **Status**: Production-ready with comprehensive test coverage (100% pass rate)

**[📖 Get Started with SQL Server →](MsSql/README.md)**

Quick installation and test:

```powershell
# Install Zync core
sqlcmd -S .\SQL2022 -d master -E -C -i "c:\Workspace\Projects\Zync\MsSql\Zync.sql"

# Install all packages
.\InstallLocalPackages.ps1

# Run comprehensive tests
.\RunAllTests.ps1

# Or run specific package test
.\RunSingleTest.ps1 -TestName string
```

## 🏗️ Project Structure

```
Zync/
├── LICENSE.txt
├── README.md                # Project overview (you are here)
└── MsSql/                   # SQL Server implementation
    ├── README.md            # SQL Server documentation
    ├── Zync.sql             # Core package manager (v3.0)
    ├── Packages/            # 12 Available packages (131 objects)
    │   ├── Backup/          # Backup & restore utilities (4 objects)
    │   ├── Base/            # Base tables for common use (8 objects)
    │   ├── DbMan/           # Database management (23 objects)
    │   ├── DbMon/           # Monitoring & diagnostics (35 objects)
    │   ├── DateTime/        # Date/time functions (32 objects)
    │   ├── Financial/       # Financial calculations (9 objects)
    │   ├── Geographic/      # Geographic calculations (26 objects)
    │   ├── Json/            # JSON manipulation (5 objects)
    │   ├── Math/            # Mathematical functions (35 objects)
    │   ├── Security/        # Security & encryption (5 objects)
    │   ├── String/          # String operations (43 objects)
    │   └── Validation/      # Validation functions (5 objects)
    ├── scripts/             # PowerShell automation scripts
    │   ├── TestConnection.ps1        # Test database connectivity
    │   ├── InstallLocalPackages.ps1  # Install all packages
    │   ├── RunAllTests.ps1           # Run comprehensive test suite
    │   ├── RunSingleTest.ps1         # Run individual package test
    │   ├── ZyncConfig.psm1           # Configuration module
    │   └── ...
    ├── Test/                # Comprehensive test suite (11 files)
    │   ├── zync_test_*.sql  # Package-specific tests
    │   └── README.md        # Test documentation
    └── TestLogs/            # Test execution logs & reports
```

## 🎯 Naming Conventions

We recommend prefixing utility objects with `Zz` to keep them organized and separate from your project's business logic. They will appear at the end of database object lists, ensuring your primary objects are always visible first.

Example:
```
Customer_Orders        (your business objects)
Product_Inventory      
...
ZzSplitString         (Zync utilities)
ZzCreateTable        
```

## � Current Status

- ✅ **SQL Server**: Production-ready with 12 packages (131 objects)
- ✅ **Test Coverage**: 100% pass rate with comprehensive test suite
- ✅ **PowerShell Automation**: Complete installation and testing scripts
- ✅ **Documentation**: Full documentation for all packages and tools

## �🛣️ Roadmap

- [ ] **Oracle** support
- [ ] **MySQL** support  
- [ ] **PostgreSQL** support
- [ ] **Package versioning** system (v1.0 in progress)
- [ ] **Package dependency** visualization
- [ ] **Web-based package** browser
- [ ] **CI/CD integration** examples

## 🤝 Support, Donations & Contributing

If you encounter any issues, have questions, or would like to contribute, here’s how you can help:

### 🆘 Getting Support
- **📝 Create an issue**: The best way to report bugs or request features.
- **📧 Contact the maintainers**: For direct inquiries.
- **📚 Check the documentation**: Each package has its own `README` file.

<!--
### ❤️ Financial Support
If you find this project helpful, your contribution would be greatly appreciated. Donations help us dedicate more time to maintenance and new features.

- **[💖 Sponsor on GitHub](https://github.com/sponsors/mirshahreza)**

Thank you for your support!
-->

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.

---

**Made with ❤️ for the database community**