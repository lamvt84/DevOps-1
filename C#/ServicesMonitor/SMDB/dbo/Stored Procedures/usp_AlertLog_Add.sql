CREATE PROCEDURE [dbo].[usp_AlertLog_Add] @AlertType       VARCHAR(10), 
                                          @AlertUrl        VARCHAR(200), 
                                          @RequestMessage  VARCHAR(1000), 
                                          @ResponseMessage VARCHAR(1000)
AS
     INSERT INTO [dbo].AlertLog
     (AlertType, 
      AlertUrl, 
      RequestMessage, 
      ReponseMessage
     )
     VALUES
     (@AlertType, 
      @AlertUrl, 
      @RequestMessage, 
      @ResponseMessage
     );