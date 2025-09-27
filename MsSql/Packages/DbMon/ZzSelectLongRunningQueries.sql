-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies queries that are currently running for a long time.
-- Sample:
-- EXEC [dbo].[ZzSelectLongRunningQueries] @MinDurationSeconds = 60;
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectLongRunningQueries]
    @MinDurationSeconds INT = 60
AS
BEGIN
    SELECT
        r.session_id,
        r.status,
        r.start_time,
        DATEDIFF(SECOND, r.start_time, GETDATE()) AS duration_seconds,
        st.text AS sql_text,
        r.cpu_time,
        r.total_elapsed_time,
        r.reads,
        r.writes,
        r.logical_reads
    FROM sys.dm_exec_requests r
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st
    WHERE r.session_id <> @@SPID
    AND DATEDIFF(SECOND, r.start_time, GETDATE()) > @MinDurationSeconds
    ORDER BY duration_seconds DESC;
END
