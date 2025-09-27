CREATE FUNCTION ZzConvertToHijri(@gregorianDate DATE)
RETURNS NVARCHAR(10)
AS
BEGIN
    RETURN FORMAT(@gregorianDate, 'yyyy/MM/dd', 'ar-SA')
END
GO
