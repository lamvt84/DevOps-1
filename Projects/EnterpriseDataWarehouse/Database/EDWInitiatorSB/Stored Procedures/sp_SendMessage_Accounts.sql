CREATE PROCEDURE [dbo].[sp_SendMessage_Accounts]
	@ServiceName NVARCHAR(512),
	@MessageTypeName NVARCHAR(256),
	@MessageBody XML
AS
BEGIN
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
	SELECT @InitDlgHandle = [ConversationHandle]
		FROM [dbo].[BrokerConversation]
		WHERE [ServiceName] = @ServiceName;

	IF @InitDlgHandle IS NULL
		BEGIN
			BEGIN DIALOG @InitDlgHandle
			   FROM SERVICE [//WalletAccount/Service/Source]
			   TO SERVICE N'//WalletAccount/Service/Target'
			   ON CONTRACT [//WalletAccount/Contract/Accounts]
			   WITH
				   ENCRYPTION = ON;
			INSERT INTO [dbo].[BrokerConversation] VALUES (@InitDlgHandle, @ServiceName)
		END
	
	;SEND ON CONVERSATION @InitDlgHandle
		MESSAGE TYPE @MessageTypeName (@MessageBody);

	INSERT [dbo].[BrokerMessages] (ConversationHandler, MessageTypeName, MessageBody)
	SELECT @InitDlgHandle, @MessageTypeName, @MessageBody
END

