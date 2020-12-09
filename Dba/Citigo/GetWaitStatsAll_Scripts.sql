;WITH cte_WaitCategories
AS (SELECT 'ASYNC_IO_COMPLETION' AS WaitType,
           'Other Disk IO' AS WaitCategory
    UNION ALL
    SELECT 'ASYNC_NETWORK_IO' AS WaitType,
           'Network IO' AS WaitCategory
    UNION ALL
    SELECT 'BACKUPIO' AS WaitType,
           'Other Disk IO' AS WaitCategory
    UNION ALL
    SELECT 'BACKUPBUFFER' AS WaitType,
           'Other Disk IO' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_CONNECTION_RECEIVE_TASK' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_DISPATCHER' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_ENDPOINT_STATE_MUTEX' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_EVENTHANDLER' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_FORWARDER' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_INIT' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_MASTERSTART' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_RECEIVE_WAITFOR' AS WaitType,
           'User Wait' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_REGISTERALLENDPOINTS' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_SERVICE' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_SHUTDOWN' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_START' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TASK_SHUTDOWN' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TASK_STOP' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TASK_SUBMIT' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TO_FLUSH' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TRANSMISSION_OBJECT' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TRANSMISSION_TABLE' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TRANSMISSION_WORK' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'BROKER_TRANSMITTER' AS WaitType,
           'Service Broker' AS WaitCategory
    UNION ALL
    SELECT 'CHECKPOINT_QUEUE' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'CHKPT' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'CLR_AUTO_EVENT' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_CRST' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_JOIN' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_MANUAL_EVENT' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_MEMORY_SPY' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_MONITOR' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_RWLOCK_READER' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_RWLOCK_WRITER' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_SEMAPHORE' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLR_TASK_START' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CLRHOST_STATE_ACCESS' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'CMEMPARTITIONED' AS WaitType,
           'Memory' AS WaitCategory
    UNION ALL
    SELECT 'CMEMTHREAD' AS WaitType,
           'Memory' AS WaitCategory
    UNION ALL
    SELECT 'CXPACKET' AS WaitType,
           'Parallelism' AS WaitCategory
    UNION ALL
    SELECT 'CXCONSUMER' AS WaitType,
           'Parallelism' AS WaitCategory
    UNION ALL
    SELECT 'DBMIRROR_DBM_EVENT' AS WaitType,
           'Mirroring' AS WaitCategory
    UNION ALL
    SELECT 'DBMIRROR_DBM_MUTEX' AS WaitType,
           'Mirroring' AS WaitCategory
    UNION ALL
    SELECT 'DBMIRROR_EVENTS_QUEUE' AS WaitType,
           'Mirroring' AS WaitCategory
    UNION ALL
    SELECT 'DBMIRROR_SEND' AS WaitType,
           'Mirroring' AS WaitCategory
    UNION ALL
    SELECT 'DBMIRROR_WORKER_QUEUE' AS WaitType,
           'Mirroring' AS WaitCategory
    UNION ALL
    SELECT 'DBMIRRORING_CMD' AS WaitType,
           'Mirroring' AS WaitCategory
    UNION ALL
    SELECT 'DIRTY_PAGE_POLL' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'DIRTY_PAGE_TABLE_LOCK' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'DISPATCHER_QUEUE_SEMAPHORE' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'DPT_ENTRY_LOCK' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'DTC' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTC_ABORT_REQUEST' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTC_RESOLVE' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTC_STATE' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTC_TMDOWN_REQUEST' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTC_WAITFOR_OUTCOME' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTCNEW_ENLIST' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTCNEW_PREPARE' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTCNEW_RECOVERY' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTCNEW_TM' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTCNEW_TRANSACTION_ENLISTMENT' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'DTCPNTSYNC' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'EE_PMOLOCK' AS WaitType,
           'Memory' AS WaitCategory
    UNION ALL
    SELECT 'EXCHANGE' AS WaitType,
           'Parallelism' AS WaitCategory
    UNION ALL
    SELECT 'EXTERNAL_SCRIPT_NETWORK_IOF' AS WaitType,
           'Network IO' AS WaitCategory
    UNION ALL
    SELECT 'FCB_REPLICA_READ' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'FCB_REPLICA_WRITE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'FT_COMPROWSET_RWLOCK' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_IFTS_RWLOCK' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_IFTS_SCHEDULER_IDLE_WAIT' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'FT_IFTSHC_MUTEX' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_IFTSISM_MUTEX' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_MASTER_MERGE' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_MASTER_MERGE_COORDINATOR' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_METADATA_MUTEX' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_PROPERTYLIST_CACHE' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FT_RESTART_CRAWL' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'FULLTEXT GATHERER' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'HADR_AG_MUTEX' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_AR_CRITICAL_SECTION_ENTRY' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_AR_MANAGER_MUTEX' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_AR_UNLOAD_COMPLETED' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_ARCONTROLLER_NOTIFICATIONS_SUBSCRIBER_LIST' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_BACKUP_BULK_LOCK' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_BACKUP_QUEUE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_CLUSAPI_CALL' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_COMPRESSED_CACHE_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_CONNECTIVITY_INFO' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DATABASE_FLOW_CONTROL' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DATABASE_VERSIONING_STATE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DATABASE_WAIT_FOR_RECOVERY' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DATABASE_WAIT_FOR_RESTART' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DATABASE_WAIT_FOR_TRANSITION_TO_VERSIONING' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DB_COMMAND' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DB_OP_COMPLETION_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DB_OP_START_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DBR_SUBSCRIBER' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DBR_SUBSCRIBER_FILTER_LIST' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DBSEEDING' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DBSEEDING_LIST' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_DBSTATECHANGE_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FABRIC_CALLBACK' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FILESTREAM_BLOCK_FLUSH' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FILESTREAM_FILE_CLOSE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FILESTREAM_FILE_REQUEST' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FILESTREAM_IOMGR' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FILESTREAM_IOMGR_IOCOMPLETION' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FILESTREAM_MANAGER' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_FILESTREAM_PREPROC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_GROUP_COMMIT' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_LOGCAPTURE_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_LOGCAPTURE_WAIT' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_LOGPROGRESS_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_NOTIFICATION_DEQUEUE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_NOTIFICATION_WORKER_EXCLUSIVE_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_NOTIFICATION_WORKER_STARTUP_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_NOTIFICATION_WORKER_TERMINATION_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_PARTNER_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_READ_ALL_NETWORKS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_RECOVERY_WAIT_FOR_CONNECTION' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_RECOVERY_WAIT_FOR_UNDO' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_REPLICAINFO_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SEEDING_CANCELLATION' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SEEDING_FILE_LIST' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SEEDING_LIMIT_BACKUPS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SEEDING_SYNC_COMPLETION' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SEEDING_TIMEOUT_TASK' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SEEDING_WAIT_FOR_COMPLETION' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SYNC_COMMIT' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_SYNCHRONIZING_THROTTLE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_TDS_LISTENER_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_TDS_LISTENER_SYNC_PROCESSING' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_THROTTLE_LOG_RATE_GOVERNOR' AS WaitType,
           'Log Rate Governor' AS WaitCategory
    UNION ALL
    SELECT 'HADR_TIMER_TASK' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_TRANSPORT_DBRLIST' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_TRANSPORT_FLOW_CONTROL' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_TRANSPORT_SESSION' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_WORK_POOL' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_WORK_QUEUE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'HADR_XRF_STACK_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'INSTANCE_LOG_RATE_GOVERNOR' AS WaitType,
           'Log Rate Governor' AS WaitCategory
    UNION ALL
    SELECT 'IO_COMPLETION' AS WaitType,
           'Other Disk IO' AS WaitCategory
    UNION ALL
    SELECT 'IO_QUEUE_LIMIT' AS WaitType,
           'Other Disk IO' AS WaitCategory
    UNION ALL
    SELECT 'IO_RETRY' AS WaitType,
           'Other Disk IO' AS WaitCategory
    UNION ALL
    SELECT 'LATCH_DT' AS WaitType,
           'Latch' AS WaitCategory
    UNION ALL
    SELECT 'LATCH_EX' AS WaitType,
           'Latch' AS WaitCategory
    UNION ALL
    SELECT 'LATCH_KP' AS WaitType,
           'Latch' AS WaitCategory
    UNION ALL
    SELECT 'LATCH_NL' AS WaitType,
           'Latch' AS WaitCategory
    UNION ALL
    SELECT 'LATCH_SH' AS WaitType,
           'Latch' AS WaitCategory
    UNION ALL
    SELECT 'LATCH_UP' AS WaitType,
           'Latch' AS WaitCategory
    UNION ALL
    SELECT 'LAZYWRITER_SLEEP' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_BU' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_BU_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_BU_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IS_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IS_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IU' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IU_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IU_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IX' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IX_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_IX_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_NL' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_NL_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_NL_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_S' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_S_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_S_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_U' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_U_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_U_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_X' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_X_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RIn_X_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RS_S' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RS_S_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RS_S_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RS_U' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RS_U_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RS_U_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_S' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_S_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_S_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_U' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_U_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_U_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_X' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_X_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_RX_X_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_S' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_S_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_S_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SCH_M' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SCH_M_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SCH_M_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SCH_S' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SCH_S_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SCH_S_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SIU' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SIU_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SIU_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SIX' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SIX_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_SIX_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_U' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_U_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_U_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_UIX' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_UIX_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_UIX_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_X' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_X_ABORT_BLOCKERS' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LCK_M_X_LOW_PRIORITY' AS WaitType,
           'Lock' AS WaitCategory
    UNION ALL
    SELECT 'LOG_RATE_GOVERNOR' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'LOGBUFFER' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'LOGMGR' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'LOGMGR_FLUSH' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'LOGMGR_PMM_LOG' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'LOGMGR_QUEUE' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'LOGMGR_RESERVE_APPEND' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'MEMORY_ALLOCATION_EXT' AS WaitType,
           'Memory' AS WaitCategory
    UNION ALL
    SELECT 'MEMORY_GRANT_UPDATE' AS WaitType,
           'Memory' AS WaitCategory
    UNION ALL
    SELECT 'MSQL_XACT_MGR_MUTEX' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'MSQL_XACT_MUTEX' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'MSSEARCH' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'NET_WAITFOR_PACKET' AS WaitType,
           'Network IO' AS WaitCategory
    UNION ALL
    SELECT 'ONDEMAND_TASK_QUEUE' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'PAGEIOLATCH_DT' AS WaitType,
           'Buffer IO' AS WaitCategory
    UNION ALL
    SELECT 'PAGEIOLATCH_EX' AS WaitType,
           'Buffer IO' AS WaitCategory
    UNION ALL
    SELECT 'PAGEIOLATCH_KP' AS WaitType,
           'Buffer IO' AS WaitCategory
    UNION ALL
    SELECT 'PAGEIOLATCH_NL' AS WaitType,
           'Buffer IO' AS WaitCategory
    UNION ALL
    SELECT 'PAGEIOLATCH_SH' AS WaitType,
           'Buffer IO' AS WaitCategory
    UNION ALL
    SELECT 'PAGEIOLATCH_UP' AS WaitType,
           'Buffer IO' AS WaitCategory
    UNION ALL
    SELECT 'PAGELATCH_DT' AS WaitType,
           'Buffer Latch' AS WaitCategory
    UNION ALL
    SELECT 'PAGELATCH_EX' AS WaitType,
           'Buffer Latch' AS WaitCategory
    UNION ALL
    SELECT 'PAGELATCH_KP' AS WaitType,
           'Buffer Latch' AS WaitCategory
    UNION ALL
    SELECT 'PAGELATCH_NL' AS WaitType,
           'Buffer Latch' AS WaitCategory
    UNION ALL
    SELECT 'PAGELATCH_SH' AS WaitType,
           'Buffer Latch' AS WaitCategory
    UNION ALL
    SELECT 'PAGELATCH_UP' AS WaitType,
           'Buffer Latch' AS WaitCategory
    UNION ALL
    SELECT 'PARALLEL_REDO_DRAIN_WORKER' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PARALLEL_REDO_FLOW_CONTROL' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PARALLEL_REDO_LOG_CACHE' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PARALLEL_REDO_TRAN_LIST' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PARALLEL_REDO_TRAN_TURN' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PARALLEL_REDO_WORKER_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PARALLEL_REDO_WORKER_WAIT_WORK' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'POOL_LOG_RATE_GOVERNOR' AS WaitType,
           'Log Rate Governor' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_ABR' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_CLOSEBACKUPMEDIA' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_CLOSEBACKUPTAPE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_CLOSEBACKUPVDIDEVICE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_CLUSAPI_CLUSTERRESOURCECONTROL' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_COCREATEINSTANCE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_COGETCLASSOBJECT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_CREATEACCESSOR' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_DELETEROWS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_GETCOMMANDTEXT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_GETDATA' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_GETNEXTROWS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_GETRESULT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_GETROWSBYBOOKMARK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_LBFLUSH' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_LBLOCKREGION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_LBREADAT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_LBSETSIZE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_LBSTAT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_LBUNLOCKREGION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_LBWRITEAT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_QUERYINTERFACE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_RELEASE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_RELEASEACCESSOR' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_RELEASEROWS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_RELEASESESSION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_RESTARTPOSITION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_SEQSTRMREAD' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_SEQSTRMREADANDWRITE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_SETDATAFAILURE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_SETPARAMETERINFO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_SETPARAMETERPROPERTIES' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_STRMLOCKREGION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_STRMSEEKANDREAD' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_STRMSEEKANDWRITE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_STRMSETSIZE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_STRMSTAT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_COM_STRMUNLOCKREGION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_CONSOLEWRITE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_CREATEPARAM' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DEBUG' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSADDLINK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSLINKEXISTCHECK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSLINKHEALTHCHECK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSREMOVELINK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSREMOVEROOT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSROOTFOLDERCHECK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSROOTINIT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DFSROOTSHARECHECK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DTC_ABORT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DTC_ABORTREQUESTDONE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DTC_BEGINTRANSACTION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DTC_COMMITREQUESTDONE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DTC_ENLIST' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_DTC_PREPAREREQUESTDONE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_FILESIZEGET' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_FSAOLEDB_ABORTTRANSACTION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_FSAOLEDB_COMMITTRANSACTION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_FSAOLEDB_STARTTRANSACTION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_FSRECOVER_UNCONDITIONALUNDO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_GETRMINFO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_HADR_LEASE_MECHANISM' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_HTTP_EVENT_WAIT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_HTTP_REQUEST' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_LOCKMONITOR' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_MSS_RELEASE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_ODBCOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLE_UNINIT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_ABORTORCOMMITTRAN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_ABORTTRAN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_GETDATASOURCE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_GETLITERALINFO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_GETPROPERTIES' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_GETPROPERTYINFO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_GETSCHEMALOCK' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_JOINTRANSACTION' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_RELEASE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDB_SETPROPERTIES' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OLEDBOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_ACCEPTSECURITYCONTEXT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_ACQUIRECREDENTIALSHANDLE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_AUTHENTICATIONOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_AUTHORIZATIONOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_AUTHZGETINFORMATIONFROMCONTEXT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_AUTHZINITIALIZECONTEXTFROMSID' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_AUTHZINITIALIZERESOURCEMANAGER' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_BACKUPREAD' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_CLOSEHANDLE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_CLUSTEROPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_COMOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_COMPLETEAUTHTOKEN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_COPYFILE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_CREATEDIRECTORY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_CREATEFILE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_CRYPTACQUIRECONTEXT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_CRYPTIMPORTKEY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_CRYPTOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DECRYPTMESSAGE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DELETEFILE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DELETESECURITYCONTEXT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DEVICEIOCONTROL' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DEVICEOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DIRSVC_NETWORKOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DISCONNECTNAMEDPIPE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DOMAINSERVICESOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DSGETDCNAME' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_DTCOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_ENCRYPTMESSAGE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_FILEOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_FINDFILE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_FLUSHFILEBUFFERS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_FORMATMESSAGE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_FREECREDENTIALSHANDLE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_FREELIBRARY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GENERICOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETADDRINFO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETCOMPRESSEDFILESIZE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETDISKFREESPACE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETFILEATTRIBUTES' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETFILESIZE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETFINALFILEPATHBYHANDLE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETLONGPATHNAME' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETPROCADDRESS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETVOLUMENAMEFORVOLUMEMOUNTPOINT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_GETVOLUMEPATHNAME' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_INITIALIZESECURITYCONTEXT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_LIBRARYOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_LOADLIBRARY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_LOGONUSER' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_LOOKUPACCOUNTSID' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_MESSAGEQUEUEOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_MOVEFILE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_NETGROUPGETUSERS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_NETLOCALGROUPGETMEMBERS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_NETUSERGETGROUPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_NETUSERGETLOCALGROUPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_NETUSERMODALSGET' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_NETVALIDATEPASSWORDPOLICY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_NETVALIDATEPASSWORDPOLICYFREE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_OPENDIRECTORY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_PDH_WMI_INIT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_PIPEOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_PROCESSOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_QUERYCONTEXTATTRIBUTES' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_QUERYREGISTRY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_QUERYSECURITYCONTEXTTOKEN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_REMOVEDIRECTORY' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_REPORTEVENT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_REVERTTOSELF' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_RSFXDEVICEOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SECURITYOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SERVICEOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SETENDOFFILE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SETFILEPOINTER' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SETFILEVALIDDATA' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SETNAMEDSECURITYINFO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SQLCLROPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_SQMLAUNCH' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_VERIFYSIGNATURE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_VERIFYTRUST' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_VSSOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_WAITFORSINGLEOBJECT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_WINSOCKOPS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_WRITEFILE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_WRITEFILEGATHER' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_OS_WSASETLASTERROR' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_REENLIST' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_RESIZELOG' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_ROLLFORWARDREDO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_ROLLFORWARDUNDO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SB_STOPENDPOINT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SERVER_STARTUP' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SETRMINFO' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SHAREDMEM_GETDATA' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SNIOPEN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SOSHOST' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SOSTESTING' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_SP_SERVER_DIAGNOSTICS' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_STARTRM' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_STREAMFCB_CHECKPOINT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_STREAMFCB_RECOVER' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_STRESSDRIVER' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_TESTING' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_TRANSIMPORT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_UNMARSHALPROPAGATIONTOKEN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_VSS_CREATESNAPSHOT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_VSS_CREATEVOLUMESNAPSHOT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_CALLBACKEXECUTE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_CX_FILE_OPEN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_CX_HTTP_CALL' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_DISPATCHER' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_ENGINEINIT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_GETTARGETSTATE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_SESSIONCOMMIT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_TARGETFINALIZE' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_TARGETINIT' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XE_TIMERRUN' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PREEMPTIVE_XETESTING' AS WaitType,
           'Preemptive' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_ACTION_COMPLETED' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_CHANGE_NOTIFIER_TERMINATION_SYNC' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_CLUSTER_INTEGRATION' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_FAILOVER_COMPLETED' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_JOIN' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_OFFLINE_COMPLETED' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_ONLINE_COMPLETED' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_POST_ONLINE_COMPLETED' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_SERVER_READY_CONNECTIONS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADR_WORKITEM_COMPLETED' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_HADRSIM' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'PWAIT_RESOURCE_SEMAPHORE_FT_PARALLEL_QUERY_SYNC' AS WaitType,
           'Full Text Search' AS WaitCategory
    UNION ALL
    SELECT 'QDS_ASYNC_QUEUE' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'QDS_SHUTDOWN_QUEUE' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'QUERY_TRACEOUT' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'REDO_THREAD_PENDING_WORK' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'REPL_CACHE_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'REPL_HISTORYCACHE_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'REPL_SCHEMA_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'REPL_TRANFSINFO_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'REPL_TRANHASHTABLE_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'REPL_TRANTEXTINFO_ACCESS' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'REPLICA_WRITES' AS WaitType,
           'Replication' AS WaitCategory
    UNION ALL
    SELECT 'REQUEST_FOR_DEADLOCK_SEARCH' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'RESERVED_MEMORY_ALLOCATION_EXT' AS WaitType,
           'Memory' AS WaitCategory
    UNION ALL
    SELECT 'RESOURCE_SEMAPHORE' AS WaitType,
           'Memory' AS WaitCategory
    UNION ALL
    SELECT 'RESOURCE_SEMAPHORE_QUERY_COMPILE' AS WaitType,
           'Compilation' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_BPOOL_FLUSH' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_BUFFERPOOL_HELPLW' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_DBSTARTUP' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_DCOMSTARTUP' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_MASTERDBREADY' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_MASTERMDREADY' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_MASTERUPGRADED' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_MEMORYPOOL_ALLOCATEPAGES' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_MSDBSTARTUP' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_RETRY_VIRTUALALLOC' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_SYSTEMTASK' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_TASK' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_TEMPDBSTARTUP' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SLEEP_WORKSPACE_ALLOCATEPAGE' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SOS_SCHEDULER_YIELD' AS WaitType,
           'CPU' AS WaitCategory
    UNION ALL
    SELECT 'SOS_WORK_DISPATCHER' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SP_SERVER_DIAGNOSTICS_SLEEP' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'SQLCLR_APPDOMAIN' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'SQLCLR_ASSEMBLY' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'SQLCLR_DEADLOCK_DETECTION' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'SQLCLR_QUANTUM_PUNISHMENT' AS WaitType,
           'SQL CLR' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_BUFFER_FLUSH' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_FILE_BUFFER' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_FILE_READ_IO_COMPLETION' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_FILE_WRITE_IO_COMPLETION' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_PENDING_BUFFER_WRITERS' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_SHUTDOWN' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'SQLTRACE_WAIT_ENTRIES' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'THREADPOOL' AS WaitType,
           'Worker Thread' AS WaitCategory
    UNION ALL
    SELECT 'TRACE_EVTNOTIF' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'TRACEWRITE' AS WaitType,
           'Tracing' AS WaitCategory
    UNION ALL
    SELECT 'TRAN_MARKLATCH_DT' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'TRAN_MARKLATCH_EX' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'TRAN_MARKLATCH_KP' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'TRAN_MARKLATCH_NL' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'TRAN_MARKLATCH_SH' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'TRAN_MARKLATCH_UP' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'TRANSACTION_MUTEX' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'UCS_SESSION_REGISTRATION' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'WAIT_FOR_RESULTS' AS WaitType,
           'User Wait' AS WaitCategory
    UNION ALL
    SELECT 'WAIT_XTP_OFFLINE_CKPT_NEW_LOG' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'WAITFOR' AS WaitType,
           'User Wait' AS WaitCategory
    UNION ALL
    SELECT 'WRITE_COMPLETION' AS WaitType,
           'Other Disk IO' AS WaitCategory
    UNION ALL
    SELECT 'WRITELOG' AS WaitType,
           'Tran Log IO' AS WaitCategory
    UNION ALL
    SELECT 'XACT_OWN_TRANSACTION' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'XACT_RECLAIM_SESSION' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'XACTLOCKINFO' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'XACTWORKSPACE_MUTEX' AS WaitType,
           'Transaction' AS WaitCategory
    UNION ALL
    SELECT 'XE_DISPATCHER_WAIT' AS WaitType,
           'Idle' AS WaitCategory
    UNION ALL
    SELECT 'XE_LIVE_TARGET_TVF' AS WaitType,
           'Other' AS WaitCategory
    UNION ALL
    SELECT 'XE_TIMER_EVENT' AS WaitType,
           'Idle' AS WaitCategory),
      cte_WaitStats AS (
	SELECT ws.wait_type,
		   c.wait_time_s,
		   CAST((CAST(ws.sum_wait_time_ms AS MONEY)) / 1000.0 / cores.cpu_count AS DECIMAL(18, 1)) AS wait_time_per_core_s,
		   c.signal_wait_time_s,
		   CASE
			   WHEN c.wait_time_s > 0 THEN
				   CAST(100. * (c.signal_wait_time_s / c.wait_time_s) AS NUMERIC(4, 1))
			   ELSE
				   0
		   END AS signal_wait_percent,
		   ws.sum_waiting_tasks AS wait_count,
		   CAST(ws.sum_wait_time_ms / (1.0 * (ws.sum_waiting_tasks)) AS NUMERIC(12, 1)) avg_wait_per_ms
	FROM 
		(
		SELECT os.wait_type,
			SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
			SUM(os.signal_wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_signal_wait_time_ms,
			SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
			FROM sys.dm_os_wait_stats os
			WHERE os.waiting_tasks_count > 0
				AND EXISTS
				(
					SELECT 1 / 0
					FROM cte_WaitCategories AS wc
					WHERE wc.WaitType = os.wait_type
				)   
		) ws
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
		) AS c
)
SELECT @@SERVERNAME AS server_name,
       SYSDATETIMEOFFSET() AS sample_time,
       0 second_sample,
       wcat.WaitType wait_type,
       wcat.WaitCategory wait_category,
       COALESCE(ws.wait_time_s, 0) wait_time_s,
       COALESCE(ws.wait_time_per_core_s, 0) wait_time_per_core_s,
       COALESCE(ws.signal_wait_time_s, 0) signal_wait_time_s,
       COALESCE(ws.signal_wait_percent, 0) signal_wait_percent,
       COALESCE(ws.wait_count, 0) wait_count,
       COALESCE(ws.avg_wait_per_ms, 0) avg_wait_per_ms
FROM cte_WaitCategories wcat
    LEFT OUTER JOIN cte_WaitStats ws
        ON wcat.WaitType = ws.wait_type