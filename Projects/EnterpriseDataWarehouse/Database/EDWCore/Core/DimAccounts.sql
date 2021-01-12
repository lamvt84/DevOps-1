CREATE TABLE Core.[DimAccounts]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name Varchar(20),
	Batch_Id int,
	Created_Time datetimeoffset,
	Updated_Time datetimeoffset,
	Current_Flag varchar(1),
	Delete_Flag varchar(1),
	AccountType varchar(1),
	UserId int,
	AccountId int,
	Accountname varchar(50),
	Balance numeric(28,12),
	BalanceType tinyint,
	Currency char(5),
	AccountCreatedTime datetimeoffset
)
