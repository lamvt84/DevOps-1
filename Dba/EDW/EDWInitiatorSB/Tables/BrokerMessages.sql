CREATE TABLE [dbo].[BrokerMessages]
(
	Id		INT IDENTITY(1,1) NOT NULL,
	[ConversationHandler]		UNIQUEIDENTIFIER,
	MessageTypeName	NVARCHAR(256),
	MessageBody	XML
)
