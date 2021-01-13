CREATE OR ALTER PROCEDURE [dbo].[sp_ProcessAsyncMessages_TransactionQueue]
AS
BEGIN
    DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
    DECLARE @RecvReqMsg XML;
    DECLARE @RecvReqMsgName sysname;
    DECLARE @ServiceName VARCHAR(512) = '//WalletTransaction/Service/Target'

    BEGIN TRY
        BEGIN TRANSACTION
        WAITFOR
        (
            RECEIVE TOP (1) @RecvReqDlgHandle = conversation_handle,
                            @RecvReqMsg = message_body,
                            @RecvReqMsgName = message_type_name
            FROM [dbo].[//WalletTransaction/Queue/Target]
        ),
        TIMEOUT 1000;
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.BrokerConversation
            WHERE ServiceName = @ServiceName
        )
            INSERT INTO [dbo].[BrokerConversation]
            VALUES
            (@RecvReqDlgHandle, @ServiceName)
        IF @RecvReqMsg IS NOT NULL
            INSERT [dbo].[BrokerMessages]
            (
                ConversationHandler,
                MessageTypeName,
                MessageBody
            )
            SELECT @RecvReqDlgHandle,
                   @RecvReqMsgName,
                   @RecvReqMsg
        COMMIT


        IF @RecvReqMsgName = '//WalletTransaction/Transactions/Request'
            EXEC [EDWCore].Dataflow.SyncTransaction @MessageBody = @RecvReqMsg
        IF @RecvReqMsgName = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
            END CONVERSATION @RecvReqDlgHandle
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1
            ROLLBACK TRANSACTION
        INSERT INTO dbo.ErrorLog
        (
            ErrorTime,
            UserName,
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage,
            MessageBody
        )
        VALUES
        (GETDATE(), USER_NAME(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(),
         ERROR_MESSAGE(), @RecvReqMsg)
    END CATCH
END
GO

ALTER QUEUE [dbo].[//WalletTransaction/Queue/Target]
    WITH ACTIVATION (
    STATUS = ON,
    MAX_QUEUE_READERS = 1,
    PROCEDURE_NAME = [dbo].[sp_ProcessAsyncMessages_TransactionQueue],
    EXECUTE AS OWNER);
GO