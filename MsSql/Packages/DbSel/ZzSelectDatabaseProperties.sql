-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays various properties for all databases on the server.
-- Sample:
-- EXEC [dbo].[ZzSelectDatabaseProperties];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectDatabaseProperties]
AS
BEGIN
    SELECT 
        name,
        database_id,
        create_date,
        collation_name,
        recovery_model_desc,
        compatibility_level,
        is_read_only,
        is_auto_close_on,
        is_auto_shrink_on,
        state_desc
    FROM sys.databases
    ORDER BY name;
END
