-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for Base package tables
-- =============================================

SET NOCOUNT ON;
DECLARE @TestResults TABLE (
    TestName NVARCHAR(100),
    Status NVARCHAR(10),
    Message NVARCHAR(MAX),
    ExecutionTime DATETIME2
);

DECLARE @StartTime DATETIME2 = SYSDATETIME();
DECLARE @TestName NVARCHAR(100);
DECLARE @Status NVARCHAR(10);
DECLARE @Message NVARCHAR(MAX);

PRINT '🧪 COMPREHENSIVE BASE PACKAGE TEST'
PRINT '=================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Table Existence Check
SET @TestName = 'Table Existence';
BEGIN TRY
    DECLARE @MissingTables NVARCHAR(MAX) = '';
    
    IF OBJECT_ID('[dbo].[BaseActivityLog]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BaseActivityLog, ';
    IF OBJECT_ID('[dbo].[BaseInfo]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BaseInfo, ';
    IF OBJECT_ID('[dbo].[BasePerson]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BasePerson, ';
    IF OBJECT_ID('[dbo].[BaseRole]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BaseRole, ';
    IF OBJECT_ID('[dbo].[BaseRolesAttributes]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BaseRolesAttributes, ';
    IF OBJECT_ID('[dbo].[BaseUser]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BaseUser, ';
    IF OBJECT_ID('[dbo].[BaseUserAttribute]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BaseUserAttribute, ';
    IF OBJECT_ID('[dbo].[BaseUserRole]', 'U') IS NULL
        SET @MissingTables = @MissingTables + 'BaseUserRole, ';
    
    IF LEN(@MissingTables) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing tables: ' + LEFT(@MissingTables, LEN(@MissingTables) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All 8 base tables exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: BaseInfo - CRUD Operations
SET @TestName = 'BaseInfo - Operations';
BEGIN TRY
    -- Insert test record
    DECLARE @TestInfoId INT;
    INSERT INTO [dbo].[BaseInfo] (Title, Description, Category)
    VALUES ('Test Info', 'Test Description', 'TEST');
    
    SET @TestInfoId = SCOPE_IDENTITY();
    
    -- Update test record
    UPDATE [dbo].[BaseInfo]
    SET Description = 'Updated Description'
    WHERE Id = @TestInfoId;
    
    -- Select test record
    DECLARE @UpdatedDesc NVARCHAR(MAX);
    SELECT @UpdatedDesc = Description
    FROM [dbo].[BaseInfo]
    WHERE Id = @TestInfoId;
    
    -- Delete test record
    DELETE FROM [dbo].[BaseInfo] WHERE Id = @TestInfoId;
    
    IF @UpdatedDesc = 'Updated Description'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'CRUD operations successful';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Update operation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: BasePerson - Insert and Validation
SET @TestName = 'BasePerson - Validation';
BEGIN TRY
    DECLARE @TestPersonId INT;
    INSERT INTO [dbo].[BasePerson] (FirstName, LastName, NationalId)
    VALUES ('Test', 'User', '1234567890');
    
    SET @TestPersonId = SCOPE_IDENTITY();
    
    -- Verify insertion
    DECLARE @PersonName NVARCHAR(200);
    SELECT @PersonName = FirstName + ' ' + LastName
    FROM [dbo].[BasePerson]
    WHERE Id = @TestPersonId;
    
    -- Cleanup
    DELETE FROM [dbo].[BasePerson] WHERE Id = @TestPersonId;
    
    IF @PersonName = 'Test User'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Person record created and validated';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Person validation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: BaseRole and BaseUser - Relationship
SET @TestName = 'Role-User Relationship';
BEGIN TRY
    -- Create test role
    DECLARE @TestRoleId INT;
    INSERT INTO [dbo].[BaseRole] (RoleName, Description)
    VALUES ('TestRole', 'Test Role Description');
    SET @TestRoleId = SCOPE_IDENTITY();
    
    -- Create test user
    DECLARE @TestUserId INT;
    INSERT INTO [dbo].[BaseUser] (Username, PasswordHash, Email)
    VALUES ('testuser', 'hashedpassword', 'test@example.com');
    SET @TestUserId = SCOPE_IDENTITY();
    
    -- Create role assignment
    INSERT INTO [dbo].[BaseUserRole] (UserId, RoleId)
    VALUES (@TestUserId, @TestRoleId);
    
    -- Verify relationship
    DECLARE @RoleCount INT;
    SELECT @RoleCount = COUNT(*)
    FROM [dbo].[BaseUserRole]
    WHERE UserId = @TestUserId AND RoleId = @TestRoleId;
    
    -- Cleanup
    DELETE FROM [dbo].[BaseUserRole] WHERE UserId = @TestUserId;
    DELETE FROM [dbo].[BaseUser] WHERE Id = @TestUserId;
    DELETE FROM [dbo].[BaseRole] WHERE Id = @TestRoleId;
    
    IF @RoleCount = 1
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Role-User relationship works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Relationship validation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: BaseActivityLog - Logging
SET @TestName = 'Activity Logging';
BEGIN TRY
    DECLARE @TestLogId INT;
    INSERT INTO [dbo].[BaseActivityLog] (UserId, Activity, LogLevel)
    VALUES (1, 'Test Activity', 'INFO');
    SET @TestLogId = SCOPE_IDENTITY();
    
    -- Verify log entry
    DECLARE @LogActivity NVARCHAR(500);
    SELECT @LogActivity = Activity
    FROM [dbo].[BaseActivityLog]
    WHERE Id = @TestLogId;
    
    -- Cleanup
    DELETE FROM [dbo].[BaseActivityLog] WHERE Id = @TestLogId;
    
    IF @LogActivity = 'Test Activity'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Activity logging works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Log verification failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test Summary
PRINT ''
PRINT '📊 TEST SUMMARY'
PRINT '==============='

SELECT 
    TestName,
    Status,
    Message
FROM @TestResults
ORDER BY ExecutionTime;

DECLARE @PassCount INT, @FailCount INT, @ErrorCount INT;
SELECT 
    @PassCount = SUM(CASE WHEN Status = 'PASS' THEN 1 ELSE 0 END),
    @FailCount = SUM(CASE WHEN Status = 'FAIL' THEN 1 ELSE 0 END),
    @ErrorCount = SUM(CASE WHEN Status = 'ERROR' THEN 1 ELSE 0 END)
FROM @TestResults;

PRINT 'Results: ' + CAST(@PassCount AS NVARCHAR(5)) + ' PASS, ' + 
      CAST(@FailCount AS NVARCHAR(5)) + ' FAIL, ' + 
      CAST(@ErrorCount AS NVARCHAR(5)) + ' ERROR';

DECLARE @EndTime DATETIME2 = SYSDATETIME();
PRINT 'Total Duration: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS NVARCHAR(10)) + ' ms';

IF @FailCount = 0 AND @ErrorCount = 0
    PRINT '🎉 ALL TESTS PASSED!'
ELSE
    PRINT '⚠️  SOME TESTS FAILED - Please review the results above';

PRINT '=================================='
