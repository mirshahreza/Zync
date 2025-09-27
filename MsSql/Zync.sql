
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
	DECLARE @PackageFullURL NVARCHAR(4000) = @Repo;
	DECLARE @status INT;
	DECLARE @responseText AS TABLE(responseText NVARCHAR(MAX));
	DECLARE @res AS INT;
	DECLARE @deps NVARCHAR(MAX);

	IF (@Command LIKE 'ls%')
    BEGIN
		SET @PackageName	= TRIM(SUBSTRING(@Command, 3, LEN(@Command)));
		IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
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
    ELSE IF (@Command LIKE 'rm%')
    BEGIN
        SET @PackageName	= TRIM(SUBSTRING(@Command, 3, LEN(@Command)));
		IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('Removing package: '''+ @PackageName +'''...');

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
				PRINT ' -> Fetched ''' + @PackageName + ''' successfully for removal.'
				SET @rv = TRIM(@rv);

                IF (CHARINDEX('EXEC DBO.Zync', @rv) > 0) -- It's a package file
                BEGIN
                    PRINT ' -> Detected a package. Removing all scripts within...';
                    
                    DECLARE @ScriptsToRemove TABLE (ScriptLine NVARCHAR(MAX));
                    INSERT INTO @ScriptsToRemove (ScriptLine)
                    SELECT value FROM STRING_SPLIT(@rv, CHAR(10)) WHERE RTRIM(LTRIM(value)) != '';

                    DECLARE @CurrentScriptLine NVARCHAR(MAX);
                    DECLARE @RecursiveCommand NVARCHAR(MAX);
                    
                    DECLARE script_cursor CURSOR LOCAL FOR
                    SELECT ScriptLine FROM @ScriptsToRemove WHERE LTRIM(ScriptLine) LIKE 'EXEC DBO.Zync%';

                    OPEN script_cursor;
                    FETCH NEXT FROM script_cursor INTO @CurrentScriptLine;

                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @RecursiveCommand = REPLACE(REPLACE(@CurrentScriptLine, '''i ', '''rm '), 'EXEC DBO.Zync', 'EXEC [dbo].[Zync]');
                        
                        PRINT ' -> Executing sub-command: ' + @RecursiveCommand;
                        EXECUTE SP_EXECUTESQL @RecursiveCommand;

                        FETCH NEXT FROM script_cursor INTO @CurrentScriptLine;
                    END

                    CLOSE script_cursor;
                    DEALLOCATE script_cursor;

                    PRINT ' -> Package ''' + @PackageName + ''' and its contents removed successfully.';
                END
                ELSE -- It's a single script file
                BEGIN
                    -- Logic to parse object type and name, and then drop it
                    DECLARE @SqlScript NVARCHAR(MAX) = @rv;
                    DECLARE @ObjectType NVARCHAR(128);
                    DECLARE @ObjectName NVARCHAR(256);
                    DECLARE @DropStatement NVARCHAR(MAX);
                    DECLARE @start INT, @end INT;

                    -- Normalize script for parsing
                    SET @SqlScript = UPPER(REPLACE(REPLACE(@SqlScript, '[', ''), ']', ''));

                    -- Determine object type
                    IF CHARINDEX('CREATE OR ALTER PROCEDURE', @SqlScript) > 0 SET @ObjectType = 'PROCEDURE';
                    ELSE IF CHARINDEX('CREATE OR ALTER FUNCTION', @SqlScript) > 0 SET @ObjectType = 'FUNCTION';
                    ELSE IF CHARINDEX('CREATE OR ALTER VIEW', @SqlScript) > 0 SET @ObjectType = 'VIEW';
                    ELSE IF CHARINDEX('CREATE TYPE', @SqlScript) > 0 SET @ObjectType = 'TYPE';

                    IF @ObjectType IS NOT NULL
                    BEGIN
                        -- Extract object name
                        SET @start = CHARINDEX(@ObjectType, @SqlScript) + LEN(@ObjectType);
                        SET @SqlScript = LTRIM(SUBSTRING(@SqlScript, @start, 512));
                        SET @end = CHARINDEX('(', @SqlScript);
                        IF @end = 0 OR @end IS NULL SET @end = CHARINDEX(' AS', @SqlScript);
                        SET @ObjectName = TRIM(SUBSTRING(@SqlScript, 1, @end - 1));

                        -- Build DROP statement
                        SET @DropStatement = 'DROP ' + @ObjectType + ' IF EXISTS ' + @ObjectName;
                        
                        PRINT ' -> Dropping ' + @ObjectType + ' ' + @ObjectName + '...';
                        EXECUTE SP_EXECUTESQL @DropStatement;
                        PRINT ' -> Script ''' + @PackageName + ''' removed successfully.';
                    END
                    ELSE
                    BEGIN
                        PRINT 'Error: Could not determine object type in script ' + @PackageName;
                    END
                END
			END
			ELSE
			BEGIN
				PRINT 'Error: Could not fetch package from URL: ' + @PackageFullURL;
				PRINT 'HTTP Status: ' + CAST(@rr AS VARCHAR(10));
			END
		END TRY
		BEGIN CATCH
			PRINT 'An error occurred during removal.';
			IF @res IS NOT NULL EXEC SP_OADESTROY @res;
			THROW;
		END CATCH
    END
    ELSE IF (@Command LIKE 'i%')
    BEGIN
		SET @PackageName	= TRIM(SUBSTRING(@Command, 2, LEN(@Command)));
		IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('Installing package: '''+ @PackageName +'''...');

		PRINT (@PackageFullURL);

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
		PRINT ('  EXEC [dbo].[Zync] ''ls <package-name>''		-- Lists all scripts in a specific package.');
		PRINT ('  EXEC [dbo].[Zync] ''i <package-name>''		-- Installs a specific package and its scripts.');
		PRINT ('  EXEC [dbo].[Zync] ''rm <package-name>''		-- Removes a specific package and its scripts.');
		PRINT ('  EXEC [dbo].[Zync] ''i <pkg/script.sql>''	-- Installs a specific script from a package.');
		PRINT ('  EXEC [dbo].[Zync] ''rm <pkg/script.sql>''	-- Removes a specific script from a package.');
		PRINT ('');
		PRINT ('Examples:');
		PRINT ('  -- List all scripts in the "String" package:');
		PRINT ('  EXEC [dbo].[Zync] ''ls String''');
		PRINT ('');
		PRINT ('  -- Install the entire "Math" package:');
		PRINT ('  EXEC [dbo].[Zync] ''i Math''');
		PRINT ('');
		PRINT ('  -- Install only the "ZzTrim" script from the "String" package:');
		PRINT ('  EXEC [dbo].[Zync] ''i String/ZzTrim.sql''');
		PRINT ('');
		PRINT ('  -- Remove the "ZzSlugify" script from the "String" package:');
		PRINT ('  EXEC [dbo].[Zync] ''rm String/ZzSlugify.sql''');
		PRINT ('');
		PRINT ('  -- Remove the entire "DbMon" package:');
		PRINT ('  EXEC [dbo].[Zync] ''rm DbMon''');
	END
	
END