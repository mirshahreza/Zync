-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Constrains a number within a specified range.
-- Sample:
-- SELECT [dbo].[ZzClamp](15, 0, 10);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzClamp]
(
    @Value DECIMAL(38, 10),
    @Min DECIMAL(38, 10),
    @Max DECIMAL(38, 10)
)
RETURNS DECIMAL(38, 10)
AS
BEGIN
    RETURN CASE
        WHEN @Value < @Min THEN @Min
        WHEN @Value > @Max THEN @Max
        ELSE @Value
    END;
END
