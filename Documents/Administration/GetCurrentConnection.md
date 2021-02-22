### Get current connections

```sql
SELECT 
		DB_NAME(database_id) as [DB],
      s.host_name, 
	  s.original_login_name,
      c.client_net_address
  FROM sys.dm_exec_connections AS c
  JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
GROUP BY DB_NAME(database_id),
      s.host_name, 
	  s.original_login_name,
      c.client_net_address
```

```sql
SELECT  spid,
        sp.[status],
        loginame [Login],
        hostname, 
        blocked BlkBy,
        sd.name DBName, 
        cmd Command,
        cpu CPUTime,
        physical_io DiskIO,
        last_batch LastBatch,
        [program_name] ProgramName,
		sp.login_time
FROM master.sys.sysprocesses sp 
INNER JOIN master.sys.sysdatabases sd ON sp.dbid = sd.dbid
WHERE spid > 50 -- Filtering System spid
ORDER BY spid
```