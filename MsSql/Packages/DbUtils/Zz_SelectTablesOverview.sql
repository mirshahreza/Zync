/*
EXEC Zzz_Deploy 'DbUtils/Zz_SelectObjectsDetails.sql'
EXEC Zzz_Deploy 'DbUtils/Zz_SelectTablesIndexes.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-27
-- Description:	Select all tables with some quick statistics created by user in details
-- =============================================
CREATE OR ALTER VIEW [DBO].[Zz_SelectTablesOverview]
AS

SELECT ObjectId,ObjectName, 
	(SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ObjectName) FieldsCount, 
	(SELECT TOP 1 ROWS FROM SYS.SYSINDEXES I WHERE INDID IN (0,1) AND I.Id = ObjectId) RecordsCount,
	ObjectSizes.TotalSpaceInBytes TotalSpaceInBytes,
	(SELECT COUNT(*) FROM Zz_SelectTablesIndexes Inds WHERE Inds.ObjectId=Zz_SelectObjectsDetails.ObjectId) IndexesCount,
	CreatedOn, UpdatedOn
FROM Zz_SelectObjectsDetails
LEFT OUTER JOIN 
	(
	SELECT T.NAME AS TableName,(SUM(A.TOTAL_PAGES) * 8) AS TotalSpaceInBytes
	FROM SYS.TABLES T
	INNER JOIN SYS.INDEXES I ON T.OBJECT_ID = I.OBJECT_ID
	INNER JOIN SYS.PARTITIONS P ON I.OBJECT_ID = P.OBJECT_ID AND I.INDEX_ID = P.INDEX_ID
	INNER JOIN SYS.ALLOCATION_UNITS A ON P.PARTITION_ID = A.CONTAINER_ID
	AND T.IS_MS_SHIPPED = 0
	GROUP BY T.NAME
	) ObjectSizes ON ObjectSizes.TableName=ObjectName
WHERE ObjectType='Table'



