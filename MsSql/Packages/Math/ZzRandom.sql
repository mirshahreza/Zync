-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Creates a view to get a random number, bypassing the UDF side-effect limitation for RAND().
-- Sample:
-- SELECT * FROM [dbo].[ZzRandom];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzRandom]
AS
SELECT RAND() AS Value;
