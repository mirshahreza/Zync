-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Formats a numeric amount as localized currency.
-- Sample:		SELECT [dbo].[ZzFormatCurrency](12345.67, 'fa-IR');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzFormatCurrency] (@amount DECIMAL(18, 2), @culture NVARCHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
    RETURN FORMAT(@amount, 'C', @culture);
END

