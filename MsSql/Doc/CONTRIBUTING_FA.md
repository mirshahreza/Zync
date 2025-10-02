# راهنمای توسعه و مشارکت در Zync (SQL Server)

[![Test Coverage](https://img.shields.io/badge/Tests-100%25%20Pass-brightgreen.svg)](../Test/)
[![Objects](https://img.shields.io/badge/Objects-131-blue.svg)](../Packages/)
[![Packages](https://img.shields.io/badge/Packages-12-orange.svg)](../Packages/)

این سند یک راهنمای کامل و قدم‌به‌قدم برای توسعه‌دهندگان است تا بتوانند:
- یک آبجکت جدید (Procedure / Function / View / Type) بسازند و به یکی از پکیج‌های موجود اضافه کنند
- یک پکیج جدید بسازند و ساختار صحیح آن را رعایت کنند
- تست‌های جامع برای آبجکت‌های خود بنویسند
- تغییراتشان را در ریپوزیتوری اصلی ارسال کنند (Pull Request) یا در ریپوی شخصی خودشان منتشر و استفاده کنند

این راهنما مخصوص پیاده‌سازی SQL Server است و با ساختار موجود در مسیر `MsSql/` هم‌راستا نوشته شده است.

**وضعیت پروژه:** نسخه 3.0 با 12 پکیج، 131 آبجکت، و پوشش تست 100%

---

## پیش‌نیازها

### نرم‌افزارهای مورد نیاز:
- **SQL Server 2017+** (پیشنهادی: SQL Server 2022)
- **PowerShell 7+** برای اجرای اسکریپت‌های تست و نصب
- **SQL Server Management Studio (SSMS)** یا ابزار مشابه
- **Git** برای مدیریت نسخه و ارسال تغییرات

### تنظیمات:
- دسترسی اجرای اسکریپت‌ها روی دیتابیس مقصد
- اجرای یک‌بارۀ فایل `MsSql/Zync.sql` روی دیتابیس هدف برای نصب هسته‌ی Zync
- فعال بودن OLE Automation برای فراخوانی HTTP (در صورت نیاز به دریافت از GitHub Raw):

```sql
EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE;
```

نکته: Zync به‌صورت پیش‌فرض از این آدرس برای دریافت پکیج‌ها استفاده می‌کند:
```
https://raw.githubusercontent.com/mirshahreza/Zync/master/MsSql/Packages/
```
اگر ریپوی شما شاخه‌ی main دارد، یا قصد دارید از ریپوی شخصی استفاده کنید، هنگام صدا زدن Zync پارامتر دوم (`@Repo`) را مشخص کنید (نمونه‌ها در ادامه آمده است).

---

## قراردادهای نام‌گذاری و سبک کدنویسی

- نام تمام آبجکت‌های Utility با پیشوند `Zz` شروع می‌شود تا از منطق کسب‌وکار شما تفکیک شوند؛ مثال: `ZzSplitString`، `ZzCreateTableGuid`.
- شِما: از `[DBO]` استفاده کنید مگر دلیل خاصی داشته باشید.
- همواره از الگوی «CREATE OR ALTER» استفاده کنید تا نصب/به‌روزرسانی ایمن باشد:
  - `CREATE OR ALTER PROCEDURE [dbo].[ZzMyProc] ...`
  - `CREATE OR ALTER FUNCTION [dbo].[ZzMyFunc] ...`
  - `CREATE OR ALTER VIEW [dbo].[ZzMyView] AS ...`
  - برای Type معمولاً `CREATE TYPE` استفاده می‌شود (پشتیبانی بکاپ برای Type متفاوت است).
- در ابتدای هر فایل، هدر توضیحی را درج کنید تا دستور `ls` بتواند «شرح» را نشان دهد. کلیدواژه‌ی `-- Description:` در یک خط مجزا کمک می‌کند توضیح در خروجی `ls <package>` نمایش داده شود.

نمونه‌ی هدر استاندارد:
```sql
-- =============================================
-- Author:      نام شما
-- Create date: 2025-09-27
-- Description: توضیح کوتاه، دقیق و عملیاتی از کار آبجکت.
-- Sample:
-- EXEC [dbo].[ZzMyFunc] ...
-- =============================================
```

- اگر اسکریپت شما به آبجکت‌های دیگر نیاز دارد، می‌توانید «وابستگی‌ها» را در ابتدای فایل و در یک بلاک کامنت بنویسید تا Zync قبل از اجرای بدنه‌ی اصلی، آن‌ها را نصب کند:

```sql
/*
EXEC DBO.Zync 'i String/ZzSplitString.sql';
EXEC DBO.Zync 'i Math/ZzSafeDivide.sql';
*/
-- ادامه‌ی اسکریپت آبجکت شما...
```

نکته: Zync ابتدا بلاک کامنت ابتدایی (اگر از اولین کاراکتر فایل با `/*` شروع شود) را استخراج و اجرا می‌کند، سپس خود اسکریپت را اجرا می‌کند.

---

## ساختار پوشه‌ها و فایل‌ها

- ریشه‌ی SQL Server: `MsSql/`
- پکیج‌ها: `MsSql/Packages/<PackageName>/`
- برای هر پکیج می‌توانید فایل فهرست `MsSql/Packages/<PackageName>/.sql` داشته باشید که شامل مجموعه‌ای از خطوط نصب باشد؛ مثال در پکیج `String` موجود است. اجرای این فایل، همه‌ی آیتم‌های پکیج را نصب می‌کند.
- هر آبجکت یک فایل `.sql` جدا با نامی شفاف و هم‌نام با آبجکت داخل دیتابیس دارد؛ مثال: `MsSql/Packages/String/ZzSplitString.sql` که داخلش `CREATE OR ALTER FUNCTION [dbo].[ZzSplitString] ...` وجود دارد.
- برای هر پکیج یک `README.md` کوتاه قرار دهید که معرفی و نحوۀ استقرار را توضیح دهد.

---

## افزودن یک آبجکت جدید به یک پکیج موجود

1) انتخاب پکیج مناسب، مثلاً `String` یا `DateTime`.
2) ایجاد فایل جدید در مسیر پکیج، مانند:
   - `MsSql/Packages/String/ZzMyNewFunction.sql`
3) نوشتن هدر استاندارد و بدنه‌ی آبجکت با «CREATE OR ALTER» و شِمای `[dbo]`.
4) در صورت نیاز، وابستگی‌ها را در ابتدای فایل و داخل بلاک کامنت قرار دهید.
5) اگر می‌خواهید نصب کامل پکیج، آبجکت جدید را هم شامل شود، یک خط نصب به فایل فهرست پکیج اضافه کنید:
   - ویرایش: `MsSql/Packages/<PackageName>/.sql`
   - افزودن: `EXEC DBO.Zync 'i <PackageName>/<FileName>.sql';`
6) به‌روزرسانی `README.md` همان پکیج و افزودن توضیح مختصر آبجکت جدید.
7) تست محلی روی دیتابیس تست:
   - نصب تک‌آیتم:
     ```sql
     EXEC [dbo].[Zync] 'i String/ZzMyNewFunction.sql';
     ```
   - فهرست با توضیحات:
     ```sql
     EXEC [dbo].[Zync] 'ls String';
     ```
   - مشاهده‌ی آبجکت‌های نصب‌شده‌ی Zync:
     ```sql
     EXEC [dbo].[Zync] 'lo';
     ```

