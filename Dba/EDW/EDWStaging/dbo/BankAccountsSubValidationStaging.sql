CREATE TABLE [dbo].[BankAccountsSubValidationStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	BankAccountId	int,
	SubscriptionId	varchar(300),
	BankAccount	varchar(30),
	BankId	int,
	UserId	int,
	IssueDate	date,
	ExpireDate	date,
	CreatedTime	datetimeoffset
)
