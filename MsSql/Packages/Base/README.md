# 📦 Base Package

The `Base` package contains core tables commonly used for user, role, and general metadata management. These objects were generated from an existing database and organized as a Zync package.

## 🚀 Deployment

Install the entire package:
```sql
EXEC dbo.Zync 'i Base'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Base/.sql'
```

Install a single item (example):
```sql
EXEC dbo.Zync 'i Base/BaseUser.sql'
```

## 📜 Included Objects (Tables)
- BaseUser
- BaseUserAttribute
- BaseRole
- BaseActivityLog
- BaseUserRole
- BaseRolesAttributes
- BasePerson
- BaseInfo

## 📝 Notes
- Tables are scripted without foreign keys by default. The self-referencing FK for `BaseInfo.ParentId` is embedded in `BaseInfo.sql`.
- The package index (`.sql`) orders installs to avoid dependency issues.
- You can customize or extend these scripts as needed for your environment.
