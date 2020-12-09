:setvar DatabaseName "EventMonitoring"
:setvar DBPhysicalPath "E:\Database\2019\EventMonitoring\"

/* Monitoring DB */
USE [master]
GO
IF EXISTS (SELECT 1 / 0 FROM sys.databases WHERE name = '$(DatabaseName)')
BEGIN
    PRINT '$(DatabaseName) is existed'
    SET NOEXEC ON
END
GO

CREATE DATABASE $(DatabaseName) CONTAINMENT = NONE
ON PRIMARY
       (
           NAME = N'$(DatabaseName)',
           FILENAME = N'$(DBPhysicalPath)\$(DatabaseName).mdf',
           SIZE = 8MB,
           MAXSIZE = 5GB,
           FILEGROWTH = 50MB
       )
LOG ON
    (
        NAME = N'$(DatabaseName)_Log',
        FILENAME = N'$(DBPhysicalPath)\$(DatabaseName)_log.ldf',
        SIZE = 50MB,
        MAXSIZE = 1GB,
        FILEGROWTH = 50MB
    )
GO
ALTER DATABASE [$(DatabaseName)] SET RECOVERY SIMPLE
GO
ALTER DATABASE [$(DatabaseName)] SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE
GO