/* Message Types */
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

/* Contract */
CREATE CONTRACT [//WalletTransaction/Contract/Transactions]
      (
            [//WalletTransaction/Transactions/Request] SENT BY INITIATOR,
            [//WalletTransaction/TransactionsInitialAccount/Request] SENT BY INITIATOR,
            [//WalletTransaction/TransactionsReceipt/Request] SENT BY INITIATOR,
            [//WalletTransaction/TransactionsSystem/Request] SENT BY INITIATOR,
            [//WalletTransaction/Transactions/Reply] SENT BY TARGET
      );
GO

/* Queue */
CREATE QUEUE [dbo].[//WalletTransaction/Queue/Target]
GO

/* Service */
CREATE SERVICE [//WalletTransaction/Service/Target]
	AUTHORIZATION [dbo]
	ON QUEUE [dbo].[//WalletTransaction/Queue/Target] (
		[//WalletTransaction/Contract/Transactions]
	)
GO