---

## ساخت یک پکیج جدید از صفر

فرض کنید می‌خواهید پکیج `Text` بسازید:

1) ساخت پوشه‌ها:
   - `MsSql/Packages/Text/`
2) ایجاد فایل شاخص پکیج:
   - `MsSql/Packages/Text/.sql`
   - داخل آن خطوط نصب آبجکت‌های پکیج را قرار دهید، مانند:
     ```sql
     EXEC DBO.Zync 'i Text/ZzNormalizeSpace.sql';
     EXEC DBO.Zync 'i Text/ZzToTitleCase.sql';
     ```
     (اختیاری) اگر این پکیج به پکیج‌های دیگر وابسته است، می‌توانید در ابتدای همین فایل یک بلاک کامنت وابستگی بگذارید.
3) ایجاد آبجکت‌ها، هرکدام در یک فایل جدا، با هدر و استانداردهای گفته‌شده.
4) ایجاد `MsSql/Packages/Text/README.md` و معرفی کوتاه پکیج + نحوۀ نصب:
   ```sql
   EXEC dbo.Zync 'i Text';
   -- یا نصب تک‌آیتم:
   EXEC dbo.Zync 'i Text/ZzNormalizeSpace.sql';
   ```
5) تست نصب پکیج روی دیتابیس تست:
   ```sql
   EXEC dbo.Zync 'i Text';
   EXEC dbo.Zync 'ls Text';
   EXEC dbo.Zync 'lo';
   ```

