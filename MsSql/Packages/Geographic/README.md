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
	- Example: `SELECT [dbo].[ZzGetProvinceFromCity](N'تهران');`

Notes:
- `ls Geographic` shows each item with its short description taken from a `-- Description:` line at the top of the script.
- Distance calculations use the Haversine formula for accuracy
- Coordinates are expected in decimal degrees format
- Supports Iranian geographic data and postal codes