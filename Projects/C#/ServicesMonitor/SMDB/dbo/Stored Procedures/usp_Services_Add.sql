CREATE PROCEDURE [dbo].[usp_Services_Add] @GroupId      INT, 
                                          @Name         VARCHAR(100), 
                                          @Description  VARCHAR(500), 
                                          @Url          VARCHAR(500), 
                                          @Params       VARCHAR(500), 
                                          @ResponseCode VARCHAR(100), 
                                          @Enable       TINYINT, 
                                          @Status       TINYINT,
                                          @SpecialCase      TINYINT
AS
     INSERT INTO [dbo].[Services]
     ([GroupId], 
      [Name], 
      [Description], 
      [Url], 
      [Params], 
      [ResponseCode], 
      [Enable],
      [Status],
      SpecialCase
     )
     VALUES
     (@GroupId, 
      @Name, 
      @Description, 
      @Url, 
      @Params, 
      @ResponseCode, 
      @Enable, 
      @Status,
      @SpecialCase
     );