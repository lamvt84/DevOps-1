CREATE TABLE [dbo].[BlockedProcessReportsDetail] (
    [Id]                     BIGINT         IDENTITY (1, 1) NOT NULL,
    [BlockedProcessReportId] BIGINT         NOT NULL,
    [BlockedSQLText]         NVARCHAR (MAX) NULL,
    [BlockingSQLText]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_BlockedProcessReportsDetail] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BlockedProcessReportsDetail_BlockedProcessReports] FOREIGN KEY ([BlockedProcessReportId]) REFERENCES [dbo].[BlockedProcessReports] ([id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_BlockedProcessReportId]
    ON [dbo].[BlockedProcessReportsDetail]([BlockedProcessReportId] ASC)
    INCLUDE([BlockingSQLText]);

