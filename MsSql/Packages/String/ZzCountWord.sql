-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-18
-- Description:	Calculates the number of non-overlapping occurrences of a specified word within a given string.
-- Sample:
-- SELECT [dbo].[ZzCountWord]('the quick brown fox jumps over the lazy dog', 'the');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzCountWord] 
( 
    @InputPhrase NVARCHAR(4000), 
    @SearchWord NVARCHAR(64) 
)
RETURNS INT
BEGIN

  RETURN
    (  
        SELECT (DATALENGTH(@InputPhrase)-DATALENGTH(REPLACE(@InputPhrase,@SearchWord,'')))/DATALENGTH(@SearchWord) 
    );

END