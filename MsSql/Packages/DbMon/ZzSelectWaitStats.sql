-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:  2025-09-29
-- Description:  Aggregated wait statistics with categories and percentages
-- Sample:       SELECT * FROM [dbo].[ZzSelectWaitStats];
-- Notes:        Requires VIEW SERVER STATE permission
-- =============================================
CREATE OR ALTER VIEW [dbo].[ZzSelectWaitStats]
AS
SELECT
    ws.wait_type,
    ws.waiting_tasks_count,
    ws.wait_time_ms,
    ws.signal_wait_time_ms,
    (ws.wait_time_ms - ws.signal_wait_time_ms) AS resource_wait_time_ms,
    CAST(ws.wait_time_ms * 1.0 / NULLIF(SUM(ws.wait_time_ms) OVER (), 0) AS DECIMAL(9,4)) AS wait_time_pct,
    CASE
        WHEN ws.wait_type LIKE 'PAGEIOLATCH%' OR ws.wait_type LIKE 'IO_COMPLETION' THEN 'IO'
        WHEN ws.wait_type LIKE 'LCK_M_%' THEN 'LOCK'
        WHEN ws.wait_type LIKE 'LATCH_%' THEN 'LATCH'
        WHEN ws.wait_type LIKE 'CXPACKET' OR ws.wait_type LIKE 'CXCONSUMER' THEN 'CPU/Parallelism'
        WHEN ws.wait_type LIKE 'SOS_SCHEDULER_YIELD' THEN 'CPU'
        WHEN ws.wait_type LIKE 'RESOURCE_SEMAPHORE%' THEN 'MEMORY'
        WHEN ws.wait_type LIKE 'THREADPOOL' THEN 'THREADPOOL'
        WHEN ws.wait_type LIKE 'WRITELOG' THEN 'LOG'
        ELSE 'OTHER'
    END AS wait_category
FROM sys.dm_os_wait_stats AS ws
WHERE ws.wait_type NOT IN (
    'SLEEP_TASK','SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH','BROKER_TASK_STOP',
    'CLR_AUTO_EVENT','CLR_MANUAL_EVENT','LAZYWRITER_SLEEP','SLEEP_BPOOL_FLUSH',
    'XE_TIMER_EVENT','XE_DISPATCHER_WAIT','BROKER_TO_FLUSH','BROKER_EVENTHANDLER',
    'DISPATCHER_QUEUE_SEMAPHORE','FT_IFTS_SCHEDULER_IDLE_WAIT','FT_IFTSHC_MUTEX',
    'HADR_FILESTREAM_IOMGR_IOCOMPLETION','HADR_LOGCAPTURE_WAIT','HADR_NOTIFICATION_DEQUEUE',
    'HADR_TIMER_TASK','HADR_WORK_QUEUE','KSOURCE_WAKEUP','LOGMGR_QUEUE','ONDEMAND_TASK_QUEUE',
    'REQUEST_FOR_DEADLOCK_SEARCH','RESOURCE_QUEUE','SERVER_IDLE_CHECK','SP_SERVER_DIAGNOSTICS_SLEEP');
