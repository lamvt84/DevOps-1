CREATE PROCEDURE [dbo].[sp_SendMessage_Batch]
	@ServiceName NVARCHAR(512) = '//ETL/Batch/Service/Source',
	@MessageTypeName NVARCHAR(256) = '//ETL/Batch/Message/Request',
	@Batch_Id INT,
	@Sync_Id INT
AS
BEGIN
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
	DECLARE @MessageBody XML = (SELECT @Batch_Id AS Batch_Id, @Sync_Id AS Sync_Id FOR XML RAW, ELEMENTS, ROOT('ETL'))
	SELECT @InitDlgHandle = [ConversationHandle]
		FROM [dbo].[BrokerConversation]
		WHERE [ServiceName] = @ServiceName;

	IF @InitDlgHandle IS NULL
		BEGIN
			BEGIN DIALOG @InitDlgHandle
			   FROM SERVICE [//ETL/Batch/Service/Source]
			   TO SERVICE N'//ETL/Batch/Service/Target'
			   ON CONTRACT [//ETL/Batch/Contract]
			   WITH
				   ENCRYPTION = ON;
			INSERT INTO [dbo].[BrokerConversation] VALUES (@InitDlgHandle, @ServiceName)
		END
	
	;SEND ON CONVERSATION @InitDlgHandle
		MESSAGE TYPE @MessageTypeName (@MessageBody);

	INSERT [dbo].[BrokerMessages] (ConversationHandler, MessageTypeName, MessageBody)
	SELECT @InitDlgHandle, @MessageTypeName, @MessageBody
END

