-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2026-01-07
-- Description:	Calculates new Id based on the new node level.
-- Sample:
-- EXEC [dbo].[ZzCalculateHID] 'MyTable', NULL, 3, 3, '.'
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[ZzCalculateHID]
    @TableName NVARCHAR(128) ,
    @ParentId VARCHAR(MAX),
    @ChildDigits INT = 3,
    @Delimiter VARCHAR(1) = '.'  
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql NVARCHAR(MAX);
    DECLARE @Prefix VARCHAR(MAX) = '';
    DECLARE @TargetDigits INT;
    DECLARE @StartNumber INT;
    DECLARE @EndNumber INT;

    IF(@ParentId = '') SET @ParentId = NULL;
    SET @TargetDigits = @ChildDigits;

    IF @ParentId IS NULL
    BEGIN
        SET @Prefix = '';
        SET @StartNumber = POWER(10, @TargetDigits - 1);
    END
    ELSE
    BEGIN
        SET @Prefix = @ParentId + @Delimiter;
        SET @StartNumber = 1; 
    END

    SET @EndNumber = POWER(10, @TargetDigits) - 1;

    SET @Sql = N'
    ;WITH Seq AS (
        SELECT ' + CAST(@StartNumber AS NVARCHAR) + N' AS Num
        UNION ALL
        SELECT Num + 1 FROM Seq WHERE Num < ' + CAST(@EndNumber AS NVARCHAR) + N'
    ),
    Existing AS (
        SELECT 
            TRY_CAST(REPLACE(Id, @Pre, '''') AS INT) AS LastPart
        FROM ' + QUOTENAME(@TableName) + N'
        WHERE (ParentId = @PId OR (@PId IS NULL AND ParentId IS NULL))
          AND Id LIKE @Pre + ''%''
    )
    SELECT TOP 1 
        @Pre + RIGHT(REPLICATE(''0'', @Digits) + CAST(Seq.Num AS NVARCHAR), @Digits) AS NewId
    FROM Seq
    LEFT JOIN Existing ON Seq.Num = Existing.LastPart
    WHERE Existing.LastPart IS NULL
    ORDER BY Seq.Num
    OPTION (MAXRECURSION 0);';

    EXEC sp_executesql @Sql, 
        N'@PId VARCHAR(MAX), @Pre VARCHAR(MAX), @Digits INT', 
        @ParentId, @Prefix, @TargetDigits;
END