-- =============================================
-- Author:        GitHub Copilot
-- Create date:   2025-09-27
-- Description:   Seed data for Common_BaseInfo - Geography hierarchy (English)
--                Root -> Countries -> States/Provinces -> Cities
--                Idempotent upsert by (ParentId, ShortName)
-- Sample:        EXEC dbo.Zync 'i AppEnd/Seed/Common_BaseInfo_Geo.en.sql';
-- =============================================
SET NOCOUNT ON;
DECLARE @now DATETIME = GETDATE();
DECLARE @sys INT = 0;

-- Root: Geography
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT CAST(NULL AS INT) AS ParentId, N'GEO' AS ShortName, N'Geography' AS Title, CAST(10.0 AS FLOAT) AS ViewOrder) AS src
    ON ((tgt.ParentId IS NULL) AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @GEO_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId IS NULL AND ShortName = N'GEO');

-- Countries under GEO
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'IR' AS ShortName, N'Iran' AS Title, CAST(10.1 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @IR_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'IR');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'US' AS ShortName, N'United States' AS Title, CAST(10.2 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @US_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'US');

-- Provinces/States under IR
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_ID AS ParentId, N'TEH' AS ShortName, N'Tehran' AS Title, CAST(10.11 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @IR_TEH_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @IR_ID AND ShortName = N'TEH');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_ID AS ParentId, N'ALB' AS ShortName, N'Alborz' AS Title, CAST(10.12 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @IR_ALB_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @IR_ID AND ShortName = N'ALB');

-- Provinces/States under US
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_ID AS ParentId, N'CA' AS ShortName, N'California' AS Title, CAST(10.21 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @US_CA_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @US_ID AND ShortName = N'CA');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_ID AS ParentId, N'NY' AS ShortName, N'New York' AS Title, CAST(10.22 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @US_NY_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @US_ID AND ShortName = N'NY');

-- Cities under IR provinces
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_TEH_ID AS ParentId, N'TEHRAN' AS ShortName, N'Tehran' AS Title, CAST(10.111 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @IR_ALB_ID AS ParentId, N'KARAJ' AS ShortName, N'Karaj' AS Title, CAST(10.121 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- Cities under US states
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_CA_ID AS ParentId, N'LOSANGELES' AS ShortName, N'Los Angeles' AS Title, CAST(10.211 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @US_NY_ID AS ParentId, N'NEWYORKCITY' AS ShortName, N'New York City' AS Title, CAST(10.221 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- Additional countries under GEO: Turkey (TR), Germany (DE), Canada (CA), United Arab Emirates (AE)
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'TR' AS ShortName, N'Turkey' AS Title, CAST(10.3 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @TR_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'TR');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'DE' AS ShortName, N'Germany' AS Title, CAST(10.4 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @DE_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'DE');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'CA' AS ShortName, N'Canada' AS Title, CAST(10.5 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @CA_COUNTRY_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'CA');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @GEO_ID AS ParentId, N'AE' AS ShortName, N'United Arab Emirates' AS Title, CAST(10.6 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @AE_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @GEO_ID AND ShortName = N'AE');

-- Turkey provinces
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @TR_ID AS ParentId, N'IST' AS ShortName, N'Istanbul' AS Title, CAST(10.31 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @TR_IST_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @TR_ID AND ShortName = N'IST');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @TR_ID AS ParentId, N'ANK' AS ShortName, N'Ankara' AS Title, CAST(10.32 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @TR_ANK_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @TR_ID AND ShortName = N'ANK');

-- Germany states
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @DE_ID AS ParentId, N'BY' AS ShortName, N'Bavaria' AS Title, CAST(10.41 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @DE_BY_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @DE_ID AND ShortName = N'BY');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @DE_ID AS ParentId, N'BE' AS ShortName, N'Berlin' AS Title, CAST(10.42 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @DE_BE_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @DE_ID AND ShortName = N'BE');

-- Canada provinces
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @CA_COUNTRY_ID AS ParentId, N'ON' AS ShortName, N'Ontario' AS Title, CAST(10.51 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @CA_ON_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @CA_COUNTRY_ID AND ShortName = N'ON');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @CA_COUNTRY_ID AS ParentId, N'BC' AS ShortName, N'British Columbia' AS Title, CAST(10.52 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @CA_BC_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @CA_COUNTRY_ID AND ShortName = N'BC');

-- UAE emirates
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @AE_ID AS ParentId, N'DU' AS ShortName, N'Dubai' AS Title, CAST(10.61 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @AE_DU_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @AE_ID AND ShortName = N'DU');

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @AE_ID AS ParentId, N'AD' AS ShortName, N'Abu Dhabi' AS Title, CAST(10.62 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
DECLARE @AE_AD_ID INT = (SELECT Id FROM dbo.Common_BaseInfo WHERE ParentId = @AE_ID AND ShortName = N'AD');

-- Cities under new provinces/states
-- Turkey
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @TR_IST_ID AS ParentId, N'ISTANBUL' AS ShortName, N'Istanbul' AS Title, CAST(10.311 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @TR_ANK_ID AS ParentId, N'ANKARA' AS ShortName, N'Ankara' AS Title, CAST(10.321 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- Germany
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @DE_BY_ID AS ParentId, N'MUNICH' AS ShortName, N'Munich' AS Title, CAST(10.411 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @DE_BE_ID AS ParentId, N'BERLIN' AS ShortName, N'Berlin' AS Title, CAST(10.421 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- Canada
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @CA_ON_ID AS ParentId, N'TORONTO' AS ShortName, N'Toronto' AS Title, CAST(10.511 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @CA_BC_ID AS ParentId, N'VANCOUVER' AS ShortName, N'Vancouver' AS Title, CAST(10.521 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

-- United Arab Emirates
MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @AE_DU_ID AS ParentId, N'DUBAI' AS ShortName, N'Dubai' AS Title, CAST(10.611 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);

MERGE dbo.Common_BaseInfo AS tgt
USING (SELECT @AE_AD_ID AS ParentId, N'ABUDHABI' AS ShortName, N'Abu Dhabi' AS Title, CAST(10.621 AS FLOAT) AS ViewOrder) AS src
    ON (tgt.ParentId = src.ParentId AND tgt.ShortName = src.ShortName)
WHEN MATCHED THEN UPDATE SET tgt.Title = src.Title, tgt.ViewOrder = ISNULL(src.ViewOrder, tgt.ViewOrder), tgt.IsActive = 1, tgt.UpdatedBy = @sys, tgt.UpdatedOn = @now
WHEN NOT MATCHED THEN INSERT (CreatedBy, CreatedOn, ParentId, Title, ShortName, ViewOrder, IsActive) VALUES (@sys, @now, src.ParentId, src.Title, src.ShortName, src.ViewOrder, 1);
