
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[Zync] 
	@Command VARCHAR(128)='?',@Repo VARCHAR(256)='https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@rr				INT;
	DECLARE @rv				NVARCHAR(MAX);
	DECLARE @PackageName	NVARCHAR(128);
	DECLARE @PackageFullURL NVARCHAR(4000) = @Repo + ISNULL(@PackageName,'');
	DECLARE @status INT;
	DECLARE @responseText AS TABLE(responseText NVARCHAR(MAX));
	DECLARE @res AS INT;
	DECLARE @deps NVARCHAR(MAX);

	IF (@Command LIKE 'ls%')
    BEGIN
		SET @PackageName	= TRIM(SUBSTRING(@Command, 3, LEN(@Command)));
		IF(@PackageFullURL NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('Listing package(s): '''+ @PackageName +'''...');

		BEGIN TRY
			EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
			EXEC SP_OAMETHOD @res, 'open', NULL, 'GET',@PackageFullURL,'false';
			EXEC SP_OAMETHOD @res, 'send';
			EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
			INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
			EXEC SP_OADESTROY @res;
			SELECT @rr=@status,@rv=responseText FROM @responseText;

			IF(@rr=200)
			BEGIN
				PRINT ' -> Fetched ''' + @PackageName + ''' successfully.'
				SET @rv = TRIM(@rv);
				IF(CHARINDEX('/*', @rv)=1 AND CHARINDEX('*/', @rv) > 1)
				BEGIN
					SET @deps = TRIM(SUBSTRING(@rv, 3, CHARINDEX('*/', @rv)-3));
					PRINT ' -> Fetching dependencies...';
					PRINT REPLACE(REPLACE(@deps,'EXEC DBO.Zync ','		'),'i ','');
				END
				PRINT REPLACE(REPLACE(@rv,'EXEC DBO.Zync ','		'),'i ','');
				PRINT ' -> Package ''' + @PackageName + ''' listed successfully.';
			END
			ELSE
			BEGIN
				PRINT 'Error: Could not fetch package from URL: ' + @PackageFullURL;
				PRINT 'HTTP Status: ' + CAST(@rr AS VARCHAR(10));
			END
		END TRY
		BEGIN CATCH
			PRINT 'An error occurred during package listing.';
			IF @res IS NOT NULL EXEC SP_OADESTROY @res;
			THROW;
		END CATCH
    END
    ELSE IF (@Command LIKE 'i%')
    BEGIN
		SET @PackageName	= TRIM(SUBSTRING(@Command, 2, LEN(@Command)));
		IF(@PackageFullURL NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('Installing package: '''+ @PackageName +'''...');

		BEGIN TRY
			EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
			EXEC SP_OAMETHOD @res, 'open', NULL, 'GET',@PackageFullURL,'false';
			EXEC SP_OAMETHOD @res, 'send';
			EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
			INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
			EXEC SP_OADESTROY @res;
			SELECT @rr=@status,@rv=responseText FROM @responseText;

			IF(@rr=200)
			BEGIN
				PRINT ' -> Fetched ''' + @PackageName + ''' successfully.'
				SET @rv = TRIM(@rv);
				IF(CHARINDEX('/*', @rv)=1 AND CHARINDEX('*/', @rv) > 1)
				BEGIN
					SET @deps = TRIM(SUBSTRING(@rv, 3, CHARINDEX('*/', @rv)-3));
					PRINT ' -> Installing dependencies...';
					EXECUTE SP_EXECUTESQL @deps;
				END

				EXECUTE SP_EXECUTESQL @rv;
				PRINT ' -> Package ''' + @PackageName + ''' installed successfully.';
			END
			ELSE
			BEGIN
				PRINT 'Error: Could not fetch package from URL: ' + @PackageFullURL;
				PRINT 'HTTP Status: ' + CAST(@rr AS VARCHAR(10));
			END
		END TRY
		BEGIN CATCH
			PRINT 'An error occurred during installation.';
			IF @res IS NOT NULL EXEC SP_OADESTROY @res;
			THROW;
		END CATCH
    END
	ELSE
	BEGIN
		PRINT ('Zync - Database Package Manager');
		PRINT ('---------------------------------');
		PRINT ('Commands:');
		PRINT ('  EXEC [dbo].[Zync] ''?''						-- Displays this help message.');
		PRINT ('  EXEC [dbo].[Zync] ''ls''					-- Lists all available packages in the repository.');
		PRINT ('  EXEC [dbo].[Zync] ''i <package-name>''		-- Installs a specific package.');
		PRINT ('  EXEC [dbo].[Zync] ''i <pkg/script.sql>''	-- Installs a specific script from a package.');
		PRINT ('');
		PRINT ('Example:');
		PRINT ('  EXEC [dbo].[Zync] ''i String''');
	END
	
END