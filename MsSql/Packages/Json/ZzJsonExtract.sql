-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Extract values from JSON using JSON path expressions
-- Sample:		SELECT [dbo].[ZzJsonExtract]('{"name":"John","age":30}', '$.name');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzJsonExtract(
    @json NVARCHAR(MAX),
    @path NVARCHAR(400)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX);
    
    -- Validate inputs
    IF @json IS NULL OR @path IS NULL OR LEN(@json) = 0 OR LEN(@path) = 0
        RETURN NULL;
    
    -- Validate JSON format
    IF ISJSON(@json) = 0
        RETURN NULL;
    
    -- Extract value using JSON_VALUE or JSON_QUERY
    BEGIN TRY
        -- Try JSON_VALUE first (for scalar values)
        SET @result = JSON_VALUE(@json, @path);
        
        -- If NULL, try JSON_QUERY (for objects/arrays)
        IF @result IS NULL
            SET @result = JSON_QUERY(@json, @path);
            
    END TRY
    BEGIN CATCH
        SET @result = NULL;
    END CATCH
    
    RETURN @result;
END
GO