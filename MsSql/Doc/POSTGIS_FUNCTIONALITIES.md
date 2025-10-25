# PostGIS Functionalities Reference List

This document provides a comprehensive list of PostGIS functionalities in PostgreSQL. PostGIS is a spatial database extender for PostgreSQL that adds support for geographic objects and spatial queries.

## 1. Geometry Constructors

### Basic Constructors
- ST_Point - Creates a Point geometry
- ST_LineString - Creates a LineString geometry
- ST_Polygon - Creates a Polygon geometry
- ST_MultiPoint - Creates a MultiPoint geometry
- ST_MultiLineString - Creates a MultiLineString geometry
- ST_MultiPolygon - Creates a MultiPolygon geometry
- ST_GeometryCollection - Creates a GeometryCollection
- ST_MakePoint - Creates a 2D, 3DZ or 4D Point geometry
- ST_MakePointM - Creates a Point with M coordinate
- ST_MakeLine - Creates a LineString from Point geometries
- ST_MakePolygon - Creates a Polygon from a shell and optional holes
- ST_MakeEnvelope - Creates a rectangular Polygon from minimum/maximum coordinates

### Advanced Constructors
- ST_Collect - Creates a GeometryCollection or Multi* geometry from a set of geometries
- ST_BuildArea - Creates an areal geometry from linestrings
- ST_Polygonize - Creates a collection of polygons from linestrings
- ST_Split - Splits a geometry by a blade geometry
- ST_Union - Merges geometries into one
- ST_Buffer - Creates a buffer around a geometry
- ST_ConvexHull - Computes the convex hull of a geometry
- ST_ConcaveHull - Computes the concave hull (alpha shape) of a geometry
- ST_Voronoi - Creates Voronoi diagram from points
- ST_DelaunayTriangles - Returns Delaunay triangulation of points

## 2. Geometry Accessors

### Basic Properties
- ST_GeometryType - Returns the type of geometry
- ST_Dimension - Returns the dimension of geometry
- ST_CoordDim - Returns the coordinate dimension
- ST_SRID - Returns the Spatial Reference System ID
- ST_IsEmpty - Tests if geometry is empty
- ST_IsSimple - Tests if geometry is simple
- ST_IsValid - Tests if geometry is valid
- ST_IsValidReason - Returns text reason for invalidity
- ST_IsValidDetail - Returns detailed information about invalidity

### Coordinate Accessors
- ST_X - Returns X coordinate of a Point
- ST_Y - Returns Y coordinate of a Point
- ST_Z - Returns Z coordinate of a Point
- ST_M - Returns M coordinate of a Point
- ST_XMin - Returns minimum X coordinate
- ST_XMax - Returns maximum X coordinate
- ST_YMin - Returns minimum Y coordinate
- ST_YMax - Returns maximum Y coordinate
- ST_ZMin - Returns minimum Z coordinate
- ST_ZMax - Returns maximum Z coordinate

### Component Accessors
- ST_NPoints - Returns number of points in geometry
- ST_NRings - Returns number of rings in a polygon
- ST_NumGeometries - Returns number of geometries in a collection
- ST_GeometryN - Returns Nth geometry in a collection
- ST_NumInteriorRings - Returns number of interior rings (holes)
- ST_InteriorRingN - Returns Nth interior ring
- ST_ExteriorRing - Returns exterior ring of a polygon
- ST_PointN - Returns Nth point in a LineString
- ST_StartPoint - Returns first point of a LineString
- ST_EndPoint - Returns last point of a LineString

## 3. Geometry Editors

### Transformation Functions
- ST_Transform - Transforms geometry to different SRID
- ST_SetSRID - Sets the SRID without transforming
- ST_Translate - Translates geometry by offsets
- ST_TransScale - Translates and scales geometry
- ST_Scale - Scales geometry
- ST_Rotate - Rotates geometry
- ST_RotateX - Rotates geometry around X axis
- ST_RotateY - Rotates geometry around Y axis
- ST_RotateZ - Rotates geometry around Z axis
- ST_Affine - Applies 3D affine transformation

