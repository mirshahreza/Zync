-- Test clean command to remove all Zync objects
PRINT 'Testing clean command to remove all Zync objects...'
PRINT ''

-- First show current objects
PRINT 'Current Zync objects in database:'
SELECT 
    name as ObjectName,
    type_desc as ObjectType,
    create_date as CreatedDate
FROM sys.objects 
WHERE name LIKE 'Zz%' 
ORDER BY type_desc, name

PRINT ''
PRINT 'Executing clean command...'

-- Execute clean command
EXEC [dbo].[Zync] 'clean'

PRINT ''
PRINT 'Objects remaining after clean:'
SELECT 
    name as ObjectName,
    type_desc as ObjectType,
    create_date as CreatedDate
FROM sys.objects 
WHERE name LIKE 'Zz%' 
ORDER BY type_desc, name

-- Also check types
SELECT 
    name as TypeName,
    'USER_DEFINED_TYPE' as ObjectType
FROM sys.types 
WHERE name LIKE 'Zz%' AND is_user_defined = 1