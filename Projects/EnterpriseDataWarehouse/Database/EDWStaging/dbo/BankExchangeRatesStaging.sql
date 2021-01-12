CREATE TABLE [dbo].[BankExchangeRatesStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	ExchangeRateId	int,
	Currency	char(5),
	Rate	numeric(28,12),
	AppliedTime	datetimeoffset,
	CreatedUser	varchar(30),
	CreatedTime	datetimeoffset
)
