-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	check if exist an object : table,view,procedure,function,fk,pk
-- =============================================

CREATE OR ALTER FUNCTION [DBO].[Zz_ObjectExist] 
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

