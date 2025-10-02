-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get length of JSON array
-- Sample:		SELECT [dbo].[ZzJsonArrayLength]('[1,2,3,4,5]');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzJsonArrayLength(
    @json NVARCHAR(MAX)
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
    
    -- Validate input
    IF @json IS NULL OR ISJSON(@json) = 0
        RETURN 0;
    
    -- Check if it's an array (starts with [ and ends with ])
    SET @json = LTRIM(RTRIM(@json));
    IF LEFT(@json, 1) != '[' OR RIGHT(@json, 1) != ']'
        RETURN 0;
    
    BEGIN TRY
        -- Count elements in the JSON array
        SELECT @result = COUNT(*)
        FROM OPENJSON(@json);
        
    END TRY
    BEGIN CATCH
        SET @result = 0;
    END CATCH
    
    RETURN @result;
END
GO