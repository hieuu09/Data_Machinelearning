-- Phan Trung Hiếu
-- Học Viện Tài Chính 
-- Bài tập ngày 26/12/2022
-- bài tập buổi 3

CREATE DATABASE BAITAP_BUOI3
GO
USE BAITAP_BUOI3
GO
drop database BAITAP_BUOI3

CREATE TABLE DMVT
(
	Mavt nvarchar(16) primary key, --ma vat tu
	Tenvt nvarchar(96), --ten vật tư
	DVT nvarchar(10),-- đơn vị tính
	LoaiVT int,	-- Loai vật tư
	DinhChi int  -- Trạng thía
)
-- tao bang danh muc doi tuong
CREATE TABLE DMDT
(
	Madt NVARCHAR(16) not null,
	Tendt NVARCHAR(96),
	Diachi NVARCHAR(192),
	Loaidt INT,		--Loại đối tượng , khách hàng , nhà cung cấp, nhân viên
	dinhchi INT,	-- trạng thái
	Ngaybd DATETIME,  -- Ngày bắt đầu
	ngaykt DATETIME	-- Ngày kết thúc
)
ALTER TABLE DMDT ADD PRIMARY KEY(Madt) 
--tao chung tu
CREATE TABLE CT
(
	soct NVARCHAR(10) PRIMARY KEY,  -- số chưng từ làm khóa chính
	Ngayct DATETIME,
	madt NVARCHAR(16) not null,
	loaict INT,	-- Loại chứng từ
	Diengiai NVARCHAR(256),  -- Diễn giải
	Dinhchi INT -- Trạng thái
)
ALTER TABLE CT ADD CONSTRAINT FK_Chungtu_DMDT FOREIGN KEY(madt) REFERENCES DMDT(Madt)
-- tao chung tu chi tiet
CREATE TABLE CTCT
(
	Soct NVARCHAR(10) not null,  -- so chungws tu 
	Mavt NVARCHAR(16) not null,  -- tao ma vat tu
	soluong NUMERIC(15,3), -- Số lượng vật tư
	Dongia NUMERIC(15,5), -- đơn giá vật tư
	Tien NUMERIC(18,2)		-- loại tiền tệ 
)
ALTER TABLE CTCT ADD CONSTRAINT FK_Chungtu_ct  FOREIGN KEY(Soct)  REFERENCES CT(soct)

ALTER TABLE CTCT ADD CONSTRAINT FK_Chung_DMVT  FOREIGN KEY(Mavt)  REFERENCES DMVT(Mavt)

-- bang ton dau ki 
CREATE TABLE TONDAU
(
	Mavt NVARCHAR(16) not null,
	Soluong NUMERIC(15,3),
	Tien NUMERIC(18,2)	
)
ALTER TABLE TONDAU ADD CONSTRAINT FKTondk_dmvt FOREIGN KEY(mavt) REFERENCES DMVT(mavt)


-- Nhập DMVDT DMVT >Tondau > Nhập các trường có khóa chính trước mới nhập các bảng có khóa ngoai
-- nếu ko sẽ báo lỗi 

INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB788','11-12-2022',N'TK001',1,N'Hangd mua nước ngoài',1)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB789','11-19-2022',N'TK002',1,N'Hàng xuất khẩu sang mĩ',0)
GO
--
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB799','11-10-2020',N'TK002',0,N'Hàng xuất khẩu sang mĩ',0)
GO
--
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB790','12-20-2023',N'TK003',0,N'Hàng xuất khẩu nước anh',1)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB791','11-20-2022',N'TK004',0,N'Thiết bị công nghệ',1)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB792','12-19-2022',N'TK005',0,N'Phần mềm kế toán doanh thu',1)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB793','12-22-2022',N'TK007',0,N'Phần mềm vật tư',0)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB794','10-20-2022',N'TK007',0,N'Vật tư',1)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB795','11-19-2022',N'TK007',0,N'Phần mềm vật tư',0)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB796','10-20-2021',N'TK006',1,N'Vật tư',1)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB797','11-19-2020',N'TK007',1,N'Phần mềm vật tư',0)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB798','12-31-2022',N'TK005',1,N'Phaan mem ',1)
GO

INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB801','12-24-2022',N'TK004',1,N'Xuat vat tu',1)
GO
INSERT INTO CT(Soct, Ngayct, MaDt, Loaict, Diengiai, dinhchi)
VALUES(N'KB800','12-26-2022',N'TK005',1,N'Xuat vat tu thep',1)
GO


