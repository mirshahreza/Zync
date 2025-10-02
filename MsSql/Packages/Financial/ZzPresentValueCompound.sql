-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-28
-- Description: Computes present value from future value with compound discounting.
-- Sample:      SELECT [dbo].[ZzPresentValueCompound](2000, 12, 10);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzPresentValueCompound] (
    @futureValue DECIMAL(18, 6),
    @annualRatePct DECIMAL(18, 8),
    @years DECIMAL(18, 6)
)
RETURNS DECIMAL(18, 6)
AS
BEGIN
    DECLARE @r DECIMAL(38, 20) = @annualRatePct / 100.0;
    RETURN @futureValue / POWER(1 + @r, @years);
END
