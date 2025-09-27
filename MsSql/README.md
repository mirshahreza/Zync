# 🗄️ Zync for SQL Server

[![SQL Server](https://img.shields.io/badge/SQL%20Server-Supported-blue.svg)](https://www.microsoft.com/en-us/sql-server/)

Complete SQL Server implementation of Zync database package manager. Install and manage database objects with automatic dependency resolution.

## 🚀 Quick Start

### 1. Setup Database

First, download and run the `Zync.sql` script to initialize the package management system in your database:

```sql
-- Run this in your SQL Server database
-- Download from: MsSql/Zync.sql
```

### 2. Deploy Your First Package

Help and Commands avalable:

```sql
EXEC DBO.Zync '?'
```

Deploy a complete package (e.g., database utilities):

```sql
EXEC DBO.Zync 'i DbMan'
EXEC DBO.Zync 'i DbMon'
EXEC DBO.Zync 'i DbSel'
```

Deploy a specific script:

```sql
EXEC DBO.Zync 'i String/ZzSplitString.sql'
```

Deploy all available packages:

```sql
EXEC DBO.Zync 'i'
```

## 📚 Available Packages

### 🔧 DbMan, DbMon, DbSel
Database utilities for common administrative tasks:
- Table and column management (create, alter, drop)
- Foreign key management  
- Object existence checking
- Dependency analysis
- Schema exploration tools

```sql
EXEC DBO.Zync 'DbMan'
EXEC DBO.Zync 'DbMon'
EXEC DBO.Zync 'DbSel'
```

### 🔤 String
String manipulation and processing functions:
- String splitting and trimming
- Character and word counting
- Text formatting utilities
- N-th item extraction

```sql
EXEC DBO.Zync 'String'
```

### 🔢 Math  
Numeric formatting and conversion utilities:
- Byte size formatting (KB, MB, GB)
- Number humanization
- Mathematical helper functions

```sql
EXEC DBO.Zync 'Math'
```

### 👤 AppEnd
Application framework components:
- User management system
- Role-based access control (RBAC)
- Activity logging
- Authentication helpers

```sql
EXEC DBO.Zync 'AppEnd'
```

### 📅 DateTime
Date and time utilities:
- Hijri and Shamsi converters
- Date formatting and manipulation
- Start/end of period calculations
- Working day calculations

```sql
EXEC DBO.Zync 'DateTime'
```

### 💰 Financial
Financial calculations and utilities:
- (Content to be added)

```sql
EXEC DBO.Zync 'Financial'
```

## 🏗️ Project Structure

```
MsSql/
├── README.md
├── Zync.sql              # Core package manager setup
└── Packages/
    ├── AppEnd/           # Application framework
    ├── DbMan/            # Database management utilities
    ├── DbMon/            # Database monitoring tools
    ├── DbSel/            # Database selection/querying tools
    ├── Math/             # Numeric functions
    └── String/           # String functions
```

## 📖 Usage Examples

### Listing and Searching (ls)

The `ls` command lists available packages and their contents. It supports a simple search filter.

Behavior:
- `ls` lists all packages and their scripts (names only; fast overview).
- `ls <package>` lists scripts inside a package with per-script descriptions.
- `ls ?term` searches across all packages (case-insensitive). Use `%` or `*` as wildcard.
- `ls <package> ?term` searches inside a package and matches on filename or description.

Examples:
```sql
-- Global listing (names only)
EXEC DBO.Zync 'ls'

-- List DateTime package with descriptions
EXEC DBO.Zync 'ls DateTime'

-- Search everywhere for "week" (e.g., WeekOfYear)
EXEC DBO.Zync 'ls ?week'

-- Search inside DbMon for items matching agent%status
EXEC DBO.Zync 'ls DbMon ?agent%status'

-- You can also use * as wildcard
EXEC DBO.Zync 'ls DateTime ?start*of'
```

### Deploy Specific Functionality

```sql
-- Install string splitting function
EXEC DBO.Zync 'String/ZzSplitString.sql'

-- Install table creation utilities
EXEC DBO.Zync 'DbMan/ZzCreateTableGuid.sql'

-- Install user management system
EXEC DBO.Zync 'AppEnd/AAA_Users.sql'
```

### Deploy Complete Solutions

```sql
-- Install all string utilities
EXEC DBO.Zync 'String'

-- Install complete user management system
EXEC DBO.Zync 'AppEnd'

-- Install everything
EXEC DBO.Zync ''
```




