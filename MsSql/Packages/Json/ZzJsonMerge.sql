-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Merge two JSON objects into one
-- Sample:		SELECT [dbo].[ZzJsonMerge]('{"a":1}', '{"b":2}');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzJsonMerge(
    @json1 NVARCHAR(MAX),
    @json2 NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX);
    
    -- Validate inputs
    IF @json1 IS NULL OR @json2 IS NULL
        RETURN NULL;
    
    IF ISJSON(@json1) = 0 OR ISJSON(@json2) = 0
        RETURN NULL;
    
    BEGIN TRY
        -- Use JSON_MODIFY to merge objects
        -- This is a simplified merge - JSON2 properties override JSON1
        DECLARE @merged NVARCHAR(MAX) = @json1;
        
        -- Extract all keys from json2 and add/update them in json1
        DECLARE @keys TABLE (keyname NVARCHAR(400), value NVARCHAR(MAX));
        
        INSERT INTO @keys (keyname, value)
        SELECT [key], value 
        FROM OPENJSON(@json2);
        
        DECLARE @key NVARCHAR(400), @value NVARCHAR(MAX);
        DECLARE key_cursor CURSOR FOR 
        SELECT keyname, value FROM @keys;
        
        OPEN key_cursor;
        FETCH NEXT FROM key_cursor INTO @key, @value;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @merged = JSON_MODIFY(@merged, '$.' + @key, JSON_QUERY(@value));
            IF @merged IS NULL
                SET @merged = JSON_MODIFY(@json1, '$.' + @key, @value);
            
            FETCH NEXT FROM key_cursor INTO @key, @value;
        END
        
        CLOSE key_cursor;
        DEALLOCATE key_cursor;
        
        SET @result = @merged;
        
    END TRY
    BEGIN CATCH
        SET @result = NULL;
    END CATCH
    
    RETURN @result;
END
GO