CREATE CERTIFICATE [InitiatorCertificate]
	AUTHORIZATION [InitiatorUser]
	WITH 
		SUBJECT = N'ServiceBroker Initiator Certificate',
		EXPIRY_DATE = N'12/31/2030'
GO