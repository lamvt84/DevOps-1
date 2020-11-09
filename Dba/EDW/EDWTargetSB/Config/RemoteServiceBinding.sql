CREATE REMOTE SERVICE BINDING [//WalletAccount/Binding/Source]
	TO SERVICE '//WalletAccount/Service/Source'
	WITH USER = [InitiatorUser]
GO
CREATE REMOTE SERVICE BINDING [//WalletTransaction/Binding/Source]
	TO SERVICE '//WalletTransaction/Service/Source'
	WITH USER = [InitiatorUser]
GO
CREATE REMOTE SERVICE BINDING [//WalletProperty/Binding/Source]
	TO SERVICE '//WalletProperty/Service/Source'
	WITH USER = [InitiatorUser]
GO