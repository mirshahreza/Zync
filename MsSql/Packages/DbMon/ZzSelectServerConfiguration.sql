-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Displays important server-level configuration settings.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectServerConfiguration];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectServerConfiguration]
AS
SELECT 
    name,
    value,
    value_in_use,
    description
FROM sys.configurations;
