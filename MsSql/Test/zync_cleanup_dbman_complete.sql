-- Remove all DbMan related packages
PRINT 'Removing all DbMan packages...'

IF OBJECT_ID('[dbo].[ZyncPackages]') IS NULL OR OBJECT_ID('[dbo].[ZyncObjects]') IS NULL
BEGIN
    PRINT 'Tracking tables do not exist. Skipping removal.'
    RETURN;
END

-- Get list of all DbMan packages
DECLARE @PackageName NVARCHAR(256)
DECLARE package_cursor CURSOR FOR
SELECT DISTINCT PackageName 
FROM [dbo].[ZyncPackages] 
WHERE PackageName LIKE 'DbMan%'

OPEN package_cursor
FETCH NEXT FROM package_cursor INTO @PackageName

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Removing: ' + @PackageName
    DECLARE @sql NVARCHAR(MAX) = 'EXEC [dbo].[Zync] ''rm ' + @PackageName + ''''
    EXEC sp_executesql @sql
    
    FETCH NEXT FROM package_cursor INTO @PackageName
END

CLOSE package_cursor
DEALLOCATE package_cursor

PRINT 'All DbMan packages removed!'