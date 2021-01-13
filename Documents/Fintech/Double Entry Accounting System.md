# Double Entry Accounting System

<!--ts-->
* [DEFINITION](#DEFINITION)
* [SCOPE](#SCOPE)
* [OBJECT](#OBJECT)
* [DESCRIPTION](#DESCRIPTION)
   * [Deposit](#Deposit)
   * [Internal payment without fee](#Internal-payment-without-fee)
   * [External payment with fee](#External-payment-with-fee)
* [BUSINESS FLOW](#BUSINESS-FLOW)
<!--te-->

### DEFINITION

-	Double Entry (Bút toán kép) là nguyên tắc ghi sổ kép trên cơ sở ý tưởng rằng mỗi giao dịch đều có ảnh hưởng cân bằng nhưng theo hai chiều đối lập nhau. Mỗi nghiệp vụ kế toán phải được ghi nhận trong các tài khoản ở cả bên Nợ và bên Có đối ứng. Double Entry là nguyên lí căn bản của kế toán.
-	Ledger General (Sổ cái) là nơi lưu trữ hoạt động của các tài khoản đáp ứng yêu cầu nghiệp vụ kế toán.
o	Debit: Bên nợ trong tài khoản chữ T.
o	Credit: Bên có trong tài khoản chữ T.

### SCOPE

-	Double Entry áp dụng cho hệ thống ví điện tử.
-	Double Entry lưu trữ thông tin tài khoản minh bạch, an toàn.
-	Double Entry đáp ứng được yêu cầu chuẩn hóa về hệ thống tài chính, các quy trình nghiệp vụ kế toán, kiểm toán.

### OBJECT

-	AccountBooking: Tập tài khoản khách hàng
-	HouseBooking: Tập tài khoản ví
-	Ledger General: Sổ cái
-	Order: Các giao dịch được khách hàng ủy quyền hệ thống xử lý
-	Document: Các tài liệu đính kèm tương ứng với mỗi giao dịch

### DESCRIPTION

Mỗi tài khoản trong hệ thống được lưu trữ bao gồm:
-	ID Tài khoản
-	Ngày chốt số dư - close_date
-	Số dư cuối kỳ - close_balance (tính đến ngày chốt số dư)
-	Tổng ghi nợ - total_debit (tính từ ngày chốt số dư)
-	Tổng ghi có - total_credit (tính từ ngày chốt số dư)

Mỗi nghiệp vụ được ghi nhận trong hệ thống sẽ bao gồm các thông tin:
-	Tài khoản Credit
-	Tài khoản Debit
-	Số tiền
-	Thời gian ghi nhận

Các nghiệp vụ được mô tả bao gồm
-	Nạp tiền
-	Giao dịch không phí với số dư trong hệ thống
-	Giao dịch có phí với số dư ngoài hệ thống

##### Deposit

-	Ngày 02/09/2020, khách hàng A nạp vào hệ thống 1.000.000. 
-	Hệ thống thực hiện ghi có cho tài khoản A số tiền 1.000.000 và ghi nợ vào tài khoản CASH của ví số tiền 1.000.000
-	Thông tin trạng thái tài khoản:

  ![image-20210113145110846](https://github.com/LouisVu84/DevOps/blob/master/Documents/Fintech/image-20210113145110846.png)
  
- Sổ cái ghi nhận:

  ![image-20210113145129368](https://github.com/LouisVu84/DevOps/blob/master/Documents/Fintech/image-20210113145129368.png)  

##### Internal payment without fee

- Ngày 05/09/2020, khách hàng A thực hiện thanh toán hóa đơn mệnh giá 200.000.
- Hệ thống thực hiện ghi nợ vào tài khoản A 200.000 và ghi có vào tài khoản CASH 200.000
- Hệ thống thực hiện ghi nợ vào tài khoản CASH 200.000 và ghi có vào tài khoản PAYMENT của ví 200.000

  ![image-20210113145156821](https://github.com/LouisVu84/DevOps/blob/master/Documents/Fintech/image-20210113145156821.png)
  
- Sổ cái ghi nhận:

  ![image-20210113145242622](https://github.com/LouisVu84/DevOps/blob/master/Documents/Fintech/image-20210113145242622.png)
  

##### External payment with fee

- Ngày 07/09/2020, khách hàng B thực hiện mua hàng mệnh giá 300.000, hệ thống thực hiện thu phí 10.000 thông qua tài khoản liên kết ngân hàng
- Hệ thống thực hiện ghi có cho tài khoản B số tiền 310.000 và ghi nợ vào tài khoản CASH của ví số tiền 310.000
- Hệ thống thực hiện ghi nợ vào tài khoản B 300.000 và ghi có vào tài khoản CASH 300.000, ghi có vào tài khoản FEE 10.000
- Hệ thống thực hiện ghi nợ vào tài khoản CASH 300.000 và ghi có vào tài khoản PAYMENT 300.000

  ![image-20210113145251585](https://github.com/LouisVu84/DevOps/blob/master/Documents/Fintech/image-20210113145251585.png)
  
- Sổ cái ghi nhận:

  ![image-20210113145259537](https://github.com/LouisVu84/DevOps/blob/master/Documents/Fintech/image-20210113145259537.png)
  

### BUSINESS FLOW

-	Nội dung trong file [Flow](https://github.com/LouisVu84/DevOps/blob/master/Documents/Fintech/DE.pdf)
