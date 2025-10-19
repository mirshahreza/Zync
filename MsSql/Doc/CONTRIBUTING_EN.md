# Zync (SQL Server) — Development & Contribution Guide

[![Test Coverage](https://img.shields.io/badge/Tests-100%25%20Pass-brightgreen.svg)](../Test/)
[![Objects](https://img.shields.io/badge/Objects-131-blue.svg)](../Packages/)
[![Packages](https://img.shields.io/badge/Packages-12-orange.svg)](../Packages/)

This document provides a complete, step-by-step guide for developers who want to:
- Create a new object (Procedure / Function / View / Type) and add it to an existing package
- Create a new package from scratch with the correct structure
- Write comprehensive tests for their objects
- Publish their changes to the main repository (Pull Request) or host and use them from a personal repository

This guide targets the SQL Server implementation and follows the structure under `MsSql/`.

**Project Status:** Version 3.0 with 12 packages, 131 objects, and 100% test coverage

---

## Prerequisites

### Required Software:
- **SQL Server 2017+** (Recommended: SQL Server 2022)
- **PowerShell 7+** for running test and installation scripts
- **SQL Server Management Studio (SSMS)** or similar tool
- **Git** for version control and submitting changes

### Configuration:
- Permission to execute scripts on the target database
- Run `MsSql/Zync.sql` once on the target database to install Zync core
- OLE Automation enabled if you will fetch packages via GitHub Raw (HTTP):

```sql
EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE;
```

By default, Zync fetches from:
```
https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/
```
If your repo uses the `main` branch, or you want to use your personal repo, pass the second Zync parameter (`@Repo`) when calling commands (examples below).

---

## Naming and Coding Conventions

- Utility object names start with the `Zz` prefix to distinguish them from business logic, e.g., `ZzSplitString`, `ZzCreateTableGuid`.
- Schema: use `[dbo]` unless you have a specific reason otherwise.
- Always use the "CREATE OR ALTER" pattern for safe installs/updates:
  - `CREATE OR ALTER PROCEDURE [dbo].[ZzMyProc] ...`
  - `CREATE OR ALTER FUNCTION [dbo].[ZzMyFunc] ...`
  - `CREATE OR ALTER VIEW [dbo].[ZzMyView] AS ...`
  - For Types, `CREATE TYPE` is generally used (backup handling differs for types).
- Put a header at the top of each file so `ls <package>` can show a description. The `-- Description:` line helps render the short description for each item.

Standard header example:
```sql
-- =============================================
-- Author:      Your Name
-- Create date: 2025-09-27
-- Description: A short, precise, actionable description of the object.
-- Sample:
-- EXEC [dbo].[ZzMyFunc] ...
-- =============================================
```

- If your script depends on other objects, you can declare dependencies at the very top in a comment block. Zync will execute this block before running the main script:

```sql
/*
EXEC DBO.Zync 'i String/ZzSplitString.sql';
EXEC DBO.Zync 'i Math/ZzSafeDivide.sql';
*/
-- Your object script continues here...
```

Note: Zync detects and executes the initial comment block (starting at the first character with `/*`) as dependencies before executing the main script.

---

## Folder and File Structure

- SQL Server root: `MsSql/`
- Packages: `MsSql/Packages/<PackageName>/`
- A package may have an index file `MsSql/Packages/<PackageName>/.sql` containing a list of install lines; see the `String` package for an example. Installing the package runs all items listed there.
- Each object is a standalone `.sql` file, named clearly and matching the database object name; e.g., `MsSql/Packages/String/ZzSplitString.sql` with `CREATE OR ALTER FUNCTION [dbo].[ZzSplitString] ...` inside.
- Include a brief `README.md` for each package describing what it provides and how to deploy it.

---

## Add a New Object to an Existing Package

1) Choose the appropriate package (e.g., `String`, `DateTime`).
2) Create a new file in that package, e.g.:
   - `MsSql/Packages/String/ZzMyNewFunction.sql`
3) Write the standard header and the object body using `CREATE OR ALTER` in schema `[dbo]`.
4) If needed, declare dependencies in an initial comment block.
5) If you want full package install to include your new object, add one line to the package index file:
   - Edit: `MsSql/Packages/<PackageName>/.sql`
   - Add: `EXEC DBO.Zync 'i <PackageName>/<FileName>.sql';`
6) Update the package `README.md` and mention the new object.
7) Test locally against a test database:
   - Install the single item:
     ```sql
     EXEC [dbo].[Zync] 'i String/ZzMyNewFunction.sql';
     ```
   - List with descriptions:
     ```sql
     EXEC [dbo].[Zync] 'ls String';
     ```
   - Show installed Zync-managed objects:
     ```sql
     EXEC [dbo].[Zync] 'lo';
     ```

