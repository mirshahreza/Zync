-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies database users that do not have a corresponding server login.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectOrphanedUsers];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectOrphanedUsers]
AS
SELECT 
    dp.name        AS UserName,
    dp.type_desc   AS UserType,
    dp.authentication_type_desc AS AuthenticationType,
    dp.default_schema_name      AS DefaultSchema,
    dp.sid
FROM sys.database_principals AS dp
LEFT JOIN sys.server_principals  AS sp
    ON dp.sid = sp.sid
WHERE dp.principal_id > 4 -- skip dbo/guest/sys/etc.
  AND dp.sid IS NOT NULL
  AND dp.type IN ('S','U','G') -- SQL user, Windows user, Windows group
  AND dp.authentication_type <> 2 -- exclude contained db users
  AND sp.sid IS NULL;
