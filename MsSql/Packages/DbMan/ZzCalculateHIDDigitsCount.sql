-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2026-01-15
-- Description:	Calculates DigitsCount for children of Parent.
-- Sample:
-- EXEC [dbo].[ZzCalculateHIDDigitsCount] 'MyTable', NULL, '.'
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[ZzCalculateHIDDigitsCount]
    @TableName VARCHAR(128) ,
    @ParentId VARCHAR(64),
    @Delimiter VARCHAR(1) = '.'  
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql NVARCHAR(MAX);

    IF(@ParentId IS NULL) SET @ParentId = '';
    
    SET @Sql = N'
    DECLARE @LastId VARCHAR(64);
    SELECT TOP 1 @LastId=Id FROM ' + QUOTENAME(@TableName) + N' WHERE ISNULL(ParentId,'''')=@ParentId ORDER BY Id DESC;
    IF(@LastId IS NULL) SELECT 1;
    ELSE SELECT LEN(REPLACE(@LastId,@ParentId+@Delimiter,''''));
    ';

    EXEC sp_executesql @Sql,
        N'@ParentId VARCHAR(64), @Delimiter CHAR(1)', 
        @ParentId, @Delimiter;

END