-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Details all foreign key relationships, showing the constraint name, the source table and column, and the target table and column.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectTablesFks];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectTablesFks]
AS

SELECT	[FKs].[NAME] FkName,
		OBJECT_NAME(FKs.PARENT_OBJECT_ID) TableName,
		COL_NAME(FKColumns.PARENT_OBJECT_ID,FKColumns.PARENT_COLUMN_ID) ColumnName,
		RefTables.[NAME] TargetTable,RefColumns.[NAME] TargetColumn,
	CASE WHEN [FKs].is_disabled = 0 THEN 1 ELSE 0 END AS EnforceRelation
FROM 
   SYS.FOREIGN_KEYS AS FKs
LEFT OUTER JOIN SYS.FOREIGN_KEY_COLUMNS FKColumns ON FKs.OBJECT_ID = FKColumns.CONSTRAINT_OBJECT_ID
LEFT OUTER JOIN SYS.TABLES RefTables ON RefTables.OBJECT_ID = FKColumns.REFERENCED_OBJECT_ID
LEFT OUTER JOIN SYS.COLUMNS RefColumns ON RefColumns.COLUMN_ID = FKColumns.CONSTRAINT_COLUMN_ID AND RefColumns.OBJECT_ID = FKColumns.REFERENCED_OBJECT_ID
WHERE [FKs].[type]='F' 
