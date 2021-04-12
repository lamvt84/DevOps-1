CREATE QUEUE [dbo].[BlockedProcessReportQueue]
    WITH ACTIVATION (STATUS = ON, PROCEDURE_NAME = [dbo].[sp_ProcessBlockProcessReports], MAX_QUEUE_READERS = 1, EXECUTE AS OWNER);

