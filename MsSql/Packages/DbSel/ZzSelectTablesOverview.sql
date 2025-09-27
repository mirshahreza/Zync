/*
EXEC DBO.Zync 'DbUtils/ZzSelectObjectsDetails.sql'
EXEC DBO.Zync 'DbUtils/ZzSelectTablesIndexes.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-27
-- Description:	Provides a summary of all user-created tables, including column count, row count, total space used, and the number of indexes.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectTablesOverview];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectTablesOverview]
AS

SELECT ObjectId,ObjectName, 
	(SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ObjectName) FieldsCount, 
	(SELECT TOP 1 ROWS FROM SYS.SYSINDEXES I WHERE INDID IN (0,1) AND I.Id = ObjectId) RecordsCount,
	ObjectSizes.TotalSpaceInBytes TotalSpaceInBytes,
	(SELECT COUNT(*) FROM ZzSelectTablesIndexes Inds WHERE Inds.ObjectId=ZzSelectObjectsDetails.ObjectId) IndexesCount,
	CreatedOn, UpdatedOn
FROM ZzSelectObjectsDetails
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



