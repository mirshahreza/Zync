-- =============================================
-- المؤلف:       GitHub Copilot
-- تاريخ الإنشاء: 2025-09-27
-- الوصف:        بيانات عامة تحت الجذر GEN. تشمل: الألقاب (السيد/السيدة/الدكتور/البروفيسور)،
--               الجنس، الحالة الاجتماعية، المستوى التعليمي، فصيلة الدم، نوع وسيلة الاتصال، نوع الهاتف، نوع العنوان، نوع المستند،
--               أيام الأسبوع، الأشهر، نعم/لا/غير معروف، الألوان، العملة، اللغة، طريقة الدفع، أسلوب التوصيل،
--               وحدة القياس، نوع الملف، شدة، أولوية، حالة، علاقة.
-- ملاحظات:      عمليات MERGE متكررة وآمنة حسب (ParentId, ShortName). تعيد التشغيل بدون تكرار.
--               البنية: GEN -> الفئة -> العناصر | إعادة التشغيل تحدّث العنوان فقط.
-- مثال:         EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_General.ar.sql';
-- =============================================
SET NOCOUNT ON;
DECLARE @now DATETIME = GETDATE();
DECLARE @sys INT = 0;

-- الجذر: عام (GEN)
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT CAST(NULL AS INT) AS ParentId, N'GEN' AS ShortName, N'عام' AS Title, CAST(5.0 AS FLOAT) AS ViewOrder) AS src
    ON ((tgt.ParentId IS NULL) AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @GEN_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId IS NULL AND ShortName = N'GEN');

-- الفئات تحت GEN
DECLARE @cat TABLE (ShortName NVARCHAR(16), Title NVARCHAR(128), ViewOrder FLOAT);
INSERT INTO @cat (ShortName, Title, ViewOrder)
VALUES
 (N'TITLES', N'الألقاب', 5.10)
,(N'GENDER', N'الجنس', 5.20)
,(N'MARITAL', N'الحالة الاجتماعية', 5.30)
,(N'EDU', N'المستوى التعليمي', 5.40)
,(N'BLOOD', N'فصيلة الدم', 5.50)
,(N'CONTACT', N'نوع جهة الاتصال', 5.60)
,(N'PHONE', N'نوع الهاتف', 5.70)
,(N'ADDR', N'نوع العنوان', 5.80)
,(N'DOC', N'نوع المستند', 5.90)
,(N'WEEKDAY', N'أيام الأسبوع', 6.10)
,(N'MONTH', N'الأشهر', 6.20)
,(N'YESNO', N'نعم/لا/غير معروف', 6.30)
,(N'COLOR', N'الألوان', 6.40)
,(N'CUR', N'العملة', 6.50)
,(N'LANG', N'اللغة', 6.60)
,(N'PAY', N'طريقة الدفع', 6.70)
,(N'DELV', N'أسلوب التوصيل', 6.80)
,(N'UOM', N'وحدة القياس', 6.90)
,(N'FILE', N'نوع الملف', 7.00)
,(N'SEV', N'الحدة', 7.10)
,(N'PRIO', N'الأولوية', 7.20)
,(N'STAT', N'الحالة', 7.30)
,(N'REL', N'العلاقة', 7.40);

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

-- تعريف معرفات الفئات (IDs)
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

-- الألقاب (TITLES)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@TITLES_ID, N'MR', N'السيد', 5.11)
        ,(@TITLES_ID, N'MRS', N'السيدة', 5.12)
        ,(@TITLES_ID, N'MS', N'الآنسة (Ms)', 5.13)
        ,(@TITLES_ID, N'MISS', N'الآنسة', 5.14)
        ,(@TITLES_ID, N'DR', N'الدكتور', 5.15)
        ,(@TITLES_ID, N'PROF', N'البروفيسور', 5.16)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- الجنس (GENDER)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@GENDER_ID, N'MALE', N'ذكر', 5.21)
        ,(@GENDER_ID, N'FEMALE', N'أنثى', 5.22)
        ,(@GENDER_ID, N'OTHER', N'آخر', 5.23)
        ,(@GENDER_ID, N'UNKNOWN', N'غير معروف', 5.24)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- الحالة الاجتماعية (MARITAL)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@MARITAL_ID, N'SINGLE', N'أعزب', 5.31)
        ,(@MARITAL_ID, N'MARRIED', N'متزوج', 5.32)
        ,(@MARITAL_ID, N'DIVORCED', N'مطلق', 5.33)
        ,(@MARITAL_ID, N'WIDOWED', N'أرمل', 5.34)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- المستوى التعليمي (EDU)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@EDU_ID, N'NONE', N'بدون', 5.41)
        ,(@EDU_ID, N'PRIMARY', N'ابتدائي', 5.42)
        ,(@EDU_ID, N'SECONDARY', N'ثانوي', 5.43)
        ,(@EDU_ID, N'DIPLOMA', N'دبلوم', 5.44)
        ,(@EDU_ID, N'BACHELOR', N'بكالوريوس', 5.45)
        ,(@EDU_ID, N'MASTER', N'ماجستير', 5.46)
        ,(@EDU_ID, N'DOCTORATE', N'دكتوراه', 5.47)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- فصيلة الدم (BLOOD)
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

