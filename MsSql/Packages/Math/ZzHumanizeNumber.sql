-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-27
-- Description:	Formats a number into a more human-readable string by adding commas as thousands separators.
-- Sample:
-- SELECT [dbo].[ZzHumanizeNumber](1234567.89);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzHumanizeNumber] 
( 
	@InputNumber DECIMAL(38,7)
) 
RETURNS VARCHAR(256) 
WITH SCHEMABINDING 
AS 
BEGIN 

	RETURN FORMAT(@InputNumber, 'N');

END 
