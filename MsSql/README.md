# 🗄️ Zync for SQL Server

[![SQL Server](https://img.shields.io/badge/SQL%20Server-Supported-blue.svg)](https://www.microsoft.com/en-us/sql-server/)

Complete SQL Server implementation of Zync database package manager. Install and manage database objects with automatic dependency resolution.

## 🚀 Quick Start

### 1. Setup Database

Run the `Zync.sql` script to initialize the package management system in your database:

```sql
-- Execute this once in your SQL Server database
-- File path: MsSql/Zync.sql
```

### 2. Explore Commands

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

### 🔧 DbMan, DbMon
Database utilities for common administrative tasks:
- Table and column management (create, alter, drop)
- Foreign key management  
- Object existence checking
- Dependency analysis
- Schema exploration tools

```sql
EXEC dbo.Zync 'i DbMan'
EXEC dbo.Zync 'i DbMon'
```

### 🔤 String
String manipulation and processing functions:
- String splitting and trimming
- Character and word counting
- Text formatting utilities
- N-th item extraction

```sql
EXEC dbo.Zync 'i String'
```

### 🔢 Math  
Numeric formatting and conversion utilities:
- Byte size formatting (KB, MB, GB)
- Number humanization
- Mathematical helper functions

```sql
EXEC dbo.Zync 'i Math'
```

### 📅 DateTime
Date and time utilities:
- Hijri and Shamsi converters
- Date formatting and manipulation
- Start/end of period calculations
- Working day calculations

```sql
EXEC dbo.Zync 'i DateTime'
```

### 💰 Financial
Financial calculations and utilities:
- (Content to be added)

```sql
EXEC dbo.Zync 'i Financial'
```

## 🏗️ Project Structure

```
MsSql/
├── README.md
├── Zync.sql              # Core package manager setup
└── Packages/
    ├── DbMan/            # Database management utilities
    ├── DbMon/            # Database monitoring & schema tools (DbSel merged here)
    ├── DateTime/         # Date/time functions
    ├── Math/             # Numeric functions
    ├── String/           # String functions
    └── Financial/        # Financial functions
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
```

## 🤝 Contributing
For development and contribution workflow, please see the dedicated guides in the `Doc` folder:
- [CONTRIBUTING_EN.md](Doc/CONTRIBUTING_EN.md)
- [CONTRIBUTING_FA.md](Doc/CONTRIBUTING_FA.md)




