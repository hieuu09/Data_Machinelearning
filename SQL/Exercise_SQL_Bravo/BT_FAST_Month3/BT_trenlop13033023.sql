--1.Tạo CSDL
-- Khach_Hang (Ma_KH, Ten_KH, MST, Gioi_Tinh) (MST: dạng ký tự không bắt buộc nhập, Gioi_Tinh kiểu INT nhận giá trị 1.Nam, 2.Nữ)
-- Hoa_Don (SoHD, Ngay, Ma_KH, Dien_Giai, TK_No, TK_Co, Tong_Tien) 
CREATE TABLE Khach_Hang
(
	Ma_KH VARCHAR(10),
	Ten_KH NVARCHAR(50),
	MST VARCHAR(10),
	Gioi_Tinh INT
)
CREATE TABLE Hoa_Don
(
	SoHD VARCHAR(10),
	Ngay DATE,
	Ma_KH VARCHAR(10),
	Dien_Giai NVARCHAR(100),
	TK_No VARCHAR(5),
	TK_Co VARCHAR(5),
	Tong_Tien NUMERIC(18,3)
)

SELECT KH.Ma_KH, KH.Ten_KH, KH.MST, KH.Gioi_Tinh
FROM #Khach_Hang AS KH

--2.Đề bài
--Câu 1. Lấy ra danh sách khách hàng
SELECT KH.Ma_KH, KH.Ten_KH, KH.MST, KH.Gioi_Tinh
FROM Khach_Hang AS KH
--Câu 2. Lấy ra các hóa đơn có mã khách hàng là KH01
SELECT HD.SOHD, HD.Ngay, HD.Ma_KH, HD.Dien_Giai, HD, TK_No, HD.TK_Co, HD.Tong_Tien
FROM Khach_Hang AS KH INNER JOIN Hoa_Don AS HD ON KH.Ma_KH = HD.Ma_KH
WHERE HD.MaKH = 'KH01'
--Câu 3. Lấy ra các hóa đơn có tổng tiền trên hóa đơn không lớn hơn 50
SELECT HD.SoHD, HD.Ngay
FROM Hoa_Don AS HD
WHERE HD.Tong_Tien > 50
--Câu 4. Lấy ra các hóa đơn có mã khách hàng là KH01 và số tiền trên hóa đơn không lớn hơn 30000
SELECT HD.SoHD, HD.Ngay 
FROM Hoa_Don AS HD INNER JOIN KHach_Hang AS KH ON HD.Ma_KH = KH.Ma_KH
WHERE HD.Ma_KH = 'KH01' AND HD.Tong_tien <= 30000
--Câu 5. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc số tiền trên hóa đơn không lớn hơn 30000
SELECT HD.SoHD, HD.Ngay 
FROM Hoa_Don AS HD INNER JOIN KHach_Hang AS KH ON HD.Ma_KH = KH.Ma_KH
WHERE HD.Ma_KH = 'KH01' OR HD.Tong_tien <= 30000
--Câu 6. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc KH02 và số tiền trên hóa đơn không lớn hơn 30000
SELECT HD.SoHD, HD.Ngay 
FROM Hoa_Don AS HD INNER JOIN KHach_Hang AS KH ON HD.Ma_KH = KH.Ma_KH
WHERE (HD.Ma_KH = 'KH01' OR HD.Ma_KH ='KH02') AND HD.Tong_tien <= 30000
--Câu 7. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc KH02 và có năm là 2013
SELECT HD.SoHD, HD.Ngay 
FROM Hoa_Don AS HD INNER JOIN KHach_Hang AS KH ON HD.Ma_KH = KH.Ma_KH
WHERE (HD.Ma_KH = 'KH01' OR HD.Ma_KH ='KH02') AND YEAR(HD.NGay) = 2013
--Câu 8. Lấy ra các khách hàng có mã số thuế null
SELECT KH.Ma_KH, KH.Ten_KH
FROM Hoa_Don AS HD INNER JOIN KHach_Hang AS KH ON HD.Ma_KH = KH.Ma_KH
WHERE KH.MST IS NULL
--Câu 9. Lấy ra các hóa đơn có diễn giải chứa kí tự Bán hàng
SELECT HD.SoHD, HD.Ngay, HD.Ma_KH, HD.Dien_Giai, HD.TK_No, HD.TK_Co, HD.Tong_Tien
FROM Hoa_Don AS HD
WHERE HD.DIen_giai LIKE N'%Bán hàng%'
--Câu 10. Lấy ra các hóa đơn có diễn giải bắt đầu với kí tự Bán hàng
SELECT HD.SoHD, HD.Ngay, HD.Ma_KH, HD.Dien_Giai, HD.TK_No, HD.TK_Co, HD.Tong_Tien
FROM Hoa_Don AS HD
WHERE HD.DIen_giai LIKE N'Bán hàng%'
--Câu 11. Lấy ra các khách hàng có kí tự thứ 2 của mã khách hàng là H
SELECT KH.Ma_KH, KH.Ten_KH, KH.MST, KH.Gioi_Tinh
FROM Khach_Hang AS KH
WHERE KH.Ma_KH LIKE '_H%'
--Câu 12. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc KH02 và có năm là 2013
SELECT HD.SoHD, HD.Ngay, HD.Ma_KH, HD.Dien_Giai, HD.TK_No, HD.TK_Co, HD.Tong_Tien
FROM Hoa_Don AS HD
WHERE (HD.Ma_KH = 'KH01' OR HD.Ma_KH = 'KH02') AND YEAR(HD.Ngay) = 2013
--Câu 13. Lấy ra các khách hàng có phát sinh hóa đơn trong năm 2013 và có mã số thuế không null
SELECT KH.Ma_KH, KH.Ten_KH, KH.MST, KH.Gioi_Tinh
FROM Hoa_Don AS HD INNER JOIN KHach_Hang AS KH ON HD.Ma_KH = KH.Ma_KH
WHERE YEAR(HD.Ngay) = 2013 AND KH.MST IS NOT NULL
--Câu 14. Lấy ra ds khách hàng và các hóa đơn phát sinh (Hóa đơn phát sinh thì đông thời cả bên hd và bên khách hàng có số hóa đơn)
SELECT KH.Ma_KH, HD.SoHD
FROM Hoa_Don AS HD INNER JOIN KHach_Hang AS KH ON HD.Ma_KH = KH.Ma_KH
--Câu 15. Lấy ra ds tất cả khách hàng và các hóa đơn phát sinh
--Câu 16. Lấy ra ds tất cả khách hàng và tất cả các hóa đơn phát sinh
--Câu 17. Lấy các hóa đơn có năm 2015, đẩy vào bảng tạm #HD2015
--Câu 18. Lấy tất cả các khách hàng, nếu trường MST là Null thì gán giá trị 123
--Câu 19. Lấy ra danh sách khách hàng và giới tính (1.Nam, 2 Nữ)
/*Câu 20. Viết ra báo cáo dạng sau :
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
DECLARE @_tungay DATE, @_denngay DATE
SET @_Tungay ='01/01/2020'
SET @_denngay ='01/01/2026'
IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #Bang1
SELECT HD.SOHD, HD.Ma_KH, HD.Dien_Giai, HD.Ngay, HD.Tong_tien AS Tien
	INTO #bang1 
FROM Hoa_Don AS HD INNER JOIN Khach_Hang AS KH ON KH.Ma_KH= HD.Ma_Kh
WHERE HD.Ngay BETWEEN @_tungay AND @_Denngay

SELECT '' SOHD, N'Tổng Cộng' AS Dien_Giai, NULL AS Ngay,SUM(Tien) AS Tien, 'Z' AS Ma_KH FROM #bang1
UNION ALL
SELECT '' AS SOHD, Ma_KH +' - Khachhang '+ Ma_Kh AS Dien_Giai, NULL AS Ngay, SUM(Tien) AS Tongtien, Ma_KH FROM #bang1
GROUP BY MA_KH
UNION ALL
SELECT SOHD, Dien_Giai +':'+ SOHD  AS [Diengiai], Ngay, Tien, Ma_KH
FROM #bang1
ORDER BY Ma_KH, SOHD






--Cho cơ sở dũ liệu sau
SET NOCOUNT ON;
SET DATEFORMAT DMY;

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

--SELECT * FROM #Ton_Dau
--SELECT * FROM #Nhap_Xuat

/* Yêu cầu
1/ Viết ra báo cáo dạng Nhập xuất tồn:
	- Điều kiện là Ma_Kho. Truyền vào kho nào thì lên kho đó, không truyền kho thì lên hết	

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


SELECT *
FROM #DMVT AS DMVT RIGHT JOIN #Ton_Dau AS TD ON DMVT.Ma_VT = TD.Ma_VT
				   INNER JOIN #Nhap_Xuat AS NX ON NX.Ma_VT = DMVT.Ma_VT

IF OBJECT_ID('TempDb..#DmVt') IS NOT NULL DROP TABLE #DmVt;
CREATE TABLE #DmVt 
(	Ma_Vt VARCHAR(16), 
	Ten_Vt VARCHAR(88)
);

IF OBJECT_ID('TempDb..#Ton_Dau') IS NOT NULL DROP TABLE #Ton_Dau;
CREATE TABLE #Ton_Dau 
(	Ma_Kho VARCHAR(16), 
	Ma_Vt VARCHAR(16), 
	Ton_Dau NUMERIC(18, 0)
);
IF OBJECT_ID('TempDb..#Nhap_Xuat') IS NOT NULL DROP TABLE #Nhap_Xuat;
CREATE TABLE #Nhap_Xuat 
(	Ngay_Ct Smalldatetime,
	Ma_Kho VARCHAR(16), 
	Ma_Vt VARCHAR(16), 
	Nhap NUMERIC(18, 0),
	Xuat NUMERIC(18, 0)
);