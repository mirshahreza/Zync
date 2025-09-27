-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the Pearson correlation coefficient between two sets of data.
-- =============================================
-- Note: This procedure requires a user-defined table type named 'PairedNumberList'.
-- CREATE TYPE PairedNumberList AS TABLE (X DECIMAL(18, 5), Y DECIMAL(18, 5));
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCorrelation]
    @Data dbo.PairedNumberList READONLY,
    @Correlation DECIMAL(18, 10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @N INT;
    DECLARE @SumX DECIMAL(38, 5), @SumY DECIMAL(38, 5);
    DECLARE @SumX2 DECIMAL(38, 5), @SumY2 DECIMAL(38, 5);
    DECLARE @SumXY DECIMAL(38, 5);

    SELECT 
        @N = COUNT(*),
        @SumX = SUM(X),
        @SumY = SUM(Y),
        @SumX2 = SUM(X*X),
        @SumY2 = SUM(Y*Y),
        @SumXY = SUM(X*Y)
    FROM @Data;

    IF @N < 2
    BEGIN
        SET @Correlation = NULL;
        RETURN;
    END

    DECLARE @Numerator DECIMAL(38, 5);
    DECLARE @Denominator DECIMAL(38, 5);

    SET @Numerator = (@N * @SumXY) - (@SumX * @SumY);
    SET @Denominator = SQRT(((@N * @SumX2) - POWER(@SumX, 2)) * ((@N * @SumY2) - POWER(@SumY, 2)));

    IF @Denominator = 0
    BEGIN
        SET @Correlation = NULL; -- Or 0, depending on desired behavior for perfect vertical/horizontal lines
    END
    ELSE
    BEGIN
        SET @Correlation = @Numerator / @Denominator;
    END
END
