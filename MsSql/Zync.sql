SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2024-07-29
-- Description:	Enhanced Database Package Manager with auto-update and backup/rollback capabilities
-- Version:		3.10
-- =============================================

-- Create helper procedure first to avoid dependency issues
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZyncParseObject]') AND type in (N'P'))
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[ZyncParseObject] AS BEGIN SELECT 1 END') -- Placeholder
END
GO

-- Create backup/rollback infrastructure
-- These tables store information NOT available in database metadata:
-- - Version history and tracking
-- - Package dependencies
-- - Object definitions for rollback capability
-- - Installation timestamps
-- Actual object existence is always verified via sys.objects/sys.columns

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
        CONSTRAINT UQ_ZyncPackages_Name UNIQUE (PackageName),
        INDEX IX_ZyncPackages_Name_Version (PackageName, Version DESC)
    )
    PRINT 'Created ZyncPackages table for tracking installations'
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZyncObjects]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ZyncObjects] (
        [ObjectId] UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
        [PackageId] UNIQUEIDENTIFIER NOT NULL,
        [ObjectName] NVARCHAR(256) NOT NULL,
        [ObjectType] NVARCHAR(50) NOT NULL, -- PROCEDURE, FUNCTION, VIEW, TYPE, TABLE
        [ObjectDefinition] NVARCHAR(MAX) NOT NULL,
        [PreviousDefinition] NVARCHAR(MAX) NULL,
        [CreateDate] DATETIME2 DEFAULT GETDATE(),
        [ModifyDate] DATETIME2 DEFAULT GETDATE(),
        CONSTRAINT FK_ZyncObjects_ZyncPackages FOREIGN KEY (PackageId) 
            REFERENCES [dbo].[ZyncPackages](PackageId) ON DELETE CASCADE,
        CONSTRAINT UQ_ZyncObjects_Package_Name UNIQUE (PackageId, ObjectName),
        INDEX IX_ZyncObjects_Package (PackageId),
        INDEX IX_ZyncObjects_Name (ObjectName)
    )
    PRINT 'Created ZyncObjects table for tracking object changes'
END

GO

-- =============================================
-- Auto-upgrade: Cleanup and apply constraints if needed
-- This ensures existing installations are automatically upgraded
-- =============================================

-- Cleanup duplicate packages (keep most recent)
IF EXISTS (SELECT 1 FROM [dbo].[ZyncPackages] GROUP BY PackageName HAVING COUNT(*) > 1)
BEGIN
    ;WITH RankedPackages AS (
        SELECT PackageId, PackageName, Version, InstallDate,
               ROW_NUMBER() OVER (PARTITION BY PackageName ORDER BY Version DESC, InstallDate DESC) AS RowNum
        FROM [dbo].[ZyncPackages]
    )
    DELETE FROM [dbo].[ZyncPackages]
    WHERE PackageId IN (SELECT PackageId FROM RankedPackages WHERE RowNum > 1);
END

-- Cleanup duplicate objects (keep most recent)
IF EXISTS (SELECT 1 FROM [dbo].[ZyncObjects] GROUP BY PackageId, ObjectName HAVING COUNT(*) > 1)
BEGIN
    ;WITH RankedObjects AS (
        SELECT ObjectId, PackageId, ObjectName, ModifyDate,
               ROW_NUMBER() OVER (PARTITION BY PackageId, ObjectName ORDER BY ModifyDate DESC) AS RowNum
        FROM [dbo].[ZyncObjects]
    )
    DELETE FROM [dbo].[ZyncObjects]
    WHERE ObjectId IN (SELECT ObjectId FROM RankedObjects WHERE RowNum > 1);
END

-- Add UNIQUE constraint on PackageName if not exists
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.ZyncPackages') 
    AND name = 'UQ_ZyncPackages_Name'
)
BEGIN
    ALTER TABLE [dbo].[ZyncPackages] 
    ADD CONSTRAINT UQ_ZyncPackages_Name UNIQUE (PackageName);
END

-- Add UNIQUE constraint on (PackageId, ObjectName) if not exists
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE object_id = OBJECT_ID('dbo.ZyncObjects') 
    AND name = 'UQ_ZyncObjects_Package_Name'
)
BEGIN
    ALTER TABLE [dbo].[ZyncObjects] 
    ADD CONSTRAINT UQ_ZyncObjects_Package_Name UNIQUE (PackageId, ObjectName);
END

-- Update foreign key to include ON DELETE CASCADE if needed
DECLARE @ExistingFK NVARCHAR(256);
SELECT @ExistingFK = fk.name
FROM sys.foreign_keys fk
WHERE fk.parent_object_id = OBJECT_ID('dbo.ZyncObjects')
  AND fk.referenced_object_id = OBJECT_ID('dbo.ZyncPackages')
  AND fk.delete_referential_action <> 1;  -- Not CASCADE

IF @ExistingFK IS NOT NULL
BEGIN
    DECLARE @DropSQL NVARCHAR(MAX) = 'ALTER TABLE [dbo].[ZyncObjects] DROP CONSTRAINT ' + QUOTENAME(@ExistingFK);
    EXEC sp_executesql @DropSQL;
    
    ALTER TABLE [dbo].[ZyncObjects]
    ADD CONSTRAINT FK_ZyncObjects_ZyncPackages 
    FOREIGN KEY (PackageId) REFERENCES [dbo].[ZyncPackages](PackageId) 
    ON DELETE CASCADE;
END

GO

-- Helper procedure to check if an object actually exists in database
CREATE OR ALTER PROCEDURE [dbo].[ZyncObjectExists]
    @ObjectName NVARCHAR(256),
    @ObjectType NVARCHAR(128),
    @Exists BIT OUTPUT
AS
BEGIN
    SET @Exists = 0;
    
    IF @ObjectType = 'TABLE' AND OBJECT_ID(@ObjectName, 'U') IS NOT NULL
        SET @Exists = 1;
    ELSE IF @ObjectType = 'VIEW' AND OBJECT_ID(@ObjectName, 'V') IS NOT NULL
        SET @Exists = 1;
    ELSE IF @ObjectType = 'PROCEDURE' AND OBJECT_ID(@ObjectName, 'P') IS NOT NULL
        SET @Exists = 1;
    ELSE IF @ObjectType = 'FUNCTION' AND (
        OBJECT_ID(@ObjectName, 'FN') IS NOT NULL OR 
        OBJECT_ID(@ObjectName, 'IF') IS NOT NULL OR 
        OBJECT_ID(@ObjectName, 'TF') IS NOT NULL
    )
        SET @Exists = 1;
    ELSE IF @ObjectType = 'TYPE' AND TYPE_ID(@ObjectName) IS NOT NULL
        SET @Exists = 1;
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
	ELSE IF CHARINDEX('CREATE TABLE', @CleanScript) > 0
	BEGIN
		SET @ObjectType = 'TABLE';
		SET @start = CHARINDEX('CREATE TABLE', @CleanScript) + LEN('CREATE TABLE');
	END

    IF @ObjectType IS NOT NULL AND @start > 0
    BEGIN
        SET @CleanScript = LTRIM(SUBSTRING(@CleanScript, @start, 512));
        
        -- For procedures/functions, stop at newline, space, or @ (parameter)
        -- For tables, stop at opening parenthesis
        IF @ObjectType IN ('PROCEDURE', 'FUNCTION')
        BEGIN
            SET @end = CHARINDEX(CHAR(10), @CleanScript);
            DECLARE @SpacePos INT = CHARINDEX(' ', @CleanScript);
            DECLARE @AtPos INT = CHARINDEX('@', @CleanScript);
            
            IF @SpacePos > 0 AND (@SpacePos < @end OR @end = 0) SET @end = @SpacePos;
            IF @AtPos > 0 AND (@AtPos < @end OR @end = 0) SET @end = @AtPos;
        END
        ELSE
        BEGIN
            SET @end = CHARINDEX('(', @CleanScript);
            IF @end = 0 OR @end IS NULL SET @end = CHARINDEX(' AS', @CleanScript);
            IF @end = 0 OR @end IS NULL SET @end = CHARINDEX(' ', @CleanScript);
        END
        
        IF @end > 0
            SET @ObjectName = TRIM(SUBSTRING(@CleanScript, 1, @end - 1));
    END
