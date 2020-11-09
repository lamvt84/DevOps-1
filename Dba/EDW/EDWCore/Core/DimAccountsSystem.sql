CREATE TABLE Core.[DimAccountsSystem]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name Varchar(20),
	Batch_Id int,
	Created_Time datetimeoffset,
	Updated_Time datetimeoffset,
	Current_Flag varchar(1),
	Delete_Flag varchar(1),
	AccountId int,
	TransactorId int,
	Balance numeric(28,12),
	AccountUpdatedTime datetimeoffset
)
