CREATE MESSAGE TYPE [//WalletAccount/Accounts/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/AccountsSecondary/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/AccountsSystem/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/Accounts/Reply] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/Users/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/UsersAuth/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/UsersAuthDevices/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/UsersBlockService/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/UsersProfile/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/UsersProfileVerification/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/UsersSecureConfig/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletAccount/Users/Reply] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/Transactions/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsInitialAccount/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsReceipt/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/TransactionsSystem/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletTransaction/Transactions/Reply] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/BankExchangeRates/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/Banks/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/BanksPartnerChannels/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/PaymentAppsButton/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/PaymentAppsMobile/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/PaymentAppsWebsite/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/TransactionsServiceFees/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/TransactionsServices/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/UsersProfileAttributesDict/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/UsersProfileLocations/Request] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//WalletProperty/References/Reply] VALIDATION = WELL_FORMED_XML
GO
/*******************************************************************************/
CREATE MESSAGE TYPE [//ETL/Batch/Message/Transactions] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//ETL/Batch/Message/TransactionsReceipt] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//ETL/Batch/Message/TransactionsSystem] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//ETL/Batch/Message/Reply] VALIDATION = WELL_FORMED_XML
GO
