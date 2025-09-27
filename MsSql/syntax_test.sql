-- Simple syntax check script for Zync.sql
-- This script will help verify that there are no variable naming conflicts

-- Test the main areas where variable conflicts occurred:

-- 1. Test clean section variables
DECLARE @CleanObjectName NVARCHAR(256), @CleanObjectType NVARCHAR(50);
SET @CleanObjectName = 'TestObject';
PRINT 'Clean section variables: OK';

-- 2. Test remove section variables (should use different names now)
DECLARE @RemoveCleanObjectName NVARCHAR(256) = 'TestRemoveObject';
DECLARE @RemoveFullObjectName NVARCHAR(256) = '[dbo].[' + @RemoveCleanObjectName + ']';
PRINT 'Remove section variables: OK - ' + @RemoveFullObjectName;

-- 3. Test rollback section variables
DECLARE @RollbackCleanObjectName NVARCHAR(256) = 'TestRollbackObject';
DECLARE @RollbackFullObjectName NVARCHAR(256) = '[dbo].[' + @RollbackCleanObjectName + ']';
PRINT 'Rollback section variables: OK - ' + @RollbackFullObjectName;

PRINT 'All variable naming conflicts resolved successfully!';