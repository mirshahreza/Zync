-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get time zone for Iranian coordinates (Iran Standard Time)
-- Sample:		SELECT dbo.ZzGetTimeZone(35.6892, 51.3890)
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetTimeZone(
    @Latitude FLOAT,
    @Longitude FLOAT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Result NVARCHAR(100);
    
    -- Validate coordinates for Iran
    IF @Latitude < 25.0 OR @Latitude > 40.0 OR @Longitude < 44.0 OR @Longitude > 64.0
    BEGIN
        -- Try to determine neighboring countries' time zones
        IF @Longitude < 44.0 -- West of Iran (Iraq, Turkey)
            SET @Result = N'UTC+3 (عراق/ترکیه)';
        ELSE IF @Longitude > 64.0 -- East of Iran (Afghanistan, Pakistan)
        BEGIN
            IF @Longitude < 68.0
                SET @Result = N'UTC+4:30 (افغانستان)';
            ELSE
                SET @Result = N'UTC+5 (پاکستان)';
        END
        ELSE IF @Latitude > 40.0 -- North of Iran (Turkmenistan, Azerbaijan)
        BEGIN
            IF @Longitude < 54.0
                SET @Result = N'UTC+4 (آذربایجان)';
            ELSE
                SET @Result = N'UTC+5 (ترکمنستان)';
        END
        ELSE IF @Latitude < 25.0 -- South of Iran (Persian Gulf waters)
            SET @Result = N'UTC+3:30 (آبهای خلیج فارس)';
        ELSE
            SET @Result = N'منطقه زمانی نامشخص';
        
        RETURN @Result;
    END
    
    -- All of Iran uses Iran Standard Time (IRST)
    -- UTC+3:30 (UTC+4:30 during daylight saving time)
    SET @Result = N'UTC+3:30 (وقت رسمی ایران)';
    
    -- Add city/region information for context
    -- Tehran and surrounding areas
    IF @Latitude BETWEEN 35.55 AND 35.85 AND @Longitude BETWEEN 51.2 AND 51.6
        SET @Result = @Result + N' - تهران';
    -- Isfahan
    ELSE IF @Latitude BETWEEN 32.55 AND 32.75 AND @Longitude BETWEEN 51.60 AND 51.75
        SET @Result = @Result + N' - اصفهان';
    -- Mashhad
    ELSE IF @Latitude BETWEEN 36.20 AND 36.40 AND @Longitude BETWEEN 59.50 AND 59.70
        SET @Result = @Result + N' - مشهد';
    -- Shiraz
    ELSE IF @Latitude BETWEEN 29.50 AND 29.70 AND @Longitude BETWEEN 52.45 AND 52.65
        SET @Result = @Result + N' - شیراز';
    -- Tabriz
    ELSE IF @Latitude BETWEEN 38.00 AND 38.15 AND @Longitude BETWEEN 46.25 AND 46.35
        SET @Result = @Result + N' - تبریز';
    -- Ahvaz
    ELSE IF @Latitude BETWEEN 31.25 AND 31.40 AND @Longitude BETWEEN 48.60 AND 48.75
        SET @Result = @Result + N' - اهواز';
    -- Kerman
    ELSE IF @Latitude BETWEEN 30.25 AND 30.35 AND @Longitude BETWEEN 57.05 AND 57.15
        SET @Result = @Result + N' - کرمان';
    -- Kermanshah
    ELSE IF @Latitude BETWEEN 34.30 AND 34.40 AND @Longitude BETWEEN 47.00 AND 47.10
        SET @Result = @Result + N' - کرمانشاه';
    -- Rasht
    ELSE IF @Latitude BETWEEN 37.25 AND 37.35 AND @Longitude BETWEEN 49.55 AND 49.65
        SET @Result = @Result + N' - رشت';
    -- Zahedan
    ELSE IF @Latitude BETWEEN 29.45 AND 29.55 AND @Longitude BETWEEN 60.85 AND 60.95
        SET @Result = @Result + N' - زاهدان';
    -- Bandar Abbas
    ELSE IF @Latitude BETWEEN 27.15 AND 27.25 AND @Longitude BETWEEN 56.25 AND 56.35
        SET @Result = @Result + N' - بندرعباس';
    -- Urmia
    ELSE IF @Latitude BETWEEN 37.50 AND 37.60 AND @Longitude BETWEEN 45.05 AND 45.15
        SET @Result = @Result + N' - ارومیه';
    -- Qom
    ELSE IF @Latitude BETWEEN 34.60 AND 34.70 AND @Longitude BETWEEN 50.85 AND 50.95
        SET @Result = @Result + N' - قم';
    -- Hamadan
    ELSE IF @Latitude BETWEEN 34.75 AND 34.85 AND @Longitude BETWEEN 48.50 AND 48.60
        SET @Result = @Result + N' - همدان';
    -- Yazd
    ELSE IF @Latitude BETWEEN 31.85 AND 31.95 AND @Longitude BETWEEN 54.35 AND 54.45
        SET @Result = @Result + N' - یزد';
    -- Arak
    ELSE IF @Latitude BETWEEN 34.05 AND 34.15 AND @Longitude BETWEEN 49.65 AND 49.75
        SET @Result = @Result + N' - اراک';
    -- Ardabil
    ELSE IF @Latitude BETWEEN 38.20 AND 38.30 AND @Longitude BETWEEN 48.25 AND 48.35
        SET @Result = @Result + N' - اردبیل';
    -- Zanjan
    ELSE IF @Latitude BETWEEN 36.65 AND 36.75 AND @Longitude BETWEEN 48.45 AND 48.55
        SET @Result = @Result + N' - زنجان';
    -- Sanandaj
    ELSE IF @Latitude BETWEEN 35.30 AND 35.40 AND @Longitude BETWEEN 46.95 AND 47.05
        SET @Result = @Result + N' - سنندج';
    -- Kish Island
    ELSE IF @Latitude BETWEEN 26.50 AND 26.60 AND @Longitude BETWEEN 53.95 AND 54.05
        SET @Result = @Result + N' - کیش';
    -- Qeshm Island
    ELSE IF @Latitude BETWEEN 26.90 AND 27.00 AND @Longitude BETWEEN 55.90 AND 56.00
        SET @Result = @Result + N' - قشم';
    
    RETURN @Result;
END
GO