### Modification Functions
- ST_AddPoint - Adds a point to a LineString
- ST_RemovePoint - Removes a point from a LineString
- ST_SetPoint - Replaces a point in a LineString
- ST_Reverse - Reverses vertex order of geometry
- ST_ForceRHR - Forces polygon rings to follow right-hand rule
- ST_Force2D - Forces geometry to 2D mode
- ST_Force3D - Forces geometry to 3D mode
- ST_Force3DZ - Forces geometry to 3DZ mode
- ST_Force3DM - Forces geometry to 3DM mode
- ST_Force4D - Forces geometry to 4D mode
- ST_ForceCollection - Converts to GeometryCollection
- ST_ForceCurve - Forces geometry to use circular arcs
- ST_LineMerge - Merges connected linestrings
- ST_CollectionExtract - Extracts specific geometry type from collection
- ST_CollectionHomogenize - Returns simplest representation

### Simplification & Precision
- ST_Simplify - Simplifies geometry using Douglas-Peucker algorithm
- ST_SimplifyPreserveTopology - Simplifies while preserving topology
- ST_SimplifyVW - Simplifies using Visvalingam-Whyatt algorithm
- ST_SnapToGrid - Snaps coordinates to a grid
- ST_RemoveRepeatedPoints - Removes repeated points
- ST_ChaikinSmoothing - Smooths geometry using Chaikin's algorithm
- ST_ReducePrecision - Reduces coordinate precision

## 4. Spatial Relationships (Topological Functions)

### Relationship Tests
- ST_Equals - Tests if geometries are spatially equal
- ST_Disjoint - Tests if geometries are disjoint
- ST_Touches - Tests if geometries touch
- ST_Within - Tests if geometry A is within B
- ST_Overlaps - Tests if geometries overlap
- ST_Crosses - Tests if geometries cross
- ST_Intersects - Tests if geometries intersect
- ST_Contains - Tests if geometry A contains B
- ST_Covers - Tests if geometry A covers B
- ST_CoveredBy - Tests if geometry A is covered by B
- ST_ContainsProperly - Tests if A contains B (with no boundary intersection)
- ST_Relate - Tests spatial relationship using DE-9IM pattern

### Distance Relationships
- ST_DWithin - Tests if geometries are within distance
- ST_DFullyWithin - Tests if all points are within distance

### Dimensional Extended 9-Intersection Model (DE-9IM)
- ST_RelateMatch - Tests if DE-9IM pattern matches
- ST_OrderingEquals - Tests if geometries are equal and have same vertex order

## 5. Measurement Functions

### Distance Measurements
- ST_Distance - Calculates minimum distance between geometries
- ST_3DDistance - Calculates 3D distance
- ST_DistanceSphere - Calculates distance on a sphere
- ST_DistanceSpheroid - Calculates distance on a spheroid
- ST_MaxDistance - Calculates maximum distance between geometries
- ST_HausdorffDistance - Calculates Hausdorff distance
- ST_FrechetDistance - Calculates Frechet distance
- ST_ClosestPoint - Returns closest point on geometry A to B
- ST_ShortestLine - Returns shortest line between geometries
- ST_LongestLine - Returns longest line between geometries

### Length & Perimeter
- ST_Length - Calculates 2D length of LineString
- ST_Length2D - Calculates 2D length
- ST_3DLength - Calculates 3D length
- ST_LengthSpheroid - Calculates length on spheroid
- ST_Perimeter - Calculates 2D perimeter of polygon
- ST_Perimeter2D - Calculates 2D perimeter
- ST_3DPerimeter - Calculates 3D perimeter

### Area Measurements
- ST_Area - Calculates 2D area of polygon
- ST_3DArea - Calculates 3D area
- ST_AreaSpheroid - Calculates area on spheroid

## 6. Overlay Functions

### Boolean Operations
- ST_Intersection - Computes geometric intersection
- ST_Union - Computes geometric union
- ST_Difference - Computes geometric difference
- ST_SymDifference - Computes symmetric difference
- ST_UnaryUnion - Computes union of a single geometry's components
- ST_MemUnion - Memory-efficient union (deprecated, use ST_Union)
- ST_Node - Nodes a collection of linestrings
- ST_Split - Splits a geometry by another geometry

### Clipping Functions
- ST_ClipByBox2D - Clips geometry by a 2D box
- ST_Subdivide - Subdivides geometry into smaller parts
- ST_SubdivideByGrid - Subdivides using a grid

## 7. Geometry Processing

### Buffer Operations
- ST_Buffer - Creates buffer around geometry
- ST_OffsetCurve - Creates offset line
- ST_SingleSidedBuffer - Creates single-sided buffer

