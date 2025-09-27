-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Creates a hash of a string using a specified algorithm.
-- Sample:
-- SELECT [dbo].[ZzHash]('Hello World', 'SHA2_256');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzHash]
(
    @InputString NVARCHAR(MAX),
    @Algorithm NVARCHAR(10) = 'SHA2_256'
)
RETURNS VARBINARY(8000)
AS
BEGIN
    RETURN HASHBYTES(@Algorithm, @InputString);
END
