-- Quick test of clean command
PRINT 'Testing clean command...'

-- Simple test 
IF OBJECT_ID('[dbo].[Zync]', 'P') IS NOT NULL
	EXEC [dbo].[Zync] 'clean'
ELSE
	PRINT 'Zync procedure not found. Skipping clean.'

PRINT 'Clean command completed.'