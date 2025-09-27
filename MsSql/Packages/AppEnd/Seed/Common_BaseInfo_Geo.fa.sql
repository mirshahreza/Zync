-- =============================================
-- Author:        GitHub Copilot
-- Create date:   2025-09-27
-- Description:   Seed data for Common_BaseInfo - Geography hierarchy (Persian/Farsi)
--                ریشه → کشورها → استان‌ها/ایالت‌ها → شهرها
--                Idempotent upsert by (ParentId, ShortName)
-- Sample:        EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_Geo.fa.sql';
-- =============================================
SET NOCOUNT ON;
DECLARE @now DATETIME = GETDATE();
DECLARE @sys INT = 0;

-- ریشه: جغرافیا
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT CAST(NULL AS INT) AS ParentId, N'GEO' AS ShortName, N'جغرافیا' AS Title, CAST(10.0 AS FLOAT) AS ViewOrder) AS src
    ON ((tgt.ParentId IS NULL) AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @GEO_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId IS NULL AND ShortName = N'GEO');

-- کشورها زیر GEO
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'IR' AS ShortName, N'ایران' AS Title, CAST(10.1 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @IR_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'IR');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'US' AS ShortName, N'ایالات متحده' AS Title, CAST(10.2 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @US_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'US');

-- استان‌ها زیر ایران
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_ID AS ParentId, N'TEH' AS ShortName, N'تهران' AS Title, CAST(10.11 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @IR_TEH_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @IR_ID AND ShortName = N'TEH');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_ID AS ParentId, N'ALB' AS ShortName, N'البرز' AS Title, CAST(10.12 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @IR_ALB_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @IR_ID AND ShortName = N'ALB');

-- ایالت‌ها زیر آمریکا
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_ID AS ParentId, N'CA' AS ShortName, N'کالیفرنیا' AS Title, CAST(10.21 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @US_CA_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @US_ID AND ShortName = N'CA');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_ID AS ParentId, N'NY' AS ShortName, N'نیویورک' AS Title, CAST(10.22 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @US_NY_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @US_ID AND ShortName = N'NY');

-- شهرها زیر استان‌های ایران
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_TEH_ID AS ParentId, N'TEHRAN' AS ShortName, N'تهران' AS Title, CAST(10.111 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_ALB_ID AS ParentId, N'KARAJ' AS ShortName, N'کرج' AS Title, CAST(10.121 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- شهرها زیر ایالت‌های آمریکا
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_CA_ID AS ParentId, N'LOSANGELES' AS ShortName, N'لس آنجلس' AS Title, CAST(10.211 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_NY_ID AS ParentId, N'NEWYORKCITY' AS ShortName, N'نیویورک' AS Title, CAST(10.221 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
