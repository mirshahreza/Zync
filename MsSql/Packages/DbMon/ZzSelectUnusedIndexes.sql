-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies indexes with low or no usage.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectUnusedIndexes];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectUnusedIndexes]
AS
SELECT 
    o.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates
FROM sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id AND ius.database_id = DB_ID()
WHERE o.type = 'U' -- User tables
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
AND (ius.user_seeks = 0 AND ius.user_scans = 0 AND ius.user_lookups = 0);
