-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-05
-- Description:	Comprehensive test for Base Package Seed Data insertion
--              Tests ZzBaseSeedData stored procedure and verifies:
--              - Role creation (Developer, BackOfficer)
--              - Admin person record creation
--              - Admin user creation with correct password hash
--              - User-Role assignment
--              - Data integrity and relationships
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

PRINT '🧪 BASE PACKAGE SEED DATA TEST'
PRINT '=============================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- =============================================
-- CLEANUP: Remove existing test data
-- =============================================
PRINT '🧹 Cleaning up existing test data...'
BEGIN TRY
    -- Remove user-role assignments for admin
    DELETE FROM [dbo].[BaseUserRole] 
    WHERE UserId IN (SELECT Id FROM [dbo].[BaseUser] WHERE UserName = 'admin');
    
    -- Remove admin user
    DELETE FROM [dbo].[BaseUser] WHERE UserName = 'admin';
    
    -- Remove admin person
    DELETE FROM [dbo].[BasePerson] 
    WHERE FirstName = 'System' AND LastName = 'Administrator';
    
    -- Remove test roles
    DELETE FROM [dbo].[BaseRole] 
    WHERE RoleName IN ('Developer', 'BackOfficer');
    
    PRINT '✓ Cleanup completed'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT '⚠️  Cleanup warning: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH

