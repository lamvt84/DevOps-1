CREATE TABLE Core.[FactTransactionsSystem]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name Varchar(20),
	Batch_Id int,
	Sync_Id int,
	Created_Time datetimeoffset,
	Updated_Time datetimeoffset,
	Current_Flag varchar(1),
	Delete_Flag varchar(1),
	TransactionId bigint,
	RelationReceiptId bigint,
	ServiceId int,
	PayType tinyint,
	AccountId int,
	TransactorId int,
	Amount numeric(28,12),
	RelatedAmount numeric(28,12),
	GrandAmount numeric(28,12),
	AmountState bit,
	OpenBalance numeric(28,12),
	CloseBalance numeric(28,12),
	CreatedUnixTime int
)
