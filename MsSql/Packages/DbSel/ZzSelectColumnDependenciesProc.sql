-- Backward-compatible wrapper proc with Select name (optional)
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectColumnDependenciesProc]
    @TableName NVARCHAR(128),
    @ColumnName NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        ReferencingSchema AS [SchemaName],
        ReferencingObject AS [ObjectName],
        ReferencingObjectType AS [ObjectType]
    FROM [DBO].[ZzSelectColumnDependencies]
    WHERE ReferencedObject = @TableName
      AND ReferencedColumn = @ColumnName;
END
