CREATE TABLE [dbo].[TransactionsServiceStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	ServiceId	int,
	GroupServiceId	int,
	GroupServiceName	nvarchar(150),
	ServiceKey	nvarchar(50),
	ServiceName	nvarchar(100),
	Description	nvarchar(250),
	AffectToBalance	tinyint,
	Enable	bit,
	ParentId	int
)
