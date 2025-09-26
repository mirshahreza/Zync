-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-27
-- Description:	Lists all indexes for every table in the database, showing the index name, type (e.g., clustered, non-clustered), and whether it enforces uniqueness.
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectTablesIndexes]
AS

SELECT ZzSelectObjectsDetails.ObjectId ObjectId, ZzSelectObjectsDetails.ObjectName TableName, IndexesT.IndexName,IndexType,IsUnique
FROM ZzSelectObjectsDetails
LEFT OUTER JOIN (
	SELECT OBJECT_ID ObjectId,NAME AS IndexName,TYPE_DESC  AS IndexType,IS_UNIQUE IsUnique
	FROM SYS.INDEXES
	WHERE IS_HYPOTHETICAL = 0 AND INDEX_ID != 0 
	) IndexesT ON IndexesT.ObjectId=ZzSelectObjectsDetails.ObjectId
WHERE ZzSelectObjectsDetails.ObjectType='Table'



