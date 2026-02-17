-- =============================================
-- Test: Elsa 3.0 Package Installation via Zync
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

PRINT '========================================='
PRINT 'Installing Elsa 3.0 Package via Zync'
PRINT '========================================='

-- Install the complete Elsa package
EXEC DBO.Zync 'i Elsa/Elsa.sql'

PRINT ''
PRINT '========================================='
PRINT 'Post-Installation Verification'
PRINT '========================================='

-- Test 1: Verify tables
PRINT ''
PRINT 'Test 1: TABLE VERIFICATION'
DECLARE @TableCount INT = 0
SELECT @TableCount = COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables found: ' + CAST(@TableCount AS VARCHAR)
IF @TableCount >= 14
  PRINT '✓ PASS: Expected tables created'
ELSE
  PRINT '✗ FAIL: Expected 14+ tables but found ' + CAST(@TableCount AS VARCHAR)

-- Test 2: Verify views
PRINT ''
PRINT 'Test 2: VIEW VERIFICATION'
DECLARE @ViewCount INT = 0
SELECT @ViewCount = COUNT(*)
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Views found: ' + CAST(@ViewCount AS VARCHAR)
IF @ViewCount >= 16
  PRINT '✓ PASS: Expected views created'
ELSE
  PRINT '✗ FAIL: Expected 16+ views but found ' + CAST(@ViewCount AS VARCHAR)

-- Test 3: Verify specific tables
PRINT ''
PRINT 'Test 3: SPECIFIC TABLE CHECK'
DECLARE @SpecificCheck INT = 0
SELECT @SpecificCheck = COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME IN (
  'ElsaWorkflowDefinitions',
  'ElsaWorkflowInstances',
  'ElsaActivityExecutions',
  'ElsaApprovalInstances',
  'ElsaAuditLogs'
)

IF @SpecificCheck = 5
  PRINT '✓ PASS: Core tables verified'
ELSE
  PRINT '✗ FAIL: Some core tables missing'

-- Test 4: Check primary keys
PRINT ''
PRINT 'Test 4: PRIMARY KEY VERIFICATION'
DECLARE @PKCheck INT = 0
SELECT @PKCheck = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'dbo' 
  AND CONSTRAINT_NAME LIKE 'PK_%'
  AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables with primary keys: ' + CAST(@PKCheck AS VARCHAR)
IF @PKCheck >= 10
  PRINT '✓ PASS: Primary keys configured'
ELSE
  PRINT '✗ FAIL: Some tables missing primary keys'

-- Test 5: Check soft delete columns
PRINT ''
PRINT 'Test 5: SOFT DELETE SUPPORT'
DECLARE @SoftDeleteCheck INT = 0
SELECT @SoftDeleteCheck = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND COLUMN_NAME = 'IsDeleted'
  AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables with IsDeleted: ' + CAST(@SoftDeleteCheck AS VARCHAR)
IF @SoftDeleteCheck >= 5
  PRINT '✓ PASS: Soft delete support in place'
ELSE
  PRINT '✗ FAIL: Limited soft delete support'

-- Test 6: Check multi-tenancy
PRINT ''
PRINT 'Test 6: MULTI-TENANCY SUPPORT'
DECLARE @TenantCheck INT = 0
SELECT @TenantCheck = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND COLUMN_NAME = 'TenantId'
  AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables with TenantId: ' + CAST(@TenantCheck AS VARCHAR)
IF @TenantCheck >= 8
  PRINT '✓ PASS: Multi-tenancy support implemented'
ELSE
  PRINT '✗ FAIL: Limited multi-tenancy support'

-- Test 7: Query a view
PRINT ''
PRINT 'Test 7: VIEW EXECUTION TEST'
BEGIN TRY
  DECLARE @ViewTest INT
  SELECT @ViewTest = COUNT(*) FROM [dbo].[ElsaWorkflowStatusOverview]
  PRINT '✓ PASS: ElsaWorkflowStatusOverview view is executable'
END TRY
BEGIN CATCH
  PRINT '✗ FAIL: Error executing ElsaWorkflowStatusOverview - ' + ERROR_MESSAGE()
END CATCH

PRINT ''
PRINT '========================================='
PRINT 'Test Summary'
PRINT '========================================='
PRINT 'Elsa 3.0 Package Installation Complete'
PRINT 'Database: ' + DB_NAME()
PRINT 'Schema: dbo'
PRINT 'Tables: ' + CAST(@TableCount AS VARCHAR)
PRINT 'Views: ' + CAST(@ViewCount AS VARCHAR)
PRINT ''
PRINT 'Status: READY FOR WORKFLOW EXECUTION'
PRINT '========================================='
