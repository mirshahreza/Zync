-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	A safe division function that prevents "divide by zero" errors by returning NULL if the denominator is zero.
-- Sample:
-- SELECT [dbo].[ZzSafeDivide](10, 0, 0);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzSafeDivide]
(
    @Numerator DECIMAL(38, 10),
    @Denominator DECIMAL(38, 10),
    @DefaultOnZero DECIMAL(38, 10) = NULL
)
RETURNS DECIMAL(38, 10)
AS
BEGIN
    RETURN CASE
        WHEN @Denominator = 0 THEN @DefaultOnZero
        ELSE @Numerator / @Denominator
    END;
END
