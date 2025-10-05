-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2025-10-05
-- Author:      Mohsen Mirshahreza
-- Description: Simple seed data - 3 records only
-- =============================================

INSERT INTO BaseRole (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (0, GETDATE(), 'Developer', 1, 'Full access', 1);

INSERT INTO BaseRole (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (0, GETDATE(), 'BackOfficer', 1, 'Admin access', 1);

-- Password: 'P@ssw0rd' (you should change this after first login)
INSERT INTO BaseUser (CreatedBy, CreatedOn, IsBuiltIn, UserName, Email, Password, PasswordUpdatedBy, PasswordUpdatedOn, IsActive, LoginLocked, LoginTryFailsCount)
VALUES (0, GETDATE(), 1, 'admin', 'admin@system.local', '8BE3C943B1609FFFBFC51AAD666D0A04ADF83C9D7A54592EA634F5DD196AF4F1', 0, GETDATE(), 1, 0, 0);    