### Geometric Analysis
- ST_ConvexHull - Computes convex hull
- ST_ConcaveHull - Computes concave hull
- ST_MinimumBoundingCircle - Computes minimum bounding circle
- ST_MinimumBoundingRadius - Returns radius of minimum bounding circle
- ST_OrientedEnvelope - Computes oriented minimum bounding rectangle
- ST_MinimumClearance - Computes minimum clearance
- ST_MinimumClearanceLine - Returns line showing minimum clearance

### Centerline & Medial Axis
- ST_Centroid - Computes geometric center
- ST_PointOnSurface - Returns point guaranteed to be on surface
- ST_GeometricMedian - Computes geometric median

### Linear Referencing
- ST_LineInterpolatePoint - Interpolates point along line at fraction
- ST_LineInterpolatePoints - Interpolates multiple points along line
- ST_LineLocatePoint - Locates point along line as fraction
- ST_LineSubstring - Returns substring of line between fractions
- ST_LocateAlong - Returns points at given measure
- ST_LocateBetween - Returns segments between measures
- ST_AddMeasure - Adds measure values to line

## 8. Clustering Functions

### Clustering Algorithms
- ST_ClusterDBSCAN - DBSCAN clustering of geometries
- ST_ClusterKMeans - K-means clustering of geometries
- ST_ClusterIntersecting - Clusters intersecting geometries
- ST_ClusterWithin - Clusters geometries within distance

## 9. Bounding Box Functions

### Box Constructors & Operators
- ST_Envelope - Returns bounding box as geometry
- ST_Extent - Aggregate function returning bounding box
- ST_3DExtent - Returns 3D bounding box
- ST_MakeBox2D - Creates 2D box from two points
- ST_EstimatedExtent - Returns estimated extent from statistics
- ST_Expand - Expands bounding box

### Box Relationships
- && - Bounding box overlaps operator
- &< - Bounding box left operator
- &> - Bounding box right operator
- &<| - Bounding box below operator
- |&> - Bounding box above operator
- << - Strictly left of operator
- >> - Strictly right of operator
- <<| - Strictly below operator
- |>> - Strictly above operator
- ~= - Same bounding box operator
- @ - Contained in bounding box operator
- ~ - Contains bounding box operator

## 10. Input/Output Functions

### Text Formats
- ST_AsText - Returns WKT (Well-Known Text) representation
- ST_AsEWKT - Returns EWKT (Extended WKT) representation
- ST_GeomFromText - Creates geometry from WKT
- ST_GeomFromEWKT - Creates geometry from EWKT
- ST_PointFromText - Creates Point from WKT
- ST_LineFromText - Creates LineString from WKT
- ST_PolyFromText - Creates Polygon from WKT
- ST_MPointFromText - Creates MultiPoint from WKT
- ST_MLineFromText - Creates MultiLineString from WKT
- ST_MPolyFromText - Creates MultiPolygon from WKT

### Binary Formats
- ST_AsBinary - Returns WKB (Well-Known Binary) representation
- ST_AsEWKB - Returns EWKB (Extended WKB) representation
- ST_GeomFromWKB - Creates geometry from WKB
- ST_GeomFromEWKB - Creates geometry from EWKB
- ST_PointFromWKB - Creates Point from WKB
- ST_LineFromWKB - Creates LineString from WKB
- ST_PolyFromWKB - Creates Polygon from WKB
- ST_MPointFromWKB - Creates MultiPoint from WKB
- ST_MLineFromWKB - Creates MultiLineString from WKB
- ST_MPolyFromWKB - Creates MultiPolygon from WKB

### Other Formats
- ST_AsGML - Returns GML (Geography Markup Language) representation
- ST_AsKML - Returns KML representation
- ST_AsGeoJSON - Returns GeoJSON representation
- ST_AsSVG - Returns SVG path data
- ST_AsX3D - Returns X3D representation
- ST_AsMVTGeom - Returns geometry in Mapbox Vector Tile format
- ST_AsMVT - Returns MVT representation
- ST_AsTWKB - Returns TWKB (Tiny WKB) representation
- ST_AsEncodedPolyline - Returns encoded polyline
- ST_AsHEXEWKB - Returns hex-encoded EWKB
- ST_GeomFromGML - Creates geometry from GML
- ST_GeomFromKML - Creates geometry from KML
- ST_GeomFromGeoJSON - Creates geometry from GeoJSON
- ST_GeomFromEncodedPolyline - Creates geometry from encoded polyline
- ST_GeomFromTWKB - Creates geometry from TWKB
- ST_LineFromEncodedPolyline - Creates LineString from encoded polyline

