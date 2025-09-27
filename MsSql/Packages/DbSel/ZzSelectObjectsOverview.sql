/*
EXEC DBO.Zync 'DbUtils/ZzSelectObjectsDetails.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-25
-- Description:	Provides a summary count of all database objects, grouped by their type (e.g., Table, View, Procedure).
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectObjectsOverview]
AS

SELECT [ObjectType],COUNT(*) ObjectsCount
  FROM [ZzSelectObjectsDetails]
  GROUP BY [ObjectType]
