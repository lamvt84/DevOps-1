# Slowly Changing Dimension



### Definition

**Slowly Changing Dimensions (SCD)** 

* Dimensions that change slowly over time, rather than changing on regular schedule, time-base. In Data Warehouse there is a need to track changes in dimension attributes in order to report historical data. In other words, implementing one of the SCD types should enable users assigning proper dimension's attribute value for given date. Example of such dimensions could be: customer, geography, employee.

* There are many approaches how to deal with SCD. The most popular are:
  * **Type 0** - The passive method
  * **Type 1** - Overwriting the old value
  * **Type 2** - Creating a new additional record
  * **Type 3** - Adding a new column
  * **Type 4** - Using historical table
  * **Type 6** - Combine approaches of types 1,2,3 (1+2+3=6)

**SCD Type for PAYMOBI**

- **Type 2** will be implemented based on business requirements and current production environment
- In this methodology all history of dimension changes is kept in the database. You capture attribute change by adding a new row with a new surrogate key to the dimension table. Both the prior and new rows contain as attributes the natural key(or other durable identifier). 

### Explanation

Data before the change

| Customer_ID | Customer_Name | Customer_Type | Start_Date | End_Date   | Current_Flag |
| :---------- | :------------ | :------------ | :--------- | :--------- | :----------- |
| 1           | Cust_1        | Corporate     | 22-07-2010 | 31-12-9999 | Y            |

Data after the change

| Customer_ID | Customer_Name | Customer_Type | Start_Date | End_Date   | Current_Flag |
| :---------- | :------------ | :------------ | :--------- | :--------- | :----------- |
| 1           | Cust_1        | Corporate     | 22-07-2010 | 17-05-2012 | N            |
| 2           | Cust_1        | Retail        | 18-05-2012 | 31-12-9999 | Y            |