## 11. Spatial Reference System Functions

### SRID Management
- ST_SRID - Gets SRID of geometry
- ST_SetSRID - Sets SRID (without transformation)
- ST_Transform - Transforms to different SRID
- ST_TransformPipeline - Transforms using coordinate operation pipeline
- UpdateGeometrySRID - Updates SRID in geometry_columns

### Coordinate System Info
- spatial_ref_sys - Table containing spatial reference system definitions
- ST_SpatialReferenceSystem - Returns SRS information

## 12. Geometry Validation & Repair

### Validation
- ST_IsValid - Tests if geometry is valid
- ST_IsValidReason - Returns text reason for invalidity
- ST_IsValidDetail - Returns detailed invalidity information
- ST_IsValidTrajectory - Tests if geometry is a valid trajectory

### Repair
- ST_MakeValid - Attempts to make invalid geometry valid
- ST_RemoveRepeatedPoints - Removes consecutive repeated points
- ST_RemoveIrrelevantPointsForView - Removes points not visible at given scale

## 13. Trajectory Functions

### Trajectory Analysis
- ST_IsValidTrajectory - Tests if geometry is valid trajectory
- ST_ClosestPointOfApproach - Returns time of closest point of approach
- ST_DistanceCPA - Returns distance at closest point of approach
- ST_CPAWithin - Tests if trajectories come within distance

## 14. Geography Functions

### Geography Measurements
- ST_Area - Calculates area on spheroid (geography)
- ST_Length - Calculates length on spheroid (geography)
- ST_Perimeter - Calculates perimeter on spheroid (geography)
- ST_Distance - Calculates distance on spheroid (geography)
- ST_Azimuth - Calculates azimuth between points
- ST_Project - Projects point along geodesic
- ST_Segmentize - Adds points along great circle arcs

### Geography Operations
- ST_Buffer - Creates buffer on spheroid
- ST_Intersection - Computes intersection on spheroid
- ST_Covers - Tests coverage on spheroid
- ST_CoveredBy - Tests covered by on spheroid
- ST_DWithin - Tests distance within on spheroid
- ST_Intersects - Tests intersection on spheroid

## 15. Raster Functions

### Raster Constructors
- ST_MakeEmptyRaster - Creates empty raster
- ST_AddBand - Adds band to raster
- ST_AsRaster - Converts geometry to raster
- ST_Tile - Tiles a raster
- ST_FromGDALRaster - Creates raster from GDAL raster

### Raster Accessors
- ST_Value - Gets pixel value at point
- ST_NearestValue - Gets nearest pixel value
- ST_Neighborhood - Gets pixel neighborhood
- ST_BandMetaData - Returns band metadata
- ST_BandNoDataValue - Returns NoData value
- ST_BandPixelType - Returns pixel type

### Raster Processing
- ST_MapAlgebra - Applies map algebra expression
- ST_Reclass - Reclassifies raster values
- ST_Clip - Clips raster by geometry
- ST_Union - Unions rasters
- ST_Resample - Resamples raster
- ST_Rescale - Rescales raster
- ST_Transform - Transforms raster to different SRID
- ST_Slope - Calculates slope from DEM
- ST_Aspect - Calculates aspect from DEM
- ST_HillShade - Calculates hillshade from DEM
- ST_TPI - Calculates Topographic Position Index
- ST_TRI - Calculates Terrain Ruggedness Index
- ST_Roughness - Calculates roughness

### Raster Analysis
- ST_SummaryStats - Computes summary statistics
- ST_Count - Counts pixels
- ST_Histogram - Computes histogram
- ST_Quantile - Computes quantiles
- ST_ValueCount - Counts distinct pixel values

### Raster-Geometry Conversion
- ST_AsPolygon - Converts raster to polygon
- ST_DumpAsPolygons - Dumps raster as polygons
- ST_PixelAsPolygons - Returns pixels as polygons
- ST_PixelAsPoints - Returns pixels as points
- ST_PixelAsCentroids - Returns pixel centroids

## 16. Topology Functions

### Topology Management
- CreateTopology - Creates new topology schema
- DropTopology - Drops topology schema
- TopologySummary - Returns topology summary
- ValidateTopology - Validates topology structure

