-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Normalize Iranian address format (remove extra spaces, fix encoding)
-- Sample:		SELECT dbo.ZzNormalizeAddress('تهران    ،    خیابان  ولیعصر ، پلاک ۱۲۳')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzNormalizeAddress(
    @Address NVARCHAR(500)
)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @Result NVARCHAR(500);
    
    -- Return null if input is null or empty
    IF @Address IS NULL OR LTRIM(RTRIM(@Address)) = ''
        RETURN NULL;
    
    SET @Result = @Address;
    
    -- Remove extra spaces
    WHILE CHARINDEX('  ', @Result) > 0
        SET @Result = REPLACE(@Result, '  ', ' ');
    
    -- Trim leading and trailing spaces
    SET @Result = LTRIM(RTRIM(@Result));
    
    -- Fix common spacing issues around punctuation
    SET @Result = REPLACE(@Result, ' ,', '،');
    SET @Result = REPLACE(@Result, ', ', '، ');
    SET @Result = REPLACE(@Result, ' ،', '،');
    SET @Result = REPLACE(@Result, '،', '، ');
    
    -- Fix multiple commas
    WHILE CHARINDEX('،،', @Result) > 0
        SET @Result = REPLACE(@Result, '،،', '،');
    
    -- Convert English numbers to Persian numbers
    SET @Result = REPLACE(@Result, '0', '۰');
    SET @Result = REPLACE(@Result, '1', '۱');
    SET @Result = REPLACE(@Result, '2', '۲');
    SET @Result = REPLACE(@Result, '3', '۳');
    SET @Result = REPLACE(@Result, '4', '۴');
    SET @Result = REPLACE(@Result, '5', '۵');
    SET @Result = REPLACE(@Result, '6', '۶');
    SET @Result = REPLACE(@Result, '7', '۷');
    SET @Result = REPLACE(@Result, '8', '۸');
    SET @Result = REPLACE(@Result, '9', '۹');
    
    -- Standardize common address terms
    SET @Result = REPLACE(@Result, 'خیابان', 'خیابان');
    SET @Result = REPLACE(@Result, 'کوچه', 'کوچه');
    SET @Result = REPLACE(@Result, 'پلاک', 'پلاک');
    SET @Result = REPLACE(@Result, 'واحد', 'واحد');
    SET @Result = REPLACE(@Result, 'طبقه', 'طبقه');
    SET @Result = REPLACE(@Result, 'شماره', 'شماره');
    SET @Result = REPLACE(@Result, 'بلوار', 'بلوار');
    SET @Result = REPLACE(@Result, 'میدان', 'میدان');
    SET @Result = REPLACE(@Result, 'چهارراه', 'چهارراه');
    SET @Result = REPLACE(@Result, 'سه راه', 'سه‌راه');
    
    -- Fix common abbreviations
    SET @Result = REPLACE(@Result, 'خ ', 'خیابان ');
    SET @Result = REPLACE(@Result, 'ک ', 'کوچه ');
    SET @Result = REPLACE(@Result, 'پ ', 'پلاک ');
    
    -- Remove trailing comma and spaces
    SET @Result = LTRIM(RTRIM(@Result));
    IF RIGHT(@Result, 1) = '،'
        SET @Result = LEFT(@Result, LEN(@Result) - 1);
    SET @Result = LTRIM(RTRIM(@Result));
    
    -- Capitalize first letter of each part (after comma)
    DECLARE @TempResult NVARCHAR(500) = '';
    DECLARE @Part NVARCHAR(100);
    DECLARE @Pos INT = 1;
    
    WHILE @Pos <= LEN(@Result)
    BEGIN
        DECLARE @CommaPos INT = CHARINDEX('،', @Result, @Pos);
        
        IF @CommaPos = 0
            SET @CommaPos = LEN(@Result) + 1;
        
        SET @Part = SUBSTRING(@Result, @Pos, @CommaPos - @Pos);
        SET @Part = LTRIM(RTRIM(@Part));
        
        IF LEN(@Part) > 0
        BEGIN
            IF @TempResult <> ''
                SET @TempResult = @TempResult + '، ';
            SET @TempResult = @TempResult + @Part;
        END
        
        SET @Pos = @CommaPos + 1;
    END
    
    SET @Result = @TempResult;
    
    RETURN @Result;
END
GO