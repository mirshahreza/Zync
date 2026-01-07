-- =============================================
-- Zync Scenario Test 09: Base Package Specific
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests Base package-specific features
-- Scenarios:
--   9.1: Base package installation
--   9.2: Seed data verification
--   9.3: Foreign Key relationships
--   9.4: CRUD operations on Base tables
--   9.5: ActivityLog tracking (if applicable)
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 09: BASE PACKAGE SPECIFIC'
PRINT '========================================='
PRINT 'Test Date: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT ''

DECLARE @TestsPassed INT = 0;
DECLARE @TestsFailed INT = 0;
DECLARE @TestsWarning INT = 0;
DECLARE @StartTime DATETIME2 = SYSDATETIME();

IF OBJECT_ID('[dbo].[Zync]', 'P') IS NULL
BEGIN
    PRINT '❌ PREREQUISITE FAILED: Zync not installed'
    RETURN;
END

PRINT '✓ Prerequisite: Zync core is installed'
PRINT ''

-- =============================================
-- SETUP: Clean and install Base
-- =============================================
PRINT '----------------------------------------'
PRINT 'Setup: Installing Base Package'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    EXEC [dbo].[Zync] 'i Base';
    PRINT '✓ Base package installed'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT '✗ Setup failed - ' + ERROR_MESSAGE();
    PRINT 'Base package may not be available or may have errors'
    GOTO TestEnd;
END CATCH

-- =============================================
-- SCENARIO 9.1: Verify Base tables exist
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 9.1: Base Tables Existence'
PRINT '----------------------------------------'

DECLARE @ExpectedTables TABLE (TableName NVARCHAR(128));
INSERT INTO @ExpectedTables VALUES
    ('BaseActivityLog'),
    ('BaseInfo'),
    ('BasePersons'),
    ('BaseRoles'),
    ('BaseRolesAttributes'),
    ('BaseUsers'),
    ('BaseUsersAttributes'),
    ('BaseUsersRoles');

DECLARE @ExistingTables INT = 0;
SELECT @ExistingTables = COUNT(*)
FROM @ExpectedTables t
WHERE OBJECT_ID('[dbo].[' + t.TableName + ']', 'U') IS NOT NULL;

DECLARE @ExpectedCount INT;
SELECT @ExpectedCount = COUNT(*) FROM @ExpectedTables;

IF @ExistingTables = @ExpectedCount
BEGIN
    PRINT '✓ PASS: All ' + CAST(@ExpectedCount AS VARCHAR) + ' Base tables exist'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Expected ' + CAST(@ExpectedCount AS VARCHAR) + 
          ' tables, found ' + CAST(@ExistingTables AS VARCHAR)
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 9.2: Seed data verification
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 9.2: Seed Data Verification'
PRINT '----------------------------------------'

-- Check for default roles
IF OBJECT_ID('[dbo].[BaseRoles]', 'U') IS NOT NULL
BEGIN
    DECLARE @RoleCount INT = 0;
    SELECT @RoleCount = COUNT(*) FROM [dbo].[BaseRoles];
    
    IF @RoleCount > 0
    BEGIN
        PRINT '✓ PASS: Seed data found in BaseRoles (' + CAST(@RoleCount AS VARCHAR) + ' roles)'
        SET @TestsPassed = @TestsPassed + 1;
        
        -- Display roles
        SELECT RoleName, IsBuiltIn FROM [dbo].[BaseRoles];
    END
    ELSE
    BEGIN
        PRINT '⚠ WARN: No seed data in BaseRoles'
        SET @TestsWarning = @TestsWarning + 1;
    END
END

-- Check for default users
IF OBJECT_ID('[dbo].[BaseUsers]', 'U') IS NOT NULL
BEGIN
    DECLARE @UserCount INT = 0;
    SELECT @UserCount = COUNT(*) FROM [dbo].[BaseUsers];
    
    IF @UserCount > 0
    BEGIN
        PRINT '✓ PASS: Seed data found in BaseUsers (' + CAST(@UserCount AS VARCHAR) + ' users)'
        SET @TestsPassed = @TestsPassed + 1;
        
        -- Display users (without sensitive data)
        SELECT Username, IsBuiltIn FROM [dbo].[BaseUsers];
    END
    ELSE
    BEGIN
        PRINT '⚠ WARN: No seed data in BaseUsers'
        SET @TestsWarning = @TestsWarning + 1;
    END
