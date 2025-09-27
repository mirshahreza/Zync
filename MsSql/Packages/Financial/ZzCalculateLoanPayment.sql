-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Computes monthly annuity payment for a loan.
-- Sample:		SELECT [dbo].[ZzCalculateLoanPayment](100000, 18, 36);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzCalculateLoanPayment] (@principal DECIMAL(18, 2), @rate DECIMAL(5, 2), @months INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @monthlyRate DECIMAL(18, 10) = @rate / 100 / 12;
    RETURN @principal * @monthlyRate * POWER(1 + @monthlyRate, @months) / (POWER(1 + @monthlyRate, @months) - 1);
END
GO
