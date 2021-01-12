CREATE TABLE [dbo].[OrdersInvoiceBankingStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	InvoiceOrderId	bigint,
	BankId	int,
	BankCode	varchar(20),
	PartnerCode	varchar(50),
	BankAccount	varchar(20),
	BankAccountName	nvarchar(50),
	BankAmount	numeric(28,12),
	BankReferenceId	varchar(50),
	RedirectURL	varchar(250),
	NotifyURL	varchar(250),
	ResponseTime	datetimeoffset,
	ResponseUnixTime	int,
	ResponseMessage	nvarchar(150)
)
