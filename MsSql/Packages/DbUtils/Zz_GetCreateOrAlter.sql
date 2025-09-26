-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-07-08
-- Description:	Generates Create Or Alter
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_GetCreateOrAlter]
	@ObjectName VARCHAR(128)
AS

BEGIN

SELECT TOP 1 CreateOrAlter FROM 
(
	SELECT ObjectDef,ObjectNameCharIndex,ObjectDefUntilName,MainPhrase
		,CHARINDEX (MainPhrase ,ObjectDefUntilName) GG
		,REPLACE(ObjectDef,MainPhrase,(REPLACE(MainPhrase,'CREATE ','CREATE OR ALTER '))) AS CreateOrAlter
	FROM (
		SELECT ObjectDef,ObjectNameCharIndex,ObjectDefUntilName 
			, LTRIM(RTRIM(REVERSE(SUBSTRING(REVERSE(ObjectDefUntilName),0,CHARINDEX(' ETAERC', REVERSE(ObjectDefUntilName))+7)))) AS MainPhrase
		FROM (
			SELECT
				DEFINITION AS ObjectDef,
				CHARINDEX(@ObjectName, DEFINITION) AS ObjectNameCharIndex,
				SUBSTRING(DEFINITION,0,CHARINDEX(@ObjectName, DEFINITION)) AS ObjectDefUntilName
			FROM SYS.SQL_MODULES 
			WHERE OBJECT_ID= OBJECT_ID(@ObjectName)
		) T
	) T
) T

END