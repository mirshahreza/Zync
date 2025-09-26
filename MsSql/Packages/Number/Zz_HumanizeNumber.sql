-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-27
-- Description:	Turns numbers to human readable format
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[Zz_HumanizeNumber] 
( 
	@InputNumber DECIMAL(38,7)
) 
RETURNS VARCHAR(256) 
WITH SCHEMABINDING 
AS 
BEGIN 

	RETURN FORMAT(@InputNumber, 'N');

END 
