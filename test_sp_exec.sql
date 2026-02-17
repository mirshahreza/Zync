DECLARE @sql NVARCHAR(MAX);
SET @sql = N'DROP TABLE IF EXISTS [dbo].[TestTable]; CREATE TABLE [dbo].[TestTable] (Id INT);';
PRINT 'Executing sp_executesql...';
EXEC sp_executesql @sql;
PRINT 'Success!';
