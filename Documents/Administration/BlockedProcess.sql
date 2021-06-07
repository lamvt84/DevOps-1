/* PRE-INSTALLATION 
+ Create Folder CertPath
+ Add user NT SERVICE\MSSQLSERVER to CertPath with full control
+ Run script with SQLCMD Enable (Alt + Q + M in SSMS)
*/

:Setvar DatabaseName "DBAMonitoring"
:Setvar CertName "DBAMonitoringCert"
:Setvar CertPath "C:\Cert\"
:Setvar CertEncryptPass "Dba===1111AAA"
:Setvar TrustedLogin "DBAMonitoringLogin"

USE [master]
GO
sp_configure 'show advanced options', 1 ;  
GO  
RECONFIGURE ;  
GO  
sp_configure 'blocked process threshold', 20 ;  -- blocking in 20 seconds and more
GO  
RECONFIGURE ;  
GO

USE [$(DatabaseName)]
GO
ALTER DATABASE [$(DatabaseName)] SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE
GO
CREATE TABLE [dbo].[BlockedProcessReports] (
    [id]                     BIGINT         IDENTITY (1, 1) NOT NULL,
    [database_name]          [sysname]      NULL,
    [post_time]              DATETIME       NULL,
    [insert_time]            DATETIME       CONSTRAINT [DF_BlockedProcessReports_InsertTime] DEFAULT (getdate()) NULL,
    [wait_time]              INT            NULL,
    [blocked_xactid]         BIGINT         NULL,
    [blocking_xactid]        BIGINT         NULL,
    [is_blocking_source]     BIT            NULL,
    [blocked_inputbuf]       NVARCHAR (MAX) NULL,
    [blocking_inputbuf]      NVARCHAR (MAX) NULL,
    [blocked_process_report] XML            NULL,
    CONSTRAINT [PK_BlockedProcessReports] PRIMARY KEY CLUSTERED ([id] ASC)
);

CREATE NONCLUSTERED INDEX [IX_BlockingXactId_BlockedXactId_WaitTime]
    ON [dbo].[BlockedProcessReports]([blocking_xactid] ASC, [blocked_xactid] ASC, [wait_time] ASC);

CREATE NONCLUSTERED INDEX [IX_PostTime_IsBlockingSource]
    ON [dbo].[BlockedProcessReports]([post_time] ASC, [is_blocking_source] ASC)
    INCLUDE([wait_time], [blocked_xactid], [blocking_xactid], [blocking_inputbuf]);
GO
CREATE PROCEDURE [dbo].[usp_Dba_ProcessBlockProcessReports]
WITH EXECUTE AS OWNER
AS
BEGIN 
	SET NOCOUNT ON;
	DECLARE @message_body XML,
			@message_type INT,
			@subject VARCHAR(MAX),
			@body VARCHAR(MAX),
			@dialog UNIQUEIDENTIFIER,
			@dbName VARCHAR(50),
			--@blockedQuery NVARCHAR(MAX),
			--@blockingQuery NVARCHAR(MAX),
			@lastBlockedXactId BIGINT,
			@lastBlockingXactId BIGINT,
			@isBlkSource BIT,
			@blockedSQLText NVARCHAR(MAX),
			@blockingSQLText NVARCHAR(MAX),
			@lastId BIGINT,
			@emailQueue INT,
			@receipt_db NVARCHAR(MAX);

	WHILE (1 = 1)
	BEGIN
		BEGIN TRANSACTION;
			-- Receive the next available message from the queue
			WAITFOR
			(
				RECEIVE TOP (1) @message_type = message_type_id,
								@message_body = CAST(message_body AS XML),
								@dialog = conversation_handle
				FROM dbo.BlockedProcessReportQueue
			),
			TIMEOUT 1000;

			-- If we didn't get anything, bail out
			IF (@@ROWCOUNT = 0)
			BEGIN
				ROLLBACK TRANSACTION;
				BREAK;
			END;

			------------------------------------------------
			-- Log block events
			INSERT INTO [dbo].[BlockedProcessReports]
			(
				database_name,
				post_time,
				wait_time,
				blocked_xactid,
				blocking_xactid,
				is_blocking_source,
				blocked_inputbuf,
				blocking_inputbuf,
				blocked_process_report
			)
			SELECT DB_NAME(CAST(@message_body AS XML).value('(/EVENT_INSTANCE/DatabaseID)[1]', 'int')) AS database_name,
				   CAST(@message_body AS XML).value('(/EVENT_INSTANCE/PostTime)[1]', 'datetime') AS post_time,
				   CAST(@message_body AS XML).value(
													   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocked-process[1]/process[1]/@waittime',
													   'int'
												   ) AS wait_time,
				   CAST(@message_body AS XML).value(
													   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocked-process[1]/process[1]/@xactid',
													   'bigint'
												   ) AS blocked_xactid,
				   CAST(@message_body AS XML).value(
													   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocking-process[1]/process[1]/@xactid',
													   'bigint'
												   ) AS blocking_xactid,
				   CASE
					   WHEN (CAST(@message_body AS XML).value(
																 '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocking-process[1]/process[1]/@waitresource',
																 'nvarchar(max)'
															 ) IS NULL
							) THEN
						   1
					   ELSE
						   0
				   END AS is_blocking_source,
				   CAST(@message_body AS XML).value(
													   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocked-process[1]/process[1]/inputbuf[1]',
													   'nvarchar(max)'
												   ) AS blocked_inputbuf,
				   CAST(@message_body AS XML).value(
													   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocking-process[1]/process[1]/inputbuf[1]',
													   'nvarchar(max)'
												   ) AS blocking_inputbuf,
				   CAST(@message_body AS XML).query('(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]') AS blocked_process_report;
		COMMIT TRANSACTION;
	END
