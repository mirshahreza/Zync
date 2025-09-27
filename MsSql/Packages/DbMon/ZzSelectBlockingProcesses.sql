-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies processes that are causing blocking on other processes.
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectBlockingProcesses]
AS
BEGIN
    SELECT
        db.name AS DBName,
        tl.request_session_id AS BlockingSessionID,
        es.host_name AS BlockingHost,
        es.login_name AS BlockingUser,
        tl.resource_type AS ResourceType,
        tl.resource_description AS ResourceDescription,
        tl.request_mode AS RequestMode,
        tl.request_status AS RequestStatus,
        wt.wait_duration_ms AS WaitDurationMs,
        (SELECT TEXT FROM sys.dm_exec_sql_text(ec.most_recent_sql_handle)) AS BlockingSQL
    FROM sys.dm_tran_locks AS tl
    INNER JOIN sys.databases db ON tl.resource_database_id = db.database_id
    INNER JOIN sys.dm_os_waiting_tasks AS wt ON tl.lock_owner_address = wt.resource_address
    INNER JOIN sys.dm_exec_sessions AS es ON tl.request_session_id = es.session_id
    INNER JOIN sys.dm_exec_connections AS ec ON tl.request_session_id = ec.session_id
    WHERE tl.request_status = 'WAIT'
    ORDER BY wt.wait_duration_ms DESC;
END
