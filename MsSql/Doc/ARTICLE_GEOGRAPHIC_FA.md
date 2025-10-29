# بسته Geographic در Zync: مجموعهٔ مکانی الهام‌گرفته از PostGIS برای SQL Server

Zync یک مدیر بستهٔ سبک و مبتنی بر Git برای SQL Server است که مجموعه‌ای از اسکریپت‌های SQL را به بسته‌های قابل نصب و وابستگی‌محور تبدیل می‌کند. با Zync می‌توانید ابزارهای پایگاه‌دادهٔ قابل‌اعتماد، تکرارپذیر و قابل اشتراک را تنها با چند دستور ساده به دست آورید.

در این مقاله به بستهٔ Geographic می‌پردازیم و توضیح می‌دهیم که چرا و چگونه عمداً بر اساس الگوها و قراردادهای PostGIS در PostgreSQL طراحی شده است تا توسعه‌دهندگان مکانی هنگام کار با SQL Server احساس آشنایی کنند.

- GitHub: https://github.com/mirshahreza/Zync
- مسیر بستهٔ Geographic: MsSql/Packages/Geographic

## چرا الگوی PostGIS؟

PostGIS استاندارد شناخته‌شدهٔ پردازش داده‌های مکانی در PostgreSQL است. طراحی API حساب‌شده، نام‌گذاری یکدست (ST_*) و مجموعهٔ توابع غنیِ PostGIS باعث شده بسیاری از مهندسان با همان ذهنیت سراغ کارهای ژئواسپیشیال بروند.

بستهٔ Geographic در Zync همان مدل ذهنی و قراردادهای نام‌گذاری را اتخاذ کرده تا:
- نام و معناشناسی توابع برای کاربران PostGIS آشنا باشد.
- کارهای رایج (ساخت هندسه، روابط مکانی، بافر، سنجش فاصله) ظاهر و احساسی مشابه داشته باشد.
- مهاجرت بین PostgreSQL/PostGIS و SQL Server برای تیم‌های چندسکویی آسان‌تر شود.

در لایهٔ پیاده‌سازی، این توابع بر بستر انواع مکانی بومی SQL Server (geometry و geography) و T‑SQL ساخته شده‌اند و تا جای ممکن سطح APIِ شبیه PostGIS ارائه می‌دهند.

## نکات طراحی

- نام‌گذاری ST_*: همهٔ کمک‌تابع‌های مکانی با قرارداد ST_* و پیشوند محافظتی Zz ارائه می‌شوند؛ مثل ZzST_Buffer، ZzST_Contains، ZzST_DWithin.
- اولویت با geometry: توابع اصلی ST_* روی نوع geometry کار می‌کنند؛ در جاهایی که دقت ژئودتیک لازم است، توابع کمکیِ جداگانه با ورودی‌های عرض/طول جغرافیایی (lat/lon) و فرمول هاورساین استفاده می‌شوند.
- سازگار با WKT/WKB: سازنده‌ها و توابع I/O، WKT/WKB را می‌پذیرند/برمی‌گردانند تا تست و تبادل داده ساده باشد.
- SRID پیش‌فرض: اگر SRID صراحتاً تعیین نشود، مقدار پیش‌فرض 4326 (WGS 84) در نظر گرفته می‌شود.
- معناشناسی آشنا: نام‌ها و رفتارها آگاهانه با مرجع PostGIS همسو شده‌اند؛ تا جایی که امکانات مکانی SQL Server اجازه می‌دهد.

برای مرجع سریع، به: MsSql/Doc/POSTGIS_FUNCTIONALITIES.md مراجعه کنید.

## چه چیزهایی داخل بسته است؟

علاوه بر توابع کاربردی مثل اعتبارسنجی مختصات و تبدیل واحدها، بسته بیش از 45 تابع به سبک PostGIS (با پیشوند ZzST_) ارائه می‌دهد، از جمله:

