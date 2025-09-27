# Changelog

All notable changes to this project will be documented in this file.

## 2025-09-28

### Documentation
- Documented the database-to-package generator script in development guides:
  - Updated `MsSql/Doc/CONTRIBUTING_FA.md` with a new section on using `scripts/GenerateZyncPackageFromDb.ps1`
  - Updated `MsSql/Doc/CONTRIBUTING_EN.md` with the English counterpart
- Added `scripts/README.md` with usage, parameters, example, outputs, and troubleshooting for the generator script

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

