/*
EXEC DBO.Zync 'DbSel/ZzSelectObjectsDetails.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-25
-- Description:	Provides a summary count of all database objects, grouped by their type (e.g., Table, View, Procedure).
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectObjectsOverview];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectObjectsOverview]
AS

SELECT [ObjectType],COUNT(*) ObjectsCount
  FROM [ZzSelectObjectsDetails]
  GROUP BY [ObjectType]
