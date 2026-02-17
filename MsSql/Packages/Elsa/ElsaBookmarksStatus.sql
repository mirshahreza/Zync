-- ==================================================================================
-- Elsa Bookmarks Status
-- ==================================================================================

GO
CREATE OR ALTER VIEW [dbo].[ElsaBookmarksStatus] AS
SELECT TOP 1000000
    [ActivityType],
    COUNT(*) AS [BookmarkCount],
    SUM(CASE WHEN [IsProcessed] = 0 THEN 1 ELSE 0 END) AS [PendingBookmarks],
    SUM(CASE WHEN [IsProcessed] = 1 THEN 1 ELSE 0 END) AS [ProcessedBookmarks]
FROM [dbo].[ElsaBookmarks]
GROUP BY [ActivityType]
ORDER BY [PendingBookmarks] DESC;
GO
