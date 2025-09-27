-- Debug script to understand the exact issue with object existence check
PRINT '=== Debugging Object Existence Check ==='

-- Simulate what the remove code does
DECLARE @RemoveObjectName NVARCHAR(256) = 'DBO.ZZALTERCOLUMN
        @TABLENAME VARCHAR'
DECLARE @RemoveObjectType NVARCHAR(50) = 'PROCEDURE'

PRINT 'Original stored ObjectName: [' + @RemoveObjectName + ']'
PRINT 'ObjectType: [' + @RemoveObjectType + ']'
PRINT ''

-- Extract clean object name (same logic as in Zync)
DECLARE @RemoveCleanObjectName NVARCHAR(256) = @RemoveObjectName;

-- Remove schema prefix (DBO.)
IF CHARINDEX('DBO.', UPPER(@RemoveCleanObjectName)) = 1
    SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 5, LEN(@RemoveCleanObjectName));

PRINT '1. After removing DBO.: [' + @RemoveCleanObjectName + ']'

-- Remove parameter part if exists (everything after space or @)
IF CHARINDEX(' ', @RemoveCleanObjectName) > 0
    SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 1, CHARINDEX(' ', @RemoveCleanObjectName) - 1);
IF CHARINDEX('@', @RemoveCleanObjectName) > 0
    SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 1, CHARINDEX('@', @RemoveCleanObjectName) - 1);

PRINT '2. After removing parameters: [' + @RemoveCleanObjectName + ']'

-- Clean up brackets, newlines, and trim whitespace
SET @RemoveCleanObjectName = REPLACE(REPLACE(REPLACE(@RemoveCleanObjectName, '[', ''), ']', ''), CHAR(10), '');
SET @RemoveCleanObjectName = REPLACE(@RemoveCleanObjectName, CHAR(13), '');
SET @RemoveCleanObjectName = TRIM(@RemoveCleanObjectName);

PRINT '3. After cleaning: [' + @RemoveCleanObjectName + ']'

-- Try to find the actual object name (case-insensitive match)
DECLARE @ActualObjectName NVARCHAR(256);
SELECT @ActualObjectName = name 
FROM sys.objects 
WHERE UPPER(name) = UPPER(@RemoveCleanObjectName) AND type IN ('P', 'FN', 'TF', 'IF', 'V');

PRINT '4. Found actual object name: [' + ISNULL(@ActualObjectName, 'NULL') + ']'

IF @ActualObjectName IS NOT NULL
    SET @RemoveCleanObjectName = @ActualObjectName;

PRINT '5. Final clean object name: [' + @RemoveCleanObjectName + ']'

-- Test existence check
DECLARE @ObjectActuallyExists BIT = 0;

IF @RemoveObjectType = 'TYPE' AND TYPE_ID('[dbo].[' + @RemoveCleanObjectName + ']') IS NOT NULL 
    SET @ObjectActuallyExists = 1;
ELSE IF @RemoveObjectType != 'TYPE' AND OBJECT_ID('[dbo].[' + @RemoveCleanObjectName + ']') IS NOT NULL 
    SET @ObjectActuallyExists = 1;

PRINT '6. Object exists check result: ' + CAST(@ObjectActuallyExists AS VARCHAR)

-- Manual verification
DECLARE @TestFullName NVARCHAR(256) = '[dbo].[' + @RemoveCleanObjectName + ']'
PRINT '7. Testing full name: [' + @TestFullName + ']'

IF OBJECT_ID(@TestFullName, 'P') IS NOT NULL
    PRINT '   ✓ Manual PROCEDURE check: EXISTS'
ELSE
    PRINT '   ✗ Manual PROCEDURE check: NOT EXISTS'

-- Show what actually exists
PRINT ''
PRINT '=== What actually exists in database ==='
SELECT 'PROCEDURE: ' + name as ActualObjects FROM sys.objects WHERE type = 'P' AND name LIKE '%Alter%'