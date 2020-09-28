CREATE PROCEDURE [dbo].usp_TaskSchedulerLog_Add @Source   UNIQUEIDENTIFIER, 
                                                @Name     VARCHAR(100), 
                                                @Duration INT
AS
     INSERT INTO [dbo].TaskSchedulerLog
     ([Source], 
      Name, 
      Duration
     )
     VALUES
     (@Source, 
      @Name, 
      @Duration
     );