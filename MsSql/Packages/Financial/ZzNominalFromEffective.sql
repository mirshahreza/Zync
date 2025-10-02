-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-28
-- Description: Computes nominal annual rate from effective annual rate and compounding frequency.
-- Sample:      SELECT [dbo].[ZzNominalFromEffective](19.56, 12);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzNominalFromEffective] (
    @effectiveAnnualRatePct DECIMAL(18, 8),
    @compoundsPerYear INT
)
RETURNS DECIMAL(18, 8)
AS
BEGIN
    DECLARE @ear DECIMAL(38, 20) = @effectiveAnnualRatePct / 100.0;
    DECLARE @m DECIMAL(38, 20) = NULLIF(@compoundsPerYear, 0);
    IF @m IS NULL RETURN NULL;
    -- (1 + EAR) = (1 + i_nom/m)^m => i_nom = m * ((1+EAR)^(1/m) - 1)
    RETURN ( @m * (POWER(1 + @ear, 1/@m) - 1) ) * 100.0;
END
