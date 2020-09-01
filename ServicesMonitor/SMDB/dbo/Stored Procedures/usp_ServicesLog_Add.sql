CREATE PROCEDURE [dbo].[usp_ServicesLog_Add]
	@JournalGuid uniqueidentifier,
	@ServiceId int,
	@ServiceUrl varchar(200),
	@ServiceStatus varchar(100)
AS
	INSERT dbo.ServicesLog (JournalGuid, ServiceId, ServiceUrl, ServiceStatus)
	VALUES (@JournalGuid, @ServiceId, @ServiceUrl, @ServiceStatus)
