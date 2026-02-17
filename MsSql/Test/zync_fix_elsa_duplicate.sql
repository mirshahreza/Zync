-- Fix: Remove existing Elsa package from Zync registry and reinstall
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

PRINT 'Removing existing Elsa package from Zync registry...'

-- Remove from Zync registry
DELETE FROM [dbo].[ZyncPackages] WHERE [PackageName] = 'Elsa'

PRINT 'Old Elsa package registration removed.'
PRINT ''
PRINT 'Now installing fresh Elsa 3.0 package...'
PRINT ''

-- Install fresh
EXEC DBO.Zync 'i Elsa/Elsa.sql'

PRINT ''
PRINT 'Installation complete!'
