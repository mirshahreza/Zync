-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate Iranian national ID using checksum algorithm
-- Sample:		SELECT [dbo].[ZzValidateIranianNationalId]('1234567890');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidateIranianNationalId(
    @national_id NVARCHAR(20)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    DECLARE @clean_id NVARCHAR(10);
    DECLARE @checksum INT = 0;
    DECLARE @i INT = 1;
    
    -- Remove any non-digit characters
    SET @clean_id = '';
    WHILE @i <= LEN(@national_id)
    BEGIN
        IF SUBSTRING(@national_id, @i, 1) LIKE '[0-9]'
            SET @clean_id = @clean_id + SUBSTRING(@national_id, @i, 1);
        SET @i = @i + 1;
    END
    
    -- Must be exactly 10 digits
    IF LEN(@clean_id) != 10
        RETURN 0;
    
    -- Check for invalid patterns (all same digits)
    IF @clean_id IN ('0000000000', '1111111111', '2222222222', '3333333333', '4444444444',
                     '5555555555', '6666666666', '7777777777', '8888888888', '9999999999')
        RETURN 0;
    
    -- Calculate checksum using Iranian national ID algorithm
    SET @i = 1;
    WHILE @i <= 9
    BEGIN
        SET @checksum = @checksum + (CONVERT(INT, SUBSTRING(@clean_id, @i, 1)) * (11 - @i));
        SET @i = @i + 1;
    END
    
    DECLARE @remainder INT = @checksum % 11;
    DECLARE @check_digit INT = CONVERT(INT, SUBSTRING(@clean_id, 10, 1));
    
    -- Validate check digit
    IF @remainder < 2 AND @check_digit = @remainder
        SET @result = 1;
    ELSE IF @remainder >= 2 AND @check_digit = (11 - @remainder)
        SET @result = 1;
    
    RETURN @result;
END
GO