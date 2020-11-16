USE [master]
GO

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

:setvar DatabaseName "EDWInitiatorSB"
:setvar DefaultFilePrefix "EDWInitiatorSB"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""
GO

:on error exit
GO

CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Log.ldf') COLLATE SQL_Latin1_General_CP1_CS_AS
GO

ALTER DATABASE [$(DatabaseName)]
    SET ENABLE_BROKER,
        TRUSTWORTHY ON
    WITH ROLLBACK IMMEDIATE

USE [$(DatabaseName)]
GO

/* Table 

*/
