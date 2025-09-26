-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-12
-- Description:	To get nth item of a separated string
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[Zz_NthItem]
(
	@String NVARCHAR(4000),@Splitter CHAR(1),@N INT
)
RETURNS NVARCHAR(4000)
AS
BEGIN
	RETURN CAST((SELECT VALUE FROM STRING_SPLIT(@String, @Splitter) ORDER BY (SELECT NULL) OFFSET @N ROWS FETCH NEXT 1 ROW ONLY) AS NVARCHAR(4000));
END


