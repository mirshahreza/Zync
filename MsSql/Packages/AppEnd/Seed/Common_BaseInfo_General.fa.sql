-- =============================================
-- نویسنده:       GitHub Copilot
-- تاریخ ایجاد:   2025-09-27
-- توضیحات:       داده‌های پایه عمومی تحت ریشه GEN. شامل: عناوین خطاب (آقا/خانم/دکتر/استاد)،
--                جنسیت، وضعیت تأهل، سطح تحصیلات، گروه خونی، نوع ارتباط، نوع تلفن، نوع آدرس، نوع سند،
--                روزهای هفته، ماه‌ها، بلی/خیر/نامشخص، رنگ‌ها، ارز، زبان، روش پرداخت، روش ارسال،
--                واحد اندازه‌گیری، نوع فایل، شدت، اولویت، وضعیت، نسبت فامیلی.
-- نکات:         الگوی درج/به‌روزرسانی تکرارپذیر (Idempotent) با MERGE بر اساس (ParentId, ShortName).
--               ساختار: GEN -> «دسته» -> «اقلام» | اجرای مجدد امن است و فقط Title را به‌روزرسانی می‌کند.
-- نمونه:        EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_General.fa.sql';
-- =============================================
SET NOCOUNT ON;
DECLARE @now DATETIME = GETDATE();
DECLARE @sys INT = 0;

-- ریشه: عمومی (GEN)
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT CAST(NULL AS INT) AS ParentId, N'GEN' AS ShortName, N'عمومی' AS Title, CAST(5.0 AS FLOAT) AS ViewOrder) AS src
    ON ((tgt.ParentId IS NULL) AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @GEN_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId IS NULL AND ShortName = N'GEN');

-- دسته‌ها زیر GEN
DECLARE @cat TABLE (ShortName NVARCHAR(16), Title NVARCHAR(128), ViewOrder FLOAT);
INSERT INTO @cat (ShortName, Title, ViewOrder)
VALUES
 (N'TITLES', N'عناوین خطاب', 5.10)
,(N'GENDER', N'جنسیت', 5.20)
,(N'MARITAL', N'وضعیت تأهل', 5.30)
,(N'EDU', N'سطح تحصیلات', 5.40)
,(N'BLOOD', N'گروه خونی', 5.50)
,(N'CONTACT', N'نوع ارتباط', 5.60)
,(N'PHONE', N'نوع تلفن', 5.70)
,(N'ADDR', N'نوع آدرس', 5.80)
,(N'DOC', N'نوع سند', 5.90)
,(N'WEEKDAY', N'روز هفته', 6.10)
,(N'MONTH', N'ماه', 6.20)
,(N'YESNO', N'بلی/خیر/نامشخص', 6.30)
,(N'COLOR', N'رنگ', 6.40)
,(N'CUR', N'ارز', 6.50)
,(N'LANG', N'زبان', 6.60)
,(N'PAY', N'روش پرداخت', 6.70)
,(N'DELV', N'روش ارسال', 6.80)
,(N'UOM', N'واحد اندازه‌گیری', 6.90)
,(N'FILE', N'نوع فایل', 7.00)
,(N'SEV', N'شدت', 7.10)
,(N'PRIO', N'اولویت', 7.20)
,(N'STAT', N'وضعیت', 7.30)
,(N'REL', N'نسبت', 7.40);

DECLARE @sn NVARCHAR(16), @ti NVARCHAR(128), @vo FLOAT;
DECLARE cat_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT ShortName, Title, ViewOrder FROM @cat;
OPEN cat_cursor;
FETCH NEXT FROM cat_cursor INTO @sn, @ti, @vo;
WHILE @@FETCH_STATUS = 0
BEGIN
    MERGE dbo.Common_BaseInfo AS tgt
    USING (SELECT @GEN_ID AS ParentId, @sn AS ShortName, @ti AS Title, @vo AS ViewOrder) AS src
        ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
    WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
    WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
    FETCH NEXT FROM cat_cursor INTO @sn, @ti, @vo;
END
CLOSE cat_cursor;
DEALLOCATE cat_cursor;

