-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-25
-- Description:	Select all objects (Table,View,Procedure,ScalarFunction,TableValuedFunction) created by user in details
-- =============================================
CREATE OR ALTER VIEW [DBO].[Zz_SelectObjectsDetails]
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



