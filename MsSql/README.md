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
EXEC DBO.Zync 'i DbUtils'
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

### 🔧 DbUtils
Database utilities for common administrative tasks:
- Table and column management (create, alter, drop)
- Foreign key management  
- Object existence checking
- Dependency analysis
- Schema exploration tools

```sql
EXEC DBO.Zync 'DbUtils'
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

### 🔢 Number  
Numeric formatting and conversion utilities:
- Byte size formatting (KB, MB, GB)
- Number humanization
- Mathematical helper functions

```sql
EXEC DBO.Zync 'Number'
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
EXEC DBO.Zync 'String/ZzSplitString.sql'

-- Install table creation utilities
EXEC DBO.Zync 'DbUtils/ZzCreateTableGuid.sql'

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