--loa
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB788',N'HK9Y356',54345,600003400,6794423443)
GO
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB789',N'HK9Y357',54345,600003400,6794443)
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB790',N'HK9Y359',45000,10000,900003)
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB791',N'HK9Y360',2500,10200,80000)
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB792',N'HK9Y361',4244,2000,7003)
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB793',N'HK9Y362',4532,50000,69893)

INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB794',N'HK9Y356',424,22000,456)
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB795',N'HK9Y357',452,520000,700093)
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB796',N'HK9Y357',452,520000.98,700093.7)
INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB798',N'HK9Y362',780.08,510000,7000998)

INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB799',N'HK9Y362',801.1,560000,9000000)

INSERT INTO CTCT(Soct, Mavt, Soluong, dongia, Tien) 
VALUES(N'KB800',N'HK9Y362',800.9,340000,760000)

select *from dmvt

-- Điền 
INSERT INTO DMDT(madt, Tendt, Diachi, Loaidt, Dinhchi, Ngaybd, Ngaykt)
VALUES(N'TK001',N'hang hoa',N'Thành phố Hà Nội',0,0,'11-12-2020','12-21-2022')
GO
INSERT INTO DMDT(madt, Tendt, Diachi, Loaidt, Dinhchi, Ngaybd, Ngaykt)
VALUES(N'TK002',N'Hàng xách tay',N'Thành phố Hồ Chí Minh',1,1,'08-12-2018','06-21-2021')
GO
INSERT INTO DMDT(madt, Tendt, Diachi, Loaidt, Dinhchi, Ngaybd, Ngaykt)
VALUES(N'TK003',N'Đồ gia dụng',N'Xã thị trấn Nho quan Nam Thành phô',2,1,'1-1-2014','10-29-2017')
GO
INSERT INTO DMDT(madt, Tendt, Diachi, Loaidt, Dinhchi, Ngaybd, Ngaykt)
VALUES(N'TK004',N'Đồ dùng trong nhà',N'Lê Văn Hiến Phường đức thắng quận ',2,0,'09-8-2013','10-5-2018')
GO
INSERT INTO DMDT(madt, Tendt, Diachi, Loaidt, Dinhchi, Ngaybd, Ngaykt)
VALUES(N'TK005',N'Thiet thị trang trí',N'Lê Văn Hiến Phường đức thắng quận ',1,1,'09-09-2014','10-5-2019')
GO
INSERT INTO DMDT(madt, Tendt, Diachi, Loaidt, Dinhchi, Ngaybd, Ngaykt)
VALUES(N'TK006',N'Thiet thị nội thất',N'Trường trinh ',2,1,'12-05-2013','10-9-2021')
GO
INSERT INTO DMDT(madt, Tendt, Diachi, Loaidt, Dinhchi, Ngaybd, Ngaykt)
VALUES(N'TK007',N'Thiet bị phần mềm',N'Thành phố hà nội ',1,0,'09-07-2014','10-5-2020')
GO


-- điền danh mục vaath tư hàng hóa
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y356',N'Nhôm',N'cái',2,1)
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y357',N'Đồng',N'Chiếc',1,0)
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y358',N'Máy thu âm',N'cân',2,1)
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y359',N'Máy nghe nhạc',N'Cái',1,0)
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y360',N'thiết bị',N'Chiếc',2,0)
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y361',N'Màn hinh',N'Cái',0,1)
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y362',N'Máy phát điện',N'Cái',1,0)


INSERT INTO TONDAU(Mavt, Soluong, Tien)
VALUES(N'HK9Y356',9809,900000000)
GO
INSERT INTO TONDAU(Mavt, Soluong, Tien)
VALUES(N'HK9Y357',1000,9003240)
GO
INSERT INTO TONDAU(Mavt, Soluong, Tien)
VALUES(N'HK9Y358',2000,93234000)
GO
INSERT INTO TONDAU(Mavt, Soluong, Tien)
VALUES(N'HK9Y359',4000,100234000)
GO
INSERT INTO TONDAU(Mavt, Soluong, Tien)
VALUES(N'HK9Y360',3500,2000234000)
GO
INSERT INTO TONDAU(Mavt, Soluong, Tien)
VALUES(N'HK9Y361',19000,19000000)
GO
INSERT INTO TONDAU(Mavt, Soluong, Tien)
VALUES(N'HK9Y362',18000,290034000)
GO




-- Bài 1 : Hiện thông tin : Bảng chi tiết chứng từ với những vật tư có sô lượng không phải là số nguyên
-- kho ham floor(x) lam tron xuong neu la so nguyen thi nó ẽ khong bi lam tron , thi sẽ bằng nhau

