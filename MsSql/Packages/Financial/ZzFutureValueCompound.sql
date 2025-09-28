-- =============================================
-- Author:      Zync
-- Create date: 2025-09-28
-- Description: Computes future value with compound interest.
-- Sample:      SELECT [dbo].[ZzFutureValueCompound](1000, 12, 10);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzFutureValueCompound] (
    @presentValue DECIMAL(18, 6),
    @annualRatePct DECIMAL(18, 8),
    @years DECIMAL(18, 6)
)
RETURNS DECIMAL(18, 6)
AS
BEGIN
    DECLARE @r DECIMAL(38, 20) = @annualRatePct / 100.0;
    RETURN @presentValue * POWER(1 + @r, @years);
END