نکات مهم:
- نام فایل‌ها با نام آبجکت‌ها هم‌خوان باشد.
- در صورت تمایل به نمایش توضیح هر آیتم در `ls <package>`، در ابتدای فایل آن آیتم، خط `-- Description:` را قرار دهید.

---

## انتشار در ریپوزیتوری اصلی (Pull Request)

1) Fork از ریپوی اصلی.
2) یک شاخه‌ی جدید بسازید (مثلاً `feature/<short-name>`).
3) تغییرات را طبق استانداردها اعمال کنید:
   - فایل اسکریپت‌ها در مسیر صحیح پکیج
   - به‌روزرسانی فایل `.sql` شاخص پکیج (در صورت نیاز)
   - به‌روزرسانی `README.md` پکیج
   - رعایت هدر استاندارد، `CREATE OR ALTER`، پیشوند `Zz`
   - اضافه کردن تست‌های لازم در `MsSql/Test/` (اختیاری ولی پیشنهاد می‌شود)
4) صحت‌سنجی محلی:
   - اجرای یک‌بارۀ `MsSql/Zync.sql` روی دیتابیس تست
   - اجرای نصب‌های آزمایشی:
     ```sql
     EXEC dbo.Zync 'clean';
     EXEC dbo.Zync 'i <YourPackageOrFile>'; -- نصب پکیج یا فایل جدید
     EXEC dbo.Zync 'ls <YourPackage>';      -- بررسی نمایش توضیح آیتم‌ها
     EXEC dbo.Zync 'lo';                    -- بررسی آبجکت‌های Zz*
     ```
   - اجرای اسکریپت‌های تست موجود مانند `MsSql/Test/zync_check_syntax.sql` یا `MsSql/Test/zync_test_comprehensive.sql` (در صورت نیاز)
5) Commit مرتب با پیام‌های واضح و Pull Request با توضیح تغییرات، دلیل و نمونه استفاده.

نکته: Zync داخل کد به‌صورت پیش‌فرض از شاخه‌ی `master` در GitHub Raw استفاده می‌کند. اگر شاخه‌ی پیش‌فرض ریپوی اصلی تغییر کند، این مقدار در آینده ممکن است به‌روزرسانی شود؛ شما لازم نیست آن را تغییر دهید، اما در PR اشاره به این نکته خالی از لطف نیست.

---

## استفاده و انتشار در ریپوزیتوری شخصی

اگر می‌خواهید پکیج‌ها را در ریپوی شخصی‌تان نگه دارید و از همان‌جا نصب کنید:

1) ساختار پوشه‌ها را مشابه این ریپو رعایت کنید:
```
<YourRepo>/MsSql/Packages/<PackageName>/<Files>.sql
```
2) فایل‌های `.sql` پکیج و آبجکت‌ها را مثل قبل آماده کنید.
3) هنگام نصب، پارامتر دوم Zync را (URL ریپو) مشخص کنید. مثال‌ها:

- نصب یک پکیج کامل از ریپوی شخصی (شاخه main):
```sql
EXEC dbo.Zync 'i String', 'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';
```

- نصب یک فایل تکی از ریپوی شخصی (شاخه master):
```sql
EXEC dbo.Zync 'i DateTime/ZzStartOfWeek.sql', 'https://raw.githubusercontent.com/<user>/<repo>/master/MsSql/Packages/';
```

- جست‌وجو و لیست کردن با ریپوی شخصی:
```sql
EXEC dbo.Zync 'ls DateTime', 'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';
EXEC dbo.Zync 'ls ?week',    'https://raw.githubusercontent.com/<user>/<repo>/main/MsSql/Packages/';
```

نکته‌ها:
- حتماً URL را به «پوشه‌ی Packages» ختم کنید (اسلش انتهایی مهم است).
- اگر شاخه‌ی شما `main` است، در URL به‌جای `master` از `main` استفاده کنید.
- فایل شاخص پکیج (`.sql`) باید مانند نمونه‌ی پکیج `String` خطوط نصب اعضای پکیج را داشته باشد.
- اگر می‌خواهید `ls <package>` توضیحات را نشان دهد، در هر فایل عضو، خط `-- Description:` قرار دهید.

