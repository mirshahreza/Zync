-- =============================================
-- Geographic Package Installation Script
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description: Complete Geographic package with all coordinate, navigation, area, urban, conversion, geological, and routing functions
-- =============================================

PRINT 'Installing Geographic Package...'

-- Core geographic functions
:r ZzCalculateDistance.sql
:r ZzValidatePostalCode.sql
:r ZzValidateCoordinates.sql
:r ZzIsPointInRadius.sql
:r ZzGetProvinceFromCity.sql
:r ZzGetMidpoint.sql
:r ZzGetBearing.sql

-- Coordinate conversion functions
:r ZzConvertDecimalToDMS.sql
:r ZzGetUTMZone.sql

-- Navigation functions
:r ZzGetDestinationPoint.sql
:r ZzGetRhumbDistance.sql
:r ZzGetCrossTrackDistance.sql

-- Area and polygon functions
:r ZzIsPointInPolygon.sql
:r ZzGetPolygonArea.sql
:r ZzGetPolygonCenter.sql
:r ZzGetBoundingBox.sql

-- Urban and address functions
:r ZzGetCityFromPostalCode.sql
:r ZzGetDistrictFromCoords.sql
:r ZzNormalizeAddress.sql

-- Unit conversion functions
:r ZzConvertArea.sql
:r ZzConvertSpeed.sql
:r ZzGetEarthRadius.sql

-- Geological and astronomical functions
:r ZzGetElevationZone.sql
:r ZzGetTimeZone.sql
:r ZzGetSunriseSunset.sql
:r ZzGetMagneticDeclination.sql

-- Routing functions
:r ZzGetRouteDistance.sql
:r ZzOptimizeRoute.sql
:r ZzGetNearestPoint.sql
:r ZzGetPointsInRadius.sql

PRINT 'Geographic Package installed successfully!'
PRINT 'Available functions:'
PRINT '  Core: ZzCalculateDistance, ZzValidatePostalCode, ZzValidateCoordinates, ZzIsPointInRadius'
PRINT '  Iranian Data: ZzGetProvinceFromCity, ZzGetCityFromPostalCode, ZzGetDistrictFromCoords'
PRINT '  Navigation: ZzGetMidpoint, ZzGetBearing, ZzGetDestinationPoint, ZzGetRhumbDistance, ZzGetCrossTrackDistance'
PRINT '  Coordinates: ZzConvertDecimalToDMS, ZzGetUTMZone'
PRINT '  Area/Polygon: ZzIsPointInPolygon, ZzGetPolygonArea, ZzGetPolygonCenter, ZzGetBoundingBox'
PRINT '  Address: ZzNormalizeAddress'
PRINT '  Conversion: ZzConvertArea, ZzConvertSpeed, ZzGetEarthRadius'
PRINT '  Geological: ZzGetElevationZone, ZzGetTimeZone, ZzGetSunriseSunset, ZzGetMagneticDeclination'
PRINT '  Routing: ZzGetRouteDistance, ZzOptimizeRoute, ZzGetNearestPoint, ZzGetPointsInRadius'