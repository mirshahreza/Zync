-- ==================================================================================
-- Elsa Recently Modified Workflows
-- ==================================================================================
CREATE OR ALTER VIEW [dbo].[ElsaRecentlyModifiedWorkflows] AS
SELECT TOP 20
    wd.[Id],
    wd.[Name],
    wd.[Version],
    wd.[IsPublished],
    wd.[UpdatedAt],
    DATEDIFF(HOUR, wd.[UpdatedAt], GETUTCDATE()) AS [HoursAgo]
FROM [dbo].[ElsaWorkflowDefinitions] wd
WHERE wd.[IsDeleted] = 0
ORDER BY wd.[UpdatedAt] DESC;

