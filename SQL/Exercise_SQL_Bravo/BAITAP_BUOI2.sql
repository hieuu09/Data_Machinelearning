-- Phan Trung Hiếu
-- Học Viện Tài Chính 
-- Bài tập ngày 26/12/2022
-- bài tập buổi 3
DROP DATABASE BaiTap1312
GO
USE MASTER
GO

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




-- Bài 1 : hiển thị thôn gtin sô chứng từ , ngày chúng từ , mã vật tư , tên vật tư số lương

SELECT CT.Soct, CT.Ngayct, DMVT.Mavt, DMVT.Tenvt, CTCT.Soluong FROM CT 
	INNER JOIN CTCT ON ct.soct = ctct.soct
	INNER JOIN DMVT ON CTCT.Mavt = DMVT.Mavt
-- các trường tự sinh ko viet vào, số CT lây dâu cũng dc , mavt lấy 
-- inner join lấy đâu cũng dc , left join , right join thì cần quan tâm đến bên nào 


-- Bài 2 : hiển thị thông tin ngày xuất gần nhất của  vật tư nhập
-- k outer appline  thi xuaat hien ra nhieu lan, ngày xuất nhỏ hơn ngày nhập có nghĩa vừa nhập, vật này nhập ngày bao nhiêu mà đã phải nhập rôii
SELECT   Ngayct AS Ngay_Nhap,CTCT.Mavt ,Xuat.Ngay_Xuat 
FROM CT INNER JOIN CTCT ON CT.Soct = CTCT.Soct 
	OUTER APPLY( SELECT TOP 1 Chungtu.Ngayct AS Ngay_xuat, Chitiet1.MaVT
				   FROM CT AS Chungtu INNER JOIN ctct AS chitiet1 ON Chungtu.soct=chitiet1.Soct
				   WHERE chungtu.Loaict = 1 AND chitiet1.Mavt = ctct.Mavt AND Chungtu.Ngayct < Ct.Ngayct
				   ORDER BY chungtu.Ngayct DESC ) AS xuat
WHERE CT.Loaict =0
ORDER BY ctct.Mavt

--SELECT DISTINCT Mavt , CT.NgayCT AS NgayNhap,NULL AS ngayxuat FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SOCT  WHERE CT.LoaiCT = 0
--UNION ALL
--SELECT DISTINCT Mavt , NULL AS NgayNhap, CT.NgayCT AS ngayxuat FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SOCT  WHERE CT.LoaiCT = 1


-- chính xác ngày xuất lớn hơn ngày nhập, ngày xuất xa nhất so với vật tư nhập
SELECT  NgayCT AS [Ngaynhap],CTCT.MaVT ,Xuat.ngayxuat --, Xuat.NgayXuat
FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SOCT
	OUTER APPLY (
					SELECT TOP 1 Chungtu.NgayCT AS Ngayxuat, Chitiet.MaVT 
					FROM CT AS Chungtu INNER JOIN CTCT AS chitiet ON Chungtu.soct = Chitiet.SoCT
					WHERE Chungtu.loaiCT = 1 AND Chitiet.MaVT = CTCT.MaVT AND Chungtu.NgayCT > CT.NgayCT
					ORDER BY Chungtu.NgayCT DESC -- Ngay xuất xa nhất với vật tư nhập và gần nhất với ngày hiện tài 
				--  ORDER BY Chungtu.NgayCT ASC -- Ngay xuaats gần nhất so với vật tư vừa nhập, nhưng xa nhất với thời gian hiện tại 
				) Xuat
WHERE CT.LoaiCT = 0
ORDER BY CTCT.MaVT
--subquery : lay 1 ngay xuat , tu 2 bang ct vs ctct

-- subquery tra e 1 bang long , hoan toan cos the join voi nhau

