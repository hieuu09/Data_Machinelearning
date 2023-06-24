-- Phan Trung Hiếu
-- Bài tập 13/04/2023

CREATE DATABASE Fast_1304
GO
USE Fast_1304
GO
CREATE TABLE NCC
(
	Manhacc VARCHAR(10) PRIMARY KEY,
	Tennhacc NVARCHAR(50),
	Diachi NVARCHAR(100),
	Sodt VARCHAR(15),
	Masothue VARCHAR(15),
)
CREATE TABLE LDV
(
	Maloaidv VARCHAR(10) PRIMARY KEY,
	Tenloaidv NVARCHAR(50),
)
CREATE TABLE MP 
(
	MaMP VARCHAR(10) PRIMARY KEY,
	Dongia NUMERIC(18,3),
	Mota NVARCHAR(100),
)

CREATE TABLE Xe
(
	Dongxe VARCHAR(20) PRIMARY KEY,
	Hangxe VARCHAR(20),
	sochongoi INT
)
CREATE TABLE DKCC
(
	MaDKCC VARCHAR(20),
	Manhacc VARCHAR(10) NOT NULL,
	Maloaidv VARCHAR(10) NOT NULL,
	Dongxe VARCHAR(20) NOT NULL,
	MaMP VARCHAR(10) NOT NULL,
	Ngaybatdaucc DATE,
	Ngayketthuccc DATE,
	soluongxedk INT

)
-- tạo khóa ngoại
ALTER TABLE DKCC ADD CONSTRAINT FK_DKCC_NCC FOREIGN KEY(manhacc) REFERENCES NCC(Manhacc)
ALTER TABLE DKCC ADD CONSTRAINT FK_LDV_NCC FOREIGN KEY(Maloaidv) REFERENCES LDV(Maloaidv)
ALTER TABLE DKCC ADD CONSTRAINT FK_Mucphi_NCC FOREIGN KEY(MaMP) REFERENCES MP(MaMP)
ALTER TABLE DKCC ADD CONSTRAINT FK_Dongxe_NCC FOREIGN KEY(Dongxe) REFERENCES Xe(Dongxe)

-- Nhà cung cấp
INSERT INTO NCC VALUES 
('NCC001',N'Cty TNHH Toàn Pháp',N'Hai Chau','0511399988',5689411),
('NCC002',N'Cty TNHH Đông Du',N'Lien Chieu','0511399988',5689412),
('NCC003',N'Cty TNHH DTD',N'Ha Noi','0511399988',568947),
('NCC004',N'Cty TNHH Toàn Cầu Xanh',N'Hai Chau','0511399988',5689416),
('NCC005',N'Cty TNHH AMA',N'Lien Chieu','0511399988',5689418),
('NCC006',N'Cty TNHH BV',N'Hoa Thuan','0511399988',5689419),
('NCC007',N'Cty TNHH PT',N'Hai Chau','0511399988',5689410),
('NCC008',N'Cty TNHH PDT',N'Lien Chieu','0511399988',5689415),
('NCC009',N'Cty TNHH Đông Nam Á',N'Hoa Thuan','0511399988',5689414),
('NCC010',N'Cty TNHH Rạng Đông',N'Hai Chau','0511399988',5689413);
GO
-- Loại dịch vụ
INSERT INTO LDV VALUES
('DV01',N'Dịch vụ xe taxi'),
('DV02',N'Dịch vụ xe buyst công cộng theo tuyến cố định'),
('DV03',N'Dịch vụ xe cho thuê theo hợp đồng');
GO
-- Mã phí
INSERT INTO MP VALUES
('MP01',10000,N'Áp dụng từ 1/2015'),
('MP02',15000,N'Áp dụng từ 2/2015'),
('MP03',20000,N'Áp dụng từ 1/2010'),
('MP04',25000,N'Áp dụng từ 2/2011');
GO
-- Thông tin xe

INSERT INTO XE VALUES 
('Hiace','Toyota',16),
('Vios','Toyota',5),
('Escape','Ford',5),
('Cerato','KIA',7),
('Forte','KIA',5),
('Starex','Huyndai',7),
('Grand-i10','Huyndai',7);
GO

