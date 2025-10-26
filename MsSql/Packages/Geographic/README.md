# 🌍 Geographic Package

The `Geographic` package provides a collection of functions for geographic calculations, location validation, and address operations.

## 🚀 Deployment

To deploy all scripts in the `Geographic` package:
```sql
EXEC dbo.Zync 'i Geographic'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Geographic/.sql'
```

## 📜 Included Utilities

### 📏 Distance & Calculations
- ZzCalculateDistance: Calculate distance between two geographic points
	- Example: `SELECT [dbo].[ZzCalculateDistance](35.6892, 51.3890, 40.7128, -74.0060, 'KM');`
- ZzConvertDistance: Convert distance between different units
	- Example: `SELECT [dbo].[ZzConvertDistance](100, 'KM', 'MILE');`
- ZzGetBearing: Calculate bearing (direction) between two geographic points
	- Example: `SELECT [dbo].[ZzGetBearing](35.6892, 51.3890, 40.7128, -74.0060);`
- ZzGetMidpoint: Calculate midpoint between two geographic points
	- Example: `SELECT [dbo].[ZzGetMidpoint](35.6892, 51.3890, 40.7128, -74.0060);`

### ✅ Validation & Verification
- ZzValidateCoordinates: Validate latitude and longitude values
	- Example: `SELECT [dbo].[ZzValidateCoordinates](35.6892, 51.3890);`
- ZzValidatePostalCode: Validate Iranian postal code format
	- Example: `SELECT [dbo].[ZzValidatePostalCode]('1234567890');`
- ZzValidateIranianCoordinates: Check if coordinates are within Iran's borders
	- Example: `SELECT [dbo].[ZzValidateIranianCoordinates](35.6892, 51.3890);`

### 🗺️ Area & Boundary Functions
- ZzIsPointInRadius: Check if a point is within radius of another point
	- Example: `SELECT [dbo].[ZzIsPointInRadius](35.6892, 51.3890, 35.7000, 51.4000, 10, 'KM');`
- ZzIsPointInBoundingBox: Check if point is inside bounding box
	- Example: `SELECT [dbo].[ZzIsPointInBoundingBox](35.7, 51.4, 35.6, 51.3, 35.8, 51.5);`

### 🔄 Coordinate Conversion
- ZzConvertDMSToDecimal: Convert Degrees/Minutes/Seconds to Decimal
	- Example: `SELECT [dbo].[ZzConvertDMSToDecimal](35, 41, 21, 'N');`

### 🏙️ Iranian Geographic Data
- ZzGetProvinceFromCity: Get province name from Iranian city name
	- Example: `SELECT [dbo].[ZzGetProvinceFromCity](N'Tehran');`

### 🗺️ PostGIS-Compatible Spatial Functions (ZzST_*)

The Geographic package now includes 45+ PostGIS-compatible spatial functions using SQL Server's native GEOMETRY type. These functions follow PostGIS naming conventions with the `ZzST_` prefix.

#### Geometry Constructors
- ZzST_Point: Creates a Point geometry from X and Y coordinates
	- Example: `SELECT [dbo].[ZzST_Point](51.3890, 35.6892).ToString();`
- ZzST_MakePoint: Creates a 2D, 3DZ or 4D Point geometry
	- Example: `SELECT [dbo].[ZzST_MakePoint](51.3890, 35.6892, 100, NULL).ToString();`
- ZzST_MakeLine: Creates a LineString from Point geometries
	- Example: `SELECT [dbo].[ZzST_MakeLine]('51.3890,35.6892;51.4000,35.7000', 4326).ToString();`
- ZzST_MakePolygon: Creates a Polygon from a shell
	- Example: `SELECT [dbo].[ZzST_MakePolygon]('0,0;0,10;10,10;10,0;0,0', 4326).ToString();`
- ZzST_MakeEnvelope: Creates a rectangular Polygon from min/max coordinates
	- Example: `SELECT [dbo].[ZzST_MakeEnvelope](51.3890, 35.6892, 51.4100, 35.7100, 4326).ToString();`

#### Input/Output Functions
- ZzST_AsText: Returns WKT (Well-Known Text) representation
	- Example: `SELECT [dbo].[ZzST_AsText](geometry::Point(51.3890, 35.6892, 4326));`
- ZzST_GeomFromText: Creates geometry from WKT
	- Example: `SELECT [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326).ToString();`
