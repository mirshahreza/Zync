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

Deploy a complete package (e.g., database utilities):

```sql
EXEC Zzz_Deploy 'DbUtils'
```

Deploy a specific script:

```sql
EXEC Zzz_Deploy 'String/Zz_SplitString.sql'
```

Deploy all available packages:

```sql
EXEC Zzz_Deploy ''
```

## 📚 Available Packages

### 🔧 DbUtils
Database utilities for common administrative tasks:
- Table and column management (create, alter, drop)
- Foreign key management  
- Object existence checking
- Dependency analysis
- Schema exploration tools

```sql
EXEC Zzz_Deploy 'DbUtils'
```

### 🔤 String
String manipulation and processing functions:
- String splitting and trimming
- Character and word counting
- Text formatting utilities
- N-th item extraction

```sql
EXEC Zzz_Deploy 'String'
```

### 🔢 Number  
Numeric formatting and conversion utilities:
- Byte size formatting (KB, MB, GB)
- Number humanization
- Mathematical helper functions

```sql
EXEC Zzz_Deploy 'Number'
```

### 👤 AppEnd
Application framework components:
- User management system
- Role-based access control (RBAC)
- Activity logging
- Authentication helpers

```sql
EXEC Zzz_Deploy 'AppEnd'
```

## 🏗️ Project Structure

```
MsSql/
├── README.md
├── Zync.sql              # Core package manager setup
└── Packages/
    ├── AppEnd/           # Application framework
    ├── DbUtils/          # Database utilities  
    ├── Number/           # Numeric functions
    └── String/           # String functions
```

## 📖 Usage Examples

### Deploy Specific Functionality

```sql
-- Install string splitting function
EXEC Zzz_Deploy 'String/Zz_SplitString.sql'

-- Install table creation utilities
EXEC Zzz_Deploy 'DbUtils/Zz_CreateTableGuid.sql'

-- Install user management system
EXEC Zzz_Deploy 'AppEnd/AAA_Users.sql'
```

### Deploy Complete Solutions

```sql
-- Install all string utilities
EXEC Zzz_Deploy 'String'

-- Install complete user management system
EXEC Zzz_Deploy 'AppEnd'

-- Install everything
EXEC Zzz_Deploy ''
```

## 🎯 Naming Conventions

### Why Objects Start with "Zz"

We recommend prefixing utility objects with `Zz` because:
- 📍 **Organized Listing**: Objects appear at the end of alphabetical lists
- 🎯 **Clear Separation**: Project objects are visible first, utilities last  
- 🔍 **Easy Identification**: Quickly distinguish between business logic and utilities
- 🚀 **Professional Structure**: Maintains clean database schemas

Example:
```
Customer_Orders        (your business objects)
Product_Inventory      
User_Profiles         
...
Zz_SplitString        (Zync utilities)
Zz_FormatBytes        
Zz_CreateTable        
```



