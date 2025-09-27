-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Rounds a number to the nearest specified multiple.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzRoundToMultiple] (@Number DECIMAL(38, 10), @Multiple DECIMAL(38, 10))
RETURNS DECIMAL(38, 10)
AS
BEGIN
    IF @Multiple = 0
        RETURN @Number;

    RETURN ROUND(@Number / @Multiple, 0) * @Multiple;
END
