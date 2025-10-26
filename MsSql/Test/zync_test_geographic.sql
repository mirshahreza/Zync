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
    
    -- PostGIS-compatible spatial functions (ZzST_*)
    IF OBJECT_ID('[dbo].[ZzST_Point]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Point, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_MakePoint]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_MakePoint, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_AsText]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_AsText, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_GeomFromText]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_GeomFromText, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_AsBinary]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_AsBinary, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_GeomFromWKB]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_GeomFromWKB, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_X]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_X, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Y]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Y, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Distance]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Distance, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Area]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Area, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Length]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Length, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Contains]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Contains, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Within]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Within, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Intersects]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Intersects, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Buffer]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Buffer, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_SRID]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_SRID, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_SetSRID]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_SetSRID, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_GeometryType]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_GeometryType, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_IsEmpty]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_IsEmpty, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_IsValid]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_IsValid, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_MakeLine]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_MakeLine, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_MakePolygon]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_MakePolygon, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_MakeEnvelope]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_MakeEnvelope, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Envelope]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Envelope, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_ConvexHull]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_ConvexHull, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Intersection]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Intersection, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Union]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Union, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Difference]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Difference, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_SymDifference]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_SymDifference, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_NPoints]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_NPoints, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_NumGeometries]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_NumGeometries, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_GeometryN]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_GeometryN, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_PointN]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_PointN, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_StartPoint]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_StartPoint, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_EndPoint]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_EndPoint, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Centroid]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Centroid, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_PointOnSurface]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_PointOnSurface, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Equals]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Equals, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Disjoint]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Disjoint, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Touches]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Touches, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Overlaps]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Overlaps, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Crosses]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Crosses, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Covers]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Covers, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Dimension]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Dimension, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_DWithin]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_DWithin, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzST_Perimeter]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzST_Perimeter, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    
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

-- Test 11: ZzST_Point and ZzST_AsText
SET @TestName = 'ST_Point & ST_AsText';
BEGIN TRY
    DECLARE @Point GEOMETRY = [dbo].[ZzST_Point](51.3890, 35.6892, 4326);
    DECLARE @WKT NVARCHAR(MAX) = [dbo].[ZzST_AsText](@Point);
    
    IF @Point IS NOT NULL AND @WKT LIKE '%POINT%'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Point created: ' + @WKT;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Point creation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '11. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '11. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 12: ZzST_Distance
SET @TestName = 'ST_Distance';
BEGIN TRY
    DECLARE @P1 GEOMETRY = [dbo].[ZzST_Point](0, 0, 0);
    DECLARE @P2 GEOMETRY = [dbo].[ZzST_Point](3, 4, 0);
    DECLARE @Dist FLOAT = [dbo].[ZzST_Distance](@P1, @P2);
    
    IF @Dist = 5.0 -- 3-4-5 triangle
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Distance calculated correctly: ' + CAST(@Dist AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Expected 5.0, got: ' + CAST(@Dist AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '12. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '12. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 13: ZzST_Area
SET @TestName = 'ST_Area';
BEGIN TRY
    DECLARE @Polygon GEOMETRY = [dbo].[ZzST_MakePolygon]('0,0;0,10;10,10;10,0;0,0', 0);
    DECLARE @AreaVal FLOAT = [dbo].[ZzST_Area](@Polygon);
    
    IF @AreaVal = 100.0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Area calculated correctly: ' + CAST(@AreaVal AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Expected 100.0, got: ' + CAST(@AreaVal AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '13. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '13. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 14: ZzST_Contains
SET @TestName = 'ST_Contains';
BEGIN TRY
    DECLARE @PolyContainer GEOMETRY = [dbo].[ZzST_GeomFromText]('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0);
    DECLARE @PointInside GEOMETRY = [dbo].[ZzST_Point](5, 5, 0);
    DECLARE @ContainsResult BIT = [dbo].[ZzST_Contains](@PolyContainer, @PointInside);
    
    IF @ContainsResult = 1
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Contains test passed';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Contains test failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '14. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '14. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 15: ZzST_Intersects
SET @TestName = 'ST_Intersects';
BEGIN TRY
    DECLARE @Line1 GEOMETRY = [dbo].[ZzST_GeomFromText]('LINESTRING(0 0, 10 10)', 0);
    DECLARE @Line2 GEOMETRY = [dbo].[ZzST_GeomFromText]('LINESTRING(0 10, 10 0)', 0);
    DECLARE @IntersectsResult BIT = [dbo].[ZzST_Intersects](@Line1, @Line2);
    
    IF @IntersectsResult = 1
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Intersects test passed';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Intersects test failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '15. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '15. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 16: ZzST_Buffer
SET @TestName = 'ST_Buffer';
BEGIN TRY
    DECLARE @PointForBuffer GEOMETRY = [dbo].[ZzST_Point](0, 0, 0);
    DECLARE @Buffered GEOMETRY = [dbo].[ZzST_Buffer](@PointForBuffer, 10);
    
    IF @Buffered IS NOT NULL AND [dbo].[ZzST_GeometryType](@Buffered) = 'ST_Polygon'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Buffer created successfully';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Buffer creation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '16. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '16. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
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
