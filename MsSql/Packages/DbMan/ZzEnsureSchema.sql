-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:  2025-09-29
-- Description:  Ensures a schema exists; creates it if missing
-- Sample:       EXEC [dbo].[ZzEnsureSchema] @schema = 'logs';
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[ZzEnsureSchema]
    @schema SYSNAME
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = @schema)
    BEGIN
        DECLARE @sql NVARCHAR(MAX) = N'CREATE SCHEMA ' + QUOTENAME(@schema) + N';';
        EXEC sys.sp_executesql @sql;
    END
END
