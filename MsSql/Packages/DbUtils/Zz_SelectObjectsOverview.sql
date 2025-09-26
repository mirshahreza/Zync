/*
EXEC Zzz_Deploy 'DbUtils/Zz_SelectObjectsDetails.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-25
-- Description:	Select all objects (Table,View,Procedure,ScalarFunction,TableValuedFunction) types and counts
-- =============================================
CREATE OR ALTER VIEW [DBO].[Zz_SelectObjectsOverview]
AS

SELECT [ObjectType],COUNT(*) ObjectsCount
  FROM [zz_SelectObjectsDetails]
  GROUP BY [ObjectType]
