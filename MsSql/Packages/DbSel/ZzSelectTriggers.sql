-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-09-28
-- Description:   Lists DML triggers with target object, type, enabled state, and actions (INSERT/UPDATE/DELETE).
-- Sample:
-- SELECT * FROM [dbo].[ZzSelectTriggers];
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectTriggers]
AS
SELECT 
    tr.name                                                      AS TriggerName,
    sch.name                                                     AS SchemaName,
    parentObj.name                                               AS ParentObjectName,
    CASE parentObj.type_desc WHEN 'USER_TABLE' THEN 'Table' WHEN 'VIEW' THEN 'View' ELSE parentObj.type_desc END AS ParentObjectType,
    CASE WHEN tr.is_disabled = 0 THEN 1 ELSE 0 END               AS IsEnabled,
    OBJECTPROPERTY(tr.object_id, 'ExecIsInsertTrigger')          AS ForInsert,
    OBJECTPROPERTY(tr.object_id, 'ExecIsUpdateTrigger')          AS ForUpdate,
    OBJECTPROPERTY(tr.object_id, 'ExecIsDeleteTrigger')          AS ForDelete,
    OBJECTPROPERTY(tr.parent_id, 'TableHasAfterTriggers')        AS IsAfterTrigger,
    OBJECTPROPERTY(tr.parent_id, 'TableHasInsteadOfTriggers')    AS IsInsteadOfTrigger,
    o.create_date                                                AS CreatedOn,
    o.modify_date                                                AS UpdatedOn
FROM sys.triggers tr
JOIN sys.objects o       ON o.object_id = tr.object_id
JOIN sys.objects parentObj ON parentObj.object_id = tr.parent_id
JOIN sys.schemas sch     ON sch.schema_id = parentObj.schema_id
WHERE tr.is_ms_shipped = 0;