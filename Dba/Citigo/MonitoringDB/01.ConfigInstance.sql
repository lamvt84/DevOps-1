USE [master]
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'blocked process threshold', 15; --seconds --default 0=off
GO
RECONFIGURE;
GO