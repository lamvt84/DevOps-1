-- detach db before moving physical files
USE [master]
GO
exec sp_detach_db @dbname = N'$(DatabaseName)'
GO

-- enable xp_cmdshell
exec sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
exec sp_configure 'xp_cmdshell', 1  -- 0 = Disable , 1 = Enable
GO
RECONFIGURE
GO

-- move physical files
EXEC xp_cmdshell 'MOVE "$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf", "D:\Datatest\$(DatabaseName).mdf"'
EXEC xp_cmdshell 'MOVE "$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf", "D:\Datatest\$(DatabaseName)_log.ldf"'
GO

-- reattach db with new filepath
CREATE DATABASE [$(DatabaseName)] ON 
(NAME = [$(DatabaseName)], FILENAME = 'D:\Datatest\$(DatabaseName).mdf'),
(NAME = [$(DatabaseName)_log], FILENAME = 'D:\Datatest\$(DatabaseName)_log.ldf')
FOR ATTACH
GO

-- disable xp_cmdshell
exec sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
exec sp_configure 'xp_cmdshell', 0  -- 0 = Disable , 1 = Enable
GO
RECONFIGURE
GO

USE [$(DatabaseName)];
GO