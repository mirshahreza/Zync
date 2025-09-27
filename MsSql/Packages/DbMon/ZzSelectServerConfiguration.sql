-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays important server-level configuration settings.
-- Sample:
-- EXEC [dbo].[ZzSelectServerConfiguration];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectServerConfiguration]
AS
BEGIN
    SELECT 
        name,
        value,
        value_in_use,
        description
    FROM sys.configurations
    ORDER BY name;
END
