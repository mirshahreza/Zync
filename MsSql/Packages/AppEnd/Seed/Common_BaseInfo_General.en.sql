-- =============================================
-- Author:        GitHub Copilot
-- Create date:   2025-09-27
-- Description:   General lookup seeds under GEN root. Includes: Titles, Gender, MaritalStatus,
--                EducationLevel, BloodType, ContactType, PhoneType, AddressType, DocumentType,
--                Weekday, Month, YesNo, Colors, Currency, Language, PaymentMethod, DeliveryMethod,
--                UnitOfMeasure, FileType, Severity, Priority, Status, Relationship.
-- Notes:         Idempotent MERGE by (ParentId, ShortName). Safe to re-run.
--                Structure: GEN -> <Category> -> <Items>
--                Tip: Gender also exists as a standalone seed file; this grouped file is recommended.
-- Sample:        EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_General.en.sql';
-- =============================================
SET NOCOUNT ON;
DECLARE @now DATETIME = GETDATE();
DECLARE @sys INT = 0;

-- Root: General (GEN)
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT CAST(NULL AS INT) AS ParentId, N'GEN' AS ShortName, N'General' AS Title, CAST(5.0 AS FLOAT) AS ViewOrder) AS src
    ON ((tgt.ParentId IS NULL) AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @GEN_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId IS NULL AND ShortName = N'GEN');

-- Categories under GEN
DECLARE @cat TABLE (ShortName NVARCHAR(16), Title NVARCHAR(128), ViewOrder FLOAT);
INSERT INTO @cat (ShortName, Title, ViewOrder)
VALUES
 (N'TITLES', N'Titles', 5.10)
,(N'GENDER', N'Gender', 5.20)
,(N'MARITAL', N'Marital Status', 5.30)
,(N'EDU', N'Education Level', 5.40)
,(N'BLOOD', N'Blood Type', 5.50)
,(N'CONTACT', N'Contact Type', 5.60)
,(N'PHONE', N'Phone Type', 5.70)
,(N'ADDR', N'Address Type', 5.80)
,(N'DOC', N'Document Type', 5.90)
,(N'WEEKDAY', N'Weekday', 6.10)
,(N'MONTH', N'Month', 6.20)
,(N'YESNO', N'Yes / No / Unknown', 6.30)
,(N'COLOR', N'Color', 6.40)
,(N'CUR', N'Currency', 6.50)
,(N'LANG', N'Language', 6.60)
,(N'PAY', N'Payment Method', 6.70)
,(N'DELV', N'Delivery Method', 6.80)
,(N'UOM', N'Unit of Measure', 6.90)
,(N'FILE', N'File Type', 7.00)
,(N'SEV', N'Severity', 7.10)
,(N'PRIO', N'Priority', 7.20)
,(N'STAT', N'Status', 7.30)
,(N'REL', N'Relationship', 7.40);

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

-- Resolve Category Ids
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

-- TITLES
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@TITLES_ID, N'MR', N'Mr', 5.11)
    ,(@TITLES_ID, N'MRS', N'Mrs', 5.12)
    ,(@TITLES_ID, N'MS', N'Ms', 5.13)
    ,(@TITLES_ID, N'MISS', N'Miss', 5.14)
    ,(@TITLES_ID, N'DR', N'Dr', 5.15)
    ,(@TITLES_ID, N'PROF', N'Prof.', 5.16)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- GENDER
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@GENDER_ID, N'MALE', N'Male', 5.21)
    ,(@GENDER_ID, N'FEMALE', N'Female', 5.22)
    ,(@GENDER_ID, N'OTHER', N'Other', 5.23)
    ,(@GENDER_ID, N'UNKNOWN', N'Unknown', 5.24)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- MARITAL STATUS
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@MARITAL_ID, N'SINGLE', N'Single', 5.31)
    ,(@MARITAL_ID, N'MARRIED', N'Married', 5.32)
    ,(@MARITAL_ID, N'DIVORCED', N'Divorced', 5.33)
    ,(@MARITAL_ID, N'WIDOWED', N'Widowed', 5.34)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- EDUCATION LEVEL
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@EDU_ID, N'NONE', N'None', 5.41)
    ,(@EDU_ID, N'PRIMARY', N'Primary', 5.42)
    ,(@EDU_ID, N'SECONDARY', N'Secondary', 5.43)
    ,(@EDU_ID, N'DIPLOMA', N'Diploma', 5.44)
    ,(@EDU_ID, N'BACHELOR', N'Bachelor', 5.45)
    ,(@EDU_ID, N'MASTER', N'Master', 5.46)
    ,(@EDU_ID, N'DOCTORATE', N'Doctorate', 5.47)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- BLOOD TYPE
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

