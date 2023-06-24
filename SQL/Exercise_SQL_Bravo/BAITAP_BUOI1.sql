-- Phan Trung Hiếu
-- Học Viện Tài Chính 
-- Bài tập ngày 23/12/2022
-- bài tập buổi 2 
DROP DATABASE BAITAP_BUOI3
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
VALUES(N'HK9Y356',N'Thiết bị phần mềm',N'cái',2,1)
INSERT INTO DMVT(Mavt, Tenvt, DVT, LoaiVT, DinhChi)
VALUES(N'HK9Y357',N'Máy vi tính',N'Chiếc',1,0)
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
-- k outer appline  thi xuaat hien ra nhieu lan
SELECT Ngayct AS Ngay_Nhap,CTCT.Mavt ,Xuat.Ngay_Xuat 
FROM CT INNER JOIN CTCT ON CT.Soct = CTCT.Soct 
	OUTER APPLY( SELECT TOP 1 Chungtu.Ngayct AS Ngay_xuat
				   FROM CT Chungtu INNER JOIN ctct AS chitiet1 ON Chungtu.soct=chitiet1.Soct
				   WHERE chungtu.Loaict = 1 AND chitiet1.Mavt = ctct.Mavt AND Chungtu.Ngayct < Ct.Ngayct
				   ORDER BY chungtu.Ngayct DESC ) AS xuat
WHERE CT.Loaict =1
ORDER BY ctct.Mavt
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


-- "chuoi1"+"chuoi2" noi chuoi bang toan tu cong
-- space(n) cha ve chuoi co n khoang trang 
declare @_strexec nvarchar(1000)='   phan anm'
set @_strexec = rtrim(@_strexec)
select @_strexec

-- bai tap chuoi 
SELECT *




declare @_strexec nvarchar(1000), @_tenbang nvarchar(32),
@_password nvarchar(32)='12432; drop table user',@_userName nvarchar(32)='admin'

set @_StrExec N'Select *from dmvt where tenvt like N'+ CHAR(39) + N'%Liệu%' + CHAR(39)
Print(@_Strexec)
EXEC(@_Strexec)
EXECUTE(@_Strexec