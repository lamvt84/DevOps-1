

# Wait Stats Deployment

<!--ts-->  

* [Installation](#Installation) 
  * [Table](#Table) 
  * [Stored Procedure](#Stored-Procedure) 
  * [Initialize Wait Categories](#Initialize-Wait-Categories) 
* [Operation](#Operation)

<!--te-->

### Installation

**Table**

```sql
CREATE TABLE dbo.WaitCategories
(
    [wait_type] [nvarchar](60) NOT NULL PRIMARY KEY CLUSTERED,
    [wait_category] [nvarchar](128) NOT NULL,
    [ignorable] [bit] NULL,
);
GO
 
CREATE TABLE dbo.WaitStats(   
    [pass] [tinyint] NULL,
    [sample_time] [datetimeoffset](7) NULL,
    [server_name] [nvarchar](50) NULL,
    [wait_type] [nvarchar](60) NULL INDEX IX_WaitType CLUSTERED,
    [wait_time_s] [numeric](12, 1) NULL,
    [wait_time_per_core_s] [decimal](18, 1) NULL,
    [signal_wait_time_s] [numeric](12, 1) NULL,
    [signal_wait_percent] [numeric](4, 1) NULL,
    [wait_count] [bigint] NULL
);
GO
```

**Stored Procedure**

```sql
CREATE OR ALTER PROCEDURE [dbo].[sp_WaitStats_Report]
    @ServerName sysname = @@SERVERNAME
AS
BEGIN
    IF NOT EXISTS (SELECT 1/0 FROM dbo.WaitStats WHERE pass = 1)
    BEGIN
        PRINT 1;
        WITH cte_WaitStats AS (
            SELECT x.wait_type,
            SUM(x.sum_wait_time_ms) AS sum_wait_time_ms,
            SUM(x.sum_signal_wait_time_ms) AS sum_signal_wait_time_ms,
            SUM(x.sum_waiting_tasks) AS sum_waiting_tasks
            FROM
            (
                SELECT owt.wait_type,
                    SUM(owt.wait_duration_ms) OVER (PARTITION BY owt.wait_type, owt.session_id) AS sum_wait_time_ms,
                    0 AS sum_signal_wait_time_ms,
                    0 AS sum_waiting_tasks
                FROM sys.dm_os_waiting_tasks owt
                WHERE owt.session_id > 50
                    AND owt.wait_duration_ms >= 0
                UNION ALL
                SELECT os.wait_type,
                    SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
                    SUM(os.signal_wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_signal_wait_time_ms,
                    SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
                FROM sys.dm_os_wait_stats os
            ) x
            GROUP BY x.wait_type
        )
        INSERT dbo.WaitStats (
            [pass]
            ,[sample_time]
            ,[server_name]
            ,[wait_type]
            ,[wait_time_s]
            ,[wait_time_per_core_s]
            ,[signal_wait_time_s]
            ,[signal_wait_percent]
            ,[wait_count]           
        )
        SELECT 1,
            SYSDATETIMEOFFSET(),
            @@SERVERNAME,
            wc.wait_type,
            COALESCE(c.wait_time_s, 0),
            COALESCE(CAST((CAST(ws.sum_wait_time_ms AS MONEY)) / 1000.0 / cores.cpu_count AS DECIMAL(18, 1)), 0),
            COALESCE(c.signal_wait_time_s, 0),
            COALESCE(
                CASE
                    WHEN c.wait_time_s > 0 THEN
                        CAST(100. * (c.signal_wait_time_s / c.wait_time_s) AS NUMERIC(4, 1))
                    ELSE
                        0
                END, 0),
            COALESCE(ws.sum_waiting_tasks, 0)           
        FROM dbo.WaitCategories wc
            LEFT JOIN cte_WaitStats ws ON wc.wait_type = ws.wait_type AND ws.sum_waiting_tasks > 0
            CROSS APPLY
            (
                SELECT SUM(1) AS cpu_count
                FROM sys.dm_os_schedulers
                WHERE status = 'VISIBLE ONLINE'
                    AND is_online = 1
            ) AS cores
            CROSS APPLY
            (
                SELECT CAST(ws.sum_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS wait_time_s,
                    CAST(ws.sum_signal_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS signal_wait_time_s
            ) AS c;
         
        WAITFOR DELAY '00:00:05';
    END;
 
    WITH cte_WaitStats AS (
        SELECT x.wait_type,
        SUM(x.sum_wait_time_ms) AS sum_wait_time_ms,
        SUM(x.sum_signal_wait_time_ms) AS sum_signal_wait_time_ms,
        SUM(x.sum_waiting_tasks) AS sum_waiting_tasks
        FROM
        (
            SELECT owt.wait_type,
                SUM(owt.wait_duration_ms) OVER (PARTITION BY owt.wait_type, owt.session_id) AS sum_wait_time_ms,
                0 AS sum_signal_wait_time_ms,
                0 AS sum_waiting_tasks
            FROM sys.dm_os_waiting_tasks owt
            WHERE owt.session_id > 50
                AND owt.wait_duration_ms >= 0
            UNION ALL
            SELECT os.wait_type,
                SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
                SUM(os.signal_wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_signal_wait_time_ms,
                SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
            FROM sys.dm_os_wait_stats os
        ) x
        GROUP BY x.wait_type
    )
    INSERT dbo.WaitStats (
        [pass]
        ,[sample_time]
        ,[server_name]
        ,[wait_type]
        ,[wait_time_s]
        ,[wait_time_per_core_s]
        ,[signal_wait_time_s]
        ,[signal_wait_percent]
        ,[wait_count]
    )
    SELECT 2,
        SYSDATETIMEOFFSET(),
        @@SERVERNAME,
        wc.wait_type,
        COALESCE(c.wait_time_s, 0),
        COALESCE(CAST((CAST(ws.sum_wait_time_ms AS MONEY)) / 1000.0 / cores.cpu_count AS DECIMAL(18, 1)), 0),
        COALESCE(c.signal_wait_time_s, 0),
        COALESCE(
            CASE
                WHEN c.wait_time_s > 0 THEN
                    CAST(100. * (c.signal_wait_time_s / c.wait_time_s) AS NUMERIC(4, 1))
                ELSE
                    0
            END, 0),
        COALESCE(ws.sum_waiting_tasks, 0)
    FROM dbo.WaitCategories wc
        LEFT JOIN cte_WaitStats ws ON wc.wait_type = ws.wait_type AND ws.sum_waiting_tasks > 0
        CROSS APPLY
        (
            SELECT SUM(1) AS cpu_count
            FROM sys.dm_os_schedulers
            WHERE status = 'VISIBLE ONLINE'
                AND is_online = 1
        ) AS cores
        CROSS APPLY
        (
            SELECT CAST(ws.sum_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS wait_time_s,
                CAST(ws.sum_signal_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS signal_wait_time_s
        ) AS c;
     
    SELECT ws2.server_name,
        ws2.sample_time,
        DATEDIFF(ss, ws1.sample_time, ws2.sample_time) time_range,
        COALESCE(wc.wait_type, 'Other') wait_type,
        COALESCE(wc.wait_category, 'Other') wait_category,
        COALESCE(ws2.wait_time_s - ws1.wait_time_s, 0) wait_time_s,
        COALESCE(ws2.wait_time_per_core_s - ws1.wait_time_per_core_s, 0) wait_time_per_core_s,
        COALESCE(ws2.signal_wait_time_s - ws1.signal_wait_time_s, 0) signal_wait_time_s,
        COALESCE(ws2.signal_wait_percent - ws1.signal_wait_percent, 0) signal_wait_percent,       
        COALESCE(ws2.wait_count - ws1.wait_count, 0) wait_count,       
        CASE WHEN ws2.wait_count > ws1.wait_count THEN COALESCE(CAST((ws2.wait_time_s - ws1.wait_time_s) * 1000. / (1.0 * (ws2.wait_count - ws1.wait_count)) AS NUMERIC(12, 1)), 0)
            ELSE 0 END avg_wait_per_ms,
        wc.ignorable
    FROM dbo.WaitStats ws2
        LEFT OUTER JOIN dbo.WaitStats ws1
            ON ws2.wait_type = ws1.wait_type
        LEFT JOIN dbo.WaitCategories wc ON ws2.wait_type = wc.wait_type
    WHERE ws1.pass = 1
        AND ws2.pass = 2;  
 
    DELETE FROM dbo.WaitStats WHERE pass = 1;
    UPDATE dbo.WaitStats SET pass = 1 WHERE pass = 2;
END
GO
```

**Initialize Wait Categories**

```sql
INSERT INTO dbo.WaitCategories
        (
            wait_type,
            wait_category,
            ignoratble
        )
        VALUES
        USE [EventMonitoring]
(N'ASYNC_IO_COMPLETION', N'Other Disk IO', 0),
(N'ASYNC_NETWORK_IO', N'Network IO', 0),
(N'BACKUPBUFFER', N'Other Disk IO', 0),
(N'BACKUPIO', N'Other Disk IO', 0),
(N'BROKER_CONNECTION_RECEIVE_TASK', N'Service Broker', 0),
(N'BROKER_DISPATCHER', N'Service Broker', 0),
(N'BROKER_ENDPOINT_STATE_MUTEX', N'Service Broker', 0),
(N'BROKER_EVENTHANDLER', N'Service Broker', 1),
(N'BROKER_FORWARDER', N'Service Broker', 0),
(N'BROKER_INIT', N'Service Broker', 0),
(N'BROKER_MASTERSTART', N'Service Broker', 0),
(N'BROKER_RECEIVE_WAITFOR', N'User Wait', 1),
(N'BROKER_REGISTERALLENDPOINTS', N'Service Broker', 0),
(N'BROKER_SERVICE', N'Service Broker', 0),
(N'BROKER_SHUTDOWN', N'Service Broker', 0),
(N'BROKER_START', N'Service Broker', 0),
(N'BROKER_TASK_SHUTDOWN', N'Service Broker', 0),
(N'BROKER_TASK_STOP', N'Service Broker', 1),
(N'BROKER_TASK_SUBMIT', N'Service Broker', 0),
(N'BROKER_TO_FLUSH', N'Service Broker', 1),
(N'BROKER_TRANSMISSION_OBJECT', N'Service Broker', 0),
(N'BROKER_TRANSMISSION_TABLE', N'Service Broker', 0),
(N'BROKER_TRANSMISSION_WORK', N'Service Broker', 0),
(N'BROKER_TRANSMITTER', N'Service Broker', 1),
(N'CHECKPOINT_QUEUE', N'Idle', 1),
(N'CHKPT', N'Tran Log IO', 1),
(N'CLR_AUTO_EVENT', N'SQL CLR', 1),
(N'CLR_CRST', N'SQL CLR', 0),
(N'CLR_JOIN', N'SQL CLR', 0),
(N'CLR_MANUAL_EVENT', N'SQL CLR', 1),
(N'CLR_MEMORY_SPY', N'SQL CLR', 0),
(N'CLR_MONITOR', N'SQL CLR', 0),
(N'CLR_RWLOCK_READER', N'SQL CLR', 0),
(N'CLR_RWLOCK_WRITER', N'SQL CLR', 0),
(N'CLR_SEMAPHORE', N'SQL CLR', 1),
(N'CLR_TASK_START', N'SQL CLR', 0),
(N'CLRHOST_STATE_ACCESS', N'SQL CLR', 0),
(N'CMEMPARTITIONED', N'Memory', 0),
(N'CMEMTHREAD', N'Memory', 0),
(N'CXCONSUMER', N'Parallelism', 1),
(N'CXPACKET', N'Parallelism', 0),
(N'DBMIRROR_DBM_EVENT', N'Mirroring', 1),
(N'DBMIRROR_DBM_MUTEX', N'Mirroring', 0),
(N'DBMIRROR_EVENTS_QUEUE', N'Mirroring', 1),
(N'DBMIRROR_SEND', N'Mirroring', 0),
(N'DBMIRROR_WORKER_QUEUE', N'Mirroring', 1),
(N'DBMIRRORING_CMD', N'Mirroring', 1),
(N'DIRTY_PAGE_POLL', N'Other', 1),
(N'DIRTY_PAGE_TABLE_LOCK', N'Replication', 0),
(N'DISPATCHER_QUEUE_SEMAPHORE', N'Other', 1),
(N'DPT_ENTRY_LOCK', N'Replication', 0),
(N'DTC', N'Transaction', 0),
(N'DTC_ABORT_REQUEST', N'Transaction', 0),
(N'DTC_RESOLVE', N'Transaction', 0),
(N'DTC_STATE', N'Transaction', 0),
(N'DTC_TMDOWN_REQUEST', N'Transaction', 0),
(N'DTC_WAITFOR_OUTCOME', N'Transaction', 0),
(N'DTCNEW_ENLIST', N'Transaction', 0),
(N'DTCNEW_PREPARE', N'Transaction', 0),
(N'DTCNEW_RECOVERY', N'Transaction', 0),
(N'DTCNEW_TM', N'Transaction', 0),
(N'DTCNEW_TRANSACTION_ENLISTMENT', N'Transaction', 0),
(N'DTCPNTSYNC', N'Transaction', 0),
(N'EE_PMOLOCK', N'Memory', 0),
(N'EXCHANGE', N'Parallelism', 0),
(N'EXTERNAL_SCRIPT_NETWORK_IOF', N'Network IO', 0),
(N'FCB_REPLICA_READ', N'Replication', 0),
(N'FCB_REPLICA_WRITE', N'Replication', 0),
(N'FT_COMPROWSET_RWLOCK', N'Full Text Search', 0),
(N'FT_IFTS_RWLOCK', N'Full Text Search', 0),
(N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'Idle', 1),
(N'FT_IFTSHC_MUTEX', N'Full Text Search', 1),
(N'FT_IFTSISM_MUTEX', N'Full Text Search', 0),
(N'FT_MASTER_MERGE', N'Full Text Search', 0),
(N'FT_MASTER_MERGE_COORDINATOR', N'Full Text Search', 0),
(N'FT_METADATA_MUTEX', N'Full Text Search', 0),
(N'FT_PROPERTYLIST_CACHE', N'Full Text Search', 0),
(N'FT_RESTART_CRAWL', N'Full Text Search', 0),
(N'FULLTEXT GATHERER', N'Full Text Search', 0),
(N'HADR_AG_MUTEX', N'Replication', 0),
(N'HADR_AR_CRITICAL_SECTION_ENTRY', N'Replication', 0),
(N'HADR_AR_MANAGER_MUTEX', N'Replication', 0),
(N'HADR_AR_UNLOAD_COMPLETED', N'Replication', 0),
(N'HADR_ARCONTROLLER_NOTIFICATIONS_SUBSCRIBER_LIST', N'Replication', 0),
(N'HADR_BACKUP_BULK_LOCK', N'Replication', 0),
(N'HADR_BACKUP_QUEUE', N'Replication', 0),
(N'HADR_CLUSAPI_CALL', N'Replication', 1),
(N'HADR_COMPRESSED_CACHE_SYNC', N'Replication', 0),
(N'HADR_CONNECTIVITY_INFO', N'Replication', 0),
(N'HADR_DATABASE_FLOW_CONTROL', N'Replication', 0),
(N'HADR_DATABASE_VERSIONING_STATE', N'Replication', 0),
(N'HADR_DATABASE_WAIT_FOR_RECOVERY', N'Replication', 0),
(N'HADR_DATABASE_WAIT_FOR_RESTART', N'Replication', 0),
(N'HADR_DATABASE_WAIT_FOR_TRANSITION_TO_VERSIONING', N'Replication', 0),
(N'HADR_DB_COMMAND', N'Replication', 0),
(N'HADR_DB_OP_COMPLETION_SYNC', N'Replication', 0),
(N'HADR_DB_OP_START_SYNC', N'Replication', 0),
(N'HADR_DBR_SUBSCRIBER', N'Replication', 0),
(N'HADR_DBR_SUBSCRIBER_FILTER_LIST', N'Replication', 0),
(N'HADR_DBSEEDING', N'Replication', 0),
(N'HADR_DBSEEDING_LIST', N'Replication', 0),
(N'HADR_DBSTATECHANGE_SYNC', N'Replication', 0),
(N'HADR_FABRIC_CALLBACK', N'Replication', 0),
(N'HADR_FILESTREAM_BLOCK_FLUSH', N'Replication', 0),
(N'HADR_FILESTREAM_FILE_CLOSE', N'Replication', 0),
(N'HADR_FILESTREAM_FILE_REQUEST', N'Replication', 0),
(N'HADR_FILESTREAM_IOMGR', N'Replication', 0),
(N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', N'Replication', 1),
(N'HADR_FILESTREAM_MANAGER', N'Replication', 0),
(N'HADR_FILESTREAM_PREPROC', N'Replication', 0),
(N'HADR_GROUP_COMMIT', N'Replication', 0),
(N'HADR_LOGCAPTURE_SYNC', N'Replication', 0),
(N'HADR_LOGCAPTURE_WAIT', N'Replication', 1),
(N'HADR_LOGPROGRESS_SYNC', N'Replication', 0),
(N'HADR_NOTIFICATION_DEQUEUE', N'Replication', 1),
(N'HADR_NOTIFICATION_WORKER_EXCLUSIVE_ACCESS', N'Replication', 0),
(N'HADR_NOTIFICATION_WORKER_STARTUP_SYNC', N'Replication', 0),
(N'HADR_NOTIFICATION_WORKER_TERMINATION_SYNC', N'Replication', 0),
(N'HADR_PARTNER_SYNC', N'Replication', 0),
(N'HADR_READ_ALL_NETWORKS', N'Replication', 0),
(N'HADR_RECOVERY_WAIT_FOR_CONNECTION', N'Replication', 0),
(N'HADR_RECOVERY_WAIT_FOR_UNDO', N'Replication', 0),
(N'HADR_REPLICAINFO_SYNC', N'Replication', 0),
(N'HADR_SEEDING_CANCELLATION', N'Replication', 0),
(N'HADR_SEEDING_FILE_LIST', N'Replication', 0),
(N'HADR_SEEDING_LIMIT_BACKUPS', N'Replication', 0),
(N'HADR_SEEDING_SYNC_COMPLETION', N'Replication', 0),
(N'HADR_SEEDING_TIMEOUT_TASK', N'Replication', 0),
(N'HADR_SEEDING_WAIT_FOR_COMPLETION', N'Replication', 0),
(N'HADR_SYNC_COMMIT', N'Replication', 0),
(N'HADR_SYNCHRONIZING_THROTTLE', N'Replication', 0),
(N'HADR_TDS_LISTENER_SYNC', N'Replication', 0),
(N'HADR_TDS_LISTENER_SYNC_PROCESSING', N'Replication', 0),
(N'HADR_THROTTLE_LOG_RATE_VERNOR', N'Log Rate vernor', 0),
(N'HADR_TIMER_TASK', N'Replication', 1),
(N'HADR_TRANSPORT_DBRLIST', N'Replication', 0),
(N'HADR_TRANSPORT_FLOW_CONTROL', N'Replication', 0),
(N'HADR_TRANSPORT_SESSION', N'Replication', 0),
(N'HADR_WORK_POOL', N'Replication', 0),
(N'HADR_WORK_QUEUE', N'Replication', 1),
(N'HADR_XRF_STACK_ACCESS', N'Replication', 0),
(N'INSTANCE_LOG_RATE_VERNOR', N'Log Rate vernor', 0),
(N'IO_COMPLETION', N'Other Disk IO', 0),
(N'IO_QUEUE_LIMIT', N'Other Disk IO', 0),
(N'IO_RETRY', N'Other Disk IO', 0),
(N'LATCH_DT', N'Latch', 0),
(N'LATCH_EX', N'Latch', 0),
(N'LATCH_KP', N'Latch', 0),
(N'LATCH_NL', N'Latch', 0),
(N'LATCH_SH', N'Latch', 0),
(N'LATCH_UP', N'Latch', 0),
(N'LAZYWRITER_SLEEP', N'Idle', 1),
(N'LCK_M_BU', N'Lock', 0),
(N'LCK_M_BU_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_BU_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_IS', N'Lock', 0),
(N'LCK_M_IS_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_IS_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_IU', N'Lock', 0),
(N'LCK_M_IU_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_IU_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_IX', N'Lock', 0),
(N'LCK_M_IX_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_IX_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RIn_NL', N'Lock', 0),
(N'LCK_M_RIn_NL_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RIn_NL_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RIn_S', N'Lock', 0),
(N'LCK_M_RIn_S_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RIn_S_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RIn_U', N'Lock', 0),
(N'LCK_M_RIn_U_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RIn_U_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RIn_X', N'Lock', 0),
(N'LCK_M_RIn_X_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RIn_X_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RS_S', N'Lock', 0),
(N'LCK_M_RS_S_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RS_S_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RS_U', N'Lock', 0),
(N'LCK_M_RS_U_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RS_U_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RX_S', N'Lock', 0),
(N'LCK_M_RX_S_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RX_S_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RX_U', N'Lock', 0),
(N'LCK_M_RX_U_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RX_U_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_RX_X', N'Lock', 0),
(N'LCK_M_RX_X_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_RX_X_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_S', N'Lock', 0),
(N'LCK_M_S_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_S_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_SCH_M', N'Lock', 0),
(N'LCK_M_SCH_M_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_SCH_M_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_SCH_S', N'Lock', 0),
(N'LCK_M_SCH_S_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_SCH_S_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_SIU', N'Lock', 0),
(N'LCK_M_SIU_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_SIU_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_SIX', N'Lock', 0),
(N'LCK_M_SIX_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_SIX_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_U', N'Lock', 0),
(N'LCK_M_U_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_U_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_UIX', N'Lock', 0),
(N'LCK_M_UIX_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_UIX_LOW_PRIORITY', N'Lock', 0),
(N'LCK_M_X', N'Lock', 0),
(N'LCK_M_X_ABORT_BLOCKERS', N'Lock', 0),
(N'LCK_M_X_LOW_PRIORITY', N'Lock', 0),
(N'LOG_RATE_VERNOR', N'Tran Log IO', 0),
(N'LOGBUFFER', N'Tran Log IO', 0),
(N'LOGMGR', N'Tran Log IO', 0),
(N'LOGMGR_FLUSH', N'Tran Log IO', 0),
(N'LOGMGR_PMM_LOG', N'Tran Log IO', 0),
(N'LOGMGR_QUEUE', N'Idle', 1),
(N'LOGMGR_RESERVE_APPEND', N'Tran Log IO', 0),
(N'MEMORY_ALLOCATION_EXT', N'Memory', 1),
(N'MEMORY_GRANT_UPDATE', N'Memory', 0),
(N'MSQL_XACT_MGR_MUTEX', N'Transaction', 0),
(N'MSQL_XACT_MUTEX', N'Transaction', 0),
(N'MSSEARCH', N'Full Text Search', 0),
(N'NET_WAITFOR_PACKET', N'Network IO', 0),
(N'ONDEMAND_TASK_QUEUE', N'Idle', 1),
(N'PAGEIOLATCH_DT', N'Buffer IO', 0),
(N'PAGEIOLATCH_EX', N'Buffer IO', 0),
(N'PAGEIOLATCH_KP', N'Buffer IO', 0),
(N'PAGEIOLATCH_NL', N'Buffer IO', 0),
(N'PAGEIOLATCH_SH', N'Buffer IO', 0),
(N'PAGEIOLATCH_UP', N'Buffer IO', 0),
(N'PAGELATCH_DT', N'Buffer Latch', 0),
(N'PAGELATCH_EX', N'Buffer Latch', 0),
(N'PAGELATCH_KP', N'Buffer Latch', 0),
(N'PAGELATCH_NL', N'Buffer Latch', 0),
(N'PAGELATCH_SH', N'Buffer Latch', 0),
(N'PAGELATCH_UP', N'Buffer Latch', 0),
(N'PARALLEL_REDO_DRAIN_WORKER', N'Replication', 1),
(N'PARALLEL_REDO_FLOW_CONTROL', N'Replication', 0),
(N'PARALLEL_REDO_LOG_CACHE', N'Replication', 1),
(N'PARALLEL_REDO_TRAN_LIST', N'Replication', 1),
(N'PARALLEL_REDO_TRAN_TURN', N'Replication', 0),
(N'PARALLEL_REDO_WORKER_SYNC', N'Replication', 1),
(N'PARALLEL_REDO_WORKER_WAIT_WORK', N'Replication', 1),
(N'POOL_LOG_RATE_VERNOR', N'Log Rate vernor', 0),
(N'PREEMPTIVE_ABR', N'Preemptive', 0),
(N'PREEMPTIVE_CLOSEBACKUPMEDIA', N'Preemptive', 0),
(N'PREEMPTIVE_CLOSEBACKUPTAPE', N'Preemptive', 0),
(N'PREEMPTIVE_CLOSEBACKUPVDIDEVICE', N'Preemptive', 0),
(N'PREEMPTIVE_CLUSAPI_CLUSTERRESOURCECONTROL', N'Preemptive', 0),
(N'PREEMPTIVE_COM_COCREATEINSTANCE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_COGETCLASSOBJECT', N'Preemptive', 0),
(N'PREEMPTIVE_COM_CREATEACCESSOR', N'Preemptive', 0),
(N'PREEMPTIVE_COM_DELETEROWS', N'Preemptive', 0),
(N'PREEMPTIVE_COM_GETCOMMANDTEXT', N'Preemptive', 0),
(N'PREEMPTIVE_COM_GETDATA', N'Preemptive', 0),
(N'PREEMPTIVE_COM_GETNEXTROWS', N'Preemptive', 0),
(N'PREEMPTIVE_COM_GETRESULT', N'Preemptive', 0),
(N'PREEMPTIVE_COM_GETROWSBYBOOKMARK', N'Preemptive', 0),
(N'PREEMPTIVE_COM_LBFLUSH', N'Preemptive', 0),
(N'PREEMPTIVE_COM_LBLOCKREGION', N'Preemptive', 0),
(N'PREEMPTIVE_COM_LBREADAT', N'Preemptive', 0),
(N'PREEMPTIVE_COM_LBSETSIZE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_LBSTAT', N'Preemptive', 0),
(N'PREEMPTIVE_COM_LBUNLOCKREGION', N'Preemptive', 0),
(N'PREEMPTIVE_COM_LBWRITEAT', N'Preemptive', 0),
(N'PREEMPTIVE_COM_QUERYINTERFACE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_RELEASE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_RELEASEACCESSOR', N'Preemptive', 0),
(N'PREEMPTIVE_COM_RELEASEROWS', N'Preemptive', 0),
(N'PREEMPTIVE_COM_RELEASESESSION', N'Preemptive', 0),
(N'PREEMPTIVE_COM_RESTARTPOSITION', N'Preemptive', 0),
(N'PREEMPTIVE_COM_SEQSTRMREAD', N'Preemptive', 0),
(N'PREEMPTIVE_COM_SEQSTRMREADANDWRITE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_SETDATAFAILURE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_SETPARAMETERINFO', N'Preemptive', 0),
(N'PREEMPTIVE_COM_SETPARAMETERPROPERTIES', N'Preemptive', 0),
(N'PREEMPTIVE_COM_STRMLOCKREGION', N'Preemptive', 0),
(N'PREEMPTIVE_COM_STRMSEEKANDREAD', N'Preemptive', 0),
(N'PREEMPTIVE_COM_STRMSEEKANDWRITE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_STRMSETSIZE', N'Preemptive', 0),
(N'PREEMPTIVE_COM_STRMSTAT', N'Preemptive', 0),
(N'PREEMPTIVE_COM_STRMUNLOCKREGION', N'Preemptive', 0),
(N'PREEMPTIVE_CONSOLEWRITE', N'Preemptive', 0),
(N'PREEMPTIVE_CREATEPARAM', N'Preemptive', 0),
(N'PREEMPTIVE_DEBUG', N'Preemptive', 0),
(N'PREEMPTIVE_DFSADDLINK', N'Preemptive', 0),
(N'PREEMPTIVE_DFSLINKEXISTCHECK', N'Preemptive', 0),
(N'PREEMPTIVE_DFSLINKHEALTHCHECK', N'Preemptive', 0),
(N'PREEMPTIVE_DFSREMOVELINK', N'Preemptive', 0),
(N'PREEMPTIVE_DFSREMOVEROOT', N'Preemptive', 0),
(N'PREEMPTIVE_DFSROOTFOLDERCHECK', N'Preemptive', 0),
(N'PREEMPTIVE_DFSROOTINIT', N'Preemptive', 0),
(N'PREEMPTIVE_DFSROOTSHARECHECK', N'Preemptive', 0),
(N'PREEMPTIVE_DTC_ABORT', N'Preemptive', 0),
(N'PREEMPTIVE_DTC_ABORTREQUESTDONE', N'Preemptive', 0),
(N'PREEMPTIVE_DTC_BEGINTRANSACTION', N'Preemptive', 0),
(N'PREEMPTIVE_DTC_COMMITREQUESTDONE', N'Preemptive', 0),
(N'PREEMPTIVE_DTC_ENLIST', N'Preemptive', 0),
(N'PREEMPTIVE_DTC_PREPAREREQUESTDONE', N'Preemptive', 0),
(N'PREEMPTIVE_FILESIZEGET', N'Preemptive', 0),
(N'PREEMPTIVE_FSAOLEDB_ABORTTRANSACTION', N'Preemptive', 0),
(N'PREEMPTIVE_FSAOLEDB_COMMITTRANSACTION', N'Preemptive', 0),
(N'PREEMPTIVE_FSAOLEDB_STARTTRANSACTION', N'Preemptive', 0),
(N'PREEMPTIVE_FSRECOVER_UNCONDITIONALUNDO', N'Preemptive', 0),
(N'PREEMPTIVE_GETRMINFO', N'Preemptive', 0),
(N'PREEMPTIVE_HADR_LEASE_MECHANISM', N'Preemptive', 0),
(N'PREEMPTIVE_HTTP_EVENT_WAIT', N'Preemptive', 0),
(N'PREEMPTIVE_HTTP_REQUEST', N'Preemptive', 0),
(N'PREEMPTIVE_LOCKMONITOR', N'Preemptive', 0),
(N'PREEMPTIVE_MSS_RELEASE', N'Preemptive', 0),
(N'PREEMPTIVE_ODBCOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OLE_UNINIT', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_ABORTORCOMMITTRAN', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_ABORTTRAN', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_GETDATASOURCE', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_GETLITERALINFO', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_GETPROPERTIES', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_GETPROPERTYINFO', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_GETSCHEMALOCK', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_JOINTRANSACTION', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_RELEASE', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDB_SETPROPERTIES', N'Preemptive', 0),
(N'PREEMPTIVE_OLEDBOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_ACCEPTSECURITYCONTEXT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_ACQUIRECREDENTIALSHANDLE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_AUTHENTICATIONOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_AUTHORIZATIONOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_AUTHZGETINFORMATIONFROMCONTEXT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_AUTHZINITIALIZECONTEXTFROMSID', N'Preemptive', 0),
(N'PREEMPTIVE_OS_AUTHZINITIALIZERESOURCEMANAGER', N'Preemptive', 0),
(N'PREEMPTIVE_OS_BACKUPREAD', N'Preemptive', 0),
(N'PREEMPTIVE_OS_CLOSEHANDLE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_CLUSTEROPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_COMOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_COMPLETEAUTHTOKEN', N'Preemptive', 0),
(N'PREEMPTIVE_OS_COPYFILE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_CREATEDIRECTORY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_CREATEFILE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_CRYPTACQUIRECONTEXT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_CRYPTIMPORTKEY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_CRYPTOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DECRYPTMESSAGE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DELETEFILE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DELETESECURITYCONTEXT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DEVICEIOCONTROL', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DEVICEOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DIRSVC_NETWORKOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DISCONNECTNAMEDPIPE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DOMAINSERVICESOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DSGETDCNAME', N'Preemptive', 0),
(N'PREEMPTIVE_OS_DTCOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_ENCRYPTMESSAGE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_FILEOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_FINDFILE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_FLUSHFILEBUFFERS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_FORMATMESSAGE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_FREECREDENTIALSHANDLE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_FREELIBRARY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GENERICOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETADDRINFO', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETCOMPRESSEDFILESIZE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETDISKFREESPACE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETFILEATTRIBUTES', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETFILESIZE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETFINALFILEPATHBYHANDLE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETLONGPATHNAME', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETPROCADDRESS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETVOLUMENAMEFORVOLUMEMOUNTPOINT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_GETVOLUMEPATHNAME', N'Preemptive', 0),
(N'PREEMPTIVE_OS_INITIALIZESECURITYCONTEXT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_LIBRARYOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_LOADLIBRARY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_LONUSER', N'Preemptive', 0),
(N'PREEMPTIVE_OS_LOOKUPACCOUNTSID', N'Preemptive', 0),
(N'PREEMPTIVE_OS_MESSAGEQUEUEOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_MOVEFILE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_NETGROUPGETUSERS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_NETLOCALGROUPGETMEMBERS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_NETUSERGETGROUPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_NETUSERGETLOCALGROUPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_NETUSERMODALSGET', N'Preemptive', 0),
(N'PREEMPTIVE_OS_NETVALIDATEPASSWORDPOLICY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_NETVALIDATEPASSWORDPOLICYFREE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_OPENDIRECTORY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_PDH_WMI_INIT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_PIPEOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_PROCESSOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_QUERYCONTEXTATTRIBUTES', N'Preemptive', 0),
(N'PREEMPTIVE_OS_QUERYREGISTRY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_QUERYSECURITYCONTEXTTOKEN', N'Preemptive', 0),
(N'PREEMPTIVE_OS_REMOVEDIRECTORY', N'Preemptive', 0),
(N'PREEMPTIVE_OS_REPORTEVENT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_REVERTTOSELF', N'Preemptive', 0),
(N'PREEMPTIVE_OS_RSFXDEVICEOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SECURITYOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SERVICEOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SETENDOFFILE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SETFILEPOINTER', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SETFILEVALIDDATA', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SETNAMEDSECURITYINFO', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SQLCLROPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_SQMLAUNCH', N'Preemptive', 0),
(N'PREEMPTIVE_OS_VERIFYSIGNATURE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_VERIFYTRUST', N'Preemptive', 0),
(N'PREEMPTIVE_OS_VSSOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_WAITFORSINGLEOBJECT', N'Preemptive', 0),
(N'PREEMPTIVE_OS_WINSOCKOPS', N'Preemptive', 0),
(N'PREEMPTIVE_OS_WRITEFILE', N'Preemptive', 0),
(N'PREEMPTIVE_OS_WRITEFILEGATHER', N'Preemptive', 0),
(N'PREEMPTIVE_OS_WSASETLASTERROR', N'Preemptive', 0),
(N'PREEMPTIVE_REENLIST', N'Preemptive', 0),
(N'PREEMPTIVE_RESIZELOG', N'Preemptive', 0),
(N'PREEMPTIVE_ROLLFORWARDREDO', N'Preemptive', 0),
(N'PREEMPTIVE_ROLLFORWARDUNDO', N'Preemptive', 0),
(N'PREEMPTIVE_SB_STOPENDPOINT', N'Preemptive', 0),
(N'PREEMPTIVE_SERVER_STARTUP', N'Preemptive', 0),
(N'PREEMPTIVE_SETRMINFO', N'Preemptive', 0),
(N'PREEMPTIVE_SHAREDMEM_GETDATA', N'Preemptive', 0),
(N'PREEMPTIVE_SNIOPEN', N'Preemptive', 0),
(N'PREEMPTIVE_SOSHOST', N'Preemptive', 0),
(N'PREEMPTIVE_SOSTESTING', N'Preemptive', 0),
(N'PREEMPTIVE_SP_SERVER_DIAGNOSTICS', N'Preemptive', 0),
(N'PREEMPTIVE_STARTRM', N'Preemptive', 0),
(N'PREEMPTIVE_STREAMFCB_CHECKPOINT', N'Preemptive', 0),
(N'PREEMPTIVE_STREAMFCB_RECOVER', N'Preemptive', 0),
(N'PREEMPTIVE_STRESSDRIVER', N'Preemptive', 0),
(N'PREEMPTIVE_TESTING', N'Preemptive', 0),
(N'PREEMPTIVE_TRANSIMPORT', N'Preemptive', 0),
(N'PREEMPTIVE_UNMARSHALPROPAGATIONTOKEN', N'Preemptive', 0),
(N'PREEMPTIVE_VSS_CREATESNAPSHOT', N'Preemptive', 0),
(N'PREEMPTIVE_VSS_CREATEVOLUMESNAPSHOT', N'Preemptive', 0),
(N'PREEMPTIVE_XE_CALLBACKEXECUTE', N'Preemptive', 0),
(N'PREEMPTIVE_XE_CX_FILE_OPEN', N'Preemptive', 0),
(N'PREEMPTIVE_XE_CX_HTTP_CALL', N'Preemptive', 0),
(N'PREEMPTIVE_XE_DISPATCHER', N'Preemptive', 0),
(N'PREEMPTIVE_XE_ENGINEINIT', N'Preemptive', 0),
(N'PREEMPTIVE_XE_GETTARGETSTATE', N'Preemptive', 1),
(N'PREEMPTIVE_XE_SESSIONCOMMIT', N'Preemptive', 0),
(N'PREEMPTIVE_XE_TARGETFINALIZE', N'Preemptive', 0),
(N'PREEMPTIVE_XE_TARGETINIT', N'Preemptive', 0),
(N'PREEMPTIVE_XE_TIMERRUN', N'Preemptive', 0),
(N'PREEMPTIVE_XETESTING', N'Preemptive', 0),
(N'PWAIT_HADR_ACTION_COMPLETED', N'Replication', 0),
(N'PWAIT_HADR_CHANGE_NOTIFIER_TERMINATION_SYNC', N'Replication', 0),
(N'PWAIT_HADR_CLUSTER_INTEGRATION', N'Replication', 0),
(N'PWAIT_HADR_FAILOVER_COMPLETED', N'Replication', 0),
(N'PWAIT_HADR_JOIN', N'Replication', 0),
(N'PWAIT_HADR_OFFLINE_COMPLETED', N'Replication', 0),
(N'PWAIT_HADR_ONLINE_COMPLETED', N'Replication', 0),
(N'PWAIT_HADR_POST_ONLINE_COMPLETED', N'Replication', 0),
(N'PWAIT_HADR_SERVER_READY_CONNECTIONS', N'Replication', 0),
(N'PWAIT_HADR_WORKITEM_COMPLETED', N'Replication', 0),
(N'PWAIT_HADRSIM', N'Replication', 0),
(N'PWAIT_RESOURCE_SEMAPHORE_FT_PARALLEL_QUERY_SYNC', N'Full Text Search', 0),
(N'QDS_ASYNC_QUEUE', N'Other', 1),
(N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', N'Other', 1),
(N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP', N'Other', 1),
(N'QDS_SHUTDOWN_QUEUE', N'Other', 1),
(N'QUERY_TRACEOUT', N'Tracing', 0),
(N'REDO_THREAD_PENDING_WORK', N'Other', 1),
(N'REPL_CACHE_ACCESS', N'Replication', 0),
(N'REPL_HISTORYCACHE_ACCESS', N'Replication', 0),
(N'REPL_SCHEMA_ACCESS', N'Replication', 0),
(N'REPL_TRANFSINFO_ACCESS', N'Replication', 0),
(N'REPL_TRANHASHTABLE_ACCESS', N'Replication', 0),
(N'REPL_TRANTEXTINFO_ACCESS', N'Replication', 0),
(N'REPLICA_WRITES', N'Replication', 0),
(N'REQUEST_FOR_DEADLOCK_SEARCH', N'Idle', 1),
(N'RESERVED_MEMORY_ALLOCATION_EXT', N'Memory', 0),
(N'RESOURCE_SEMAPHORE', N'Memory', 0),
(N'RESOURCE_SEMAPHORE_QUERY_COMPILE', N'Compilation', 0),
(N'SLEEP_BPOOL_FLUSH', N'Idle', 1),
(N'SLEEP_BUFFERPOOL_HELPLW', N'Idle', 0),
(N'SLEEP_DBSTARTUP', N'Idle', 1),
(N'SLEEP_DCOMSTARTUP', N'Idle', 1),
(N'SLEEP_MASTERDBREADY', N'Idle', 1),
(N'SLEEP_MASTERMDREADY', N'Idle', 1),
(N'SLEEP_MASTERUPGRADED', N'Idle', 1),
(N'SLEEP_MEMORYPOOL_ALLOCATEPAGES', N'Idle', 0),
(N'SLEEP_MSDBSTARTUP', N'Idle', 1),
(N'SLEEP_RETRY_VIRTUALALLOC', N'Idle', 0),
(N'SLEEP_SYSTEMTASK', N'Idle', 1),
(N'SLEEP_TASK', N'Idle', 1),
(N'SLEEP_TEMPDBSTARTUP', N'Idle', 1),
(N'SLEEP_WORKSPACE_ALLOCATEPAGE', N'Idle', 0),
(N'SOS_SCHEDULER_YIELD', N'CPU', 0),
(N'SOS_WORK_DISPATCHER', N'Idle', 1),
(N'SP_SERVER_DIAGNOSTICS_SLEEP', N'Other', 1),
(N'SQLCLR_APPDOMAIN', N'SQL CLR', 0),
(N'SQLCLR_ASSEMBLY', N'SQL CLR', 0),
(N'SQLCLR_DEADLOCK_DETECTION', N'SQL CLR', 0),
(N'SQLCLR_QUANTUM_PUNISHMENT', N'SQL CLR', 0),
(N'SQLTRACE_BUFFER_FLUSH', N'Idle', 1),
(N'SQLTRACE_FILE_BUFFER', N'Tracing', 0),
(N'SQLTRACE_FILE_READ_IO_COMPLETION', N'Tracing', 0),
(N'SQLTRACE_FILE_WRITE_IO_COMPLETION', N'Tracing', 0),
(N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', N'Idle', 1),
(N'SQLTRACE_PENDING_BUFFER_WRITERS', N'Tracing', 0),
(N'SQLTRACE_SHUTDOWN', N'Tracing', 0),
(N'SQLTRACE_WAIT_ENTRIES', N'Idle', 1),
(N'THREADPOOL', N'Worker Thread', 0),
(N'TRACE_EVTNOTIF', N'Tracing', 0),
(N'TRACEWRITE', N'Tracing', 0),
(N'TRAN_MARKLATCH_DT', N'Transaction', 0),
(N'TRAN_MARKLATCH_EX', N'Transaction', 0),
(N'TRAN_MARKLATCH_KP', N'Transaction', 0),
(N'TRAN_MARKLATCH_NL', N'Transaction', 0),
(N'TRAN_MARKLATCH_SH', N'Transaction', 0),
(N'TRAN_MARKLATCH_UP', N'Transaction', 0),
(N'TRANSACTION_MUTEX', N'Transaction', 0),
(N'UCS_SESSION_REGISTRATION', N'Other', 0),
(N'WAIT_FOR_RESULTS', N'User Wait', 1),
(N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', N'Other', 1),
(N'WAITFOR', N'User Wait', 1),
(N'WRITE_COMPLETION', N'Other Disk IO', 0),
(N'WRITELOG', N'Tran Log IO', 0),
(N'XACT_OWN_TRANSACTION', N'Transaction', 0),
(N'XACT_RECLAIM_SESSION', N'Transaction', 0),
(N'XACTLOCKINFO', N'Transaction', 0),
(N'XACTWORKSPACE_MUTEX', N'Transaction', 0),
(N'XE_DISPATCHER_WAIT', N'Idle', 1),
(N'XE_LIVE_TARGET_TVF', N'Other', 0),
(N'XE_TIMER_EVENT', N'Idle', 1)
```

### Operation

Table WaitStats will store all information at the time [dbo].[sp_WaitStats_Report] is executed

Execute SP [dbo].[sp_WaitStats_Report] each 60s to get the stats change

```sql
EXEC [dbo].[sp_WaitStats_Report] @ServerName = @@SERVERNAME
```