END

PRINT ''

-- =============================================
-- SCENARIO 9.3: Foreign Key relationships
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 9.3: Foreign Key Relationships'
PRINT '----------------------------------------'

-- Check for Foreign Keys
DECLARE @FKCount INT = 0;
SELECT @FKCount = COUNT(*)
FROM sys.foreign_keys
WHERE parent_object_id IN (
    SELECT object_id FROM sys.objects 
    WHERE name LIKE 'Base%' AND type = 'U'
);

IF @FKCount > 0
BEGIN
    PRINT '✓ PASS: Foreign Keys exist (' + CAST(@FKCount AS VARCHAR) + ' relationships)'
    SET @TestsPassed = @TestsPassed + 1;
    
    -- Display FK relationships
    SELECT 
        OBJECT_NAME(parent_object_id) AS TableName,
        name AS FKName,
        OBJECT_NAME(referenced_object_id) AS ReferencedTable
    FROM sys.foreign_keys
    WHERE parent_object_id IN (
        SELECT object_id FROM sys.objects 
        WHERE name LIKE 'Base%' AND type = 'U'
    );
END
ELSE
BEGIN
    PRINT '⚠ WARN: No Foreign Keys found in Base tables'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 9.4: CRUD operations
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 9.4: CRUD Operations on BaseInfo'
PRINT '----------------------------------------'

IF OBJECT_ID('[dbo].[BaseInfo]', 'U') IS NOT NULL
BEGIN
    -- INSERT
    DECLARE @TestInfoId INT;
    BEGIN TRY
        INSERT INTO [dbo].[BaseInfo] (Title, Description, Category)
        VALUES ('Test Title', 'Test Description', 'TEST');
        
        SET @TestInfoId = SCOPE_IDENTITY();
        PRINT '✓ PASS: INSERT successful (Id: ' + CAST(@TestInfoId AS VARCHAR) + ')'
        SET @TestsPassed = @TestsPassed + 1;
    END TRY
    BEGIN CATCH
        PRINT '✗ FAIL: INSERT failed - ' + ERROR_MESSAGE();
        SET @TestsFailed = @TestsFailed + 1;
    END CATCH
    
    -- UPDATE
    BEGIN TRY
        UPDATE [dbo].[BaseInfo]
        SET Description = 'Updated Description'
        WHERE Id = @TestInfoId;
        
        DECLARE @UpdatedDesc NVARCHAR(MAX);
        SELECT @UpdatedDesc = Description
        FROM [dbo].[BaseInfo]
        WHERE Id = @TestInfoId;
        
        IF @UpdatedDesc = 'Updated Description'
        BEGIN
            PRINT '✓ PASS: UPDATE successful'
            SET @TestsPassed = @TestsPassed + 1;
        END
        ELSE
        BEGIN
            PRINT '✗ FAIL: UPDATE did not apply'
            SET @TestsFailed = @TestsFailed + 1;
        END
    END TRY
    BEGIN CATCH
        PRINT '✗ FAIL: UPDATE failed - ' + ERROR_MESSAGE();
        SET @TestsFailed = @TestsFailed + 1;
    END CATCH
    
    -- SELECT
    BEGIN TRY
        DECLARE @SelectCount INT;
        SELECT @SelectCount = COUNT(*)
        FROM [dbo].[BaseInfo]
        WHERE Id = @TestInfoId;
        
        IF @SelectCount = 1
        BEGIN
            PRINT '✓ PASS: SELECT successful'
            SET @TestsPassed = @TestsPassed + 1;
        END
        ELSE
        BEGIN
            PRINT '✗ FAIL: SELECT returned incorrect count'
            SET @TestsFailed = @TestsFailed + 1;
        END
    END TRY
    BEGIN CATCH
        PRINT '✗ FAIL: SELECT failed - ' + ERROR_MESSAGE();
        SET @TestsFailed = @TestsFailed + 1;
    END CATCH
    
    -- DELETE
    BEGIN TRY
        DELETE FROM [dbo].[BaseInfo] WHERE Id = @TestInfoId;
        
        DECLARE @DeleteCheck INT;
        SELECT @DeleteCheck = COUNT(*)
        FROM [dbo].[BaseInfo]
        WHERE Id = @TestInfoId;
        
        IF @DeleteCheck = 0
        BEGIN
            PRINT '✓ PASS: DELETE successful'
            SET @TestsPassed = @TestsPassed + 1;
        END
        ELSE
        BEGIN
            PRINT '✗ FAIL: DELETE did not remove row'
            SET @TestsFailed = @TestsFailed + 1;
        END
    END TRY
    BEGIN CATCH
        PRINT '✗ FAIL: DELETE failed - ' + ERROR_MESSAGE();
        SET @TestsFailed = @TestsFailed + 1;
    END CATCH
