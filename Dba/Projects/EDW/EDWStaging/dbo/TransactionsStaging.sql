CREATE TABLE [dbo].[TransactionsStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Sync_Id		int,
	Action_Flag	varchar(1),
	TransactionId	bigint,
	RelationReceiptId	bigint,
	PayType	tinyint,
	ServiceId	int,
	AccountId	int,
	Amount	numeric(28,12),
	AmountState	bit,
	Description	nvarchar(300),
	OpenBalance	numeric(28,12),
	CloseBalance	numeric(28,12),
	CreatedUnixTime	int,
	InitUnixTime	int,
	ClientUnixIP	bigint
)
