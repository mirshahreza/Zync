-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Shows the backup history for databases.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectBackupHistory];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectBackupHistory]
AS
SELECT 
    s.database_name,
    m.physical_device_name,
    CAST(CAST(s.backup_size AS INT) / 1048576 AS VARCHAR(10)) + ' MB' AS backup_size,
    s.backup_start_date,
    s.backup_finish_date,
    s.expiration_date,
    CASE s.type
        WHEN 'D' THEN 'Database'
        WHEN 'L' THEN 'Log'
        ELSE 'Other'
    END AS backup_type
FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id;
