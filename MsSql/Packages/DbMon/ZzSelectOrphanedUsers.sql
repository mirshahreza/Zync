-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies database users that do not have a corresponding server login.
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectOrphanedUsers]
AS
BEGIN
    EXEC sp_change_users_login 'Report';
END
