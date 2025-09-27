-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the slope and intercept for a simple linear regression.
-- =============================================
-- Note: This procedure requires a user-defined table type named 'PairedNumberList'.
-- CREATE TYPE PairedNumberList AS TABLE (X DECIMAL(18, 5), Y DECIMAL(18, 5));
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzRegression]
    @Data dbo.PairedNumberList READONLY,
    @Slope DECIMAL(18, 10) OUTPUT,
    @Intercept DECIMAL(18, 10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @N INT;
    DECLARE @SumX DECIMAL(38, 5), @SumY DECIMAL(38, 5);
    DECLARE @SumX2 DECIMAL(38, 5), @SumXY DECIMAL(38, 5);

    SELECT 
        @N = COUNT(*),
        @SumX = SUM(X),
        @SumY = SUM(Y),
        @SumX2 = SUM(X*X),
        @SumXY = SUM(X*Y)
    FROM @Data;

    IF @N < 2
    BEGIN
        SET @Slope = NULL;
        SET @Intercept = NULL;
        RETURN;
    END

    DECLARE @Denominator DECIMAL(38, 5);
    SET @Denominator = (@N * @SumX2) - POWER(@SumX, 2);

    IF @Denominator = 0
    BEGIN
        SET @Slope = NULL; -- Vertical line, slope is undefined
        SET @Intercept = NULL;
    END
    ELSE
    BEGIN
        SET @Slope = ((@N * @SumXY) - (@SumX * @SumY)) / @Denominator;
        SET @Intercept = (SUM(@SumY) / @N) - (@Slope * (SUM(@SumX) / @N));
    END
END
