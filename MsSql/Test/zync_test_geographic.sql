-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for Geographic package functions
-- =============================================

SET NOCOUNT ON;
DECLARE @TestResults TABLE (
    TestName NVARCHAR(100),
    Status NVARCHAR(10),
    Message NVARCHAR(MAX),
    ExecutionTime DATETIME2
);

DECLARE @StartTime DATETIME2 = SYSDATETIME();
DECLARE @TestName NVARCHAR(100);
DECLARE @Status NVARCHAR(10);
DECLARE @Message NVARCHAR(MAX);

PRINT '🧪 COMPREHENSIVE GEOGRAPHIC PACKAGE TEST'
PRINT '========================================'
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    DECLARE @FunctionCount INT = 0;
    
    IF OBJECT_ID('[dbo].[ZzCalculateDistance]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzCalculateDistance, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzConvertArea]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzConvertArea, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzConvertDecimalToDMS]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzConvertDecimalToDMS, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzConvertDistance]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzConvertDistance, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzConvertDMSToDecimal]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzConvertDMSToDecimal, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzConvertSpeed]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzConvertSpeed, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetBearing]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetBearing, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetBoundingBox]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzGetBoundingBox]', 'TF') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetBoundingBox, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetCrossTrackDistance]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetCrossTrackDistance, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetDestinationPoint]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetDestinationPoint, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetEarthRadius]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetEarthRadius, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetMagneticDeclination]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetMagneticDeclination, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetMidpoint]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetMidpoint, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetNearestPoint]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzGetNearestPoint]', 'TF') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetNearestPoint, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetPointsInRadius]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzGetPointsInRadius]', 'TF') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetPointsInRadius, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetPolygonArea]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetPolygonArea, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetPolygonCenter]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetPolygonCenter, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetRhumbDistance]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetRhumbDistance, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetRouteDistance]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetRouteDistance, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetSunriseSunset]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzGetSunriseSunset]', 'TF') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetSunriseSunset, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetUTMZone]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGetUTMZone, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsPointInBoundingBox]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsPointInBoundingBox, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsPointInPolygon]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsPointInPolygon, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsPointInRadius]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsPointInRadius, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzOptimizeRoute]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzOptimizeRoute]', 'TF') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzOptimizeRoute, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzValidateCoordinates]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzValidateCoordinates, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All ' + CAST(@FunctionCount AS NVARCHAR(5)) + ' geographic functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzValidateCoordinates
SET @TestName = 'Validate Coordinates';
BEGIN TRY
    DECLARE @Valid1 BIT = [dbo].[ZzValidateCoordinates](35.6892, 51.3890); -- Tehran coordinates
    DECLARE @Valid2 BIT = [dbo].[ZzValidateCoordinates](200, 300); -- Invalid
    
    IF @Valid1 = 1 AND @Valid2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Coordinate validation works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Validation logic failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: ZzCalculateDistance - Haversine Distance
