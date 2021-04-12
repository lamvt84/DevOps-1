CREATE TABLE [dbo].[BlockedProcessReports] (
    [id]                     BIGINT         IDENTITY (1, 1) NOT NULL,
    [database_name]          [sysname]      NOT NULL,
    [post_time]              DATETIME       NULL,
    [insert_time]            DATETIME       CONSTRAINT [DF_BlockedProcessReports_InsertTime] DEFAULT (getdate()) NULL,
    [wait_time]              INT            NULL,
    [blocked_xactid]         BIGINT         NULL,
    [blocking_xactid]        BIGINT         NULL,
    [is_blocking_source]     BIT            NULL,
    [blocked_inputbuf]       NVARCHAR (MAX) NULL,
    [blocking_inputbuf]      NVARCHAR (MAX) NULL,
    [blocked_process_report] XML            NULL,
    CONSTRAINT [PK_BlockedProcessReports] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_BlockingXactId_BlockedXactId_WaitTime]
    ON [dbo].[BlockedProcessReports]([blocking_xactid] ASC, [blocked_xactid] ASC, [wait_time] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_PostTime_IsBlockingSource]
    ON [dbo].[BlockedProcessReports]([post_time] ASC, [is_blocking_source] ASC)
    INCLUDE([wait_time], [blocked_xactid], [blocking_xactid], [blocking_inputbuf]);

