CREATE TABLE [dbo].[OrdersInvoicePaymentStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	InvoiceOrderId	bigint,
	PaymentAppId	int,
	PaymentApp	varchar(50),
	MerchantUserId	int,
	MerchantAccount	varchar(30),
	MerchantOrderAmount	numeric(28,12),
	MerchantAmount	numeric(28,12),
	MerchantFee	numeric(28,12),
	MerchantReferenceId	varchar(50),
	RedirectURL	varchar(250),
	NotifyURL	varchar(250),
	ResponseTime	datetimeoffset,
	ResponseMessage	nvarchar(200)
)
