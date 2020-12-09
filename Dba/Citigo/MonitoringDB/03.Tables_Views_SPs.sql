:setvar DatabaseName "EventMonitoring"
:setvar DBPhysicalPath "E:\Database\2019\EventMonitoring\"

USE [$(DatabaseName)]
GO

/* TABLES */
IF OBJECT_ID('DeadlockLog') IS NULL
    CREATE TABLE DeadlockLog
    (
        [Id] BIGINT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
        DatabaseName NVARCHAR(100),
        [Time] DATETIME,
        BlockedXactid INT,
        BlockingXactid INT,
        BlockedQuery NVARCHAR(MAX),
        BlockingQuery NVARCHAR(MAX),
        LockMode NVARCHAR(5),
        XMLReport XML
    )
GO
CREATE INDEX IX_Time_Incl ON DeadlockLog ([Time] ASC) 
    INCLUDE (
            [DatabaseName],
            [BlockedXactid],
            [BlockingXactid],
            [BlockedQuery],
            [BlockingQuery],
            [LockMode],
            [XMLReport]
        )

IF OBJECT_ID('BlockedProcessReports') IS NULL
    CREATE TABLE [BlockedProcessReports]
    (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        database_name SYSNAME,
        post_time DATETIME,
        insert_time DATETIME,
        wait_time INT,
        blocked_xactid BIGINT,
        blocking_xactid BIGINT,
        is_blocking_source BIT, --1=Query block chính
        blocked_inputbuf NVARCHAR(MAX), --Query bị block
        blocking_inputbuf NVARCHAR(MAX), --Query block
        blocked_process_report XML --Full XML report
    );
GO

ALTER TABLE [BlockedProcessReports] ADD CONSTRAINT DF_BlockedProcessReports_InsertTime DEFAULT GETDATE() FOR insert_time
GO

CREATE INDEX IX_BlockingXactId_BlockedXactId_WaitTime
ON [dbo].[BlockedProcessReports] 
(    [blocking_xactid] ASC,
    [blocked_xactid] ASC,
    [wait_time] ASC
)
GO

CREATE INDEX [IX_PostTime_IsBlockingSource_Incl] 
ON [dbo].[BlockedProcessReports]
(    [post_time] ASC,
    [is_blocking_source] ASC
)
INCLUDE (     [wait_time],
    [blocked_xactid],
    [blocking_xactid],
    [blocking_inputbuf])
GO

--Tạo bảng để log lại câu query full. blocked_inputbuf, blocking_inputbuf bị truncate. Để lấy đc query đầy đủ phải dùng SQLHandle.
IF OBJECT_ID('[BlockedProcessReportsDetail]') IS NULL
    CREATE TABLE [BlockedProcessReportsDetail]
    (
        Id BIGINT IDENTITY(1,1) PRIMARY KEY,
        BlockedProcessReportId BIGINT NOT NULL,
        BlockedSQLText NVARCHAR(MAX),
        BlockingSQLText NVARCHAR(MAX)
    );
GO

ALTER TABLE [dbo].[BlockedProcessReportsDetail]  WITH CHECK ADD  CONSTRAINT [FK_BlockedProcessReportsDetail_BlockedProcessReports] FOREIGN KEY([BlockedProcessReportId])
REFERENCES [dbo].[BlockedProcessReports] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[BlockedProcessReportsDetail] CHECK CONSTRAINT [FK_BlockedProcessReportsDetail_BlockedProcessReports]
GO

--Index for 4h report
CREATE INDEX [IX_BlockedProcessReportsId_Incl] 
ON [dbo].[BlockedProcessReportsDetail] ([BlockedProcessReportId] ASC)
INCLUDE ([BlockingSQLText])
GO

CREATE TABLE [dbo].[SlowQueryLog] (
    [Id] BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED ,
    [Time] DATETIME,
    [Duration] FLOAT,
    [CPUTime] FLOAT,
    [PhysicalReads] INT,
    [LogicalReads] INT,
    [Writes] INT,
    [User] NVARCHAR(100),
    [AppName] NVARCHAR(100),
    [Database] NVARCHAR(100),
    [STMT_Batch_Text] NVARCHAR(MAX),
    [SQLText] NVARCHAR(MAX)
)
GO

-- Index hỗ trợ 6h report
CREATE NONCLUSTERED INDEX [IX_Time_Incl] ON [dbo].[SlowQueryLog]
(
    [Time] ASC
)
INCLUDE (     [Duration],
    [CPUTime],
    [PhysicalReads],
    [LogicalReads],
    [Writes],
    [STMT_Batch_Text],
    [SQLText])


/* VIEWS */
--View for daily report using linked server
CREATE VIEW [dbo].[View_BlocksReport]
AS
SELECT  [database_name],
        [post_time],
        [wait_time],
        [blocked_xactid],
        [blocking_xactid],
        [is_blocking_source],
        [blocked_inputbuf],
        [blocking_inputbuf]
FROM    dbo.BlockedProcessReports;
GO

