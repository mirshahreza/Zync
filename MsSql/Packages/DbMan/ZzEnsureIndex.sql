-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:  2025-09-29
-- Description:  Creates a nonclustered index if it doesn't exist (with INCLUDE/WHERE support)
-- Sample:
-- EXEC [dbo].[ZzEnsureIndex]
--     @schema = 'dbo',
--     @table = 'Orders',
--     @indexName = 'IX_Orders_CreatedAt',
--     @columns = 'CreatedAt DESC',
--     @include = 'CustomerId, Status',
--     @where = 'Status <> 0';
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[ZzEnsureIndex]
    @schema     SYSNAME,
    @table      SYSNAME,
    @indexName  SYSNAME,
    @columns    NVARCHAR(MAX),
    @include    NVARCHAR(MAX) = NULL,
    @where      NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fullTable NVARCHAR(517) = QUOTENAME(@schema) + N'.' + QUOTENAME(@table);

    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes i
        JOIN sys.objects o ON o.object_id = i.object_id
        JOIN sys.schemas s ON s.schema_id = o.schema_id
        WHERE s.name = @schema AND o.name = @table AND i.name = @indexName
    )
    BEGIN
        DECLARE @sql NVARCHAR(MAX) = N'CREATE NONCLUSTERED INDEX ' + QUOTENAME(@indexName)
            + N' ON ' + @fullTable + N' (' + @columns + N')';

        IF @include IS NOT NULL AND LTRIM(RTRIM(@include)) <> ''
            SET @sql += N' INCLUDE (' + @include + N')';

        IF @where IS NOT NULL AND LTRIM(RTRIM(@where)) <> ''
            SET @sql += N' WHERE ' + @where;

        EXEC sys.sp_executesql @sql;
    END
END
