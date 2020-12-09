:setvar DatabaseName "EventMonitoring"
:setvar DBPhysicalPath "E:\Database\2019\EventMonitoring\"

USE [$(DatabaseName)]
GO

DROP SERVICE BlockedProcessReportService
DROP QUEUE BlockedProcessReportQueue
DROP EVENT NOTIFICATION BlockedProcessReport ON SERVER ;

CREATE QUEUE BlockedProcessReportQueue;
GO

CREATE SERVICE BlockedProcessReportService
ON QUEUE BlockedProcessReportQueue
([http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]); --Bắt buộc phải có link này
GO

--OPTIONAL: Dùng khi chạy Service Broker trên production DB
CREATE ROUTE BlockedProcessReportRoute
WITH SERVICE_NAME = 'BlockedProcessReportService',
ADDRESS = 'LOCAL';
GO

DROP EVENT NOTIFICATION notify_locks ON SERVER ;
CREATE EVENT NOTIFICATION BlockedProcessReport
ON SERVER
WITH FAN_IN
FOR BLOCKED_PROCESS_REPORT
TO SERVICE 'BlockedProcessReportService','current database'; 
GO

