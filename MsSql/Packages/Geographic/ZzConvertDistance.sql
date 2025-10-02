-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Convert distance between different units (KM, MILE, METER, FEET, NAUTICAL_MILE)
-- Sample:		SELECT [dbo].[ZzConvertDistance](100, 'KM', 'MILE');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzConvertDistance(
    @distance DECIMAL(15,5),
    @from_unit NVARCHAR(20),
    @to_unit NVARCHAR(20)
)
RETURNS DECIMAL(15,5)
AS
BEGIN
    DECLARE @result DECIMAL(15,5);
    DECLARE @meters DECIMAL(15,5);
    
    -- Validate inputs
    IF @distance IS NULL OR @distance < 0 OR @from_unit IS NULL OR @to_unit IS NULL
        RETURN NULL;
    
    SET @from_unit = UPPER(RTRIM(LTRIM(@from_unit)));
    SET @to_unit = UPPER(RTRIM(LTRIM(@to_unit)));
    
    -- If same unit, return original distance
    IF @from_unit = @to_unit
        RETURN @distance;
    
    -- First convert to meters as base unit
    IF @from_unit = 'KM' OR @from_unit = 'KILOMETER'
        SET @meters = @distance * 1000;
    ELSE IF @from_unit = 'MILE' OR @from_unit = 'MI'
        SET @meters = @distance * 1609.344;
    ELSE IF @from_unit = 'METER' OR @from_unit = 'M'
        SET @meters = @distance;
    ELSE IF @from_unit = 'FEET' OR @from_unit = 'FT'
        SET @meters = @distance * 0.3048;
    ELSE IF @from_unit = 'NAUTICAL_MILE' OR @from_unit = 'NM'
        SET @meters = @distance * 1852;
    ELSE IF @from_unit = 'YARD' OR @from_unit = 'YD'
        SET @meters = @distance * 0.9144;
    ELSE
        RETURN NULL; -- Unknown unit
    
    -- Convert from meters to target unit
    IF @to_unit = 'KM' OR @to_unit = 'KILOMETER'
        SET @result = @meters / 1000;
    ELSE IF @to_unit = 'MILE' OR @to_unit = 'MI'
        SET @result = @meters / 1609.344;
    ELSE IF @to_unit = 'METER' OR @to_unit = 'M'
        SET @result = @meters;
    ELSE IF @to_unit = 'FEET' OR @to_unit = 'FT'
        SET @result = @meters / 0.3048;
    ELSE IF @to_unit = 'NAUTICAL_MILE' OR @to_unit = 'NM'
        SET @result = @meters / 1852;
    ELSE IF @to_unit = 'YARD' OR @to_unit = 'YD'
        SET @result = @meters / 0.9144;
    ELSE
        RETURN NULL; -- Unknown unit
    
    RETURN @result;
END
GO