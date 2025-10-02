-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get district/region from coordinates (Tehran districts as example)
-- Sample:		SELECT dbo.ZzGetDistrictFromCoords(35.6892, 51.3890)
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetDistrictFromCoords(
    @Latitude FLOAT,
    @Longitude FLOAT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Result NVARCHAR(100) = N'نامشخص';
    
    -- Validate coordinates for Iran
    IF @Latitude < 25.0 OR @Latitude > 40.0 OR @Longitude < 44.0 OR @Longitude > 64.0
        RETURN N'خارج از محدوده ایران';
    
    -- Tehran districts (approximate boundaries)
    IF @Latitude BETWEEN 35.55 AND 35.85 AND @Longitude BETWEEN 51.2 AND 51.6
    BEGIN
        -- District 1 (North Tehran)
        IF @Latitude > 35.75 AND @Longitude BETWEEN 51.3 AND 51.5
            SET @Result = N'منطقه 1 - شمیران';
        -- District 2 (Tajrish, Niavaran)
        ELSE IF @Latitude BETWEEN 35.72 AND 35.80 AND @Longitude BETWEEN 51.35 AND 51.48
            SET @Result = N'منطقه 2 - تجریش';
        -- District 3 (Zafaraniyeh, Jordan)
        ELSE IF @Latitude BETWEEN 35.70 AND 35.78 AND @Longitude BETWEEN 51.40 AND 51.50
            SET @Result = N'منطقه 3 - زعفرانیه';
        -- District 4 (Kehrizak area)
        ELSE IF @Latitude BETWEEN 35.55 AND 35.65 AND @Longitude BETWEEN 51.25 AND 51.35
            SET @Result = N'منطقه 4 - کهریزک';
        -- District 5 (Jannat Abad)
        ELSE IF @Latitude BETWEEN 35.70 AND 35.76 AND @Longitude BETWEEN 51.30 AND 51.38
            SET @Result = N'منطقه 5 - جنت‌آباد';
        -- District 6 (Yousef Abad, Park Way)
        ELSE IF @Latitude BETWEEN 35.68 AND 35.74 AND @Longitude BETWEEN 51.38 AND 51.45
            SET @Result = N'منطقه 6 - یوسف‌آباد';
        -- District 7 (Bazaar area)
        ELSE IF @Latitude BETWEEN 35.65 AND 35.70 AND @Longitude BETWEEN 51.40 AND 51.45
            SET @Result = N'منطقه 7 - بازار';
        -- District 8 (South Tehran)
        ELSE IF @Latitude BETWEEN 35.58 AND 35.66 AND @Longitude BETWEEN 51.36 AND 51.44
            SET @Result = N'منطقه 8 - جنوب تهران';
        -- District 9 (West Tehran)
        ELSE IF @Latitude BETWEEN 35.65 AND 35.72 AND @Longitude BETWEEN 51.25 AND 51.35
            SET @Result = N'منطقه 9 - غرب تهران';
        -- District 10 (Shahrak Gharb)
        ELSE IF @Latitude BETWEEN 35.70 AND 35.76 AND @Longitude BETWEEN 51.25 AND 51.33
            SET @Result = N'منطقه 10 - شهرک غرب';
        -- District 11 (Shahre Rey)
        ELSE IF @Latitude BETWEEN 35.58 AND 35.64 AND @Longitude BETWEEN 51.40 AND 51.48
            SET @Result = N'منطقه 11 - شهر ری';
        -- District 12 (East Tehran)
        ELSE IF @Latitude BETWEEN 35.68 AND 35.75 AND @Longitude BETWEEN 51.48 AND 51.56
            SET @Result = N'منطقه 12 - شرق تهران';
        -- District 13 (Shahre Ziba)
        ELSE IF @Latitude BETWEEN 35.58 AND 35.66 AND @Longitude BETWEEN 51.48 AND 51.56
            SET @Result = N'منطقه 13 - شهر زیبا';
        -- District 14 (Robat Karim)
        ELSE IF @Latitude BETWEEN 35.45 AND 35.58 AND @Longitude BETWEEN 51.05 AND 51.25
            SET @Result = N'منطقه 14 - رباط‌کریم';
        -- District 15 (Shahriar)
        ELSE IF @Latitude BETWEEN 35.60 AND 35.70 AND @Longitude BETWEEN 51.05 AND 51.25
            SET @Result = N'منطقه 15 - شهریار';
        -- District 16 (Pakdasht)
        ELSE IF @Latitude BETWEEN 35.45 AND 35.58 AND @Longitude BETWEEN 51.65 AND 51.85
            SET @Result = N'منطقه 16 - پاکدشت';
        -- District 17 (Varamin)
        ELSE IF @Latitude BETWEEN 35.25 AND 35.45 AND @Longitude BETWEEN 51.60 AND 51.80
            SET @Result = N'منطقه 17 - ورامین';
        -- District 18 (Malard)
        ELSE IF @Latitude BETWEEN 35.60 AND 35.75 AND @Longitude BETWEEN 50.90 AND 51.10
            SET @Result = N'منطقه 18 - ملارد';
        -- District 19 (Eslamshahr)
        ELSE IF @Latitude BETWEEN 35.50 AND 35.60 AND @Longitude BETWEEN 51.20 AND 51.35
            SET @Result = N'منطقه 19 - اسلام‌شهر';
        -- District 20 (Qods)
        ELSE IF @Latitude BETWEEN 35.68 AND 35.78 AND @Longitude BETWEEN 51.05 AND 51.20
            SET @Result = N'منطقه 20 - قدس';
        -- District 21 (Pardis)
        ELSE IF @Latitude BETWEEN 35.70 AND 35.80 AND @Longitude BETWEEN 51.70 AND 51.85
            SET @Result = N'منطقه 21 - پردیس';
        -- District 22 (Damavand)
        ELSE IF @Latitude BETWEEN 35.68 AND 35.85 AND @Longitude BETWEEN 52.00 AND 52.20
            SET @Result = N'منطقه 22 - دماوند';
        ELSE
            SET @Result = N'تهران - منطقه نامشخص';
    END
    -- Isfahan districts
    ELSE IF @Latitude BETWEEN 32.55 AND 32.75 AND @Longitude BETWEEN 51.60 AND 51.75
    BEGIN
        SET @Result = N'اصفهان';
    END
    -- Mashhad districts
    ELSE IF @Latitude BETWEEN 36.20 AND 36.40 AND @Longitude BETWEEN 59.50 AND 59.70
    BEGIN
        SET @Result = N'مشهد';
    END
    -- Shiraz districts
    ELSE IF @Latitude BETWEEN 29.50 AND 29.70 AND @Longitude BETWEEN 52.45 AND 52.65
    BEGIN
        SET @Result = N'شیراز';
    END
    -- Tabriz districts
    ELSE IF @Latitude BETWEEN 38.00 AND 38.15 AND @Longitude BETWEEN 46.25 AND 46.35
    BEGIN
        SET @Result = N'تبریز';
    END
    -- Ahvaz districts
    ELSE IF @Latitude BETWEEN 31.25 AND 31.40 AND @Longitude BETWEEN 48.60 AND 48.75
    BEGIN
        SET @Result = N'اهواز';
    END
    
    RETURN @Result;
END
GO