END
GO
/* Service Broker */
USE [$(DatabaseName)]
GO
IF EXISTS (SELECT 1/0 FROM sys.services WHERE name = 'BlockedProcessReportService')
    DROP SERVICE BlockedProcessReportService
IF EXISTS (SELECT 1/0 FROM sys.service_queues WHERE name = 'BlockedProcessReportQueue')
    DROP QUEUE BlockedProcessReportQueue
IF EXISTS (SELECT 1/0 FROM sys.server_event_notifications WHERE name = 'BlockedProcessReport')
    DROP EVENT NOTIFICATION BlockedProcessReport ON SERVER
GO
CREATE QUEUE BlockedProcessReportQueue
CREATE SERVICE BlockedProcessReportService
    ON QUEUE BlockedProcessReportQueue
    (
        [http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]
    )
CREATE EVENT NOTIFICATION BlockedProcessReport ON SERVER WITH fan_in FOR blocked_process_report TO SERVICE 'BlockedProcessReportService', 'current database'
GO
ALTER QUEUE BlockedProcessReportQueue
WITH STATUS = ON,
     RETENTION = OFF,
     ACTIVATION
     (
         STATUS = ON,
         PROCEDURE_NAME = usp_Dba_ProcessBlockProcessReports,
         MAX_QUEUE_READERS = 1,
         EXECUTE AS OWNER
     );
GO

/* Certification */
USE [$(DatabaseName)]
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.certificates WHERE name = '$(CertName)')
    CREATE CERTIFICATE [$(CertName)]
        ENCRYPTION BY PASSWORD = '$(CertEncryptPass)'
        WITH SUBJECT = 'Certificate for dba monitoring'

IF EXISTS (
    SELECT 1/0 
    FROM sys.crypt_properties cp
        INNER JOIN sys.objects obj        ON obj.object_id = cp.major_id
        LEFT   JOIN sys.certificates c    ON c.thumbprint = cp.thumbprint
        LEFT   JOIN sys.asymmetric_keys a ON a.thumbprint = cp.thumbprint
    WHERE obj.name = 'usp_Dba_ProcessBlockProcessReports'
)
    DROP SIGNATURE FROM OBJECT::[dbo].[usp_Dba_ProcessBlockProcessReports] BY CERTIFICATE [$(CertName)]

ADD SIGNATURE TO OBJECT::[dbo].[usp_Dba_ProcessBlockProcessReports]
    BY CERTIFICATE [$(CertName)]
    WITH PASSWORD = '$(CertEncryptPass)'

DECLARE @FilePath NVARCHAR(1000) = '$(CertPath)$(CertName)_' + FORMAT(GETDATE(),'yyyymmddhhmmss') + '.cer'
DECLARE @Sql NVARCHAR(4000) 
SET @Sql = 'BACKUP CERTIFICATE [$(CertName)] TO FILE = ''' + @FilePath + ''''
EXEC sp_executesql @Sql

USE [master]

IF EXISTS (SELECT 1/0 FROM sys.server_principals WHERE name = '$(TrustedLogin)' AND type_desc = 'CERTIFICATE_MAPPED_LOGIN')
	DROP LOGIN [$(TrustedLogin)]

IF EXISTS (SELECT 1/0 FROM sys.certificates WHERE name = '$(CertName)')
    DROP CERTIFICATE [$(CertName)] 

SET @Sql = 'CREATE CERTIFICATE [$(CertName)] FROM FILE = ''' + @FilePath + ''''
EXEC sp_executesql @Sql

IF NOT EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = '$(TrustedLogin)')
    CREATE LOGIN [$(TrustedLogin)] FROM CERTIFICATE [$(CertName)]

GRANT VIEW SERVER STATE, AUTHENTICATE SERVER TO [$(TrustedLogin)]
GO