---

## Create a New Package from Scratch

Assume you want a new package `Text`:

1) Create folders:
   - `MsSql/Packages/Text/`
2) Create the package index file:
   - `MsSql/Packages/Text/.sql`
   - Put install lines for package items, for example:
     ```sql
     EXEC DBO.Zync 'i Text/ZzNormalizeSpace.sql';
     EXEC DBO.Zync 'i Text/ZzToTitleCase.sql';
     ```
     (Optional) If the package depends on other packages, add a top comment block with dependency installs.
3) Create your objects, each in a separate file, with the header and standards above.
4) Create `MsSql/Packages/Text/README.md` to introduce the package and show how to install it:
   ```sql
   EXEC dbo.Zync 'i Text';
   -- or install a single item:
   EXEC dbo.Zync 'i Text/ZzNormalizeSpace.sql';
   ```
5) Test on a test database:
   ```sql
   EXEC dbo.Zync 'i Text';
   EXEC dbo.Zync 'ls Text';
   EXEC dbo.Zync 'lo';
   ```

Notes:
- Make sure filenames match object names.
- For `ls <package>` descriptions to show, add a `-- Description:` line at the top of each item file.

---

## Publish to the Main Repository (Pull Request)

1) Fork the main repo.
2) Create a new branch (e.g., `feature/<short-name>`).
3) Apply changes according to the standards:
   - Place scripts in the correct package paths
   - Update the package index `.sql` (if needed)
   - Update the package `README.md`
   - Keep the standard header, `CREATE OR ALTER`, and the `Zz` prefix
   - Optionally add tests under `MsSql/Test/`
4) Local verification:
   - Run `MsSql/Zync.sql` once on a test DB
   - Try installs:
     ```sql
     EXEC dbo.Zync 'clean';
     EXEC dbo.Zync 'i <YourPackageOrFile>';
     EXEC dbo.Zync 'ls <YourPackage>';
     EXEC dbo.Zync 'lo';
     ```
   - Optionally run `MsSql/Test/zync_check_syntax.sql` or `MsSql/Test/zync_test_comprehensive.sql`
5) Commit with clear messages and open a PR that explains changes, rationale, and usage samples.

Note: Zync currently defaults to `master` in the GitHub Raw URL. If the default branch changes in the future, this may be updated internally; you normally do not need to modify it. Mentioning branch considerations in your PR is welcome.

---

## Use and Host from a Personal Repository

If you want to host and install packages from your own repo:

1) Mirror the folder structure:
```
<YourRepo>/MsSql/Packages/<PackageName>/<Files>.sql
```
2) Prepare your `.sql` files as above.
3) When installing, pass the repo URL as the second parameter to Zync. Examples:

- Install a full package from a personal repo (main branch):
```sql
EXEC dbo.Zync 'i String', 'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';
```

- Install a single file from a personal repo (master branch):
```sql
EXEC dbo.Zync 'i DateTime/ZzStartOfWeek.sql', 'https://raw.githubusercontent.com/<user>/<repo>/master/MsSql/Packages/';
```

- List/Search using a personal repo:
```sql
EXEC dbo.Zync 'ls DateTime', 'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';
EXEC dbo.Zync 'ls ?week',    'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';
```

Tips:
- Ensure the URL ends with the `Packages` folder path (trailing slash matters).
- Use `main` or `master` in the URL according to your repo branch.
- The package index file (`.sql`) should list install lines like the `String` package example.
- For `ls <package>` descriptions, include a `-- Description:` line in each item.

---

## Templates

### 1) Function template
```sql
/* Optional dependencies
EXEC DBO.Zync 'i String/ZzSplitString.sql';
*/
-- =============================================
-- Author:      Your Name
-- Create date: 2025-09-27
-- Description: Short description of the function
-- Sample:
-- SELECT * FROM [dbo].[ZzMyFunc](...);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzMyFunc]
(
    @Param1 NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT @Param1 AS Value -- Replace with actual body
);
```

### 2) Procedure template
```sql
/* Optional dependencies
EXEC DBO.Zync 'i DbMan/ZzObjectExist.sql';
*/
-- =============================================
-- Author:      Your Name
-- Create date: 2025-09-27
-- Description: What this procedure does
-- Sample:
-- EXEC [dbo].[ZzMyProc] @Param = '...';
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[ZzMyProc]
    @Param NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    -- Body goes here
END
```

