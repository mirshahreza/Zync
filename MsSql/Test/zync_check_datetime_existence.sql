-- =============================================
-- Author:		Mohsen Mirshahreza  
-- Create date: 2025-09-30
-- Description:	Quick syntax check for advanced DateTime functions
-- =============================================

PRINT 'Quick Syntax Check for Advanced DateTime Functions...';
PRINT '====================================================';

-- Check if advanced DateTime functions exist
PRINT 'Checking function existence...';

IF OBJECT_ID('[dbo].[ZzConvertToLunar]', 'FN') IS NOT NULL
    PRINT '✓ ZzConvertToLunar function exists'
ELSE
    PRINT '✗ ZzConvertToLunar function missing';

IF OBJECT_ID('[dbo].[ZzHolidayChecker]', 'FN') IS NOT NULL
    PRINT '✓ ZzHolidayChecker function exists'
ELSE
    PRINT '✗ ZzHolidayChecker function missing';

IF OBJECT_ID('[dbo].[ZzDateValidator]', 'FN') IS NOT NULL
    PRINT '✓ ZzDateValidator function exists'
ELSE
    PRINT '✗ ZzDateValidator function missing';

IF OBJECT_ID('[dbo].[ZzTimeZoneConverter]', 'FN') IS NOT NULL
    PRINT '✓ ZzTimeZoneConverter function exists'
ELSE
    PRINT '✗ ZzTimeZoneConverter function missing';

IF OBJECT_ID('[dbo].[ZzBusinessDaysCalculator]', 'FN') IS NOT NULL
    PRINT '✓ ZzBusinessDaysCalculator function exists'
ELSE
    PRINT '✗ ZzBusinessDaysCalculator function missing';

IF OBJECT_ID('[dbo].[ZzScheduleGenerator]', 'TF') IS NOT NULL
    PRINT '✓ ZzScheduleGenerator table function exists'
ELSE
    PRINT '✗ ZzScheduleGenerator table function missing';

PRINT '====================================================';
PRINT 'Syntax check completed.';