CREATE TABLE [dbo].[BankAccountsStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	BankAccountId	int,
	UserId	int,
	AccountName	varchar(30),
	BankId	int,
	BankBranch	nvarchar(100),
	BankAccount	varchar(30),
	BankAccountName	nvarchar(100),
	BankAccountAddress	nvarchar(250),
	BankAccountType	tinyint,
	Description	nvarchar(250),
	IsDefault	bit,
	OpenDate	varchar(50),
	UpdatedUser	varchar(30),
	CreatedTime	datetimeoffset
)
