USE master

IF EXISTS (SELECT 1/0 FROM dbo.sysdatabases WHERE name = 'DeadLockDB')
BEGIN
    DROP DATABASE [DeadLockDB]
END
GO

CREATE DATABASE [DeadLockDB]
GO

USE [DeadLockDB]
GO

CREATE TABLE [Brand] (
	Id INT PRIMARY KEY CLUSTERED,	
	Name VARCHAR(50) INDEX IX_Name
)
GO

CREATE TABLE [Product] (
	Id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	BrandId INT 
		CONSTRAINT FK_Brand_Product REFERENCES Brand(Id),
	Name VARCHAR(50) INDEX IX_Name,
	Status TINYINT NOT NULL DEFAULT(0)-- 0: Available, 1: Taken
)
GO

INSERT [Brand] (Id, Name) 
VALUES (1, 'Philips'), (2, 'Cuisinart'), (3, 'Trung Nguyen'), (4, 'Vinacafe')

INSERT [Product] (BrandId, Name)
VALUES (1, 'Viva Collection'), (1, 'Daily Collection'),
		(2, 'Digital Gooseneck Kettle'), (2, 'Aura 2 Quart Teakettle'),
		(3, 'G7 Pure Black Coffee'), (3, 'G7 Expresso Instant Coffee'),
		(4, 'Vinacafe Instant Coffee Mix'), (4, 'Vinacafe Golden Original Instant Coffee')

SELECT * FROM [Brand]
SELECT * FROM [Product]