-- =============================================
-- Verify that all DbMon ZzSelect* objects are views (not procedures)
-- =============================================
PRINT 'Verifying DbMon ZzSelect* objects are views...';

;WITH DbMonViews AS (
    SELECT 'ZzSelectActiveSessions'   AS Name UNION ALL
    SELECT 'ZzSelectAgentJobsStatus'  UNION ALL
    SELECT 'ZzSelectBackupHistory'    UNION ALL
    SELECT 'ZzSelectBlockingProcesses' UNION ALL
    SELECT 'ZzSelectCheckConstraints'  UNION ALL
    SELECT 'ZzSelectColumnDependencies' UNION ALL
    SELECT 'ZzSelectDatabaseGrowth'    UNION ALL
    SELECT 'ZzSelectDatabasePermissions' UNION ALL
    SELECT 'ZzSelectDatabaseProperties' UNION ALL
    SELECT 'ZzSelectDefaultConstraints' UNION ALL
    SELECT 'ZzSelectExpensiveQueries'  UNION ALL
    SELECT 'ZzSelectExtendedProperties' UNION ALL
    SELECT 'ZzSelectFileStats'         UNION ALL
    SELECT 'ZzSelectFragmentedIndexes' UNION ALL
    SELECT 'ZzSelectIdentityColumns'   UNION ALL
    SELECT 'ZzSelectIndexUsage'        UNION ALL
    SELECT 'ZzSelectLogFileUsage'      UNION ALL
    SELECT 'ZzSelectLongRunningQueries' UNION ALL
    SELECT 'ZzSelectMissingIndexes'    UNION ALL
    SELECT 'ZzSelectObjectDependencies' UNION ALL
    SELECT 'ZzSelectObjectsDetails'    UNION ALL
    SELECT 'ZzSelectObjectsOverview'   UNION ALL
    SELECT 'ZzSelectOrphanedUsers'     UNION ALL
    SELECT 'ZzSelectProceduresFunctionsParameters' UNION ALL
    SELECT 'ZzSelectServerConfiguration' UNION ALL
    SELECT 'ZzSelectTablesFks'         UNION ALL
    SELECT 'ZzSelectTablesIndexes'     UNION ALL
    SELECT 'ZzSelectTableSizes'        UNION ALL
    SELECT 'ZzSelectTablesOverview'    UNION ALL
    SELECT 'ZzSelectTablesViewsColumns' UNION ALL
    SELECT 'ZzSelectTempdbUsage'       UNION ALL
    SELECT 'ZzSelectTriggers'          UNION ALL
    SELECT 'ZzSelectUniqueAndPKConstraints' UNION ALL
    SELECT 'ZzSelectUnusedIndexes'     UNION ALL
    SELECT 'ZzSelectWaitStats'         UNION ALL
    SELECT 'ZzSelectFailedLogins'
)
SELECT v.Name,
       o.type_desc
FROM DbMonViews v
LEFT JOIN sys.objects o ON o.name = v.Name
ORDER BY v.Name;

-- Show any that are procedures (should be none)
PRINT '';
PRINT 'Objects that are PROCEDURE (expect 0 rows):';
SELECT o.name, o.type_desc
FROM sys.objects o
WHERE o.name IN (SELECT Name FROM DbMonViews)
  AND o.type = 'P';
