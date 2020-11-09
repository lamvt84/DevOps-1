CREATE TABLE [dbo].[AccountsStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	UserId	int,
	AccountId	int,
	Accountname	varchar(50),
	Balance	numeric(28,12),
	BalanceType	tinyint,
	Currency	char(5)
)
