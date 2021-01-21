# List backup history

```sql
SELECT
        CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server,
        msdb.dbo.backupset.database_name,
        CONVERT(VARCHAR,msdb.dbo.backupset.backup_start_date, 121) backup_start_date,
        CONVERT(VARCHAR,msdb.dbo.backupset.backup_finish_date, 121) backup_finish_date,
        msdb.dbo.backupset.backup_finish_date create_date,
        msdb.dbo.backupset.expiration_date,
        CASE msdb..backupset.type
        WHEN 'D' THEN 'Full'
        WHEN 'L' THEN 'Log'
        WHEN 'I'  THEN 'Diff'
        END AS backup_type,
        msdb.dbo.backupset.backup_size,
        msdb.dbo.backupmediafamily.logical_device_name,
        msdb.dbo.backupmediafamily.physical_device_name,
        msdb.dbo.backupset.name AS backupset_name,
        msdb.dbo.backupset.description
    FROM msdb.dbo.backupmediafamily
    INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
    WHERE 1 = 1
    AND (CONVERT(VARCHAR, msdb.dbo.backupset.backup_start_date, 112) >= CONVERT(VARCHAR, GETDATE() - 7, 112))
    ORDER BY
        msdb.dbo.backupset.database_name,
        msdb.dbo.backupset.backup_finish_date
```