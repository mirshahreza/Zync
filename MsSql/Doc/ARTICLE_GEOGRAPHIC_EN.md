# Geographic in Zync: PostGIS-Inspired Spatial Utilities for SQL Server

Zync is a lightweight, Git-powered package manager for SQL Server that turns collections of SQL scripts into installable, dependency-aware packages. It helps teams ship consistent, reusable database utilities with simple, discoverable commands.

This article focuses on the Geographic package and how it intentionally mirrors PostGIS patterns from PostgreSQL—so spatial developers can feel at home while working on Microsoft SQL Server.

- GitHub: https://github.com/mirshahreza/Zync
- Geographic package folder: MsSql/Packages/Geographic

## Why PostGIS patterns?

PostGIS is the de facto standard for spatial data processing in PostgreSQL. Its thoughtful API design, consistent naming (ST_*), and rich function set have shaped how many engineers think about geospatial work.

The Zync Geographic package adopts the same mental model and naming conventions so that:
- Function names and semantics are familiar to PostGIS users.
- Common tasks (constructing geometry, spatial relationships, buffering, distance queries) look and feel similar.
- Migration between PostgreSQL/PostGIS and SQL Server is easier for mixed environments.

Under the hood, these functions are implemented using SQL Server's native spatial types (geometry and geography) and T‑SQL, and they expose a PostGIS-like surface area where possible.

## Design highlights

- ST_* naming: All spatial helpers follow the ST_* convention with a protective Zz prefix, e.g., ZzST_Buffer, ZzST_Contains, ZzST_DWithin.
- Geometry-first: Core ST_* functions operate on SQL Server geometry; where geodetic accuracy is needed, separate helpers use latitude/longitude and the Haversine formula.
- WKT/WKB friendly: Constructors and I/O helpers accept and return WKT/WKB, easing copy/paste and testing.
- SRID defaults: SRID 4326 (WGS 84) is the default when an SRID is not explicitly provided.
- Familiar semantics: Names and behavior are intentionally aligned with the PostGIS reference where supported by SQL Server's spatial stack.

See the quick reference: MsSql/Doc/POSTGIS_FUNCTIONALITIES.md

## What’s included

Beyond utility routines like coordinate validation and distance conversions, the package ships 45+ PostGIS‑style functions (ZzST_*) including:

- Geometry constructors: ZzST_Point, ZzST_MakePoint, ZzST_MakeLine, ZzST_MakePolygon, ZzST_MakeEnvelope
- I/O helpers: ZzST_AsText, ZzST_AsBinary, ZzST_GeomFromText, ZzST_GeomFromWKB
- Accessors: ZzST_X, ZzST_Y, ZzST_GeometryType, ZzST_SRID
- Measurements and predicates: ZzST_Distance, ZzST_Length, ZzST_Area, ZzST_Perimeter, ZzST_Contains, ZzST_Within, ZzST_Intersects, ZzST_DWithin
- Processing: ZzST_Buffer, ZzST_Centroid, ZzST_Envelope, ZzST_ConvexHull, ZzST_PointOnSurface
- Set operations: ZzST_Union, ZzST_Intersection, ZzST_Difference, ZzST_SymDifference

You’ll also find pragmatic helpers commonly needed in app backends:
- ZzIsPointInRadius, ZzGetPointsInRadius, ZzGetBoundingBox, ZzGetNearestPoint
- Converters and formatters: ZzConvertDMSToDecimal, ZzConvertDecimalToDMS, ZzConvertDistance/Area/Speed

Browse the full list and examples in MsSql/Packages/Geographic/README.md

## Usage examples

Note: geometry is used below; replace with geography where your use case requires spheroid-aware measurements. Default SRID is 4326 unless specified.

1) Construct points and lines (PostGIS‑like):

```sql
-- POINT(lon lat)
SELECT [dbo].[ZzST_AsText](
  [dbo].[ZzST_MakePoint](51.3890, 35.6892, NULL, NULL)
) AS WKT;

-- LINESTRING from two points
SELECT [dbo].[ZzST_AsText](
  [dbo].[ZzST_MakeLine]('51.3890,35.6892;51.4000,35.7000', 4326)
) AS WKT;
```

2) Spatial relationships and predicates:

```sql
-- Envelope (bbox) that contains a point
DECLARE @bbox geometry = [dbo].[ZzST_MakeEnvelope](51.3800, 35.6800, 51.4200, 35.7200, 4326);
DECLARE @pt   geometry = [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326);
SELECT [dbo].[ZzST_Contains](@bbox, @pt) AS ContainsPoint; -- 1 = true, 0 = false
```

3) Distance and proximity:

```sql
-- Are two points within 1km?
DECLARE @a geometry = [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326);
DECLARE @b geometry = [dbo].[ZzST_GeomFromText]('POINT(51.4000 35.7000)', 4326);
SELECT [dbo].[ZzST_DWithin](@a, @b, 1000.0) AS IsNearby;
```

