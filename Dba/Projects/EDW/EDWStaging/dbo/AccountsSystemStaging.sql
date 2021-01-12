CREATE TABLE [dbo].[AccountsSystemStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	AccountId	int,
	TransactorId	int,
	Balance	numeric(28,12),
	UpdatedTime	datetimeoffset
)
