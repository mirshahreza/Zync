USE [Test]
GO
/****** Object:  StoredProcedure [dbo].[Zync]    Script Date: 9/26/2025 9:39:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[Zync] 
	@Command VARCHAR(16)='?',@Repo VARCHAR(256)='https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/'
AS
BEGIN

	IF (@Command LIKE 'ls %')
    BEGIN
		PRINT ('Listing packages is not yet implemented.');
    END
    ELSE IF (@Command LIKE 'i %')
    BEGIN

		DECLARE	@rr				INT;
		DECLARE @rv				NVARCHAR(4000);
		DECLARE @PackageName	NVARCHAR(128) = REPLACE(@Command,'i ','');
		DECLARE @PackageFullURL NVARCHAR(4000) = @Repo + ISNULL(@PackageName,'');

		PRINT ('Installing '+@PackageName+' ...');

		IF(@PackageFullURL NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + '/.sql'

		DECLARE @status INT;
		DECLARE @responseText AS TABLE(responseText NVARCHAR(MAX));
		DECLARE @res AS INT;
		EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
		EXEC SP_OAMETHOD @res, 'open', NULL, 'GET',@PackageFullURL,'false';
		EXEC SP_OAMETHOD @res, 'send';
		EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
		INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
		EXEC SP_OADESTROY @res;
		SELECT @rr=@status,@rv=responseText FROM @responseText;

		IF(@rr=200)
		BEGIN
			PRINT @PackageName + ' fetched successful.'
			SET @rv = LTRIM(RTRIM(@rv));
			IF(CHARINDEX('/*', @rv)=1)
			BEGIN
				DECLARE @deps NVARCHAR(4000);
				SET @deps = LTRIM(RTRIM(SUBSTRING(@rv, 3, CHARINDEX('*/', @rv)-3)));
				EXECUTE SP_EXECUTESQL @deps;
			END

			EXECUTE SP_EXECUTESQL @rv;
			PRINT @PackageName + ' executed successful.';
		END
		ELSE
		BEGIN
			PRINT (@PackageFullURL + ' fetch problem.');
			PRINT (@PackageFullURL + ' fetch problem.');
			PRINT (@PackageFullURL + ' fetch problem.');
		END
    END
	ELSE
	BEGIN
		PRINT ('Commands :');
		PRINT ('EXEC [DBO].[ZipQl] (''?'', DEFAULT) -- Displays available commands and usage.');
		PRINT ('EXEC [DBO].[ZipQl] (''ls'', DEFAULT) -- Lists all available packages in the default repository.');
		PRINT ('EXEC [DBO].[ZipQl] (''ls'', DEFAULT) -- Lists all available packages in the default repository.');
		PRINT ('EXEC [DBO].[ZipQl] (''i'', DEFAULT) -- Installs all available packages from the default repository.');
		PRINT ('EXEC [DBO].[ZipQl] (''i pkg-name'', DEFAULT) -- Installs a specific package from the default repository.');
		PRINT ('EXEC [DBO].[ZipQl] (''i pkg-name/script-name.sql'', DEFAULT) -- Installs a specific script from a specific package in the default repository.');
		PRINT ('');
		PRINT ('Note : Replace the second parameter (DEFAULT) with a specific/custom repository URL.');
	END
	

END