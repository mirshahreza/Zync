-- =============================================
-- Author:        Zync Contributors
-- Create date:   2026-02-01
-- Description:   Table-valued function returning object-to-object dependencies
--                 based on sys.sql_expression_dependencies.
--
-- Parameters:
--   @ObjectName   NVARCHAR(128)  Optional object name of target object (name-only)
--   @Mode         NVARCHAR(20)   'referenced' | 'referencing' | 'both' (default)
--
-- Notes:
-- - If @ObjectName is NULL, returns all dependencies.
-- - When @Mode = 'referenced', returns objects the target depends on.
-- - When @Mode = 'referencing', returns objects that depend on the target.
-- - When @Mode = 'both', returns union of both directions for the target.
--
-- Samples:
--   SELECT * FROM [dbo].[ZzFnObjectDependencies](N'MyView', N'both');
--   SELECT * FROM [dbo].[ZzFnObjectDependencies](N'MyProc', N'referenced');
--   SELECT * FROM [dbo].[ZzFnObjectDependencies](DEFAULT, N'both'); -- all
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzFnObjectDependencies]
(
    @ObjectName NVARCHAR(128) = NULL,
    @Mode       NVARCHAR(20)  = N'both'
)
RETURNS TABLE
AS
RETURN
WITH target AS (
    SELECT LOWER(@Mode) AS mode_val,
           @ObjectName AS target_name
)
SELECT 
    OBJECT_SCHEMA_NAME(d.referencing_id) AS ReferencingSchema,
    OBJECT_NAME(d.referencing_id)        AS ReferencingObject,
    ro.type_desc                         AS ReferencingObjectType,
    OBJECT_SCHEMA_NAME(d.referenced_id)  AS ReferencedSchema,
    OBJECT_NAME(d.referenced_id)         AS ReferencedObject,
    r.type_desc                          AS ReferencedObjectType
FROM sys.sql_expression_dependencies AS d
LEFT JOIN sys.objects AS ro ON ro.object_id = d.referencing_id
LEFT JOIN sys.objects AS r  ON r.object_id  = d.referenced_id
CROSS JOIN target
WHERE (
    target.target_name IS NULL
    OR (
        (target.mode_val IN (N'both', N'referenced') AND OBJECT_NAME(d.referencing_id) = target.target_name)
        OR (target.mode_val IN (N'both', N'referencing') AND OBJECT_NAME(d.referenced_id) = target.target_name)
    )
);
