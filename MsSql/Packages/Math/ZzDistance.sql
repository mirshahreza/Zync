-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the Euclidean distance between two points (x1, y1) and (x2, y2).
-- Sample:
-- SELECT [dbo].[ZzDistance](0, 0, 3, 4);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzDistance]
(
    @x1 DECIMAL(18, 5),
    @y1 DECIMAL(18, 5),
    @x2 DECIMAL(18, 5),
    @y2 DECIMAL(18, 5)
)
RETURNS DECIMAL(18, 5)
AS
BEGIN
    RETURN SQRT(POWER(@x2 - @x1, 2) + POWER(@y2 - @y1, 2));
END
