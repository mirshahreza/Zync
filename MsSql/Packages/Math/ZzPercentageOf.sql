-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the percentage that one number represents of a total.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzPercentageOf]
(
    @Part DECIMAL(38, 10),
    @Total DECIMAL(38, 10)
)
RETURNS DECIMAL(38, 2)
AS
BEGIN
    IF @Total = 0
        RETURN 0.00;

    RETURN (@Part / @Total) * 100;
END
