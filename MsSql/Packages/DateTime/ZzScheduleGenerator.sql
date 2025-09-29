-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Generates work schedules with patterns (Table-Valued Function).
-- Sample:		SELECT * FROM [dbo].[ZzScheduleGenerator]('2025-10-01','2025-10-31','WEEKLY',1,'MON,TUE,WED,THU,SUN',1);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzScheduleGenerator] (
    @startDate DATE,
    @endDate DATE,
    @pattern NVARCHAR(20) = 'DAILY', -- DAILY, WEEKLY, MONTHLY
    @interval INT = 1,               -- Every N days/weeks/months
    @workDays NVARCHAR(50) = 'MON,TUE,WED,THU,SUN', -- Work days for Iran
    @excludeHolidays BIT = 1
)
RETURNS TABLE
AS
RETURN
(
    WITH DateRange AS (
        SELECT @startDate AS ScheduleDate
        UNION ALL
        SELECT DATEADD(DAY, 1, ScheduleDate)
        FROM DateRange
        WHERE ScheduleDate < @endDate
    ),
    FilteredDates AS (
        SELECT 
            ScheduleDate,
            DATENAME(WEEKDAY, ScheduleDate) AS DayName,
            CASE DATENAME(WEEKDAY, ScheduleDate)
                WHEN 'Monday' THEN 'MON'
                WHEN 'Tuesday' THEN 'TUE' 
                WHEN 'Wednesday' THEN 'WED'
                WHEN 'Thursday' THEN 'THU'
                WHEN 'Friday' THEN 'FRI'
                WHEN 'Saturday' THEN 'SAT'
                WHEN 'Sunday' THEN 'SUN'
            END AS DayCode,
            DATEPART(WEEKDAY, ScheduleDate) AS WeekDayNum,
            ROW_NUMBER() OVER (ORDER BY ScheduleDate) AS DaySequence
        FROM DateRange
    )
    SELECT 
        ScheduleDate,
        DayName,
        DayCode,
        CASE 
            WHEN @excludeHolidays = 1 AND dbo.ZzHolidayChecker(ScheduleDate, 'IR') = 1 
            THEN 'Holiday'
            WHEN @workDays LIKE '%' + DayCode + '%' 
            THEN 'WorkDay'
            ELSE 'Weekend'
        END AS ScheduleType,
        CASE 
            WHEN @excludeHolidays = 1 AND dbo.ZzHolidayChecker(ScheduleDate, 'IR') = 1 
            THEN 0
            WHEN @workDays LIKE '%' + DayCode + '%' 
            THEN 1
            ELSE 0
        END AS IsWorkDay
    FROM FilteredDates
    WHERE 
        -- Apply pattern filtering
        (@pattern = 'DAILY' AND (DaySequence - 1) % @interval = 0)
        OR (@pattern = 'WEEKLY' AND @workDays LIKE '%' + DayCode + '%')
        OR (@pattern = 'MONTHLY' AND DAY(ScheduleDate) = DAY(@startDate) AND 
            DATEDIFF(MONTH, @startDate, ScheduleDate) % @interval = 0)
)