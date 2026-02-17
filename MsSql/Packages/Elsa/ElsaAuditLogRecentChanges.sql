-- ==================================================================================
-- Elsa Audit Log Recent Changes
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaAuditLogRecentChanges] AS
SELECT TOP 100
    [EntityType],
    [EntityId],
    [Action],
    [ChangedBy],
    [ChangedAt],
    [IpAddress]
FROM [dbo].[ElsaAuditLogs]
ORDER BY [ChangedAt] DESC;
