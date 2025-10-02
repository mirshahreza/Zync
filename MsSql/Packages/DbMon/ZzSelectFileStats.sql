-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:  2025-09-29
-- Description:  File I/O stats and sizes per database file
-- Sample:       SELECT * FROM [dbo].[ZzSelectFileStats];
-- Notes:        Requires VIEW SERVER STATE permission
-- =============================================
CREATE OR ALTER VIEW [dbo].[ZzSelectFileStats]
AS
SELECT
    DB_NAME(vfs.database_id) AS database_name,
    mf.file_id,
    mf.type_desc,
    mf.physical_name,
    (vfs.num_of_reads) AS num_reads,
    (vfs.io_stall_read_ms) AS read_stall_ms,
    (vfs.num_of_writes) AS num_writes,
    (vfs.io_stall_write_ms) AS write_stall_ms,
    CASE WHEN vfs.num_of_reads > 0 THEN vfs.io_stall_read_ms * 1.0 / vfs.num_of_reads ELSE NULL END AS avg_read_ms,
    CASE WHEN vfs.num_of_writes > 0 THEN vfs.io_stall_write_ms * 1.0 / vfs.num_of_writes ELSE NULL END AS avg_write_ms,
    (mf.size * 8.0) AS size_kb,
    ((mf.size - mf.used_pages) * 8.0) AS free_kb
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
JOIN sys.master_files AS mf
  ON vfs.database_id = mf.database_id AND vfs.file_id = mf.file_id;
