-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Calculates simple interest amount.
-- Sample:		SELECT [dbo].[ZzCalculateInterest](1000, 12, 2);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzCalculateInterest] (@principal DECIMAL(18, 2), @rate DECIMAL(5, 2), @years INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    RETURN @principal * @rate * @years / 100;
END

