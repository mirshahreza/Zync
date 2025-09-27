-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Creates a user-defined table type for a list of paired numbers (X, Y).
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'PairedNumberList')
BEGIN
    CREATE TYPE dbo.PairedNumberList AS TABLE (
        X DECIMAL(18, 5),
        Y DECIMAL(18, 5)
    );
END
