# Deployment & Configuration



### Source

https://dev.azure.com/iris2019/1F_PayMobi_DevOps/_git/1F_PayMobi_DevOps 



### Site

##### Deployment

- **Database** - Project: SMDB
  - In Securiy > Logins.sql, there is a script to create a specific login for DB:
    - User: sqlmonitor
    - Password: **M00nj$--Hto##
  - Build the project and get the .dacpac file
  - Deploy database with .dacpac file
- **Site** - project: **MVCSite**
  - Publish the project to a package folder:
    - Target framework: netcore 3.1
    - Target runtime: portable
  - Bring a package folder and deploy to server

##### Configuration

* **appsettings.json**

  * DefaultConnection: use login that was create with database project

  * ExtendSettings:

    ```
    "ExtendSettings": {
    	"SecureKey": "c4ca4238a0b923820dcc509a6f75849b",
        "SendMailUrl": "http://10.54.170.73:8245/api/MobiService/SendMail",
        "SendSmsUrl": "http://10.54.170.73:8245/api/MobiService/SendSMS"
      }
    ```

    

### Health Check Task

##### Cases

- Normal: Services that can be queried directly from DB with health check scripts
- Special: Services that can be retrieved via restful get method

##### Deployment

* Module installation:

  * Check TaskSchedule > Modules for **ThreadJob.zip**
  * Bring this file to server and unzip in C:\Program Files\WindowsPowerShell\Modules
  * Verify: Open Windows Powershell ISE, looking for Commands tab on the right, click on Modules dropdownlist and find the **ThreadJob** module

* Task installation:

  * Bring all these files to server:

    * Libs.ps1
    * ProcessHealthCheck.ps1
    * Config.json
    * TaskTemplate.xml

  * Create a ps1 file call: CallProcess.ps1

    * Normal case

    ```powershell
    <Physical_Path>\ProcessHealthCheck.ps1
    ```

    - Special case

    ```powershell
    <Physical_Path>\ProcessHealthCheck.ps1 -Object @(87,88,89,90,91,92,93,94,95,96,97,98,99)
    
    # @(87,88,89,90,91,92,93,94,95,96,97,98,99) = Id set of services
    # Service Id can be retrieved with monitor site
    ```

  - Go to Task Scheduler, import new task with TaskTemplate.xml

  * In actions tab, modify the action with right path to CallProcess.ps1

##### Configuration

- Config.json

  ```
  {
    "SqlInstance": "SQLFCI-REPORT", // Instance name or IP
    "Database": "wUtility.HealCheckDB", // Monitor DB
    "User": "sqlmonitor",
    "Password": "**M00nj$--Hto##",
    "RootUrl": "http://10.54.170.75:8275" // Site URL
  }
  ```



### Groups, Services & Alert configuration

All these configurations can be check in Site > Configuration

##### Groups

Currently, there are 3 types:

- **API**: Call a service api to verify if service is working or not (HttpStatus)
- **TCP**: Use telnet with IP and Port to verify
- **UCP**: Use UdpClient with IP and Port to verify

The Process will get service with group type and decide the way to verify it.

In order to create/modify groups, go to Site > Configuration > Groups

##### Services

Beside required properties that are Url, Group Type and Name, each service have 3 extend properties:

- **Status**: status of the service // 1 ~ up, 0 ~ down
- **Enable**: health check process will check only enabled services // 1 ~ enable, 0 ~ disable
- **Special** Case: health check process will check services with special case rule

##### Alert

**Rule**:

- 1st: Immediately
- 2nd: After 5 mins
- 3rd: After 15 mins
- 4th: After 60 mins
- Stop sending alert after 4th step
  Operation:
- Go to Site > Dashboard and TURN OFF Alert
- Rule will be reset after TURNING ON via Site > Dashboard 

**Mail**

* Contains all email required properties

**SMS**

- Contains all SMS required properties