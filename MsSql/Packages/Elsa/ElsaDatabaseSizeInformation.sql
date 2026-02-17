-- ==================================================================================
-- Elsa Database Size Information
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaDatabaseSizeInformation] AS
SELECT 
    OBJECT_NAME(i.object_id) AS [TableName],
    SUM(s.row_count) AS [RowCount],
    SUM(s.reserved_page_count * 8) / 1024 AS [SizeKB]
FROM sys.dm_db_partition_stats s
INNER JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE OBJECT_NAME(i.object_id) LIKE 'Elsa%'
    AND (i.type_desc = 'HEAP' OR i.type_desc = 'CLUSTERED INDEX')
GROUP BY OBJECT_NAME(i.object_id)
ORDER BY [SizeKB] DESC;
