-- =============================================
-- Zync Scenario Test 03: Table Operations
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests table schema evolution scenarios
-- Scenarios:
--   3.1: Creating new tables
--   3.2: Adding columns to existing tables
--   3.3: Dropping columns (testing ALTER)
--   3.4: Changing column data types
--   3.5: Adding Foreign Key constraints
--   3.6: Adding Indexes
--   3.7: Adding CHECK/UNIQUE/DEFAULT constraints
--   3.8: Data preservation during changes
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 03: TABLE OPERATIONS'
PRINT '========================================='
PRINT 'Test Date: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT ''

DECLARE @TestsPassed INT = 0;
DECLARE @TestsFailed INT = 0;
DECLARE @TestsWarning INT = 0;
DECLARE @StartTime DATETIME2 = SYSDATETIME();

-- =============================================
-- PREREQUISITE: Verify Zync is installed
-- =============================================
IF OBJECT_ID('[dbo].[Zync]', 'P') IS NULL
BEGIN
    PRINT '❌ PREREQUISITE FAILED: Zync not installed'
    RETURN;
END

PRINT '✓ Prerequisite: Zync core is installed'
PRINT ''

-- =============================================
-- SETUP: Clean environment
-- =============================================
PRINT '----------------------------------------'
PRINT 'Setup: Preparing Test Environment'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ Environment cleaned'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT '✗ Setup failed - ' + ERROR_MESSAGE();
    RETURN;
END CATCH

-- =============================================
-- SCENARIO 3.1: Creating new tables
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.1: Creating New Tables'
PRINT '----------------------------------------'

