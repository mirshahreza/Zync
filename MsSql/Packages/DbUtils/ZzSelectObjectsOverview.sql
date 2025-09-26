/*
EXEC DBO.Zync 'DbUtils/ZzSelectObjectsDetails.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-25
-- Description:	Select all objects (Table,View,Procedure,ScalarFunction,TableValuedFunction) types and counts
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectObjectsOverview]
AS

SELECT [ObjectType],COUNT(*) ObjectsCount
  FROM [ZzSelectObjectsDetails]
  GROUP BY [ObjectType]
