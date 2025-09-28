-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-09-28
-- Description:   Lists extended properties (e.g., MS_Description) for objects and columns.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectExtendedProperties];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectExtendedProperties]
AS
SELECT 
    s.name                                  AS SchemaName,
    o.name                                  AS ObjectName,
    CASE o.type_desc 
        WHEN 'USER_TABLE' THEN 'Table'
        WHEN 'VIEW' THEN 'View'
        WHEN 'SQL_STORED_PROCEDURE' THEN 'Procedure'
        WHEN 'SQL_SCALAR_FUNCTION' THEN 'ScalarFunction'
        WHEN 'SQL_TABLE_VALUED_FUNCTION' THEN 'TableFunction'
        ELSE o.type_desc END                AS ObjectType,
    c.name                                  AS ColumnName,
    ep.name                                 AS PropertyName,
    CAST(ep.value AS NVARCHAR(MAX))         AS PropertyValue
FROM sys.extended_properties ep
LEFT JOIN sys.objects o ON o.object_id = ep.major_id AND ep.class = 1 -- object or column
LEFT JOIN sys.schemas s ON s.schema_id = o.schema_id
LEFT JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id AND ep.class = 1
WHERE ep.class IN (0,1,3) -- 0: database, 1: object/column, 3: schema
  AND (ep.class <> 0)     -- skip database-level properties to keep the view focused on objects/columns
;