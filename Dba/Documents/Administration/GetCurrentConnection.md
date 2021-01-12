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

