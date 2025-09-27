-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the present value of an investment or loan.
-- Sample:
-- SELECT [dbo].[ZzPresentValue](0.05, 10, 100, 10000);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzPresentValue]
(
    @Rate DECIMAL(18, 4), -- Interest rate per period
    @NPer INT,             -- Total number of payment periods
    @Pmt DECIMAL(18, 2),   -- Payment made each period
    @Fv DECIMAL(18, 2)     -- Future value
)
RETURNS DECIMAL(38, 6)
AS
BEGIN
    -- Formula: PV = (PMT * (1 - (1 + r)^-n) / r) + FV / (1 + r)^n
    DECLARE @RateFactor DECIMAL(38, 18) = POWER(1 + @Rate, @NPer);
    RETURN (@Pmt * (1 - 1 / @RateFactor) / @Rate) + @Fv / @RateFactor;
END
