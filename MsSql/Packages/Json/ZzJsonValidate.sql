-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate JSON format and structure
-- Sample:		SELECT [dbo].[ZzJsonValidate]('{"valid": true}');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzJsonValidate(
    @json NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    
    -- Basic null/empty check
    IF @json IS NULL OR LEN(@json) = 0
        RETURN 0;
    
    -- Use SQL Server's built-in JSON validation
    IF ISJSON(@json) = 1
        SET @result = 1;
    
    RETURN @result;
END
GO