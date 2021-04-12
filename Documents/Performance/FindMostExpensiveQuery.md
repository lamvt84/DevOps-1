### Find most expensive queries

```sql
SELECT TOP (50)
       qs.execution_count AS [Execution Count],
       (qs.total_logical_reads) / 1000.0 AS [Total Logical Reads in ms],
       (qs.total_logical_reads / qs.execution_count) / 1000.0 AS [Avg Logical Reads in ms],
	   qs.last_logical_reads last_logical_reads,
       (qs.total_worker_time) / 1000.0 AS [Total Worker Time in ms],
       (qs.total_worker_time / qs.execution_count) / 1000.0 AS [Avg Worker Time in ms],
	   qs.last_worker_time / 1000. last_worker_time,
       (qs.total_elapsed_time) / 1000.0 AS [Total Elapsed Time in ms],
       (qs.total_elapsed_time / qs.execution_count) / 1000.0 AS [Avg Elapsed Time in ms],
	   qs.last_elapsed_time / 1000. last_elapsed_time,
       qs.creation_time AS [Creation Time],
       last_execution_time,
       t.TEXT AS [Complete Query Text],       
      -- convert(xml,'<xml><![CDATA[' + cast(t.TEXT as varchar(max)) + ']]></xml>') [Full Query XML],
       qp.query_plan AS [Query Plan]
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
    CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
    CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
WHERE qs.last_execution_time > '2021-03-16 16:00:00'
ORDER BY qs.execution_count DESC OPTION (RECOMPILE); -- for frequently ran query
-- ORDER BY [Avg Logical Reads in ms] DESC OPTION (RECOMPILE);-- for High Disk Reading query
-- ORDER BY [Avg Worker Time in ms] DESC OPTION (RECOMPILE);-- for High CPU query
-- ORDER BY [Avg Elapsed Time in ms] DESC OPTION (RECOMPILE);-- for Long Running query
```