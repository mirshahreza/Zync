-- ==================================================================================
-- Elsa Audit Log Recent Changes
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaAuditLogRecentChanges] AS
SELECT TOP 100
    [Id],
    [EntityType],
    [EntityId],
    [Action],
    [Changes],
    [ChangedBy],
    [ChangedAt],
    DATEDIFF(MINUTE, [ChangedAt], GETUTCDATE()) AS [MinutesAgo]
FROM [dbo].[ElsaAuditLogs]
WHERE [ChangedAt] >= DATEADD(DAY, -7, GETUTCDATE())
ORDER BY [ChangedAt] DESC;
GO
