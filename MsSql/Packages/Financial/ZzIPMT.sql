-- =============================================
-- Author:      Zync
-- Create date: 2025-09-28
-- Description: Interest portion of a payment for a period in an annuity.
-- Sample:      SELECT [dbo].[ZzIPMT](18, 36, 1, 100000);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzIPMT] (
    @annualRatePct DECIMAL(18, 8),
    @nper INT,
    @per INT,
    @presentValue DECIMAL(18, 6)
)
RETURNS DECIMAL(18, 6)
AS
BEGIN
    IF @nper <= 0 OR @per <= 0 OR @per > @nper RETURN NULL;
    DECLARE @r DECIMAL(38, 20) = @annualRatePct / 100.0 / 12.0;
    -- Balance at start of period 'per-1'
    DECLARE @pmt DECIMAL(38, 20) = @presentValue * @r * POWER(1+@r, @nper) / (POWER(1+@r, @nper) - 1);
    DECLARE @balance DECIMAL(38, 20) = @presentValue;
    DECLARE @i INT = 1;
    WHILE @i < @per
    BEGIN
        DECLARE @interest DECIMAL(38, 20) = @balance * @r;
        DECLARE @principal DECIMAL(38, 20) = @pmt - @interest;
        SET @balance = @balance - @principal;
        SET @i = @i + 1;
    END
    RETURN CAST(@balance * @r AS DECIMAL(18,6));
END
