-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-01
-- Description:	A view that provides detailed metadata about all columns in every table and view, including data type, nullability, primary key status, and default values.
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectTablesViewsColumns];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectTablesViewsColumns]
AS

SELECT 
	OBJS.object_id ObjectId,
	OBJS.NAME ParentObjectName,
	C.NAME ColumnName,
	C.column_id ColumnId,
    UPPER(T.NAME) ColumnType,
    ISNULL((
		SELECT CAST(COUNT(*) AS BIT)
		FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
		WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'ISPRIMARYKEY') = 1
			AND TABLE_NAME = OBJS.NAME AND COLUMN_NAME=C.NAME
	), 0) IsPrimaryKey,
    C.IS_NULLABLE AllowNull,
	(
		CASE 
			-- Character/binary types with length in parentheses
			WHEN T.NAME IN ('VARCHAR','CHAR','VARBINARY','BINARY') THEN 
				CASE WHEN C.MAX_LENGTH = -1 THEN NULL ELSE C.MAX_LENGTH END

			-- NVARCHAR/NCHAR store length in bytes; divide by 2 for characters
			WHEN T.NAME IN ('NVARCHAR','NCHAR') THEN 
				CASE WHEN C.MAX_LENGTH = -1 THEN NULL ELSE C.MAX_LENGTH/2 END

			-- DECIMAL/NUMERIC have (precision, scale); report precision
			WHEN T.NAME IN ('DECIMAL','NUMERIC') THEN C.PRECISION

			-- FLOAT(n) reports the mantissa precision in parentheses
			WHEN T.NAME = 'FLOAT' THEN C.PRECISION

			-- DATETIME2/TIME/DATETIMEOFFSET have fractional seconds precision in parentheses
			WHEN T.NAME IN ('DATETIME2','TIME','DATETIMEOFFSET') THEN C.SCALE

			-- VECTOR stores float32 elements (4 bytes each); derive dimension from max_length
			WHEN T.NAME = 'VECTOR' THEN 
				CASE WHEN C.MAX_LENGTH IS NULL OR C.MAX_LENGTH = -1 THEN NULL ELSE C.MAX_LENGTH/4 END

			ELSE NULL
		END
	) MaxLen,
	C.IS_IDENTITY IsIdentity,
	(SELECT SEED_VALUE		FROM SYS.IDENTITY_COLUMNS IDNT	WHERE IDNT.OBJECT_ID=C.OBJECT_ID AND IDNT.COLUMN_ID=C.COLUMN_ID) IdentityStart,
	(SELECT INCREMENT_VALUE FROM SYS.IDENTITY_COLUMNS IDNT	WHERE IDNT.OBJECT_ID=C.OBJECT_ID AND IDNT.COLUMN_ID=C.COLUMN_ID) IdentityStep,
	REPLACE(REPLACE(REPLACE(DEF.DEFINITION,'(',''),')',''),'''','') DbDefault,
	C.COLUMN_ID ViewOrder
FROM			SYS.COLUMNS C
INNER JOIN		SYS.TYPES T					ON C.USER_TYPE_ID = T.USER_TYPE_ID
LEFT OUTER JOIN SYS.DEFAULT_CONSTRAINTS DEF ON DEF.PARENT_OBJECT_ID = C.OBJECT_ID AND DEF.PARENT_COLUMN_ID = C.COLUMN_ID
LEFT OUTER JOIN SYS.OBJECTS OBJS ON OBJS.OBJECT_ID=C.OBJECT_ID
