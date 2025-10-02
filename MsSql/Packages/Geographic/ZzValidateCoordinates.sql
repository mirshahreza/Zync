-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate latitude and longitude coordinates
-- Sample:		SELECT [dbo].[ZzValidateCoordinates](35.6892, 51.3890);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidateCoordinates(
    @latitude DECIMAL(10,7),
    @longitude DECIMAL(10,7)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    
    -- Check for null values
    IF @latitude IS NULL OR @longitude IS NULL
        RETURN 0;
    
    -- Validate latitude range (-90 to 90)
    IF @latitude < -90.0 OR @latitude > 90.0
        RETURN 0;
    
    -- Validate longitude range (-180 to 180)
    IF @longitude < -180.0 OR @longitude > 180.0
        RETURN 0;
    
    -- All validations passed
    SET @result = 1;
    
    RETURN @result;
END
GO