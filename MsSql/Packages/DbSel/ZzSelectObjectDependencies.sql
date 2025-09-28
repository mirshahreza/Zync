-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-09-28
-- Description:   Lists object-to-object dependencies using sys.sql_expression_dependencies.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectObjectDependencies] WHERE ReferencedObject = 'MyTable';
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectObjectDependencies]
AS
SELECT 
    OBJECT_SCHEMA_NAME(d.referencing_id) AS ReferencingSchema,
    OBJECT_NAME(d.referencing_id)        AS ReferencingObject,
    ro.type_desc                         AS ReferencingObjectType,
    OBJECT_SCHEMA_NAME(d.referenced_id)  AS ReferencedSchema,
    OBJECT_NAME(d.referenced_id)         AS ReferencedObject,
    r.type_desc                          AS ReferencedObjectType
FROM sys.sql_expression_dependencies d
LEFT JOIN sys.objects ro ON ro.object_id = d.referencing_id
LEFT JOIN sys.objects r  ON r.object_id  = d.referenced_id;