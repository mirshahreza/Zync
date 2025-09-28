-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays log file size and usage statistics for each database.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectLogFileUsage];
-- Note: Requires SQL Server 2019+ (sys.dm_db_log_stats)
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectLogFileUsage]
AS
SELECT 
    db.name AS DatabaseName,
    CAST(ls.total_log_size_mb AS decimal(19,2)) AS TotalLogSizeMB,
    CAST(ls.active_log_size_mb AS decimal(19,2)) AS UsedLogSpaceMB,
    CAST(CASE WHEN ls.total_log_size_mb > 0 THEN (ls.active_log_size_mb / ls.total_log_size_mb) * 100.0 ELSE 0 END AS decimal(5,2)) AS UsedLogSpacePercent
FROM sys.databases AS db
CROSS APPLY sys.dm_db_log_stats(db.database_id) AS ls
WHERE db.state_desc = 'ONLINE';
