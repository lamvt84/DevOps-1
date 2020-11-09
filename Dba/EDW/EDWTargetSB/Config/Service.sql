CREATE SERVICE [//WalletAccount/Service/Target]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//WalletAccount/Queue/Target] (
		[//WalletAccount/Contract/Accounts],
		[//WalletAccount/Contract/Users]
	)
GO
CREATE SERVICE [//WalletTransaction/Service/Target]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//WalletTransaction/Queue/Target] (
		[//WalletTransaction/Contract/Transactions]
	)
GO
CREATE SERVICE [//WalletProperty/Service/Target]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//WalletProperty/Queue/Target] (
		[//WalletProperty/Contract/References]
	)
GO
CREATE SERVICE [//ETL/Batch/Service/Target]
	AUTHORIZATION [InitiatorUser]
	ON QUEUE [dbo].[//ETL/Batch/Queue/Target] (
		[//ETL/Batch/Contract]
	)
GO