-- Đăng kí cung cấp
INSERT INTO DKCC VALUES  
('DK001','NCC001','DV01','Hiace','MP01','2015-11-20','2016-11-20',4),
('DK002','NCC002','DV02','Vios','MP02','2015-11-20','2017-11-20',3),
('DK003','NCC003','DV03','Escape','MP03','2017-11-20','2018-11-20',5),
('DK004','NCC005','DV01','Cerato','MP04','2015-11-20','2019-11-20',7),
('DK005','NCC002','DV02','Forte','MP03','2019-11-20','2019-11-20',1),
('DK006','NCC004','DV03','Starex','MP04','2016-11-10','2021-11-20',2),
('DK007','NCC005','DV01','Cerato','MP03','2015-11-30','2016-01-25',8),
('DK008','NCC006','DV01','Vios','MP02','2016-02-28','2016-08-15',9),
('DK009','NCC005','DV03','Grand-i10','MP02','2016-04-27','2017-04-30',10),
('DK010','NCC006','DV01','Forte','MP02','2015-11-21','2016-02-22',4),
('DK011','NCC007','DV01','Forte','MP01','2016-12-25','2017-02-20',5),
('DK012','NCC007','DV03','Cerato','MP01','2016-04-04','2017-12-20',6),
('DK013','NCC003','DV02','Cerato','MP01','2015-12-21','2016-12-21',8),
('DK014','NCC008','DV02','Cerato','MP01','2016-05-20','2016-12-30',1),
('DK015','NCC003','DV01','Hiace','MP02','2018-04-20','2019-11-20',6),
('DK016','NCC001','DV03','Grand-i10','MP02','2015-06-22','2016-12-21',8),
('DK017','NCC002','DV03','Cerato','MP03','2016-09-30','2019-09-30',4),
('DK018','NCC008','DV03','Escape','MP04','2017-12-13','2018-09-30',2),
('DK019','NCC003','DV03','Escape','MP03','2016-01-24','2016-12-30',8),
('DK020','NCC002','DV03','Cerato','MP04','2016-05-03','2017-10-21',7),
('DK021','NCC006','DV01','Forte','MP02','2015-01-30','2016-12-30',9),
('DK022','NCC002','DV02','Cerato','MP04','2016-07-25','2017-12-30',6),
('DK023','NCC002','DV01','Forte','MP03','2017-11-30','2018-05-20',5),
('DK024','NCC003','DV03','Forte','MP04','2017-12-23','2019-11-30',8),
('DK025','NCC003','DV03','Hiace','MP02','2016-08-24','2017-10-25',1);
GO

TRUNCATE TABLE DKCC

-- Câu 3: Liệt kê những dòng xe có số chỗ ngồi trên 5 chỗ
SELECT Dongxe, Hangxe, Sochongoi FROM Xe
WHERE sochongoi > 5
/* Câu 4: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp những dòng xe
thuộc hãng xe “Toyota” với mức phí có đơn giá là 15.000 VNĐ/km hoặc những dòng xe thuộc hãng xe “KIA” với mức phí có đơn giá là 20.000 VNĐ/km */

SELECT DISTINCT NCC.Manhacc, NCC.Tennhacc, NCC.Diachi, NCC.Sodt, NCC.masothue
FROM NCC INNER JOIN DKCC ON NCC.Manhacc = DKCC.manhacc
		 INNER JOIN XE ON DKCC.Dongxe = Xe.Dongxe
		 INNER JOIN MP ON MP.MaMP = DKCC.MaMP
WHERE (Xe.Hangxe LIKE '%Toyota%' AND MP.Dongia = 15000) OR (Xe.Hangxe LIKE '%Kia%' AND MP.Dongia = 20000)

/*Câu 5: Liệt kê thông tin toàn bộ nhà cung cấp được sắp xếp tăng dần theo tên nhà cung cấp và giảm dần theo mã số thuế */
SELECT NCC.Manhacc, NCC.Tennhacc, NCC.Diachi, NCC.Sodt, NCC.Masothue
FROM NCC
ORDER BY NCC.Tennhacc ASC, NCC.masothue DESC