-- تعیین شناسه دسته‌ها (IDs)
DECLARE @TITLES_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'TITLES');
DECLARE @GENDER_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'GENDER');
DECLARE @MARITAL_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'MARITAL');
DECLARE @EDU_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'EDU');
DECLARE @BLOOD_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'BLOOD');
DECLARE @CONTACT_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'CONTACT');
DECLARE @PHONE_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'PHONE');
DECLARE @ADDR_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'ADDR');
DECLARE @DOC_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'DOC');
DECLARE @WEEKDAY_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'WEEKDAY');
DECLARE @MONTH_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'MONTH');
DECLARE @YESNO_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'YESNO');
DECLARE @COLOR_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'COLOR');
DECLARE @CUR_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'CUR');
DECLARE @LANG_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'LANG');
DECLARE @PAY_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'PAY');
DECLARE @DELV_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'DELV');
DECLARE @UOM_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'UOM');
DECLARE @FILE_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'FILE');
DECLARE @SEV_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'SEV');
DECLARE @PRIO_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'PRIO');
DECLARE @STAT_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'STAT');
DECLARE @REL_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEN_ID AND ShortName = N'REL');

-- عناوین خطاب (TITLES)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@TITLES_ID, N'MR', N'آقا', 5.11)
        ,(@TITLES_ID, N'MRS', N'خانم', 5.12)
        ,(@TITLES_ID, N'MS', N'خانم (Ms)', 5.13)
        ,(@TITLES_ID, N'MISS', N'دوشیزه', 5.14)
        ,(@TITLES_ID, N'DR', N'دکتر', 5.15)
        ,(@TITLES_ID, N'PROF', N'استاد', 5.16)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- جنسیت (GENDER)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@GENDER_ID, N'MALE', N'مذکر', 5.21)
        ,(@GENDER_ID, N'FEMALE', N'مونث', 5.22)
        ,(@GENDER_ID, N'OTHER', N'دیگر', 5.23)
        ,(@GENDER_ID, N'UNKNOWN', N'نامشخص', 5.24)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- وضعیت تأهل (MARITAL)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@MARITAL_ID, N'SINGLE', N'مجرد', 5.31)
        ,(@MARITAL_ID, N'MARRIED', N'متأهل', 5.32)
        ,(@MARITAL_ID, N'DIVORCED', N'مطلقه', 5.33)
        ,(@MARITAL_ID, N'WIDOWED', N'بیوه', 5.34)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- سطح تحصیلات (EDU)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@EDU_ID, N'NONE', N'بدون', 5.41)
        ,(@EDU_ID, N'PRIMARY', N'ابتدایی', 5.42)
        ,(@EDU_ID, N'SECONDARY', N'متوسطه', 5.43)
        ,(@EDU_ID, N'DIPLOMA', N'دیپلم', 5.44)
        ,(@EDU_ID, N'BACHELOR', N'کارشناسی', 5.45)
        ,(@EDU_ID, N'MASTER', N'کارشناسی ارشد', 5.46)
        ,(@EDU_ID, N'DOCTORATE', N'دکتری', 5.47)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- گروه خونی (BLOOD)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@BLOOD_ID, N'A_POS', N'A+', 5.51)
        ,(@BLOOD_ID, N'A_NEG', N'A-', 5.52)
        ,(@BLOOD_ID, N'B_POS', N'B+', 5.53)
        ,(@BLOOD_ID, N'B_NEG', N'B-', 5.54)
        ,(@BLOOD_ID, N'AB_POS', N'AB+', 5.55)
        ,(@BLOOD_ID, N'AB_NEG', N'AB-', 5.56)
        ,(@BLOOD_ID, N'O_POS', N'O+', 5.57)
        ,(@BLOOD_ID, N'O_NEG', N'O-', 5.58)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع ارتباط (CONTACT)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@CONTACT_ID, N'EMAIL', N'ایمیل', 5.61)
        ,(@CONTACT_ID, N'MOBILE', N'موبایل', 5.62)
        ,(@CONTACT_ID, N'PHONE', N'تلفن', 5.63)
        ,(@CONTACT_ID, N'FAX', N'فکس', 5.64)
        ,(@CONTACT_ID, N'WEBSITE', N'وب‌سایت', 5.65)
        ,(@CONTACT_ID, N'SOCIAL', N'شبکه اجتماعی', 5.66)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع تلفن (PHONE)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@PHONE_ID, N'MOBILE', N'موبایل', 5.71)
        ,(@PHONE_ID, N'HOME', N'منزل', 5.72)
        ,(@PHONE_ID, N'WORK', N'محل کار', 5.73)
        ,(@PHONE_ID, N'FAX', N'فکس', 5.74)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع آدرس (ADDR)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@ADDR_ID, N'HOME', N'منزل', 5.81)
        ,(@ADDR_ID, N'WORK', N'محل کار', 5.82)
        ,(@ADDR_ID, N'BILLING', N'صورتحساب', 5.83)
        ,(@ADDR_ID, N'SHIPPING', N'ارسال', 5.84)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع سند (DOC)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@DOC_ID, N'PASSPORT', N'گذرنامه', 5.91)
        ,(@DOC_ID, N'NATIONAL_ID', N'کارت ملی', 5.92)
        ,(@DOC_ID, N'DRIVER_LICENSE', N'گواهینامه رانندگی', 5.93)
        ,(@DOC_ID, N'BIRTH_CERT', N'شناسنامه', 5.94)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- روزهای هفته (WEEKDAY)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@WEEKDAY_ID, N'MON', N'دوشنبه', 6.11)
        ,(@WEEKDAY_ID, N'TUE', N'سه‌شنبه', 6.12)
        ,(@WEEKDAY_ID, N'WED', N'چهارشنبه', 6.13)
        ,(@WEEKDAY_ID, N'THU', N'پنج‌شنبه', 6.14)
        ,(@WEEKDAY_ID, N'FRI', N'جمعه', 6.15)
        ,(@WEEKDAY_ID, N'SAT', N'شنبه', 6.16)
        ,(@WEEKDAY_ID, N'SUN', N'یکشنبه', 6.17)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- ماه‌ها (MONTH)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@MONTH_ID, N'JAN', N'ژانویه', 6.21)
        ,(@MONTH_ID, N'FEB', N'فوریه', 6.22)
        ,(@MONTH_ID, N'MAR', N'مارس', 6.23)
        ,(@MONTH_ID, N'APR', N'آوریل', 6.24)
        ,(@MONTH_ID, N'MAY', N'مه', 6.25)
        ,(@MONTH_ID, N'JUN', N'ژوئن', 6.26)
        ,(@MONTH_ID, N'JUL', N'ژوئیه', 6.27)
        ,(@MONTH_ID, N'AUG', N'اوت', 6.28)
        ,(@MONTH_ID, N'SEP', N'سپتامبر', 6.29)
        ,(@MONTH_ID, N'OCT', N'اکتبر', 6.30)
        ,(@MONTH_ID, N'NOV', N'نوامبر', 6.31)
        ,(@MONTH_ID, N'DEC', N'دسامبر', 6.32)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- بلی/خیر/نامشخص (YES/NO)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@YESNO_ID, N'YES', N'بله', 6.41)
        ,(@YESNO_ID, N'NO', N'خیر', 6.42)
        ,(@YESNO_ID, N'UNKNOWN', N'نامشخص', 6.43)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- رنگ‌ها (COLOR)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@COLOR_ID, N'RED', N'قرمز', 6.51)
        ,(@COLOR_ID, N'GREEN', N'سبز', 6.52)
        ,(@COLOR_ID, N'BLUE', N'آبی', 6.53)
        ,(@COLOR_ID, N'YELLOW', N'زرد', 6.54)
        ,(@COLOR_ID, N'BLACK', N'سیاه', 6.55)
        ,(@COLOR_ID, N'WHITE', N'سفید', 6.56)
        ,(@COLOR_ID, N'ORANGE', N'نارنجی', 6.57)
        ,(@COLOR_ID, N'PURPLE', N'بنفش', 6.58)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- ارز (CUR)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@CUR_ID, N'USD', N'دلار آمریکا', 6.61)
        ,(@CUR_ID, N'EUR', N'یورو', 6.62)
        ,(@CUR_ID, N'JPY', N'ین ژاپن', 6.63)
        ,(@CUR_ID, N'GBP', N'پوند بریتانیا', 6.64)
        ,(@CUR_ID, N'AUD', N'دلار استرالیا', 6.65)
        ,(@CUR_ID, N'CAD', N'دلار کانادا', 6.66)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- زبان (LANG)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@LANG_ID, N'EN', N'انگلیسی', 6.71)
        ,(@LANG_ID, N'FR', N'فرانسوی', 6.72)
        ,(@LANG_ID, N'SP', N'اسپانیایی', 6.73)
        ,(@LANG_ID, N'DE', N'آلمانی', 6.74)
        ,(@LANG_ID, N'ZH', N'چینی', 6.75)
        ,(@LANG_ID, N'JA', N'ژاپنی', 6.76)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- روش پرداخت (PAY)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@PAY_ID, N'CASH', N'نقدی', 6.81)
        ,(@PAY_ID, N'CHECK', N'چک', 6.82)
        ,(@PAY_ID, N'WIRE', N'حواله بانکی', 6.83)
        ,(@PAY_ID, N'CC', N'کارت اعتباری', 6.84)
        ,(@PAY_ID, N'DC', N'کارت بانکی', 6.85)
        ,(@PAY_ID, N'PAYPAL', N'پی‌پال', 6.86)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- روش ارسال (DELV)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@DELV_ID, N'STANDARD', N'ارسال عادی', 6.91)
        ,(@DELV_ID, N'EXPRESS', N'ارسال سریع', 6.92)
        ,(@DELV_ID, N'OVERNIGHT', N'ارسال شبانه', 6.93)
        ,(@DELV_ID, N'PICKUP', N'دریافت از فروشگاه', 6.94)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- واحد اندازه‌گیری (UOM)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@UOM_ID, N'PCS', N'عدد', 7.01)
        ,(@UOM_ID, N'BOX', N'جعبه', 7.02)
        ,(@UOM_ID, N'CTN', N'کارتن', 7.03)
        ,(@UOM_ID, N'PALLET', N'پالت', 7.04)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع فایل (FILE)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@FILE_ID, N'PDF', N'فایل PDF', 7.11)
        ,(@FILE_ID, N'DOC', N'فایل DOC', 7.12)
        ,(@FILE_ID, N'XLS', N'فایل XLS', 7.13)
        ,(@FILE_ID, N'PPT', N'فایل PPT', 7.14)
        ,(@FILE_ID, N'CSV', N'فایل CSV', 7.15)
        ,(@FILE_ID, N'IMG', N'فایل تصویری', 7.16)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- شدت (SEV)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@SEV_ID, N'LOW', N'کم', 7.21)
        ,(@SEV_ID, N'MEDIUM', N'متوسط', 7.22)
        ,(@SEV_ID, N'HIGH', N'زیاد', 7.23)
        ,(@SEV_ID, N'CRITICAL', N'بحرانی', 7.24)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- اولویت (PRIO)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@PRIO_ID, N'LOW', N'کم', 7.31)
        ,(@PRIO_ID, N'MEDIUM', N'متوسط', 7.32)
        ,(@PRIO_ID, N'HIGH', N'زیاد', 7.33)
        ,(@PRIO_ID, N'IMMEDIATE', N'فوری', 7.34)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- وضعیت (STAT)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@STAT_ID, N'OPEN', N'باز', 7.41)
        ,(@STAT_ID, N'IN_PROGRESS', N'در حال انجام', 7.42)
        ,(@STAT_ID, N'COMPLETED', N'انجام‌شده', 7.43)
        ,(@STAT_ID, N'ON_HOLD', N'متوقف', 7.44)
        ,(@STAT_ID, N'CLOSED', N'بسته', 7.45)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نسبت (REL)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@REL_ID, N'PARENT', N'والد', 7.51)
        ,(@REL_ID, N'CHILD', N'فرزند', 7.52)
        ,(@REL_ID, N'SPOUSE', N'همسر', 7.53)
        ,(@REL_ID, N'SIBLING', N'خواهر/برادر', 7.54)
        ,(@REL_ID, N'FRIEND', N'دوست', 7.55)
        ,(@REL_ID, N'OTHER', N'دیگر', 7.56)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- اختیاری: غیرفعال‌سازی دسته‌های حذف‌شده (اقلام زیرمجموعه دست‌نخورده می‌مانند)
UPDATE tgt
SET tgt.IsActive = 0, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
FROM dbo.Common_BaseInfo tgt
WHERE tgt.ParentId = @GEN_ID AND tgt.IsActive = 1
    AND NOT EXISTS (SELECT 1 FROM @cat src WHERE src.ShortName = tgt.ShortName);
