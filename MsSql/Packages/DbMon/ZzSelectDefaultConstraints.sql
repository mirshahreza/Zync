-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-09-28
-- Description:   Lists all DEFAULT constraints with their target table/column and default expression.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectDefaultConstraints];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectDefaultConstraints]
AS
SELECT 
    dc.name                 AS ConstraintName,
    s.name                  AS SchemaName,
    t.name                  AS TableName,
    c.name                  AS ColumnName,
    dc.definition           AS DefaultExpression,
    CONVERT(bit, 1)         AS IsEnabled,
    o.create_date           AS CreatedOn,
    o.modify_date           AS UpdatedOn
FROM sys.default_constraints dc
JOIN sys.objects o ON o.object_id = dc.object_id
JOIN sys.columns c ON c.object_id = dc.parent_object_id AND c.column_id = dc.parent_column_id
JOIN sys.tables  t ON t.object_id = dc.parent_object_id
JOIN sys.schemas s ON s.schema_id = t.schema_id;