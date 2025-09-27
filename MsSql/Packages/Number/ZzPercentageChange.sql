-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the percentage increase or decrease from a starting value to an ending value.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzPercentageChange]
(
    @StartValue DECIMAL(38, 10),
    @EndValue DECIMAL(38, 10)
)
RETURNS DECIMAL(38, 2)
AS
BEGIN
    IF @StartValue = 0
        RETURN CASE WHEN @EndValue = 0 THEN 0.00 ELSE NULL END; -- Or handle as infinite change

    RETURN ((@EndValue - @StartValue) / @StartValue) * 100;
END
