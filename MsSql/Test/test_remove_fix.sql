-- Test script to verify that the remove functionality works correctly
-- This script creates a test object, installs it via Zync, then tests removal

-- Step 1: Create a simple test function to install and remove
PRINT 'Creating test function ZzTestRemove...'
GO

CREATE OR ALTER FUNCTION [dbo].[ZzTestRemove](@input INT)
RETURNS INT
AS
BEGIN
    RETURN @input * 2
END
GO

-- Step 2: Check if the function exists
PRINT 'Checking if ZzTestRemove function exists:'
IF OBJECT_ID('[dbo].[ZzTestRemove]', 'FN') IS NOT NULL
    PRINT '✓ ZzTestRemove function exists'
ELSE
    PRINT '✗ ZzTestRemove function does not exist'
GO

-- Step 3: Manually insert into tracking tables to simulate a Zync-managed object
PRINT 'Adding ZzTestRemove to Zync tracking system...'

DECLARE @TestPackageId UNIQUEIDENTIFIER = NEWID()

-- Insert package record
INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Version, Status)
VALUES (@TestPackageId, 'TestRemovePackage', 1, 'INSTALLED')

-- Insert object record
INSERT INTO [dbo].[ZyncObjects] (PackageId, ObjectName, ObjectType, ObjectDefinition)
VALUES (@TestPackageId, 'ZzTestRemove', 'FUNCTION', 
'CREATE OR ALTER FUNCTION [dbo].[ZzTestRemove](@input INT)
RETURNS INT
AS
BEGIN
    RETURN @input * 2
END')

PRINT 'Added to tracking system successfully'
GO

-- Step 4: Test the remove command
PRINT 'Testing remove command...'
EXEC [dbo].[Zync] 'rm TestRemovePackage'
GO

-- Step 5: Verify the function was actually removed
PRINT 'Verifying function removal:'
IF OBJECT_ID('[dbo].[ZzTestRemove]', 'FN') IS NOT NULL
    PRINT '✗ FAILED: ZzTestRemove function still exists after removal!'
ELSE
    PRINT '✓ SUCCESS: ZzTestRemove function was properly removed'
GO

-- Step 6: Check tracking tables were cleaned up
PRINT 'Checking tracking table cleanup:'
IF EXISTS (SELECT 1 FROM [dbo].[ZyncPackages] WHERE PackageName = 'TestRemovePackage' AND Status = 'INSTALLED')
    PRINT '✗ FAILED: Package record still shows as INSTALLED'
ELSE
    PRINT '✓ SUCCESS: Package record properly updated'

IF EXISTS (SELECT 1 FROM [dbo].[ZyncObjects] WHERE ObjectName = 'ZzTestRemove')
    PRINT '✗ FAILED: Object record still exists in tracking table'
ELSE
    PRINT '✓ SUCCESS: Object record properly removed from tracking table'
GO

PRINT 'Test completed!'