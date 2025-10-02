-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Convert between different speed units (m/s, km/h, mph, knots, etc.)
-- Sample:		SELECT dbo.ZzConvertSpeed(100, 'km/h', 'm/s')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzConvertSpeed(
    @Value FLOAT,
    @FromUnit NVARCHAR(20),
    @ToUnit NVARCHAR(20)
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Result FLOAT;
    DECLARE @ValueInMeterPerSecond FLOAT;
    
    -- Convert input to meters per second first
    IF @FromUnit = 'm/s' OR @FromUnit = 'mps'
        SET @ValueInMeterPerSecond = @Value;
    ELSE IF @FromUnit = 'km/h' OR @FromUnit = 'kph' OR @FromUnit = 'kmh'
        SET @ValueInMeterPerSecond = @Value / 3.6;
    ELSE IF @FromUnit = 'mph' OR @FromUnit = 'mi/h'
        SET @ValueInMeterPerSecond = @Value * 0.44704;
    ELSE IF @FromUnit = 'knots' OR @FromUnit = 'kn'
        SET @ValueInMeterPerSecond = @Value * 0.514444;
    ELSE IF @FromUnit = 'ft/s' OR @FromUnit = 'fps'
        SET @ValueInMeterPerSecond = @Value * 0.3048;
    ELSE IF @FromUnit = 'cm/s' OR @FromUnit = 'cps'
        SET @ValueInMeterPerSecond = @Value * 0.01;
    ELSE IF @FromUnit = 'mm/s' OR @FromUnit = 'mmps'
        SET @ValueInMeterPerSecond = @Value * 0.001;
    ELSE IF @FromUnit = 'mach'
        SET @ValueInMeterPerSecond = @Value * 343.0; -- Speed of sound at sea level
    -- Persian traditional units
    ELSE IF @FromUnit = 'farsakh/h' OR @FromUnit = 'فرسخ/ساعت'
        SET @ValueInMeterPerSecond = @Value * 1.667; -- 6km/h in m/s
    ELSE
        RETURN NULL; -- Unknown unit
    
    -- Convert from meters per second to target unit
    IF @ToUnit = 'm/s' OR @ToUnit = 'mps'
        SET @Result = @ValueInMeterPerSecond;
    ELSE IF @ToUnit = 'km/h' OR @ToUnit = 'kph' OR @ToUnit = 'kmh'
        SET @Result = @ValueInMeterPerSecond * 3.6;
    ELSE IF @ToUnit = 'mph' OR @ToUnit = 'mi/h'
        SET @Result = @ValueInMeterPerSecond / 0.44704;
    ELSE IF @ToUnit = 'knots' OR @ToUnit = 'kn'
        SET @Result = @ValueInMeterPerSecond / 0.514444;
    ELSE IF @ToUnit = 'ft/s' OR @ToUnit = 'fps'
        SET @Result = @ValueInMeterPerSecond / 0.3048;
    ELSE IF @ToUnit = 'cm/s' OR @ToUnit = 'cps'
        SET @Result = @ValueInMeterPerSecond / 0.01;
    ELSE IF @ToUnit = 'mm/s' OR @ToUnit = 'mmps'
        SET @Result = @ValueInMeterPerSecond / 0.001;
    ELSE IF @ToUnit = 'mach'
        SET @Result = @ValueInMeterPerSecond / 343.0;
    -- Persian traditional units
    ELSE IF @ToUnit = 'farsakh/h' OR @ToUnit = 'فرسخ/ساعت'
        SET @Result = @ValueInMeterPerSecond / 1.667;
    ELSE
        RETURN NULL; -- Unknown unit
    
    RETURN @Result;
END
GO