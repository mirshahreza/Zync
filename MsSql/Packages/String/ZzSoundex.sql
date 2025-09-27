-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Indexes a string by its sound as pronounced in English.
-- Sample:
-- SELECT [dbo].[ZzSoundex]('Robert'), [dbo].[ZzSoundex]('Rupert');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzSoundex] (@InputString VARCHAR(MAX))
RETURNS VARCHAR(4)
AS
BEGIN
    RETURN SOUNDEX(@InputString);
END
