-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get UTM zone number from latitude and longitude coordinates
-- Sample:		SELECT [dbo].[ZzGetUTMZone](35.6892, 51.3890);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetUTMZone(
    @latitude DECIMAL(10,7),
    @longitude DECIMAL(10,7)
)
RETURNS NVARCHAR(10)
AS
BEGIN
    DECLARE @result NVARCHAR(10);
    DECLARE @zone_number INT;
    DECLARE @zone_letter NVARCHAR(1);
    
    -- Validate coordinates
    IF dbo.ZzValidateCoordinates(@latitude, @longitude) = 0
        RETURN NULL;
    
    -- Calculate UTM zone number (1-60)
    SET @zone_number = FLOOR((@longitude + 180) / 6) + 1;
    
    -- Handle special cases
    -- Norway
    IF @latitude >= 56.0 AND @latitude < 64.0 AND @longitude >= 3.0 AND @longitude < 12.0
        SET @zone_number = 32;
    
    -- Svalbard
    IF @latitude >= 72.0 AND @latitude < 84.0
    BEGIN
        IF @longitude >= 0.0 AND @longitude < 9.0
            SET @zone_number = 31;
        ELSE IF @longitude >= 9.0 AND @longitude < 21.0
            SET @zone_number = 33;
        ELSE IF @longitude >= 21.0 AND @longitude < 33.0
            SET @zone_number = 35;
        ELSE IF @longitude >= 33.0 AND @longitude < 42.0
            SET @zone_number = 37;
    END
    
    -- Calculate UTM zone letter (C-X, excluding I and O)
    DECLARE @lat_band INT = FLOOR((@latitude + 80) / 8);
    DECLARE @letters NVARCHAR(24) = 'CDEFGHJKLMNPQRSTUVWX';
    
    IF @lat_band >= 0 AND @lat_band < 20
        SET @zone_letter = SUBSTRING(@letters, @lat_band + 1, 1);
    ELSE
        SET @zone_letter = 'Z'; -- Invalid
    
    -- Special case for X band
    IF @latitude >= 72.0 AND @latitude < 84.0
        SET @zone_letter = 'X';
    
    SET @result = CAST(@zone_number AS NVARCHAR(2)) + @zone_letter;
    
    RETURN @result;
END
GO