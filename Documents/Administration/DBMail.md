# DB Mail

### Prerequisites to Enable Database Mail

To enable the database mail feature, the following prerequisites are required:

* Service Broker for MSDB database must be enabled.

```sql
USE master 
GO
SELECT database_id AS 'Database ID', 
       NAME        AS 'Database Name', 
       CASE 
         WHEN is_broker_enabled = 0 THEN 'Service Broker is disabled.' 
         WHEN is_broker_enabled = 1 THEN 'Service Broker is Enabled.' 
       END         AS 'Service Broker Status' 
FROM   sys.databases 
WHERE  NAME = 'msdb'
/* Enable if not */
Use master
GO
ALTER DATABASE [MSDB] SET single_user WITH ROLLBACK immediate
GO
ALTER DATABASE [MSDB] SET Enable_Broker
GO
ALTER DATABASE [MSDB] SET multi_user WITH ROLLBACK immediate
GO
```

* SQL Server Agent service must be running.

### Installation

**Enable Database Mail**

```sql
USE master
Go
EXEC sp_configure 'show advanced options' --Enable advance option
GO
RECONFIGURE
Go
EXEC sp_configure 'Database Mail XPs' --Enable database Mail option
Go
RECONFIGURE
Go
EXEC sp_configure 'show advanced options' --Disabled advanced option
Go
RECONFIGURE
Go
```

**Create Profile**

```sql
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'Database Mail Profile'
  , @description = 'This profile will be used to send database mail'
GO
```

**Create Account**

```sql
EXEC msdb.dbo.sysmail_add_account_sp @account_name = 'Database Mail Account',
                                     @description = 'Account for DBA Alerts',
                                     @email_address = '',
                                     @display_name = '', -- name of the mail account that is displayed in messages
                                     @replyto_address = '',
                                     @mailserver_type = 'SMTP',
                                     @mailserver_name = '',
                                     @port = 21,
                                     @username = '',
                                     @password = '',
                                     @enable_ssl = 1
GO

EXEC msdb.dbo.sysmail_add_profileaccount_sp @profile_name = 'Database Mail Profile',
                                            @account_name = 'Database Mail Account',
                                            @sequence_number = 1
GO
```

**Test**

```sql
EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Database Mail Profile',
							@recipients = 'abc@gmail.com',
							@subject = 'test email',
							@body = 'This is a test email',
							@importance = 'high';
GO
```

### List of essential tables to check the email status

Following is the list of tables, used to view configuration database mail, database account and status of the email.

| Configuration                  | List of table and view or Query |
| :----------------------------- | :------------------------------ |
| View list of profiles          | msdb.dbo.sysmail_profile        |
| View list of accounts          | msdb.dbo.sysmail_account        |
| View Mail server configuration | msdb.dbo.sysmail_server         |
|                                | msdb.dbo.sysmail_servertype     |
|                                | msdb.dbo.sysmail_configuration  |
| View Email Sent Status         | msdb.dbo.sysmail_allitems       |
|                                | msdb.dbo.sysmail_sentitems      |
|                                | msdb.dbo.sysmail_unsentitems    |
|                                | msdb.dbo.sysmail_faileditems    |
| View Status of events          | msdb.dbo.sysmail_event_log      |

### List of essential SP to config DB Mail

Following is the list of tables, used to view configuration database mail, database account and status of the email.

| Configuration | List of SP                |
| :------------ | :------------------------ |
| Config        | sysmail_configure_sp      |
| Config Help   | sysmail_help_configure_sp |

### Dropping Database Mail

```sql
/* Detach account from profile */
IF EXISTS
(
    SELECT *
    FROM msdb.dbo.sysmail_profileaccount pa
        INNER JOIN msdb.dbo.sysmail_profile p
            ON pa.profile_id = p.profile_id
        INNER JOIN msdb.dbo.sysmail_account a
            ON pa.account_id = a.account_id
    WHERE p.name = 'Database Mail Profile'
          AND a.name = 'Database Mail Default SMTP account'
)
BEGIN
    EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = 'Database Mail Profile',
                                                      @account_name = 'Database Mail Account'
END
/* Drop account */
IF EXISTS
(
    SELECT *
    FROM msdb.dbo.sysmail_account
    WHERE name = 'Database Mail Account'
)
BEGIN
    EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = 'Database Mail Account'
END
/* Drop profile */
IF EXISTS
(
    SELECT *
    FROM msdb.dbo.sysmail_profile
    WHERE name = 'Database Mail Profile'
)
BEGIN
    EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = 'Database Mail Profile'
END
```

