--Bài 1: Cho cơ sở dũ liệu sau
-- Danh mục khách hàng
IF OBJECT_ID('TempDb..#dmsv') IS NOT NULL DROP TABLE #dmsv
CREATE TABLE #dmsv (
	ma_sv VARCHAR(16),
	ten_sv NVARCHAR(156),
	ngay_sinh SMALLDATETIME,
	gioi_tinh BIT
)

insert into #dmsv values ('SV001', N'Hoàng Tuấn Anh', '19951111', 0)
insert into #dmsv values ('SV003', N'Vũ Đức Chính', '19920115', 1)
insert into #dmsv values ('SV008', N'Bùi Thị Tươi', '19930308', 1)
insert into #dmsv values ('SV011', N'Nguyễn Tiến Đạt', '19981201', 0)
insert into #dmsv values ('SV016', N'Nguyễn Ngọc Kiên', '19940828', NULL)
insert into #dmsv values ('SV022', N'Bùi Viết Xuân', '19970727', NULL)

-- Danh mục sách
IF OBJECT_ID('TempDb..#dmsach') IS NOT NULL DROP TABLE #dmsach
CREATE TABLE #dmsach (
	ma_sach VARCHAR(16),
	ten_sach NVARCHAR(156),
	so_trang_sach INT,
	loai_sach NVARCHAR(10),
	so_luong INT
)

insert into #dmsach values ('Q0001', N'Word', 50, NULL, 10)
insert into #dmsach values ('Q0002', N'Excel', 60, NULL, 20)
insert into #dmsach values ('Q0003', N'Access', 102, NULL, 7)
insert into #dmsach values ('Q0004', N'C programming', 71, NULL, 7)
insert into #dmsach values ('Q0005', N'HTML', 71, NULL, 2)
insert into #dmsach values ('Q0006', N'ASP programming', 50, NULL, 18)
insert into #dmsach values ('Q0007', N'ASP programming', 50, NULL, 18)
insert into #dmsach values ('Q0008', N'ASP programming', 50, NULL, 18)
-- Mượn sách
IF OBJECT_ID('TempDb..#Muon_Sach') IS NOT NULL DROP TABLE #Muon_Sach
CREATE TABLE #Muon_Sach (
	ma_sv VARCHAR(16),
	ma_sach VARCHAR(16),
	ngay_muon SMALLDATETIME
)

insert into #Muon_Sach values ('SV001', 'Q0001', '20220609')
insert into #Muon_Sach values ('SV008', 'Q0001', '20220508')
insert into #Muon_Sach values ('SV003', 'Q0002', '20220428')
insert into #Muon_Sach values ('SV008', 'Q0003', '20220312')
insert into #Muon_Sach values ('SV011', 'Q0003', '20220608')
insert into #Muon_Sach values ('SV008', 'Q0004', '20220906')
insert into #Muon_Sach values ('SV022', 'Q0005', '20220403')
insert into #Muon_Sach values ('SV022', 'Q0006', '20220228')
insert into #Muon_Sach values ('SV016', 'Q0006', '20220131')
insert into #Muon_Sach values ('SV011', 'Q0006', '20220222')
insert into #Muon_Sach values ('SV011', 'Q0003', '20220224')


--Yêu cầu
--(1) Hiện ra tất cả các sách có số lượng trên 50 trang, sắp xếp theo số trang tăng dần và các tên sách.
SELECT S.Ma_Sach, S.Ten_Sach, S.So_trang_Sach
FROM #dmSach AS S 
WHERE S.So_trang_Sach >50
--(2) Hiện ra tên sinh viên đã mượn và tên sách đã mượn
SELECT Sv.Ten_SV, SV.Ma_SV, S.So_luong
FROM #dmsv AS SV INNER JOIN #Muon_sach AS M ON M.Ma_SV = SV.Ma_SV
				 INNER JOIN #dmsach AS S ON S.Ma_Sach = M.Ma_Sach
