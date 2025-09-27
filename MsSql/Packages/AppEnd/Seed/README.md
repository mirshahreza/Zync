# Common_BaseInfo Seed Scripts

These scripts populate `dbo.Common_BaseInfo` with foundational lookup data. Each category has language-specific scripts:

- Suffix `.en.sql` – English titles
- Suffix `.fa.sql` – Persian (Farsi) titles
- Suffix `.ar.sql` – Arabic titles

Run only ONE language variant per environment to localize titles accordingly. Re-running a different language for the same category will update the localized `Title` field for existing rows (idempotent upserts by `ShortName` + `ParentId`).

Categories included:
- General (grouped common lookups under GEN)
- Gender
- Geography (root + sample Countries → States/Provinces → Cities)

Usage examples (via Zync):

- Install English Gender seeds:
  - `EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_Gender.en.sql';`
- Install Persian Geography seeds:
  - `EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_Geo.fa.sql';`

- Install Arabic General seeds (grouped):
  - `EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_General.ar.sql';`

Notes:
- These are sample seeds. Extend them by following the same pattern: use stable `ShortName` codes and link children via `ParentId`.
- The General seeds create a `GEN` root, then categories (e.g., `TITLES`, `MARITAL`, `LANG`) and their items. If you run both standalone Gender and General, the Gender section under `GEN` will update its localized titles consistently.