- سازنده‌های هندسه: ZzST_Point، ZzST_MakePoint، ZzST_MakeLine، ZzST_MakePolygon، ZzST_MakeEnvelope
- توابع ورودی/خروجی: ZzST_AsText، ZzST_AsBinary، ZzST_GeomFromText، ZzST_GeomFromWKB
- دسترسی‌دهنده‌ها: ZzST_X، ZzST_Y، ZzST_GeometryType، ZzST_SRID
- سنجش و گزاره‌ها: ZzST_Distance، ZzST_Length، ZzST_Area، ZzST_Perimeter، ZzST_Contains، ZzST_Within، ZzST_Intersects، ZzST_DWithin
- پردازش هندسی: ZzST_Buffer، ZzST_Centroid، ZzST_Envelope، ZzST_ConvexHull، ZzST_PointOnSurface
- عملیات مجموعه‌ای: ZzST_Union، ZzST_Intersection، ZzST_Difference، ZzST_SymDifference

همچنین چند کمک‌تابع عمل‌گرای محبوب برای Backendهای اپلیکیشن‌ها:
- ZzIsPointInRadius، ZzGetPointsInRadius، ZzGetBoundingBox، ZzGetNearestPoint
- مبدل‌ها و قالب‌دهنده‌ها: ZzConvertDMSToDecimal، ZzConvertDecimalToDMS، ZzConvertDistance/Area/Speed

فهرست کامل و مثال‌ها را در MsSql/Packages/Geographic/README.md ببینید.

## مثال‌های کاربردی

نکته: در مثال‌ها از geometry استفاده شده است؛ در صورت نیاز به محاسبات ژئودتیک دقیق، از geography بهره بگیرید. SRID پیش‌فرض 4326 است مگر اینکه خلاف آن را تعیین کنید.

1) ساخت نقطه و خط (شبیه PostGIS):

```sql
-- POINT(lon lat)
SELECT [dbo].[ZzST_AsText](
  [dbo].[ZzST_MakePoint](51.3890, 35.6892, NULL, NULL)
) AS WKT;

-- LINESTRING از دو نقطه
SELECT [dbo].[ZzST_AsText](
  [dbo].[ZzST_MakeLine]('51.3890,35.6892;51.4000,35.7000', 4326)
) AS WKT;
```

2) روابط مکانی و گزاره‌ها:

```sql
-- پاکت (BBox) که یک نقطه را دربرگیرد
DECLARE @bbox geometry = [dbo].[ZzST_MakeEnvelope](51.3800, 35.6800, 51.4200, 35.7200, 4326);
DECLARE @pt   geometry = [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326);
SELECT [dbo].[ZzST_Contains](@bbox, @pt) AS ContainsPoint; -- 1 = درست، 0 = نادرست
```

3) فاصله و همسایگی:

```sql
-- آیا دو نقطه در شعاع 1000 متر از هم هستند؟
DECLARE @a geometry = [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326);
DECLARE @b geometry = [dbo].[ZzST_GeomFromText]('POINT(51.4000 35.7000)', 4326);
SELECT [dbo].[ZzST_DWithin](@a, @b, 1000.0) AS IsNearby;
```

4) بافر کردن:

```sql
-- ایجاد بافر کوچک پیرامون یک نقطه (~واحد به SRID بستگی دارد)
DECLARE @pt geometry = [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326);
SELECT [dbo].[ZzST_AsText]([dbo].[ZzST_Buffer](@pt, 0.01)) AS Buffered;
```

5) کمک‌تابع‌های «دوست‌دار اپلیکیشن» با ورودی lat/lon:

