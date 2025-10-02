# Stop Juggling SQL Scripts: Introducing Zync, the Database Package Manager

[![Test Coverage](https://img.shields.io/badge/Tests-100%25%20Pass-brightgreen.svg)](../Test/)
[![Objects](https://img.shields.io/badge/Objects-131-blue.svg)](../Packages/)
[![Packages](https://img.shields.io/badge/Packages-12-orange.svg)](../Packages/)

If you've ever worked on a large database project, you know the pain. You have folders filled with SQL scripts for stored procedures, functions, and views. Script `A` depends on `B`, which depends on `C`. Deploying to a new environment means running them in the correct order, and heaven forbid you miss one. Sharing reusable utilities across projects is a copy-paste nightmare.

We've built powerful package managers for our application code—npm for Node.js, NuGet for .NET, Pip for Python. They handle dependencies, versioning, and distribution flawlessly. So why are we still managing database scripts like it's 1999?

It's time for a change. Introducing **Zync version 3.0**, a production-ready package manager for SQL Server with 12 packages, 131 tested objects, and 100% test coverage.Juggling SQL Scripts: Introducing Zync, the Database Package Manager

If you’ve ever worked on a large database project, you know the pain. You have folders filled with SQL scripts for stored procedures, functions, and views. Script `A` depends on `B`, which depends on `C`. Deploying to a new environment means running them in the correct order, and heaven forbid you miss one. Sharing reusable utilities across projects is a copy-paste nightmare.

We’ve built powerful package managers for our application code—npm for Node.js, NuGet for .NET, Pip for Python. They handle dependencies, versioning, and distribution flawlessly. So why are we still managing database scripts like it’s 1999?

It’s time for a change. Introducing **Zync**, a simple but powerful package manager for SQL Server, designed to bring the convenience of modern package management directly into your database.

### The Chaos of Manual Script Management

Before we dive into the solution, let’s appreciate the problem. Traditionally, managing a collection of database objects involves:

*   **Manual Dependency Tracking:** You have to remember that `CreateUserView.sql` must run after `CreateUserTable.sql`. This knowledge is often stored in a developer's head or a fragile `README` file.
*   **Scattered Scripts:** Utility functions and procedures are often scattered across different project folders, leading to code duplication and maintenance headaches.
*   **Inconsistent Deployment:** Deploying to a new database is often a manual, error-prone process that can easily lead to inconsistencies between development, staging, and production environments.
*   **Difficult Collaboration:** Sharing a set of useful database tools with your team or the community is far from straightforward.

Zync was born out of this frustration. It treats your database objects as what they are: **packages**—modular, reusable, and dependency-aware units of code.

### How Zync Simplifies Your Workflow

Zync is built around a single stored procedure, `dbo.Zync`, that acts as your command-line interface inside SQL Server Management Studio (SSMS). Once installed, it gives you access to a world of functionality through simple commands.

The core philosophy is simple: host your SQL packages in a GitHub repository, and let Zync handle the rest.

#### Key Concepts:

*   **📦 Package Management:** Group related SQL objects (procedures, functions, etc.) into a "package," which is simply a folder in a repository.
*   **🔄 Automatic Dependency Resolution:** Define dependencies for a package, and Zync will automatically fetch and install them first.
*   **🎯 Simple Commands:** A clean, intuitive command structure for listing and installing packages.
*   **🏗️ Standardized Repositories:** Use the official Zync repository or point it to your own for private packages.

### Getting Started with Zync

Zync currently targets SQL Server (MsSql). All scripts, packages, tests, and helper tools live under the `MsSql/` folder in the repository.

Ready to give it a try? It only takes a few minutes to get up and running.

#### Step 1: Install the Zync Stored Procedure

First, you need to install the core `Zync` procedure in your target database. Just download and run the [`Zync.sql`](https://github.com/mirshahreza/Zync/blob/main/MsSql/Zync.sql) script from the official repository. This one-time setup is all you need.

#### Step 2: List Available Packages

Once installed, you can see which packages are available in the default repository with the `ls` (list) command. The root list expands the repository index at `MsSql/Packages/.sql` and shows the scripts contained in each package.

```sql
EXEC [dbo].[Zync] 'ls'
```

This command reads the repository index and returns a list of packages and their contained scripts (names only) for a quick overview.

**Expected Output:**

```
Listing package(s): ''...

 -> Expanding packages and listing contained objects:
	[DateTime]:
		- ZzStartOfWeek.sql
		- ZzEndOfWeek.sql
		- ...
	[DbMan]:
		- ZzCreateTableGuid.sql
		- ZzCreateOrAlterFk.sql
		- ...
	[DbMon]:
		- ZzSelectActiveSessions.sql
		- ZzSelectBackupHistory.sql
		- ...
	[Math]:
		- ZzFormatBytes.sql
		- ZzSafeDivide.sql
		- ...
	[String]:
		- ZzSplitString.sql
		- ZzCountWord.sql
		- ...
	[Financial]:
		- ZzCalculateLoanPayment.sql
		- ...
```

#### Search and Discover

You can filter across all packages or inside a specific package:

```sql
-- Search everywhere (case-insensitive; % or * as wildcard)
EXEC [dbo].[Zync] 'ls ?week';

-- Search inside a package by name or description
EXEC [dbo].[Zync] 'ls DbMon ?agent%status';
```

#### Step 3: Install Your First Package

Let's say you need a set of string manipulation utilities. You can install the `String` package with the `i` (install) command.

```sql
EXEC [dbo].[Zync] 'i String'
```

Here’s what happens behind the scenes:
1.  Zync constructs the URL to the package's main SQL file in the repository.
2.  It fetches the content of the script.
3.  It checks for any dependencies listed at the top of the file and installs them first.
4.  Finally, it executes the script, creating all the objects from the `String` package in your database.

**Output:**

```
Installing package: 'String'...
 -> Fetched 'String' successfully.
 -> Package 'String' installed successfully.
```

Just like that, you now have access to useful functions like `ZzSplitString` and `ZzCountWord` without ever leaving your query editor.

You can also install a single script from a package if you don't need the entire collection:

```sql
-- Installs only the ZzSplitString function
EXEC [dbo].[Zync] 'i String/ZzSplitString.sql'
```

### The Zync Ecosystem: Production-Ready Packages

**Zync version 3.0** is now production-ready with comprehensive testing:

*   ✅ **12 packages** with 131 tested objects
*   ✅ **100% test coverage** - all tests passing
*   ✅ **PowerShell automation** scripts for installation and testing
*   ✅ **Complete documentation** for all packages

**Available Packages:**
- **Backup** (4 objects): Backup and restore utilities
- **Base** (8 objects): Foundation tables for common application needs
- **DateTime** (32 objects): Comprehensive date/time functions including Hijri/Shamsi converters
- **DbMan** (23 objects): Database management tools
- **DbMon** (35 objects): Monitoring and diagnostic utilities
- **Financial** (9 objects): Financial calculations
- **Geographic** (26 objects): Geographic calculations and coordinate operations
- **Json** (5 objects): JSON manipulation functions
- **Math** (35 objects): Mathematical functions and utilities
- **Security** (5 objects): Security and encryption utilities
- **String** (43 objects): Comprehensive string operations
- **Validation** (5 objects): Data validation functions

### The Road Ahead

*   **Support for other databases** like PostgreSQL, MySQL, and Oracle
*   **Advanced versioning** for managing different package versions
*   **Dependency visualization** for better understanding of package relationships
*   **Web browser** for package discovery and search

### Join the Movement

Managing database code shouldn't be a chore. Zync offers a streamlined, modern approach that saves time and reduces errors. It empowers developers to build, share, and reuse database utilities with ease.

Check out the project on GitHub, give it a star, and try it out in your own projects. Contributions, feedback, and ideas are always welcome.

**Find the project here: [https://github.com/mirshahreza/Zync](https://github.com/mirshahreza/Zync)**

Tip: By default Zync fetches from `https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/`. You can point to your own repository/branch by passing it as the second parameter, e.g. `EXEC dbo.Zync 'i String', 'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';`.

Useful commands beyond install/list:
- `lo` or `list-objects`: list all Zync-managed objects (name starts with Zz)
- `clean`: remove ALL Zync-managed objects and tracking data
- `rm <pkgOrFile>`: remove a package or a specific script (restores previous version when available)
- `rb <package>`: rollback a package to its previous version

---

### Comprehensive Automated Testing

Zync includes a complete test suite with 100% coverage to ensure quality and stability:

```powershell
# Test database connectivity
.\scripts\TestConnection.ps1

# Install all packages from local files
.\scripts\InstallLocalPackages.ps1

# Run all tests (recommended)
.\scripts\RunAllTests.ps1

# Run specific package test
.\scripts\RunSingleTest.ps1 -TestName string
.\scripts\RunSingleTest.ps1 -TestName math

# List available tests
.\scripts\ListTests.ps1

# Validate test file structure
.\scripts\ValidateTests.ps1
```

**Latest Test Results:**
- ✅ 11 test files
- ✅ 131 objects tested
- ✅ 100% success rate
- ⚡ Average execution time: 60ms per test

All test logs are saved to `MsSql/TestLogs/`.

---

**Mohsen Mirshahreza**  
Database Developer and Architect  
GitHub: [@mirshahreza](https://github.com/mirshahreza)
