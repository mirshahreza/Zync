-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-09-28
-- Description:   Lists all IDENTITY columns with seed, increment, and current identity value.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectIdentityColumns];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectIdentityColumns]
AS
SELECT 
    s.name                              AS SchemaName,
    t.name                              AS TableName,
    c.name                              AS ColumnName,
    CAST(IDENT_SEED(QUOTENAME(s.name)+'.'+QUOTENAME(t.name)) AS DECIMAL(38,0))     AS Seed,
    CAST(IDENT_INCR(QUOTENAME(s.name)+'.'+QUOTENAME(t.name)) AS DECIMAL(38,0))     AS Increment,
    CAST(IDENT_CURRENT(QUOTENAME(s.name)+'.'+QUOTENAME(t.name)) AS DECIMAL(38,0))  AS CurrentIdentityValue,
    ty.name                             AS DataType,
    o.create_date                       AS CreatedOn,
    o.modify_date                       AS UpdatedOn
FROM sys.columns c
JOIN sys.tables t   ON t.object_id = c.object_id
JOIN sys.schemas s  ON s.schema_id = t.schema_id
JOIN sys.types ty   ON ty.user_type_id = c.user_type_id
JOIN sys.objects o  ON o.object_id = t.object_id
WHERE c.is_identity = 1;