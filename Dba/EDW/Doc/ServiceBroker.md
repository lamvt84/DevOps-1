# Service Broker Installation

### Scope

Setup service broker for **Wallet.Transaction** DB

Steps:

* Initiator
* Target
* Send message to Queue
* Receive message from Queue
* Triggers

### Initiator

Database: EDWInitiatorSB

Create Message Types:

```sql
USE [EDWInitiatorSB]
GO
CREATE MESSAGE TYPE [//WalletTransaction/Transactions/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsInitialAccount/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsReceipt/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsSystem/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/Transactions/Reply] VALIDATION = WELL_FORMED_XML
GO
```

Create Contracts:

```sql
USE [EDWInitiatorSB]
GO
CREATE CONTRACT [//ETL/Batch/Contract]
      (
            [//ETL/Batch/Message/Transactions] SENT BY INITIATOR,
            [//ETL/Batch/Message/TransactionsReceipt] SENT BY INITIATOR,
            [//ETL/Batch/Message/TransactionsSystem] SENT BY INITIATOR,
            [//ETL/Batch/Message/Reply] SENT BY TARGET
      );
GO
```

Create Queue:

```sql
USE [EDWInitiatorSB]
GO
CREATE QUEUE [dbo].[//WalletTransaction/Queue/Source]
GO
```

Create Service:

```sql
USE [EDWInitiatorSB]
GO
CREATE SERVICE [//WalletTransaction/Service/Source]
	AUTHORIZATION [dbo]
	ON QUEUE [dbo].[//WalletTransaction/Queue/Source] (
		[//WalletTransaction/Contract/Transactions]
	)
GO
```

### Target

Database: EDWTargetSB

Create Message Types:

```sql
USE [EDWTargetSB]
GO
CREATE MESSAGE TYPE [//WalletTransaction/Transactions/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsInitialAccount/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsReceipt/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsSystem/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/Transactions/Reply] VALIDATION = WELL_FORMED_XML
GO
```

Create Contracts:

```sql
USE [EDWTargetSB]
GO
CREATE CONTRACT [//ETL/Batch/Contract]
      (
            [//ETL/Batch/Message/Transactions] SENT BY INITIATOR,
            [//ETL/Batch/Message/TransactionsReceipt] SENT BY INITIATOR,
            [//ETL/Batch/Message/TransactionsSystem] SENT BY INITIATOR,
            [//ETL/Batch/Message/Reply] SENT BY TARGET
      );
GO
```

Create Queue:

```sql
USE [EDWTargetSB]
GO
CREATE QUEUE [dbo].[//WalletTransaction/Queue/Target]
GO
```

Create Service:

```sql
USE [EDWTargetSB]
GO
CREATE SERVICE [//WalletTransaction/Service/Target]
	AUTHORIZATION [dbo]
	ON QUEUE [dbo].[//WalletTransaction/Queue/Target] (
		[//WalletTransaction/Contract/Transactions]
	)
GO
```

### Send message to queue

```sql
DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
DECLARE @MessageTypeName NVARCHAR(256) = N'//WalletTransaction/Transactions/Request'
DECLARE @MessageBody XML;
IF @InitDlgHandle IS NULL
	BEGIN
    	BEGIN DIALOG @InitDlgHandle
        	FROM SERVICE [//WalletTransaction/Service/Source]
            TO SERVICE N'//WalletTransaction/Service/Target'
            ON CONTRACT [//WalletTransaction/Contract/Transactions]
            WITH
            	ENCRYPTION = ON;			
	END

;SEND ON CONVERSATION @InitDlgHandle
	MESSAGE TYPE @MessageTypeName (@MessageBody);
;END CONVERSATION @InitDlgHandle
```

### Receive message from queue

```sql
DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
DECLARE @RecvReqMsg XML;
DECLARE @RecvReqMsgName sysname;
    
WAITFOR
    ( RECEIVE TOP(1)
        @RecvReqDlgHandle = conversation_handle,
        @RecvReqMsg = message_body,
        @RecvReqMsgName = message_type_name
        FROM [dbo].[//WalletTransaction/Queue/Target]
    ), TIMEOUT 1000;
IF @RecvReqMsgName = '//WalletTransaction/Transactions/Request'
	SELECT @RecvReqMsg;
IF @RecvReqMsgName = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
    END CONVERSATION @RecvReqDlgHandle;
```

