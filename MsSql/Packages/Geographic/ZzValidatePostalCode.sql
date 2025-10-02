-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate Iranian postal code format (10 digits)
-- Sample:		SELECT [dbo].[ZzValidatePostalCode]('1234567890');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidatePostalCode(
    @postal_code NVARCHAR(20)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    DECLARE @clean_code NVARCHAR(10);
    DECLARE @i INT = 1;
    
    -- Remove any non-digit characters
    SET @clean_code = '';
    WHILE @i <= LEN(@postal_code)
    BEGIN
        IF SUBSTRING(@postal_code, @i, 1) LIKE '[0-9]'
            SET @clean_code = @clean_code + SUBSTRING(@postal_code, @i, 1);
        SET @i = @i + 1;
    END
    
    -- Must be exactly 10 digits for Iranian postal code
    IF LEN(@clean_code) != 10
        RETURN 0;
    
    -- Cannot be all same digits
    IF @clean_code IN ('0000000000', '1111111111', '2222222222', '3333333333', '4444444444',
                       '5555555555', '6666666666', '7777777777', '8888888888', '9999999999')
        RETURN 0;
    
    -- Basic validation passed
    SET @result = 1;
    
    RETURN @result;
END
GO