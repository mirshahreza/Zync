-- =============================================
-- Author:      Zync
-- Create date: 2025-09-28
-- Description: Computes Effective Annual Rate (EAR) from nominal rate and compounding periods.
-- Sample:      SELECT [dbo].[ZzEffectiveAnnualRate](18, 12);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzEffectiveAnnualRate] (
    @nominalRatePct DECIMAL(18, 8),
    @compoundsPerYear INT
)
RETURNS DECIMAL(18, 8)
AS
BEGIN
    DECLARE @i DECIMAL(38, 20) = @nominalRatePct / 100.0;
    DECLARE @m DECIMAL(38, 20) = NULLIF(@compoundsPerYear, 0);
    IF @m IS NULL RETURN NULL;
    RETURN (POWER(1 + @i/@m, @m) - 1) * 100.0;
END
