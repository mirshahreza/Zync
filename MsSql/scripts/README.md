# Scripts (MsSql)

Helper scripts for Zync on SQL Server. All scripts live under `MsSql/scripts/`.

## Test Runner — RunZyncTests.ps1

Run the full SQL test suite under `MsSql/Test/` against a chosen SQL Server instance. Creates a test DB if needed, installs `MsSql/Zync.sql`, executes tests in a safe order, and writes logs to `MsSql/TestLogs/`.

- Path: `MsSql/scripts/RunZyncTests.ps1`
- Logs: `MsSql/TestLogs/*.log`
- Prerequisites: PowerShell, and the `SqlServer` module (auto-installed if missing)

Parameters:
- `-ServerName` (default: `\.\SQL2022`)
- `-Database` (default: `ZyncTest`)
- `-Auth` (`Windows` or `Sql`)
- `-User`, `-Password` (when `-Auth Sql`)
- `-TestFilter` (e.g., `zync_test_comprehensive.sql`)
- `-ContinueOnError`
- `-NoOleAutomation` (skip enabling OLE Automation)

Example:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File "c:\Workspace\Projects\Zync\MsSql\scripts\RunZyncTests.ps1" `
  -ServerName ".\SQL2022" `
  -Database "ZyncTest" `
  -ContinueOnError
```

Notes:
- The runner sets `TrustServerCertificate = $true` and `Encrypt = Optional` to avoid local TLS issues.
- If needed, it attempts to enable OLE Automation for HTTP fetches used by `dbo.Zync`.

## Package Generator — GenerateZyncPackageFromDb.ps1

Automates creating a Zync package from an existing SQL Server database by prefix (e.g., all `Base*` tables).

- Path: `MsSql/scripts/GenerateZyncPackageFromDb.ps1`
- Behavior:
  - Scripts tables first (without foreign keys)
  - Scripts all foreign keys into a single `_ForeignKeys.sql`
  - Writes a package index `.sql` that installs tables first, then `_ForeignKeys.sql`
- Requirements: SMO assemblies or the `SqlServer` PowerShell module

Parameters:
- `-ServerName` (default: `\.\SQL2022`)
- `-Database` (default: `AppEndV2`)
- `-User`, `-Password`
- `-NamePrefix` (e.g., `Base`)
- `-OutputDir` (e.g., `MsSql/Packages/Base`)

Example:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File "c:\Workspace\Projects\Zync\MsSql\scripts\GenerateZyncPackageFromDb.ps1" `
  -ServerName ".\SQL2022" `
  -Database "AppEndV2" `
  -User "sa" `
  -Password "1" `
  -NamePrefix "Base" `
  -OutputDir "c:\Workspace\Projects\Zync\MsSql\Packages\Base"
```

Outputs:
- `MsSql/Packages/<Prefix>/<Table>.sql` for each table (no FKs)
- `MsSql/Packages/<Prefix>/_ForeignKeys.sql`
- `MsSql/Packages/<Prefix>/.sql` index including `_ForeignKeys.sql` last

Troubleshooting:
- If SMO types fail to load, install PowerShell module `SqlServer`:
  - `Install-Module -Name SqlServer -Scope CurrentUser`
- If you see a `List[SMO.Urn]` generic type error, the script already uses plain arrays for URNs.
