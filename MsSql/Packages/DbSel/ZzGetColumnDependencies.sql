-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Finds and lists all database objects (procedures, views, functions) that have a dependency on a specific table column.
-- Sample:
-- EXEC [dbo].[ZzGetColumnDependencies] @TableName = 'MyTable', @ColumnName = 'MyColumn';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzGetColumnDependencies]
    @TableName NVARCHAR(128),
    @ColumnName NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        OBJECT_SCHEMA_NAME(d.referencing_id) AS [SchemaName],
        OBJECT_NAME(d.referencing_id) AS [ObjectName],
        o.type_desc AS [ObjectType]
    FROM 
        sys.sql_expression_dependencies d
    JOIN 
        sys.objects o ON d.referencing_id = o.object_id
    WHERE 
        d.referenced_id = OBJECT_ID(@TableName)
        AND d.referenced_minor_id = (
            SELECT column_id 
            FROM sys.columns 
            WHERE name = @ColumnName 
            AND object_id = OBJECT_ID(@TableName)
        );

END
