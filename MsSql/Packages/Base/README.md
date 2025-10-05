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
- **BaseUser** - User accounts table
- **BaseUserAttribute** - Custom user attributes
- **BaseRole** - Roles/permissions table
- **BaseActivityLog** - Activity logging
- **BaseUserRole** - User-Role mapping
- **BaseRolesAttribute** - Role attributes
- **BasePerson** - Person information
- **BaseInfo** - General information/metadata
- **BaseSeedData** - Initial data seeding script

## 🌱 Initial Seed Data

The package automatically inserts initial data when installed:

### Default Roles:
- **Developer** - Software developer with full system access
- **BackOfficer** - Back office staff with administrative access

### Default User:
- **Username:** `admin`
- **Password:** `Admin@123` 
- **Role:** Developer
- ⚠️ **IMPORTANT:** Change the password immediately after first login!

The seed data script (`BaseSeedData.sql`) runs after table creation and:
- Creates the roles with `IsBuiltIn = 1`
- Creates an admin user with ID 100000
- Creates a person record linked to the admin user
- Assigns the Developer role to the admin user

To manually run seed data:
```sql
EXEC dbo.Zync 'i Base/BaseSeedData.sql'
```

Or execute directly:
```sql
-- From local file
sqlcmd -S YourServer -d YourDatabase -E -i "BaseSeedData.sql"
```

## 📝 Notes
- Tables are scripted without foreign keys by default. The self-referencing FK for `BaseInfo.ParentId` is embedded in `BaseInfo.sql`.
- The package index (`.sql`) orders installs to avoid dependency issues.
- Seed data uses `CreatedBy = 0` as the system user ID
- Password is stored as SHA-256 hash
- You can customize or extend these scripts as needed for your environment.