--(3) Hiện ra tên sinh viên mượn và số sách đã mượn của sinh viên
SELECT SV.Ten_SV, DM.So_Luong
FROM #dmsv AS SV  INNER JOIN #Muon_Sach AS M ON SV.Ma_SV = M.Ma_SV
				  INNER JOIN #dmsach AS dm ON DM.Ma_Sach = M.Ma_Sach
--(4) Hiện ra tất cả những sinh viên có giới tính là null
SELECT SV.Ten_SV, SV.Ma_SV
FROM #DMSV AS SV 
WHERE SV.Gioi_Tinh IS NULL
--(5) Hiện ra tên những quyển sách mà chưa ai mượn
SELECT DM.Ma_Sach, DM.Ten_Sach
FROM #DMSach AS DM LEFT JOIN #Muon_Sach AS M ON M.Ma_Sach = DM.Ma_Sach
WHERE M.Ma_SV IS NULL
--(6) Hiện ra tên, số lần mượn của quyển sách (những quyển sách) được mượn nhiều nhất
SELECT S.Ma_Sach, COUNT(S.Ma_Sach) AS [So lan muon]
FROM #DmSach AS S INNER JOIN #Muon_Sach AS M ON S.Ma_Sach = M.Ma_Sach
GROUP BY S.Ma_Sach
HAVING COUNT(S.Ma_Sach) = 
					
					(SELECT Muon FROM  ( SELECT TOP 1 S.Ma_Sach, COUNT(S.Ma_Sach) AS [Muon]
											  FROM #DMSach AS S INNER JOIN #Muon_Sach AS M ON S.Ma_Sach = M.Ma_Sach
											  GROUP BY S.Ma_Sach
											  ORDER BY [Muon] DESC) AS B)

SELECT ma_sach, COUNT(*) AS SL, b.sl_max 
FROM #Muon_Sach AS A
CROSS JOIN 
		( SELECT TOP 1 COUNT(*) AS SL_Max 
		FROM #Muon_Sach GROUP BY Ma_Sach 
		ORDER BY COUNT(*) DESC ) AS B
GROUP BY a.Ma_Sach, SL_Max
HAVING COUNT(*) = SL_Max


--(7) Hiện ra tên, số lần mượn của những quyển sách được mượn ít nhất 2 lần.
SELECT SV.Ma_SV , COUNT(SV.Ma_SV) AS LanMuon
FROM #dmsv AS SV INNER JOIN #Muon_Sach AS M ON SV.Ma_SV = M.Ma_SV
GROUP BY SV.Ma_SV
HAVING COUNT(SV.Ma_SV) >=2
/*(8) Viết store procduce hiển thị dữ liệu có dạng như sau:
	- Biến truyền vào là tháng: @thang
	- Biến truyền vào là năm: @nam

	|Mã sách          1           2          3			4			5		(đầy đủ các ngày của tháng - năm truyền vào)		       
	|---------------- ---------------------------------------- 
	|Q0001			  Số lượng sách cho mượn tại ngày đó (1 người mượn đc hiểu là mượn 1 quyển)
	|Q0002			  Số lượng sách cho mượn tại ngày đó (1 người mượn đc hiểu là mượn 1 quyển)     
	|Q0003			  Số lượng sách cho mượn tại ngày đó (1 người mượn đc hiểu là mượn 1 quyển)    
	|---------------- ---------------- -------------- -------------- --------------
*/

--Bài 2: Cho cơ sở dũ liệu sau
-- Danh mục khách hàng
IF OBJECT_ID('TempDb..#dmkh') IS NOT NULL DROP TABLE #dmkh
CREATE TABLE #dmkh (
	ma_kh VARCHAR(16),
	ten_kh NVARCHAR(156),
	ma_so_thue VARCHAR(32),
	gioi_tinh INT
)

