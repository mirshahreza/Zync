-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Formats a DATETIME as yyyy-MM-dd HH:mm (default) or yyyy-MM-dd HH:mm:ss based on @precision.
-- Sample:		SELECT [dbo].[ZzFormatAsDashedDateTime](GETDATE());
-- Sample:		SELECT [dbo].[ZzFormatAsDashedDateTime](GETDATE(), 'second');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzFormatAsDashedDateTime]
(
    @dateTime DATETIME,
    @precision NVARCHAR(10) = N'minute' -- 'minute' or 'second'
)
RETURNS NVARCHAR(19)
AS
BEGIN
    DECLARE @datePart CHAR(10) = CONVERT(CHAR(10), @dateTime, 23); -- yyyy-mm-dd
    IF LOWER(@precision) = N'second'
        RETURN @datePart + N' ' + CONVERT(CHAR(8), @dateTime, 108); -- HH:mm:ss
    RETURN @datePart + N' ' + CONVERT(CHAR(5), @dateTime, 108); -- HH:mm
END