-- =============================================
-- Test 1: Stored Procedure Existence
-- =============================================
SET @TestName = 'SP Existence Check';
BEGIN TRY
    IF EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[ZzBaseSeedData]') 
               AND type in (N'P', N'PC'))
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'ZzBaseSeedData stored procedure exists';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'ZzBaseSeedData stored procedure not found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 2: Execute Seed Data Procedure
-- =============================================
SET @TestName = 'Execute Seed Data';
BEGIN TRY
    PRINT ''
    PRINT '--- Executing ZzBaseSeedData ---'
    EXEC [dbo].[ZzBaseSeedData];
    PRINT '--- Execution Complete ---'
    PRINT ''
    
    SET @Status = 'PASS';
    SET @Message = 'Seed data procedure executed successfully';
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 3: Developer Role Creation
-- =============================================
SET @TestName = 'Developer Role';
BEGIN TRY
    DECLARE @DeveloperRoleId INT;
    DECLARE @DeveloperRoleName NVARCHAR(100);
    DECLARE @DeveloperIsActive BIT;
    DECLARE @DeveloperIsBuiltIn BIT;
    
    SELECT 
        @DeveloperRoleId = Id,
        @DeveloperRoleName = RoleName,
        @DeveloperIsActive = IsActive,
        @DeveloperIsBuiltIn = IsBuiltIn
    FROM [dbo].[BaseRole]
    WHERE RoleName = 'Developer';
    
    IF @DeveloperRoleId IS NOT NULL
    BEGIN
        IF @DeveloperIsActive = 1 AND @DeveloperIsBuiltIn = 1
        BEGIN
            SET @Status = 'PASS';
            SET @Message = 'Developer role created (ID: ' + CAST(@DeveloperRoleId AS VARCHAR(10)) + ', Active: Yes, BuiltIn: Yes)';
        END
        ELSE
        BEGIN
            SET @Status = 'FAIL';
            SET @Message = 'Developer role has incorrect flags (Active: ' + 
                          CAST(@DeveloperIsActive AS VARCHAR(1)) + ', BuiltIn: ' + 
                          CAST(@DeveloperIsBuiltIn AS VARCHAR(1)) + ')';
        END
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Developer role not found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 4: BackOfficer Role Creation
-- =============================================
SET @TestName = 'BackOfficer Role';
BEGIN TRY
    DECLARE @BackOfficerRoleId INT;
    DECLARE @BackOfficerIsActive BIT;
    DECLARE @BackOfficerIsBuiltIn BIT;
    
    SELECT 
        @BackOfficerRoleId = Id,
        @BackOfficerIsActive = IsActive,
        @BackOfficerIsBuiltIn = IsBuiltIn
    FROM [dbo].[BaseRole]
    WHERE RoleName = 'BackOfficer';
    
    IF @BackOfficerRoleId IS NOT NULL
    BEGIN
        IF @BackOfficerIsActive = 1 AND @BackOfficerIsBuiltIn = 1
        BEGIN
            SET @Status = 'PASS';
            SET @Message = 'BackOfficer role created (ID: ' + CAST(@BackOfficerRoleId AS VARCHAR(10)) + ', Active: Yes, BuiltIn: Yes)';
        END
        ELSE
        BEGIN
            SET @Status = 'FAIL';
            SET @Message = 'BackOfficer role has incorrect flags';
        END
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'BackOfficer role not found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 5: Admin Person Record
-- =============================================
SET @TestName = 'Admin Person Record';
BEGIN TRY
    DECLARE @AdminPersonId INT;
    DECLARE @AdminPersonFirstName NVARCHAR(100);
    DECLARE @AdminPersonLastName NVARCHAR(100);
    DECLARE @AdminPersonUserId INT;
    
    SELECT 
        @AdminPersonId = Id,
        @AdminPersonFirstName = FirstName,
        @AdminPersonLastName = LastName,
        @AdminPersonUserId = UserId
    FROM [dbo].[BasePerson]
    WHERE FirstName = 'System' AND LastName = 'Administrator';
    
    IF @AdminPersonId IS NOT NULL
    BEGIN
        IF @AdminPersonUserId IS NOT NULL
        BEGIN
            SET @Status = 'PASS';
            SET @Message = 'Admin person record created (ID: ' + CAST(@AdminPersonId AS VARCHAR(10)) + 
                          ', Linked to UserId: ' + CAST(@AdminPersonUserId AS VARCHAR(10)) + ')';
        END
        ELSE
        BEGIN
            SET @Status = 'WARN';
            SET @Message = 'Admin person record exists but not linked to user';
        END
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Admin person record not found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 6: Admin User Creation
-- =============================================
SET @TestName = 'Admin User Creation';
BEGIN TRY
    DECLARE @AdminUserId INT;
    DECLARE @AdminUserName NVARCHAR(100);
    DECLARE @AdminEmail NVARCHAR(200);
    DECLARE @AdminPassword NVARCHAR(500);
    DECLARE @AdminIsActive BIT;
    DECLARE @AdminIsBuiltIn BIT;
    DECLARE @AdminLoginLocked BIT;
    
    SELECT 
        @AdminUserId = Id,
        @AdminUserName = UserName,
        @AdminEmail = Email,
        @AdminPassword = Password,
        @AdminIsActive = IsActive,
        @AdminIsBuiltIn = IsBuiltIn,
        @AdminLoginLocked = LoginLocked
    FROM [dbo].[BaseUser]
    WHERE UserName = 'admin';
    
    IF @AdminUserId IS NOT NULL
    BEGIN
        IF @AdminUserName = 'admin' 
           AND @AdminEmail = 'admin@system.local'
           AND @AdminIsActive = 1
           AND @AdminIsBuiltIn = 1
           AND @AdminLoginLocked = 0
        BEGIN
            SET @Status = 'PASS';
            SET @Message = 'Admin user created correctly (ID: ' + CAST(@AdminUserId AS VARCHAR(10)) + 
                          ', Username: ' + @AdminUserName + ', Email: ' + @AdminEmail + ')';
        END
        ELSE
        BEGIN
            SET @Status = 'FAIL';
            SET @Message = 'Admin user has incorrect properties';
        END
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Admin user not found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 7: Password Hash Validation
-- =============================================
SET @TestName = 'Password Hash';
BEGIN TRY
    DECLARE @ExpectedHash NVARCHAR(500) = '8BE3C943B1609FFFBFC51AAD666D0A04ADF83C9D7A54592EA634F5DD196AF4F1';
    DECLARE @ActualHash NVARCHAR(500);
    
    SELECT @ActualHash = Password
    FROM [dbo].[BaseUser]
    WHERE UserName = 'admin';
    
    IF @ActualHash = @ExpectedHash
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Password hash is correct (SHA-256 of P@ssw0rd)';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Password hash mismatch. Expected: ' + @ExpectedHash + ', Got: ' + ISNULL(@ActualHash, 'NULL');
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '7. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '7. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 8: User-Role Assignment (Developer)
-- =============================================
SET @TestName = 'User-Role Assignment';
BEGIN TRY
    DECLARE @UserRoleCount INT;
    DECLARE @AssignedRoleId INT;
    DECLARE @AssignedRoleName NVARCHAR(100);
    
    SELECT 
        @UserRoleCount = COUNT(*),
        @AssignedRoleId = MAX(ur.RoleId)
    FROM [dbo].[BaseUserRole] ur
    INNER JOIN [dbo].[BaseUser] u ON ur.UserId = u.Id
    WHERE u.UserName = 'admin';
    
    IF @AssignedRoleId IS NOT NULL
    BEGIN
        SELECT @AssignedRoleName = RoleName
        FROM [dbo].[BaseRole]
        WHERE Id = @AssignedRoleId;
    END
    
    IF @UserRoleCount > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Admin has ' + CAST(@UserRoleCount AS VARCHAR(10)) + 
                      ' role(s) assigned (Role: ' + ISNULL(@AssignedRoleName, 'Unknown') + ')';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'No roles assigned to admin user';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '8. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '8. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 9: Data Integrity - Foreign Keys
