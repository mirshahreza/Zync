-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Suggests new indexes based on query workload to improve performance.
-- Sample:
-- EXEC [dbo].[ZzSelectMissingIndexes];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectMissingIndexes]
AS
BEGIN
    SELECT 
        mid.statement AS TableName,
        migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) AS ImprovementMeasure,
        'CREATE INDEX [IX_' + OBJECT_NAME(mid.object_id) + '_' + REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns, ''), ', ', '_'), '[', ''), ']', '') + ']'
        + ' ON ' + mid.statement 
        + ' (' + ISNULL(mid.equality_columns, '') 
        + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END 
        + ISNULL(mid.inequality_columns, '')
        + ')' 
        + ISNULL(' INCLUDE (' + mid.included_columns + ')', '') AS CreateIndexStatement
    FROM sys.dm_db_missing_index_groups mig
    INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
    INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
    WHERE migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
    ORDER BY ImprovementMeasure DESC;
END
