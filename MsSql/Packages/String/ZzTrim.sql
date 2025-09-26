-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-17
-- Description:	A simple function that removes leading and trailing whitespace from a given string by applying both LTRIM and RTRIM.
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


