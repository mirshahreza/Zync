/*
DbMon/ZzSelectObjectsDetails.sql
DbMon/ZzSelectTablesViewsColumns.sql
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2026-01-02
-- Description:	A view to show all objects plus columns
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectObjectsAll];
-- =============================================
CREATE OR ALTER OR ALTER VIEW [DBO].[ZzSelectObjectsAll]
AS
	
SELECT 
	CAST(ObjectId AS VARCHAR(16)) FinalId, ObjectType , ObjectName , NULL DataType , CreatedOn , UpdatedOn
FROM ZzSelectObjectsDetails

UNION ALL

SELECT 
	CAST(ObjectId AS VARCHAR(16))+'-' +CAST(ColumnId AS VARCHAR(16)) FinalId , 'Column' AS ObjectType , ColumnName ObjectName , ColumnType DataType ,NULL CreatedOn , NULL UpdatedOn
FROM ZzSelectTablesViewsColumns

	