--Bài 3: Hiển thị dữ liệu mavt, ngayct,slnhap,slxuat: xuất 1 , nhập 0
-- trong ngày lập chứng từ có thể xuất hoặc nhập
-- nên  viêt kiểu này
SELECT DMVT.Mavt,CT.NgayCT ,
	CASE WHEN CT.LoaiCT=1 THEN CTCT.SoLuong ELSE 0 END AS [Số lượng xuất ],
	CASE WHEN CT.LoaiCT = 0 THEN CTCT.SoLuong ELSE 0 END  AS [Số lượng nhập]
FROM DMVT
	INNER JOIN CTCT ON DMVT.Mavt = CTCT.Mavt
	INNER JOIN CT ON CTCT.SoCT = CT.SoCT


/*case 
	when dk then kq 
	else kq2
	end as [alias] */

-- viết dạng động , nên rất dễ bị hach , sql ịnjection


DECLARE @_StrExec NVARCHAR(1000)
SET @_StrExec ='SELECT *FROM Dmvt'
EXEC(@_StrExec)
-- 

--; la ngay cau lenhj
DECLARE @_StrExec NVARCHAR(1000) ,@_Tenbang NVARCHAR(32)='DMVT; DROP TABLE'
@_Password NVARCHAR(32) 


-- ham sp_executesql @SteExec.'DECLARE @_ ', danh sach bien truyen vao
-- input truyen vao ben trong de xu li , output tra ve bien ben ngoai

--gan bang chuoi , cong them 1 bien bang chuoi bien admin , sau thAY BIEN Amin , 2 nhay vao sql bien thanh 1 nhay
-- trc dau cong cos 1 dau nhay
-- vt='ao1' EXEC('select *from dmvt where ma_vt=''A01''')
-- de bij pha  du lieu , trunscate , delete de bi nguy hien loi he thong 
-- > nen dung sp_executesql

-- round(X,n)  so X lam tron , n chu so tinh tu so thap phan 
-- power(x,y) x luy thua cua y
--square(x) binh phuong cua x
-- sqrt(x) can bac 2 cua x
-- abs(x) gia tri tuyet doi cua x 
-- floor(x) lam tron xuong phan nguyen gia tri x
-- ceiling(x) lamtron len phan nguyen gia tri x , thap phan
--A%B lay so du chia A/b
-- sign(x) tra ve kieu so x ( so thap phan) va gia tri 1 so duong, 0 so , 1 so am
-- rand(@_x) tra ve so ngau nhien cho bien @_x 
--select exp(1) gia tri ccua e
--charindex  tim kiem 1 anh nao do , co rat nhieu vi tri 
-- phan birt hoa thường :PATTINDEX('%ba','fdsfd')
-- ko cos ham tìm tư bên phải nên phải đảo ngược để tìm kiêma
select ASCII('c') -- lay vi tri unicode so bao nhieu , unicode


-- "chuoi1"+"chuoi2" noi chuoi bang toan tu cong
-- space(n) cha ve chuoi co n khoang trang 
declare @_strexec nvarchar(1000)='   phan anm'
set @_strexec = rtrim(@_strexec)
select @_strexec

declare @_strexec nvarchar(1000), @_tenbang nvarchar(32),
@_password nvarchar(32)='12432; drop table user',@_userName nvarchar(32)='admin'