-- =============================================
SET @TestName = 'Data Integrity';
BEGIN TRY
    DECLARE @IntegrityIssues NVARCHAR(MAX) = '';
    
    -- Check if BasePerson.UserId references existing BaseUser
    IF EXISTS (SELECT 1 FROM [dbo].[BasePerson] p
               LEFT JOIN [dbo].[BaseUser] u ON p.UserId = u.Id
               WHERE p.UserId IS NOT NULL AND u.Id IS NULL)
    BEGIN
        SET @IntegrityIssues = @IntegrityIssues + 'Invalid UserId in BasePerson; ';
    END
    
    -- Check if BaseUserRole references existing users and roles
    IF EXISTS (SELECT 1 FROM [dbo].[BaseUserRole] ur
               LEFT JOIN [dbo].[BaseUser] u ON ur.UserId = u.Id
               WHERE u.Id IS NULL)
    BEGIN
        SET @IntegrityIssues = @IntegrityIssues + 'Invalid UserId in BaseUserRole; ';
    END
    
    IF EXISTS (SELECT 1 FROM [dbo].[BaseUserRole] ur
               LEFT JOIN [dbo].[BaseRole] r ON ur.RoleId = r.Id
               WHERE r.Id IS NULL)
    BEGIN
        SET @IntegrityIssues = @IntegrityIssues + 'Invalid RoleId in BaseUserRole; ';
    END
    
    IF LEN(@IntegrityIssues) = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All foreign key relationships are valid';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Integrity issues found: ' + @IntegrityIssues;
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '9. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '9. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test 10: Idempotency Test (Re-run)
-- =============================================
SET @TestName = 'Idempotency Test';
BEGIN TRY
    PRINT ''
    PRINT '--- Re-executing ZzBaseSeedData (Idempotency Test) ---'
    
    -- Count records before re-run
    DECLARE @RoleCountBefore INT, @UserCountBefore INT, @PersonCountBefore INT;
    SELECT @RoleCountBefore = COUNT(*) FROM [dbo].[BaseRole] WHERE RoleName IN ('Developer', 'BackOfficer');
    SELECT @UserCountBefore = COUNT(*) FROM [dbo].[BaseUser] WHERE UserName = 'admin';
    SELECT @PersonCountBefore = COUNT(*) FROM [dbo].[BasePerson] WHERE FirstName = 'System' AND LastName = 'Administrator';
    
    -- Re-execute
    EXEC [dbo].[ZzBaseSeedData];
    
    -- Count records after re-run
    DECLARE @RoleCountAfter INT, @UserCountAfter INT, @PersonCountAfter INT;
    SELECT @RoleCountAfter = COUNT(*) FROM [dbo].[BaseRole] WHERE RoleName IN ('Developer', 'BackOfficer');
    SELECT @UserCountAfter = COUNT(*) FROM [dbo].[BaseUser] WHERE UserName = 'admin';
    SELECT @PersonCountAfter = COUNT(*) FROM [dbo].[BasePerson] WHERE FirstName = 'System' AND LastName = 'Administrator';
    
    PRINT '--- Re-execution Complete ---'
    PRINT ''
    
    IF @RoleCountBefore = @RoleCountAfter 
       AND @UserCountBefore = @UserCountAfter 
       AND @PersonCountBefore = @PersonCountAfter
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Procedure is idempotent (Roles: ' + CAST(@RoleCountAfter AS VARCHAR(10)) + 
                      ', Users: ' + CAST(@UserCountAfter AS VARCHAR(10)) + 
                      ', Persons: ' + CAST(@PersonCountAfter AS VARCHAR(10)) + ')';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Duplicate records created on re-run';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '10. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '10. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- =============================================
-- Test Summary
-- =============================================
PRINT ''
PRINT '📊 TEST SUMMARY'
PRINT '==============='

SELECT 
    TestName,
    Status,
    Message
FROM @TestResults
ORDER BY ExecutionTime;

DECLARE @PassCount INT, @FailCount INT, @ErrorCount INT, @WarnCount INT;
SELECT 
    @PassCount = SUM(CASE WHEN Status = 'PASS' THEN 1 ELSE 0 END),
    @FailCount = SUM(CASE WHEN Status = 'FAIL' THEN 1 ELSE 0 END),
    @ErrorCount = SUM(CASE WHEN Status = 'ERROR' THEN 1 ELSE 0 END),
    @WarnCount = SUM(CASE WHEN Status = 'WARN' THEN 1 ELSE 0 END)
FROM @TestResults;

PRINT '';
PRINT 'Results: ' + CAST(@PassCount AS NVARCHAR(5)) + ' PASS, ' + 
      CAST(@FailCount AS NVARCHAR(5)) + ' FAIL, ' + 
      CAST(@ErrorCount AS NVARCHAR(5)) + ' ERROR, ' +
      CAST(@WarnCount AS NVARCHAR(5)) + ' WARN';

DECLARE @EndTime DATETIME2 = SYSDATETIME();
PRINT 'Total Duration: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS NVARCHAR(10)) + ' ms';

PRINT '';
IF @FailCount = 0 AND @ErrorCount = 0
BEGIN
    PRINT '🎉 ALL TESTS PASSED!'
    PRINT '';
    PRINT '✅ Seed Data Verification Summary:';
    PRINT '   - Developer role created';
    PRINT '   - BackOfficer role created';
    PRINT '   - Admin person record created';
    PRINT '   - Admin user created';
    PRINT '   - Password hash validated';
    PRINT '   - User-Role assignment completed';
    PRINT '   - Data integrity verified';
    PRINT '   - Idempotency confirmed';
END
ELSE
BEGIN
    PRINT '⚠️  SOME TESTS FAILED - Please review the results above';
END

PRINT '=============================='

-- Display created data for verification
PRINT ''
PRINT '📋 CREATED DATA VERIFICATION'
PRINT '============================'
PRINT ''
PRINT 'Roles:'
SELECT Id, RoleName, IsActive, IsBuiltIn, Note
FROM [dbo].[BaseRole]
WHERE RoleName IN ('Developer', 'BackOfficer');

PRINT ''
PRINT 'Admin User:'
SELECT Id, UserName, Email, IsActive, IsBuiltIn, LoginLocked, CreatedOn
FROM [dbo].[BaseUser]
WHERE UserName = 'admin';

PRINT ''
PRINT 'Admin Person:'
SELECT Id, FirstName, LastName, UserId, Mobile, CreatedOn
FROM [dbo].[BasePerson]
WHERE FirstName = 'System' AND LastName = 'Administrator';

PRINT ''
PRINT 'User-Role Assignments:'
SELECT 
    ur.Id,
    u.UserName,
    r.RoleName,
    ur.CreatedOn
FROM [dbo].[BaseUserRole] ur
INNER JOIN [dbo].[BaseUser] u ON ur.UserId = u.Id
INNER JOIN [dbo].[BaseRole] r ON ur.RoleId = r.Id
WHERE u.UserName = 'admin';

PRINT ''
PRINT '============================'
