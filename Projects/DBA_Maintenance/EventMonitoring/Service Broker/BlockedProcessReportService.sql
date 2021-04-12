CREATE SERVICE [BlockedProcessReportService]
    AUTHORIZATION [dbo]
    ON QUEUE [dbo].[BlockedProcessReportQueue]
    ([http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]);

