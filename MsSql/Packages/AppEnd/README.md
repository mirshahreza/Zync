# 📦 AppEnd Package

The `AppEnd` package provides a foundational framework for building applications, including user management, role-based access control (RBAC), and activity logging.

## 🚀 Deployment

### Deploy All Scripts
To deploy all scripts in the `AppEnd` package, run the following command:
```sql
EXEC dbo.Zync 'i AppEnd'
```
Alternatively, you can use:
```sql
EXEC dbo.Zync 'i AppEnd/.sql'
```

## 📜 Scripts

This package contains the following scripts:
- `Common_ActivityLog.sql`: Table and procedures for logging user activities.
- `Common_BaseInfo.sql`: Core lookup table for storing hierarchical data.
- `Common_Roles_Attributes.sql`: Manages attributes for roles.
- `Common_Roles.sql`: Core table for defining user roles.
- `Common_Users_Attributes.sql`: Manages attributes for users.
- `Common_Users_Roles.sql`: Maps users to roles.
- `Common_Users.sql`: Core table for managing users.

For more information on seeding initial data, see the [Seed README](Seed/README.md).
