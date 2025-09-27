-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-18
-- Description:	Formats a single-digit string by prepending a '0' to ensure it is two characters long. Returns the original string if it's already two characters.
-- Sample:
-- SELECT [dbo].[ZzFix2Char]('5');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzFix2Char] ( @S VARCHAR(8) )
RETURNS VARCHAR(8)
BEGIN

	DECLARE @L INT;
	DECLARE @R VARCHAR(8);

	SET @L = LEN(@S);

	IF @L=2 SET @R=@S;
	ELSE IF @L=1 SET @R='0'+@S;
	ELSE SET @R=NULL;

	RETURN @R;

END