SELECT soct , mavt, soluong, dongia, tien FROM CTCT WHERE FLOOR(soluong) != soluong
SELECT soct, mavt, soluong, dongia, tien FROM CTCT WHERE CEILING(soluong) <> soluong

SELECT soct, mavt, soluong, dongia, tien FROM CTCT WHERE soluong%1 <> 0
SELECT soct, mavt, soluong, dongia, tien FROM CTCT WHERE soluong- floor(soluong) <>0


/* Bài 2 : Hiện thị mavt, mavt đầy đủ ( có dấu gạch ngang là tên vật tư ) 
	và độ rộng của mã vật tư đầy đủ ( mã vật tư đó có bao nhiêu kí tự) */

SELECT MaVT,Mavt+N'-'+TenVT,LEN(MaVT+N'-'+TenVT) AS DORONG FROM DMVT
SELECT Mavt,MaVT + N'-'+TenVT ,LEN(CONCAT(MaVT,N'-',TenVT)) AS DORONG FROM DMVT	


-- Bài 3:Cho 1 chuỗi họ và tên : Viết scirt T-SQL Để lấy tên đệm, tên , họ
/* charindex(chuoi1,chuoi2,a) tim vi tri chuoi1 , trong chuoi 2 tu vi tri a
   substring(chuoi1,a,b) lay tu chuoi 1 , tu vi tri , so ki tu
   ý tưởng tách khoảng trắng hai đầu lọc họ va , tên , len(chuỗi)-(len(ho)+len(ten)) */

DECLARE @_Chuoiten NVARCHAR(50)=N' Phan Trung Hiếu ';
SET @_Chuoiten = TRIM(@_Chuoiten); 
DECLARE @Chuoinguoc NVARCHAR(50)=REVERSE(@_Chuoiten);
DECLARE @_n int = CHARINDEX(' ',@_Chuoiten,1); 
DECLARE @_z int;
SET @_z = CHARINDEX(' ',@Chuoinguoc,1); 
DECLARE @layho nvarchar(10)= SUBSTRING(@_Chuoiten,1,@_n);
DECLARE @tendem NVARCHAR(50) = SUBSTRING(@_Chuoiten,@_n+1,len(@_Chuoiten)-@_n -@_z) ;
DECLARE @layten nvarchar(10)= REVERSE(SUBSTRING(@Chuoinguoc,1,@_z));

SELECT @Layho AS [Họ] ,@Tendem [Tên đệm], @Layten AS [Tên];

-- Cách 2

DECLARE @_Hoten NVARCHAR(25)=N'Nguyễn Thị Vân nam'
DECLARE @_ho NVARCHAR(6),@_hodem NVARCHAR(20),@_ten NVARCHAR(6)

SET @_ho = LEFT(@_Hoten,CHARINDEX(' ',@_Hoten,1))
SET @_Ten= RIGHT(@_Hoten,CHARINDEX(' ',REVERSE(@_Hoten))-1)
SET @_Hodem = SUBSTRING(@_HoTen,CHARINDEX(' ',@_Hoten)+1,LEN(@_Hoten)-LEN(@_Ho)-LEN(@_Ten)-2)
SELECT @_Ho AS HO, @_Hodem AS HODEM, @_Ten AS TEN


-- lấy ho tìm khoảng tráng lấy vị trí trừ đi 1 , vì nó có 1 khoảng tráng
-- lấy tên đảo ngược chuối tìm khaongr trắng , rồi cắt từ bên phải chuỗi đấy trừ đi 1
-- lấy ho đệm lấy độ dài hoteen - ho - ten - trừ tiếp 2 khoảng trắng 

