-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Shows the data and log file growth history for databases.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectDatabaseGrowth];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectDatabaseGrowth]
AS
SELECT
    DB_NAME(database_id) AS DatabaseName,
    type_desc AS FileType,
    name AS LogicalFileName,
    physical_name AS PhysicalFileName,
    (size * 8.0 / 1024) AS SizeMB,
    (FILEPROPERTY(name, 'SpaceUsed') * 8.0 / 1024) AS SpaceUsedMB,
    (growth * 8.0 / 1024) AS GrowthMB
FROM sys.master_files;
