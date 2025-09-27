CREATE FUNCTION ZzConvertToShamsi(@gregorianDate DATE)
RETURNS NVARCHAR(10)
AS
BEGIN
    RETURN FORMAT(@gregorianDate, 'yyyy/MM/dd', 'fa-IR')
END
GO
