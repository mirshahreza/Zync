-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies queries that are currently running for a long time.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectLongRunningQueries]; -- default threshold: > 60 seconds
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectLongRunningQueries]
AS
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
  AND DATEDIFF(SECOND, r.start_time, GETDATE()) > 60;
