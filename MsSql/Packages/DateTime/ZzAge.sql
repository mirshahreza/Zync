-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-09-27
-- Description:	Calculates age in full years from birth date to today.
-- Sample:		SELECT [dbo].[ZzAge]('1990-01-15');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzAge] (@birthDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YY, @birthDate, GETDATE()) - CASE WHEN( (MONTH(@birthDate)*100 + DAY(@birthDate)) > (MONTH(GETDATE())*100 + DAY(GETDATE())) ) THEN 1 ELSE 0 END
END
