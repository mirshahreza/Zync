-- =============================================
-- Author:       Zync
-- Create date:  2025-09-29
-- Description:  TempDB space usage by session and internal objects
-- Sample:       SELECT * FROM [dbo].[ZzSelectTempdbUsage];
-- Notes:        Requires VIEW SERVER STATE permission
-- =============================================
CREATE OR ALTER VIEW [dbo].[ZzSelectTempdbUsage]
AS
SELECT
    s.session_id,
    s.login_name,
    r.status,
    tsu.user_objects_alloc_page_count,
    tsu.user_objects_dealloc_page_count,
    tsu.internal_objects_alloc_page_count,
    tsu.internal_objects_dealloc_page_count,
    (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count) * 8 AS user_kb,
    (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) * 8 AS internal_kb
FROM sys.dm_db_task_space_usage AS tsu
JOIN sys.dm_exec_requests AS r ON tsu.request_id = r.request_id AND tsu.session_id = r.session_id
JOIN sys.dm_exec_sessions AS s ON s.session_id = tsu.session_id;
