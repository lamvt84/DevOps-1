# About

**Zabbix 5.0.1 & MSSQL WSFC**

# Environment

MSSQL

| Object      | Name           | Description                       |
|-------------|----------------|-----------------------------------|
| Server      | Virtual IP     | 10.10.1.1                         |
|             | Node 1         | 10.10.1.2                         |
|             | Node 2         | 10.10.1.3                         |
| Login       | User           | zabmonitor                       |
|             | Password       | password                          |
|             | Permission     | [update later]                    |

Zabbix

| Object      | Name           | Description                                                                     |
|-------------|----------------|---------------------------------------------------------------------------------|
| Agent       | Node 1         | Install agent on port number 10050                                              |
|             | Node 2         | Install agent on port number 10050                                              |
| Template    | MSSQL WSFC     | https://github.com/hermanekt/MSSQL-2008-2016-Multi-instance-with-WSFC           |
|             | MSSQL ODBC     | https://git.zabbix.com/projects/ZBX/repos/zabbix/browse/templates/db/mssql_odbc |

# Import templates

* On Zabbix main webpage, go to **Configuration** -> **Templates** -> **Import** (on the top right hand coner of the screen)

* Add template file (.xml) with *Screens - Create New* option

# Create host

On Zabbix main webpage, go to **Configuration** -> **Hosts** -> **Create host** (on the top right hand coner of the screen)

Host

* Interfaces:
    * Add agent for Node 1
	* Add agent for Node 2
* Other fields: put required value to each fields

Templates

* Select 2 templates for linked that were imported


Macro

* Click on **Inherited and host macros**
* Find {$MSSQL.USER} and {$MSSQL.PASSWORD}, click **change** and put your value there
* Modify others options based on your need 

Finally, click Add to create a new host and wait for some minutes until zabbix updates server information



 *docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Hh010898@@" -p 6699:1433 -d mcr.microsoft.com/mssql/server:2019-latest*