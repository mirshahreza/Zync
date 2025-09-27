-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays the current status of all SQL Server Agent jobs.
-- Sample:
-- EXEC [dbo].[ZzSelectAgentJobsStatus];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectAgentJobsStatus]
AS
BEGIN
    SELECT 
        j.name AS JobName,
        CASE 
            WHEN jh.run_status = 0 THEN 'Failed'
            WHEN jh.run_status = 1 THEN 'Succeeded'
            WHEN jh.run_status = 2 THEN 'Retry'
            WHEN jh.run_status = 3 THEN 'Canceled'
            WHEN jh.run_status = 4 THEN 'In Progress'
            ELSE 'Unknown'
        END AS LastRunStatus,
        msdb.dbo.agent_datetime(jh.run_date, jh.run_time) AS LastRunDateTime
    FROM msdb.dbo.sysjobs j
    INNER JOIN msdb.dbo.sysjobhistory jh ON j.job_id = jh.job_id
    WHERE jh.step_id = 0 -- Job outcome
    AND jh.instance_id = (
        SELECT MAX(instance_id) 
        FROM msdb.dbo.sysjobhistory 
        WHERE job_id = j.job_id
    )
    ORDER BY j.name;
END