-- CONTACT TYPE
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@CONTACT_ID, N'EMAIL', N'Email', 5.61)
    ,(@CONTACT_ID, N'MOBILE', N'Mobile', 5.62)
    ,(@CONTACT_ID, N'PHONE', N'Phone', 5.63)
    ,(@CONTACT_ID, N'FAX', N'Fax', 5.64)
    ,(@CONTACT_ID, N'WEBSITE', N'Website', 5.65)
    ,(@CONTACT_ID, N'SOCIAL', N'Social Network', 5.66)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- PHONE TYPE
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@PHONE_ID, N'MOBILE', N'Mobile', 5.71)
    ,(@PHONE_ID, N'HOME', N'Home', 5.72)
    ,(@PHONE_ID, N'WORK', N'Work', 5.73)
    ,(@PHONE_ID, N'FAX', N'Fax', 5.74)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- ADDRESS TYPE
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@ADDR_ID, N'HOME', N'Home', 5.81)
    ,(@ADDR_ID, N'WORK', N'Work', 5.82)
    ,(@ADDR_ID, N'BILLING', N'Billing', 5.83)
    ,(@ADDR_ID, N'SHIPPING', N'Shipping', 5.84)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- DOCUMENT TYPE
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@DOC_ID, N'PASSPORT', N'Passport', 5.91)
    ,(@DOC_ID, N'NATIONAL_ID', N'National ID', 5.92)
    ,(@DOC_ID, N'DRIVER_LICENSE', N'Driver License', 5.93)
    ,(@DOC_ID, N'BIRTH_CERT', N'Birth Certificate', 5.94)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- WEEKDAY
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@WEEKDAY_ID, N'MON', N'Monday', 6.11)
    ,(@WEEKDAY_ID, N'TUE', N'Tuesday', 6.12)
    ,(@WEEKDAY_ID, N'WED', N'Wednesday', 6.13)
    ,(@WEEKDAY_ID, N'THU', N'Thursday', 6.14)
    ,(@WEEKDAY_ID, N'FRI', N'Friday', 6.15)
    ,(@WEEKDAY_ID, N'SAT', N'Saturday', 6.16)
    ,(@WEEKDAY_ID, N'SUN', N'Sunday', 6.17)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- MONTH
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@MONTH_ID, N'JAN', N'January', 6.21)
    ,(@MONTH_ID, N'FEB', N'February', 6.22)
    ,(@MONTH_ID, N'MAR', N'March', 6.23)
    ,(@MONTH_ID, N'APR', N'April', 6.24)
    ,(@MONTH_ID, N'MAY', N'May', 6.25)
    ,(@MONTH_ID, N'JUN', N'June', 6.26)
    ,(@MONTH_ID, N'JUL', N'July', 6.27)
    ,(@MONTH_ID, N'AUG', N'August', 6.28)
    ,(@MONTH_ID, N'SEP', N'September', 6.29)
    ,(@MONTH_ID, N'OCT', N'October', 6.30)
    ,(@MONTH_ID, N'NOV', N'November', 6.31)
    ,(@MONTH_ID, N'DEC', N'December', 6.32)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- YES/NO
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@YESNO_ID, N'YES', N'Yes', 6.41)
    ,(@YESNO_ID, N'NO', N'No', 6.42)
    ,(@YESNO_ID, N'UNKNOWN', N'Unknown', 6.43)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- COLOR
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@COLOR_ID, N'RED', N'Red', 6.51)
    ,(@COLOR_ID, N'GREEN', N'Green', 6.52)
    ,(@COLOR_ID, N'BLUE', N'Blue', 6.53)
    ,(@COLOR_ID, N'YELLOW', N'Yellow', 6.54)
    ,(@COLOR_ID, N'BLACK', N'Black', 6.55)
    ,(@COLOR_ID, N'WHITE', N'White', 6.56)
    ,(@COLOR_ID, N'ORANGE', N'Orange', 6.57)
    ,(@COLOR_ID, N'PURPLE', N'Purple', 6.58)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- CURRENCY (sample)
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@CUR_ID, N'USD', N'US Dollar', 6.61)
    ,(@CUR_ID, N'EUR', N'Euro', 6.62)
    ,(@CUR_ID, N'JPY', N'Japanese Yen', 6.63)
    ,(@CUR_ID, N'GBP', N'British Pound', 6.64)
    ,(@CUR_ID, N'AUD', N'Australian Dollar', 6.65)
    ,(@CUR_ID, N'CAD', N'Canadian Dollar', 6.66)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- LANGUAGE (sample)
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@LANG_ID, N'EN', N'English', 6.71)
    ,(@LANG_ID, N'FR', N'French', 6.72)
    ,(@LANG_ID, N'SP', N'Spanish', 6.73)
    ,(@LANG_ID, N'DE', N'German', 6.74)
    ,(@LANG_ID, N'ZH', N'Chinese', 6.75)
    ,(@LANG_ID, N'JA', N'Japanese', 6.76)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- PAYMENT METHOD
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@PAY_ID, N'CASH', N'Cash', 6.81)
    ,(@PAY_ID, N'CHECK', N'Check', 6.82)
    ,(@PAY_ID, N'WIRE', N'Wire Transfer', 6.83)
    ,(@PAY_ID, N'CC', N'Credit Card', 6.84)
    ,(@PAY_ID, N'DC', N'Debit Card', 6.85)
    ,(@PAY_ID, N'PAYPAL', N'PayPal', 6.86)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- DELIVERY METHOD
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@DELV_ID, N'STANDARD', N'Standard Shipping', 6.91)
    ,(@DELV_ID, N'EXPRESS', N'Express Shipping', 6.92)
    ,(@DELV_ID, N'OVERNIGHT', N'Overnight Shipping', 6.93)
    ,(@DELV_ID, N'PICKUP', N'Store Pickup', 6.94)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- UNIT OF MEASURE
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@UOM_ID, N'PCS', N'Pieces', 7.01)
    ,(@UOM_ID, N'BOX', N'Boxes', 7.02)
    ,(@UOM_ID, N'CTN', N'Cartons', 7.03)
    ,(@UOM_ID, N'PALLET', N'Pallets', 7.04)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- FILE TYPE
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@FILE_ID, N'PDF', N'PDF File', 7.11)
    ,(@FILE_ID, N'DOC', N'DOC File', 7.12)
    ,(@FILE_ID, N'XLS', N'XLS File', 7.13)
    ,(@FILE_ID, N'PPT', N'PPT File', 7.14)
    ,(@FILE_ID, N'CSV', N'CSV File', 7.15)
    ,(@FILE_ID, N'IMG', N'Image File', 7.16)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- SEVERITY
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@SEV_ID, N'LOW', N'Low', 7.21)
    ,(@SEV_ID, N'MEDIUM', N'Medium', 7.22)
    ,(@SEV_ID, N'HIGH', N'High', 7.23)
    ,(@SEV_ID, N'CRITICAL', N'Critical', 7.24)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- PRIORITY
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@PRIO_ID, N'LOW', N'Low', 7.31)
    ,(@PRIO_ID, N'MEDIUM', N'Medium', 7.32)
    ,(@PRIO_ID, N'HIGH', N'High', 7.33)
    ,(@PRIO_ID, N'IMMEDIATE', N'Immediate', 7.34)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- STATUS
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@STAT_ID, N'OPEN', N'Open', 7.41)
    ,(@STAT_ID, N'IN_PROGRESS', N'In Progress', 7.42)
    ,(@STAT_ID, N'COMPLETED', N'Completed', 7.43)
    ,(@STAT_ID, N'ON_HOLD', N'On Hold', 7.44)
    ,(@STAT_ID, N'CLOSED', N'Closed', 7.45)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- RELATIONSHIP
MERGE dbo.Common_BaseInfo AS tgt
USING (
    VALUES
      (@REL_ID, N'PARENT', N'Parent', 7.51)
    ,(@REL_ID, N'CHILD', N'Child', 7.52)
    ,(@REL_ID, N'SPOUSE', N'Spouse', 7.53)
    ,(@REL_ID, N'SIBLING', N'Sibling', 7.54)
    ,(@REL_ID, N'FRIEND', N'Friend', 7.55)
    ,(@REL_ID, N'OTHER', N'Other', 7.56)
) AS src(ParentId, ShortName, Title, ViewOrder)
ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = src.ViewOrder, tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- Optional: deactivate removed categories under GEN (keeps items untouched)
UPDATE tgt
SET tgt.IsActive = 0, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
FROM dbo.Common_BaseInfo tgt
WHERE tgt.ParentId = @GEN_ID AND tgt.IsActive = 1
  AND NOT EXISTS (SELECT 1 FROM @cat src WHERE src.ShortName = tgt.ShortName);
