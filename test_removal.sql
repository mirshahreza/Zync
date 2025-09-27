-- Test script to verify removal functionality works properly

-- First, let's see what objects currently exist
PRINT 'Current objects in database:'
SELECT name, type_desc FROM sys.objects WHERE name LIKE 'Zz%' ORDER BY name;

-- Check what packages are tracked
PRINT 'Currently tracked packages:'
SELECT PackageName, Status, Version FROM [dbo].[ZyncPackages];

-- Check what objects are tracked  
PRINT 'Currently tracked objects:'
SELECT ObjectName, ObjectType FROM [dbo].[ZyncObjects];

-- Now test removing DbMan package (which should contain many objects)
PRINT 'Testing removal of DbMan package...'
EXEC [dbo].[Zync] 'rm DbMan';

-- Check what's left after removal
PRINT 'Objects after removal:'
SELECT name, type_desc FROM sys.objects WHERE name LIKE 'Zz%' ORDER BY name;

-- Check tracking tables after removal
PRINT 'Packages after removal:'
SELECT PackageName, Status, Version FROM [dbo].[ZyncPackages];

PRINT 'Objects after removal:'
SELECT ObjectName, ObjectType FROM [dbo].[ZyncObjects];