/*Câu 6: Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với yêu cầu chỉ 
đếm cho những nhà cung cấp thực hiện đăng ký cung cấp có ngày bắt đầu
cung cấp là “20/11/2015”*/

DECLARE @_ngaybd DATE
SET @_ngaybd ='2015/11/20'

SELECT NCC.Manhacc, COUNT(DKCC.Manhacc) AS SolanDKxe
FROM NCC INNER JOIN DKCC ON NCC.Manhacc= DKCC.Manhacc
WHERE DKCC.Ngaybatdaucc = @_ngaybd
GROUP BY NCC.Manhacc

/*Câu 7: Liệt kê tên của toàn bộ các hãng xe có trong cơ sở dữ liệu với yêu cầu mỗi hãng xe chỉ được liệt kê một lần */

SELECT Hangxe FROM Xe GROUP BY Hangxe

/*Câu 8: Liệt kê MaDKCC, MaNhaCC, TenNhaCC, DiaChi, MaSoThue, TenLoaiDV, DonGia, HangXe, NgayBatDauCC, NgayKetThucCC của tất cả các lần đăng ký cung cấp phương
tiện với yêu cầu những nhà cung cấp nào chưa từng thực hiện đăng ký cung cấp phương tiện thì cũng liệt kê thông tin những nhà cung cấp đó ra */

SELECT DKCC.MaDKCC, NCC.Manhacc, NCC.tennhacc, NCC.Diachi, NCC.Masothue, LDV.TenloaiDV, MP.Dongia, Xe.Hangxe, DKCC.Ngaybatdaucc, DKCC.Ngayketthuccc
FROM NCC LEFT JOIN DKCC ON NCC.Manhacc = DKCC.Manhacc
		 LEFT JOIN LDV ON LDV.MaloaiDV = DKCC.MaloaiDV
		 LEFT JOIN MP ON MP.MaMP = DKCC.MaMP
		 LEFT JOIN Xe ON Xe.Dongxe = DKCC.Dongxe

/*Câu 9: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện thuộc dòng xe “Hiace” hoặc từng đăng ký cung cấp phương tiện thuộc dòng xe “Cerato” */

SELECT DISTINCT NCC.Manhacc, NCC.tennhacc, NCC.Diachi, NCC.Masothue
FROM NCC INNER JOIN DKCC ON NCC.Manhacc = DKCC.Manhacc
		 INNER JOIN Xe ON xe.Dongxe = DKCC.Dongxe
WHERE Xe.Dongxe LIKE '%Hiace%' OR Xe.Dongxe LIKE '%Cerato%'

/*Câu 10: Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp sphương tiện lần nào cả */

SELECT NCC.Manhacc, NCC.tennhacc, NCC.Diachi, NCC.Masothue
FROM NCC LEFT JOIN DKCC ON DKCC.Manhacc = NCC.Manhacc
WHERE DKCC.Manhacc IS NULL

/*Câu 11: Liệt kê thông tin các NCC đã từng đăng kí cung cấp phương tiện thuộc dòng xe
""Hiace" OR từng đăng kí cung cấp phương tiện thuộc dòng xe "Cerato"*/

SELECT DISTINCT NCC.Manhacc, NCC.tennhacc, NCC.Diachi, NCC.Masothue
FROM NCC INNER JOIN DKCC ON DKCC.Manhacc = NCC.Manhacc
		 INNER JOIN Xe ON XE.dongxe = DKCC.dongxe
WHERE xe.dongxe LIKE '%Hiace%' OR xe.Dongxe LIKE '%Cerato%'

/*Câu 12: Liệt kê thông tin các NCC chưa từng đăng kí cung cấp phương tiện lần nào cả*/

SELECT NCC.Manhacc, NCC.tennhacc, NCC.Diachi, NCC.Masothue
FROM NCC LEFT JOIN DKCC ON DKCC.Manhacc = NCC.Manhacc
WHERE DKCC.Manhacc IS NULL

