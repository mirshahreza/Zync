-- ==================================================================================
-- Elsa Database Size Information
-- ==================================================================================

GO
CREATE OR ALTER VIEW [dbo].[ElsaDatabaseSizeInformation] AS
SELECT TOP 1000000
    t.[name] AS [TableName],
    SUM(p.[rows]) AS [RowCount],
    (SUM(a.[total_pages]) * 8.0 / 1024.0) AS [SizeMB]
FROM
    sys.tables t
    INNER JOIN sys.indexes i ON t.[object_id] = i.[object_id]
    INNER JOIN sys.partitions p ON i.[object_id] = p.[object_id] AND i.[index_id] = p.[index_id]
    INNER JOIN sys.allocation_units a ON p.[partition_id] = a.[container_id]
WHERE
    t.[name] LIKE 'Elsa%'
    AND i.[index_id] <= 1
GROUP BY
    t.[name]
ORDER BY
    [SizeMB] DESC;
GO