---

## الگوهای آماده (Templates)

### 1) Function نمونه
```sql
/* وابستگی‌ها (اختیاری)
EXEC DBO.Zync 'i String/ZzSplitString.sql';
*/
-- =============================================
-- Author:      Your Name
-- Create date: 2025-09-27
-- Description: توضیح مختصر عملکرد تابع
-- Sample:
-- SELECT * FROM [dbo].[ZzMyFunc](...);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzMyFunc]
(
    @Param1 NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT @Param1 AS Value -- بدنه‌ی واقعی را اینجا بنویسید
);
```

### 2) Procedure نمونه
```sql
/* وابستگی‌ها (اختیاری)
EXEC DBO.Zync 'i DbMan/ZzObjectExist.sql';
*/
-- =============================================
-- Author:      Your Name
-- Create date: 2025-09-27
-- Description: کاری که این پروسیجر انجام می‌دهد
-- Sample:
-- EXEC [dbo].[ZzMyProc] @Param = '...';
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[ZzMyProc]
    @Param NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    -- بدنه‌ی واقعی را اینجا بنویسید
END
```

### 3) فایل شاخص پکیج (.sql)
```sql
-- نصب همه‌ی آبجکت‌های پکیج Text
EXEC DBO.Zync 'i Text/ZzNormalizeSpace.sql';
EXEC DBO.Zync 'i Text/ZzToTitleCase.sql';
```

---

## نکات تست و کنترل کیفیت

- قبل از PR یا انتشار، روی دیتابیس تست اجرا و نصب/حذف را بررسی کنید:
  - `EXEC dbo.Zync 'i <PkgOrFile>'`
  - `EXEC dbo.Zync 'lo'`
  - `EXEC dbo.Zync 'rm <PkgOrFile>'` و مجدداً `lo`
- اسکریپت‌های کمکی در `MsSql/Test/` وجود دارند؛ در صورت نیاز استفاده کنید (مثل `zync_check_syntax.sql`، `zync_test_comprehensive.sql`).
- به پیام‌های خطا و سازگاری با SQL Server دقت کنید.
- از کاراکترهای براکت `[ ]` در نام‌گذاری استفاده شده است؛ Parser داخلی Zync با الگوهای «CREATE OR ALTER ... [dbo].[Name]» سازگار است.

---

## سوالات متداول (FAQ)

- چرا توضیحات آبجکت‌ها در `ls <package>` نمایش داده نمی‌شود؟
  - مطمئن شوید در ابتدای فایل آبجکت، خطی با `-- Description:` وجود دارد.
- ترتیب نصب وابستگی‌ها چطور رعایت می‌شود؟
  - اگر بلاک کامنت ابتدای فایل داشته باشید، Zync آن را قبل از بدنه‌ی اصلی اجرا می‌کند. برای پکیج‌ها، فایل شاخص `.sql` می‌تواند ترتیب نصب اعضا را تعیین کند.
- اگر شاخه‌ی ریپوی من `main` باشد چه کنم؟
  - هنگام فراخوانی Zync، پارامتر دوم را با URL شاخه‌ی `main` بدهید.

---

با رعایت این راهنما، می‌توانید به‌راحتی آبجکت‌های جدید بسازید، پکیج‌های تازه تعریف کنید و آن‌ها را در ریپوی اصلی یا شخصی خودتان منتشر نمایید. سپاس از مشارکت شما در Zync.

---

## ساخت پکیج از روی دیتابیس با اسکریپت خودکار

برای استخراج بخشی از آبجکت‌های یک دیتابیس (مثلاً همه‌ی جدول‌هایی که با «Base» شروع می‌شوند) و تبدیل آن‌ها به یک پکیج Zync، از اسکریپت زیر استفاده کنید:

- مسیر اسکریپت: `scripts/GenerateZyncPackageFromDb.ps1`
- خروجی نمونه: `MsSql/Packages/Base/`
- ویژگی مهم: ابتدا خود جدول‌ها بدون Foreign Key اسکریپت می‌شوند، سپس تمام کلیدهای خارجی در یک فایل واحد به نام `_ForeignKeys.sql` اسکریپت می‌گردند و در انتهای فایل شاخص پکیج اضافه می‌شوند تا ترتیب نصب ایمن باشد.