END
GO

-- Helper procedure to smart update tables (add missing columns without data loss)
CREATE OR ALTER PROCEDURE [dbo].[ZyncSmartTableUpdate]
    @TableName NVARCHAR(256),
    @CreateTableScript NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ColumnsAdded INT = 0;
    
    -- Check if table exists
    IF OBJECT_ID(@TableName, 'U') IS NULL
    BEGIN
        PRINT '       Table doesn''t exist, will be created.';
        RETURN; -- Let the original CREATE TABLE script handle it
    END
    
    -- Find CREATE TABLE statement (may be inside IF block)
    DECLARE @CreatePos INT = CHARINDEX('CREATE TABLE', UPPER(@CreateTableScript));
    IF @CreatePos = 0
    BEGIN
        PRINT '       Could not find CREATE TABLE statement.';
        RETURN;
    END
    
    -- Extract column definitions: find first '(' after CREATE TABLE
    DECLARE @StartPos INT = CHARINDEX('(', @CreateTableScript, @CreatePos);
    DECLARE @EndPos INT;
    DECLARE @ParenCount INT = 1;
    DECLARE @i INT = @StartPos + 1;
    
    -- Find matching closing parenthesis
    WHILE @i <= LEN(@CreateTableScript) AND @ParenCount > 0
    BEGIN
        IF SUBSTRING(@CreateTableScript, @i, 1) = '(' SET @ParenCount = @ParenCount + 1;
        IF SUBSTRING(@CreateTableScript, @i, 1) = ')' SET @ParenCount = @ParenCount - 1;
        SET @i = @i + 1;
    END
    SET @EndPos = @i - 1;
    
    IF @StartPos = 0 OR @EndPos <= @StartPos
    BEGIN
        PRINT '       Could not parse table structure.';
        RETURN;
    END
    
    -- Extract column definitions
    DECLARE @ColumnDefs NVARCHAR(MAX) = SUBSTRING(@CreateTableScript, @StartPos + 1, @EndPos - @StartPos - 1);
    
    -- Parse each line to extract column definitions
    DECLARE @Lines TABLE (LineText NVARCHAR(MAX));
    DECLARE @Line NVARCHAR(MAX), @LinePos INT = 1, @NextPos INT, @EndPos2 INT;
    
    -- Split by commas at the root level (not inside parentheses)
    SET @ParenCount = 0;
    DECLARE @SegmentStart INT = 1;
    SET @i = 1;
    WHILE @i <= LEN(@ColumnDefs)
    BEGIN
        DECLARE @Char CHAR(1) = SUBSTRING(@ColumnDefs, @i, 1);
        IF @Char = '(' SET @ParenCount = @ParenCount + 1;
        ELSE IF @Char = ')' SET @ParenCount = @ParenCount - 1;
        ELSE IF @Char = ',' AND @ParenCount = 0
        BEGIN
            SET @Line = TRIM(SUBSTRING(@ColumnDefs, @SegmentStart, @i - @SegmentStart));
            IF LEN(@Line) > 0 INSERT INTO @Lines(LineText) VALUES(@Line);
            SET @SegmentStart = @i + 1;
        END
        SET @i = @i + 1;
    END
    -- Add last segment
    SET @Line = TRIM(SUBSTRING(@ColumnDefs, @SegmentStart, LEN(@ColumnDefs) - @SegmentStart + 1));
    IF LEN(@Line) > 0 INSERT INTO @Lines(LineText) VALUES(@Line);
    
    -- Process each definition
    DECLARE @CurrentLine NVARCHAR(MAX), @ColumnName NVARCHAR(256), @ColumnDef NVARCHAR(MAX);
    DECLARE line_cursor CURSOR LOCAL FOR SELECT LineText FROM @Lines;
    OPEN line_cursor; FETCH NEXT FROM line_cursor INTO @CurrentLine;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Skip constraints
        IF UPPER(@CurrentLine) NOT LIKE 'CONSTRAINT%' 
           AND UPPER(@CurrentLine) NOT LIKE 'PRIMARY KEY%'
           AND UPPER(@CurrentLine) NOT LIKE 'UNIQUE%'
           AND UPPER(@CurrentLine) NOT LIKE 'FOREIGN KEY%'
           AND UPPER(@CurrentLine) NOT LIKE 'CHECK%'
           AND UPPER(@CurrentLine) NOT LIKE 'INDEX%'
           AND @CurrentLine LIKE '[[]%'
        BEGIN
            -- Extract column name
            DECLARE @BracketStart INT = CHARINDEX('[', @CurrentLine);
            DECLARE @BracketEnd INT = CHARINDEX(']', @CurrentLine, @BracketStart);
            
            IF @BracketStart > 0 AND @BracketEnd > @BracketStart
            BEGIN
                SET @ColumnName = SUBSTRING(@CurrentLine, @BracketStart + 1, @BracketEnd - @BracketStart - 1);
                
                -- Check if column exists
                IF NOT EXISTS (
                    SELECT 1 FROM sys.columns 
                    WHERE object_id = OBJECT_ID(@TableName) 
                    AND name = @ColumnName
                )
                BEGIN
                    -- Add column
                    SET @ColumnDef = @CurrentLine;
                    DECLARE @AlterSQL NVARCHAR(MAX) = 'ALTER TABLE ' + @TableName + ' ADD ' + @ColumnDef;
                    
                    BEGIN TRY
                        EXEC sp_executesql @AlterSQL;
                        PRINT '       Added column: ' + @ColumnName;
                        SET @ColumnsAdded = @ColumnsAdded + 1;
                    END TRY
                    BEGIN CATCH
                        PRINT '       Warning: Could not add column ' + @ColumnName + ': ' + ERROR_MESSAGE();
                    END CATCH
                END
            END
        END
        
        FETCH NEXT FROM line_cursor INTO @CurrentLine;
    END
    
    CLOSE line_cursor; DEALLOCATE line_cursor;
    
    IF @ColumnsAdded > 0
        PRINT '       Total columns added: ' + CAST(@ColumnsAdded AS VARCHAR);
    ELSE
        PRINT '       No new columns to add.';
END
GO

