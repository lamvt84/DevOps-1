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

/* Table */
CREATE TABLE [dbo].[BrokerConversation] (
    [ConversationHandle] UNIQUEIDENTIFIER NULL,
    [ServiceName]        NVARCHAR (512)   NULL
);
GO

CREATE TABLE [dbo].[BrokerMessages] (
    [Id]                  INT              IDENTITY (1, 1) NOT NULL,
    [ConversationHandler] UNIQUEIDENTIFIER NULL,
    [MessageTypeName]     NVARCHAR (256)   NULL,
    [MessageBody]         XML              NULL
);
GO

CREATE TABLE [dbo].[ErrorLog] (
    [ErrorLogID]     INT                IDENTITY (1, 1) NOT NULL,
    [ErrorTime]      DATETIMEOFFSET (7) NOT NULL,
    [UserName]       [sysname]          NOT NULL,
    [ErrorNumber]    INT                NOT NULL,
    [ErrorSeverity]  INT                NULL,
    [ErrorState]     INT                NULL,
    [ErrorProcedure] NVARCHAR (126)     NULL,
    [ErrorLine]      INT                NULL,
    [ErrorMessage]   NVARCHAR (4000)    NOT NULL,
    [MessageBody]    XML                NULL,
    CONSTRAINT [PK_ErrorLog_ErrorLogID] PRIMARY KEY CLUSTERED ([ErrorLogID] ASC)
);
GO

