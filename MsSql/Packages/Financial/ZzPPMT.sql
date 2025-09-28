-- =============================================
-- Author:      Zync
-- Create date: 2025-09-28
-- Description: Principal portion of a payment for a period in an annuity.
-- Sample:      SELECT [dbo].[ZzPPMT](18, 36, 1, 100000);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzPPMT] (
    @annualRatePct DECIMAL(18, 8),
    @nper INT,
    @per INT,
    @presentValue DECIMAL(18, 6)
)
RETURNS DECIMAL(18, 6)
AS
BEGIN
    -- PPMT = PMT - IPMT
    DECLARE @r DECIMAL(38, 20) = @annualRatePct / 100.0 / 12.0;
    DECLARE @pmt DECIMAL(38, 20) = @presentValue * @r * POWER(1+@r, @nper) / (POWER(1+@r, @nper) - 1);
    RETURN CAST(@pmt - [dbo].[ZzIPMT](@annualRatePct, @nper, @per, @presentValue) AS DECIMAL(18,6));
END