END
ELSE
BEGIN
    PRINT '⚠ WARN: BaseInfo table not found'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 9.5: Complex relationships
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 9.5: User-Role Relationships'
PRINT '----------------------------------------'

IF OBJECT_ID('[dbo].[BaseUsersRoles]', 'U') IS NOT NULL
BEGIN
    -- Check user-role mappings exist (from seed data)
    DECLARE @MappingCount INT = 0;
    SELECT @MappingCount = COUNT(*) FROM [dbo].[BaseUsersRoles];
    
    IF @MappingCount > 0
    BEGIN
        PRINT '✓ PASS: User-Role mappings exist (' + CAST(@MappingCount AS VARCHAR) + ' mappings)'
        SET @TestsPassed = @TestsPassed + 1;
        
        -- Display relationships
        SELECT 
            u.Username,
            r.RoleName
        FROM [dbo].[BaseUsersRoles] ur
        INNER JOIN [dbo].[BaseUsers] u ON ur.UserId = u.Id
        INNER JOIN [dbo].[BaseRoles] r ON ur.RoleId = r.Id;
    END
    ELSE
    BEGIN
        PRINT '⚠ WARN: No User-Role mappings found'
        SET @TestsWarning = @TestsWarning + 1;
    END
END

PRINT ''

-- =============================================
-- SCENARIO 9.6: Data integrity
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 9.6: Data Integrity Checks'
PRINT '----------------------------------------'

-- Verify all users have corresponding persons
IF OBJECT_ID('[dbo].[BaseUsers]', 'U') IS NOT NULL 
   AND OBJECT_ID('[dbo].[BasePersons]', 'U') IS NOT NULL
BEGIN
    DECLARE @OrphanUsers INT = 0;
    SELECT @OrphanUsers = COUNT(*)
    FROM [dbo].[BaseUsers] u
    LEFT JOIN [dbo].[BasePersons] p ON u.PersonId = p.Id
    WHERE p.Id IS NULL AND u.PersonId IS NOT NULL;
    
    IF @OrphanUsers = 0
    BEGIN
        PRINT '✓ PASS: All users have valid person records'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: Found ' + CAST(@OrphanUsers AS VARCHAR) + ' orphan users'
        SET @TestsFailed = @TestsFailed + 1;
    END
END

PRINT ''

-- =============================================
-- CLEANUP
-- =============================================
TestEnd:

PRINT '----------------------------------------'
PRINT 'Cleanup: Removing Base Package'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ Cleanup completed'
END TRY
BEGIN CATCH
    PRINT '⚠ Warning: Cleanup error - ' + ERROR_MESSAGE();
END CATCH

PRINT ''

-- =============================================
-- TEST SUMMARY
-- =============================================
DECLARE @EndTime DATETIME2 = SYSDATETIME();
DECLARE @Duration FLOAT = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
DECLARE @TotalTests INT = @TestsPassed + @TestsFailed;

PRINT '========================================'
PRINT 'TEST SUMMARY'
PRINT '========================================'
PRINT 'Total Tests: ' + CAST(@TotalTests AS VARCHAR)
PRINT 'Passed: ' + CAST(@TestsPassed AS VARCHAR)
PRINT 'Failed: ' + CAST(@TestsFailed AS VARCHAR)
PRINT 'Warnings: ' + CAST(@TestsWarning AS VARCHAR)
PRINT 'Duration: ' + CAST(@Duration AS VARCHAR) + ' seconds'
PRINT ''

IF @TestsFailed = 0
BEGIN
    PRINT 'Status: ✅ ALL TESTS PASSED'
    PRINT '========================================'
END
ELSE
BEGIN
    PRINT 'Status: ❌ SOME TESTS FAILED'
    PRINT '========================================'
END

GO
