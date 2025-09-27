-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-07-12
-- Description:	Finds and lists all database objects that have a dependency on a specified object.
-- Sample:
-- EXEC [dbo].[ZzGetObjectDependencies] @ObjectName = 'MyTable';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzGetObjectDependencies]
	@ObjectName VARCHAR(128)
AS

BEGIN

	SELECT 
		OBJECT_NAME(referencing_id) AS ReferencingObject,
		o.type_desc AS ReferencingObjectType
	FROM sys.sql_expression_dependencies d
	JOIN sys.objects o ON d.referencing_id = o.object_id
	WHERE referenced_id = OBJECT_ID(@ObjectName);

END