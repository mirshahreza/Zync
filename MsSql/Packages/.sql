-- Master package index: install all core packages in a sensible order
-- Note: Each package manages its own internal dependencies via its /.sql
EXEC DBO.Zync 'i Base';
EXEC DBO.Zync 'i String';
EXEC DBO.Zync 'i Math';
EXEC DBO.Zync 'i DateTime';
EXEC DBO.Zync 'i Validation';
EXEC DBO.Zync 'i Json';
EXEC DBO.Zync 'i Financial';
EXEC DBO.Zync 'i Security';
EXEC DBO.Zync 'i DbMan';
EXEC DBO.Zync 'i DbMon';
EXEC DBO.Zync 'i Backup';
EXEC DBO.Zync 'i Geographic';
EXEC DBO.Zync 'i Elsa';