set @_StrExec N'Select *from dmvt where tenvt like N'+ CHAR(39) + N'%Liệu%' + CHAR(39)
Print(@_Strexec)
EXEC(@_Strexec)
EXECUTE(@_Strexec


-- Bài 1 : Hiện thông tin : Bảng chi tiết chứng từ với những vật tư có sô lượng không phải là số nguyên
-- kho ham floor(x) lam tron xuong neu la so nguyen thi nó ẽ khong bi lam tron , thi sẽ bằng nhau

SELECT soct , mavt, soluong, dongia, tien FROM CTCT WHERE FLOOR(soluong) != soluong
SELECT soct, mavt, soluong, dongia, tien FROM CTCT WHERE CEILING(soluong) <> soluong

-- Bài 2 : Hiện thị mavt, mavt đầy đủ ( có dấu gạch ngang là tên vật tư ) 
--và độ rộng của mã vật tư đầy đủ ( mã vật tư đó có bao nhiêu kí tự)
	
SELECT mavt, mavt+ N'-' + tenvt,LEN(Mavt+N'-'+TenVT) AS [Độ rộng mã vật tư đầy đủ] FROM DMVT


-- Bài 3:Cho 1 chuỗi họ và tên : Viết scirt T-SQL Để lấy tên đệm, tên , họ
-- charindex(chuoi1,chuoi2,a) tim vi tri chuoi1 , trong chuoi 2 tu vi tri a
-- substring(chuoi1,a,b) lay tu chuoi 1 , tu vi tri , so ki tu
-- ý tưởng tách khoảng trắng hai đầu lọc họ va , tên , len(chuỗi)-(len(ho)+len(ten))

DECLARE @chuoi NVARCHAR(100)= N'Phan Trung Hiếu'
DECLARE @ho nvarchar(10), @hodem NVARCHAR(30) , @ten NVARCHAR(10);
SET @ho = LEFT(@chuoi, CHARINDEX(' ',@chuoi,1)-1)
SET @ten = RIGHT(@chuoi,CHARINDEX(' ',REVERSE(@Chuoi),1)-1)
SET @hodem = SUBSTRING(@chuoi, CHARINDEX(' ',@chuoi,1)+1, LEN(@chuoi)-LEN(@ho)- LEN(@Ten)-2)

SELECT @ho AS [Họ] ,@Hodem AS [Họ đệm là] ,@ten AS [Tên là]
-- Bài 4 : Cho chuỗi @_A cắt kí tự chuỗi @_A để hiện thị dữ liệu theo từng dòng 
DECLARE @_A NVARCHAR(32); SELECT @_A=N'Bố,Mẹ,Anh,Chị' -- cắt ký tự ( không dùng vòng lặp)
DECLARE @EXEC NVARCHAR(1000)
SET @EXEC =N'PRINT(N'''+REPLACE(@_A,',',N''');PRINT(N''')+N''')'
PRINT @EXEC
EXEC (@EXEC)


-- Bài 5: Hiện thị DMVT mà có tên vật tư trong chuỗi danh sách @_List_Ten_VT='sắt, nhôm, đồng'

DECLARE @_List_Ten_VT nvarchar(50) =N'sắt, nhôm, đồng'
DECLARE @chuoi NVARCHAR(1000)
SET @chuoi = N'SELECT Mavt, Tenvt ,DVT, LoaiVT, DinhChi FROM DMVT 
			WHERE Tenvt=N'''+REPLACE(@_list_ten_vt,', ',N''' OR TenVT=N''' )+''' '
EXEC (@chuoi)

-- bài 6: cho 1 chuỗi cách nhau nhiều dấu cách :"Nguyễn   du   Thúy  Kiều" Viết câu lệnh sql để chuẩn lại chuỗi này 
-- các từ cách nhau 1 dấu cách ( Lưu ý : không dùng vòng lặp )

DECLARE @Chuoi NVARCHAR(50) = N'Nguyễn   du   Thúy    Kiều'

SET @chuoi = REPLACE(@chuoi, CHAR(32), '<>')
SET @chuoi = REPLACE(@chuoi, '><','')
SET @chuoi = REPLACE(@chuoi, '<>',CHAR(32))
print @chuoi

-- Bài 7 : Hiển thị kí tự đầu tiên của từng chữ viết hoa và kí tự khác viết thường trong chuỗi tên
-- "Hải hòa vinH lệ nguyên quang' ( lưu ý không dùng vòng lặp)
DECLARE @Chuoi NVARCHAR(100) = N'Hải hòa vinH lệ nguyên quang'
SET @chuoi =LOWER(@chuoi)
SELECT *,STUFF(VALUE,1,1,UPPER(LEFT(VALUE,1))) FROM STRING_SPLIT(@chuoi,' ')

