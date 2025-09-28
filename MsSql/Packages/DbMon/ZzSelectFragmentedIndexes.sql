-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Lists all indexes with fragmentation, indicating which need maintenance.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectFragmentedIndexes];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectFragmentedIndexes]
AS
SELECT 
    OBJECT_NAME(ps.object_id) AS TableName,
    i.name AS IndexName,
    ps.index_type_desc,
    ps.avg_fragmentation_in_percent,
    ps.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') AS ps
JOIN sys.indexes AS i ON ps.object_id = i.object_id AND ps.index_id = i.index_id
WHERE ps.avg_fragmentation_in_percent > 10.0
  AND ps.page_count > 100;
