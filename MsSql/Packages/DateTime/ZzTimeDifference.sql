CREATE FUNCTION ZzTimeDifference (@time1 TIME, @time2 TIME)
RETURNS TIME
AS
BEGIN
    DECLARE @seconds1 INT = DATEPART(HOUR, @time1) * 3600 + DATEPART(MINUTE, @time1) * 60 + DATEPART(SECOND, @time1)
    DECLARE @seconds2 INT = DATEPART(HOUR, @time2) * 3600 + DATEPART(MINUTE, @time2) * 60 + DATEPART(SECOND, @time2)
    DECLARE @diff INT = ABS(@seconds1 - @seconds2)
    RETURN TIMEFROMPARTS(@diff / 3600, (@diff % 3600) / 60, @diff % 60, 0, 0)
END
GO
