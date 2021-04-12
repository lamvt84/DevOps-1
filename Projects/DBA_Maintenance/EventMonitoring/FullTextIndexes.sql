CREATE FULLTEXT INDEX ON [dbo].[SlowQueryLog]
    ([STMT_Batch_Text] LANGUAGE 1033)
    KEY INDEX [PK_SlowQueryLog]
    ON [SlowLogCatalog];