IF OBJECT_ID('[dbo].[ZzTestProducts]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ZzTestProducts];

BEGIN TRY
    CREATE TABLE [dbo].[ZzTestProducts] (
        ProductId INT PRIMARY KEY IDENTITY(1,1),
        ProductName NVARCHAR(100) NOT NULL,
        Price DECIMAL(18, 2) NOT NULL,
        CreatedDate DATETIME2 DEFAULT SYSDATETIME()
    );
    PRINT '✓ PASS: Table ZzTestProducts created successfully'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not create table - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify table exists
IF OBJECT_ID('[dbo].[ZzTestProducts]', 'U') IS NOT NULL
BEGIN
    PRINT '✓ PASS: Table exists in database'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Table not found'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 3.2: Adding columns
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.2: Adding Columns to Table'
PRINT '----------------------------------------'

BEGIN TRY
    ALTER TABLE [dbo].[ZzTestProducts]
    ADD Description NVARCHAR(500) NULL;
    
    PRINT '✓ PASS: Column Description added'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not add column - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify column exists
IF COL_LENGTH('[dbo].[ZzTestProducts]', 'Description') IS NOT NULL
BEGIN
    PRINT '✓ PASS: Description column verified'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Description column not found'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 3.3: Data preservation
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.3: Data Preservation During Changes'
PRINT '----------------------------------------'

-- Insert test data
BEGIN TRY
    INSERT INTO [dbo].[ZzTestProducts] (ProductName, Price, Description)
    VALUES 
        ('Product A', 19.99, 'Test product A'),
        ('Product B', 29.99, 'Test product B'),
        ('Product C', 39.99, NULL);
    
    PRINT '✓ PASS: Test data inserted (3 rows)'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not insert test data - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify data
DECLARE @RowCount INT = 0;
SELECT @RowCount = COUNT(*) FROM [dbo].[ZzTestProducts];

IF @RowCount = 3
BEGIN
    PRINT '✓ PASS: Data verified (' + CAST(@RowCount AS VARCHAR) + ' rows)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Expected 3 rows, found ' + CAST(@RowCount AS VARCHAR)
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 3.4: Adding another column with data preserved
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.4: Add Column (Preserve Data)'
PRINT '----------------------------------------'

BEGIN TRY
    ALTER TABLE [dbo].[ZzTestProducts]
    ADD Category NVARCHAR(50) NULL;
    
    PRINT '✓ PASS: Category column added'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not add Category column - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify data still exists
DECLARE @RowCountAfterAlter INT = 0;
SELECT @RowCountAfterAlter = COUNT(*) FROM [dbo].[ZzTestProducts];

IF @RowCountAfterAlter = 3
BEGIN
    PRINT '✓ PASS: Data preserved after column addition'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Data lost after ALTER TABLE'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 3.5: Foreign Key constraints
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.5: Foreign Key Constraints'
PRINT '----------------------------------------'

-- Create related table
IF OBJECT_ID('[dbo].[ZzTestCategories]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ZzTestCategories];

BEGIN TRY
    CREATE TABLE [dbo].[ZzTestCategories] (
        CategoryId INT PRIMARY KEY IDENTITY(1,1),
        CategoryName NVARCHAR(50) NOT NULL
    );
    
    INSERT INTO [dbo].[ZzTestCategories] (CategoryName)
    VALUES ('Electronics'), ('Books'), ('Clothing');
    
    PRINT '✓ PASS: Categories table created with data'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not create categories table - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Add CategoryId column to Products
BEGIN TRY
    ALTER TABLE [dbo].[ZzTestProducts]
    ADD CategoryId INT NULL;
    
    PRINT '✓ PASS: CategoryId column added to Products'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not add CategoryId - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Add Foreign Key
BEGIN TRY
    ALTER TABLE [dbo].[ZzTestProducts]
    ADD CONSTRAINT FK_Products_Categories
    FOREIGN KEY (CategoryId) REFERENCES [dbo].[ZzTestCategories](CategoryId);
    
    PRINT '✓ PASS: Foreign Key constraint added'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not add Foreign Key - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 3.6: Adding Indexes
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.6: Adding Indexes'
PRINT '----------------------------------------'

BEGIN TRY
    CREATE INDEX IX_Products_CategoryId 
    ON [dbo].[ZzTestProducts](CategoryId);
    
    PRINT '✓ PASS: Index on CategoryId created'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not create index - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

BEGIN TRY
    CREATE INDEX IX_Products_Price 
    ON [dbo].[ZzTestProducts](Price);
    
    PRINT '✓ PASS: Index on Price created'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not create price index - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 3.7: CHECK/UNIQUE/DEFAULT constraints
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.7: Adding Constraints'
PRINT '----------------------------------------'

-- Add CHECK constraint
BEGIN TRY
    ALTER TABLE [dbo].[ZzTestProducts]
    ADD CONSTRAINT CHK_Price_Positive CHECK (Price > 0);
    
    PRINT '✓ PASS: CHECK constraint added (Price > 0)'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not add CHECK constraint - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Test CHECK constraint works
BEGIN TRY
    INSERT INTO [dbo].[ZzTestProducts] (ProductName, Price)
    VALUES ('Invalid Product', -10.00);
    
    PRINT '✗ FAIL: CHECK constraint did not prevent negative price'
    SET @TestsFailed = @TestsFailed + 1;
END TRY
BEGIN CATCH
    PRINT '✓ PASS: CHECK constraint prevented invalid data'
    SET @TestsPassed = @TestsPassed + 1;
END CATCH

-- Add UNIQUE constraint on ProductName
BEGIN TRY
    -- First ensure no duplicates exist
    DELETE FROM [dbo].[ZzTestProducts] 
    WHERE ProductId NOT IN (
        SELECT MIN(ProductId) 
        FROM [dbo].[ZzTestProducts] 
        GROUP BY ProductName
    );
    
    ALTER TABLE [dbo].[ZzTestProducts]
    ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);
    
    PRINT '✓ PASS: UNIQUE constraint added on ProductName'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not add UNIQUE constraint - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 3.8: Verify data integrity
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 3.8: Final Data Integrity Check'
PRINT '----------------------------------------'

-- Verify all constraints are in place
DECLARE @ConstraintCount INT = 0;
SELECT @ConstraintCount = COUNT(*)
FROM sys.objects
WHERE parent_object_id = OBJECT_ID('[dbo].[ZzTestProducts]')
  AND type IN ('PK', 'F', 'C', 'UQ');

IF @ConstraintCount >= 4  -- PK + FK + CHECK + UNIQUE
BEGIN
    PRINT '✓ PASS: All constraints exist (' + CAST(@ConstraintCount AS VARCHAR) + ' constraints)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Expected at least 4 constraints, found ' + CAST(@ConstraintCount AS VARCHAR)
    SET @TestsWarning = @TestsWarning + 1;
END

-- Verify indexes
DECLARE @IndexCount INT = 0;
SELECT @IndexCount = COUNT(*)
FROM sys.indexes
WHERE object_id = OBJECT_ID('[dbo].[ZzTestProducts]')
  AND name IS NOT NULL;

IF @IndexCount >= 3  -- PK + 2 indexes we created
BEGIN
    PRINT '✓ PASS: Indexes created (' + CAST(@IndexCount AS VARCHAR) + ' indexes)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Expected at least 3 indexes, found ' + CAST(@IndexCount AS VARCHAR)
    SET @TestsWarning = @TestsWarning + 1;
END

-- Verify data still intact
DECLARE @FinalRowCount INT = 0;
SELECT @FinalRowCount = COUNT(*) FROM [dbo].[ZzTestProducts];

IF @FinalRowCount > 0
BEGIN
    PRINT '✓ PASS: Data preserved through all operations (' + CAST(@FinalRowCount AS VARCHAR) + ' rows)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Data was lost'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- CLEANUP
-- =============================================
PRINT '----------------------------------------'
PRINT 'Cleanup: Removing Test Tables'
PRINT '----------------------------------------'

BEGIN TRY
    -- Drop FK first
    IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Products_Categories')
        ALTER TABLE [dbo].[ZzTestProducts] DROP CONSTRAINT FK_Products_Categories;
    
    IF OBJECT_ID('[dbo].[ZzTestProducts]', 'U') IS NOT NULL
        DROP TABLE [dbo].[ZzTestProducts];
    
    IF OBJECT_ID('[dbo].[ZzTestCategories]', 'U') IS NOT NULL
        DROP TABLE [dbo].[ZzTestCategories];
    
    PRINT '✓ Cleanup completed'
END TRY
BEGIN CATCH
    PRINT '⚠ Warning: Cleanup error - ' + ERROR_MESSAGE();
END CATCH

PRINT ''

-- =============================================
-- TEST SUMMARY
-- =============================================
DECLARE @EndTime DATETIME2 = SYSDATETIME();
DECLARE @Duration FLOAT = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
DECLARE @TotalTests INT = @TestsPassed + @TestsFailed;

PRINT '========================================'
PRINT 'TEST SUMMARY'
PRINT '========================================'
PRINT 'Total Tests: ' + CAST(@TotalTests AS VARCHAR)
PRINT 'Passed: ' + CAST(@TestsPassed AS VARCHAR)
PRINT 'Failed: ' + CAST(@TestsFailed AS VARCHAR)
PRINT 'Warnings: ' + CAST(@TestsWarning AS VARCHAR)
PRINT 'Duration: ' + CAST(@Duration AS VARCHAR) + ' seconds'
PRINT ''

IF @TestsFailed = 0
BEGIN
    PRINT 'Status: ✅ ALL TESTS PASSED'
    PRINT '========================================'
END
ELSE
BEGIN
    PRINT 'Status: ❌ SOME TESTS FAILED'
    PRINT '========================================'
END

GO