Geodesic distance in meters (geography):

```sql
-- For earth-accurate distances in meters, use the GEOGRAPHY variant
-- Note: geography::Point takes (Latitude, Longitude, SRID)
DECLARE @g1 geography = geography::Point(35.6892, 51.3890, 4326); -- Tehran
DECLARE @g2 geography = geography::Point(35.7000, 51.4000, 4326);
SELECT [dbo].[ZzST_Distance_Meters](@g1, @g2) AS DistanceMeters; -- meters
```

Lat/Lon convenience (function and stored procedure):

```sql
-- Function: input lat/lon, returns meters
SELECT [dbo].[ZzST_Distance_Meters_LatLon](35.6892, 51.3890, 35.7000, 51.4000, 4326) AS DistanceMeters;

-- Procedure: returns both meters and kilometers as OUTPUT params
DECLARE @m FLOAT, @km DECIMAL(15,5);
EXEC [dbo].[ZzST_Distance_Meters_Proc]
  @Lat1=35.6892, @Lon1=51.3890,
  @Lat2=35.7000, @Lon2=51.4000,
  @Meters=@m OUTPUT, @Kilometers=@km OUTPUT;
SELECT @m AS Meters, @km AS Kilometers;
```

4) Buffering:

```sql
-- Create a small buffer around a point (~units depend on SRID)
DECLARE @pt geometry = [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326);
SELECT [dbo].[ZzST_AsText]([dbo].[ZzST_Buffer](@pt, 0.01)) AS Buffered;
```

5) “App friendly” helpers with lat/lon inputs:

```sql
-- Check if a point (lat/lon) is within a radius (KM/MILE/M)
SELECT [dbo].[ZzIsPointInRadius](35.6892, 51.3890, 35.7000, 51.4000, 10, 'KM') AS InRadius;

-- Find points within a radius around a center point (example table schema assumed)
-- SELECT * FROM [dbo].[ZzGetPointsInRadius](
--   @centerLat, @centerLon, @radiusValue, @radiusUnit, @YourPointsTable
-- );
```

## Mapping for PostGIS users

- ST_* naming is preserved with a Zz prefix: e.g., PostGIS ST_Buffer ≈ ZzST_Buffer.
- WKT/WKB inputs are supported via ZzST_GeomFromText and ZzST_GeomFromWKB.
- SRID management via ZzST_SRID and ZzST_SetSRID (no transform).
- SQL Server equivalents (internal) may differ in name (e.g., STBuffer, STDistance), but the wrapper functions provide PostGIS‑like ergonomics.

### Quick mapping table

| PostGIS | Zync Geographic | Notes/Differences |
|---|---|---|
| ST_Buffer | ZzST_Buffer | Buffers on geometry; units depend on the SRID. |
| ST_DWithin | ZzST_DWithin | Proximity within a distance (units = coordinate system units). Consider geography for geodetic accuracy over long distances. |
| ST_Intersects | ZzST_Intersects | Returns 0/1; works across geometry types. |
| ST_Contains | ZzST_Contains | Tests if A completely contains B. |
| ST_Within | ZzST_Within | Tests if A is within B. |
| ST_Distance | ZzST_Distance | Minimum 2D distance; for lat/lon geodetic cases use ZzCalculateDistance (Haversine). |
| ST_AsText | ZzST_AsText | WKT output for viewing/debugging. |
| ST_GeomFromText | ZzST_GeomFromText | Construct geometry from WKT with SRID. |

Caveats and tips:
- Be explicit about SRIDs when mixing data from multiple sources.
- Geography vs geometry: choose geography for long‑distance geodetic calculations; use geometry for planar operations and most predicates.
- Tolerance and units: buffer radii and distances depend on the coordinate system—prefer consistent SRIDs (WGS 84 for GPS).

Units and SRID quick note:
- ZzST_Distance (geometry) returns values in the coordinate system units (e.g., degrees for SRID 4326), suitable for planar math and small extents.
- ZzST_Distance_Meters (geography) returns geodesic distance in meters on the spheroid—recommended for real-world lat/lon distances.

## Installation

Install directly from the Zync repository using the Zync command:

```sql
-- Install the entire Geographic package
EXEC [dbo].[Zync] 'i Geographic';

-- Or install only spatial functions
EXEC [dbo].[Zync] 'i Geographic/ZzST_*.sql';
```

If you don't have Zync yet, run MsSql/Zync.sql from the repository to bootstrap the core procedure. See MsSql/Doc/ARTICLE_EN.md for a gentle introduction and MsSql/scripts/README.md for automation.

## References

- Zync repository: https://github.com/mirshahreza/Zync
- PostGIS docs: https://postgis.net/docs/
- SQL Server spatial types: geometry and geography

---

If you’ve been productive with PostGIS, you’ll feel right at home: the Zync Geographic package brings a familiar, modern spatial toolbox to SQL Server—tested, documented, and ready for production.
