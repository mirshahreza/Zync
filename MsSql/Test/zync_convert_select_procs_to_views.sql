-- =============================================
-- Helper script: Convert ZzSelect* procedures to views
-- Usage:
--   1) Run this script in your database
--   2) It will drop any dbo.ZzSelect* procedures if exist
--   3) Then re-run Zync to install DbMon package (views)
-- =============================================

PRINT 'Converting ZzSelect* procedures to views...'

-- Drop ZzSelect* procedures if any
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql = @sql + 'DROP PROCEDURE [dbo].[' + name + '];' + CHAR(13)
FROM sys.objects
WHERE type = 'P' AND name LIKE 'ZzSelect%';

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping procedures:'
    PRINT @sql
    EXEC sp_executesql @sql;
END
ELSE
BEGIN
    PRINT 'No ZzSelect* procedures found.'
END

-- Re-install DbMon package to ensure views are present
IF OBJECT_ID('[dbo].[Zync]', 'P') IS NOT NULL
BEGIN
    PRINT 'Re-installing DbMon package via Zync...';
    EXEC [dbo].[Zync] 'i DbMon';
END
ELSE
BEGIN
    PRINT 'Zync procedure not found. Please run MsSql/Zync.sql first.';
END

-- Verification
PRINT 'Verifying that ZzSelect* objects are views (not procedures)...';
SELECT name, type_desc
FROM sys.objects
WHERE name LIKE 'ZzSelect%'
ORDER BY type_desc, name;

PRINT 'Done.';