- ZzST_AsBinary: Returns WKB (Well-Known Binary) representation
	- Example: `SELECT [dbo].[ZzST_AsBinary](geometry::Point(51.3890, 35.6892, 4326));`
- ZzST_GeomFromWKB: Creates geometry from WKB
	- Example: `SELECT [dbo].[ZzST_GeomFromWKB](0x0101000000..., 4326).ToString();`

#### Coordinate Accessors
- ZzST_X: Returns X coordinate of a Point
	- Example: `SELECT [dbo].[ZzST_X](geometry::Point(51.3890, 35.6892, 4326));`
- ZzST_Y: Returns Y coordinate of a Point
	- Example: `SELECT [dbo].[ZzST_Y](geometry::Point(51.3890, 35.6892, 4326));`

#### Measurement Functions
- ZzST_Distance: Calculates minimum distance between geometries
	- Example: `SELECT [dbo].[ZzST_Distance](geometry::Point(51.3890, 35.6892, 4326), geometry::Point(51.4000, 35.7000, 4326));`
- ZzST_Area: Calculates 2D area of polygon
	- Example: `SELECT [dbo].[ZzST_Area](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0));`
- ZzST_Length: Calculates 2D length of LineString
	- Example: `SELECT [dbo].[ZzST_Length](geometry::STGeomFromText('LINESTRING(0 0, 10 10, 20 20)', 0));`
- ZzST_Perimeter: Calculates 2D perimeter of polygon
	- Example: `SELECT [dbo].[ZzST_Perimeter](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0));`

#### Spatial Relationships
- ZzST_Contains: Tests if geometry A contains B
	- Example: `SELECT [dbo].[ZzST_Contains](polygon, point);`
- ZzST_Within: Tests if geometry A is within B
	- Example: `SELECT [dbo].[ZzST_Within](point, polygon);`
- ZzST_Intersects: Tests if geometries intersect
	- Example: `SELECT [dbo].[ZzST_Intersects](line1, line2);`
- ZzST_Equals: Tests if geometries are spatially equal
- ZzST_Disjoint: Tests if geometries are disjoint
- ZzST_Touches: Tests if geometries touch
- ZzST_Overlaps: Tests if geometries overlap
- ZzST_Crosses: Tests if geometries cross
- ZzST_Covers: Tests if geometry A covers B
- ZzST_DWithin: Tests if geometries are within distance

#### Boolean Operations
- ZzST_Intersection: Computes geometric intersection
- ZzST_Union: Computes geometric union
- ZzST_Difference: Computes geometric difference
- ZzST_SymDifference: Computes symmetric difference

#### Geometry Processing
- ZzST_Buffer: Creates buffer around geometry
	- Example: `SELECT [dbo].[ZzST_Buffer](geometry::Point(51.3890, 35.6892, 4326), 0.01).ToString();`
- ZzST_ConvexHull: Computes convex hull
- ZzST_Envelope: Returns bounding box as geometry
- ZzST_Centroid: Computes geometric center
- ZzST_PointOnSurface: Returns point guaranteed to be on surface

#### Geometry Accessors
- ZzST_GeometryType: Returns the type of geometry
- ZzST_Dimension: Returns the dimension of geometry
- ZzST_IsEmpty: Tests if geometry is empty
- ZzST_IsValid: Tests if geometry is valid
- ZzST_NPoints: Returns number of points in geometry
- ZzST_NumGeometries: Returns number of geometries in a collection
- ZzST_GeometryN: Returns Nth geometry in a collection
- ZzST_PointN: Returns Nth point in a LineString
- ZzST_StartPoint: Returns first point of a LineString
- ZzST_EndPoint: Returns last point of a LineString

#### SRID Management
- ZzST_SRID: Gets SRID of geometry
	- Example: `SELECT [dbo].[ZzST_SRID](geometry::Point(51.3890, 35.6892, 4326));`
- ZzST_SetSRID: Sets SRID without transforming
	- Example: `SELECT [dbo].[ZzST_SetSRID](geometry::Point(51.3890, 35.6892, 0), 4326).STSrid;`

Notes:
- `ls Geographic` shows each item with its short description taken from a `-- Description:` line at the top of the script.
- Distance calculations use the Haversine formula for accuracy
- Coordinates are expected in decimal degrees format
- Supports Iranian geographic data and postal codes
- PostGIS-compatible functions (ZzST_*) leverage SQL Server's native GEOMETRY type
- Default SRID for spatial functions is 4326 (WGS 84 - GPS coordinates)