### Triggers

Table: Transactions

```sql
USE [Wallet.Transaction]
GO
CREATE OR ALTER TRIGGER [dbo].[tr_Transactions_IUD]
ON [dbo].[Transactions]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @ChangeMsg XML;
    DECLARE @DeletedCnt INT = 0;
    DECLARE @InsertedCnt INT = 0;
    DECLARE @Action CHAR(1);
    DECLARE @Source_Name VARCHAR(20) = 'PAYMOBI';
    DECLARE @Batch_Id INT = 0;
    DECLARE @Sync_Id INT = 0;
    DECLARE @ServiceName NVARCHAR(512) = N'//WalletTransaction/Service/Source';

    BEGIN
        SELECT @InsertedCnt = COUNT(*)
        FROM inserted
        SELECT @DeletedCnt = COUNT(*)
        FROM deleted

        SELECT @Action = CASE
                             WHEN @InsertedCnt IS NOT NULL
                                  AND @DeletedCnt IS NOT NULL THEN
                                 'U'
                             WHEN @InsertedCnt IS NULL THEN
                                 'D'
                             ELSE
                                 'I'
                         END
        IF (@Action = 'U')
        BEGIN
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       i.*
                FROM inserted i
                    JOIN
                    (
                        SELECT DISTINCT
                               r.TransactionID
                        FROM
                        (
                            SELECT 'I' [Type],
                                   *
                            FROM inserted
                            UNION ALL
                            SELECT 'D' [Type],
                                   *
                            FROM deleted
                        ) r
                        GROUP BY TransactionID,
                                 RelationReceiptID,
                                 PayType,
                                 ServiceID,
                                 AccountID,
                                 Amount,
                                 AmountState,
                                 Description,
                                 OpenBalance,
                                 CloseBalance,
                                 CreatedUnixTime,
                                 InitUnixTime,
                                 ClientUnixIP
                        HAVING COUNT(*) = 1
                    ) t
                        ON i.TransactionID = t.TransactionID
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END
        IF (@Action = 'D')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM deleted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;
        IF (@Action = 'I')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM inserted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;

        IF @ChangeMsg IS NOT NULL
            EXEC [EDWInitiatorSB].dbo.sp_SendMessage_Transactions @ServiceName = @ServiceName,
                                                                  @MessageTypeName = N'//WalletTransaction/Transactions/Request',
                                                                  @MessageBody = @ChangeMsg
    END

END
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_Transactions_IUD]',
                        @order = N'Last',
                        @stmttype = N'DELETE'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_Transactions_IUD]',
                        @order = N'Last',
                        @stmttype = N'INSERT'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_Transactions_IUD]',
                        @order = N'Last',
                        @stmttype = N'UPDATE'
GO
```

Table: Transactions_Receipt

