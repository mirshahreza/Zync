-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Check if coordinates are within Iran's borders (approximate)
-- Sample:		SELECT [dbo].[ZzValidateIranianCoordinates](35.6892, 51.3890);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidateIranianCoordinates(
    @latitude DECIMAL(10,7),
    @longitude DECIMAL(10,7)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    
    -- Validate basic coordinate format first
    IF dbo.ZzValidateCoordinates(@latitude, @longitude) = 0
        RETURN 0;
    
    -- Iran's approximate bounding box coordinates
    -- Northernmost: ~39.8° N (near Aras River)
    -- Southernmost: ~25.0° N (Persian Gulf)
    -- Westernmost: ~44.0° E (border with Iraq/Turkey)  
    -- Easternmost: ~63.3° E (border with Afghanistan/Pakistan)
    
    IF @latitude >= 25.0 AND @latitude <= 39.8 AND 
       @longitude >= 44.0 AND @longitude <= 63.3
    BEGIN
        SET @result = 1;
    END
    
    RETURN @result;
END
GO