# DWH Architect



### Scope

* Building an DWH for storing Data and Reports
* Data must be near real time compared with Core DB
* DWH's data must be consistency compared with Core DB

### Solution

**Service Broker** for near real time synchronization

When data changes, MSSQL creates a conversation between Core Initiator Service Broker and DWH Target Service Broker. The change is sent within Queue from Initiator. Target receives and synchronizes the change with current DWH data.

**SSIS ETL** for data consistency

A scheduled job (daily, hourly, delta) that will build a batch of data and send from Core to DWH Staging and re-synchronize with current data in DWH

![Architect](https://github.com/LouisVu84/DevOps/blob/master/Dba/EDW/Doc/Flow.PNG)

