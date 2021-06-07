/* PRE-INSTALLATION 
+ Run script with SQLCMD Enable (Alt + Q + M in SSMS)
*/
:Setvar DatabaseName "DBAMonitoring"
/* DB DBAMonitoring */
USE [$(DatabaseName)]
GO
/* INIT */
CREATE TABLE [dbo].[DeadlockLog] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [DatabaseName]   NVARCHAR (100) NULL,
    [Time]           DATETIME       NULL,
    [BlockedXactid]  BIGINT         NULL,
    [BlockingXactid] BIGINT         NULL,
    [BlockedQuery]   NVARCHAR (MAX) NULL,
    [BlockingQuery]  NVARCHAR (MAX) NULL,
    [LockMode]       NVARCHAR (5)   NULL,
    [XMLReport]      XML            NULL,
    CONSTRAINT [PK_DeadLockLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO
CREATE NONCLUSTERED INDEX [IX_Time]
    ON [dbo].[DeadlockLog]([Time] ASC)
    INCLUDE([DatabaseName], [BlockedXactid], [BlockingXactid], [BlockedQuery], [BlockingQuery], [LockMode], [XMLReport]);
GO
CREATE PROCEDURE [dbo].[usp_Dba_DeadLockLog]	
AS
BEGIN
    -- Query ring buffer data
    IF OBJECT_ID('tempdb..#tempDeadlockRingBuffer') IS NOT NULL
        DROP TABLE #tempDeadlockRingBuffer;   

    -- Query ring buffer into temp table
    SELECT  CAST(dt.target_data AS XML) AS xmlDeadlockData
    INTO    #tempDeadlockRingBuffer
    FROM    sys.dm_xe_session_targets dt
            JOIN sys.dm_xe_sessions ds ON ds.address = dt.event_session_address
            JOIN sys.server_event_sessions ss ON ds.name = ss.name
    WHERE   dt.target_name = 'ring_buffer'
            AND ds.name = 'EV_DeadlockLog';

    ;WITH cte
    AS (
        SELECT  CASE WHEN xevents.event_data.query('(data[@name="blocked_process"]/value/blocked-process-report)[1]').value('(blocked-process-report[@monitorLoop])[1]', 'NVARCHAR(MAX)') IS NULL THEN xevents.event_data.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(100)') 
                ELSE xevents.event_data.value('(data[@name="database_name"]/value)[1]', 'NVARCHAR(100)') 
                END AS [DatabaseName],
                DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), CURRENT_TIMESTAMP), xevents.event_data.value('(@timestamp)[1]', 'datetime2')) AS [Time],
                xevents.event_data.value('(data[@name="lock_mode"]/text)[1]', 'NVARCHAR(5)') AS [LockMode],
                xevents.event_data.query('(data[@name="xml_report"]/value/deadlock)[1]') AS [DeadlockGraph]
        FROM    #tempDeadlockRingBuffer
                CROSS APPLY xmlDeadlockData.nodes('//RingBufferTarget/event') AS xevents (event_data)
    )

    INSERT INTO DeadlockLog
    SELECT 
        [DatabaseName],
        [Time],
        --BlockedXactid, BlockingXactid
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[1]/@xactid', 'bigint') AS [BlockedXactid],
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[2]/@xactid', 'bigint') AS [BlockingXactid],

        --BlockedQuery, BlockingQuery
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[1]/inputbuf[1]', 'nvarchar(max)') AS [BlockedQuery],
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[2]/inputbuf[1]', 'nvarchar(max)') AS [BlockingQuery],

        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[2]/@lockMode', 'nvarchar(5)') AS [LockMode],
        [DeadlockGraph] AS [XMLReport]
    FROM cte
END;
GO
/* JOB Collect Slow query */
USE [msdb]
GO
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'DBA' AND category_class=1)
BEGIN
	EXEC @ReturnCode = msdb.dbo.sp_add_category @class = N'JOB',
                                                @type = N'LOCAL',
                                                @name = N'DBA'
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Collector - Deadlock Log', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Get events from ExtendedEvents ring buffer and insert into .dbo.DeadLockLog table.', 
		@category_name=N'DBA', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Insert table DeadLockLog', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.usp_Dba_DeadLockLog', 
		@database_name=N'$(DatabaseName)', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'RestartSession', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF EXISTS (SELECT 1 FROM sys.dm_xe_sessions WHERE [name] = ''EV_DeadlockLog'')
    ALTER EVENT SESSION EV_DeadlockLog ON SERVER STATE = STOP;
IF NOT EXISTS (SELECT 1 FROM sys.dm_xe_sessions WHERE [name] = ''EV_DeadlockLog'')
    ALTER EVENT SESSION EV_DeadlockLog ON SERVER STATE = START;', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every1h', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170622, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/* Event Session */
USE [master]
GO
IF EXISTS (SELECT 1/0 FROM sys.server_event_sessions WHERE name = 'EV_DeadlockLog')
    DROP EVENT SESSION [EV_DeadlockLog] ON SERVER 
    
CREATE EVENT SESSION [EV_DeadlockLog] ON SERVER
    ADD EVENT sqlserver.xml_deadlock_report (
        ACTION (sqlserver.client_app_name, sqlserver.client_hostname,
        sqlserver.database_id, sqlserver.database_name, sqlserver.plan_handle,
        sqlserver.sql_text, sqlserver.username))
    ADD TARGET package0.ring_buffer (SET max_events_limit = (1500),
                                        max_memory = (50000)) --Max 50MB : config số câu query trong buffer
    WITH (MAX_MEMORY = 4096 KB,
            EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
            MAX_DISPATCH_LATENCY = 1 SECONDS,
            MAX_EVENT_SIZE = 0 KB,
            MEMORY_PARTITION_MODE = NONE,
            TRACK_CAUSALITY = OFF,
            STARTUP_STATE = OFF);
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.dm_xe_sessions WHERE [name] = 'EV_DeadlockLog')
    ALTER EVENT SESSION EV_DeadlockLog ON SERVER STATE = START;