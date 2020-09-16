CREATE TABLE [dbo].[AlertMapping]
(
	[AlertConfigId] INT NOT NULL, 
    [MappingId] INT NOT NULL, 
    [MappingType] TINYINT NOT NULL,
    CONSTRAINT PK_AlertMapping PRIMARY KEY CLUSTERED ([AlertConfigId], [MappingId], [MappingType])
)
