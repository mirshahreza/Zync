-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the future value of an investment.
-- Sample:
-- SELECT [dbo].[ZzFutureValue](0.05, 10, 100, 1000);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzFutureValue]
(
    @Rate DECIMAL(18, 4), -- Interest rate per period
    @NPer INT,             -- Total number of payment periods
    @Pmt DECIMAL(18, 2),   -- Payment made each period
    @Pv DECIMAL(18, 2)     -- Present value (or a lump-sum starting value)
)
RETURNS DECIMAL(38, 6)
AS
BEGIN
    -- Formula: FV = PV * (1 + r)^n + PMT * [((1 + r)^n - 1) / r]
    RETURN @Pv * POWER(1 + @Rate, @NPer) + @Pmt * ((POWER(1 + @Rate, @NPer) - 1) / @Rate);
END
