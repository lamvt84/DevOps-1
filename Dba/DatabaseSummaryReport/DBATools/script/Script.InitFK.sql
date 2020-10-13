IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_QueueDatabase_Queue]') AND parent_object_id = OBJECT_ID(N'[dbo].[QueueDatabase]'))
ALTER TABLE [dbo].[QueueDatabase]  WITH CHECK ADD  CONSTRAINT [FK_QueueDatabase_Queue] FOREIGN KEY([QueueID])
REFERENCES [dbo].[Queue] ([QueueID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_QueueDatabase_Queue]') AND parent_object_id = OBJECT_ID(N'[dbo].[QueueDatabase]'))
ALTER TABLE [dbo].[QueueDatabase] CHECK CONSTRAINT [FK_QueueDatabase_Queue]
GO
