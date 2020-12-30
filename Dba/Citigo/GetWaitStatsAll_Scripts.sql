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
FROM cte_WaitStats ws
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
WHERE ws.sum_waiting_tasks > 0