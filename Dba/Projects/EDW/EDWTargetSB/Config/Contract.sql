CREATE CONTRACT [//WalletAccount/Contract/Accounts]
      (
            [//WalletAccount/Accounts/Request] SENT BY INITIATOR,
            [//WalletAccount/AccountsSecondary/Request] SENT BY INITIATOR,
            [//WalletAccount/AccountsSystem/Request] SENT BY INITIATOR,
            [//WalletAccount/Accounts/Reply] SENT BY TARGET
      );
GO

CREATE CONTRACT [//WalletAccount/Contract/Users]
      (
            [//WalletAccount/Users/Request] SENT BY INITIATOR,
            [//WalletAccount/UsersAuth/Request] SENT BY INITIATOR,
            [//WalletAccount/UsersAuthDevices/Request] SENT BY INITIATOR,
            [//WalletAccount/UsersBlockService/Request] SENT BY INITIATOR,
            [//WalletAccount/UsersProfile/Request] SENT BY INITIATOR,
            [//WalletAccount/UsersProfileVerification/Request] SENT BY INITIATOR,
            [//WalletAccount/UsersSecureConfig/Request] SENT BY INITIATOR,
            [//WalletAccount/Users/Reply] SENT BY TARGET
      );
GO

CREATE CONTRACT [//WalletTransaction/Contract/Transactions]
      (
            [//WalletTransaction/Transactions/Request] SENT BY INITIATOR,
            [//WalletTransaction/TransactionsInitialAccount/Request] SENT BY INITIATOR,
            [//WalletTransaction/TransactionsReceipt/Request] SENT BY INITIATOR,
            [//WalletTransaction/TransactionsSystem/Request] SENT BY INITIATOR,
            [//WalletTransaction/Transactions/Reply] SENT BY TARGET
      );
GO

CREATE CONTRACT [//WalletProperty/Contract/References]
      (
           [//WalletProperty/BankExchangeRates/Request] SENT BY INITIATOR,
            [//WalletProperty/Banks/Request] SENT BY INITIATOR,
            [//WalletProperty/BanksPartnerChannels/Request] SENT BY INITIATOR,
            [//WalletProperty/PaymentAppsButton/Request] SENT BY INITIATOR,
            [//WalletProperty/PaymentAppsMobile/Request] SENT BY INITIATOR,
            [//WalletProperty/PaymentAppsWebsite/Request] SENT BY INITIATOR,
            [//WalletProperty/TransactionsServiceFees/Request] SENT BY INITIATOR,
            [//WalletProperty/TransactionsServices/Request] SENT BY INITIATOR,
            [//WalletProperty/UsersProfileAttributesDict/Request] SENT BY INITIATOR,
            [//WalletProperty/UsersProfileLocations/Request] SENT BY INITIATOR,
            [//WalletProperty/References/Reply] SENT BY TARGET
      );
GO

CREATE CONTRACT [//ETL/Batch/Contract]
      (
            [//ETL/Batch/Message/Transactions] SENT BY INITIATOR,
            [//ETL/Batch/Message/TransactionsReceipt] SENT BY INITIATOR,
            [//ETL/Batch/Message/TransactionsSystem] SENT BY INITIATOR,
            [//ETL/Batch/Message/Reply] SENT BY TARGET
      );
GO