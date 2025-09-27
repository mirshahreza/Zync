-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Checks if a specific bit is set (1) within an integer.
-- Sample:
-- SELECT [dbo].[ZzIsBitSet](5, 0);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzIsBitSet]
(
    @Number INT,
    @BitPosition INT -- Zero-based index of the bit to check
)
RETURNS BIT
AS
BEGIN
    RETURN (@Number & (1 / POWER(2, @BitPosition))) / POWER(2, @BitPosition);
END
