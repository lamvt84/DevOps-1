CREATE TABLE [dbo].[TransactionsSystemStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Sync_Id		int,
	Action_Flag	varchar(1),
	TransactionId	bigint,
	RelationReceiptId	bigint,
	ServiceId	int,
	PayType	tinyint,
	AccountId	int,
	TransactorId	int,
	Amount	numeric(28,12),
	RelatedAmount	numeric(28,12),
	GrandAmount	numeric(28,12),
	AmountState	bit,
	OpenBalance	numeric(28,12),
	CloseBalance	numeric(28,12),
	CreatedUnixTime	int
)