insert into #dmkh values ('KH001',N'Hoàng Thị Tuyết','0106920494',2)
insert into #dmkh values ('KH002',N'Phạm Anh Tuấn', NULL,1)
insert into #dmkh values ('KH003',N'Vương Thị Thu Trang','',2)
insert into #dmkh values ('KH004',N'Nguyễn Thị Kim Oanh',NULL,2)
insert into #dmkh values ('KH005',N'Nguyễn Ngọc Sơn','0107416392',1)
insert into #dmkh values ('KH006',N'Chu Hoàng Tùng','',1)

--Hóa đơn
IF OBJECT_ID('TempDb..#Hoa_Don') IS NOT NULL DROP TABLE #Hoa_Don
CREATE TABLE #Hoa_Don (
	so_hd CHAR(16),
	ngay_hd SMALLDATETIME,
	ma_kh VARCHAR(16),
	dien_giai NVARCHAR(512),
	tk_no VARCHAR(16),
	tk_co VARCHAR(16),
	tong_tien NUMERIC(19,4)
)

insert into #Hoa_Don values ('HD001','2021/09/20','KH001',N'Bán hàng giảm giá','131111','51111',500000)
insert into #Hoa_Don values ('HD002','2021/12/31','KH002',N'Xuất bán hàng','131111','51111',1000000)
insert into #Hoa_Don values ('HD003','2022/01/21','KH006',N'Bán hàng khuyến mãi','131111','51111',200000)
insert into #Hoa_Don values ('HD004','2022/02/15','KH001',N'Bán hàng giảm giá','131111','51111',750000)
insert into #Hoa_Don values ('HD005','2022/02/18','KH002',N'Bán hàng giảm giá','131111','51111',350000)
insert into #Hoa_Don values ('HD006','2022/02/22','KH005',N'Bán hàng khuyến mãi','131111','51111',600000)

)
/*Yêu cầu: Viết ra báo cáo dạng sau:
	|Số HD           Diễn giải			             Ngày	        Tổng tiền        
	|---------------- ----------------------        ----- -       ------------- 
	|				  KH01 - Khách hàng KH01                            7000
	|HD01			  Số hóa đơn : HD01 (15/01/2017)  15/01/2017        1000 
	|HD02			  Số hóa đơn : HD02 (15/01/2017)  15/01/2017        2000      
	|HD03			  Số hóa đơn : HD03 (17/01/2017)  17/01/2017        4000    
	|				  KH02 - Khách hàng KH02                            8000
	|HD05			  Số hóa đơn : HD05 (15/01/2017)  15/01/2017        1000 
	|HD06			  Số hóa đơn : HD06 (16/01/2017)  16/01/2017        3000      
	|HD07			  Số hóa đơn : HD07 (17/01/2017)  17/01/2017        4000    
	| 				  Tổng cộng			                                15000            
	|---------------- ---------------- -------------- -------------- -------------- ------------
*/

-- Làm thủ tục

CREATE PROCEDURE Bai1 
		@_Tungay DATE,
		@_denngay DATE
AS BEGIN 
		IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1 
		SELECT HD.SO_HD, HD.Dien_Giai, HD.Ngay_HD, ISNULL(HD.Tong_tien, 0) AS Tien, KH.Ma_KH, KH.Ten_KH INTO #bang1
		FROM #dmkh AS KH LEFT JOIN #Hoa_Don AS HD ON HD.Ma_KH= KH.Ma_KH 
		WHERE HD.Ngay_HD BETWEEN @_Tungay AND @_denngay
		--- tính toán
		SELECT '' AS So_HD, N'Tổng Cộng' AS Dien_Giai, NULL AS Ngay, SUM(Tien) AS Tien, 'z' AS Ma_KH
		FROM #bang1
		UNION ALL
		SELECT '' AS [So_HD], #bang1.Ma_KH + ' : '+ #bang1.Ten_KH AS Dien_Giai, NULL AS Ngay, SUM(Tien) AS Tien, Ma_KH
		FROM #bang1
		GROUP BY #bang1.Ten_Kh, #bang1.Ma_KH
		UNION ALL
		SELECT SO_HD, Dien_Giai, Ngay_HD, Tien, Ma_KH
		FROM #bang1
		ORDER BY Ma_KH, SO_HD
