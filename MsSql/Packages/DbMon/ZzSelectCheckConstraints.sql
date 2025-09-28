-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-09-28
-- Description:   Lists all CHECK constraints with their target table/columns, definition, and status.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectCheckConstraints];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectCheckConstraints]
AS
SELECT 
    cc.name                          AS ConstraintName,
    s.name                           AS SchemaName,
    t.name                           AS TableName,
    STUFF((
        SELECT ',' + c.name
        FROM sys.sql_expression_dependencies d
        JOIN sys.columns c 
            ON c.object_id = t.object_id
           AND c.column_id = d.referenced_minor_id
        WHERE d.referencing_id = cc.object_id
          AND d.referenced_id  = t.object_id
          AND d.referenced_minor_id > 0
        GROUP BY c.name, d.referenced_minor_id
        ORDER BY MAX(d.referenced_minor_id)
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS ColumnNames,
    cc.definition                    AS Definition,
    CASE WHEN cc.is_disabled = 0 THEN 1 ELSE 0 END AS IsEnabled,
    o.create_date                    AS CreatedOn,
    o.modify_date                    AS UpdatedOn
FROM sys.check_constraints cc
JOIN sys.objects o ON o.object_id = cc.object_id
JOIN sys.tables t   ON t.object_id = cc.parent_object_id
JOIN sys.schemas s  ON s.schema_id  = t.schema_id;