-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get elevation zone based on coordinates (Iranian geography)
-- Sample:		SELECT dbo.ZzGetElevationZone(35.6892, 51.3890)
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetElevationZone(
    @Latitude FLOAT,
    @Longitude FLOAT
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Result NVARCHAR(50) = N'نامشخص';
    
    -- Validate coordinates for Iran
    IF @Latitude < 25.0 OR @Latitude > 40.0 OR @Longitude < 44.0 OR @Longitude > 64.0
        RETURN N'خارج از محدوده ایران';
    
    -- Alborz Mountains (High elevation - above 1500m)
    IF (@Latitude BETWEEN 35.7 AND 37.0 AND @Longitude BETWEEN 50.0 AND 56.0) OR
       (@Latitude BETWEEN 36.5 AND 38.5 AND @Longitude BETWEEN 47.0 AND 52.0)
    BEGIN
        SET @Result = N'کوهستانی بلند - البرز';
    END
    -- Zagros Mountains (Medium to High elevation - 800-3000m)
    ELSE IF (@Latitude BETWEEN 27.0 AND 37.0 AND @Longitude BETWEEN 45.0 AND 55.0) AND
            NOT (@Latitude BETWEEN 30.0 AND 32.5 AND @Longitude BETWEEN 48.0 AND 53.0) -- Exclude Khuzestan plain
    BEGIN
        SET @Result = N'کوهستانی متوسط - زاگرس';
    END
    -- Kopet Dag Mountains (Northeast)
    ELSE IF @Latitude BETWEEN 36.0 AND 38.0 AND @Longitude BETWEEN 57.0 AND 61.0
    BEGIN
        SET @Result = N'کوهستانی - کپه‌داغ';
    END
    -- Central Iranian Plateau (Medium elevation - 1000-1500m)
    ELSE IF (@Latitude BETWEEN 32.0 AND 36.0 AND @Longitude BETWEEN 51.0 AND 59.0) OR
            (@Latitude BETWEEN 33.0 AND 35.0 AND @Longitude BETWEEN 55.0 AND 61.0)
    BEGIN
        SET @Result = N'فلات مرکزی';
    END
    -- Khuzestan Plain (Low elevation - below 200m)
    ELSE IF @Latitude BETWEEN 30.0 AND 32.5 AND @Longitude BETWEEN 48.0 AND 53.0
    BEGIN
        SET @Result = N'جلگه‌ای - خوزستان';
    END
    -- Caspian Sea coastal plain (Below sea level to 200m)
    ELSE IF @Latitude BETWEEN 36.5 AND 38.5 AND @Longitude BETWEEN 48.5 AND 54.5
    BEGIN
        SET @Result = N'جلگه ساحلی - خزر';
    END
    -- Persian Gulf coastal plain (Sea level to 100m)
    ELSE IF @Latitude BETWEEN 25.0 AND 30.5 AND @Longitude BETWEEN 48.0 AND 63.0
    BEGIN
        SET @Result = N'جلگه ساحلی - خلیج فارس';
    END
    -- Eastern deserts (Low to medium elevation - 200-1000m)
    ELSE IF (@Latitude BETWEEN 28.0 AND 35.0 AND @Longitude BETWEEN 55.0 AND 61.0) OR
            (@Latitude BETWEEN 30.0 AND 33.0 AND @Longitude BETWEEN 57.0 AND 63.0)
    BEGIN
        SET @Result = N'کویری - شرق ایران';
    END
    -- Central deserts (Dasht-e Kavir, Dasht-e Lut)
    ELSE IF (@Latitude BETWEEN 32.0 AND 36.0 AND @Longitude BETWEEN 53.0 AND 59.0) OR
            (@Latitude BETWEEN 28.0 AND 32.0 AND @Longitude BETWEEN 56.0 AND 61.0)
    BEGIN
        SET @Result = N'کویری - مرکز ایران';
    END
    -- Northwestern highlands
    ELSE IF @Latitude BETWEEN 37.0 AND 39.5 AND @Longitude BETWEEN 44.0 AND 48.0
    BEGIN
        SET @Result = N'مرتفعات شمال‌غرب';
    END
    -- Southeastern highlands (Baluchestan mountains)
    ELSE IF @Latitude BETWEEN 25.0 AND 29.0 AND @Longitude BETWEEN 58.0 AND 63.0
    BEGIN
        SET @Result = N'مرتفعات جنوب‌شرق';
    END
    -- Default based on general elevation patterns
    ELSE
    BEGIN
        -- Higher latitudes tend to be more mountainous
        IF @Latitude > 35.0
            SET @Result = N'کوهستانی';
        ELSE IF @Latitude < 30.0
            SET @Result = N'جلگه‌ای';
        ELSE
            SET @Result = N'فلات';
    END
    
    RETURN @Result;
END
GO