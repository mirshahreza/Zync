-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-09-28
-- Description:   Lists Primary Keys and Unique Constraints with their columns and status.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectUniqueAndPKConstraints];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectUniqueAndPKConstraints]
AS
WITH cols AS (
    SELECT 
        kc.object_id,
        ic.key_ordinal,
        c.name AS ColumnName
    FROM sys.key_constraints kc
    JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id
    JOIN sys.columns c ON c.object_id = kc.parent_object_id AND c.column_id = ic.column_id
)
SELECT 
    CASE WHEN kc.type = 'PK' THEN 'PK' ELSE 'Unique' END AS ConstraintType,
    kc.name                      AS ConstraintName,
    sch.name                     AS SchemaName,
    t.name                       AS TableName,
    STUFF((SELECT ',' + c2.ColumnName FROM cols c2 WHERE c2.object_id = kc.object_id ORDER BY c2.key_ordinal FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS Columns,
    CASE WHEN i.is_disabled = 0 THEN 1 ELSE 0 END AS IsEnabled,
    o.create_date                AS CreatedOn,
    o.modify_date                AS UpdatedOn
FROM sys.key_constraints kc
JOIN sys.objects o ON o.object_id = kc.object_id
JOIN sys.tables  t  ON t.object_id = kc.parent_object_id
JOIN sys.schemas sch ON sch.schema_id = t.schema_id
JOIN sys.indexes i ON i.object_id = kc.parent_object_id AND i.index_id = kc.unique_index_id;