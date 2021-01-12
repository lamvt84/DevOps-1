# Service Broker Installation

### Scope

Create Message Types, Contract, Queue, Service for Transactions
* EDWInitiatorSB
* EDWTargetSB

### EDWInitiatorSB

**Source**
* D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\Initiator.sql

**Installation**

Run PS Scripts

```powershell
Import-Module dbatools

$script = "D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\Initiator.sql"
$servers = "LAMVT1FINTECH\SQL2019"
$database = "EDWInitiatorSB"    
$OutputFile = "D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\Initiator.txt"

Invoke-DbaQuery –SqlInstance $servers –File $script –Database $database –MessagesToOutput | Out-File –FilePath $OutputFile
```

### EDWTargetSB

**Source**
* D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\Target.sql

**Installation**

Run PS Scripts

```powershell
Import-Module dbatools

$script = "D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\Target.sql"
$servers = "LAMVT1FINTECH\SQL2019"
$database = "EDWTargetSB"    
$OutputFile = "D:\Repo\Personal\Github\DevOps\Dba\EDW\Doc\ScriptsToRun\Target.txt"

Invoke-DbaQuery –SqlInstance $servers –File $script –Database $database –MessagesToOutput | Out-File –FilePath $OutputFile
```

### Test

**Send** message to queue
```sql
USE [EDWInitiatorSB]
GO

DECLARE @MessageBody XML = '<Content>Test from Initiator</Content>';
DECLARE @MessageTypeName NVARCHAR(256) = N'//WalletTransaction/Transactions/Request'
DECLARE @InitDlgHandle UNIQUEIDENTIFIER;

BEGIN DIALOG @InitDlgHandle
    FROM SERVICE [//WalletTransaction/Service/Source]
    TO SERVICE N'//WalletTransaction/Service/Target'
    ON CONTRACT [//WalletTransaction/Contract/Transactions]
    WITH
        ENCRYPTION = ON;

;SEND ON CONVERSATION @InitDlgHandle
    MESSAGE TYPE @MessageTypeName (@MessageBody);

;END CONVERSATION @InitDlgHandle
```

**Check** message in queue
```sql
USE [EDWTargetSB]
GO

SELECT * FROM [dbo].[//WalletTransaction/Queue/Target]
```

**Receive** message from queue
```sql
USE [EDWTargetSB]
GO

DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
DECLARE @RecvReqMsg XML;
DECLARE @RecvReqMsgName sysname;
DECLARE @ServiceName VARCHAR(512) = '//WalletTransaction/Service/Target'

WAITFOR
    ( RECEIVE TOP(1)
        @RecvReqDlgHandle = conversation_handle,
        @RecvReqMsg = message_body,
        @RecvReqMsgName = message_type_name
        FROM [dbo].[//WalletTransaction/Queue/Target]
    ), TIMEOUT 1000;

IF @RecvReqMsgName = '//WalletTransaction/Transactions/Request'
    SELECT @RecvReqMsg
IF @RecvReqMsgName = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
    END CONVERSATION @RecvReqDlgHandle
```