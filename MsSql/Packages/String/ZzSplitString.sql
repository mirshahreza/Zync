-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-13
-- Description:	A table-valued function that splits a delimited string into a table of values, using the specified separator. It leverages the built-in STRING_SPLIT function.
-- Sample:
-- SELECT * FROM [dbo].[ZzSplitString]('apple,banana,cherry', ',');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzSplitString] 
(
	@String NVARCHAR(4000),@Splitter CHAR(1)
)
RETURNS TABLE
AS
RETURN
(
	SELECT value FROM STRING_SPLIT(ISNULL(@String,''), ISNULL(@Splitter,','))
)


