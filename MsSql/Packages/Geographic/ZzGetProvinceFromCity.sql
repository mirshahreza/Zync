-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get province name from Iranian city name
-- Sample:		SELECT [dbo].[ZzGetProvinceFromCity](N'تهران');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetProvinceFromCity(
    @city_name NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @result NVARCHAR(100);
    DECLARE @clean_city NVARCHAR(100);
    
    -- Validate input
    IF @city_name IS NULL OR LEN(RTRIM(LTRIM(@city_name))) = 0
        RETURN NULL;
    
    -- Clean and normalize city name
    SET @clean_city = RTRIM(LTRIM(@city_name));
    
    -- Major Iranian cities and their provinces
    IF @clean_city IN (N'تهران', N'Tehran')
        SET @result = N'تهران';
    ELSE IF @clean_city IN (N'مشهد', N'Mashhad')
        SET @result = N'خراسان رضوی';
    ELSE IF @clean_city IN (N'اصفهان', N'Isfahan')
        SET @result = N'اصفهان';
    ELSE IF @clean_city IN (N'کرج', N'Karaj')
        SET @result = N'البرز';
    ELSE IF @clean_city IN (N'شیراز', N'Shiraz')
        SET @result = N'فارس';
    ELSE IF @clean_city IN (N'تبریز', N'Tabriz')
        SET @result = N'آذربایجان شرقی';
    ELSE IF @clean_city IN (N'قم', N'Qom')
        SET @result = N'قم';
    ELSE IF @clean_city IN (N'اهواز', N'Ahvaz')
        SET @result = N'خوزستان';
    ELSE IF @clean_city IN (N'کرمانشاه', N'Kermanshah')
        SET @result = N'کرمانشاه';
    ELSE IF @clean_city IN (N'ارومیه', N'Urmia')
        SET @result = N'آذربایجان غربی';
    ELSE IF @clean_city IN (N'رشت', N'Rasht')
        SET @result = N'گیلان';
    ELSE IF @clean_city IN (N'زاهدان', N'Zahedan')
        SET @result = N'سیستان و بلوچستان';
    ELSE IF @clean_city IN (N'همدان', N'Hamedan')
        SET @result = N'همدان';
    ELSE IF @clean_city IN (N'یزد', N'Yazd')
        SET @result = N'یزد';
    ELSE IF @clean_city IN (N'کرمان', N'Kerman')
        SET @result = N'کرمان';
    ELSE IF @clean_city IN (N'ساری', N'Sari')
        SET @result = N'مازندران';
    ELSE IF @clean_city IN (N'قزوین', N'Qazvin')
        SET @result = N'قزوین';
    ELSE IF @clean_city IN (N'اراک', N'Arak')
        SET @result = N'مرکزی';
    ELSE IF @clean_city IN (N'بندرعباس', N'Bandar Abbas')
        SET @result = N'هرمزگان';
    ELSE IF @clean_city IN (N'زنجان', N'Zanjan')
        SET @result = N'زنجان';
    ELSE IF @clean_city IN (N'سنندج', N'Sanandaj')
        SET @result = N'کردستان';
    ELSE IF @clean_city IN (N'گرگان', N'Gorgan')
        SET @result = N'گلستان';
    ELSE IF @clean_city IN (N'بوشهر', N'Bushehr')
        SET @result = N'بوشهر';
    ELSE IF @clean_city IN (N'خرم‌آباد', N'Khorramabad')
        SET @result = N'لرستان';
    ELSE IF @clean_city IN (N'بیرجند', N'Birjand')
        SET @result = N'خراسان جنوبی';
    ELSE IF @clean_city IN (N'بجنورد', N'Bojnurd')
        SET @result = N'خراسان شمالی';
    ELSE IF @clean_city IN (N'اردبیل', N'Ardabil')
        SET @result = N'اردبیل';
    ELSE IF @clean_city IN (N'یاسوج', N'Yasuj')
        SET @result = N'کهگیلویه و بویراحمد';
    ELSE IF @clean_city IN (N'ایلام', N'Ilam')
        SET @result = N'ایلام';
    ELSE IF @clean_city IN (N'شهرکرد', N'Shahrekord')
        SET @result = N'چهارمحال و بختیاری';
    ELSE IF @clean_city IN (N'خوی', N'Khoy')
        SET @result = N'آذربایجان غربی';
    ELSE IF @clean_city IN (N'مراغه', N'Maragheh')
        SET @result = N'آذربایجان شرقی';
    ELSE IF @clean_city IN (N'آبادان', N'Abadan')
        SET @result = N'خوزستان';
    ELSE IF @clean_city IN (N'دزفول', N'Dezful')
        SET @result = N'خوزستان';
    ELSE IF @clean_city IN (N'کاشان', N'Kashan')
        SET @result = N'اصفهان';
    ELSE IF @clean_city IN (N'نجف‌آباد', N'Najafabad')
        SET @result = N'اصفهان';
    ELSE
        SET @result = NULL; -- Unknown city
    
    RETURN @result;
END
GO