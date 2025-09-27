-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Formats a Gregorian date as Persian (fa-IR) yyyy/MM/dd.
-- Sample:		SELECT [dbo].[ZzConvertToShamsi]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzConvertToShamsi](@gregorianDate DATE)
RETURNS NVARCHAR(10)
AS
BEGIN
    RETURN FORMAT(@gregorianDate, 'yyyy/MM/dd', 'fa-IR')
END
GO
