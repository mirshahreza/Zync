-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays all current active sessions on the server.
-- Sample:
-- EXEC [dbo].[ZzSelectActiveSessions];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectActiveSessions]
AS
BEGIN
    SELECT 
        s.session_id,
        s.login_name,
        s.host_name,
        s.program_name,
        s.status,
        c.last_read,
        c.last_write,
        s.login_time,
        s.cpu_time,
        s.memory_usage * 8 AS memory_usage_kb,
        r.command,
        (SELECT TEXT FROM sys.dm_exec_sql_text(c.most_recent_sql_handle)) AS last_sql_text
    FROM sys.dm_exec_sessions s
    LEFT JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
    LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
    WHERE s.is_user_process = 1
    ORDER BY s.login_time;
END
