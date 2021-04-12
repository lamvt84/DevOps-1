IF EXISTS (SELECT 1/0 FROM sys.server_event_sessions WHERE name = 'KV_SlowQueryLog')
    DROP EVENT SESSION [KV_SlowQueryLog] ON SERVER 

CREATE EVENT SESSION [KV_SlowQueryLog] ON SERVER
    ADD EVENT sqlserver.rpc_completed (
        ACTION ( sqlserver.client_app_name, sqlserver.client_hostname,
        sqlserver.database_id, sqlserver.database_name, sqlserver.plan_handle,
        sqlserver.sql_text, sqlserver.username )
        WHERE [duration] > ( 5000000 )), --5s in microseconds
    ADD EVENT sqlserver.sql_statement_completed (
        ACTION ( sqlserver.client_app_name, sqlserver.client_hostname,
        sqlserver.database_id, sqlserver.database_name, sqlserver.plan_handle,
        sqlserver.sql_text, sqlserver.username )
        WHERE [duration] > ( 5000000 ))
    --          ,
    --ADD EVENT sqlserver.query_memory_grant_usage (
    --    ACTION ( sqlserver.client_app_name, sqlserver.client_hostname,
    --    sqlserver.database_id, sqlserver.database_name, sqlserver.plan_handle,
    --    sqlserver.sql_text, sqlserver.username )
    --    WHERE ( [granted_memory_kb] > ( 1000 ) --Mem granted in KB
    --            AND [database_name] = N'KiotViet'
    --          ) )
    ADD TARGET package0.ring_buffer ( SET max_events_limit = ( 1500 ) ,
                                    max_memory = ( 50000 ) ) --Max 50MB
    WITH ( MAX_MEMORY = 4096 KB ,
            EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS ,
            MAX_DISPATCH_LATENCY = 1 SECONDS ,
            MAX_EVENT_SIZE = 0 KB ,
            MEMORY_PARTITION_MODE = NONE ,
            TRACK_CAUSALITY = OFF ,
            STARTUP_STATE = OFF );

IF NOT EXISTS (SELECT 1/0 FROM sys.dm_xe_sessions WHERE [name] = 'KV_SlowQueryLog')
    ALTER EVENT SESSION KV_SlowQueryLog ON SERVER STATE = START;
