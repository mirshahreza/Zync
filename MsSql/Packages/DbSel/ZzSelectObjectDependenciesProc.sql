-- Backward-compatible wrapper proc with Select name (optional)
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectObjectDependenciesProc]
    @ObjectName VARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ReferencingSchema,
           ReferencingObject,
           ReferencingObjectType,
           ReferencedSchema,
           ReferencedObject,
           ReferencedObjectType
    FROM [DBO].[ZzSelectObjectDependencies]
    WHERE ReferencedObject = @ObjectName
       OR ReferencingObject = @ObjectName;
END
