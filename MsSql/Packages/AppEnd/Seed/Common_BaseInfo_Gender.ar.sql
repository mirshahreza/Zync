-- =============================================
-- Author:        GitHub Copilot
-- Create date:   2025-09-27
-- Description:   Seed data for Common_BaseInfo - Gender (Arabic)
--                Idempotent upsert based on (ParentId, ShortName).
--                Run once per environment; safe to re-run.
-- Sample:        EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_Gender.ar.sql';
-- =============================================
SET NOCOUNT ON;
DECLARE @now DATETIME = GETDATE();
DECLARE @sys INT = 0; -- معرف المستخدم النظامي

-- الجذر: الجنس
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT CAST(NULL AS INT) AS ParentId, N'GENDER' AS ShortName, N'الجنس' AS Title, CAST(1.0 AS FLOAT) AS ViewOrder) AS src
    ON ((tgt.ParentId IS NULL) AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET
    tgt.Title = src.Title,
    tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder),
    tgt.IsActive = 1,
    tgt.UpdatedBy = @sys,
    tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

DECLARE @GENDER_ID INT = (
    SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId IS NULL AND ShortName = N'GENDER'
);

-- الأبناء: ذكر، أنثى، آخر
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GENDER_ID AS ParentId, N'MALE' AS ShortName, N'ذكر' AS Title, CAST(1.1 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET
    tgt.Title = src.Title,
    tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder),
    tgt.IsActive = 1,
    tgt.UpdatedBy = @sys,
    tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GENDER_ID AS ParentId, N'FEMALE' AS ShortName, N'أنثى' AS Title, CAST(1.2 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET
    tgt.Title = src.Title,
    tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder),
    tgt.IsActive = 1,
    tgt.UpdatedBy = @sys,
    tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GENDER_ID AS ParentId, N'OTHER' AS ShortName, N'آخر' AS Title, CAST(1.3 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET
    tgt.Title = src.Title,
    tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder),
    tgt.IsActive = 1,
    tgt.UpdatedBy = @sys,
    tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive)
    VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
