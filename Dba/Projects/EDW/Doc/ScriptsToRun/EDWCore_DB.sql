USE [master]
GO

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

:setvar DatabaseName "EDWCore"
:setvar DefaultFilePrefix "EDWCore"
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

USE [$(DatabaseName)]
GO

/* SCHEMA */
CREATE SCHEMA [Core] AUTHORIZATION [dbo];
CREATE SCHEMA [Dataflow] AUTHORIZATION [dbo];
CREATE SCHEMA [Ref] AUTHORIZATION [dbo];
CREATE SCHEMA [Staging] AUTHORIZATION [dbo];

/* Table 

*/

/* SP 

*/