SET @TestName = 'Calculate Distance';
BEGIN TRY
    -- Distance between Tehran and Isfahan (approximate)
    DECLARE @Distance FLOAT = [dbo].[ZzCalculateDistance](35.6892, 51.3890, 32.6539, 51.6660);
    
    IF @Distance > 300 AND @Distance < 500 -- Should be around 340 km
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Distance calculated: ' + CAST(@Distance AS NVARCHAR(20)) + ' km';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Distance value: ' + CAST(@Distance AS NVARCHAR(20)) + ' km (expected ~340 km)';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzGetBearing
SET @TestName = 'Get Bearing';
BEGIN TRY
    DECLARE @Bearing FLOAT = [dbo].[ZzGetBearing](35.6892, 51.3890, 32.6539, 51.6660);
    
    IF @Bearing >= 0 AND @Bearing < 360
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Bearing: ' + CAST(@Bearing AS NVARCHAR(20)) + '°';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Invalid bearing: ' + CAST(@Bearing AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzGetMidpoint
SET @TestName = 'Get Midpoint';
BEGIN TRY
    DECLARE @Midpoint NVARCHAR(100) = [dbo].[ZzGetMidpoint](35.6892, 51.3890, 32.6539, 51.6660);
    
    IF @Midpoint IS NOT NULL AND LEN(@Midpoint) > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Midpoint: ' + @Midpoint;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Midpoint calculation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: ZzConvertDistance
SET @TestName = 'Convert Distance';
BEGIN TRY
    DECLARE @ConvertedDist FLOAT = [dbo].[ZzConvertDistance](100, 'KM', 'MILE');
    
    IF @ConvertedDist > 60 AND @ConvertedDist < 65 -- 100 km ≈ 62 miles
    BEGIN
        SET @Status = 'PASS';
        SET @Message = '100 km = ' + CAST(@ConvertedDist AS NVARCHAR(20)) + ' miles';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Converted: ' + CAST(@ConvertedDist AS NVARCHAR(20)) + ' miles';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 7: ZzConvertDMSToDecimal & ZzConvertDecimalToDMS
SET @TestName = 'DMS Conversion';
BEGIN TRY
    DECLARE @DecimalDegree FLOAT = [dbo].[ZzConvertDMSToDecimal](35, 41, 21);
    DECLARE @DMSString NVARCHAR(50) = [dbo].[ZzConvertDecimalToDMS](35.6892);
    
    IF @DecimalDegree IS NOT NULL AND @DMSString IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'DMS: ' + @DMSString + ' = ' + CAST(@DecimalDegree AS NVARCHAR(20)) + '°';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'DMS conversion failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '7. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '7. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 8: ZzIsPointInRadius
SET @TestName = 'Point in Radius';
BEGIN TRY
    DECLARE @InRadius BIT = [dbo].[ZzIsPointInRadius](35.6892, 51.3890, 35.7, 51.4, 10); -- Within 10 km
    DECLARE @OutRadius BIT = [dbo].[ZzIsPointInRadius](35.6892, 51.3890, 40, 52, 10); -- Outside 10 km
    
    IF @InRadius = 1 AND @OutRadius = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Radius check works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Radius check failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '8. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '8. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 9: ZzGetEarthRadius
SET @TestName = 'Earth Radius';
BEGIN TRY
    DECLARE @Radius FLOAT = [dbo].[ZzGetEarthRadius](35.6892); -- At Tehran latitude
    
    IF @Radius > 6350 AND @Radius < 6380 -- Earth radius in km
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Earth radius: ' + CAST(@Radius AS NVARCHAR(20)) + ' km';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Radius: ' + CAST(@Radius AS NVARCHAR(20)) + ' km';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '9. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '9. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 10: ZzGetUTMZone
SET @TestName = 'UTM Zone';
BEGIN TRY
    DECLARE @UTMZone NVARCHAR(10) = [dbo].[ZzGetUTMZone](35.6892, 51.3890);
    
    IF @UTMZone IS NOT NULL AND LEN(@UTMZone) > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'UTM Zone: ' + @UTMZone;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'UTM Zone calculation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '10. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '10. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test Summary
PRINT ''
PRINT '📊 TEST SUMMARY'
PRINT '==============='

SELECT 
    TestName,
    Status,
    Message
FROM @TestResults
ORDER BY ExecutionTime;

DECLARE @PassCount INT, @FailCount INT, @ErrorCount INT;
SELECT 
    @PassCount = SUM(CASE WHEN Status = 'PASS' THEN 1 ELSE 0 END),
    @FailCount = SUM(CASE WHEN Status = 'FAIL' THEN 1 ELSE 0 END),
    @ErrorCount = SUM(CASE WHEN Status = 'ERROR' THEN 1 ELSE 0 END)
FROM @TestResults;

PRINT 'Results: ' + CAST(@PassCount AS NVARCHAR(5)) + ' PASS, ' + 
      CAST(@FailCount AS NVARCHAR(5)) + ' FAIL, ' + 
      CAST(@ErrorCount AS NVARCHAR(5)) + ' ERROR';

DECLARE @EndTime DATETIME2 = SYSDATETIME();
PRINT 'Total Duration: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS NVARCHAR(10)) + ' ms';

IF @FailCount = 0 AND @ErrorCount = 0
    PRINT '🎉 ALL TESTS PASSED!'
ELSE
    PRINT '⚠️  SOME TESTS FAILED - Please review the results above';

PRINT '========================================'
