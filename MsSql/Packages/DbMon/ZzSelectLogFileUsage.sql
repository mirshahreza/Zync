-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays log file size and usage statistics for each database.
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectLogFileUsage]
AS
BEGIN
    SELECT 
        db.name AS DatabaseName,
        (total_log_size_in_bytes / 1048576.0) AS TotalLogSizeMB,
        (used_log_space_in_bytes / 1048576.0) AS UsedLogSpaceMB,
        used_log_space_in_percent AS UsedLogSpacePercent
    FROM sys.databases db
    CROSS APPLY sys.dm_db_log_space_usage(db.database_id);
END
