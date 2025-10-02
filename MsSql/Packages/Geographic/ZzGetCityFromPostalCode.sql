-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get city name from Iranian postal code
-- Sample:		SELECT dbo.ZzGetCityFromPostalCode('1234567890')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetCityFromPostalCode(
    @PostalCode NVARCHAR(10)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Result NVARCHAR(100) = NULL;
    DECLARE @Code INT;
    
    -- Clean postal code
    SET @PostalCode = REPLACE(@PostalCode, '-', '');
    SET @PostalCode = LTRIM(RTRIM(@PostalCode));
    
    -- Validate postal code format
    IF LEN(@PostalCode) <> 10 OR @PostalCode NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        RETURN NULL;
    
    -- Get first 5 digits for city identification
    SET @Code = CAST(LEFT(@PostalCode, 5) AS INT);
    
    -- Map postal codes to cities (major Iranian cities)
    IF @Code BETWEEN 10000 AND 19999 SET @Result = N'تهران';
    ELSE IF @Code BETWEEN 31000 AND 31999 SET @Result = N'اصفهان';
    ELSE IF @Code BETWEEN 11000 AND 11999 SET @Result = N'مشهد';
    ELSE IF @Code BETWEEN 61000 AND 61999 SET @Result = N'اهواز';
    ELSE IF @Code BETWEEN 71000 AND 71999 SET @Result = N'شیراز';
    ELSE IF @Code BETWEEN 51000 AND 51999 SET @Result = N'تبریز';
    ELSE IF @Code BETWEEN 14000 AND 14999 SET @Result = N'کرج';
    ELSE IF @Code BETWEEN 38000 AND 38999 SET @Result = N'قم';
    ELSE IF @Code BETWEEN 37000 AND 37999 SET @Result = N'کرمانشاه';
    ELSE IF @Code BETWEEN 64000 AND 64999 SET @Result = N'کرمان';
    ELSE IF @Code BETWEEN 41000 AND 41999 SET @Result = N'رشت';
    ELSE IF @Code BETWEEN 47000 AND 47999 SET @Result = N'همدان';
    ELSE IF @Code BETWEEN 45000 AND 45999 SET @Result = N'یزد';
    ELSE IF @Code BETWEEN 16000 AND 16999 SET @Result = N'اردبیل';
    ELSE IF @Code BETWEEN 48000 AND 48999 SET @Result = N'سنندج';
    ELSE IF @Code BETWEEN 56000 AND 56999 SET @Result = N'زاهدان';
    ELSE IF @Code BETWEEN 58000 AND 58999 SET @Result = N'بیرجند';
    ELSE IF @Code BETWEEN 19000 AND 19999 SET @Result = N'ساری';
    ELSE IF @Code BETWEEN 17000 AND 17999 SET @Result = N'گرگان';
    ELSE IF @Code BETWEEN 49000 AND 49999 SET @Result = N'ایلام';
    ELSE IF @Code BETWEEN 66000 AND 66999 SET @Result = N'بوشهر';
    ELSE IF @Code BETWEEN 74000 AND 74999 SET @Result = N'بندرعباس';
    ELSE IF @Code BETWEEN 35000 AND 35999 SET @Result = N'اراک';
    ELSE IF @Code BETWEEN 39000 AND 39999 SET @Result = N'لرستان';
    ELSE IF @Code BETWEEN 44000 AND 44999 SET @Result = N'سمنان';
    ELSE IF @Code BETWEEN 75000 AND 75999 SET @Result = N'کیش';
    ELSE IF @Code BETWEEN 76000 AND 76999 SET @Result = N'قشم';
    -- Additional regional codes
    ELSE IF @Code BETWEEN 12000 AND 12999 SET @Result = N'ورامین';
    ELSE IF @Code BETWEEN 13000 AND 13999 SET @Result = N'پاکدشت';
    ELSE IF @Code BETWEEN 15000 AND 15999 SET @Result = N'قزوین';
    ELSE IF @Code BETWEEN 18000 AND 18999 SET @Result = N'زنجان';
    ELSE IF @Code BETWEEN 32000 AND 32999 SET @Result = N'نجف‌آباد';
    ELSE IF @Code BETWEEN 33000 AND 33999 SET @Result = N'شهرکرد';
    ELSE IF @Code BETWEEN 34000 AND 34999 SET @Result = N'کاشان';
    ELSE IF @Code BETWEEN 36000 AND 36999 SET @Result = N'بروجرد';
    ELSE IF @Code BETWEEN 42000 AND 42999 SET @Result = N'بابل';
    ELSE IF @Code BETWEEN 43000 AND 43999 SET @Result = N'آمل';
    ELSE IF @Code BETWEEN 52000 AND 52999 SET @Result = N'ارومیه';
    ELSE IF @Code BETWEEN 53000 AND 53999 SET @Result = N'مراغه';
    ELSE IF @Code BETWEEN 54000 AND 54999 SET @Result = N'میانه';
    ELSE IF @Code BETWEEN 55000 AND 55999 SET @Result = N'ماکو';
    ELSE IF @Code BETWEEN 57000 AND 57999 SET @Result = N'مشگین‌شهر';
    ELSE IF @Code BETWEEN 59000 AND 59999 SET @Result = N'پارس‌آباد';
    ELSE IF @Code BETWEEN 62000 AND 62999 SET @Result = N'آبادان';
    ELSE IF @Code BETWEEN 63000 AND 63999 SET @Result = N'دزفول';
    ELSE IF @Code BETWEEN 65000 AND 65999 SET @Result = N'راور';
    ELSE IF @Code BETWEEN 67000 AND 67999 SET @Result = N'گناوه';
    ELSE IF @Code BETWEEN 68000 AND 68999 SET @Result = N'دشتستان';
    ELSE IF @Code BETWEEN 69000 AND 69999 SET @Result = N'کنگان';
    ELSE IF @Code BETWEEN 72000 AND 72999 SET @Result = N'مرودشت';
    ELSE IF @Code BETWEEN 73000 AND 73999 SET @Result = N'جهرم';
    ELSE SET @Result = N'نامشخص';
    
    RETURN @Result;
END
GO