-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate credit card numbers using Luhn algorithm
-- Sample:		SELECT [dbo].[ZzValidateCreditCard]('4111111111111111');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidateCreditCard(
    @card_number NVARCHAR(20)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    DECLARE @clean_number NVARCHAR(20);
    DECLARE @i INT = 1;
    DECLARE @sum INT = 0;
    DECLARE @alternate BIT = 0;
    
    -- Remove any non-digit characters (spaces, dashes, etc.)
    SET @clean_number = '';
    WHILE @i <= LEN(@card_number)
    BEGIN
        IF SUBSTRING(@card_number, @i, 1) LIKE '[0-9]'
            SET @clean_number = @clean_number + SUBSTRING(@card_number, @i, 1);
        SET @i = @i + 1;
    END
    
    -- Must be between 13-19 digits
    IF LEN(@clean_number) < 13 OR LEN(@clean_number) > 19
        RETURN 0;
    
    -- Apply Luhn algorithm
    SET @i = LEN(@clean_number);
    WHILE @i >= 1
    BEGIN
        DECLARE @digit INT = CONVERT(INT, SUBSTRING(@clean_number, @i, 1));
        
        IF @alternate = 1
        BEGIN
            SET @digit = @digit * 2;
            IF @digit > 9
                SET @digit = @digit - 9;
        END
        
        SET @sum = @sum + @digit;
        SET @alternate = CASE WHEN @alternate = 1 THEN 0 ELSE 1 END;
        SET @i = @i - 1;
    END
    
    -- Valid if sum is divisible by 10
    IF @sum % 10 = 0
        SET @result = 1;
    
    RETURN @result;
END
GO