-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-25
-- Description:	A comprehensive view that lists all user-created database objects (Tables, Views, Procedures, Functions) with their names, types, and creation/modification dates.
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectObjectsDetails]
AS

SELECT OBJECT_ID ObjectId, NAME AS ObjectName ,'Table'					ObjectType,	
	CREATE_DATE CreatedOn, MODIFY_DATE UpdatedOn, 1 ViewOrder FROM SYS.OBJECTS WHERE TYPE_DESC='USER_TABLE'
UNION ALL 																			   
SELECT OBJECT_ID ObjectId, NAME AS ObjectName ,'View'					ObjectType,	
	CREATE_DATE CreatedOn, MODIFY_DATE UpdatedOn, 2 ViewOrder FROM SYS.OBJECTS WHERE TYPE_DESC='VIEW'
UNION ALL 																			   
SELECT OBJECT_ID ObjectId, NAME AS ObjectName ,'Procedure'				ObjectType,	
	CREATE_DATE CreatedOn, MODIFY_DATE UpdatedOn, 3 ViewOrder FROM SYS.OBJECTS WHERE TYPE_DESC='SQL_STORED_PROCEDURE'
UNION ALL 																			   
SELECT OBJECT_ID ObjectId, NAME AS ObjectName ,'ScalarFunction'			ObjectType,	
	CREATE_DATE CreatedOn, MODIFY_DATE UpdatedOn, 4 ViewOrder FROM SYS.OBJECTS WHERE TYPE_DESC='SQL_SCALAR_FUNCTION'
UNION ALL 																			   
SELECT OBJECT_ID ObjectId, NAME AS ObjectName ,'TableFunction'	
	ObjectType,	CREATE_DATE CreatedOn, MODIFY_DATE UpdatedOn, 4 ViewOrder FROM SYS.OBJECTS WHERE TYPE_DESC LIKE '%TABLE_VALUED%'



