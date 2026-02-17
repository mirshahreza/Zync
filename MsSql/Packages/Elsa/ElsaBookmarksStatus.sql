-- ==================================================================================
-- Elsa Bookmarks Status
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaBookmarksStatus] AS
SELECT
    SUM(CASE WHEN [IsProcessed] = 0 THEN 1 ELSE 0 END) AS [PendingBookmarks],
    SUM(CASE WHEN [IsProcessed] = 1 THEN 1 ELSE 0 END) AS [ProcessedBookmarks],
    COUNT(*) AS [TotalBookmarks]
FROM [dbo].[ElsaBookmarks];
