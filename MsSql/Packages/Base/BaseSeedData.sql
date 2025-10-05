-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2025-10-05
-- Description: Stored procedure to insert initial seed data into Base tables
--              - Creates Admin user in BaseUser
--              - Creates Developer and BackOfficer roles in BaseRole
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZzBaseSeedData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ZzBaseSeedData]
GO

CREATE PROCEDURE [dbo].[ZzBaseSeedData]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '�� Inserting Base Package Seed Data...';
    PRINT '';

    -- System user ID for CreatedBy fields (using a standard system ID)
    DECLARE @SystemUserId INT = 0;
    DECLARE @CurrentDate DATETIME = GETDATE();

    -- =============================================
    -- BaseRole: Insert Initial Roles
    -- =============================================
    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseRole]') AND type = 'U')
    BEGIN
        PRINT '🎭 Creating initial roles...';
        
        -- Developer Role
        IF NOT EXISTS (SELECT 1 FROM [dbo].[BaseRole] WHERE RoleName = 'Developer')
        BEGIN
            INSERT INTO [dbo].[BaseRole] (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
            VALUES (@SystemUserId, @CurrentDate, 'Developer', 1, 'Software developer with full system access for development purposes', 1);
            PRINT '  ✓ Role "Developer" created';
        END
        ELSE
        BEGIN
            PRINT '  ⚠ Role "Developer" already exists';
        END
        
        -- BackOfficer Role
        IF NOT EXISTS (SELECT 1 FROM [dbo].[BaseRole] WHERE RoleName = 'BackOfficer')
        BEGIN
            INSERT INTO [dbo].[BaseRole] (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
            VALUES (@SystemUserId, @CurrentDate, 'BackOfficer', 1, 'Back office staff with administrative access', 1);
            PRINT '  ✓ Role "BackOfficer" created';
        END
        ELSE
        BEGIN
            PRINT '  ⚠ Role "BackOfficer" already exists';
        END
        
        PRINT '';
    END
    ELSE
    BEGIN
        PRINT '  ❌ BaseRole table not found. Please install Base package first.';
        PRINT '';
    END

    -- =============================================
    -- BasePerson: Insert Admin Person Record
    -- =============================================
    DECLARE @AdminPersonId INT = NULL;

    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BasePerson]') AND type = 'U')
    BEGIN
        PRINT '👤 Creating Admin person record...';
        
        IF NOT EXISTS (SELECT 1 FROM [dbo].[BasePerson] WHERE FirstName = 'System' AND LastName = 'Administrator')
        BEGIN
            INSERT INTO [dbo].[BasePerson] (CreatedBy, CreatedOn, UserId, GenderId, FirstName, LastName, Mobile)
            VALUES (@SystemUserId, @CurrentDate, NULL, 0, 'System', 'Administrator', '00000000000');
            
            SET @AdminPersonId = SCOPE_IDENTITY();
            PRINT '  ✓ Admin person record created (ID: ' + CAST(@AdminPersonId AS VARCHAR(10)) + ')';
        END
        ELSE
        BEGIN
            SELECT @AdminPersonId = Id 
            FROM [dbo].[BasePerson] 
            WHERE FirstName = 'System' AND LastName = 'Administrator';
            PRINT '  ⚠ Admin person record already exists (ID: ' + CAST(@AdminPersonId AS VARCHAR(10)) + ')';
        END
        
        PRINT '';
    END
    ELSE
    BEGIN
        PRINT '  ⚠ BasePerson table not found. Skipping person record.';
        PRINT '';
    END

    -- =============================================
    -- BaseUser: Insert Admin User
    -- =============================================
    DECLARE @AdminUserId INT = NULL;

    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseUser]') AND type = 'U')
    BEGIN
        PRINT '👤 Creating Admin user...';
        
        IF NOT EXISTS (SELECT 1 FROM [dbo].[BaseUser] WHERE UserName = 'admin')
        BEGIN
            -- Create admin user
            -- Password: 'P@ssw0rd' (you should change this after first login)
            -- Hash: SHA-256 of 'P@ssw0rd'
            INSERT INTO [dbo].[BaseUser] (
                CreatedBy, CreatedOn, IsBuiltIn, UserName, Email, 
                Password, PasswordUpdatedBy, PasswordUpdatedOn, 
                IsActive, LoginLocked, LoginTryFailsCount
            )
            VALUES (
                @SystemUserId,
                @CurrentDate,
                1, -- IsBuiltIn
                'admin',
                'admin@system.local',
                '8BE3C943B1609FFFBFC51AAD666D0A04ADF83C9D7A54592EA634F5DD196AF4F1', -- SHA-256 hash of 'P@ssw0rd'
                @SystemUserId,
                @CurrentDate,
                1, -- IsActive
                0, -- LoginLocked
                0  -- LoginTryFailsCount
            );
            
            SET @AdminUserId = SCOPE_IDENTITY();
            PRINT '  ✓ Admin user created (ID: ' + CAST(@AdminUserId AS VARCHAR(10)) + ')';
            PRINT '    Username: admin';
            PRINT '    Password: P@ssw0rd';
            PRINT '    ⚠️  Please change the password after first login!';
            
            -- Update BasePerson with UserId if person record exists
            IF @AdminPersonId IS NOT NULL
            BEGIN
                UPDATE [dbo].[BasePerson] 
                SET UserId = @AdminUserId,
                    UpdatedBy = @SystemUserId,
                    UpdatedOn = @CurrentDate
                WHERE Id = @AdminPersonId;
                PRINT '  ✓ Person record linked to user';
            END
            
            PRINT '';
        END
        ELSE
        BEGIN
            SELECT @AdminUserId = Id FROM [dbo].[BaseUser] WHERE UserName = 'admin';
            PRINT '  ⚠ Admin user already exists (ID: ' + CAST(@AdminUserId AS VARCHAR(10)) + ')';
            PRINT '';
        END
    END
    ELSE
    BEGIN
        PRINT '  ❌ BaseUser table not found. Please install Base package first.';
        PRINT '';
    END

    -- =============================================
    -- BaseUserRole: Assign Developer Role to Admin
    -- =============================================
    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseUserRole]') AND type = 'U')
       AND @AdminUserId IS NOT NULL
    BEGIN
        PRINT '🔐 Assigning roles to Admin user...';
        
        DECLARE @DeveloperRoleId INT;
        SELECT @DeveloperRoleId = Id FROM [dbo].[BaseRole] WHERE RoleName = 'Developer';
        
        IF @DeveloperRoleId IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM [dbo].[BaseUserRole] WHERE UserId = @AdminUserId AND RoleId = @DeveloperRoleId)
            BEGIN
                INSERT INTO [dbo].[BaseUserRole] (CreatedBy, CreatedOn, UserId, RoleId)
                VALUES (@SystemUserId, @CurrentDate, @AdminUserId, @DeveloperRoleId);
                PRINT '  ✓ Developer role assigned to admin user';
            END
            ELSE
            BEGIN
                PRINT '  ⚠ Developer role already assigned';
            END
        END
        ELSE
        BEGIN
            PRINT '  ⚠ Developer role not found';
        END
        
        PRINT '';
    END
    ELSE
    BEGIN
        IF @AdminUserId IS NULL
        BEGIN
            PRINT '  ⚠ Admin user not created, skipping role assignment';
        END
        ELSE
        BEGIN
            PRINT '  ⚠ BaseUserRole table not found. Skipping role assignment.';
        END
        PRINT '';
    END

    -- =============================================
    -- Summary
    -- =============================================
    PRINT '📊 Seed Data Summary:';
    PRINT '=====================';

    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseRole]') AND type = 'U')
    BEGIN
        DECLARE @RoleCount INT;
        SELECT @RoleCount = COUNT(*) FROM [dbo].[BaseRole];
        PRINT '  Roles in system: ' + CAST(@RoleCount AS VARCHAR(10));
    END

    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseUser]') AND type = 'U')
    BEGIN
        DECLARE @UserCount INT;
        SELECT @UserCount = COUNT(*) FROM [dbo].[BaseUser];
        PRINT '  Users in system: ' + CAST(@UserCount AS VARCHAR(10));
    END

    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseUserRole]') AND type = 'U')
    BEGIN
        DECLARE @UserRoleCount INT;
        SELECT @UserRoleCount = COUNT(*) FROM [dbo].[BaseUserRole];
        PRINT '  User-Role assignments: ' + CAST(@UserRoleCount AS VARCHAR(10));
    END

    PRINT '';
    PRINT '✅ Seed data installation completed!';
    PRINT '';
    PRINT '📝 Default Credentials:';
    PRINT '   Username: admin';
    PRINT '   Password: P@ssw0rd';
    PRINT '   ⚠️  Change password immediately after first login!';
    PRINT '';
END
GO
