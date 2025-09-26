-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-27
-- Description:	Select all tables with all indexes
-- =============================================
CREATE OR ALTER VIEW [DBO].[Zz_SelectTablesIndexes]
AS

SELECT Zz_SelectObjectsDetails.ObjectId ObjectId, Zz_SelectObjectsDetails.ObjectName TableName, IndexesT.IndexName,IndexType,IsUnique
FROM Zz_SelectObjectsDetails
LEFT OUTER JOIN (
	SELECT OBJECT_ID ObjectId,NAME AS IndexName,TYPE_DESC  AS IndexType,IS_UNIQUE IsUnique
	FROM SYS.INDEXES
	WHERE IS_HYPOTHETICAL = 0 AND INDEX_ID != 0 
	) IndexesT ON IndexesT.ObjectId=Zz_SelectObjectsDetails.ObjectId
WHERE Zz_SelectObjectsDetails.ObjectType='Table'