-- Bài 4 : Cho chuỗi @_A cắt kí tự chuỗi @_A để hiện thị dữ liệu theo từng dòng 
-- cachs 2 N'PRINT(N''' no la 1 chuoi unicode  print(N'' , 2 nhay vao trong chuoi la 1 nhay 
-- 2 nháy vào chuỗi là một nháy , 1 nháy trong là 2 nháy ngoài

DECLARE @_A NVARCHAR(32);SELECT @_A =N'Bố, Mẹ, Anh, Chị'
DECLARE @_ExecStr NVARCHAR(1000)
SET @_ExecStr =N'PRINT(N'''+ REPLACE(@_A,N', ',N''');PRINT(N''') +N''')'
print @_EXECstr
EXEC(@_ExecStr)
-- cach 2 
SET @_ExecStr=N'SELECT N''' +REPLACE(@_A,N',',N''' UNION ALL SELECT N''')+ ''''
EXEC(@_ExecStr)




DECLARE @_A NVARCHAR(32);SELECT @_A =N'Bố, Mẹ, Anh, Chị'
DECLARE @_ExecStr NVARCHAR(1000)
SET @_ExecStr =N'PRINT(N'''+ REPLACE(@_A,N', ',N''');print(N''')+N''')'
print @_EXECstr
EXEC(@_ExecStr)


DECLARE @chuoi NVARCHAR(100)= N'Nguyễn, Thị, Trâm, Anh'
DECLARE @thucthi NVARCHAR(1000)
-- Nó in ra PRINT(N''' thì PRINT(N' cusws sau dấu phẩy nó lai đóng nháy và thêm ngoặc đóng lại tiếp tục PRINT(N''' thì 1 nháy
-- rồi cộng các chữ sau dấu phẩy cứ tiếp tục đến hết rồi N''' thì cộng 1 nháy đóng avf dấu ) để kết thuc , thục hiện như truy vấn bình thương
SET @thucthi = N'PRINT(N'''+REPLACE(@chuoi,', ',N''');PRINT(N''')+N''')'
print @thucthi
EXEC (@thucthi)

select @thucthi
-- Bài 5: Hiện thị DMVT mà có tên vật tư trong chuỗi danh sách @_List_Ten_VT='sắt, nhôm, đồng'

DECLARE @_List_Ten_VT  NVARCHAR(50) = N'Sắt,Nhôm,Đồng'
DECLARE @_ExecStr NVARCHAR(1000)
SET @_ExecStr = N'SELECT MaVt, TenVt, Dvt, LoaiVt, DinhChi FROM DMVT 
				WHERE TenVt = N''' +REPLACE(@_List_Ten_VT, ',',''' OR TenVt = N''')+''''
PRINT(@_ExecStr)
EXEC sp_Executesql @_ExecStr



DECLARE @_List_Ten_VT  NVARCHAR(50) = N'Sắt,Nhôm,Đồng'
DECLARE @_ExecStr NVARCHAR(1000) -- ghi chu Nó in hết xong bắt đầu N''' thành N' + tên Rôi chuyển dấu , thành ''' nháy đóng công hoặc tên vt viết như thường
--rồi nó lại đóng nahy trc chữ hoặc rồi tếp tục cho đên sheets + N''' là đóng nháy cho chuỗi cuối cùng, như câu SELECT bình thường
SET @_ExecStr = N'SELECT * FROM DMVT WHERE TenVt = N''' +REPLACE(@_List_Ten_VT, ',', ''' OR TenVt = N''')+''''
PRINT(@_ExecStr)
EXEC sp_Executesql @_ExecStr


-- ko có chữ N  , '', phải có chữ n in chuỗi cứ có nháy thì phải có chữ N , nếu ko có chữ N nó sẽ lỗi
-- chặn đầu chặn cuối : ngoài chuỗi có 1 nháy thì vào trong chuỗi có 2 nháy , 
-- 2 nháy sql tự biến thành 1 nháy , 3 nháy vì > nhay cuối đóng nháy đầu tiên
-- trc dấu cộng phải có 1 dấu đóng nháy chuỗi trc
-- 2 nháy biến thành 1 nháy, 4 nháy biến thành nháy nháy 2 nháy
-- với mỗi nay đơn , khi sử dụng chuỗi thêm 1 nháy nữa 
-- cộng kí tự đặc biệt thì dùng char , hoặc nchar
-- lưu ý execute , exec: ko nên lạm dụng khó debug , tìm ra lôi khó tìm ra ,dễ bị ịnection


/* bài 6: cho 1 chuỗi cách nhau nhiều dấu cách :"Nguyễn   du   Thúy  Kiều" Viết câu lệnh sql để chuẩn lại chuỗi này 
	 các từ cách nhau 1 dấu cách ( Lưu ý : không dùng vòng lặp ) */

DECLARE @_Ten NVARCHAR(50) = N'  Nguyễn    du  nam Thúy  Kiều'
SET @_ten = REPLACE(@_Ten,CHAR(32),'()') -- thay all khoảng trắng bằng dấu đối 
SET @_Ten = REPLACE(@_Ten,')(','')   -- thay all ko kí tự thành dối > còn 1 cặp đối
SET @_Ten = REPLACE(@_Ten,'()',CHAR(32))   -- thay all khoảng trắng , <>, trường hợp 2 khoảng nó gộp còn 1
SELECT @_Ten AS [Ten]


/* Bài 7 : Hiển thị kí tự đầu tiên của từng chữ viết hoa và kí tự khác viết thường trong chuỗi tên
	"Hải hòa vinH lệ nguyên quang' ( lưu ý không dùng vòng lặp) */
	-- tachs chuỗi
DECLARE @Chuoi NVARCHAR(100) = N'Hải hòa vinH lệ nguyên quang'
select trim(value) AS [cat chuoi] from string_split(@chuoi,' ')
-- string split sẽ trả giá trị về value 

DECLARE @_Str nvarchar(200);
declare @str2 nvarchar(max)=N''
set @_Str=N'Hiếu nguyễn vâN Nam anH hAI'
SET @_Str =LOWER(@_Str) 
print @_Str

--select value from string_split(@_Str,' ')
select *,stuff(value,1,1,upper(left(value,1)))
from string_split(@_Str,' ')


-- ý tưởng cho all chuỗi viết thường , lấy giá trị hàm stuff để thay đổi chữ rồi hàm string_split cắt chuỗi
DECLARE @chuoi nvarchar(200)=N'Nguyễn THỊ Vân ÁnH NguyỄN Thị'
SET @chuoi = LOWER(@chuoi)
select value, stuff(value,1,1,upper(left(value,1))) from string_split(@chuoi,' ')

-- chuỗi 1, chuỗi 2 , chuỗi 3 : thay chuỗi 3 vào chuỗi 2 các khoảng , có chuỗi 2 vào chuỗi 1
select replace('nam nguyen','n','ab')

-- '' ko có kí tự 
-- Hàm ngày tháng năm 
--datename(datepart,date) tra ve  nvarchar
--datepart(datepart,date) int , thành pahanf của ngày giờ tháng năm , h , phút , giấy
-- day , month ,year tra ve kieu int 
SELECT DATEADD(DD,-7,GETDATE()) -- công ngày
--- khoảng cách ngày giây thnasg 
-- khoảng cách giây 
SELECT DATEDIFF(SECOND,'2022-12-24','2022-12-25')

-- 2 HAM NHU NHAO
SELECT GETDATE() AS [NGAYHIEN TAI]
SELECT CURRENT_TIMESTAMP

SELECT YEAR(CURRENT_TIMESTAMP)

SELECT DATEPART(YEAR,CURRENT_TIMESTAMP) AS [NAM ],DATEPART(MONTH,CURRENT_TIMESTAMP) AS [THANG]
,DATEPART(DAY,CURRENT_TIMESTAMP) AS [NGAY],DATEPART(WEEKDAY,CURRENT_TIMESTAMP) AS[THU],
DATEPART(DAYOFYEAR,CURRENT_TIMESTAMP) AS[ NGAY TRONG NAM]

SELECT DATENAME(YEAR,CURRENT_TIMESTAMP) AS [NAM ],DATENAME(MONTH,CURRENT_TIMESTAMP) AS [THANG]
	,DATENAME(DAY,CURRENT_TIMESTAMP) AS [NGAY],DATENAME(WEEKDAY,CURRENT_TIMESTAMP) AS[THU],
	 DATENAME(DAYOFYEAR,CURRENT_TIMESTAMP) AS[ NGAY TRONG NAM]

SELECT CAST(GETDATE() AS NVARCHAR(19) ) AS [NGAYF HIEN TAI]

-- cross apply nó đi lần lượt với các phần tử rtung với nó s 1 3,1 2,1 4> no hiện 9 làn

-- Bài 3: Hiển thị các phiếu bán vào thứ 6 ngày 13
-- dd ngày , dw thứ , mm thấng , qq quý , yy năm , dayofyear ngày trong năm 
SELECT soct, Ngayct, madt, loaict,diengiai, dinhchi FROM CT 
		WHERE Loaict=1 AND DATEPART(DW,Ngayct)=6 AND DATEPART(DD,NgayCT)=13

-- Bài 4 Sử dụng các hàm ngày tháng để hiện thị thông tin của bảng chứng từ 
--thêm cột tháng quý năm được tính từ cột ngày chứng tư
SELECT soct, Ngayct, madt, loaict,diengiai, dinhchi,
	DATEPART(mm,Ngayct) AS [Tháng], DATEPART(QQ,Ngayct) AS Quý, DATEPART(YY,Ngayct) AS NĂM FROM CT 

-- Bài 5: Hiển thị ngày đầu tháng, cuối tháng của ngày hiện tại và hiển thị cùng kỳ năm ngoái của ngày 
-- đầu tháng , cuối tháng vừa tính được 



select datepart(dw,current_timestamp) as Thứ,datepart(dd,current_timestamp) as Ngày,datepart(mm,current_timestamp) as Tháng,
		datepart(qq,current_timestamp) as Quý, datepart(yy,current_timestamp) as Năm ,
		datepart(dayofyear,current_timestamp) as [Ngày trong năm]
