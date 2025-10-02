-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Generate backup script for table structure and data
-- Sample:		SELECT [dbo].[ZzCreateBackupScript]('Users', 1);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzCreateBackupScript(
    @table_name NVARCHAR(128),
    @include_data BIT = 1
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX) = '';
    DECLARE @sql NVARCHAR(MAX);
    
    -- Validate table exists
    IF OBJECT_ID(@table_name, 'U') IS NULL
        RETURN 'ERROR: Table ' + @table_name + ' does not exist.';
    
    -- Generate CREATE TABLE script
    SET @result = @result + '-- Backup script for table: ' + @table_name + CHAR(13) + CHAR(10);
    SET @result = @result + '-- Generated on: ' + CONVERT(NVARCHAR(20), GETDATE(), 120) + CHAR(13) + CHAR(10);
    SET @result = @result + CHAR(13) + CHAR(10);
    
    -- Get table structure
    DECLARE @create_script NVARCHAR(MAX) = '';
    SET @create_script = 'CREATE TABLE [' + @table_name + '_backup_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + '] (' + CHAR(13) + CHAR(10);
    
    -- Get columns
    DECLARE @columns NVARCHAR(MAX) = '';
    SELECT @columns = @columns + 
        '    [' + COLUMN_NAME + '] ' + 
        DATA_TYPE + 
        CASE 
            WHEN DATA_TYPE IN ('varchar', 'nvarchar', 'char', 'nchar') 
            THEN '(' + CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX' ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(10)) END + ')'
            WHEN DATA_TYPE IN ('decimal', 'numeric') 
            THEN '(' + CAST(NUMERIC_PRECISION AS NVARCHAR(10)) + ',' + CAST(NUMERIC_SCALE AS NVARCHAR(10)) + ')'
            ELSE ''
        END +
        CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END +
        ',' + CHAR(13) + CHAR(10)
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = @table_name
    ORDER BY ORDINAL_POSITION;
    
    -- Remove last comma
    SET @columns = LEFT(@columns, LEN(@columns) - 3) + CHAR(13) + CHAR(10);
    
    SET @create_script = @create_script + @columns + ');' + CHAR(13) + CHAR(10);
    SET @result = @result + @create_script + CHAR(13) + CHAR(10);
    
    -- Generate INSERT statements if data included
    IF @include_data = 1
    BEGIN
        SET @result = @result + '-- Insert data' + CHAR(13) + CHAR(10);
        SET @result = @result + 'INSERT INTO [' + @table_name + '_backup_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + ']' + CHAR(13) + CHAR(10);
        SET @result = @result + 'SELECT * FROM [' + @table_name + '];' + CHAR(13) + CHAR(10);
    END
    
    RETURN @result;
END
GO