```sql
-- بررسی قرارگیری یک نقطه (lat/lon) درون شعاع مشخص (KM/MILE/M)
SELECT [dbo].[ZzIsPointInRadius](35.6892, 51.3890, 35.7000, 51.4000, 10, 'KM') AS InRadius;

-- یافتن نقاط درون یک شعاع پیرامون مرکز (Schema نمونه فرضی)
-- SELECT * FROM [dbo].[ZzGetPointsInRadius](
--   @centerLat, @centerLon, @radiusValue, @radiusUnit, @YourPointsTable
-- );
```

## نگاشت برای کاربران PostGIS

- نام‌گذاری ST_* با پیشوند Zz حفظ شده است: مثلاً ST_Buffer در PostGIS ≈ ZzST_Buffer در این بسته.
- ورودی‌های WKT/WKB از طریق ZzST_GeomFromText و ZzST_GeomFromWKB پشتیبانی می‌شوند.
- مدیریت SRID با ZzST_SRID و ZzST_SetSRID (بدون Transform) انجام می‌شود.
- معادل‌های SQL Server (درونی) ممکن است نام متفاوتی داشته باشند (مثل STBuffer، STDistance)، اما Wrapperها ارگونومی مشابه PostGIS ارائه می‌دهند.

### جدول نگاشت کوتاه

| PostGIS | Zync Geographic | توضیح/تفاوت‌ها |
|---|---|---|
| ST_Buffer | ZzST_Buffer | بافر روی geometry؛ واحد به SRID وابسته است. |
| ST_DWithin | ZzST_DWithin | بررسی نزدیکی در فاصلهٔ مشخص (واحد = واحد سیستم مختصات). برای مسیرهای طولانی geodetic، geography را در نظر بگیرید. |
| ST_Intersects | ZzST_Intersects | بازگشت 0/1؛ تقاطع هر نوع هندسه. |
| ST_Contains | ZzST_Contains | آیا A شامل B است (B کاملاً درون A). |
| ST_Within | ZzST_Within | آیا A درون B قرار دارد. |
| ST_Distance | ZzST_Distance | حداقل فاصلهٔ دوبعدی؛ برای lat/lon دقیق، از ZzCalculateDistance (Haversine) استفاده کنید. |
| ST_AsText | ZzST_AsText | خروجی WKT برای مشاهده/دیباگ. |
| ST_GeomFromText | ZzST_GeomFromText | سازندهٔ هندسه از WKT با SRID ورودی. |

نکات و توصیه‌ها:
- هنگام ترکیب داده از منابع گوناگون، SRID را صریح تعیین کنید.
- geography در برابر geometry: برای محاسبات ژئودتیک مسافت‌های بلند از geography استفاده کنید؛ برای عملیات صفحه‌ای و اکثر گزاره‌ها geometry کفایت می‌کند.
- تولرانس و واحد: شعاع بافر و فاصله‌ها به سیستم مختصات وابسته‌اند—SRIDهای همسان (مثل WGS 84 برای GPS) را ترجیح دهید.

## نصب

نصب مستقیم از مخزن Zync با دستور Zync:

```sql
-- نصب کل بستهٔ Geographic
EXEC [dbo].[Zync] 'i Geographic';

-- یا فقط نصب توابع مکانی
EXEC [dbo].[Zync] 'i Geographic/ZzST_*.sql';
```

اگر هنوز Zync را نصب نکرده‌اید، اسکریپت MsSql/Zync.sql را از مخزن اجرا کنید. برای معرفی ملایم به MsSql/Doc/ARTICLE_EN.md و برای خودکارسازی به MsSql/scripts/README.md مراجعه کنید.

## منابع

- مخزن Zync: https://github.com/mirshahreza/Zync
- مستندات PostGIS: https://postgis.net/docs/
- انواع مکانی در SQL Server: geometry و geography

---

اگر با PostGIS راحت بوده‌اید، اینجا هم احساس آشنایی می‌کنید: بستهٔ Geographic در Zync یک جعبه‌ابزار مکانی آشنا، مدرن و Production‑Ready را برای SQL Server می‌آورد؛ مستند، آزموده و آمادهٔ استفاده.