CREATE USER [sqlmonitor] FOR LOGIN [sqlmonitor] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [sqlmonitor]
GO