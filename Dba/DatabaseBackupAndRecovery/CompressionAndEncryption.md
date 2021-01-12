Table of contents
=================
<!--ts-->   
   * [Benefit](#Benefit)  
   * [Compare with 7zip](#Compare-with-7zip)
   * [Certificate Installation](#Certificate-Installation)
   * [Backup Database](#Backup-Database)
   * [Restore Database](#Restore-Database)
   * [Troubleshoot](#Troubleshoot)
<!--te-->

### Benefit

- Encryption: 

  https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/backup-encryption?view=sql-server-ver15

  - Encrypt backup data while creating backup file
  - Encrypt with algorithms: AES 128, AES 192, AES 256, and Triple DES
  - Encrypt using Certificate with Private Key.
  - Couldn't restore the backup file without Certificate

- Compression: 

  https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/backup-compression-sql-server?view=sql-server-ver15

  - Creating a backup file with smaller size
  - Less server throughput IO
  - Less backup time 

### Compare with 7zip 

Sample: 50GB Database

|             | Compression Option | 7Zip                                              |
| :---------- | :----------------- | :------------------------------------------------ |
| Time        | 09 min 46 sec      | Backup Full: 17 min 08 secCompress: 49 min 46 sec |
| Backup Size | 15GB               | 10GB                                              |

### Certificate Installation

```sql
/* Create Database MASTER KEY for Source Database*/
USE [master]
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.symmetric_keys WHERE name LIKE '%DatabaseMasterKey%')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = '###' -- MasterKeyPassword
END
Go
 
/* Create backup certificate */
CREATE CERTIFICATE BackupCertification
    WITH SUBJECT = 'Certification for database backup'
GO
 
/* Back up MASTER KEY and Cert */
BACKUP MASTER KEY
TO FILE = 'E:\Cert\MasterKey_SQL201922.key'
ENCRYPTION BY PASSWORD = '###'
GO
BACKUP CERTIFICATE BackupCertification
TO FILE = '<location>\BackupCertification.cer'
WITH PRIVATE KEY
(
    FILE = '<location>\BackupCertificationPK.key'
   ,ENCRYPTION BY PASSWORD = '###' -- Private Key Password
)
GO
```

### Backup Database

```sql
BACKUP DATABASE [TestDB] TO  DISK = N'FilePath.bak'
WITH FORMAT, INIT, 
    MEDIANAME = N'TestDB', 
    NAME = N'TestDB-Full Database Backup',
    SKIP, NOREWIND, NOUNLOAD,
    COMPRESSION,
    ENCRYPTION(ALGORITHM = AES_256, SERVER CERTIFICATE = [BackupCertification]),
    CHECKSUM
GO
RESTORE VERIFYONLY FROM  DISK = N'FilePath.bak' /* Need [BackupCertification] installed on SQL SERVER */
```

### Restore Database

```sql
/* Create Database MASTER KEY for Source Database */
USE [master]
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.symmetric_keys WHERE name LIKE '%DatabaseMasterKey%')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = '###' -- MasterKeyPassword, doesn't need to be the same with master key on source database
END
GO
 
/* Create Certification from source certificate to target database */
CREATE CERTIFICATE BackupCertification
    FROM FILE = '<location>\BackupCertification.cer'
     WITH PRIVATE KEY
      (
        FILE = '<location>\BackupCertificationPK.key',
        DECRYPTION BY PASSWORD = '###' -- Private Key Password
      )
GO
 
/* Restore Database */
RESTORE DATABASE [TestDB] FROM  DISK = N'FilePath.bak'
GO
```

### Troubleshoot

- Create certificate with wrong private key password: 

  ``` diff
  -The private key password is invalid.
  ```

- Restore database from backup file without certificate:

  ```diff
  -Cannot find server certification with thumbprint '0x.....'.
  -RESTORE DATABASE is terminating abnormally
  ```

  
