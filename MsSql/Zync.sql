SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2024-07-29
-- Description:	Enhanced Database Package Manager with backup/rollback capabilities
-- Version:		3.0
-- =============================================

-- Create helper procedure first to avoid dependency issues
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZyncParseObject]') AND type in (N'P'))
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[ZyncParseObject] AS BEGIN SELECT 1 END') -- Placeholder
END
GO

-- Create backup/rollback infrastructure
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZyncPackages]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ZyncPackages] (
        [PackageId] UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
        [PackageName] NVARCHAR(128) NOT NULL,
        [Version] INT NOT NULL DEFAULT 1,
        [InstallDate] DATETIME2 DEFAULT GETDATE(),
        [Status] NVARCHAR(20) DEFAULT 'INSTALLED', -- INSTALLED, UPDATED, REMOVED
        [BackupData] NVARCHAR(MAX) NULL,
        [Dependencies] NVARCHAR(MAX) NULL,
        INDEX IX_ZyncPackages_Name_Version (PackageName, Version DESC)
    )
    PRINT 'Created ZyncPackages table for tracking installations'
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZyncObjects]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ZyncObjects] (
        [ObjectId] UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
        [PackageId] UNIQUEIDENTIFIER REFERENCES [dbo].[ZyncPackages](PackageId),
        [ObjectName] NVARCHAR(256) NOT NULL,
        [ObjectType] NVARCHAR(50) NOT NULL, -- PROCEDURE, FUNCTION, VIEW, TYPE
        [ObjectDefinition] NVARCHAR(MAX) NOT NULL,
        [PreviousDefinition] NVARCHAR(MAX) NULL,
        [CreateDate] DATETIME2 DEFAULT GETDATE(),
        [ModifyDate] DATETIME2 DEFAULT GETDATE(),
        INDEX IX_ZyncObjects_Package (PackageId),
        INDEX IX_ZyncObjects_Name (ObjectName)
    )
    PRINT 'Created ZyncObjects table for tracking object changes'
END

GO

-- Helper procedure to parse object information from SQL scripts
CREATE OR ALTER PROCEDURE [dbo].[ZyncParseObject]
    @SqlScript NVARCHAR(MAX),
    @ObjectType NVARCHAR(128) OUTPUT,
    @ObjectName NVARCHAR(256) OUTPUT
AS
BEGIN
    SET @ObjectType = NULL;
    SET @ObjectName = NULL;
    
    -- Strip comments to prevent parsing errors
    DECLARE @CleanScript NVARCHAR(MAX) = @SqlScript;
    WHILE CHARINDEX('/*', @CleanScript) > 0
        SET @CleanScript = STUFF(@CleanScript, CHARINDEX('/*', @CleanScript), CHARINDEX('*/', @CleanScript, CHARINDEX('/*', @CleanScript)) - CHARINDEX('/*', @CleanScript) + 2, '');
    WHILE CHARINDEX('--', @CleanScript) > 0
        SET @CleanScript = STUFF(@CleanScript, CHARINDEX('--', @CleanScript), CHARINDEX(CHAR(10), @CleanScript, CHARINDEX('--', @CleanScript)) - CHARINDEX('--', @CleanScript), '');

    -- Normalize script for parsing
    SET @CleanScript = UPPER(REPLACE(REPLACE(@CleanScript, '[', ''), ']', ''));

    -- Determine object type and extract name
    DECLARE @start INT, @end INT;
    
    IF CHARINDEX('CREATE OR ALTER PROCEDURE', @CleanScript) > 0 
    BEGIN
        SET @ObjectType = 'PROCEDURE';
        SET @start = CHARINDEX('CREATE OR ALTER PROCEDURE', @CleanScript) + LEN('CREATE OR ALTER PROCEDURE');
    END
    ELSE IF CHARINDEX('CREATE OR ALTER FUNCTION', @CleanScript) > 0 
    BEGIN
        SET @ObjectType = 'FUNCTION';
        SET @start = CHARINDEX('CREATE OR ALTER FUNCTION', @CleanScript) + LEN('CREATE OR ALTER FUNCTION');
    END
    ELSE IF CHARINDEX('CREATE OR ALTER VIEW', @CleanScript) > 0 
    BEGIN
        SET @ObjectType = 'VIEW';
        SET @start = CHARINDEX('CREATE OR ALTER VIEW', @CleanScript) + LEN('CREATE OR ALTER VIEW');
    END
    ELSE IF CHARINDEX('CREATE TYPE', @CleanScript) > 0 
    BEGIN
        SET @ObjectType = 'TYPE';
        SET @start = CHARINDEX('CREATE TYPE', @CleanScript) + LEN('CREATE TYPE');
    END

    IF @ObjectType IS NOT NULL AND @start > 0
    BEGIN
        SET @CleanScript = LTRIM(SUBSTRING(@CleanScript, @start, 512));
        SET @end = CHARINDEX('(', @CleanScript);
        IF @end = 0 OR @end IS NULL SET @end = CHARINDEX(' AS', @CleanScript);
        IF @end = 0 OR @end IS NULL SET @end = CHARINDEX(' ', @CleanScript);
        
        IF @end > 0
            SET @ObjectName = TRIM(SUBSTRING(@CleanScript, 1, @end - 1));
    END
END
GO

