# 🌱 AppEnd Seed Scripts

These scripts populate the `dbo.Common_BaseInfo` table with foundational lookup data. Each category has language-specific scripts to localize the `Title` field.

- **Suffix `.en.sql`**: English titles
- **Suffix `.fa.sql`**: Persian (Farsi) titles
- **Suffix `.ar.sql`**: Arabic titles

Run only **one** language variant per category in your environment. The scripts perform idempotent upserts, so you can safely re-run them or switch languages.

## 📚 Categories

- **General**: Common lookups (e.g., marital status, titles) grouped under a `GEN` root.
- **Gender**: `Male`, `Female`, etc.
- **Geography**: A sample hierarchy of Countries → States/Provinces → Cities.

## 🚀 Usage Examples

Use Zync to deploy a specific seed script.

- **Install English Gender seeds:**
  ```sql
  EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_Gender.en.sql';
  ```
- **Install Persian Geography seeds:**
  ```sql
  EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_Geo.fa.sql';
  ```
- **Install Arabic General seeds:**
  ```sql
  EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_General.ar.sql';
  ```

## 📝 Notes
- These are sample seeds. You can extend them by following the same pattern.
- The scripts use stable `ShortName` codes and link children via `ParentId` to maintain relationships.
