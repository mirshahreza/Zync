-- Test script to exactly simulate the stored procedure logic
-- First reinstall a fresh package for testing
DELETE FROM [dbo].[ZyncObjects]; 
DELETE FROM [dbo].[ZyncPackages];
EXEC DBO.Zync 'i DbMan/ZzAlterColumn.sql';

-- Now simulate the exact remove logic
DECLARE @PackageName NVARCHAR(128) = 'DbMan/ZzAlterColumn.sql';

-- Get package info (same as stored procedure)
DECLARE @RemovePackageId UNIQUEIDENTIFIER;
SELECT @RemovePackageId = PackageId 
FROM [dbo].[ZyncPackages] 
WHERE PackageName = @PackageName AND Status IN ('INSTALLED', 'UPDATED');

PRINT 'Found PackageId: ' + CAST(@RemovePackageId AS VARCHAR(36));

-- Get objects to remove (same as stored procedure)
DECLARE @ObjectsToRemove TABLE (
    ObjectName NVARCHAR(256),
    ObjectType NVARCHAR(50),
    PreviousDefinition NVARCHAR(MAX)
);

INSERT INTO @ObjectsToRemove (ObjectName, ObjectType, PreviousDefinition)
SELECT ObjectName, ObjectType, PreviousDefinition
FROM [dbo].[ZyncObjects]
WHERE PackageId = @RemovePackageId;

-- Show what we found
SELECT 'Found object: [' + ObjectName + '] Type: [' + ObjectType + ']' as FoundObjects
FROM @ObjectsToRemove;

-- Now simulate the cursor logic for first object
DECLARE @RemoveObjectName NVARCHAR(256);
DECLARE @RemoveObjectType NVARCHAR(50);
DECLARE @PreviousDefinition NVARCHAR(MAX);

SELECT TOP 1 @RemoveObjectName = ObjectName, @RemoveObjectType = ObjectType, @PreviousDefinition = PreviousDefinition
FROM @ObjectsToRemove;

PRINT 'Processing object: [' + @RemoveObjectName + ']';
PRINT 'Object type: [' + @RemoveObjectType + ']';

-- Exact same logic as stored procedure
DECLARE @ObjectActuallyExists BIT = 0;

-- Extract clean object name from stored format like "DBO.ZZALTERCOLUMN@TABLENAME VARCHAR"
DECLARE @RemoveCleanObjectName NVARCHAR(256) = @RemoveObjectName;

-- Remove schema prefix (DBO.)
IF CHARINDEX('DBO.', UPPER(@RemoveCleanObjectName)) = 1
    SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 5, LEN(@RemoveCleanObjectName));

-- Remove parameter part if exists (everything after space or @)
IF CHARINDEX(' ', @RemoveCleanObjectName) > 0
    SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 1, CHARINDEX(' ', @RemoveCleanObjectName) - 1);
IF CHARINDEX('@', @RemoveCleanObjectName) > 0
    SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 1, CHARINDEX('@', @RemoveCleanObjectName) - 1);

-- Clean up brackets, newlines, and trim whitespace
SET @RemoveCleanObjectName = REPLACE(REPLACE(REPLACE(@RemoveCleanObjectName, '[', ''), ']', ''), CHAR(10), '');
SET @RemoveCleanObjectName = REPLACE(@RemoveCleanObjectName, CHAR(13), '');
SET @RemoveCleanObjectName = TRIM(@RemoveCleanObjectName);

-- Try to find the actual object name (case-insensitive match)
DECLARE @ActualObjectName NVARCHAR(256);
SELECT @ActualObjectName = name 
FROM sys.objects 
WHERE UPPER(name) = UPPER(@RemoveCleanObjectName) AND type IN ('P', 'FN', 'TF', 'IF', 'V');

IF @ActualObjectName IS NOT NULL
    SET @RemoveCleanObjectName = @ActualObjectName;

PRINT 'Clean object name: [' + @RemoveCleanObjectName + ']';

-- Final existence check
IF @RemoveObjectType = 'TYPE' AND TYPE_ID('[dbo].[' + @RemoveCleanObjectName + ']') IS NOT NULL 
    SET @ObjectActuallyExists = 1;
ELSE IF @RemoveObjectType != 'TYPE' AND OBJECT_ID('[dbo].[' + @RemoveCleanObjectName + ']') IS NOT NULL 
    SET @ObjectActuallyExists = 1;

PRINT 'Object actually exists: ' + CAST(@ObjectActuallyExists AS VARCHAR);

IF @ObjectActuallyExists = 1
BEGIN
    DECLARE @RemoveFullObjectName NVARCHAR(256) = '[dbo].[' + @RemoveCleanObjectName + ']';
    DECLARE @DropStatement NVARCHAR(MAX) = 'DROP ' + @RemoveObjectType + ' ' + @RemoveFullObjectName;
    
    PRINT 'Would execute: ' + @DropStatement;
    
    -- Actually execute the DROP
    BEGIN TRY
        EXECUTE SP_EXECUTESQL @DropStatement;
        PRINT '✓ Successfully dropped ' + @RemoveObjectType + ' ' + @RemoveFullObjectName;
    END TRY
    BEGIN CATCH
        PRINT '✗ Error dropping ' + @RemoveObjectType + ' ' + @RemoveFullObjectName + ': ' + ERROR_MESSAGE();
    END CATCH
END
ELSE
    PRINT '✗ Object does not exist - would skip';

-- Verify result
SELECT name FROM sys.objects WHERE name LIKE 'ZzAlter%';