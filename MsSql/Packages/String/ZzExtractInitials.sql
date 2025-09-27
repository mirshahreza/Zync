-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Extracts the initials from a full name.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzExtractInitials] (@FullName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Initials NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    DECLARE @IsFirstLetter BIT = 1;

    SET @FullName = LTRIM(RTRIM(@FullName));

    WHILE @i <= LEN(@FullName)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@FullName, @i, 1);
        IF @IsFirstLetter = 1 AND @Char LIKE '[A-Za-z]'
        BEGIN
            SET @Initials = @Initials + UPPER(@Char);
            SET @IsFirstLetter = 0;
        END
        ELSE IF @Char = ' '
        BEGIN
            SET @IsFirstLetter = 1;
        END
        SET @i = @i + 1;
    END

    RETURN @Initials;
END
