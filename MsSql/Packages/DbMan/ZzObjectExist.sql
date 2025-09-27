-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	A scalar function that checks for the existence of any database object (table, view, procedure, etc.) by its name and returns a bit (1 for exists, 0 for not found).
-- Sample:
-- SELECT [dbo].[ZzObjectExist]('MyTable');
-- =============================================

CREATE OR ALTER FUNCTION [DBO].[ZzObjectExist] 
( 
	@ObjectName VARCHAR(128)
) 
RETURNS BIT 
WITH SCHEMABINDING 
AS 
BEGIN 
	
	DECLARE @RES BIT;
	SET @RES =(SELECT CASE 
	WHEN OBJECT_ID(@ObjectName) IS NULL THEN 0
	ELSE 1
	END);
	RETURN @RES;

END 