### پیش‌نیازها

- PowerShell (روی ویندوز) و دسترسی اجرای اسکریپت‌ها
- نصب بودن SMO (SQL Server Management Objects) یا ماژول PowerShell به نام `SqlServer`
  - اگر اسکریپت نتواند اسمبلی‌های SMO را بارگذاری کند، به‌صورت خودکار تلاش می‌کند ماژول `SqlServer` را Import کند
  - در صورت نیاز، می‌توانید ماژول را نصب کنید:
    - در PowerShell: `Install-Module -Name SqlServer -Scope CurrentUser`

### پارامترها

- `-ServerName` نام یا instance سرور SQL (پیش‌فرض: `.
SQL2022`)
- `-Database` نام دیتابیس (پیش‌فرض: `AppEndV2`)
- `-User`, `-Password` اعتبارنامه‌ی SQL Login (در حالت Windows Auth لازم نیست اما اسکریپت فعلی روی SQL Login تنظیم شده است)
- `-NamePrefix` پیشوند نام آبجکت‌ها برای فیلتر (مثلاً `Base`)
- `-OutputDir` مسیر خروجی برای پکیج تولیدشده (مثلاً `MsSql/Packages/Base`)

### مثال اجرا (Windows PowerShell)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "c:\Workspace\Projects\Zync\scripts\GenerateZyncPackageFromDb.ps1" `
  -ServerName ".\SQL2022" `
  -Database "AppEndV2" `
  -User "sa" `
  -Password "1" `
  -NamePrefix "Base" `
  -OutputDir "c:\Workspace\Projects\Zync\MsSql\Packages\Base"
```

### خروجی‌ها و ساختار پکیج تولیدی

- یک فایل برای هر جدول: مانند `BaseUser.sql`, `BaseInfo.sql`, ... (بدون FK)
- یک فایل مجزا برای همه‌ی FKها: `MsSql/Packages/<Prefix>/_ForeignKeys.sql`
- فایل شاخص پکیج: `MsSql/Packages/<Prefix>/.sql` که خطوط نصب را به ترتیب زیر دارد:
  - ابتدا تمام فایل‌های جدول
  - در انتها: `EXEC DBO.Zync 'i <Prefix>/_ForeignKeys.sql';`

با این چینش، نصب پکیج با دستور زیر انجام می‌شود:

```sql
EXEC dbo.Zync 'i Base';
```

و می‌توانید اقلام پکیج را لیست کنید:

```sql
EXEC dbo.Zync 'ls Base';
```

### نکات و رفع اشکال

- اگر پیام «Cycles detected among tables…» نمایش داده شد، طبیعی است؛ چون وابستگی‌های دوری ممکن است وجود داشته باشد. چون FKها جداگانه و در انتها اعمال می‌شوند، نصب امن است.
- اگر خطا درباره‌ی نوع جنریک `List[SMO.Urn]` دیدید، نسخه‌ی اسکریپت فعلی با آرایه‌ی ساده‌ی PowerShell کار می‌کند و این مشکل رفع شده است. مطمئن شوید آخرین نسخه را اجرا می‌کنید.
- اگر SMO در سیستم شما نصب نیست و Import ماژول `SqlServer` هم موفق نمی‌شود، ابتدا ماژول را نصب کنید یا SQL Server Management Studio/Feature Pack شامل SMO را اضافه نمایید.
- برای فیلتر کردن مجموعه‌ی دیگری از آبجکت‌ها، مقدار `-NamePrefix` را عوض کنید (مثلاً `Core` یا `User`).

### یکپارچه‌سازی با توسعه‌ی پکیج

- بعد از تولید پوشه‌ی پکیج، در صورت نیاز توضیحات هر فایل را با خط `-- Description:` تکمیل کنید تا در خروجی `ls` نمایش داده شود.
- یک `README.md` کوتاه برای پکیج بسازید (الگو در پکیج‌های موجود).
- در صورت تمایل می‌توانید ایندکس‌ها/Check Constraints را نیز مانند FKها جداگانه اسکریپت کنید (Feature پیشنهادی).