-- Add ZzRPad function for formatting if it doesn't exist (must precede procedure that uses it)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZzRPad]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
EXEC('CREATE FUNCTION [dbo].[ZzRPad] (@string NVARCHAR(MAX), @length INT, @pad CHAR(1))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN LEFT(CONCAT(@string, REPLICATE(@pad, @length)), @length)
END')
END

GO

CREATE OR ALTER PROCEDURE [dbo].[Zync] 
	@Command VARCHAR(128)='?',@Repo VARCHAR(256)='https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/'
AS
BEGIN
	SET NOCOUNT ON;

	-- =============================================
	-- ZYNC AUTO-UPDATE MECHANISM
	-- =============================================
	DECLARE @ZYNC_VERSION DECIMAL(5,2) = 3.10;
	DECLARE @ZYNC_BASE_URL NVARCHAR(512) = 'https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Zync.sql';
	
	-- Check if auto-update already performed in this session
	IF SESSION_CONTEXT(N'ZyncAutoUpdateChecked') IS NULL
	BEGIN
		BEGIN TRY
			-- Ensure Ole Automation is enabled
			DECLARE @OleEnabled INT;
			SELECT @OleEnabled = CAST(value AS INT) 
			FROM sys.configurations 
			WHERE name = 'Ole Automation Procedures';
			
			IF @OleEnabled = 0
			BEGIN
				PRINT '>>> Enabling Ole Automation Procedures for Zync operations...';
				EXEC sp_configure 'show advanced options', 1;
				RECONFIGURE;
				EXEC sp_configure 'Ole Automation Procedures', 1;
				RECONFIGURE;
				PRINT '>>> Ole Automation Procedures enabled successfully.';
			END
			
			-- Check for Zync updates
			PRINT '>>> Checking for Zync updates...';
			DECLARE @UpdateRes INT, @UpdateStatus INT, @UpdateContent NVARCHAR(MAX);
			DECLARE @UpdateResponse TABLE(responseText NVARCHAR(MAX));
			
			EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @UpdateRes OUT;
			EXEC SP_OAMETHOD @UpdateRes, 'open', NULL, 'GET', @ZYNC_BASE_URL, 'false';
			EXEC SP_OAMETHOD @UpdateRes, 'send';
			EXEC SP_OAGETPROPERTY @UpdateRes, 'status', @UpdateStatus OUT;
			INSERT INTO @UpdateResponse (responseText) EXEC SP_OAGETPROPERTY @UpdateRes, 'responseText';
			EXEC SP_OADESTROY @UpdateRes;
			
			SELECT @UpdateContent = responseText FROM @UpdateResponse;
			
			IF @UpdateStatus = 200 AND @UpdateContent IS NOT NULL
			BEGIN
				-- Extract version from downloaded content
				DECLARE @RemoteVersion DECIMAL(5,2) = NULL;
				DECLARE @VersionPos INT = CHARINDEX('DECLARE @ZYNC_VERSION DECIMAL(5,2) = ', @UpdateContent);
				IF @VersionPos > 0
				BEGIN
					DECLARE @VersionStart INT = @VersionPos + LEN('DECLARE @ZYNC_VERSION DECIMAL(5,2) = ');
					DECLARE @VersionEnd INT = CHARINDEX(';', @UpdateContent, @VersionStart);
					IF @VersionEnd > @VersionStart
					BEGIN
						DECLARE @VersionStr NVARCHAR(20) = SUBSTRING(@UpdateContent, @VersionStart, @VersionEnd - @VersionStart);
						SET @RemoteVersion = TRY_CAST(TRIM(@VersionStr) AS DECIMAL(5,2));
					END
				END
				
				-- Compare versions and update if needed
				IF @RemoteVersion IS NOT NULL AND @RemoteVersion > @ZYNC_VERSION
				BEGIN
					PRINT '>>> New Zync version available: ' + CAST(@RemoteVersion AS VARCHAR(10)) + ' (current: ' + CAST(@ZYNC_VERSION AS VARCHAR(10)) + ')';
					PRINT '>>> Applying Zync update...';
					
					-- Execute the update
					BEGIN TRY
						EXEC sp_executesql @UpdateContent;
						
						-- Record the update in ZyncPackages
						IF NOT EXISTS (SELECT 1 FROM [dbo].[ZyncPackages] WHERE PackageName = 'ZYNC_CORE')
						BEGIN
							INSERT INTO [dbo].[ZyncPackages] (PackageName, Version, Status)
							VALUES ('ZYNC_CORE', CAST(@RemoteVersion * 100 AS INT), 'UPDATED');
						END
						ELSE
						BEGIN
							UPDATE [dbo].[ZyncPackages]
							SET Version = CAST(@RemoteVersion * 100 AS INT),
								InstallDate = GETDATE(),
								Status = 'UPDATED'
							WHERE PackageName = 'ZYNC_CORE';
						END
						
						PRINT '>>> Zync updated successfully to version ' + CAST(@RemoteVersion AS VARCHAR(10)) + '!';
						PRINT '>>> Re-executing command with updated Zync...';
						PRINT '';
						
						-- Re-execute the original command with updated version
						EXEC [dbo].[Zync] @Command, @Repo;
						RETURN; -- Exit current execution
					END TRY
					BEGIN CATCH
						PRINT '>>> Warning: Failed to apply Zync update: ' + ERROR_MESSAGE();
						PRINT '>>> Continuing with current version...';
					END CATCH
				END
				ELSE IF @RemoteVersion IS NOT NULL
				BEGIN
					PRINT '>>> Zync is up to date (version ' + CAST(@ZYNC_VERSION AS VARCHAR(10)) + ').';
				END
				ELSE
				BEGIN
					PRINT '>>> Could not determine remote Zync version. Continuing with current version...';
				END
			END
			ELSE
			BEGIN
				PRINT '>>> Could not check for Zync updates (HTTP ' + CAST(@UpdateStatus AS VARCHAR(10)) + '). Continuing...';
			END
			
			-- Mark that we've checked for updates in this session
			EXEC sp_set_session_context @key = N'ZyncAutoUpdateChecked', @value = 1;
			PRINT '';
		END TRY
		BEGIN CATCH
			PRINT '>>> Auto-update check failed: ' + ERROR_MESSAGE();
			PRINT '>>> Continuing with current Zync version...';
			PRINT '';
			-- Still mark as checked to avoid repeated failures
			EXEC sp_set_session_context @key = N'ZyncAutoUpdateChecked', @value = 1;
		END CATCH
	END
	-- =============================================
	-- END AUTO-UPDATE MECHANISM
	-- =============================================

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
		-- Column widths for table-like printing
		DECLARE @COLW_PKG INT = 44;   -- package column width
		DECLARE @COLW_ITEM INT = 72;  -- item+description column width
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

		PRINT 'Listing package(s): ''' + @PackageName + CASE WHEN @Search IS NOT NULL THEN ''' (filter: ' + @Search + ')' ELSE '''' END + '...';

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
							   IF @Search IS NULL 
							   BEGIN
								   DECLARE @PkgHdr NVARCHAR(MAX) = dbo.ZzRPad('    ' + QUOTENAME(@CurPkg), @COLW_PKG, ' ');
								   PRINT @PkgHdr + ' | ' + 'EXEC dbo.Zync ''i ' + @CurPkg + '''';
							   END
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
										   -- Root ls mode: show only filenames, plus copy-paste install command
											   IF @Search IS NULL
											   BEGIN
												   DECLARE @ItemRow NVARCHAR(MAX) = dbo.ZzRPad('        - ' + @Item, @COLW_ITEM, ' ');
												   PRINT @ItemRow + ' | ' + 'EXEC dbo.Zync ''i ' + @CurPkg + '/' + @Item + '''';
											   END
						   	   	   	   	   ELSE
						   	   	   	   	   	   BEGIN
						   	   	   	   	   	   	   DECLARE @ItemLower NVARCHAR(512) = LOWER(@Item);
						   	   	   	   	   	   	   IF PATINDEX(@SearchPattern, @ItemLower) > 0
						   	   	   	   	   	   	   BEGIN
														   IF @GroupPrinted = 0
						   	   	   	   	   	   	   	   BEGIN
															   DECLARE @PkgHdr2 NVARCHAR(MAX) = dbo.ZzRPad('    ' + QUOTENAME(@CurPkg), @COLW_PKG, ' ');
															   PRINT @PkgHdr2 + ' | ' + 'EXEC dbo.Zync ''i ' + @CurPkg + '''';
						   	   	   	   	   	   	   	   	   SET @GroupPrinted = 1;
						   	   	   	   	   	   	   	   END
														   DECLARE @ItemRow2 NVARCHAR(MAX) = dbo.ZzRPad('        - ' + @Item, @COLW_ITEM, ' ');
														   PRINT @ItemRow2 + ' | ' + 'EXEC dbo.Zync ''i ' + @CurPkg + '/' + @Item + '''';
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

					   -- Show copy-paste command to install the whole package (table-like)
					   DECLARE @PkgHdr3 NVARCHAR(MAX) = dbo.ZzRPad('    ' + QUOTENAME(@PackageName), @COLW_PKG, ' ');
					   PRINT @PkgHdr3 + ' | ' + 'EXEC dbo.Zync ''i ' + @PackageName + '''';
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
							   BEGIN
								   DECLARE @LeftText NVARCHAR(MAX) = '    - ' + @Item2 + CASE WHEN @ItemDesc2<>'' THEN ' — ' + @ItemDesc2 ELSE '' END;
								   DECLARE @Row NVARCHAR(MAX) = dbo.ZzRPad(@LeftText, @COLW_ITEM, ' ');
								   PRINT @Row + ' | ' + 'EXEC dbo.Zync ''i ' + @PackageName + '/' + @Item2 + '''';
							   END
						   	   ELSE
						   	   	   BEGIN
						   	   	   	   DECLARE @Item2Lower NVARCHAR(512) = LOWER(@Item2);
						   	   	   	   DECLARE @Desc2Lower NVARCHAR(4000) = LOWER(@ItemDesc2);
						   	   	   	   IF PATINDEX(@SearchPattern, @Item2Lower) > 0 OR PATINDEX(@SearchPattern, @Desc2Lower) > 0
										   BEGIN
											   DECLARE @LeftText2 NVARCHAR(MAX) = '    - ' + @Item2 + CASE WHEN @ItemDesc2<>'' THEN ' — ' + @ItemDesc2 ELSE '' END;
											   DECLARE @Row2 NVARCHAR(MAX) = dbo.ZzRPad(@LeftText2, @COLW_ITEM, ' ');
											   PRINT @Row2 + ' | ' + 'EXEC dbo.Zync ''i ' + @PackageName + '/' + @Item2 + '''';
										   END
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
			-- Check if error is related to Ole Automation Procedures
			IF ERROR_NUMBER() = 15281 OR ERROR_MESSAGE() LIKE '%Ole Automation Procedures%' OR ERROR_MESSAGE() LIKE '%sp_OACreate%'
			BEGIN
				PRINT '';
				PRINT '========================================';
				PRINT 'CONFIGURATION REQUIRED';
				PRINT '========================================';
				PRINT 'Zync requires ''Ole Automation Procedures'' to fetch packages from remote repositories.';
				PRINT 'This component is disabled by default for security reasons.';
				PRINT '';
				PRINT 'To enable it, execute the following commands as a database administrator:';
				PRINT '';
				PRINT '    -- Enable advanced options';
				PRINT '    EXEC sp_configure ''show advanced options'', 1;';
				PRINT '    RECONFIGURE;';
				PRINT '';
				PRINT '    -- Enable Ole Automation Procedures';
				PRINT '    EXEC sp_configure ''Ole Automation Procedures'', 1;';
				PRINT '    RECONFIGURE;';
				PRINT '';
				PRINT 'After enabling, run your Zync command again.';
				PRINT '';
				PRINT 'Security Note: Only enable this feature if you trust the package sources.';
				PRINT 'For more information, see SQL Server Books Online.';
				PRINT '========================================';
			END
			ELSE
			BEGIN
				PRINT 'An error occurred during package listing.';
				IF @res IS NOT NULL EXEC SP_OADESTROY @res;
				THROW;
			END
		END CATCH

	END
	ELSE IF (@Command LIKE 'list-objects%' OR @Command LIKE 'lo%')
	BEGIN
		PRINT ('')
		PRINT ('Listing all Zync-managed objects...');
		
		-- Show all objects starting with 'Zz'
		SELECT 
			dbo.ZzRPad(CONCAT('[', SCHEMA_NAME(schema_id), '].[', name, ']'), 70, ' ') as ObjectName,
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
			dbo.ZzRPad(CONCAT('[', SCHEMA_NAME(schema_id), '].[', name, ']'), 70, ' ') as ObjectName,
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
		-- First drop all views and procedures (dependents)
		OPEN clean_cursor;
		FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @CleanObjectType IN ('VIEW', 'PROCEDURE')
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
		
		-- Then drop functions and types (dependencies) AFTER views/procedures
		OPEN clean_cursor;
		FETCH NEXT FROM clean_cursor INTO @CleanObjectName, @CleanObjectType;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @CleanObjectType IN ('FUNCTION', 'TYPE')
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
		-- If no package specified, remove ALL installed packages one by one
		IF (@PackageName IS NULL OR @PackageName = '')
		BEGIN
			PRINT 'Removing ALL installed packages...';
			-- Clean up any invalid tracking rows with empty/null names to avoid recursion
			DELETE FROM [dbo].[ZyncPackages]
			WHERE PackageName IS NULL OR LTRIM(RTRIM(PackageName)) = '';
			DECLARE @Processed INT = 0, @Skipped INT = 0;
			DECLARE @AllPkg NVARCHAR(128);
			DECLARE rm_all_cursor CURSOR LOCAL FOR
			    SELECT PackageName FROM [dbo].[ZyncPackages]
			    WHERE Status IN ('INSTALLED','UPDATED')
			      AND LTRIM(RTRIM(ISNULL(PackageName,''))) <> ''
			    ORDER BY PackageName; -- deterministic order
			OPEN rm_all_cursor;
			FETCH NEXT FROM rm_all_cursor INTO @AllPkg;
			WHILE @@FETCH_STATUS = 0
			BEGIN
			    IF @AllPkg IS NOT NULL AND LTRIM(RTRIM(@AllPkg)) <> ''
			    BEGIN
			    	PRINT ' -> Removing package: ' + @AllPkg;
			    	DECLARE @AllCmd VARCHAR(256) = 'rm ' + LTRIM(RTRIM(@AllPkg));
			    	EXEC [dbo].[Zync] @Command = @AllCmd;
			    	SET @Processed = @Processed + 1;
			    END
			    ELSE
			    	BEGIN
			    		PRINT ' -> Skipping invalid (empty) package entry.';
			    		SET @Skipped = @Skipped + 1;
			    	END
			    FETCH NEXT FROM rm_all_cursor INTO @AllPkg;
			END
			CLOSE rm_all_cursor; DEALLOCATE rm_all_cursor;
			PRINT 'All installed packages processed.';
			PRINT ' -> Summary: processed=' + CAST(@Processed AS VARCHAR(10)) + ', skipped=' + CAST(@Skipped AS VARCHAR(10));
			RETURN;
		END

	PRINT 'Removing package group or file: ''' + @PackageName + '''...';

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
					IF @SubPackageName IS NULL OR LTRIM(RTRIM(@SubPackageName)) = ''
					BEGIN
						PRINT ' -> Skipping invalid sub-package entry (empty name).';
						FETCH NEXT FROM group_remove_cursor INTO @SubPackageName;
						CONTINUE;
					END
					SET @SubCommand = 'rm ' + LTRIM(RTRIM(@SubPackageName));
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

				-- Helper routine: drops a single object safely and restores previous definition if any
				-- Two passes: 1) Views & Procedures (dependents)  2) Functions & Types (dependencies)

				-- Pass 1: Views and Procedures
				DECLARE remove_cursor CURSOR LOCAL FOR
					SELECT ObjectName, ObjectType, PreviousDefinition
					FROM @ObjectsToRemove
					WHERE ObjectType IN ('VIEW','PROCEDURE');
				OPEN remove_cursor;
				FETCH NEXT FROM remove_cursor INTO @RemoveObjectName, @RemoveObjectType, @PreviousDefinition;
				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @ObjectActuallyExists BIT = 0;
					DECLARE @RemoveCleanObjectName NVARCHAR(256) = @RemoveObjectName;
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
						PRINT '  -> Object ' + @RemoveObjectType + ' ' + @RemoveObjectName + ' does not exist (already removed).';
					FETCH NEXT FROM remove_cursor INTO @RemoveObjectName, @RemoveObjectType, @PreviousDefinition;
				END
				CLOSE remove_cursor; DEALLOCATE remove_cursor;

				-- Pass 2: Functions and Types
				DECLARE remove_cursor2 CURSOR LOCAL FOR
					SELECT ObjectName, ObjectType, PreviousDefinition
					FROM @ObjectsToRemove
					WHERE ObjectType IN ('FUNCTION','TYPE');
				OPEN remove_cursor2;
				FETCH NEXT FROM remove_cursor2 INTO @RemoveObjectName, @RemoveObjectType, @PreviousDefinition;
				WHILE @@FETCH_STATUS = 0
				BEGIN
					DECLARE @ObjectActuallyExists2 BIT = 0;
					DECLARE @RemoveCleanObjectName2 NVARCHAR(256) = @RemoveObjectName;
					IF CHARINDEX('DBO.', UPPER(@RemoveCleanObjectName2)) = 1 SET @RemoveCleanObjectName2 = SUBSTRING(@RemoveCleanObjectName2, 5, LEN(@RemoveCleanObjectName2));
					IF CHARINDEX(' ', @RemoveCleanObjectName2) > 0 SET @RemoveCleanObjectName2 = SUBSTRING(@RemoveCleanObjectName2, 1, CHARINDEX(' ', @RemoveCleanObjectName2) - 1);
					IF CHARINDEX('@', @RemoveCleanObjectName2) > 0 SET @RemoveCleanObjectName2 = SUBSTRING(@RemoveCleanObjectName2, 1, CHARINDEX('@', @RemoveCleanObjectName2) - 1);
					SET @RemoveCleanObjectName2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@RemoveCleanObjectName2, '[', ''), ']', ''), CHAR(10), ''), CHAR(13), ''), CHAR(9), '');
					WHILE CHARINDEX('  ', @RemoveCleanObjectName2) > 0 SET @RemoveCleanObjectName2 = REPLACE(@RemoveCleanObjectName2, '  ', ' ');
					SET @RemoveCleanObjectName2 = TRIM(@RemoveCleanObjectName2);
					DECLARE @ActualObjectName2 NVARCHAR(256);
					SELECT @ActualObjectName2 = name FROM sys.objects WHERE UPPER(name) = UPPER(@RemoveCleanObjectName2) AND type IN ('P', 'FN', 'TF', 'IF', 'V');
					IF @ActualObjectName2 IS NOT NULL SET @RemoveCleanObjectName2 = @ActualObjectName2;
					IF @RemoveObjectType = 'TYPE' AND TYPE_ID('[dbo].[' + @RemoveCleanObjectName2 + ']') IS NOT NULL SET @ObjectActuallyExists2 = 1;
					ELSE IF @RemoveObjectType != 'TYPE' AND OBJECT_ID('[dbo].[' + @RemoveCleanObjectName2 + ']') IS NOT NULL SET @ObjectActuallyExists2 = 1;
					IF @ObjectActuallyExists2 = 1
					BEGIN
						DECLARE @RemoveFullObjectName2 NVARCHAR(256) = '[dbo].[' + @RemoveCleanObjectName2 + ']';
						SET @DropStatement = 'DROP ' + @RemoveObjectType + ' ' + @RemoveFullObjectName2;
						PRINT '  -> Dropping ' + @RemoveObjectType + ' ' + @RemoveFullObjectName2 + '...';
						BEGIN TRY
							EXECUTE SP_EXECUTESQL @DropStatement;
							PRINT '     ✓ Successfully dropped ' + @RemoveObjectType + ' ' + @RemoveFullObjectName2;
						END TRY
						BEGIN CATCH
							PRINT '     ✗ Error dropping ' + @RemoveObjectType + ' ' + @RemoveFullObjectName2 + ': ' + ERROR_MESSAGE();
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
						PRINT '  -> Object ' + @RemoveObjectType + ' ' + @RemoveObjectName + ' does not exist (already removed).';
					FETCH NEXT FROM remove_cursor2 INTO @RemoveObjectName, @RemoveObjectType, @PreviousDefinition;
				END
				CLOSE remove_cursor2; DEALLOCATE remove_cursor2;
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
		PRINT 'Rolling back package: ''' + @PackageName + '''...';

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

		-- Update ALL installed packages if no name provided (or wildcard keywords)
		IF (@PackageName = '' OR LOWER(@PackageName) IN ('all','*'))
		BEGIN
			PRINT ('');
			PRINT 'Updating ALL installed packages...';
			DECLARE @UpdName NVARCHAR(128);
			DECLARE upd_all_cursor CURSOR LOCAL FOR
				SELECT PackageName FROM [dbo].[ZyncPackages]
				WHERE Status IN ('INSTALLED','UPDATED') AND LTRIM(RTRIM(ISNULL(PackageName,''))) <> ''
				ORDER BY PackageName;
			OPEN upd_all_cursor;
			FETCH NEXT FROM upd_all_cursor INTO @UpdName;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT ' -> Updating: ' + @UpdName;
				DECLARE @UpdCmd VARCHAR(256) = 'u ' + @UpdName;
				EXEC [dbo].[Zync] @Command = @UpdCmd;
				FETCH NEXT FROM upd_all_cursor INTO @UpdName;
			END
			CLOSE upd_all_cursor; DEALLOCATE upd_all_cursor;
			PRINT 'All installed packages processed.';
			RETURN;
		END

		IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
		ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('')
		PRINT 'Updating package: ''' + @PackageName + '''...';

		-- Check if package exists (will be validated later for composite vs single)
		DECLARE @UpdatePackageId UNIQUEIDENTIFIER;
		SELECT @UpdatePackageId = PackageId FROM [dbo].[ZyncPackages] 
		WHERE PackageName = @PackageName AND Status IN ('INSTALLED','UPDATED');

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
				
				-- Check if this is a composite package (contains only EXEC DBO.Zync commands)
				DECLARE @IsComposite BIT = 0;
				DECLARE @CleanContent NVARCHAR(MAX) = REPLACE(REPLACE(REPLACE(@rv, CHAR(13), ''), CHAR(10), ''), CHAR(9), '');
				DECLARE @NonExecContent NVARCHAR(MAX) = @CleanContent;
				
				-- Remove all EXEC DBO.Zync lines and see what's left
				WHILE CHARINDEX('EXEC DBO.Zync', UPPER(@NonExecContent)) > 0
				BEGIN
					DECLARE @ExecPos INT = CHARINDEX('EXEC DBO.Zync', UPPER(@NonExecContent));
					DECLARE @SemiPos INT = CHARINDEX(';', @NonExecContent, @ExecPos);
					IF @SemiPos = 0 SET @SemiPos = LEN(@NonExecContent) + 1;
					SET @NonExecContent = STUFF(@NonExecContent, @ExecPos, @SemiPos - @ExecPos + 1, '');
				END
				
				-- If nothing significant left, it's a composite package
				SET @NonExecContent = REPLACE(REPLACE(REPLACE(TRIM(@NonExecContent), ' ', ''), ';', ''), '/*', '');
				IF LEN(@NonExecContent) < 10 SET @IsComposite = 1;
				
				IF @IsComposite = 1
				BEGIN
					-- This is a composite package, update all sub-packages
					PRINT ' -> Detected composite package. Updating all sub-packages...';
					
					-- If composite package itself is not registered, create it
					IF @UpdatePackageId IS NULL
					BEGIN
						DECLARE @TempPackageId UNIQUEIDENTIFIER = NEWID();
						INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Version, Status, InstallDate)
						VALUES (@TempPackageId, @PackageName, 1, 'INSTALLED', GETDATE());
						SET @UpdatePackageId = @TempPackageId;
						PRINT ' -> Registered composite package in tracking system.';
					END
					
					DECLARE @SubPackages TABLE (SubPackageName NVARCHAR(256));
					DECLARE @SubPkgPos INT = CHARINDEX('''i ', @rv);
					DECLARE @SubPkgEnd INT, @SubPkgName NVARCHAR(256);
					
					-- Extract all sub-package names
					WHILE @SubPkgPos > 0
					BEGIN
						SET @SubPkgEnd = CHARINDEX('''', @rv, @SubPkgPos + 3);
						IF @SubPkgEnd = 0 BREAK;
						SET @SubPkgName = TRIM(SUBSTRING(@rv, @SubPkgPos + 3, @SubPkgEnd - (@SubPkgPos + 3)));
						IF LEN(@SubPkgName) > 0
							INSERT INTO @SubPackages (SubPackageName) VALUES (@SubPkgName);
						SET @SubPkgPos = CHARINDEX('''i ', @rv, @SubPkgEnd + 1);
					END
					
					-- Update or install each sub-package  
					DECLARE @SubPkg NVARCHAR(256), @UpdateCount INT = 0, @InstallCount INT = 0;
					DECLARE sub_cursor CURSOR LOCAL FOR SELECT SubPackageName FROM @SubPackages;
					OPEN sub_cursor; FETCH NEXT FROM sub_cursor INTO @SubPkg;
					WHILE @@FETCH_STATUS = 0
					BEGIN
						-- Check if sub-package object actually exists in database (not just in tracking)
						DECLARE @SubPkgTracked UNIQUEIDENTIFIER;
						SELECT @SubPkgTracked = PackageId FROM [dbo].[ZyncPackages] 
						WHERE PackageName = @SubPkg AND Status IN ('INSTALLED','UPDATED');
						
						-- Determine if we should update or install
						-- If tracked AND object exists -> update
						-- If not tracked OR object doesn't exist -> install
						DECLARE @ShouldInstall BIT = 0;
						
						IF @SubPkgTracked IS NULL
							SET @ShouldInstall = 1;  -- Not tracked, definitely install
						ELSE
						BEGIN
							-- Tracked, but verify object actually exists in DB
							-- Fetch sub-package to check its object type
							DECLARE @SubPkgURL NVARCHAR(4000) = @Repo;
							IF @SubPkg NOT LIKE N'%.sql' 
								SET @SubPkgURL = @SubPkgURL + @SubPkg + '/' + '.sql';
							ELSE 
								SET @SubPkgURL = @SubPkgURL + @SubPkg;
							SET @SubPkgURL = REPLACE(@SubPkgURL, '//.sql', '/.sql');
							
							-- We'll let update command handle the check
							-- If object doesn't exist, update will fail and we'll catch it
							SET @ShouldInstall = 0;
						END
						
						IF @ShouldInstall = 0
						BEGIN
							-- Try to update
							PRINT '    -> Updating sub-package: ' + @SubPkg;
							DECLARE @SubCmdUpdate VARCHAR(256) = 'u ' + @SubPkg;
							
							BEGIN TRY
								EXEC [dbo].[Zync] @Command = @SubCmdUpdate;
								SET @UpdateCount = @UpdateCount + 1;
							END TRY
							BEGIN CATCH
								-- Update failed, probably object doesn't exist, try install
								PRINT '       (Update failed, trying install...)';
								SET @ShouldInstall = 1;
							END CATCH
						END
						
						IF @ShouldInstall = 1
						BEGIN
							-- Install the sub-package
							PRINT '    -> Installing new sub-package: ' + @SubPkg;
							DECLARE @SubCmdInstall VARCHAR(256) = 'i ' + @SubPkg;
							
							BEGIN TRY
								EXEC [dbo].[Zync] @Command = @SubCmdInstall;
								SET @InstallCount = @InstallCount + 1;
							END TRY
							BEGIN CATCH
								PRINT '       Warning: Install failed for ' + @SubPkg + ': ' + ERROR_MESSAGE();
							END CATCH
						END
						
						FETCH NEXT FROM sub_cursor INTO @SubPkg;
					END
					CLOSE sub_cursor; DEALLOCATE sub_cursor;
					
					-- Update composite package version
					UPDATE [dbo].[ZyncPackages] 
					SET Version = Version + 1,
						Status = 'UPDATED',
						InstallDate = GETDATE()
					WHERE PackageId = @UpdatePackageId;
					
					DECLARE @SummaryMsg NVARCHAR(256) = ' -> Composite package ''' + @PackageName + ''' processed successfully';
					IF @UpdateCount > 0 AND @InstallCount > 0
						SET @SummaryMsg = @SummaryMsg + ' (' + CAST(@UpdateCount AS VARCHAR) + ' updated, ' + CAST(@InstallCount AS VARCHAR) + ' installed).';
					ELSE IF @UpdateCount > 0
						SET @SummaryMsg = @SummaryMsg + ' (' + CAST(@UpdateCount AS VARCHAR) + ' sub-packages updated).';
					ELSE IF @InstallCount > 0
						SET @SummaryMsg = @SummaryMsg + ' (' + CAST(@InstallCount AS VARCHAR) + ' sub-packages installed).';
					ELSE
						SET @SummaryMsg = @SummaryMsg + '.';
					PRINT @SummaryMsg;
				END
				ELSE
				BEGIN
					-- This is a single object package, parse object first
					DECLARE @UpdateObjectType NVARCHAR(128), @UpdateObjectName NVARCHAR(256);
					EXEC [dbo].[ZyncParseObject] @rv, @UpdateObjectType OUTPUT, @UpdateObjectName OUTPUT;
					
					IF @UpdateObjectName IS NOT NULL AND @UpdateObjectType IS NOT NULL
					BEGIN
						-- Check if object actually exists in database (this is the source of truth)
						DECLARE @ObjectExists BIT = 0;
						EXEC [dbo].[ZyncObjectExists] @UpdateObjectName, @UpdateObjectType, @ObjectExists OUTPUT;
						
						IF @ObjectExists = 0
						BEGIN
							PRINT ' -> Object ''' + @UpdateObjectName + ''' does not exist in database.';
							PRINT ' -> This may be a new object. Use ''i'' command to install, or let composite package install it.';
							RETURN;
						END
						
						-- Object exists in DB, ensure it's tracked
						IF @UpdatePackageId IS NULL
						BEGIN
							-- Object exists but not tracked, register it first
							PRINT ' -> Object exists in database but not tracked. Registering...';
							DECLARE @RegPackageId UNIQUEIDENTIFIER = NEWID();
							INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Version, Status, InstallDate)
							VALUES (@RegPackageId, @PackageName, 1, 'INSTALLED', GETDATE());
							SET @UpdatePackageId = @RegPackageId;
						END
						
						-- Get current definition for backup
						DECLARE @CurrentDefinition NVARCHAR(MAX);
						SELECT @CurrentDefinition = OBJECT_DEFINITION(OBJECT_ID(@UpdateObjectName));
						IF @UpdateObjectType = 'TYPE' SET @CurrentDefinition = 'TYPE_DEFINITION_BACKUP';
						ELSE IF @UpdateObjectType = 'TABLE' SET @CurrentDefinition = 'TABLE_DEFINITION_BACKUP';
						
						-- Update or create object record
						IF EXISTS (SELECT 1 FROM [dbo].[ZyncObjects] WHERE PackageId = @UpdatePackageId AND ObjectName = @UpdateObjectName)
						BEGIN
							UPDATE [dbo].[ZyncObjects] 
							SET PreviousDefinition = ObjectDefinition,
								ObjectDefinition = @rv,
								ModifyDate = GETDATE()
							WHERE PackageId = @UpdatePackageId AND ObjectName = @UpdateObjectName;
						END
						ELSE
						BEGIN
							INSERT INTO [dbo].[ZyncObjects] (PackageId, ObjectName, ObjectType, ObjectDefinition, PreviousDefinition)
							VALUES (@UpdatePackageId, @UpdateObjectName, @UpdateObjectType, @rv, @CurrentDefinition);
						END
						
						-- Update package version
						UPDATE [dbo].[ZyncPackages] 
						SET Version = Version + 1,
							Status = 'UPDATED',
							InstallDate = GETDATE()
						WHERE PackageId = @UpdatePackageId;
						
						-- Special handling for tables: add missing columns without data loss
						IF @UpdateObjectType = 'TABLE'
						BEGIN
							PRINT ' -> Analyzing table structure for updates...';
							EXEC [dbo].[ZyncSmartTableUpdate] @UpdateObjectName, @rv;
						END
						
						-- Execute the update (for non-tables, or for tables to handle other changes)
						BEGIN TRY
							EXECUTE SP_EXECUTESQL @rv;
						END TRY
						BEGIN CATCH
							-- For tables, IF NOT EXISTS will prevent errors, so this is okay
							IF @UpdateObjectType != 'TABLE'
								THROW;
						END CATCH
						
						-- Get version info for display
						DECLARE @OldVersion INT, @NewVersion INT;
						SELECT @NewVersion = Version FROM [dbo].[ZyncPackages] WHERE PackageId = @UpdatePackageId;
						SET @OldVersion = @NewVersion - 1;
						
						PRINT ' -> Object ''' + @UpdateObjectName + ''' updated successfully from version ' + 
							  CAST(@OldVersion AS VARCHAR) + ' to ' + CAST(@NewVersion AS VARCHAR) + '.';
					END
					ELSE
					BEGIN
						PRINT ' -> Could not parse object information from package script.';
					END
				END
			END
			ELSE
			BEGIN
				PRINT 'ERROR: Could not fetch package from URL: ' + @PackageFullURL;
				PRINT 'HTTP Status: ' + CAST(@rr AS VARCHAR(10));
			END
		END TRY
		BEGIN CATCH
			-- Check if error is related to Ole Automation Procedures
			IF ERROR_NUMBER() = 15281 OR ERROR_MESSAGE() LIKE '%Ole Automation Procedures%' OR ERROR_MESSAGE() LIKE '%sp_OACreate%'
			BEGIN
				PRINT '';
				PRINT '========================================';
				PRINT 'CONFIGURATION REQUIRED';
				PRINT '========================================';
				PRINT 'Zync requires ''Ole Automation Procedures'' to fetch packages from remote repositories.';
				PRINT 'This component is disabled by default for security reasons.';
				PRINT '';
				PRINT 'To enable it, execute the following commands as a database administrator:';
				PRINT '';
				PRINT '    -- Enable advanced options';
				PRINT '    EXEC sp_configure ''show advanced options'', 1;';
				PRINT '    RECONFIGURE;';
				PRINT '';
				PRINT '    -- Enable Ole Automation Procedures';
				PRINT '    EXEC sp_configure ''Ole Automation Procedures'', 1;';
				PRINT '    RECONFIGURE;';
				PRINT '';
				PRINT 'After enabling, run your Zync command again.';
				PRINT '';
				PRINT 'Security Note: Only enable this feature if you trust the package sources.';
				PRINT 'For more information, see SQL Server Books Online.';
				PRINT '========================================';
			END
			ELSE
			BEGIN
				PRINT 'ERROR: An error occurred during update.';
				IF @res IS NOT NULL EXEC SP_OADESTROY @res;
				THROW;
			END
		END CATCH
    END
	ELSE IF (@Command LIKE 'i%')
    BEGIN
		SET @PackageName = TRIM(SUBSTRING(@Command, 2, LEN(@Command)));

		-- Support install-all via empty, 'all' or '*' keyword
		IF (@PackageName = '' OR LOWER(@PackageName) IN ('all','*'))
		BEGIN
			SET @PackageFullURL = @Repo + '.sql';
		END
		ELSE
		BEGIN
			IF(@PackageName NOT LIKE N'%.sql') SET @PackageFullURL = @PackageFullURL + @PackageName + '/' + '.sql'
			ELSE SET @PackageFullURL = @PackageFullURL + @PackageName;
		END
		SET @PackageFullURL = REPLACE(@PackageFullURL,'//.sql','/.sql');

		PRINT ('')
		PRINT 'Installing package: ''' + @PackageName + '''...';

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
					-- Treat the first block comment as a newline-delimited list of dependency scripts
					-- Example:
					-- /*
					--   DbMon/ZzSelectObjectsDetails.sql
					--   DbMon/ZzSelectTablesIndexes.sql
					-- */
					-- Each non-empty line will be installed via: EXEC [dbo].[Zync] 'i <line>'
					SET @deps = TRIM(SUBSTRING(@rv, 3, CHARINDEX('*/', @rv)-3));
					PRINT ' -> Resolving dependencies...';

					DECLARE @pos INT = 1,
							@len INT = LEN(@deps),
							@line NVARCHAR(4000),
							@nl INT,
							@depCmd NVARCHAR(4000);

					WHILE @pos <= @len
					BEGIN
						SET @nl = CHARINDEX(CHAR(10), @deps, @pos);
						IF @nl = 0 SET @nl = @len + 1;

						-- Extract one line and normalize CRLF/whitespace
						SET @line = SUBSTRING(@deps, @pos, @nl - @pos);
						SET @line = TRIM(REPLACE(@line, CHAR(13), ''));

						IF (@line <> '')
						BEGIN
							-- Skip SQL-style line comments inside the block, if any
							IF LEFT(@line, 2) <> '--'
							BEGIN
								SET @depCmd = N'i ' + @line;
								-- Re-entrant call to install dependency; it will no-op if already installed
								EXEC [dbo].[Zync] @depCmd;
							END
						END

						SET @pos = @nl + 1;
					END
				END

				-- Parse object information
				DECLARE @SqlScript NVARCHAR(MAX) = @rv;
				DECLARE @ObjectType NVARCHAR(128), @ObjectName NVARCHAR(256);
				DECLARE @ExistingDefinition NVARCHAR(MAX);
				DECLARE @InstallObjectExists BIT = 0;
				
				-- Extract object information
				EXEC [dbo].[ZyncParseObject] @SqlScript, @ObjectType OUTPUT, @ObjectName OUTPUT;
				
				-- Check if object already exists in database
				IF @ObjectName IS NOT NULL AND @ObjectType IS NOT NULL
				BEGIN
					EXEC [dbo].[ZyncObjectExists] @ObjectName, @ObjectType, @InstallObjectExists OUTPUT;
					
					IF @InstallObjectExists = 1
					BEGIN
						-- Object exists, check if it's tracked
						DECLARE @ExistingTrackingId UNIQUEIDENTIFIER;
						SELECT @ExistingTrackingId = PackageId FROM [dbo].[ZyncPackages] 
						WHERE PackageName = @PackageName AND Status IN ('INSTALLED', 'UPDATED');
						
						IF @ExistingTrackingId IS NOT NULL
						BEGIN
							PRINT ' -> Object ''' + @ObjectName + ''' already exists and is tracked. Use ''u'' to update.';
							RETURN;
						END
						ELSE
						BEGIN
							PRINT ' -> Object ''' + @ObjectName + ''' exists but not tracked. Registering...';
						END
					END
					
					-- Backup existing object definition if it exists
					IF @InstallObjectExists = 1
					BEGIN
						SELECT @ExistingDefinition = OBJECT_DEFINITION(OBJECT_ID(@ObjectName));
						IF @ObjectType = 'TABLE' SET @ExistingDefinition = 'TABLE_DEFINITION_BACKUP';
					END
					
					-- Insert or update package record
					IF NOT EXISTS (SELECT 1 FROM [dbo].[ZyncPackages] WHERE PackageName = @PackageName)
					BEGIN
						INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Dependencies, BackupData)
						VALUES (@NewPackageId, @PackageName, @deps, @ExistingDefinition);
					END
					ELSE
					BEGIN
						UPDATE [dbo].[ZyncPackages] 
						SET Status = 'INSTALLED', 
							InstallDate = GETDATE(),
							Dependencies = @deps,
							BackupData = @ExistingDefinition
						WHERE PackageName = @PackageName;
						
						SELECT @NewPackageId = PackageId FROM [dbo].[ZyncPackages] WHERE PackageName = @PackageName;
					END
					
					-- Insert or update object record
					IF NOT EXISTS (SELECT 1 FROM [dbo].[ZyncObjects] WHERE PackageId = @NewPackageId AND ObjectName = @ObjectName)
					BEGIN
						INSERT INTO [dbo].[ZyncObjects] (PackageId, ObjectName, ObjectType, ObjectDefinition, PreviousDefinition)
						VALUES (@NewPackageId, @ObjectName, @ObjectType, @rv, @ExistingDefinition);
					END
					ELSE
					BEGIN
						UPDATE [dbo].[ZyncObjects]
						SET ObjectDefinition = @rv,
							PreviousDefinition = @ExistingDefinition,
							ModifyDate = GETDATE()
						WHERE PackageId = @NewPackageId AND ObjectName = @ObjectName;
					END
					
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
			-- Check if error is related to Ole Automation Procedures
			IF ERROR_NUMBER() = 15281 OR ERROR_MESSAGE() LIKE '%Ole Automation Procedures%' OR ERROR_MESSAGE() LIKE '%sp_OACreate%'
			BEGIN
				PRINT '';
				PRINT '========================================';
				PRINT 'CONFIGURATION REQUIRED';
				PRINT '========================================';
				PRINT 'Zync requires ''Ole Automation Procedures'' to fetch packages from remote repositories.';
				PRINT 'This component is disabled by default for security reasons.';
				PRINT '';
				PRINT 'To enable it, execute the following commands as a database administrator:';
				PRINT '';
				PRINT '    -- Enable advanced options';
				PRINT '    EXEC sp_configure ''show advanced options'', 1;';
				PRINT '    RECONFIGURE;';
				PRINT '';
				PRINT '    -- Enable Ole Automation Procedures';
				PRINT '    EXEC sp_configure ''Ole Automation Procedures'', 1;';
				PRINT '    RECONFIGURE;';
				PRINT '';
				PRINT 'After enabling, run your Zync command again.';
				PRINT '';
				PRINT 'Security Note: Only enable this feature if you trust the package sources.';
				PRINT 'For more information, see SQL Server Books Online.';
				PRINT '========================================';
			END
			ELSE
			BEGIN
				PRINT 'ERROR: An error occurred during installation of package ''' + @PackageName + '''.';
				IF @res IS NOT NULL EXEC SP_OADESTROY @res;
				THROW;
			END
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
	PRINT ('  ls ?<term>                       Search all packages (case-insensitive; use % or * as wildcard).');
	PRINT ('  ls <package-name> ?<term>        Search inside a package (matches name or description).');
		PRINT ('');
	PRINT ('  i                      Installs all available packages (from Packages/.sql).');
	PRINT ('  i all                  Alias for installing all packages.');
	PRINT ('  i <package-name>       Installs a package (with backup of existing objects).');
	PRINT ('  i <pkg/script.sql>     Installs a specific script from a package.');
		PRINT ('');
	PRINT ('  u                      Updates all installed packages to the latest version.');
	PRINT ('  u all                  Alias for updating all installed packages.');
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