### Topology Editing
- AddTopoGeometryColumn - Adds TopoGeometry column
- TopoGeo_AddPoint - Adds isolated node
- TopoGeo_AddLineString - Adds linestring to topology
- TopoGeo_AddPolygon - Adds polygon to topology
- TopoElementArray_Agg - Aggregates topology elements

### Topology Analysis
- GetTopologyID - Gets topology ID
- GetTopologySRID - Gets topology SRID
- GetTopoGeomElements - Gets TopoGeometry elements
- GetRingEdges - Gets edges forming ring

## 17. 3D Functions

### 3D Constructors
- ST_MakePoint - Creates 3D point
- ST_3DMakeBox - Creates 3D box
- ST_Extrude - Extrudes 2D geometry to 3D
- ST_Tesselate - Tesselates surface

### 3D Measurements
- ST_3DDistance - Calculates 3D distance
- ST_3DLength - Calculates 3D length
- ST_3DPerimeter - Calculates 3D perimeter
- ST_3DArea - Calculates 3D area

### 3D Operations
- ST_3DIntersects - Tests 3D intersection
- ST_3DClosestPoint - Returns closest 3D point
- ST_3DShortestLine - Returns shortest 3D line
- ST_3DLongestLine - Returns longest 3D line
- ST_3DMaxDistance - Returns maximum 3D distance

## 18. Affinity & Transformation

### Affine Transformations
- ST_Affine - Applies 3D affine transformation
- ST_Rotate - Rotates geometry around origin
- ST_RotateX - Rotates around X axis
- ST_RotateY - Rotates around Y axis
- ST_RotateZ - Rotates around Z axis
- ST_Scale - Scales geometry
- ST_Translate - Translates geometry
- ST_TransScale - Translates and scales geometry

## 19. Utility Functions

### Version & Configuration
- PostGIS_Version - Returns PostGIS version
- PostGIS_Full_Version - Returns full version information
- PostGIS_GEOS_Version - Returns GEOS version
- PostGIS_LibXML_Version - Returns LibXML version
- PostGIS_Lib_Version - Returns library version
- PostGIS_PROJ_Version - Returns PROJ version
- PostGIS_Scripts_Installed - Returns installed scripts version
- PostGIS_Scripts_Released - Returns released scripts version

### Database Management
- PostGIS_Extensions_Upgrade - Upgrades PostGIS extensions
- UpdateGeometrySRID - Updates geometry SRID in metadata
- Populate_Geometry_Columns - Populates geometry_columns table
- AddGeometryColumn - Adds geometry column to table
- DropGeometryColumn - Drops geometry column
- DropGeometryTable - Drops table with geometry

### Miscellaneous
- ST_MemSize - Returns memory size of geometry
- ST_Summary - Returns text summary of geometry
- ST_NPoints - Returns number of points
- ST_NumPatches - Returns number of patches in PolyhedralSurface
- ST_NumInteriorRings - Returns number of interior rings

## 20. Aggregates

### Spatial Aggregates
- ST_Collect - Collects geometries into collection
- ST_Union - Unions geometries
- ST_MemUnion - Memory-efficient union (deprecated)
- ST_Extent - Returns bounding box of geometries
- ST_3DExtent - Returns 3D bounding box
- ST_MakeLine - Creates line from points
- ST_Polygonize - Creates polygons from lines
- ST_ClusterIntersecting - Clusters intersecting geometries
- ST_ClusterWithin - Clusters geometries within distance

## 21. Window Functions

### Spatial Window Functions
- ST_ClusterDBSCAN - DBSCAN clustering over window
- ST_ClusterKMeans - K-means clustering over window

## Notes

- **ST_** prefix stands for "Spatial Type"
- Functions marked with **(geography)** work on the geography type for accurate geodetic calculations
- Many functions have both geometry and geography versions
- SRID (Spatial Reference System Identifier) defines the coordinate system
- WKT/WKB are standard OGC formats for geometry representation
- PostGIS follows OGC (Open Geospatial Consortium) standards

## Resources

- Official PostGIS Documentation: https://postgis.net/documentation/
- PostGIS Function Reference: https://postgis.net/docs/reference.html
- OGC Simple Features Specification: https://www.ogc.org/standards/sfa

---

*This list covers PostGIS version 3.x functionalities. Some functions may vary by version.*
