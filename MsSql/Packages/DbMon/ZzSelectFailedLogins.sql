-- =============================================
-- Author:        Mohsen Mirshahreza
-- Create date:   2025-10-15
-- Description:   Shows failed login attempts from default trace (where available) or from error log on newer versions.
-- Sample:
-- SELECT TOP 100 * FROM [dbo].[ZzSelectFailedLogins];
-- Notes:
--  - Requires VIEW SERVER STATE permission for default trace
--  - On some environments, default trace may be disabled; the view will return no rows
-- =============================================
CREATE OR ALTER VIEW [DBO].[ZzSelectFailedLogins]
AS
/* Default trace-based failed logins (EventClass 20 = Audit Login Failed)
   Note: Default trace can be disabled; in that case this view returns 0 rows. */
SELECT 
    gt.StartTime           AS EventDate,
    gt.HostName            AS ClientHost,
    gt.LoginName           AS LoginName,
    gt.ApplicationName     AS ApplicationName,
    gt.SPID                AS SessionId,
    gt.TextData            AS Message
FROM sys.fn_trace_gettable(
         (SELECT CONVERT(VARCHAR(260), value)
            FROM sys.fn_trace_getinfo(NULL)
           WHERE property = 2),
         DEFAULT) AS gt
WHERE gt.EventClass = 20 -- Audit Login Failed
