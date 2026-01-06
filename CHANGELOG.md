# Changelog

All notable changes to this project will be documented in this file.

## 2026-01-06

### Added
- **Auto-Update Mechanism (v3.10):** Zync now automatically checks for updates on every first execution per session
  - Checks GitHub for the latest version and compares with current version
  - Automatically downloads and applies updates if a newer version is available
  - Session-based caching to avoid repeated checks within the same session
  - Automatic Ole Automation Procedures enablement when needed
  - Version tracking in `ZyncPackages` table with `ZYNC_CORE` entry
- New test file: `zync_test_autoupdate.sql` for testing auto-update functionality

### Changed
- Version bumped to 3.10
- Updated README with Auto-Update documentation section
- Updated Prerequisites section to reflect automatic Ole Automation enablement

### Technical Details
- Uses `SESSION_CONTEXT` to track update checks per session
- Extracts version number from remote Zync.sql via string parsing
- Re-executes original command after successful update
- Graceful fallback if update check fails or GitHub is unreachable

## 2025-09-28

### Documentation
- Documented the database-to-package generator script in development guides:
  - Updated `MsSql/Doc/CONTRIBUTING_FA.md` with a new section on using `scripts/GenerateZyncPackageFromDb.ps1`
  - Updated `MsSql/Doc/CONTRIBUTING_EN.md` with the English counterpart
- Added `scripts/README.md` with usage, parameters, example, outputs, and troubleshooting for the generator script
 - Performed a full documentation sweep to align with latest behavior:
   - Updated `README.md` and `MsSql/README.md` (clarified `ls` behavior, added maintenance commands, repo URL override)
   - Refreshed package READMEs (`DbMan`, `DbMon`, `DateTime`, `Math`, `String`, `Financial`) and added description notes
   - Revised articles (`ARTICLE_EN.md`, `ARTICLE_FA.md`) to show index-based listing and current packages
   - Fixed mixed-language phrasing in `DbMon/README.md`
 - Fixed package index: removed deprecated `DbSel` from `MsSql/Packages/.sql`

### Fixes
- Corrected broken Markdown code fences and section formatting in `MsSql/README.md` (help section and maintenance examples)
- Fixed project structure tree indentation and package listing in root `README.md`

## 2025-09-29

### Added
- DbMon: `ZzSelectWaitStats`, `ZzSelectTempdbUsage`, `ZzSelectFileStats`
- DbMan: `ZzEnsureSchema`, `ZzEnsureIndex`
- String: `ZzNormalizePersianText`, `ZzConvertDigitsFaEn`
- DateTime: `ZzISOWeekNumber`

### Documentation
- Updated package READMEs (`DbMon`, `DbMan`, `String`, `DateTime`) with new utilities and notes
- Wired new scripts into package indexes (`MsSql/Packages/*/.sql`) for install via `EXEC dbo.Zync 'i <Package>'`

### Tests
- Hardened test scripts under `MsSql/Test`: added guards when Zync or tracking tables are missing and optional smoke checks for new utilities

## 2025-09-27

### Documentation
- Added comprehensive contribution guides:
  - `CONTRIBUTING_FA.md` (Persian)
  - `CONTRIBUTING_EN.md` (English)
- Updated `README.md` to link to dedicated contribution guides.
- Cleaned and standardized package documentation under `MsSql/Packages/*/README.md`:
  - Consistent install commands via `EXEC dbo.Zync ...`
  - Fixed headings and code fences
  - Removed any contribution/development instructions from package docs
- Refined `MsSql/README.md` quick start, usage examples, and added a Contributing links section.
- Replaced duplicated contributing docs under `MsSql/Doc/` with pointers to root guides to keep a single source of truth.