/*Câu 13: Liệt kê thông tin các NCC đã từng đăng kí cung cấp phương tiện thuộc dòng xe
""Hiace" và chưa từng đăng kí cung cấp phương tiện thuộc dòng xe "Cerato"*/

SELECT DISTINCT NCC.Manhacc, NCC.tennhacc, NCC.Diachi, NCC.Masothue
FROM NCC INNER JOIN DKCC ON DKCC.Manhacc = NCC.Manhacc
		 INNER JOIN Xe ON XE.dongxe = DKCC.dongxe
WHERE xe.dongxe LIKE '%Hiace%' AND xe.Dongxe NOT LIKE '%Cerato%'

/*Câu 14 Liệt kê thông tin của những dòng xe chưa đc NCC đăng kí cho thuê lần nào vào năm 2015
 nhưng đã từng được đăng kí co thuê vào năm 2016*/

 DECLARE @_namdcdk INT, @_daunamdk DATE, @_cuoinamdk DATE
 SET @_namdcdk = 2016
 SET @_daunamdk = DATEADD(YY, @_namdcdk-1900, 0)
 SET @_cuoinamdk = DATEADD(DD,  -1 , DATEADD(YY, 1, @_daunamdk))

 DECLARE @_namkodcdk INT, @_daunamkodk DATE, @_cuoinamkodk DATE
 SET @_namkodcdk = 2015
 SET @_daunamkodk = DATEADD(YY, @_namkodcdk-1900, 0)
 SET @_cuoinamkodk = DATEADD(DD, -1, DATEADD(YY, 1, @_daunamkodk))

 SELECT DISTINCT NCC.Manhacc, NCC.tennhacc, NCC.Diachi, NCC.Masothue
FROM NCC INNER JOIN DKCC ON DKCC.Manhacc = NCC.Manhacc
		 INNER JOIN Xe ON XE.dongxe = DKCC.dongxe
WHERE (DKCC.Ngaybatdaucc BETWEEN @_daunamdk AND @_cuoinamdk)
		AND (DKCC.Ngaybatdaucc  NOT BETWEEN @_daunamkodk AND @_cuoinamkodk)



/*Câu 15 Hiện thị TT của những dòng xe có số lần được đăng kí cho thuê nhiều nhất tính từ đầu năm 2016 đến hết năm 2019*/
 DECLARE @_tunam INT, @_dtunam DATE, @_cuoinam INT, @_dcuoinam DATE
 SET @_tunam = 2016
 SET @_cuoinam = 2019
 SET @_dtunam = DATEADD(YY, @_tunam -1900, 0)
 SET @_dcuoinam = DATEADD(DD, -1, DATEADD(YY, @_cuoinam - 1900 +1, 0))

SELECT Xe.dongxe,  COUNT(Xe.dongxe) AS solandk, AA.slmax FROM Xe 
		INNER JOIN DKCC ON DKCC.Dongxe= xe.dongxe
CROSS JOIN (
		SELECT TOP 1 COUNT(Xe.dongxe) AS slmax FROM Xe
			INNER JOIN DKCC ON DKCC.Dongxe= xe.dongxe
		WHERE DKCC.Ngaybatdaucc BETWEEN @_dtunam AND @_dcuoinam
		GROUP BY Xe.dongxe
		ORDER BY slmax DESC	) AS AA
WHERE DKCC.Ngaybatdaucc BETWEEN @_dtunam AND  @_dcuoinam
GROUP BY Xe.Dongxe , slmax
HAVING COUNT(Xe.dongxe) = slmax


/*Câu 16: Tính tống số lượng xe đã được đăng kí cho thuê tương ứng với từng dòng xe với yêu cầu chỉ thực hiện tính với nhwuxng lần đăng kí cho thuê
có mức phí với đơn giá là 20000 VND trên 1km*/

SELECT Xe.dongxe , SUM(DKCC.Soluongxedk) AS Tongslxe
FROM Xe INNER JOIN DKCC ON DKCC.Dongxe = Xe.Dongxe
	    INNER JOIN MP ON MP.MaMP = DKCC.MaMP
WHERE Mp.Dongia > 20000
GROUP BY Xe.dongxe
