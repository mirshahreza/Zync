-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays log file size and usage statistics for each database.
-- Sample:
-- EXEC [dbo].[ZzSelectLogFileUsage];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectLogFileUsage]
AS
BEGIN
    SET NOCOUNT ON;

    /*
        Notes:
        - sys.dm_db_log_space_usage returns data only for the CURRENT database and is a DMV (no parameters).
          The previous implementation incorrectly tried to pass database_id to it via CROSS APPLY, causing
          "is not a function" errors on many SQL Server versions.
        - For SQL Server 2019+ (major version 15+), sys.dm_db_log_stats(database_id) safely returns per-db
          log statistics. We use it when available.
        - For older versions, we fall back to DBCC SQLPERF(LOGSPACE), which provides per-db log size (MB)
          and used percent. We compute used MB accordingly.
    */

    DECLARE @majorVersion int = TRY_CAST(PARSENAME(CONVERT(varchar(50), SERVERPROPERTY('ProductVersion')), 4) AS int);

    IF (@majorVersion IS NOT NULL AND @majorVersion >= 15)
    BEGIN
        -- SQL Server 2019+ : use sys.dm_db_log_stats(database_id)
        SELECT 
            db.name AS DatabaseName,
            (ls.total_log_size_in_bytes / 1048576.0) AS TotalLogSizeMB,
            (ls.used_log_space_in_bytes / 1048576.0) AS UsedLogSpaceMB,
            ls.used_log_space_in_percent AS UsedLogSpacePercent
        FROM sys.databases AS db
        CROSS APPLY sys.dm_db_log_stats(db.database_id) AS ls
        WHERE db.state_desc = 'ONLINE'
        ORDER BY db.name;
    END
    ELSE
    BEGIN
        -- Older SQL Server versions: fall back to DBCC SQLPERF(LOGSPACE)
        CREATE TABLE #logspace
        (
            DatabaseName sysname,
            LogSizeMB    float,
            LogSpaceUsedPercent float,
            Status       int
        );

        INSERT INTO #logspace
        EXEC ('DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS');

        SELECT 
            ls.DatabaseName,
            ls.LogSizeMB AS TotalLogSizeMB,
            (ls.LogSizeMB * (ls.LogSpaceUsedPercent / 100.0)) AS UsedLogSpaceMB,
            ls.LogSpaceUsedPercent AS UsedLogSpacePercent
        FROM #logspace AS ls
        INNER JOIN sys.databases AS db
            ON db.name = ls.DatabaseName
        WHERE db.state_desc = 'ONLINE'
        ORDER BY ls.DatabaseName;

        DROP TABLE #logspace;
    END
END
