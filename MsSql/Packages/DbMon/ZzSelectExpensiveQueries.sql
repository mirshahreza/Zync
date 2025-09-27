-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Identifies the most resource-intensive queries on the database.
-- Sample:
-- EXEC [dbo].[ZzSelectExpensiveQueries];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectExpensiveQueries]
AS
BEGIN
    SELECT TOP 50
        qs.total_worker_time / qs.execution_count AS AvgCPUTime,
        qs.total_elapsed_time / qs.execution_count AS AvgElapsedTime,
        qs.total_logical_reads / qs.execution_count AS AvgLogicalReads,
        qs.execution_count,
        SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
            ((CASE qs.statement_end_offset
                WHEN -1 THEN DATALENGTH(st.text)
                ELSE qs.statement_end_offset
             END - qs.statement_start_offset)/2) + 1) AS QueryText,
        DB_NAME(st.dbid) AS DatabaseName,
        st.objectid AS ObjectId
    FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
    ORDER BY AvgCPUTime DESC;
END
