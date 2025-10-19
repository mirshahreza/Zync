-- Step 1: Inspect existing objects
PRINT '=== List of existing objects ==='
SELECT 
    name as ObjectName,
    CASE type
        WHEN 'P' THEN 'PROCEDURE'
        WHEN 'FN' THEN 'FUNCTION'
        WHEN 'TF' THEN 'FUNCTION'
        WHEN 'IF' THEN 'FUNCTION'
        WHEN 'V' THEN 'VIEW'
    END as ObjectType,
    type
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type IN ('P', 'FN', 'TF', 'IF', 'V')
ORDER BY name

PRINT ''
PRINT '=== List of existing TYPEs ==='
SELECT 
    name as TypeName,
    'TYPE' as ObjectType
FROM sys.types 
WHERE name LIKE 'Zz%' AND is_user_defined = 1
ORDER BY name

PRINT ''
PRINT '=== Check tracking tables ==='
IF OBJECT_ID('[dbo].[ZyncPackages]') IS NOT NULL
BEGIN
    PRINT 'ZyncPackages table exists:'
    SELECT PackageName, Status, Version, InstallDate FROM [dbo].[ZyncPackages]
END
ELSE
    PRINT 'ZyncPackages table does not exist'

IF OBJECT_ID('[dbo].[ZyncObjects]') IS NOT NULL
BEGIN
    PRINT 'ZyncObjects table exists:'
    SELECT ObjectName, ObjectType, PackageId FROM [dbo].[ZyncObjects]
END
ELSE
    PRINT 'ZyncObjects table does not exist'