-- نوع جهة الاتصال (CONTACT)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@CONTACT_ID, N'EMAIL', N'البريد الإلكتروني', 5.61)
        ,(@CONTACT_ID, N'MOBILE', N'الهاتف المحمول', 5.62)
        ,(@CONTACT_ID, N'PHONE', N'الهاتف', 5.63)
        ,(@CONTACT_ID, N'FAX', N'الفاكس', 5.64)
        ,(@CONTACT_ID, N'WEBSITE', N'الموقع الإلكتروني', 5.65)
        ,(@CONTACT_ID, N'SOCIAL', N'شبكة اجتماعية', 5.66)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع الهاتف (PHONE)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@PHONE_ID, N'MOBILE', N'محمول', 5.71)
        ,(@PHONE_ID, N'HOME', N'المنزل', 5.72)
        ,(@PHONE_ID, N'WORK', N'العمل', 5.73)
        ,(@PHONE_ID, N'FAX', N'الفاكس', 5.74)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع العنوان (ADDR)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@ADDR_ID, N'HOME', N'المنزل', 5.81)
        ,(@ADDR_ID, N'WORK', N'العمل', 5.82)
        ,(@ADDR_ID, N'BILLING', N'الفوترة', 5.83)
        ,(@ADDR_ID, N'SHIPPING', N'الشحن', 5.84)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع المستند (DOC)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@DOC_ID, N'PASSPORT', N'جواز سفر', 5.91)
        ,(@DOC_ID, N'NATIONAL_ID', N'الهوية الوطنية', 5.92)
        ,(@DOC_ID, N'DRIVER_LICENSE', N'رخصة القيادة', 5.93)
        ,(@DOC_ID, N'BIRTH_CERT', N'شهادة الميلاد', 5.94)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- أيام الأسبوع (WEEKDAY)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@WEEKDAY_ID, N'MON', N'الاثنين', 6.11)
        ,(@WEEKDAY_ID, N'TUE', N'الثلاثاء', 6.12)
        ,(@WEEKDAY_ID, N'WED', N'الأربعاء', 6.13)
        ,(@WEEKDAY_ID, N'THU', N'الخميس', 6.14)
        ,(@WEEKDAY_ID, N'FRI', N'الجمعة', 6.15)
        ,(@WEEKDAY_ID, N'SAT', N'السبت', 6.16)
        ,(@WEEKDAY_ID, N'SUN', N'الأحد', 6.17)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- الأشهر (MONTH)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@MONTH_ID, N'JAN', N'يناير', 6.21)
        ,(@MONTH_ID, N'FEB', N'فبراير', 6.22)
        ,(@MONTH_ID, N'MAR', N'مارس', 6.23)
        ,(@MONTH_ID, N'APR', N'أبريل', 6.24)
        ,(@MONTH_ID, N'MAY', N'مايو', 6.25)
        ,(@MONTH_ID, N'JUN', N'يونيو', 6.26)
        ,(@MONTH_ID, N'JUL', N'يوليو', 6.27)
        ,(@MONTH_ID, N'AUG', N'أغسطس', 6.28)
        ,(@MONTH_ID, N'SEP', N'سبتمبر', 6.29)
        ,(@MONTH_ID, N'OCT', N'أكتوبر', 6.30)
        ,(@MONTH_ID, N'NOV', N'نوفمبر', 6.31)
        ,(@MONTH_ID, N'DEC', N'ديسمبر', 6.32)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نعم/لا/غير معروف (YES/NO)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@YESNO_ID, N'YES', N'نعم', 6.41)
        ,(@YESNO_ID, N'NO', N'لا', 6.42)
        ,(@YESNO_ID, N'UNKNOWN', N'غير معروف', 6.43)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- الألوان (COLOR)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@COLOR_ID, N'RED', N'أحمر', 6.51)
        ,(@COLOR_ID, N'GREEN', N'أخضر', 6.52)
        ,(@COLOR_ID, N'BLUE', N'أزرق', 6.53)
        ,(@COLOR_ID, N'YELLOW', N'أصفر', 6.54)
        ,(@COLOR_ID, N'BLACK', N'أسود', 6.55)
        ,(@COLOR_ID, N'WHITE', N'أبيض', 6.56)
        ,(@COLOR_ID, N'ORANGE', N'برتقالي', 6.57)
        ,(@COLOR_ID, N'PURPLE', N'أرجواني', 6.58)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- العملة (CUR)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@CUR_ID, N'USD', N'الدولار الأمريكي', 6.61)
        ,(@CUR_ID, N'EUR', N'اليورو', 6.62)
        ,(@CUR_ID, N'JPY', N'الين الياباني', 6.63)
        ,(@CUR_ID, N'GBP', N'الجنيه الإسترليني', 6.64)
        ,(@CUR_ID, N'AUD', N'الدولار الأسترالي', 6.65)
        ,(@CUR_ID, N'CAD', N'الدولار الكندي', 6.66)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- اللغة (LANG)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@LANG_ID, N'EN', N'الإنجليزية', 6.71)
        ,(@LANG_ID, N'FR', N'الفرنسية', 6.72)
        ,(@LANG_ID, N'SP', N'الإسبانية', 6.73)
        ,(@LANG_ID, N'DE', N'الألمانية', 6.74)
        ,(@LANG_ID, N'ZH', N'الصينية', 6.75)
        ,(@LANG_ID, N'JA', N'اليابانية', 6.76)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- طريقة الدفع (PAY)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@PAY_ID, N'CASH', N'نقدًا', 6.81)
        ,(@PAY_ID, N'CHECK', N'شيك', 6.82)
        ,(@PAY_ID, N'WIRE', N'حوالة بنكية', 6.83)
        ,(@PAY_ID, N'CC', N'بطاقة ائتمان', 6.84)
        ,(@PAY_ID, N'DC', N'بطاقة خصم', 6.85)
        ,(@PAY_ID, N'PAYPAL', N'باي بال', 6.86)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- أسلوب التوصيل (DELV)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@DELV_ID, N'STANDARD', N'شحن عادي', 6.91)
        ,(@DELV_ID, N'EXPRESS', N'شحن سريع', 6.92)
        ,(@DELV_ID, N'OVERNIGHT', N'شحن ليلي', 6.93)
        ,(@DELV_ID, N'PICKUP', N'الاستلام من المتجر', 6.94)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- وحدة القياس (UOM)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@UOM_ID, N'PCS', N'قطعة', 7.01)
        ,(@UOM_ID, N'BOX', N'صندوق', 7.02)
        ,(@UOM_ID, N'CTN', N'كرتون', 7.03)
        ,(@UOM_ID, N'PALLET', N'منصة', 7.04)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- نوع الملف (FILE)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@FILE_ID, N'PDF', N'ملف PDF', 7.11)
        ,(@FILE_ID, N'DOC', N'ملف DOC', 7.12)
        ,(@FILE_ID, N'XLS', N'ملف XLS', 7.13)
        ,(@FILE_ID, N'PPT', N'ملف PPT', 7.14)
        ,(@FILE_ID, N'CSV', N'ملف CSV', 7.15)
        ,(@FILE_ID, N'IMG', N'ملف صورة', 7.16)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- الحدّة (SEV)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@SEV_ID, N'LOW', N'منخفض', 7.21)
        ,(@SEV_ID, N'MEDIUM', N'متوسط', 7.22)
        ,(@SEV_ID, N'HIGH', N'مرتفع', 7.23)
        ,(@SEV_ID, N'CRITICAL', N'حرج', 7.24)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- الأولوية (PRIO)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@PRIO_ID, N'LOW', N'منخفضة', 7.31)
        ,(@PRIO_ID, N'MEDIUM', N'متوسطة', 7.32)
        ,(@PRIO_ID, N'HIGH', N'مرتفعة', 7.33)
        ,(@PRIO_ID, N'IMMEDIATE', N'فورية', 7.34)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- الحالة (STAT)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@STAT_ID, N'OPEN', N'مفتوح', 7.41)
        ,(@STAT_ID, N'IN_PROGRESS', N'قيد التنفيذ', 7.42)
        ,(@STAT_ID, N'COMPLETED', N'مكتمل', 7.43)
        ,(@STAT_ID, N'ON_HOLD', N'معلّق', 7.44)
        ,(@STAT_ID, N'CLOSED', N'مغلق', 7.45)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- العلاقة (REL)
MERGE dbo.Common_BaseInfo AS tgt
USING (
        VALUES
            (@REL_ID, N'PARENT', N'والد/والدة', 7.51)
        ,(@REL_ID, N'CHILD', N'ابن/ابنة', 7.52)
        ,(@REL_ID, N'SPOUSE', N'زوج/زوجة', 7.53)
        ,(@REL_ID, N'SIBLING', N'أخ/أخت', 7.54)
        ,(@REL_ID, N'FRIEND', N'صديق', 7.55)
        ,(@REL_ID, N'OTHER', N'آخر', 7.56)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
        VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- اختياري: إلغاء تفعيل الفئات المحذوفة (لا يؤثر على العناصر الفرعية)
UPDATE tgt
SET tgt.IsActive = 0, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
FROM dbo.Common_BaseInfo tgt
WHERE tgt.ParentId = @GEN_ID AND tgt.IsActive = 1
    AND NOT EXISTS (SELECT 1 FROM @cat src WHERE src.ShortName = tgt.ShortName);