### 3) Package index file (.sql)
```sql
-- Install all objects of the Text package
EXEC DBO.Zync 'i Text/ZzNormalizeSpace.sql';
EXEC DBO.Zync 'i Text/ZzToTitleCase.sql';
```

---

## Testing and Quality Checks

- Before PR or publishing, try install/remove on a test DB:
  - `EXEC dbo.Zync 'i <PkgOrFile>'`
  - `EXEC dbo.Zync 'lo'`
  - `EXEC dbo.Zync 'rm <PkgOrFile>'` then `lo` again
- You can use helper scripts under `MsSql/Test/` (e.g., `zync_check_syntax.sql`, `zync_test_comprehensive.sql`).
- Watch for error messages and SQL Server compatibility.
- Brackets `[ ]` in names are used consistently; Zync's internal parser expects patterns like `CREATE OR ALTER ... [dbo].[Name]`.

---

## FAQ

- Why are descriptions not shown in `ls <package>`?
  - Ensure each item file has a `-- Description:` line at the top.
- How are dependencies installed in order?
  - If you provide a top comment block, Zync executes it before the main script. For packages, the index `.sql` determines the install order of member items.
- What if my repo uses the `main` branch?
  - Pass the second parameter to Zync with a URL pointing to your `main` branch.

---

With these guidelines, you can confidently build new objects, create packages, and publish them either to the main repository or your personal one. Thanks for contributing to Zync!

---

## Generate a Package from an Existing Database (Automation Script)

To extract a subset of objects from a database (e.g., all tables whose names start with "Base") and turn them into a Zync package, use the automation script:

- Script path: `scripts/GenerateZyncPackageFromDb.ps1`
- Typical output path: `MsSql/Packages/Base/`
- Key behavior: the script generates tables first without foreign keys, then emits all foreign keys into a single `_ForeignKeys.sql` file and adds it at the end of the package index to ensure a safe install order.

### Prerequisites

- Windows PowerShell with permission to run scripts
- SMO (SQL Server Management Objects) or the `SqlServer` PowerShell module
  - If SMO assemblies are not found, the script will try to `Import-Module SqlServer`
  - If needed, install the module:
    - In PowerShell: `Install-Module -Name SqlServer -Scope CurrentUser`

### Parameters

- `-ServerName` SQL Server instance name (default: `.
SQL2022`)
- `-Database` Database name (default: `AppEndV2`)
- `-User`, `-Password` SQL Login credentials (the current script uses SQL auth)
- `-NamePrefix` Name prefix filter for objects (e.g., `Base`)
- `-OutputDir` Output folder for the generated package (e.g., `MsSql/Packages/Base`)

### Example run (Windows PowerShell)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "c:\Workspace\Projects\Zync\scripts\GenerateZyncPackageFromDb.ps1" `
  -ServerName ".\SQL2022" `
  -Database "AppEndV2" `
  -User "sa" `
  -Password "1" `
  -NamePrefix "Base" `
  -OutputDir "c:\Workspace\Projects\Zync\MsSql\Packages\Base"
```

### Outputs and package layout

- One file per table: e.g., `BaseUsers.sql`, `BaseInfo.sql`, ... (without FKs)
- A single file for all FKs: `MsSql/Packages/<Prefix>/_ForeignKeys.sql`
- Package index file: `MsSql/Packages/<Prefix>/.sql` listing install lines in order:
  - All table files first
  - Final line: `EXEC DBO.Zync 'i <Prefix>/_ForeignKeys.sql';`

Install the generated package with:

```sql
EXEC dbo.Zync 'i Base';
```

List items:

```sql
EXEC dbo.Zync 'ls Base';
```

### Notes and troubleshooting

- Seeing “Cycles detected among tables…” is expected for mutually referencing schemas. Since FKs are applied at the end, install remains safe.
- If you encounter an error about `List[SMO.Urn]`, the current script version uses plain PowerShell arrays for URNs, which resolves the issue. Ensure you are running the latest version.
- If SMO is missing and importing `SqlServer` fails, install the module or add SMO via SSMS/Feature Pack.
- To target a different subset, adjust `-NamePrefix` (e.g., `Core`, `User`).

### Integrating with package development

- After generation, consider adding a `-- Description:` line at the top of each file so Zync’s `ls <package>` can show friendly descriptions.
- Add a brief `README.md` for the new package (use existing packages as a template).
- Optionally, you can extend the script to split indexes/check constraints into separate scripts similar to the FK split.