CREATE REMOTE SERVICE BINDING [//WalletAccount/Binding/Target]
	TO SERVICE '//WalletAccount/Service/Target'
	WITH USER = [TargetUser]
GO
CREATE REMOTE SERVICE BINDING [//WalletTransaction/Binding/Target]
	TO SERVICE '//WalletTransaction/Service/Target'
	WITH USER = [TargetUser]
GO
CREATE REMOTE SERVICE BINDING [//WalletProperty/Binding/Target]
	TO SERVICE '//WalletProperty/Service/Target'
	WITH USER = [TargetUser]
GO