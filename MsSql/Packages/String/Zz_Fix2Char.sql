-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-18
-- Description:	Adds a zero before if the lenght is equal to 1
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[Zz_Fix2Char] ( @S VARCHAR(8) )
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