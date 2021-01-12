CREATE TABLE [dbo].[TransactionsServiceFeesStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	FeeConfigId	int,
	Note	nvarchar(450),
	Paytypes	varchar(50),
	Services	varchar(500),
	TransferorFee	varchar(50),
	ReceiverFee	varchar(50),
	NextTransferorFee	varchar(50),
	NextReceiverFee	varchar(50),
	NextApplyTime	datetimeoffset,
	Changeable	bit,
	ApplyObjectId	int,
	ApplyObjectType	tinyint,
	UpdatedTime	datetimeoffset
)
