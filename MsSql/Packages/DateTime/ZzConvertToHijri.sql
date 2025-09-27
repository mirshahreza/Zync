-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Formats a Gregorian date as Hijri (ar-SA) yyyy/MM/dd.
-- Sample:		SELECT [dbo].[ZzConvertToHijri]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzConvertToHijri](@gregorianDate DATE)
RETURNS NVARCHAR(10)
AS
BEGIN
    RETURN FORMAT(@gregorianDate, 'yyyy/MM/dd', 'ar-SA')
END
GO