```sql
USE [Wallet.Transaction]
GO
CREATE OR ALTER TRIGGER [dbo].[tr_TransactionsReceipt_IUD]
ON [dbo].[Transactions_Receipt]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @ChangeMsg XML;
    DECLARE @DeletedCnt INT = 0;
    DECLARE @InsertedCnt INT = 0;
    DECLARE @Action CHAR(1);
    DECLARE @Source_Name VARCHAR(20) = 'PAYMOBI';
    DECLARE @Batch_Id INT = 0;
    DECLARE @Sync_Id INT = 0;
    DECLARE @ServiceName NVARCHAR(512) = N'//WalletTransaction/Service/Source';

    BEGIN
        SELECT @InsertedCnt = COUNT(*)
        FROM inserted
        SELECT @DeletedCnt = COUNT(*)
        FROM deleted

        SELECT @Action = CASE
                             WHEN @InsertedCnt IS NOT NULL
                                  AND @DeletedCnt IS NOT NULL THEN
                                 'U'
                             WHEN @InsertedCnt IS NULL THEN
                                 'D'
                             ELSE
                                 'I'
                         END
        IF (@Action = 'U')
        BEGIN
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       i.*
                FROM inserted i
                    JOIN
                    (
                        SELECT DISTINCT
                               r.TransactionID
                        FROM
                        (
                            SELECT 'I' [Type],
                                   *
                            FROM inserted
                            UNION ALL
                            SELECT 'D' [Type],
                                   *
                            FROM deleted
                        ) r
                        GROUP BY TransactionID,
                                 SourceReceiptID,
                                 PayType,
                                 UserID,
                                 AccountID,
                                 AccountName,
                                 BankAccount,
                                 BankCode,
                                 Amount,
                                 Fee,
                                 RelatedFee,
                                 RelatedAmount,
                                 RelatedUserID,
                                 RelatedAccountID,
                                 RelatedAccount,
                                 Description,
                                 PaymentApp,
                                 PaymentReferenceID,
                                 BankReferenceID,
                                 BillingOrderID,
                                 CreatedUser,
                                 DeviceType,
                                 ClientIP,
                                 CreatedTime,
                                 InitTime
                        HAVING COUNT(*) = 1
                    ) t
                        ON i.TransactionID = t.TransactionID
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END
        IF (@Action = 'D')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM deleted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;
        IF (@Action = 'I')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM inserted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;

        IF @ChangeMsg IS NOT NULL
            EXEC [EDWInitiatorSB].dbo.sp_SendMessage_Transactions @ServiceName = @ServiceName,
                                                                  @MessageTypeName = N'//WalletTransaction/TransactionsReceipt/Request',
                                                                  @MessageBody = @ChangeMsg
    END

END
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsReceipt_IUD]',
                        @order = N'Last',
                        @stmttype = N'DELETE'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsReceipt_IUD]',
                        @order = N'Last',
                        @stmttype = N'INSERT'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsReceipt_IUD]',
                        @order = N'Last',
                        @stmttype = N'UPDATE'
GO
```

Table: Transactions_System

```sql
USE [Wallet.Transaction]
GO
CREATE OR ALTER TRIGGER [dbo].[tr_TransactionsSystem_IUD]
ON [dbo].[Transactions_System]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @ChangeMsg XML;
    DECLARE @DeletedCnt INT = 0;
    DECLARE @InsertedCnt INT = 0;
    DECLARE @Action CHAR(1);
    DECLARE @Source_Name VARCHAR(20) = 'PAYMOBI';
    DECLARE @Batch_Id INT = 0;
    DECLARE @Sync_Id INT = 0;
    DECLARE @ServiceName NVARCHAR(512) = N'//WalletTransaction/Service/Source';

    BEGIN
        SELECT @InsertedCnt = COUNT(*)
        FROM inserted
        SELECT @DeletedCnt = COUNT(*)
        FROM deleted

        SELECT @Action = CASE
                             WHEN @InsertedCnt IS NOT NULL
                                  AND @DeletedCnt IS NOT NULL THEN
                                 'U'
                             WHEN @InsertedCnt IS NULL THEN
                                 'D'
                             ELSE
                                 'I'
                         END
        IF (@Action = 'U')
        BEGIN
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       i.*
                FROM inserted i
                    JOIN
                    (
                        SELECT DISTINCT
                               r.TransactionID
                        FROM
                        (
                            SELECT 'I' [Type],
                                   *
                            FROM inserted
                            UNION ALL
                            SELECT 'D' [Type],
                                   *
                            FROM deleted
                        ) r
                        GROUP BY [TransactionID],
                                 [RelationReceiptID],
                                 [ServiceID],
                                 [PayType],
                                 [AccountID],
                                 [TransactorID],
                                 [Amount],
                                 [RelatedAmount],
                                 [GrandAmount],
                                 [AmountState],
                                 [OpenBalance],
                                 [CloseBalance],
                                 [CreatedUnixTime]
                        HAVING COUNT(*) = 1
                    ) t
                        ON i.TransactionID = t.TransactionID
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END
        IF (@Action = 'D')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM deleted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;
        IF (@Action = 'I')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM inserted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;

        IF @ChangeMsg IS NOT NULL
            EXEC [EDWInitiatorSB].dbo.sp_SendMessage_Transactions @ServiceName = @ServiceName,
                                                                  @MessageTypeName = N'//WalletTransaction/TransactionsSystem/Request',
                                                                  @MessageBody = @ChangeMsg
    END

END
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsSystem_IUD]',
                        @order = N'Last',
                        @stmttype = N'DELETE'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsSystem_IUD]',
                        @order = N'Last',
                        @stmttype = N'INSERT'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsSystem_IUD]',
                        @order = N'Last',
                        @stmttype = N'UPDATE'
GO
```