END 
GO
EXEC Bai1 '2013-01-01', '2024-01-01'

-- Bài 3: Cho cơ sở dũ liệu sau
-- Danh mục vật tư
IF OBJECT_ID('TempDb..#DmVt') IS NOT NULL DROP TABLE #DmVt;
CREATE TABLE #DmVt 
(	Ma_Vt VARCHAR(16), 
	Ten_Vt VARCHAR(88)
);
INSERT INTO #DmVt (Ma_Vt, Ten_Vt) VALUES ('VT01', 'Vat tu 01')
INSERT INTO #DmVt (Ma_Vt, Ten_Vt) VALUES ('VT02', 'Vat tu 02')
INSERT INTO #DmVt (Ma_Vt, Ten_Vt) VALUES ('VT03', 'Vat tu 03')
INSERT INTO #DmVt (Ma_Vt, Ten_Vt) VALUES ('VT04', 'Vat tu 04')
INSERT INTO #DmVt (Ma_Vt, Ten_Vt) VALUES ('VT05', 'Vat tu 05')
INSERT INTO #DmVt (Ma_Vt, Ten_Vt) VALUES ('VT09', 'Vat tu 09')
-- Tồn đầu
IF OBJECT_ID('TempDb..#Ton_Dau') IS NOT NULL DROP TABLE #Ton_Dau;
CREATE TABLE #Ton_Dau 
(	Ma_Kho VARCHAR(16), 
	Ma_Vt VARCHAR(16), 
	Ton_Dau NUMERIC(18, 0)
);

INSERT INTO #Ton_Dau (Ma_Kho, Ma_Vt, Ton_Dau) VALUES ('K1', 'VT01', 15)
INSERT INTO #Ton_Dau (Ma_Kho, Ma_Vt, Ton_Dau) VALUES ('K1', 'VT02', 20)
INSERT INTO #Ton_Dau (Ma_Kho, Ma_Vt, Ton_Dau) VALUES ('K1', 'VT05', 8)

-- Nhập xuất trong kỳ
IF OBJECT_ID('TempDb..#Nhap_Xuat') IS NOT NULL DROP TABLE #Nhap_Xuat;
CREATE TABLE #Nhap_Xuat 
(	Ngay_Ct Smalldatetime,
	Ma_Kho VARCHAR(16), 
	Ma_Vt VARCHAR(16), 
	Nhap NUMERIC(18, 0),
	Xuat NUMERIC(18, 0)
);

INSERT INTO #Nhap_Xuat (Ngay_Ct, Ma_Kho, Ma_Vt, Nhap, Xuat) VALUES ('01/01/11', 'K1', 'VT01', 4, 0)
INSERT INTO #Nhap_Xuat (Ngay_Ct, Ma_Kho, Ma_Vt, Nhap, Xuat) VALUES ('01/01/11', 'K1', 'VT03', 10, 0)
INSERT INTO #Nhap_Xuat (Ngay_Ct, Ma_Kho, Ma_Vt, Nhap, Xuat) VALUES ('02/01/11', 'K1', 'VT05', 0, 5)
INSERT INTO #Nhap_Xuat (Ngay_Ct, Ma_Kho, Ma_Vt, Nhap, Xuat) VALUES ('04/01/11', 'K1', 'VT02', 0, 12)
INSERT INTO #Nhap_Xuat (Ngay_Ct, Ma_Kho, Ma_Vt, Nhap, Xuat) VALUES ('05/01/11', 'K2', 'VT04', 14, 0)
INSERT INTO #Nhap_Xuat (Ngay_Ct, Ma_Kho, Ma_Vt, Nhap, Xuat) VALUES ('05/01/11', 'K2', 'VT04', 0, 10)

