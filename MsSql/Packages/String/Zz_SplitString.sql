-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-13
-- Description:	To split a separated string to rows
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[Zz_SplitString] 
(
	@String NVARCHAR(4000),@Splitter CHAR(1)
)
RETURNS TABLE
AS
RETURN
(
	SELECT value FROM STRING_SPLIT(ISNULL(@String,''), ISNULL(@Splitter,','))
)


