:setvar DatabaseName "EventMonitoring"
:setvar DBPhysicalPath "E:\Database\2019\EventMonitoring\"

/* Configuration */
USE [master]
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'blocked process threshold', 15; --seconds --default 0=off
GO
RECONFIGURE;
GO

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

USE [$(DatabaseName)]
GO

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
CREATE INDEX IX_Time_Incl
ON DeadlockLog ([Time] ASC)
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

ALTER TABLE [BlockedProcessReports] ADD CONSTRAINT
DF_BlockedProcessReports_InsertTime DEFAULT GETDATE() FOR insert_time
GO

CREATE INDEX IX_BlockingXactId_BlockedXactId_WaitTime
ON [dbo].[BlockedProcessReports] 
(    [blocking_xactid] ASC,
    [blocked_xactid] ASC,
    [wait_time] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_PostTime_IsBlockingSource_Incl] 
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






CREATE TABLE [dbo].[BlockedProcessReports]
(
    [id] [bigint] IDENTITY(1, 1) NOT NULL,
    [database_name] [sysname] NOT NULL,
    [post_time] [datetime] NULL,
    [insert_time] [datetime] NULL,
    [wait_time] [int] NULL,
    [blocked_xactid] [bigint] NULL,
    [blocking_xactid] [bigint] NULL,
    [is_blocking_source] [bit] NULL,
    [blocked_inputbuf] [nvarchar](max) NULL,
    [blocking_inputbuf] [nvarchar](max) NULL,
    [blocked_process_report] [xml] NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
         ) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_BlocksReport]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_BlocksReport]
AS
SELECT [database_name],
       [post_time],
       [wait_time],
       [blocked_xactid],
       [blocking_xactid],
       [is_blocking_source],
       [blocked_inputbuf],
       [blocking_inputbuf]
FROM dbo.BlockedProcessReports;
GO
/****** Object:  Table [dbo].[BlockedProcessReportsDetail]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlockedProcessReportsDetail]
(
    [Id] [bigint] IDENTITY(1, 1) NOT NULL,
    [BlockedProcessReportId] [bigint] NOT NULL,
    [BlockedSQLText] [nvarchar](max) NULL,
    [BlockingSQLText] [nvarchar](max) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
         ) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeadlockLog]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeadlockLog]
(
    [Id] [bigint] IDENTITY(1, 1) NOT NULL,
    [DatabaseName] [nvarchar](100) NULL,
    [Time] [datetime] NULL,
    [BlockedXactid] [int] NULL,
    [BlockingXactid] [int] NULL,
    [BlockedQuery] [nvarchar](max) NULL,
    [BlockingQuery] [nvarchar](max) NULL,
    [LockMode] [nvarchar](5) NULL,
    [XMLReport] [xml] NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
         ) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SlowQueryLog]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SlowQueryLog]
(
    [ID] [bigint] IDENTITY(1, 1) NOT NULL,
    [Time] [datetime] NULL,
    [Duration] [float] NULL,
    [CPUTime] [float] NULL,
    [PhysicalReads] [int] NULL,
    [LogicalReads] [int] NULL,
    [Writes] [int] NULL,
    [User] [nvarchar](100) NULL,
    [AppName] [nvarchar](100) NULL,
    [Database] [nvarchar](100) NULL,
    [STMT_Batch_Text] [nvarchar](max) NULL,
    [SQLText] [nvarchar](max) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
         ) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Test_blocking]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test_blocking]
(
    [Zap_Id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [NCI-BlockedProcReports-BlockingXactId-BlockedXactId-WaitTime]    Script Date: 12/4/2020 11:28:37 AM ******/
CREATE NONCLUSTERED INDEX [NCI-BlockedProcReports-BlockingXactId-BlockedXactId-WaitTime]
ON [dbo].[BlockedProcessReports] (
                                     [blocking_xactid] ASC,
                                     [blocked_xactid] ASC,
                                     [wait_time] ASC
                                 )
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
     )
ON [PRIMARY]
GO
/****** Object:  Index [NCI-BlockedProcReports-PostTime-IsBlockingSource]    Script Date: 12/4/2020 11:28:37 AM ******/
CREATE NONCLUSTERED INDEX [NCI-BlockedProcReports-PostTime-IsBlockingSource]
ON [dbo].[BlockedProcessReports] (
                                     [post_time] ASC,
                                     [is_blocking_source] ASC
                                 )
INCLUDE (
            [wait_time],
            [blocked_xactid],
            [blocking_xactid],
            [blocking_inputbuf]
        )
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
     )
ON [PRIMARY]
GO
/****** Object:  Index [NCI-BlockedProcReportsDetail-BlockedProcessReportsId]    Script Date: 12/4/2020 11:28:37 AM ******/
CREATE NONCLUSTERED INDEX [NCI-BlockedProcReportsDetail-BlockedProcessReportsId]
ON [dbo].[BlockedProcessReportsDetail] ([BlockedProcessReportId] ASC)
INCLUDE ([BlockingSQLText])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
     )
ON [PRIMARY]
GO
/****** Object:  Index [NCI-DeadlockLog-Time]    Script Date: 12/4/2020 11:28:37 AM ******/
CREATE NONCLUSTERED INDEX [NCI-DeadlockLog-Time]
ON [dbo].[DeadlockLog] ([Time] ASC)
INCLUDE (
            [DatabaseName],
            [BlockedXactid],
            [BlockingXactid],
            [BlockedQuery],
            [BlockingQuery],
            [LockMode],
            [XMLReport]
        )
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
     )
ON [PRIMARY]
GO
/****** Object:  Index [NCI-SlowQueryLog-Time]    Script Date: 12/4/2020 11:28:37 AM ******/
CREATE NONCLUSTERED INDEX [NCI-SlowQueryLog-Time]
ON [dbo].[SlowQueryLog] ([Time] ASC)
INCLUDE (
            [Duration],
            [CPUTime],
            [PhysicalReads],
            [LogicalReads],
            [Writes],
            [STMT_Batch_Text],
            [SQLText]
        )
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
     )
