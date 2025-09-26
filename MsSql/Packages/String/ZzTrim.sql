-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-17
-- Description:	To Trim strings : LTRIM and RTRIM together
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzTrim]
(
	@String NVARCHAR(4000)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
	RETURN LTRIM(RTRIM(@String));
END


