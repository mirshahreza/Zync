-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-14
-- Description:	Select all parameters for Procedures and Functions
-- =============================================
CREATE OR ALTER VIEW [DBO].[Zz_SelectProceduresFunctionsParameters]
AS

SELECT 
   SCHEMA_NAME(SO.SCHEMA_ID) AS [Schema],
   SO.Name AS [ObjectName],
   SO.Type_Desc AS [ObjectType],
   PM.Parameter_ID AS [ViewOrder],
   CASE WHEN PM.Parameter_ID = 0 THEN 'Returns' ELSE PM.Name END AS [ParameterName],
   TYPE_NAME(PM.User_Type_ID) AS [ParameterDataType],
   CASE
      WHEN TYPE_NAME(PM.User_Type_ID) IN ('float', 'uniqueidentifier', 'datetime', 'bit', 'bigint', 'int', 'image', 'money', 'xml', 'varbinary', 'tinyint', 'text', 'ntext', 'smallint', 'smallmoney') THEN ''
      WHEN TYPE_NAME(PM.User_Type_ID) IN ('decimal', 'numeric') THEN '(' + CAST( PM.Precision AS VARCHAR(4) ) + ', ' + CAST( PM.Scale AS VARCHAR(4)) + ')'
      WHEN PM.Max_Length = -1 THEN '(Max)'
      WHEN TYPE_NAME(PM.User_Type_ID) IN ('nvarchar', 'nchar' ) THEN CAST( PM.Max_Length/2 AS VARCHAR(5))
      ELSE CAST( PM.Max_Length AS VARCHAR(5))
      END AS [Size],
   CASE WHEN PM.Is_Output = 1 THEN 'Output' ELSE 'Input' END AS [Direction]
FROM SYS.OBJECTS AS SO
INNER JOIN SYS.PARAMETERS AS PM ON SO.OBJECT_ID = PM.OBJECT_ID
WHERE SO.TYPE IN ('P','FN','IF')
