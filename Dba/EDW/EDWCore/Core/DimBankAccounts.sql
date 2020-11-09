CREATE TABLE Core.[DimBankAccounts]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name Varchar(20),
	Batch_Id int,
	Created_Time datetimeoffset,
	Updated_Time datetimeoffset,
	Current_Flag varchar(1),
	Delete_Flag varchar(1),
	BankAccountId int,
	UserId int,
	AccountName varchar(30),
	BankId int,
	BankBranch nvarchar(100),
	BankAccount varchar(30),
	BankAccountName nvarchar(100),
	BankAccountAddress nvarchar(250),
	BankAccountType tinyint,
	Description nvarchar(250),
	IsDefault bit,
	OpenDate varchar(50),
	UpdatedUser varchar(30),
	CreatedTime datetimeoffset
)
