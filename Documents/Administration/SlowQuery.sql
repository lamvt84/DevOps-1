/* PRE-INSTALLATION 
+ Run script with SQLCMD Enable (Alt + Q + M in SSMS)
*/
:Setvar DatabaseName "DBAMonitoring"
/* DB DBAMonitoring */
USE [$(DatabaseName)]
GO
/* INIT */
CREATE TABLE [dbo].[SlowQueryLog] (
    [ID]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [Time]            DATETIME       NULL,
    [Duration]        FLOAT (53)     NULL,
    [CPUTime]         FLOAT (53)     NULL,
    [PhysicalReads]   BIGINT         NULL,
    [LogicalReads]    BIGINT         NULL,
    [Writes]          BIGINT         NULL,
    [User]            NVARCHAR (100) NULL,
    [AppName]         NVARCHAR (100) NULL,
    [Database]        NVARCHAR (100) NULL,
    [STMT_Batch_Text] NVARCHAR (MAX) NULL,
    [SQLText]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_SlowQueryLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);
GO
CREATE NONCLUSTERED INDEX [IX_Time]
    ON [dbo].[SlowQueryLog]([Time] ASC)
    INCLUDE([Duration], [CPUTime], [PhysicalReads], [LogicalReads], [Writes], [STMT_Batch_Text], [SQLText]);
GO
CREATE PROCEDURE [dbo].[usp_Dba_SlowQueryLog]	
AS
BEGIN
    -- Query ring buffer into temp table
    SELECT CAST(dt.target_data AS XML) AS xmlSlowData
    INTO #tempSlowQueryRingBuffer
    FROM sys.dm_xe_session_targets dt
        JOIN sys.dm_xe_sessions ds ON ds.Address = dt.event_session_address
        JOIN sys.server_event_sessions ss ON ds.Name = ss.Name
    WHERE dt.target_name = 'ring_buffer'
        AND ds.Name = 'EV_SlowQueryLog'

    -- Insert into table
    INSERT INTO [dbo].[SlowQueryLog]
    SELECT
        DATEADD(hh, 7, xed.event_data.value('(@timestamp)[1]', 'datetime')) AS [Time] --Add 7h because ext events takes UTC time
        , CONVERT (FLOAT, xed.event_data.value ('(data[@name=''duration'']/value)[1]', 'BIGINT')) / 1000000 AS [Duration(s)]
        , CONVERT (FLOAT, xed.event_data.value ('(data[@name=''cpu_time'']/value)[1]', 'BIGINT')) / 1000000 AS [CPUTime(s)]
        , xed.event_data.value ('(data[@name=''physical_reads'']/value)[1]', 'BIGINT') AS [PhysicalReads]
        , xed.event_data.value ('(data[@name=''logical_reads'']/value)[1]', 'BIGINT') AS [LogicalReads]
        , xed.event_data.value ('(data[@name=''writes'']/value)[1]', 'BIGINT') AS [Writes]
        , xed.event_data.value ('(action[@name=''username'']/value)[1]', 'NVARCHAR(100)') AS [User]
        , xed.event_data.value ('(action[@name=''client_app_name'']/value)[1]', 'NVARCHAR(100)') AS [AppName]
        , xed.event_data.value ('(action[@name=''database_name'']/value)[1]', 'NVARCHAR(100)') AS [Database]
        , ISNULL(xed.event_data.value('(data[@name=''statement'']/value)[1]', 'NVARCHAR(MAX)'),
                    xed.event_data.value('(data[@name=''batch_text'']/value)[1]', 'NVARCHAR(MAX)')) AS [STMT_Batch_Text] --sql statement text depending on rpc or stmt
        , xed.event_data.value('(action[@name=''sql_text'']/value)[1]', 'NVARCHAR(MAX)') AS [SQLText]
    FROM #tempSlowQueryRingBuffer
        CROSS APPLY xmlSlowData.nodes('//RingBufferTarget/event') AS xed (event_data)    
END
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
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Collector - Slow Query Log', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Get events from ExtendedEvents ring buffer and insert into dbo.SlowQueryLog table.', 
		@category_name=N'DBA', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Insert table SlowQueryLog]    Script Date: 2/25/2021 2:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Insert table SlowQueryLog', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.usp_Dba_SlowQueryLog', 
		@database_name=N'$(DatabaseName)', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Clear ring buffer]    Script Date: 2/25/2021 2:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Clear ring buffer', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
		IF EXISTS (SELECT 1 FROM sys.dm_xe_sessions WHERE [name] = ''EV_SlowQueryLog'')
			ALTER EVENT SESSION EV_SlowQueryLog ON SERVER STATE = STOP;
		IF NOT EXISTS (SELECT 1 FROM sys.dm_xe_sessions WHERE [name] = ''EV_SlowQueryLog'')
			ALTER EVENT SESSION EV_SlowQueryLog ON SERVER STATE = START;', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'10m rotation', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170118, 
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
IF EXISTS (SELECT 1/0 FROM sys.server_event_sessions WHERE name = 'EV_SlowQueryLog')
    DROP EVENT SESSION [EV_SlowQueryLog] ON SERVER 
GO
CREATE EVENT SESSION [EV_SlowQueryLog] ON SERVER
    ADD EVENT sqlserver.rpc_completed (
        ACTION ( sqlserver.client_app_name, sqlserver.client_hostname,
        sqlserver.database_id, sqlserver.database_name, sqlserver.plan_handle,
        sqlserver.sql_text, sqlserver.username )
        WHERE [duration] > ( 5000000 )),
    ADD EVENT sqlserver.sql_statement_completed (
        ACTION ( sqlserver.client_app_name, sqlserver.client_hostname,
        sqlserver.database_id, sqlserver.database_name, sqlserver.plan_handle,
        sqlserver.sql_text, sqlserver.username )
        WHERE [duration] > ( 5000000 )),
    ADD EVENT sqlserver.query_memory_grant_usage (
        ACTION ( sqlserver.client_app_name, sqlserver.client_hostname,
        sqlserver.database_id, sqlserver.database_name, sqlserver.plan_handle,
        sqlserver.sql_text, sqlserver.username )
        WHERE ( [granted_memory_kb] > ( 1000 ) ) )
    ADD TARGET package0.ring_buffer ( SET max_events_limit = ( 1500 ) ,
                                    max_memory = ( 50000 ) ) --Max 50MB
    WITH ( MAX_MEMORY = 4096 KB ,
            EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS ,
            MAX_DISPATCH_LATENCY = 1 SECONDS ,
            MAX_EVENT_SIZE = 0 KB ,
            MEMORY_PARTITION_MODE = NONE ,
            TRACK_CAUSALITY = OFF ,
            STARTUP_STATE = OFF );
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.dm_xe_sessions WHERE [name] = 'EV_SlowQueryLog')
    ALTER EVENT SESSION EV_SlowQueryLog ON SERVER STATE = START;
