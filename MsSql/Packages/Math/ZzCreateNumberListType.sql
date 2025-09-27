-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Creates a user-defined table type for a list of numbers.
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'NumberList')
BEGIN
    CREATE TYPE dbo.NumberList AS TABLE (Value DECIMAL(18, 5));
END