CREATE OR ALTER PROCEDURE [dbo].[Zync] 
	@Command VARCHAR(128)='?',@Repo VARCHAR(256)='https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@rr				INT;
	DECLARE @rv				NVARCHAR(MAX);
	DECLARE @PackageName	NVARCHAR(128);
	DECLARE @PackageFullURL NVARCHAR(4000) = @Repo;
	DECLARE @status INT;
	DECLARE @responseText TABLE(responseText NVARCHAR(MAX));
	DECLARE @res INT;
	DECLARE @deps NVARCHAR(MAX);

	IF (@Command LIKE 'ls%')
    BEGIN
		-- Support optional search: syntax 'ls ?term' or 'ls <package> ?term'
		DECLARE @RawArg NVARCHAR(256) = TRIM(SUBSTRING(@Command, 3, LEN(@Command)));
		DECLARE @Search NVARCHAR(128) = NULL;
		DECLARE @SearchPattern NVARCHAR(256) = NULL;
		DECLARE @qpos INT = NULL;
		SET @qpos = CHARINDEX('?', @RawArg);
		IF (@qpos > 0)
		BEGIN
			SET @Search = TRIM(SUBSTRING(@RawArg, @qpos + 1, 4000));
			SET @PackageName = TRIM(LEFT(@RawArg, @qpos - 1));
			IF (@Search = '') SET @Search = NULL;
		END
		ELSE
		BEGIN
			SET @PackageName = @RawArg;
		END

		IF @Search IS NOT NULL
		BEGIN
			-- Build a case-insensitive LIKE pattern; allow '*' as wildcard too
			SET @SearchPattern = LOWER(REPLACE(@Search, '*', '%'));
			IF CHARINDEX('%', @SearchPattern) = 0 SET @SearchPattern = '%' + @SearchPattern + '%';
		END

		IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('Listing package(s): '''+ @PackageName + CASE WHEN @Search IS NOT NULL THEN ''' (filter: ' + @Search + ')' ELSE '''' END + '...');

		BEGIN TRY
			EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
			EXEC SP_OAMETHOD @res, 'open', NULL, 'GET',@PackageFullURL,'false';
			EXEC SP_OAMETHOD @res, 'send';
			EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
			   DELETE FROM @ResponseText; INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
			EXEC SP_OADESTROY @res;
			SELECT @rr=@status,@rv=responseText FROM @responseText;

			IF(@rr=200)
			BEGIN
				PRINT ' -> Fetched ''' + @PackageName + ''' successfully.'
				SET @rv = TRIM(@rv);
				IF(CHARINDEX('/*', @rv)=1 AND CHARINDEX('*/', @rv) > 1)
				BEGIN
					SET @deps = TRIM(SUBSTRING(@rv, 3, CHARINDEX('*/', @rv)-3));
						-- PRINT ' -> Fetching dependencies...';
						-- PRINT REPLACE(REPLACE(@deps,'EXEC DBO.Zync ','		'),'i ','');
				END
					-- PRINT REPLACE(REPLACE(@rv,'EXEC DBO.Zync ','		'),'i ','');
					-- PRINT ' -> Package ''' + @PackageName + ''' listed successfully.';

				   -- New: Also show sub-items (objects) inside each package
				   -- Preserve the fetched package index source before any further HTTP calls (like README)
				   DECLARE @IndexSrc NVARCHAR(MAX) = @rv;
				   DECLARE @ScanSrc NVARCHAR(MAX) = ISNULL(@deps + CHAR(10), '') + ISNULL(@rv, '');
				   DECLARE @p INT, @q INT, @token NVARCHAR(512);
               
				   -- If no package specified, expand all packages listed in the index
				   IF (ISNULL(@PackageName, '') = '')
				   BEGIN
					   PRINT '';
					   IF @Search IS NULL
					   	PRINT ' -> Expanding packages and listing contained objects:';
					   ELSE
					   	PRINT ' -> Searching across packages and objects...';
					   DECLARE @Packages TABLE (Name NVARCHAR(128) PRIMARY KEY);
					   SET @p = CHARINDEX('''i ', @ScanSrc);
					   WHILE @p > 0
					   BEGIN
						   SET @q = CHARINDEX('''', @ScanSrc, @p + 3);
						   IF @q = 0 BREAK;
						   SET @token = TRIM(SUBSTRING(@ScanSrc, @p + 3, @q - (@p + 3)));
						   -- Only capture top-level packages (no slash)
						   IF @token NOT LIKE '%.sql' AND CHARINDEX('/', @token) = 0 AND LEN(@token) > 0
							   IF NOT EXISTS (SELECT 1 FROM @Packages WHERE Name = @token) INSERT INTO @Packages(Name) VALUES(@token);
						   SET @p = CHARINDEX('''i ', @ScanSrc, @q + 1);
					   END

					   DECLARE @CurPkg NVARCHAR(128);
					   DECLARE pkg_cursor CURSOR LOCAL FOR SELECT Name FROM @Packages ORDER BY Name;
					   OPEN pkg_cursor; FETCH NEXT FROM pkg_cursor INTO @CurPkg;
					   WHILE @@FETCH_STATUS = 0
					   BEGIN
						   -- In root ls mode print package heading unless filtering; with filtering, print when first match is found
						   IF @Search IS NULL PRINT '    ' + QUOTENAME(@CurPkg) + ':';
						   DECLARE @PkgUrl NVARCHAR(4000) = @Repo + @CurPkg + '/.sql';
						   SET @PkgUrl = REPLACE(@PkgUrl,'//.sql','/.sql');

						   BEGIN TRY
							   EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
							   EXEC SP_OAMETHOD @res, 'open', NULL, 'GET',@PkgUrl,'false';
							   EXEC SP_OAMETHOD @res, 'send';
							   EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
							   DELETE FROM @ResponseText; INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
							   EXEC SP_OADESTROY @res;
							   SELECT @rr=@status,@rv=responseText FROM @responseText;

							   IF(@rr=200)
							   BEGIN
								   DECLARE @PkgSrc NVARCHAR(MAX) = @rv;
						   	   	   DECLARE @GroupPrinted BIT = 0;
								   SET @p = CHARINDEX('''i ', @PkgSrc);
								   WHILE @p > 0
								   BEGIN
									   SET @q = CHARINDEX('''', @PkgSrc, @p + 3);
									   IF @q = 0 BREAK;
									   SET @token = TRIM(SUBSTRING(@PkgSrc, @p + 3, @q - (@p + 3)));
									   -- Expecting tokens like '<Pkg>/SomeScript.sql'
									   IF @token LIKE @CurPkg + '/%'
									   BEGIN
										   DECLARE @Item NVARCHAR(512) = SUBSTRING(@token, LEN(@CurPkg) + 2, 512);
										   -- Root ls mode: show only filenames, no descriptions
						   	   	   	   	   IF @Search IS NULL
						   	   	   	   	   	   PRINT '        - ' + @Item;
						   	   	   	   	   ELSE
						   	   	   	   	   	   BEGIN
						   	   	   	   	   	   	   DECLARE @ItemLower NVARCHAR(512) = LOWER(@Item);
						   	   	   	   	   	   	   IF PATINDEX(@SearchPattern, @ItemLower) > 0
						   	   	   	   	   	   	   BEGIN
						   	   	   	   	   	   	   	   IF @GroupPrinted = 0
						   	   	   	   	   	   	   	   BEGIN
						   	   	   	   	   	   	   	   	   PRINT '    ' + QUOTENAME(@CurPkg) + ':';
						   	   	   	   	   	   	   	   	   SET @GroupPrinted = 1;
						   	   	   	   	   	   	   	   END
						   	   	   	   	   	   	   	   PRINT '        - ' + @Item;
						   	   	   	   	   	   	   END
						   	   	   	   	   	   END
									   END
									   SET @p = CHARINDEX('''i ', @PkgSrc, @q + 1);
								   END
							   END
							   ELSE
							   BEGIN
								   PRINT '        (could not fetch: HTTP ' + CAST(@rr AS VARCHAR(10)) + ')';
							   END
						   END TRY
						   BEGIN CATCH
							   PRINT '        (error expanding package: ' + ERROR_MESSAGE() + ')';
							   IF @res IS NOT NULL EXEC SP_OADESTROY @res;
						   END CATCH

						   FETCH NEXT FROM pkg_cursor INTO @CurPkg;
					   END
					   CLOSE pkg_cursor; DEALLOCATE pkg_cursor;
				   END
				   ELSE
				   BEGIN
					   -- Specific package requested: list its objects
					   PRINT '';
					   -- Fetch package README for description
					   DECLARE @PkgReadmeUrl2 NVARCHAR(4000) = @Repo + @PackageName + '/README.md';
					   DECLARE @PkgDesc2 NVARCHAR(4000) = NULL;
					   BEGIN TRY
						   EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
						   EXEC SP_OAMETHOD @res, 'open', NULL, 'GET',@PkgReadmeUrl2,'false';
						   EXEC SP_OAMETHOD @res, 'send';
						   EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
						   DELETE FROM @ResponseText; INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
						   EXEC SP_OADESTROY @res;
						   SELECT @rr=@status,@rv=responseText FROM @ResponseText;
						   IF (@rr=200)
						   BEGIN
							   DECLARE @readme2 NVARCHAR(MAX) = @rv;
							   DECLARE @ls2 INT=1, @le2 INT, @line2 NVARCHAR(4000);
							   WHILE 1=1
							   BEGIN
								   SET @le2 = CHARINDEX(CHAR(10), @readme2, @ls2);
								   IF @le2 = 0 SET @le2 = LEN(@readme2) + 1;
								   SET @line2 = TRIM(REPLACE(REPLACE(SUBSTRING(@readme2, @ls2, @le2-@ls2), CHAR(13), ''), CHAR(10), ''));
								   IF (@line2 IS NULL OR @line2 = '') OR LEFT(@line2,3)='```' OR LEFT(@line2,1)='#' OR LEFT(@line2,2)='##' OR LEFT(@line2,1)='>' OR LEFT(@line2,1)='-' OR LEFT(@line2,1)='*'
								   BEGIN
									   IF @le2 >= LEN(@readme2) BREAK; ELSE SET @ls2 = @le2 + 1; CONTINUE;
								   END
								   ELSE BEGIN SET @PkgDesc2 = LEFT(@line2, 180); BREAK; END
							   END
						   END
					   END TRY
					   BEGIN CATCH
						   IF @res IS NOT NULL EXEC SP_OADESTROY @res;
					   END CATCH
					   IF @Search IS NULL
					   	   PRINT ' -> Objects inside package ' + QUOTENAME(@PackageName) + CASE WHEN @PkgDesc2 IS NOT NULL AND @PkgDesc2<>'' THEN ' — ' + @PkgDesc2 ELSE ':' END;
					   ELSE
					   	   PRINT ' -> Searching inside package ' + QUOTENAME(@PackageName) + CASE WHEN @PkgDesc2 IS NOT NULL AND @PkgDesc2<>'' THEN ' — ' + @PkgDesc2 ELSE '' END + ' (filter: ' + @Search + ')';
					   -- Use the preserved package index source (not README content)
					   DECLARE @PkgSrc2 NVARCHAR(MAX) = @IndexSrc;
					   SET @p = CHARINDEX('''i ', @PkgSrc2);
					   WHILE @p > 0
					   BEGIN
						   SET @q = CHARINDEX('''', @PkgSrc2, @p + 3);
						   IF @q = 0 BREAK;
						   SET @token = TRIM(SUBSTRING(@PkgSrc2, @p + 3, @q - (@p + 3)));
						   IF @token LIKE @PackageName + '/%'
						   BEGIN
							   DECLARE @Item2 NVARCHAR(512) = SUBSTRING(@token, LEN(@PackageName) + 2, 512);
							   -- Skip the meta entry '/.sql' if present
							   IF @Item2 <> '.sql'
							   BEGIN
							   -- Fetch script for description
							   DECLARE @FileUrl2 NVARCHAR(4000) = @Repo + @token;
							   DECLARE @ItemDesc2 NVARCHAR(4000) = NULL;
							   BEGIN TRY
								   EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
								   EXEC SP_OAMETHOD @res, 'open', NULL, 'GET',@FileUrl2,'false';
								   EXEC SP_OAMETHOD @res, 'send';
								   EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
								   DELETE FROM @ResponseText; INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
								   EXEC SP_OADESTROY @res;
								   SELECT @rr=@status,@rv=responseText FROM @ResponseText;
								   IF (@rr=200)
								   BEGIN
									   DECLARE @src2 NVARCHAR(MAX) = @rv;
									   DECLARE @pos2 INT = CHARINDEX('-- Description:', @src2);
									   IF @pos2 > 0
									   BEGIN
										   DECLARE @eol2 INT = CHARINDEX(CHAR(10), @src2, @pos2);
										   IF @eol2 = 0 SET @eol2 = LEN(@src2)+1;
										   SET @ItemDesc2 = TRIM(REPLACE(REPLACE(SUBSTRING(@src2, @pos2 + LEN('-- Description:'), @eol2 - (@pos2 + LEN('-- Description:'))), CHAR(13), ''), CHAR(10), ''));
									   END
									   ELSE
									   BEGIN
										   SET @pos2 = CHARINDEX('Description:', @src2);
										   IF @pos2 > 0 AND @pos2 < 500
										   BEGIN
											   DECLARE @end22 INT = CHARINDEX(CHAR(10), @src2, @pos2);
											   IF @end22 = 0 SET @end22 = LEN(@src2)+1;
											   SET @ItemDesc2 = TRIM(REPLACE(REPLACE(SUBSTRING(@src2, @pos2 + LEN('Description:'), @end22 - (@pos2 + LEN('Description:'))), CHAR(13), ''), CHAR(10), ''));
										   END
									   END
								   END
							   END TRY
							   BEGIN CATCH
								   IF @res IS NOT NULL EXEC SP_OADESTROY @res;
							   END CATCH
						   	   IF @ItemDesc2 IS NULL SET @ItemDesc2 = '';
						   	   -- Apply search filter if provided: match on file name or description
						   	   IF (@Search IS NULL)
						   	   	   PRINT '    - ' + @Item2 + CASE WHEN @ItemDesc2<>'' THEN ' — ' + @ItemDesc2 ELSE '' END;
						   	   ELSE
						   	   	   BEGIN
						   	   	   	   DECLARE @Item2Lower NVARCHAR(512) = LOWER(@Item2);
						   	   	   	   DECLARE @Desc2Lower NVARCHAR(4000) = LOWER(@ItemDesc2);
						   	   	   	   IF PATINDEX(@SearchPattern, @Item2Lower) > 0 OR PATINDEX(@SearchPattern, @Desc2Lower) > 0
						   	   	   	   	   PRINT '    - ' + @Item2 + CASE WHEN @ItemDesc2<>'' THEN ' — ' + @ItemDesc2 ELSE '' END;
						   	   	   END
							   END
						   END
						   SET @p = CHARINDEX('''i ', @PkgSrc2, @q + 1);
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
			PRINT 'An error occurred during package listing.';
			IF @res IS NOT NULL EXEC SP_OADESTROY @res;
			THROW;
		END CATCH
    END
    ELSE IF (@Command LIKE 'list-objects%' OR @Command LIKE 'lo%')
    BEGIN
		PRINT ('')
		PRINT ('Listing all Zync-managed objects...');
		
		-- Show all objects starting with 'Zz'
		SELECT 
			dbo.RPAD(CONCAT('[', SCHEMA_NAME(schema_id), '].[', name, ']'), 70, ' ') as ObjectName,
			CASE type
				WHEN 'P' THEN 'PROCEDURE'
				WHEN 'FN' THEN 'FUNCTION'
				WHEN 'TF' THEN 'FUNCTION'
				WHEN 'IF' THEN 'FUNCTION'
				WHEN 'V' THEN 'VIEW'
			END as ObjectType
		FROM sys.objects 
		WHERE name LIKE 'Zz%' AND type IN ('P', 'FN', 'TF', 'IF', 'V')
		
		UNION ALL
		
		SELECT 
			dbo.RPAD(CONCAT('[', SCHEMA_NAME(schema_id), '].[', name, ']'), 70, ' ') as ObjectName,
			'TYPE' as ObjectType
		FROM sys.types 
		WHERE name LIKE 'Zz%' AND is_user_defined = 1
		ORDER BY ObjectType, ObjectName
		
		DECLARE @TotalObjectCount INT;
		SELECT @TotalObjectCount = COUNT(*)
		FROM (
			SELECT name FROM sys.objects WHERE name LIKE 'Zz%' AND type IN ('P', 'FN', 'TF', 'IF', 'V')
			UNION ALL
			SELECT name FROM sys.types WHERE name LIKE 'Zz%' AND is_user_defined = 1
		) AllObjects
		
		PRINT '---------------------------------------------------------------------------'
		PRINT 'Total Zync-managed objects found: ' + CAST(@TotalObjectCount AS VARCHAR)
    END
    ELSE IF (@Command LIKE 'clean%')
    BEGIN
		PRINT ('')
		PRINT ('Cleaning all Zync-managed objects...');
		
		-- Find all objects starting with 'Zz'
		DECLARE @ObjectsToClean TABLE (
			ObjectName NVARCHAR(256),
			ObjectType NVARCHAR(50)
		);
		
		INSERT INTO @ObjectsToClean (ObjectName, ObjectType)
		SELECT 
			'[' + SCHEMA_NAME(schema_id) + '].[' + name + ']' as ObjectName,
			CASE type
				WHEN 'P' THEN 'PROCEDURE'
				WHEN 'FN' THEN 'FUNCTION'
				WHEN 'TF' THEN 'FUNCTION'
				WHEN 'IF' THEN 'FUNCTION'
				WHEN 'V' THEN 'VIEW'
			END as ObjectType
		FROM sys.objects 
		WHERE name LIKE 'Zz%' AND type IN ('P', 'FN', 'TF', 'IF', 'V')
		
		UNION ALL
		
		SELECT 
			'[' + SCHEMA_NAME(schema_id) + '].[' + name + ']' as ObjectName,
			'TYPE' as ObjectType
		FROM sys.types 
		WHERE name LIKE 'Zz%' AND is_user_defined = 1;
		
		DECLARE @CleanObjectCount INT;
		SELECT @CleanObjectCount = COUNT(*) FROM @ObjectsToClean;
		
		IF @CleanObjectCount = 0
		BEGIN
			PRINT 'No Zync-managed objects found to clean.';
			RETURN;
		END
		
		PRINT 'Found ' + CAST(@CleanObjectCount AS VARCHAR) + ' object(s) to clean:';
		
		-- Show what will be removed
		DECLARE @CleanObjectName NVARCHAR(256), @CleanObjectType NVARCHAR(50);
		DECLARE clean_cursor CURSOR LOCAL FOR
		SELECT ObjectName, ObjectType FROM @ObjectsToClean;

		OPEN clean_cursor;
		FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT ' -> ' + @CleanObjectType + ' ' + @CleanObjectName;
			FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;
		END

		CLOSE clean_cursor;
		
		PRINT '';
		PRINT 'Proceeding with cleanup...';
		
		-- Remove objects in proper order to handle dependencies
		-- First drop all functions and procedures
		OPEN clean_cursor;
		FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @CleanObjectType IN ('PROCEDURE', 'FUNCTION')
			BEGIN
				DECLARE @CleanDropStatement NVARCHAR(MAX) = 'DROP ' + @CleanObjectType + ' ' + @CleanObjectName;
				
				BEGIN TRY
					EXECUTE SP_EXECUTESQL @CleanDropStatement;
					PRINT '    ✓ Dropped ' + @CleanObjectType + ' ' + @CleanObjectName;
				END TRY
				BEGIN CATCH
					PRINT '    ✗ Error dropping ' + @CleanObjectType + ' ' + @CleanObjectName + ': ' + ERROR_MESSAGE();
				END CATCH
			END
			
			FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;
		END

		CLOSE clean_cursor;
		
		-- Then drop views and types
		OPEN clean_cursor;
		FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @CleanObjectType IN ('VIEW', 'TYPE')
			BEGIN
				SET @CleanDropStatement = 'DROP ' + @CleanObjectType + ' ' + @CleanObjectName;
				
				BEGIN TRY
					EXECUTE SP_EXECUTESQL @CleanDropStatement;
					PRINT '    ✓ Dropped ' + @CleanObjectType + ' ' + @CleanObjectName;
				END TRY
				BEGIN CATCH
					PRINT '    ✗ Error dropping ' + @CleanObjectType + ' ' + @CleanObjectName + ': ' + ERROR_MESSAGE();
				END CATCH
			END
			
			FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;
		END

		CLOSE clean_cursor;
		DEALLOCATE clean_cursor;
		
		-- Also clean tracking tables
		DELETE FROM [dbo].[ZyncObjects];
		DELETE FROM [dbo].[ZyncPackages];
		
		PRINT '';
		PRINT 'Cleanup completed. All Zync-managed objects and tracking data removed.';
    END
    ELSE IF (@Command LIKE 'rm%')
    BEGIN
        SET @PackageName = TRIM(SUBSTRING(@Command, 3, LEN(@Command)));
		PRINT ('')
		PRINT ('Removing package group or file: '''+ @PackageName +'''...');

		-- First, check if it's a package group and remove its members
		IF @PackageName NOT LIKE '%.sql'
		BEGIN
			PRINT ' -> Input ''' + @PackageName + ''' is a package group. Removing all sub-packages...';
			
			DECLARE @GroupPackagesToRemove TABLE (PackageName NVARCHAR(128));
			INSERT INTO @GroupPackagesToRemove (PackageName)
			SELECT PackageName FROM [dbo].[ZyncPackages] WHERE PackageName LIKE @PackageName + '/%' AND Status IN ('INSTALLED', 'UPDATED');

			IF NOT EXISTS (SELECT 1 FROM @GroupPackagesToRemove)
			BEGIN
				PRINT ' -> No installed sub-packages found in group ''' + @PackageName + '''.';
			END
			ELSE
			BEGIN
				DECLARE @SubPackageName NVARCHAR(128);
				DECLARE @SubCommand VARCHAR(256);
				DECLARE group_remove_cursor CURSOR LOCAL FOR
				SELECT PackageName FROM @GroupPackagesToRemove;

				OPEN group_remove_cursor;
				FETCH NEXT FROM group_remove_cursor INTO @SubPackageName;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @SubCommand = 'rm ' + @SubPackageName;
					-- PRINT ' -> Recursively calling remove for sub-package: ' + @SubPackageName;
					EXEC [dbo].[Zync] @Command = @SubCommand;
					FETCH NEXT FROM group_remove_cursor INTO @SubPackageName;
				END

				CLOSE group_remove_cursor;
				DEALLOCATE group_remove_cursor;
				
				PRINT ' -> Successfully removed all sub-packages in group ''' + @PackageName + '''.';
			END
		END

		-- Now, proceed to remove the package itself (whether it's a group package or a single file)
		DECLARE @RemovePackageId UNIQUEIDENTIFIER;
		SELECT @RemovePackageId = PackageId
		FROM [dbo].[ZyncPackages] 
		WHERE PackageName = @PackageName AND Status IN ('INSTALLED', 'UPDATED');

		IF @RemovePackageId IS NULL
		BEGIN
			-- PRINT ' -> Package ''' + @PackageName + ''' is not tracked or already removed. Skipping final removal step.';
			RETURN;
		END

		BEGIN TRY
			-- Get all objects in this package
			DECLARE @ObjectsToRemove TABLE (
				ObjectName NVARCHAR(256),
				ObjectType NVARCHAR(50),
				PreviousDefinition NVARCHAR(MAX)
			);
			
			INSERT INTO @ObjectsToRemove (ObjectName, ObjectType, PreviousDefinition)
			SELECT ObjectName, ObjectType, PreviousDefinition
			FROM [dbo].[ZyncObjects]
			WHERE PackageId = @RemovePackageId;
			
			-- Check if we found any objects to remove
			DECLARE @ObjectCount INT;
			SELECT @ObjectCount = COUNT(*) FROM @ObjectsToRemove;
			
			IF @ObjectCount = 0
			BEGIN
				PRINT ' -> No objects found for package ''' + @PackageName + ''' itself. It might be a meta-package.';
			END
			ELSE
			BEGIN
				PRINT ' -> Found ' + CAST(@ObjectCount AS VARCHAR) + ' object(s) to remove for package ''' + @PackageName + '''.';

				DECLARE @RemoveObjectName NVARCHAR(256);
				DECLARE @RemoveObjectType NVARCHAR(50);
				DECLARE @PreviousDefinition NVARCHAR(MAX);
				DECLARE @DropStatement NVARCHAR(MAX);
				
				-- Remove each object
				DECLARE remove_cursor CURSOR LOCAL FOR
				SELECT ObjectName, ObjectType, PreviousDefinition FROM @ObjectsToRemove;

				OPEN remove_cursor;
				FETCH NEXT FROM remove_cursor INTO @RemoveObjectName, @RemoveObjectType, @PreviousDefinition;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- Check if object actually exists before trying to drop
					DECLARE @ObjectActuallyExists BIT = 0;
					DECLARE @RemoveCleanObjectName NVARCHAR(256) = @RemoveObjectName;
					
					-- Clean the object name
					IF CHARINDEX('DBO.', UPPER(@RemoveCleanObjectName)) = 1 SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 5, LEN(@RemoveCleanObjectName));
					IF CHARINDEX(' ', @RemoveCleanObjectName) > 0 SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 1, CHARINDEX(' ', @RemoveCleanObjectName) - 1);
					IF CHARINDEX('@', @RemoveCleanObjectName) > 0 SET @RemoveCleanObjectName = SUBSTRING(@RemoveCleanObjectName, 1, CHARINDEX('@', @RemoveCleanObjectName) - 1);
					SET @RemoveCleanObjectName = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@RemoveCleanObjectName, '[', ''), ']', ''), CHAR(10), ''), CHAR(13), ''), CHAR(9), '');
					WHILE CHARINDEX('  ', @RemoveCleanObjectName) > 0 SET @RemoveCleanObjectName = REPLACE(@RemoveCleanObjectName, '  ', ' ');
					SET @RemoveCleanObjectName = TRIM(@RemoveCleanObjectName);
					
					DECLARE @ActualObjectName NVARCHAR(256);
					SELECT @ActualObjectName = name FROM sys.objects WHERE UPPER(name) = UPPER(@RemoveCleanObjectName) AND type IN ('P', 'FN', 'TF', 'IF', 'V');
					IF @ActualObjectName IS NOT NULL SET @RemoveCleanObjectName = @ActualObjectName;
					
					IF @RemoveObjectType = 'TYPE' AND TYPE_ID('[dbo].[' + @RemoveCleanObjectName + ']') IS NOT NULL SET @ObjectActuallyExists = 1;
					ELSE IF @RemoveObjectType != 'TYPE' AND OBJECT_ID('[dbo].[' + @RemoveCleanObjectName + ']') IS NOT NULL SET @ObjectActuallyExists = 1;
					
					IF @ObjectActuallyExists = 1
					BEGIN
						DECLARE @RemoveFullObjectName NVARCHAR(256) = '[dbo].[' + @RemoveCleanObjectName + ']';
						SET @DropStatement = 'DROP ' + @RemoveObjectType + ' ' + @RemoveFullObjectName;
						PRINT '  -> Dropping ' + @RemoveObjectType + ' ' + @RemoveFullObjectName + '...';
						
						BEGIN TRY
							EXECUTE SP_EXECUTESQL @DropStatement;
							PRINT '     ✓ Successfully dropped ' + @RemoveObjectType + ' ' + @RemoveFullObjectName;
						END TRY
						BEGIN CATCH
							PRINT '     ✗ Error dropping ' + @RemoveObjectType + ' ' + @RemoveFullObjectName + ': ' + ERROR_MESSAGE();
						END CATCH
						
						IF @PreviousDefinition IS NOT NULL AND LEN(@PreviousDefinition) > 0
						BEGIN
							PRINT '  -> Restoring previous version of ' + @RemoveObjectName + '...';
							BEGIN TRY
								EXECUTE SP_EXECUTESQL @PreviousDefinition;
								PRINT '     ✓ Successfully restored previous version';
							END TRY
							BEGIN CATCH
								PRINT '     ✗ Error restoring previous version: ' + ERROR_MESSAGE();
							END CATCH
						END
					END
					ELSE
					BEGIN
						PRINT '  -> Object ' + @RemoveObjectType + ' ' + @RemoveObjectName + ' does not exist (already removed).';
					END

					FETCH NEXT FROM remove_cursor INTO @RemoveObjectName, @RemoveObjectType, @PreviousDefinition;
				END

				CLOSE remove_cursor;
				DEALLOCATE remove_cursor;
			END

			-- Mark package as removed and delete its objects from tracking
			UPDATE [dbo].[ZyncPackages] SET Status = 'REMOVED', InstallDate = GETDATE() WHERE PackageId = @RemovePackageId;
			DELETE FROM [dbo].[ZyncObjects] WHERE PackageId = @RemovePackageId;

			PRINT ' -> Package ''' + @PackageName + ''' and its objects removed successfully.';
		END TRY
		BEGIN CATCH
			PRINT 'ERROR: An error occurred during final removal of package ''' + @PackageName + '''.';
			THROW;
		END CATCH
    END
    ELSE IF (@Command LIKE 'rb%' OR @Command LIKE 'rollback%')
    BEGIN
		SET @PackageName = TRIM(SUBSTRING(@Command, CASE WHEN @Command LIKE 'rb%' THEN 3 ELSE 9 END, LEN(@Command)));

		PRINT ('');
		PRINT ('Rolling back package: '''+ @PackageName +'''...');

		-- Check if package exists
		DECLARE @RollbackPackageId UNIQUEIDENTIFIER;
		SELECT @RollbackPackageId = PackageId 
		FROM [dbo].[ZyncPackages] 
		WHERE PackageName = @PackageName AND Status IN ('INSTALLED', 'UPDATED');

		IF @RollbackPackageId IS NULL
		BEGIN
			PRINT ' -> Package ''' + @PackageName + ''' is not installed or has no rollback data.';
			RETURN;
		END

		BEGIN TRY
			-- Get all objects in this package with their previous definitions
			DECLARE @ObjectsToRollback TABLE (
				ObjectName NVARCHAR(256),
				ObjectType NVARCHAR(50),
				PreviousDefinition NVARCHAR(MAX)
			);
			
			INSERT INTO @ObjectsToRollback (ObjectName, ObjectType, PreviousDefinition)
			SELECT ObjectName, ObjectType, PreviousDefinition
			FROM [dbo].[ZyncObjects]
			WHERE PackageId = @RollbackPackageId AND PreviousDefinition IS NOT NULL;

			IF NOT EXISTS (SELECT 1 FROM @ObjectsToRollback)
			BEGIN
				PRINT ' -> No rollback data available for package ''' + @PackageName + '''.';
				RETURN;
			END

			DECLARE @RollbackObjectName NVARCHAR(256);
			DECLARE @RollbackObjectType NVARCHAR(50);
			DECLARE @RollbackDefinition NVARCHAR(MAX);
			
			-- Rollback each object
			DECLARE rollback_cursor CURSOR LOCAL FOR
			SELECT ObjectName, ObjectType, PreviousDefinition FROM @ObjectsToRollback;

			OPEN rollback_cursor;
			FETCH NEXT FROM rollback_cursor INTO @RollbackObjectName, @RollbackObjectType, @RollbackDefinition;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @RollbackDefinition IS NOT NULL AND LEN(@RollbackDefinition) > 0
				BEGIN
					PRINT ' -> Rolling back ' + @RollbackObjectType + ' ' + @RollbackObjectName + ' to previous version...';
					EXECUTE SP_EXECUTESQL @RollbackDefinition;
					
					-- Update object record to reflect rollback
					UPDATE [dbo].[ZyncObjects] 
					SET ObjectDefinition = PreviousDefinition,
						PreviousDefinition = NULL,
						ModifyDate = GETDATE()
					WHERE PackageId = @RollbackPackageId AND ObjectName = @RollbackObjectName;
				END
				ELSE
				BEGIN
					DECLARE @RollbackCleanObjectName NVARCHAR(256) = REPLACE(REPLACE(@RollbackObjectName, '[', ''), ']', '');
					DECLARE @RollbackFullObjectName NVARCHAR(256) = '[dbo].[' + @RollbackCleanObjectName + ']';
					PRINT ' -> Dropping ' + @RollbackObjectType + ' ' + @RollbackFullObjectName + ' (no previous version to restore)...';
					DECLARE @RollbackDropStatement NVARCHAR(MAX);
					IF @RollbackObjectType = 'TYPE'
						SET @RollbackDropStatement = 'IF TYPE_ID(''' + @RollbackFullObjectName + ''') IS NOT NULL DROP ' + @RollbackObjectType + ' ' + @RollbackFullObjectName;
					ELSE
						SET @RollbackDropStatement = 'DROP ' + @RollbackObjectType + ' ' + @RollbackFullObjectName;
					
					EXECUTE SP_EXECUTESQL @RollbackDropStatement;
					
					-- Remove object record since there's nothing to restore to
					DELETE FROM [dbo].[ZyncObjects] 
					WHERE PackageId = @RollbackPackageId AND ObjectName = @RollbackObjectName;
				END

				FETCH NEXT FROM rollback_cursor INTO @RollbackObjectName, @RollbackObjectType, @RollbackDefinition;
			END

			CLOSE rollback_cursor;
			DEALLOCATE rollback_cursor;

			-- Update package version (decrement)
			UPDATE [dbo].[ZyncPackages] 
			SET Version = CASE WHEN Version > 1 THEN Version - 1 ELSE 1 END,
				Status = 'INSTALLED',
				InstallDate = GETDATE()
			WHERE PackageId = @RollbackPackageId;

			PRINT ' -> Package ''' + @PackageName + ''' rolled back successfully.';
		END TRY
		BEGIN CATCH
			PRINT 'ERROR: An error occurred during rollback.';
			THROW;
		END CATCH
    END
    ELSE IF (@Command LIKE 'u%')
    BEGIN
		SET @PackageName = TRIM(SUBSTRING(@Command, 2, LEN(@Command)));
		IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('')
		PRINT ('Updating package: '''+ @PackageName +'''...');

		-- Check if package exists
		DECLARE @UpdatePackageId UNIQUEIDENTIFIER;
		SELECT @UpdatePackageId = PackageId FROM [dbo].[ZyncPackages] 
		WHERE PackageName = @PackageName AND Status = 'INSTALLED';

		IF @UpdatePackageId IS NULL
		BEGIN
			PRINT ' -> Package ''' + @PackageName + ''' is not installed. Use ''i'' command to install first.';
			RETURN;
		END

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
				PRINT ' -> Fetched latest version of ''' + @PackageName + ''' successfully.'
				SET @rv = TRIM(@rv);
				
				-- Parse object information
				DECLARE @UpdateObjectType NVARCHAR(128), @UpdateObjectName NVARCHAR(256);
				EXEC [dbo].[ZyncParseObject] @rv, @UpdateObjectType OUTPUT, @UpdateObjectName OUTPUT;
				
				IF @UpdateObjectName IS NOT NULL AND @UpdateObjectType IS NOT NULL
				BEGIN
					-- Check if object exists in database
					DECLARE @ObjectExists BIT = 0;
					IF @UpdateObjectType = 'TYPE' AND TYPE_ID(@UpdateObjectName) IS NOT NULL SET @ObjectExists = 1;
					ELSE IF OBJECT_ID(@UpdateObjectName) IS NOT NULL SET @ObjectExists = 1;
					
					IF @ObjectExists = 1
					BEGIN
						-- Get current definition for backup
						DECLARE @CurrentDefinition NVARCHAR(MAX);
						SELECT @CurrentDefinition = OBJECT_DEFINITION(OBJECT_ID(@UpdateObjectName));
						IF @UpdateObjectType = 'TYPE' SET @CurrentDefinition = 'TYPE_DEFINITION_BACKUP'; -- Types need special handling
						
						-- Update object record with new version
						UPDATE [dbo].[ZyncObjects] 
						SET PreviousDefinition = ObjectDefinition,
							ObjectDefinition = @rv,
							ModifyDate = GETDATE()
						WHERE PackageId = @UpdatePackageId AND ObjectName = @UpdateObjectName;
						
						-- Update package version
						UPDATE [dbo].[ZyncPackages] 
						SET Version = Version + 1,
							Status = 'UPDATED',
							InstallDate = GETDATE()
						WHERE PackageId = @UpdatePackageId;
						
						-- Execute the update
						EXECUTE SP_EXECUTESQL @rv;
						
						-- Get version info for display
						DECLARE @OldVersion INT, @NewVersion INT;
						SELECT @NewVersion = Version FROM [dbo].[ZyncPackages] WHERE PackageId = @UpdatePackageId;
						SET @OldVersion = @NewVersion - 1;
						
						PRINT ' -> Object ''' + @UpdateObjectName + ''' updated successfully from version ' + 
							  CAST(@OldVersion AS VARCHAR) + ' to ' + CAST(@NewVersion AS VARCHAR) + '.';
					END
					ELSE
					BEGIN
						PRINT ' -> Object ''' + @UpdateObjectName + ''' does not exist in database. Use ''i'' command to install first.';
					END
				END
				ELSE
				BEGIN
					PRINT ' -> Could not parse object information from package script.';
				END
			END
			ELSE
			BEGIN
				PRINT 'ERROR: Could not fetch package from URL: ' + @PackageFullURL;
				PRINT 'HTTP Status: ' + CAST(@rr AS VARCHAR(10));
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR: An error occurred during update.';
			IF @res IS NOT NULL EXEC SP_OADESTROY @res;
			THROW;
		END CATCH
    END
    ELSE IF (@Command LIKE 'i%')
    BEGIN
		SET @PackageName = TRIM(SUBSTRING(@Command, 2, LEN(@Command)));
		IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('')
		PRINT ('Installing package: '''+ @PackageName +'''...');

		-- Check if package already exists
		DECLARE @ExistingPackageId UNIQUEIDENTIFIER;
		SELECT @ExistingPackageId = PackageId FROM [dbo].[ZyncPackages] 
		WHERE PackageName = @PackageName AND Status IN ('INSTALLED', 'UPDATED');

		IF @ExistingPackageId IS NOT NULL
		BEGIN
			-- PRINT ' -> Package ''' + @PackageName + ''' is already installed. Use ''u'' command to update.';
			RETURN;
		END

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
				
				-- Create package record
				DECLARE @NewPackageId UNIQUEIDENTIFIER = NEWID();
				
				-- Handle dependencies
				IF(CHARINDEX('/*', @rv)=1 AND CHARINDEX('*/', @rv) > 1)
				BEGIN
					SET @deps = TRIM(SUBSTRING(@rv, 3, CHARINDEX('*/', @rv)-3));
					-- PRINT ' -> Installing dependencies...';
					EXECUTE SP_EXECUTESQL @deps;
				END

				-- Parse and backup existing objects before installation
				DECLARE @SqlScript NVARCHAR(MAX) = @rv;
				DECLARE @ObjectType NVARCHAR(128), @ObjectName NVARCHAR(256);
				DECLARE @ExistingDefinition NVARCHAR(MAX);
				
				-- Extract object information
				EXEC [dbo].[ZyncParseObject] @SqlScript, @ObjectType OUTPUT, @ObjectName OUTPUT;
				
				-- Backup existing object if it exists
				IF @ObjectName IS NOT NULL AND @ObjectType IS NOT NULL
				BEGIN
					SELECT @ExistingDefinition = OBJECT_DEFINITION(OBJECT_ID(@ObjectName));
					
					-- Insert package record
					INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Dependencies, BackupData)
					VALUES (@NewPackageId, @PackageName, @deps, @ExistingDefinition);
					
					-- Insert object record
					INSERT INTO [dbo].[ZyncObjects] (PackageId, ObjectName, ObjectType, ObjectDefinition, PreviousDefinition)
					VALUES (@NewPackageId, @ObjectName, @ObjectType, @rv, @ExistingDefinition);
					
					-- PRINT ' -> Backed up existing object: ' + ISNULL(@ObjectName, 'N/A');
				END
				ELSE
				BEGIN
					-- Insert package record without object backup
					INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Dependencies)
					VALUES (@NewPackageId, @PackageName, @deps);
				END

				-- Execute the installation
				EXECUTE SP_EXECUTESQL @rv;
				PRINT ' -> Package ''' + @PackageName + ''' installed successfully.';
			END
			ELSE
			BEGIN
				PRINT 'ERROR: Could not fetch package from URL: ' + @PackageFullURL;
				PRINT 'HTTP Status: ' + CAST(@rr AS VARCHAR(10));
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR: An error occurred during installation of package ''' + @PackageName + '''.';
			IF @res IS NOT NULL EXEC SP_OADESTROY @res;
			THROW;
		END CATCH
    END
	ELSE
	BEGIN
		PRINT ('Zync - Database Package Manager v3.0');
		PRINT ('================================================');
		PRINT ('');
		PRINT ('Usage: EXEC [dbo].[Zync] ''<command> [package_name]''');
		PRINT ('');
		PRINT ('Commands:');
		PRINT ('  ?                      Displays this help message.');
		PRINT ('');
		PRINT ('  ls                               Lists all packages and their scripts (names only).');
		PRINT ('  ls <package-name>                Lists scripts of a package with descriptions.');
		PRINT ('  ls ?<term>                        Search all packages (case-insensitive; use % or * as wildcard).');
		PRINT ('  ls <package-name> ?<term>         Search inside a package (matches name or description).');
		PRINT ('');
		PRINT ('  i                      Installs all available packages.');
		PRINT ('  i <package-name>       Installs a package (with backup of existing objects).');
		PRINT ('  i <pkg/script.sql>     Installs a specific script from a package.');
		PRINT ('');
		PRINT ('  u                      Updates all installed packages to the latest version.');
		PRINT ('  u <package-name>       Updates an existing package to the latest version.');
		PRINT ('');
		PRINT ('  rm                     Removes all installed packages.');
		PRINT ('  rm <package-name>      Removes a package (restores previous versions).');
		PRINT ('  rm <pkg/script.sql>    Removes a specific script from a package.');
		PRINT ('');
		PRINT ('  rb <package-name>      Rolls back a package to its previous version.');
		PRINT ('  rollback <package-name>  Alias for ''rb''.');
		PRINT ('');
		PRINT ('  clean                  Removes ALL Zync-managed objects (Zz* pattern) and tracking data.');
		PRINT ('  lo                     Lists all Zync-managed objects in the database (Zz* pattern).');
		PRINT ('  list-objects           Alias for ''lo''.');
		PRINT ('');
		PRINT ('Examples:');
		PRINT ('  EXEC [dbo].[Zync] ''ls''                     -- List all packages and contained scripts (no descriptions).');
		PRINT ('  EXEC [dbo].[Zync] ''ls DateTime''            -- List DateTime scripts with descriptions.');
		PRINT ('  EXEC [dbo].[Zync] ''ls ?week''               -- Search across all packages for "week".');
		PRINT ('  EXEC [dbo].[Zync] ''ls DbMon ?agent%status'' -- Search in DbMon for names/descriptions like agent%status.');
		PRINT ('  EXEC [dbo].[Zync] ''i Math''                 -- Install the "Math" package.');
		PRINT ('  EXEC [dbo].[Zync] ''u String''               -- Update the "String" package.');
		PRINT ('  EXEC [dbo].[Zync] ''rb DbMon''               -- Rollback the "DbMon" package.');
		PRINT ('  EXEC [dbo].[Zync] ''rm DateTime''            -- Remove the "DateTime" package.');
		PRINT ('  EXEC [dbo].[Zync] ''clean''                  -- Remove all Zync objects from the database.');
		PRINT ('');
		PRINT ('For more information, visit: https://github.com/mirshahreza/Zync');
	END
	
END
GO
-- Add RPAD function for formatting if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RPAD]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
EXEC('CREATE FUNCTION [dbo].[RPAD] (@string NVARCHAR(MAX), @length INT, @pad CHAR(1))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN LEFT(CONCAT(@string, REPLICATE(@pad, @length)), @length)
END')
END
GO