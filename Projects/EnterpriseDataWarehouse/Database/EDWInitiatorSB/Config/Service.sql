CREATE SERVICE [//WalletAccount/Service/Source]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//WalletAccount/Queue/Source] (
		[//WalletAccount/Contract/Accounts],
		[//WalletAccount/Contract/Users]
	)
GO
CREATE SERVICE [//WalletTransaction/Service/Source]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//WalletTransaction/Queue/Source] (
		[//WalletTransaction/Contract/Transactions]
	)
GO
CREATE SERVICE [//WalletProperty/Service/Source]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//WalletProperty/Queue/Source] (
		[//WalletProperty/Contract/References]
	)
GO
CREATE SERVICE [//ETL/Batch/Service/Source]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//ETL/Batch/Queue/Source] (
		[//ETL/Batch/Contract]
	)
GO
