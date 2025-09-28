-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies the most resource-intensive queries on the database.
-- Sample:
-- SELECT TOP 50 * FROM [dbo].[ZzSelectExpensiveQueries];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectExpensiveQueries]
AS
SELECT 
    qs.total_worker_time / NULLIF(qs.execution_count,0) AS AvgCPUTime,
    qs.total_elapsed_time / NULLIF(qs.execution_count,0) AS AvgElapsedTime,
    qs.total_logical_reads / NULLIF(qs.execution_count,0) AS AvgLogicalReads,
    qs.execution_count,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS QueryText,
    DB_NAME(st.dbid) AS DatabaseName,
    st.objectid AS ObjectId
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st;
