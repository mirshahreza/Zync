-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Convert between different area units (sq_meter, sq_km, hectare, acre, etc.)
-- Sample:		SELECT dbo.ZzConvertArea(1000000, 'sq_meter', 'sq_km')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzConvertArea(
    @Value FLOAT,
    @FromUnit NVARCHAR(20),
    @ToUnit NVARCHAR(20)
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Result FLOAT;
    DECLARE @ValueInSqMeters FLOAT;
    
    -- Convert input to square meters first
    IF @FromUnit = 'sq_meter' OR @FromUnit = 'm2'
        SET @ValueInSqMeters = @Value;
    ELSE IF @FromUnit = 'sq_km' OR @FromUnit = 'km2'
        SET @ValueInSqMeters = @Value * 1000000.0;
    ELSE IF @FromUnit = 'hectare' OR @FromUnit = 'ha'
        SET @ValueInSqMeters = @Value * 10000.0;
    ELSE IF @FromUnit = 'acre'
        SET @ValueInSqMeters = @Value * 4046.86;
    ELSE IF @FromUnit = 'sq_foot' OR @FromUnit = 'ft2'
        SET @ValueInSqMeters = @Value * 0.092903;
    ELSE IF @FromUnit = 'sq_yard' OR @FromUnit = 'yd2'
        SET @ValueInSqMeters = @Value * 0.836127;
    ELSE IF @FromUnit = 'sq_mile' OR @FromUnit = 'mi2'
        SET @ValueInSqMeters = @Value * 2589988.11;
    ELSE IF @FromUnit = 'sq_inch' OR @FromUnit = 'in2'
        SET @ValueInSqMeters = @Value * 0.00064516;
    ELSE IF @FromUnit = 'sq_cm' OR @FromUnit = 'cm2'
        SET @ValueInSqMeters = @Value * 0.0001;
    ELSE IF @FromUnit = 'sq_mm' OR @FromUnit = 'mm2'
        SET @ValueInSqMeters = @Value * 0.000001;
    -- Persian units
    ELSE IF @FromUnit = 'jerib' OR @FromUnit = 'جریب'
        SET @ValueInSqMeters = @Value * 1000.0; -- Approximate
    ELSE IF @FromUnit = 'farsakh' OR @FromUnit = 'فرسخ'
        SET @ValueInSqMeters = @Value * 36000000.0; -- 6km x 6km
    ELSE
        RETURN NULL; -- Unknown unit
    
    -- Convert from square meters to target unit
    IF @ToUnit = 'sq_meter' OR @ToUnit = 'm2'
        SET @Result = @ValueInSqMeters;
    ELSE IF @ToUnit = 'sq_km' OR @ToUnit = 'km2'
        SET @Result = @ValueInSqMeters / 1000000.0;
    ELSE IF @ToUnit = 'hectare' OR @ToUnit = 'ha'
        SET @Result = @ValueInSqMeters / 10000.0;
    ELSE IF @ToUnit = 'acre'
        SET @Result = @ValueInSqMeters / 4046.86;
    ELSE IF @ToUnit = 'sq_foot' OR @ToUnit = 'ft2'
        SET @Result = @ValueInSqMeters / 0.092903;
    ELSE IF @ToUnit = 'sq_yard' OR @ToUnit = 'yd2'
        SET @Result = @ValueInSqMeters / 0.836127;
    ELSE IF @ToUnit = 'sq_mile' OR @ToUnit = 'mi2'
        SET @Result = @ValueInSqMeters / 2589988.11;
    ELSE IF @ToUnit = 'sq_inch' OR @ToUnit = 'in2'
        SET @Result = @ValueInSqMeters / 0.00064516;
    ELSE IF @ToUnit = 'sq_cm' OR @ToUnit = 'cm2'
        SET @Result = @ValueInSqMeters / 0.0001;
    ELSE IF @ToUnit = 'sq_mm' OR @ToUnit = 'mm2'
        SET @Result = @ValueInSqMeters / 0.000001;
    -- Persian units
    ELSE IF @ToUnit = 'jerib' OR @ToUnit = 'جریب'
        SET @Result = @ValueInSqMeters / 1000.0;
    ELSE IF @ToUnit = 'farsakh' OR @ToUnit = 'فرسخ'
        SET @Result = @ValueInSqMeters / 36000000.0;
    ELSE
        RETURN NULL; -- Unknown unit
    
    RETURN @Result;
END
GO