-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2025-10-05
-- Author:      Mohsen Mirshahreza
-- Description: Simple seed data - 3 records only
-- =============================================

INSERT INTO BaseRoles (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (0, GETDATE(), 'Developer', 1, 'Full access', 1);

INSERT INTO BaseRoles (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (0, GETDATE(), 'BackOfficer', 1, 'Admin access', 1);

-- Password: 'P@ssw0rd' (you should change this after first login)
INSERT INTO BaseUsers (CreatedBy, CreatedOn, IsBuiltIn, UserName, Email, Password, PasswordUpdatedBy, PasswordUpdatedOn, IsActive, LoginLocked, LoginTryFailsCount)
VALUES (0, GETDATE(), 1, 'admin', 'admin@system.local', '161EBD7D45089B3446EE4E0D86DBCF92', 0, GETDATE(), 1, 0, 0);


