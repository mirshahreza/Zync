-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Lists all users, roles, and their specific database permissions.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectDatabasePermissions];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectDatabasePermissions]
AS
SELECT 
    dp.principal_id,
    dp.name AS PrincipalName,
    dp.type_desc AS PrincipalType,
    p.class_desc,
    OBJECT_NAME(p.major_id) AS ObjectName,
    p.permission_name,
    p.state_desc AS PermissionState
FROM sys.database_permissions AS p
JOIN sys.database_principals AS dp ON p.grantee_principal_id = dp.principal_id
WHERE p.major_id >= 0;
