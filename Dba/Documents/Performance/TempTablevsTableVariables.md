### Temp Table vs Table Variables

```sql
DECLARE @user TABLE
(
    ID INT NOT NULL,
    AccountID INT,
    CreationDate DATETIME,
    DisplayName VARCHAR(100),
    INDEX IX_ID CLUSTERED (ID),
    INDEX IX_AccountID NONCLUSTERED (AccountID)
);

INSERT INTO @user
SELECT TOP 1000
       Id,
       AccountId,
       CreationDate,
       DisplayName
FROM StackOverflow.dbo.Users;

/* Index scan because there aren't any statistic for table variable */
SELECT *
FROM @user
WHERE AccountID = 1;

DROP TABLE IF EXISTS #user;
CREATE TABLE #user
(
    ID INT NOT NULL,
    AccountID INT,
    CreationDate DATETIME,
    DisplayName VARCHAR(100),
    INDEX IX_ID CLUSTERED (ID),
    INDEX IX_AccountID NONCLUSTERED (AccountID)
);

INSERT INTO #user
SELECT TOP 1000
       Id,
       AccountId,
       CreationDate,
       DisplayName
FROM StackOverflow.dbo.Users;

/* Index Seek because of statistic */
SELECT *
FROM #user
WHERE AccountID = 1;
```

