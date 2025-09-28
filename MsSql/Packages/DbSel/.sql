-- Prefer views
EXEC DBO.Zync 'i DbSel/ZzSelectObjectDependencies.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectColumnDependencies.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectDatabasePermissions.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectDatabaseProperties.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectObjectsDetails.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectObjectsOverview.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectProceduresFunctionsParameters.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectTablesFks.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectTablesIndexes.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectTableSizes.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectTablesOverview.sql';
EXEC DBO.Zync 'i DbSel/ZzSelectTablesViewsColumns.sql';
