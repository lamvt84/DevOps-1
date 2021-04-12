CREATE TABLE [dbo].[SlowQueryLog] (
    [ID]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [Time]            DATETIME       NULL,
    [Duration]        FLOAT (53)     NULL,
    [CPUTime]         FLOAT (53)     NULL,
    [PhysicalReads]   BIGINT         NULL,
    [LogicalReads]    BIGINT         NULL,
    [Writes]          BIGINT         NULL,
    [User]            NVARCHAR (100) NULL,
    [AppName]         NVARCHAR (100) NULL,
    [Database]        NVARCHAR (100) NULL,
    [STMT_Batch_Text] NVARCHAR (MAX) NULL,
    [SQLText]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_SlowQueryLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Time]
    ON [dbo].[SlowQueryLog]([Time] ASC)
    INCLUDE([Duration], [CPUTime], [PhysicalReads], [LogicalReads], [Writes], [STMT_Batch_Text], [SQLText]);