ON [PRIMARY]
GO
ALTER TABLE [dbo].[BlockedProcessReports]
ADD CONSTRAINT [DF_BlockedProcessReports_InsertTime]
    DEFAULT (GETDATE()) FOR [insert_time]
GO
ALTER TABLE [dbo].[BlockedProcessReportsDetail] WITH CHECK
ADD CONSTRAINT [FK_BlockedProcessReportsDetail_BlockedProcessReports]
    FOREIGN KEY ([BlockedProcessReportId])
    REFERENCES [dbo].[BlockedProcessReports] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlockedProcessReportsDetail] CHECK CONSTRAINT [FK_BlockedProcessReportsDetail_BlockedProcessReports]
GO
/****** Object:  StoredProcedure [dbo].[pr_HourlyBlocksReport]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_HourlyBlocksReport]
(
    @Interval TINYINT, --Report from last ? hour
    @EmailTo NVARCHAR(200)
)
AS
SET NOCOUNT ON
DECLARE @subject NVARCHAR(MAX),
        @body NVARCHAR(MAX),
        @xml NVARCHAR(MAX);
DECLARE @err NVARCHAR(2000) = ''

--Get report
BEGIN TRY
    WITH cte
    AS (SELECT 'DB.1' AS DB,
               MAX(MaxTime) AS MaxTime,
               SUM(Blocks) AS BlockTimes,
               blocking_inputbuf AS BlockingQuery
        FROM
        (
            SELECT MAX(wait_time) AS MaxTime,
                   1 AS Blocks,
                   blocked_xactid,
                   blocking_xactid,
                   blocking_inputbuf
            FROM [EventMonitoring].[dbo].[View_BlocksReport]
            WHERE (post_time
                  BETWEEN DATEADD(HOUR, - (@Interval), GETDATE()) AND GETDATE()
                  )
                  AND is_blocking_source = 1
                  AND blocking_inputbuf IS NOT NULL
                  AND blocking_inputbuf != ''
            GROUP BY blocked_xactid,
                     blocking_xactid,
                     blocking_inputbuf
        ) AS a
        GROUP BY blocking_inputbuf)

    --Format HTML table email body
    SELECT @xml = CAST(
        (
            SELECT [DB] AS 'td',
                   '',
                   [MaxTime] AS 'td',
                   '',
                   [BlockTimes] AS 'td',
                   '',
                   [BlockingQuery] AS 'td'
            FROM cte
            FOR XML PATH('tr'), ELEMENTS
        ) AS NVARCHAR(MAX));
END TRY
BEGIN CATCH
    SELECT @err = ERROR_MESSAGE()
END CATCH

--Send email if there are blocks
IF (@xml IS NOT NULL OR LEN(@xml) != 0)
BEGIN
    SET @subject
        = 'Blocks Report. Between ' + CAST(DATEADD(HOUR, - (@Interval), GETDATE()) AS NVARCHAR) + ' -> '
          + CAST(GETDATE() AS NVARCHAR);
    SET @body
        = '<html><body><H3>' + @subject + '. ' + @err
          + '</H3>
                    <table border = 1> 
                    <tr>
                    <th> DB </th><th> Max WaitTime(ms) </th> <th> Blocks Count </th> <th> Blocking Query </th> </tr>';
    SET @body = @body + @xml + '</table></body></html>';

    EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                 --@importance = 'high',
                                 @body_format = 'HTML',
                                 @recipients = @EmailTo,
                                 @subject = @subject,
                                 @body = @body;
END

GO
/****** Object:  StoredProcedure [dbo].[pr_HourlySlowReport]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_HourlySlowReport]
(
    @Interval INT, --Report from last ? hour
    @EmailTo NVARCHAR(200),
    @DBName NVARCHAR(50)
)
AS
SET NOCOUNT ON
DECLARE @subject NVARCHAR(200),
        @body NVARCHAR(MAX),
        @xml NVARCHAR(MAX),
        @isSessionOn NVARCHAR(200) = '';

DECLARE @error NVARCHAR(MAX) = ''
BEGIN TRY
    --Get report
    ;WITH cte
     AS (SELECT COUNT(ID) AS [EventsCount],
                CAST(AVG([Duration]) AS NUMERIC(32, 2)) AS [AVGDuration],
                CAST(AVG([CPUTime]) AS NUMERIC(32, 2)) AS [AVGCPUTime],
                AVG([PhysicalReads]) AS AVGPhysicalReads,
                AVG([LogicalReads]) AS AVGLogicalReads,
                AVG([Writes]) AS AVGWrites,
                CASE --filter SQL text for grouping
                    WHEN [STMT_Batch_Text] LIKE N'%prClearRetailerAndSendMail%' THEN
                        'prClearRetailerAndSendMail'
                    WHEN [STMT_Batch_Text] LIKE N'%pr_Product_Group%' THEN
                        'exec [dbo].[pr_Product_Group]'
                    WHEN [STMT_Batch_Text] LIKE N'%ImportProduct%' THEN
                        'ImportProduct'
                    --if UPDATE then get all SQL text before SET
                    WHEN [STMT_Batch_Text] LIKE N'%UPDATE%' THEN
                        SUBSTRING(   [STMT_Batch_Text],
                                     1,
                                     CASE
                                         WHEN CHARINDEX('SET', [STMT_Batch_Text]) = 0 THEN
                                             300
                                         ELSE
                                             CHARINDEX('SET', [STMT_Batch_Text]) - 1
                                     END
                                 )
                    --if INSERT then get all SQL text untill table name or ]([
                    WHEN [STMT_Batch_Text] LIKE N'%INSERT%' THEN
                        SUBSTRING(   [STMT_Batch_Text],
                                     1,
                                     CASE
                                         WHEN CHARINDEX(']([', [STMT_Batch_Text]) = 0 THEN
                                             300
                                         ELSE
                                             CHARINDEX(']([', [STMT_Batch_Text])
                                     END
                                 )
                    --if DELETE then get all SQL text before WHERE
                    WHEN [STMT_Batch_Text] LIKE N'%DELETE%' THEN
                        SUBSTRING(   [STMT_Batch_Text],
                                     1,
                                     CASE
                                         WHEN CHARINDEX('WHERE', [STMT_Batch_Text]) = 0 THEN
                                             300
                                         ELSE
                                             CHARINDEX('WHERE', [STMT_Batch_Text]) - 1
                                     END
                                 )
                    --get all exec stored procedure untill @ where param are set
                    WHEN CHARINDEX('exec [dbo]', [STMT_Batch_Text]) = 1 THEN
                        REPLACE(SUBSTRING([STMT_Batch_Text], 1, CHARINDEX('@', [STMT_Batch_Text])), '@', '')
                    WHEN [STMT_Batch_Text] = '' THEN
                        CAST([SQLText] AS NVARCHAR(300))
                    ELSE
                        CAST([STMT_Batch_Text] AS NVARCHAR(300))
                END AS [ShortedSQLText]
         FROM SlowQueryLog WITH (NOLOCK)
         WHERE [Time]
               BETWEEN DATEADD(HOUR, - (@Interval), GETDATE()) AND GETDATE()
               --Eliminate system queries
               AND CHARINDEX('.sql', [STMT_Batch_Text]) = 0
               AND CHARINDEX('@profile_name', [STMT_Batch_Text]) = 0
               AND CHARINDEX('@fromDate', [STMT_Batch_Text]) = 0
         GROUP BY CASE --filter SQL text for grouping
                      WHEN [STMT_Batch_Text] LIKE N'%prClearRetailerAndSendMail%' THEN
                          'prClearRetailerAndSendMail'
                      WHEN [STMT_Batch_Text] LIKE N'%pr_Product_Group%' THEN
                          'exec [dbo].[pr_Product_Group]'
                      WHEN [STMT_Batch_Text] LIKE N'%ImportProduct%' THEN
                          'ImportProduct'
                      --if UPDATE then get all SQL text before SET
                      WHEN [STMT_Batch_Text] LIKE N'%UPDATE%' THEN
                          SUBSTRING(   [STMT_Batch_Text],
                                       1,
                                       CASE
                                           WHEN CHARINDEX('SET', [STMT_Batch_Text]) = 0 THEN
                                               300
                                           ELSE
                                               CHARINDEX('SET', [STMT_Batch_Text]) - 1
                                       END
                                   )
                      --if INSERT then get all SQL text untill table name or ]([
                      WHEN [STMT_Batch_Text] LIKE N'%INSERT%' THEN
                          SUBSTRING(   [STMT_Batch_Text],
                                       1,
                                       CASE
                                           WHEN CHARINDEX(']([', [STMT_Batch_Text]) = 0 THEN
                                               300
                                           ELSE
                                               CHARINDEX(']([', [STMT_Batch_Text])
                                       END
                                   )
                      --if DELETE then get all SQL text before WHERE
                      WHEN [STMT_Batch_Text] LIKE N'%DELETE%' THEN
                          SUBSTRING(   [STMT_Batch_Text],
                                       1,
                                       CASE
                                           WHEN CHARINDEX('WHERE', [STMT_Batch_Text]) = 0 THEN
                                               300
                                           ELSE
                                               CHARINDEX('WHERE', [STMT_Batch_Text]) - 1
                                       END
                                   )
                      --get all exec stored procedure untill @ where param are set
                      WHEN CHARINDEX('exec [dbo]', [STMT_Batch_Text]) = 1 THEN
                          REPLACE(SUBSTRING([STMT_Batch_Text], 1, CHARINDEX('@', [STMT_Batch_Text])), '@', '')
                      WHEN [STMT_Batch_Text] = '' THEN
                          CAST([SQLText] AS NVARCHAR(300))
                      ELSE
                          CAST([STMT_Batch_Text] AS NVARCHAR(300))
                  END)

    --Format HTML table email body
    SELECT @xml = CAST(
         (
             SELECT [EventsCount] AS 'td',
                    '',
                    [AVGDuration] AS 'td',
                    '',
                    [AVGCPUTime] AS 'td',
                    '',
                    [AVGPhysicalReads] AS 'td',
                    '',
                    [AVGLogicalReads] AS 'td',
                    '',
                    [AVGWrites] AS 'td',
                    '',
                    [ShortedSQLText] AS 'td'
             FROM cte
             ORDER BY [EventsCount] DESC,
                      [AVGDuration] DESC
             FOR XML PATH('tr'), ELEMENTS
         ) AS NVARCHAR(MAX))
END TRY
BEGIN CATCH
    SELECT @error = ERROR_MESSAGE()
END CATCH

IF NOT EXISTS
(
    SELECT 1
    FROM sys.dm_xe_sessions
    WHERE name = 'KV_SlowQueryLog'
) --Check if extended events is running
    SET @isSessionOn = '    Warning!!! Extended Events session is not running.'

--IF (@xml IS NOT NULL OR LEN(@xml) != 0) --Send email if there are blocks
--    BEGIN
--        SET @subject = @DBName + '-Slow Query Report. Between ' + CAST(DATEADD(HOUR, -(@Interval), GETDATE()) AS NVARCHAR) + ' -> ' + CAST(GETDATE() AS NVARCHAR);
--        SET @body = '<html><body><H3>' + @subject + @isSessionOn + @error + '</H3>
--                    <table border = 1> 
--                    <tr>
--                    <th> EventsCount </th> <th> AVGDuration(s) </th> <th> AVGCPUTime(s) </th> 
--                    <th> AVGPhysicalReads </th> <th> AVGLogicalReads </th> <th> AVGWrites </th> <th> ShortedSQLText </th> </tr>';    
--        SET @body = @body + @xml + '</table></body></html>';

--        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
--            @body_format ='HTML',
--            @recipients = @EmailTo,
--            @subject = @subject,
--            @body = @body;
--    END
--ELSE --Send email no slow found
--    BEGIN
--        SET @subject = @DBName + '-Slow Query Report. Between ' + CAST(DATEADD(HOUR, -(@Interval), GETDATE()) AS NVARCHAR) + ' -> ' + CAST(GETDATE() AS NVARCHAR);
--        SET @body = 'No slow queries found. ' + @isSessionOn + @error;    

--        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
--            @body_format ='TEXT',
--            @recipients = @EmailTo,
--            @subject = @subject,
--            @body = @body;
--    END
GO
/****** Object:  StoredProcedure [dbo].[pr_IndexFrag_AutoMaintenance]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_IndexFrag_AutoMaintenance]
(
    @RebuildThreshold TINYINT, --index rebuild threshold. Must be >= 30%. (Recommendation: >30% rebuild. Between 5-30% reorganize)
    @DoReorganize BIT,         --1 reorganize, 0 dont reorganize indexes with fragmentation between 5-30%.
    @DoFullTxtReorganize BIT,  --1 reorganize, 0 dont reorganize
    @DbName NVARCHAR(100),     --DbName
    @TimeLimitFrom TIME,
    @TimeLimitTo TIME,
    @DBNameShort NVARCHAR(50),
    @EmailTo NVARCHAR(200)
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @TableName NVARCHAR(255),
            @IndexName NVARCHAR(255),
            @SQL NVARCHAR(MAX),
            @Fragm NVARCHAR(100),
            @ErrorMsgReb NVARCHAR(MAX) = 'None',
            @ErrorMsgReorg NVARCHAR(MAX) = 'None',
            @ErrorMsgFullTxtReorg NVARCHAR(MAX) = 'None',
            @Subject NVARCHAR(500),
            @Body NVARCHAR(MAX) = NULL
    DECLARE @countReb INT = 0,
            @countReorg INT = 0,
            @countFullTxtReorg INT = 0
    DECLARE @totalReb INT = 0,
            @totalReorg INT = 0,
            @totalFullTxtReorg INT = 0
    DECLARE @CatalogName NVARCHAR(255),
            @FullTxtFragm NVARCHAR(100)

    --Count total index to rebuild, reorganize
    IF (@RebuildThreshold >= 30)
    BEGIN
        SELECT @totalReb = COUNT(*)
        FROM sys.dm_db_index_physical_stats(DB_ID(@DbName), NULL, NULL, NULL, NULL) AS a
            JOIN sys.indexes AS b
                ON a.object_id = b.object_id
                   AND a.index_id = b.index_id
        WHERE OBJECT_NAME(a.object_id) NOT IN ( 'sysdiagrams', '__RefactorLog' )
              AND a.avg_fragmentation_in_percent > @RebuildThreshold
    END

    IF (@DoReorganize = 1)
    BEGIN
        SELECT @totalReorg = COUNT(*)
        FROM sys.dm_db_index_physical_stats(DB_ID(@DbName), NULL, NULL, NULL, NULL) AS a
            JOIN sys.indexes AS b
                ON a.object_id = b.object_id
                   AND a.index_id = b.index_id
        WHERE OBJECT_NAME(a.object_id) NOT IN ( 'sysdiagrams', '__RefactorLog' )
              AND
              (
                  a.avg_fragmentation_in_percent > 5
                  AND a.avg_fragmentation_in_percent < 30
              )
    END

    IF (@DoFullTxtReorganize = 1)
    BEGIN
        SELECT @totalFullTxtReorg = COUNT(c.name)
        FROM sys.fulltext_catalogs c
            JOIN sys.fulltext_indexes i
                ON i.fulltext_catalog_id = c.fulltext_catalog_id
            JOIN
            (
                SELECT table_id,
                       COUNT(*) AS num_fragments,
                       CONVERT(DECIMAL(9, 2), SUM(data_size / (1024. * 1024.))) AS fulltext_mb,
                       CONVERT(DECIMAL(9, 2), MAX(data_size / (1024. * 1024.))) AS largest_fragment_mb
                FROM sys.fulltext_index_fragments
                GROUP BY table_id
            ) f
                ON f.table_id = i.object_id
        WHERE 100 * (f.fulltext_mb - f.largest_fragment_mb) / NULLIF(f.fulltext_mb, 0) >= 5
    END

    --Reorganize Full Text Catalog
    --------------------------------------------
    IF (@DoFullTxtReorganize = 1)
    BEGIN
        BEGIN TRY
            DECLARE cursFullTxtReorg CURSOR FOR --Get list of full text catalog needs to reorganize
            SELECT c.name AS CatalogName,
                   100 * (f.fulltext_mb - f.largest_fragment_mb) / NULLIF(f.fulltext_mb, 0) AS FragPercent
            FROM sys.fulltext_catalogs c
                JOIN sys.fulltext_indexes i
                    ON i.fulltext_catalog_id = c.fulltext_catalog_id
                JOIN
                (
                    SELECT table_id,
                           COUNT(*) AS num_fragments,
                           CONVERT(DECIMAL(9, 2), SUM(data_size / (1024. * 1024.))) AS fulltext_mb,
                           CONVERT(DECIMAL(9, 2), MAX(data_size / (1024. * 1024.))) AS largest_fragment_mb
                    FROM sys.fulltext_index_fragments
                    GROUP BY table_id
                ) f
                    ON f.table_id = i.object_id
            WHERE 100 * (f.fulltext_mb - f.largest_fragment_mb) / NULLIF(f.fulltext_mb, 0) >= 5

            OPEN cursFullTxtReorg
            FETCH NEXT FROM cursFullTxtReorg
            INTO @CatalogName,
                 @FullTxtFragm
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @SQL = ''
                SET @SQL = N'ALTER FULLTEXT CATALOG [' + @CatalogName + '] REORGANIZE'

                IF (CAST(GETDATE() AS TIME) BETWEEN @TimeLimitFrom AND @TimeLimitTo)
                BEGIN
                    PRINT @FullTxtFragm + '% - ' + @SQL
                    EXEC (@SQL)

                    SET @Body = CONCAT(@Body, CHAR(13), @FullTxtFragm, '% --- ', @CatalogName, ' REORGANIZE')
                    SET @countFullTxtReorg = @countFullTxtReorg + 1
                END
                ELSE
                BEGIN
                    PRINT 'CANCELED (TIME PAST ' + CAST(@TimeLimitTo AS NVARCHAR(5)) + ') - ' + @FullTxtFragm + '% - '
                          + @SQL
                    SET @Body
                        = CONCAT(
                                    @Body,
                                    CHAR(13),
                                    'CANCELED (TIME PAST ',
                                    CAST(@TimeLimitTo AS NVARCHAR(5)),
                                    ') - ',
                                    @FullTxtFragm,
                                    '% --- ',
                                    @CatalogName,
                                    ' REORGANIZE'
                                )
                END

                FETCH NEXT FROM cursFullTxtReorg
                INTO @CatalogName,
                     @FullTxtFragm
            END
        END TRY
        BEGIN CATCH
            SELECT @ErrorMsgFullTxtReorg = ERROR_MESSAGE()
        END CATCH

        --Close/deallocate cursor
        BEGIN TRY
            CLOSE cursFullTxtReorg
            DEALLOCATE cursFullTxtReorg
        END TRY
        BEGIN CATCH
        --PRINT 'Done'
        END CATCH
    END

    --Rebuild
    --------------------------------------------
    IF (@RebuildThreshold >= 30)
    BEGIN
        BEGIN TRY
            DECLARE cursRebuild CURSOR FOR --Get list of indexes that needs to rebuild (a.avg_fragmentation_in_percent  > @RebuildThreshold)
            SELECT OBJECT_NAME(a.object_id) AS TableName,
                   b.name AS IndexName,
                   --a.index_id, 
                   a.avg_fragmentation_in_percent AS Fragm
            FROM sys.dm_db_index_physical_stats(DB_ID(@DbName), NULL, NULL, NULL, NULL) AS a
                JOIN sys.indexes AS b
                    ON a.object_id = b.object_id
                       AND a.index_id = b.index_id
            WHERE OBJECT_NAME(a.object_id) NOT IN ( 'sysdiagrams', '__RefactorLog' )
                  AND a.avg_fragmentation_in_percent > @RebuildThreshold
            ORDER BY OBJECT_NAME(a.object_id)

            OPEN cursRebuild
            FETCH NEXT FROM cursRebuild
            INTO @TableName,
                 @IndexName,
                 @Fragm
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @SQL = ''
                SET @SQL = N'ALTER INDEX [' + @IndexName + '] ON [' + @TableName + '] REBUILD'

                IF (CAST(GETDATE() AS TIME) BETWEEN @TimeLimitFrom AND @TimeLimitTo)
                BEGIN
                    PRINT @Fragm + '% - ' + @SQL
                    EXEC (@SQL)

                    SET @Body = CONCAT(@Body, CHAR(13), @Fragm, '% --- ', @TableName, ' ', @IndexName, ' REBUILD')
                    SET @countReb = @countReb + 1
                END
                ELSE
                BEGIN
                    PRINT 'CANCELED (TIME PAST ' + CAST(@TimeLimitTo AS NVARCHAR(5)) + ') - ' + @Fragm + '% - ' + @SQL
                    SET @Body
                        = CONCAT(
                                    @Body,
                                    CHAR(13),
                                    'CANCELED (TIME PAST ',
                                    CAST(@TimeLimitTo AS NVARCHAR(5)),
                                    ') - ',
                                    @Fragm,
                                    '% --- ',
                                    @TableName,
                                    ' ',
                                    @IndexName,
                                    ' REBUILD'
                                )
                END

                FETCH NEXT FROM cursRebuild
                INTO @TableName,
                     @IndexName,
                     @Fragm
            END
        END TRY
        BEGIN CATCH
            SELECT @ErrorMsgReb = ERROR_MESSAGE()
        END CATCH

        --Close/deallocate cursor
        BEGIN TRY
            CLOSE cursRebuild
            DEALLOCATE cursRebuild
        END TRY
        BEGIN CATCH
        --PRINT 'Done'
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Fragmentation threshold must be higher than 30% for rebuild'
    END

    --Reorganize
    --------------------------------------------
    IF (@DoReorganize = 1)
    BEGIN
        BEGIN TRY
            DECLARE cursReorg CURSOR FOR --Get list of indexes that needs to reorganize (a.avg_fragmentation_in_percent betwwen 5%-30%)
            SELECT OBJECT_NAME(a.object_id) AS TableName,
                   b.name AS IndexName,
                   a.avg_fragmentation_in_percent AS Fragm
            FROM sys.dm_db_index_physical_stats(DB_ID(@DbName), NULL, NULL, NULL, NULL) AS a
                JOIN sys.indexes AS b
                    ON a.object_id = b.object_id
                       AND a.index_id = b.index_id
            WHERE OBJECT_NAME(a.object_id) NOT IN ( 'sysdiagrams', '__RefactorLog' )
                  AND
                  (
                      a.avg_fragmentation_in_percent > 5
                      AND a.avg_fragmentation_in_percent < 30
                  )

            OPEN cursReorg
            FETCH NEXT FROM cursReorg
            INTO @TableName,
                 @IndexName,
                 @Fragm
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @SQL = ''
                SET @SQL = N'ALTER INDEX [' + @IndexName + '] ON [' + @TableName + '] REORGANIZE'

                IF (CAST(GETDATE() AS TIME) BETWEEN @TimeLimitFrom AND @TimeLimitTo)
                BEGIN
                    PRINT @Fragm + '% - ' + @SQL
                    EXEC (@SQL)

                    SET @Body = CONCAT(@Body, CHAR(13), @Fragm, '% --- ', @TableName, ' ', @IndexName, ' REORGANIZE')
                    SET @countReorg = @countReorg + 1
                END
                ELSE
                BEGIN
                    PRINT 'CANCELED (TIME PAST ' + CAST(@TimeLimitTo AS NVARCHAR(5)) + ') - ' + @Fragm + '% - ' + @SQL
                    SET @Body
                        = CONCAT(
                                    @Body,
                                    CHAR(13),
                                    'CANCELED (TIME PAST ',
                                    CAST(@TimeLimitTo AS NVARCHAR(5)),
                                    ') - ',
                                    @Fragm,
                                    '% --- ',
                                    @TableName,
                                    ' ',
                                    @IndexName,
                                    ' REORGANIZE'
                                )
                END

                FETCH NEXT FROM cursReorg
                INTO @TableName,
                     @IndexName,
                     @Fragm
            END
        END TRY
        BEGIN CATCH
            SELECT @ErrorMsgReorg = ERROR_MESSAGE()
        END CATCH

        --Close/deallocate cursor
        BEGIN TRY
            CLOSE cursReorg
            DEALLOCATE cursReorg
        END TRY
        BEGIN CATCH
        --PRINT 'Done'
        END CATCH
    END

    --Send mail with result or error
    SET @Subject = @DBNameShort + '-Index Auto Maintenance-' + CAST(GETDATE() AS NVARCHAR)
    DECLARE @tmpBody NVARCHAR(MAX)
        = '  => ' + CAST(@countReb AS NVARCHAR) + '/' + CAST(@totalReb AS NVARCHAR) + ' index rebuilt. Errors: '
          + @ErrorMsgReb + CHAR(13) + '  => ' + CAST(@countReorg AS NVARCHAR) + '/' + CAST(@totalReorg AS NVARCHAR)
          + ' index reorganized. Errors: ' + @ErrorMsgReorg + CHAR(13) + '  => ' + CAST(@countFullTxtReorg AS NVARCHAR)
          + '/' + CAST(@totalFullTxtReorg AS NVARCHAR) + ' catalog reorganized. Errors: ' + @ErrorMsgFullTxtReorg

    SET @Body = CONCAT(@tmpBody, CHAR(13), @Body)

    EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                 @body_format = 'TEXT',
                                 @recipients = @EmailTo,
                                 @subject = @Subject,
                                 @body = @Body;
END;
GO
/****** Object:  StoredProcedure [dbo].[pr_ProcessBlockProcessReports]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_ProcessBlockProcessReports]
WITH EXECUTE AS OWNER
AS
SET NOCOUNT ON;
DECLARE @message_body XML,
        @message_type INT,
        @subject VARCHAR(MAX),
        @body VARCHAR(MAX),
        @dialog UNIQUEIDENTIFIER,
        @dbName VARCHAR(50),
        --@blockedQuery NVARCHAR(MAX),
        --@blockingQuery NVARCHAR(MAX),
        @lastBlockedXactId BIGINT,
        @lastBlockingXactId BIGINT,
        @isBlkSource BIT,
        @blockedSQLText NVARCHAR(MAX),
        @blockingSQLText NVARCHAR(MAX),
        @lastId BIGINT,
        @emailQueue INT;

WHILE (1 = 1)
BEGIN
    BEGIN
        BEGIN TRANSACTION;
        -- Receive the next available message from the queue
        WAITFOR
        (
            RECEIVE TOP (1) @message_type = message_type_id,
                            @message_body = CAST(message_body AS XML),
                            @dialog = conversation_handle
            FROM dbo.BlockedProcessReportQueue
        ),
        TIMEOUT 1000;

        -- If we didn't get anything, bail out
        IF (@@ROWCOUNT = 0)
        BEGIN
            ROLLBACK TRANSACTION;
            BREAK;
        END;

        ------------------------------------------------
        -- Log block events
        INSERT INTO [dbo].[BlockedProcessReports]
        (
            database_name,
            post_time,
            wait_time,
            blocked_xactid,
            blocking_xactid,
            is_blocking_source,
            blocked_inputbuf,
            blocking_inputbuf,
            blocked_process_report
        )
        SELECT DB_NAME(CAST(@message_body AS XML).value('(/EVENT_INSTANCE/DatabaseID)[1]', 'int')) + '_Test2222' AS database_name,
               CAST(@message_body AS XML).value('(/EVENT_INSTANCE/PostTime)[1]', 'datetime') AS post_time,
               CAST(@message_body AS XML).value(
                                                   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocked-process[1]/process[1]/@waittime',
                                                   'int'
                                               ) AS wait_time,
               CAST(@message_body AS XML).value(
                                                   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocked-process[1]/process[1]/@xactid',
                                                   'bigint'
                                               ) AS blocked_xactid,
               CAST(@message_body AS XML).value(
                                                   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocking-process[1]/process[1]/@xactid',
                                                   'bigint'
                                               ) AS blocking_xactid,
               CASE
                   WHEN (CAST(@message_body AS XML).value(
                                                             '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocking-process[1]/process[1]/@waitresource',
                                                             'nvarchar(max)'
                                                         ) IS NULL
                        ) THEN
                       1
                   ELSE
                       0
               END AS is_blocking_source,
               CAST(@message_body AS XML).value(
                                                   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocked-process[1]/process[1]/inputbuf[1]',
                                                   'nvarchar(max)'
                                               ) AS blocked_inputbuf,
               CAST(@message_body AS XML).value(
                                                   '(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]/blocking-process[1]/process[1]/inputbuf[1]',
                                                   'nvarchar(max)'
                                               ) AS blocking_inputbuf,
               CAST(@message_body AS XML).query('(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]') AS blocked_process_report;

        SET @dbName = NULL
        SET @lastBlockedXactId = NULL
        SET @lastBlockingXactId = NULL
        SET @isBlkSource = NULL
        SET @lastId = IDENT_CURRENT('BlockedProcessReports') --Get the lastest report ID for further processing

        ------------------------------------------------
        -- Get XactID for lastest report. Just inserted above.
        SELECT @lastBlockedXactId = blocked_xactid,
               @lastBlockingXactId = blocking_xactid,
               @isBlkSource = is_blocking_source,
               @dbName = database_name
        FROM BlockedProcessReports
        WHERE id = @lastId

        ------------------------------------------------
        -- Process report, extract full SQL text and send alert email if blocks excess 59s - Timeout on web is 60s
        -- Send only the first block report to excess 59s
        ------------------------------------------------
        IF (
           (
               SELECT COUNT(id)
               FROM BlockedProcessReports
               WHERE blocked_xactid = @lastBlockedXactId
                     AND blocking_xactid = @lastBlockingXactId
                     AND wait_time >= 59000
           ) = 1 -- =1 means is the first report
           AND @isBlkSource = 1
           AND (DATEPART(hh, GETDATE()) NOT
           BETWEEN 2 AND 4
               )
           ) --Dont send alert between 2AM-5AM
        BEGIN
            -- Get SQLHandle from XML Report
            DECLARE @BlockedSQlHandle VARBINARY(MAX)
                = ISNULL(
                            CONVERT(XML, @message_body).query('/EVENT_INSTANCE[1]/TextData[1]/*').value(
                                                                                                           'xs:hexBinary(substring((/blocked-process-report[1]/blocked-process[1]/process[1]/executionStack[1]/frame[1]/@sqlhandle)[1],3))',
                                                                                                           'varbinary(max)'
                                                                                                       ),
                            0x
                        )
            DECLARE @BlockingSQlHandle VARBINARY(MAX)
                = ISNULL(
                            CONVERT(XML, @message_body).query('/EVENT_INSTANCE[1]/TextData[1]/*').value(
                                                                                                           'xs:hexBinary(substring((/blocked-process-report[1]/blocking-process[1]/process[1]/executionStack[1]/frame[1]/@sqlhandle)[1],3))',
                                                                                                           'varbinary(max)'
                                                                                                       ),
                            0x
                        )

            -- Get SQL Text using SQL Handle
            SET @blockedSQLText = NULL
            SET @blockingSQLText = NULL

            IF (@BlockedSQlHandle != 0x)
                SELECT @blockedSQLText = [text]
                FROM sys.dm_exec_sql_text(@BlockedSQlHandle)
            IF (@BlockingSQlHandle != 0x)
                SELECT @blockingSQLText = [text]
                FROM sys.dm_exec_sql_text(@BlockingSQlHandle)

            -- Insert full query into log table
            INSERT INTO BlockedProcessReportsDetail
            VALUES
            (@lastId, @blockedSQLText, @blockingSQLText)

            IF ((SELECT COUNT(*) FROM msdb.dbo.sysmail_unsentitems) < 30)
            BEGIN -- Send alert email and if DB email queue is not busy (<50 email in queue)
                SET @subject = 'DB.1 - Block Alert >59s - ' + @dbName;
                SELECT @body
                    = '-----XML Report:' + CHAR(13) + CHAR(13)
                      + CONVERT(
                                   NVARCHAR(MAX),
                                   CAST(@message_body AS XML).query('(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]')
                               ) + CHAR(13) + CHAR(13) + '-----Blocked Query:' + CHAR(13) + CHAR(13)
                      + ISNULL(
                                  @blockedSQLText,
                                  'Could not get SQL text using SQL Handle. Please get it manually using stmtstart and stmtend.'
                              ) + CHAR(13) + CHAR(13) + '-----Blocking Query:' + CHAR(13) + CHAR(13)
                      + ISNULL(
                                  @blockingSQLText,
                                  'Could not get SQL text using SQL Handle. Please get it manually using stmtstart and stmtend.'
                              );

                EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                             @recipients = 'hung.dao@citigo.net; tung.ndt@citigo.net; dong.pham@citigo.net; huy.tran@citigo.net; duc.vu@citigo.com.vn; hung.ln@citigo.com.vn; sy.lk@citigo.com.vn; phuc.cv@citigo.com.vn',
                                             --@recipients = 'duc.vu@citigo.com.vn',
                                             @subject = @subject,
                                             @body = @body;
            END
        END;

        ------------------------------------------------
        -- Send alert if block > 2m
        ------------------------------------------------
        IF (
           (
               SELECT COUNT(id)
               FROM BlockedProcessReports
               WHERE blocked_xactid = @lastBlockedXactId
                     AND blocking_xactid = @lastBlockingXactId
                     AND wait_time >= 120000
           ) = 1 -- =1 means is the first report
           AND @isBlkSource = 1
           AND (DATEPART(hh, GETDATE()) NOT
           BETWEEN 2 AND 4
               )
           ) --Dont send alert between 2AM-5AM
        BEGIN
            -- Get SQLHandle from XML Report
            DECLARE @BlockedSQlHandle2 VARBINARY(MAX)
                = ISNULL(
                            CONVERT(XML, @message_body).query('/EVENT_INSTANCE[1]/TextData[1]/*').value(
                                                                                                           'xs:hexBinary(substring((/blocked-process-report[1]/blocked-process[1]/process[1]/executionStack[1]/frame[1]/@sqlhandle)[1],3))',
                                                                                                           'varbinary(max)'
                                                                                                       ),
                            0x
                        )
            DECLARE @BlockingSQlHandle2 VARBINARY(MAX)
                = ISNULL(
                            CONVERT(XML, @message_body).query('/EVENT_INSTANCE[1]/TextData[1]/*').value(
                                                                                                           'xs:hexBinary(substring((/blocked-process-report[1]/blocking-process[1]/process[1]/executionStack[1]/frame[1]/@sqlhandle)[1],3))',
                                                                                                           'varbinary(max)'
                                                                                                       ),
                            0x
                        )

            -- Get SQL Text using SQL Handle
            SET @blockedSQLText = NULL
            SET @blockingSQLText = NULL

            IF (@BlockedSQlHandle2 != 0x)
                SELECT @blockedSQLText = [text]
                FROM sys.dm_exec_sql_text(@BlockedSQlHandle2)
            IF (@BlockingSQlHandle2 != 0x)
                SELECT @blockingSQLText = [text]
                FROM sys.dm_exec_sql_text(@BlockingSQlHandle2)

            -- Insert full query into log table
            INSERT INTO BlockedProcessReportsDetail
            VALUES
            (@lastId, @blockedSQLText, @blockingSQLText)

            IF ((SELECT COUNT(*) FROM msdb.dbo.sysmail_unsentitems) < 30)
            BEGIN -- Send alert email and if DB email queue is not busy (<50 email in queue)
                SET @subject = 'DB.1 - DB BLOCK ALERT !!! Block >2min - ' + @dbName;
                SELECT @body
                    = '-----XML Report:' + CHAR(13) + CHAR(13)
                      + CONVERT(
                                   NVARCHAR(MAX),
                                   CAST(@message_body AS XML).query('(/EVENT_INSTANCE/TextData/blocked-process-report/.)[1]')
                               ) + CHAR(13) + CHAR(13) + '-----Blocked Query:' + CHAR(13) + CHAR(13)
                      + ISNULL(
                                  @blockedSQLText,
                                  'Could not get SQL text using SQL Handle. Please get it manually using stmtstart and stmtend.'
                              ) + CHAR(13) + CHAR(13) + '-----Blocking Query:' + CHAR(13) + CHAR(13)
                      + ISNULL(
                                  @blockingSQLText,
                                  'Could not get SQL text using SQL Handle. Please get it manually using stmtstart and stmtend.'
                              );

                EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                             @recipients = 'hung.dao@citigo.net; tung.ndt@citigo.net; dong.pham@citigo.net; huy.tran@citigo.net; duc.vu@citigo.com.vn; hung.ln@citigo.com.vn; sy.lk@citigo.com.vn; phuc.cv@citigo.com.vn',
                                             --@recipients = 'duc.vu@citigo.com.vn',
                                             @subject = @subject,
                                             @body = @body,
                                             @importance = 'high';
            END;
        END;
    END;

    COMMIT TRANSACTION;
END;
GO
/****** Object:  StoredProcedure [dbo].[pr_Stats_AutoMaintenance]    Script Date: 12/4/2020 11:28:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_Stats_AutoMaintenance]
(
    @OlderThan TINYINT, --Update stats older than .. days
    @TimeLimitFrom TIME,
    @TimeLimitTo TIME,
    @DBNameShort NVARCHAR(50),
    @EmailTo NVARCHAR(200)
)
AS
BEGIN
    DECLARE @TableName NVARCHAR(255),
            @IndexName NVARCHAR(255),
            @SQL NVARCHAR(MAX),
            @ErrorMsg NVARCHAR(MAX) = NULL,
            @Subject NVARCHAR(500),
            @Body NVARCHAR(MAX) = NULL
    DECLARE @count INT = 0,
            @total INT

    SELECT @total = COUNT(*)
    FROM sys.stats
    WHERE STATS_DATE(OBJECT_ID, stats_id) IS NOT NULL
          AND OBJECTPROPERTY(OBJECT_ID, 'IsUserTable') = 1
          AND OBJECT_NAME(OBJECT_ID) NOT IN ( 'sysdiagrams', '__RefactorLog' )
          AND DATEDIFF(DAY, ISNULL(STATS_DATE(OBJECT_ID, stats_id), 1), GETDATE()) > @OlderThan --older than ... days

    BEGIN TRY
        DECLARE curs CURSOR FOR
        SELECT OBJECT_NAME(OBJECT_ID) AS TableName,
               [Name] AS IndexName
        --,STATS_DATE(object_id, stats_id)
        FROM sys.stats
        WHERE STATS_DATE(OBJECT_ID, stats_id) IS NOT NULL
              AND OBJECTPROPERTY(OBJECT_ID, 'IsUserTable') = 1
              AND OBJECT_NAME(OBJECT_ID) NOT IN ( 'sysdiagrams', '__RefactorLog' )
              AND DATEDIFF(DAY, ISNULL(STATS_DATE(OBJECT_ID, stats_id), 1), GETDATE()) > @OlderThan --older than ... days
        ORDER BY OBJECT_NAME(OBJECT_ID)

        OPEN curs
        FETCH NEXT FROM curs
        INTO @TableName,
             @IndexName
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SQL = ''
            SET @SQL = N'UPDATE STATISTICS [' + @TableName + '] [' + @IndexName + '] WITH FULLSCAN'

            IF (CAST(GETDATE() AS TIME) BETWEEN @TimeLimitFrom AND @TimeLimitTo) --Update stats only if time between 3 am - 4 am.
            BEGIN
                PRINT @SQL
                EXEC sp_executesql @SQL

                SET @Body = CONCAT(@Body, CHAR(13), @SQL)
                SET @count = @count + 1
            END
            ELSE
            BEGIN
                PRINT 'CANCELED (TIME PAST ' + CAST(@TimeLimitTo AS NVARCHAR(5)) + ') - ' + @SQL
                SET @Body
                    = CONCAT(@Body, CHAR(13), 'CANCELED (TIME PAST ', CAST(@TimeLimitTo AS NVARCHAR(5)), ') - ', @SQL)
            END

            FETCH NEXT FROM curs
            INTO @TableName,
                 @IndexName
        END
    END TRY
    BEGIN CATCH
        SELECT @ErrorMsg = ERROR_MESSAGE()
    END CATCH


    --Close/deallocate cursor
    BEGIN TRY
        CLOSE curs
        DEALLOCATE curs
    END TRY
    BEGIN CATCH
    --PRINT 'Done'
    END CATCH

    --Send mail with result or error
    IF @ErrorMsg IS NULL
        SET @ErrorMsg = 'None'
    SET @Subject = @DBNameShort + '-Statistics Auto Maintenance-' + CAST(GETDATE() AS NVARCHAR)
    DECLARE @tmpBody NVARCHAR(100)
        = '  => ' + CAST(@count AS NVARCHAR) + '/' + CAST(@total AS NVARCHAR) + ' statistics updated. Errors: '
          + @ErrorMsg
    SET @Body = CONCAT(@tmpBody, CHAR(13), @Body)

    EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                 @body_format = 'TEXT',
                                 @recipients = @EmailTo,
                                 @subject = @Subject,
                                 @body = @Body;
END;
GO
USE [master]
GO
ALTER DATABASE [EventMonitoring] SET READ_WRITE
GO
