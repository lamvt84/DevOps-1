USE [EDWInitiatorSB]
GO
CREATE MESSAGE TYPE [//ETL/Batch/Message/Transactions] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//ETL/Batch/Message/Reply] VALIDATION = WELL_FORMED_XML
GO
CREATE CONTRACT [//ETL/Batch/Contract]
      (
            [//ETL/Batch/Message/Transactions] SENT BY INITIATOR,
            [//ETL/Batch/Message/Reply] SENT BY TARGET
      );
GO
CREATE QUEUE [dbo].[//ETL/Batch/Queue/Source]
GO
CREATE SERVICE [//ETL/Batch/Service/Source]
	AUTHORIZATION [dbo]
	ON QUEUE [dbo].[//ETL/Batch/Queue/Source] (
		[//ETL/Batch/Contract]
	)
GO