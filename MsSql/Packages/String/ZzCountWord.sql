-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-18
-- Description:	Calculate count of existing a word in a string
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