/* Yêu cầu: Viết store procduce hiển thị dữ liệu có dạng như sau:
	- Biến truyền vào là mã kho: @ma_kho. Truyền vào kho nào thì lên kho đó, không truyền kho thì lên hết

	|Ma_Kho           Ma_Vt				Ton_Dau        Nhap           Xuat           Ton_Cuoi
	|---------------- ----------------	-------------- -------------- -------------- ------------
	|K1               VT01 - Vat tu 01  15              4               0              19
	|K1               VT02 - Vat tu 02  20              0              12               8
	|K1               VT03 - Vat tu 03   0             10               0              10
	|K1               VT05 - Vat tu 04   8              0               5               3
	|K2               VT04 - Vat tu 05   0             14              10               4
	| 				  Tong cong			43             28              27              44
	|---------------- ---------------- -------------- -------------- -------------- ------------
*/


IF OBJECT_ID('tempdb..#bang2') IS NOT NULL DROP TABLE #bang2
SELECT T.Ma_Kho, DMVT.Ma_VT, SUM(ISNULL(T.Ton_Dau, 0)) AS Ton, SUM(ISNULL(NX.Nhap, 0)) AS Nhap, SUM(ISNULL(NX.Xuat, 0)) AS Xuat INTO #bang2
FROM #DMVT AS DMVT LEFT JOIN #Ton_Dau AS T ON T.Ma_VT = DMVT.Ma_VT
				   LEFT JOIN #nhap_Xuat AS NX ON NX.Ma_VT = DMVT.Ma_VT
GROUP BY T.Ma_Kho, DMVT.Ma_VT

SELECT Ma_Kho, Ma_VT, Ton, Nhap, Xuat, Ton+ Nhap- Xuat AS [Toncuoi]
FROM #bang2
UNION ALL
SELECT '' AS Ma_Kho, N'Tổng cộng' AS Ma_VT, SUM(Ton) AS Ton, SUM(nhap) AS Nhap, SUM(Xuat) AS XUat, SUM(Ton)+ SUM(Nhap) - SUM(Xuat) AS Toncuoi 
FROM #bang2


ALTER PROCEDURE bai3
	@_tungay DATE,
	@_denngay DATE
AS BEGIN 
		IF OBJECT_ID('tempdb..#bang2') IS NOT NULL DROP TABLE #bang2
		SELECT T.Ma_Kho, DMVT.Ma_VT, SUM(ISNULL(T.Ton_Dau, 0)) AS Ton, SUM(ISNULL(NX.Nhap, 0)) AS Nhap, SUM(ISNULL(NX.Xuat, 0)) AS Xuat INTO #bang2
		FROM #DMVT AS DMVT LEFT JOIN #Ton_Dau AS T ON T.Ma_VT = DMVT.Ma_VT
						   LEFT JOIN #nhap_Xuat AS NX ON NX.Ma_VT = DMVT.Ma_VT
		WHERE NX.Ngay_CT BETWEEN @_tungay AND @_denngay
		GROUP BY T.Ma_Kho, DMVT.Ma_VT
		SELECT Ma_Kho, Ma_VT, Ton, Nhap, Xuat, Ton+ Nhap- Xuat AS [Toncuoi]
		FROM #bang2
		UNION ALL
		SELECT '' AS Ma_Kho, N'Tổng cộng' AS Ma_VT, SUM(Ton) AS Ton, SUM(nhap) AS Nhap, SUM(Xuat) AS XUat, SUM(Ton)+ SUM(Nhap) - SUM(Xuat) AS Toncuoi 
		FROM #bang2
END 
GO 
EXEC Bai3 '2010-01-01', '2025-01-01'
GO
