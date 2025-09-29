-- Debug script to test object name parsing logic
DECLARE @ObjectName NVARCHAR(256) = 'DBO.ZZALTERCOLUMN
        @TABLENAME VARCHAR'
DECLARE @ObjectType NVARCHAR(50) = 'PROCEDURE'

PRINT 'Original ObjectName: [' + @ObjectName + ']'

-- Extract clean object name from stored format like "DBO.ZZALTERCOLUMN@TABLENAME VARCHAR"
DECLARE @CleanObjectName NVARCHAR(256) = @ObjectName;

-- Remove schema prefix (DBO.)
IF CHARINDEX('DBO.', UPPER(@CleanObjectName)) = 1
    SET @CleanObjectName = SUBSTRING(@CleanObjectName, 5, LEN(@CleanObjectName));

PRINT 'After removing DBO.: [' + @CleanObjectName + ']'

-- Remove parameter part if exists (everything after space or @)
IF CHARINDEX(' ', @CleanObjectName) > 0
    SET @CleanObjectName = SUBSTRING(@CleanObjectName, 1, CHARINDEX(' ', @CleanObjectName) - 1);
IF CHARINDEX('@', @CleanObjectName) > 0
    SET @CleanObjectName = SUBSTRING(@CleanObjectName, 1, CHARINDEX('@', @CleanObjectName) - 1);

PRINT 'After removing parameters: [' + @CleanObjectName + ']'

-- Clean up brackets and newlines  
SET @CleanObjectName = REPLACE(REPLACE(REPLACE(@CleanObjectName, '[', ''), ']', ''), CHAR(10), '');
SET @CleanObjectName = REPLACE(@CleanObjectName, CHAR(13), '');
SET @CleanObjectName = TRIM(@CleanObjectName);

PRINT 'Final clean name: [' + @CleanObjectName + ']'

-- Test if object exists
DECLARE @FullName NVARCHAR(256) = '[dbo].[' + @CleanObjectName + ']'
PRINT 'Testing existence of: [' + @FullName + ']'

IF OBJECT_ID(@FullName) IS NOT NULL
    PRINT '✓ Object EXISTS!'
ELSE
    PRINT '✗ Object does NOT exist'

-- Check what objects actually exist with similar names
PRINT 'Objects with similar names:'
SELECT name FROM sys.objects WHERE name LIKE '%ALTER%' AND type = 'P'