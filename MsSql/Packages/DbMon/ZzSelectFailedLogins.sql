-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Shows the history of failed login attempts.
-- Sample:
-- EXEC [dbo].[ZzSelectFailedLogins];
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzSelectFailedLogins]
AS
BEGIN
    -- This requires reading the SQL Server error log. 
    -- The user needs appropriate permissions (e.g., setupadmin server role).
    EXEC sp_readerrorlog 0, 1, 'Login failed';
END
