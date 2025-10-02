-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Mask sensitive data for display purposes
-- Sample:		SELECT [dbo].[ZzMaskSensitiveData]('1234567890123456', 'CARD');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzMaskSensitiveData(
    @data NVARCHAR(256),
    @type NVARCHAR(20) = 'DEFAULT'
)
RETURNS NVARCHAR(256)
AS
BEGIN
    DECLARE @result NVARCHAR(256);
    DECLARE @len INT;
    
    -- Validate input
    IF @data IS NULL OR LEN(@data) = 0
        RETURN @data;
    
    SET @len = LEN(@data);
    SET @type = UPPER(ISNULL(@type, 'DEFAULT'));
    
    -- Different masking strategies based on data type
    IF @type = 'CARD' -- Credit card number
    BEGIN
        IF @len >= 12
            SET @result = LEFT(@data, 4) + REPLICATE('*', @len - 8) + RIGHT(@data, 4);
        ELSE
            SET @result = REPLICATE('*', @len);
    END
    ELSE IF @type = 'EMAIL' -- Email address
    BEGIN
        DECLARE @at_pos INT = CHARINDEX('@', @data);
        IF @at_pos > 1
        BEGIN
            DECLARE @local_part NVARCHAR(128) = LEFT(@data, @at_pos - 1);
            DECLARE @domain_part NVARCHAR(128) = SUBSTRING(@data, @at_pos, @len - @at_pos + 1);
            
            IF LEN(@local_part) <= 2
                SET @result = REPLICATE('*', LEN(@local_part)) + @domain_part;
            ELSE
                SET @result = LEFT(@local_part, 1) + REPLICATE('*', LEN(@local_part) - 2) + RIGHT(@local_part, 1) + @domain_part;
        END
        ELSE
            SET @result = REPLICATE('*', @len);
    END
    ELSE IF @type = 'PHONE' -- Phone number
    BEGIN
        IF @len >= 6
            SET @result = LEFT(@data, 2) + REPLICATE('*', @len - 4) + RIGHT(@data, 2);
        ELSE
            SET @result = REPLICATE('*', @len);
    END
    ELSE IF @type = 'NATIONAL_ID' -- National ID
    BEGIN
        IF @len >= 6
            SET @result = LEFT(@data, 2) + REPLICATE('*', @len - 4) + RIGHT(@data, 2);
        ELSE
            SET @result = REPLICATE('*', @len);
    END
    ELSE -- DEFAULT masking
    BEGIN
        IF @len <= 3
            SET @result = REPLICATE('*', @len);
        ELSE IF @len <= 6
            SET @result = LEFT(@data, 1) + REPLICATE('*', @len - 2) + RIGHT(@data, 1);
        ELSE
            SET @result = LEFT(@data, 2) + REPLICATE('*', @len - 4) + RIGHT(@data, 2);
    END
    
    RETURN @result;
END
GO