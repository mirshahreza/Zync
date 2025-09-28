-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Shows how indexes are being used (seeks, scans, lookups).
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectIndexUsage];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectIndexUsage]
AS
SELECT 
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates,
    (s.user_seeks + s.user_scans + s.user_lookups) AS TotalReads,
    (s.user_seeks + s.user_scans + s.user_lookups) - s.user_updates AS ReadWriteRatio
FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE s.database_id = DB_ID()
  AND OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1;
