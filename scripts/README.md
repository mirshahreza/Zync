# Scripts

This folder contains helper scripts for Zync.

## GenerateZyncPackageFromDb.ps1

Automates creating a Zync package from existing SQL Server database tables filtered by a name prefix.

- Path: `scripts/GenerateZyncPackageFromDb.ps1`
- Behavior:
  - Scripts tables first without foreign keys
  - Scripts all foreign keys into a single `_ForeignKeys.sql`
  - Writes a package index `.sql` that installs tables first, then `_ForeignKeys.sql`
- Requirements: SMO assemblies or the `SqlServer` PowerShell module

### Parameters
- `-ServerName` (default: `./SQL2022`)
- `-Database` (default: `AppEndV2`)
- `-User`, `-Password`
- `-NamePrefix` (e.g., `Base`)
- `-OutputDir` (e.g., `MsSql/Packages/Base`)

### Example

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "c:\Workspace\Projects\Zync\scripts\GenerateZyncPackageFromDb.ps1" `
  -ServerName ".\SQL2022" `
  -Database "AppEndV2" `
  -User "sa" `
  -Password "1" `
  -NamePrefix "Base" `
  -OutputDir "c:\Workspace\Projects\Zync\MsSql\Packages\Base"
```

### Outputs
- `MsSql/Packages/<Prefix>/<Table>.sql` for each table (no FKs)
- `MsSql/Packages/<Prefix>/_ForeignKeys.sql`
- `MsSql/Packages/<Prefix>/.sql` index including `_ForeignKeys.sql` last

### Troubleshooting
- If SMO types fail to load, install PowerShell module `SqlServer`:
  - `Install-Module -Name SqlServer -Scope CurrentUser`
- If you see a `List[SMO.Urn]` generic type error, use the updated script (it now uses plain arrays for URNs).
