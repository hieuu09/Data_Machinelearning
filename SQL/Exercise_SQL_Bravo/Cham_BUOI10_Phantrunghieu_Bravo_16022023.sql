/*
Tổng điểm: 5 Điểm.
Điểm CSDL: 1
Câu 1: 1 Điểm. Chưa bắt điều kiện WHERE Lớp Tin học 65A. Sai kết quả. 1 sinh viên mượn nhiều lần thì đang bị lặp lại.
Câu 2: 2.5 Điểm. 
Câu 3: 0.5 Điểm. 
*/
-- Phan Trung Hiếu
-- Bài kiểm tra số 1

CREATE DATABASE BKT
USE BKT

CREATE TABLE DMsach 
(
	Masach VARCHAR(16) NOT NULL PRIMARY KEY ,
	Tensach NVARCHAR(92) NOT NULL,
	Loaisach VARCHAR(2) ,
	Hansudung DATE 
)

CREATE TABLE DMSinhvien
(
	Masv VARCHAR(16) NOT NULL PRIMARY KEY,
	TenSV NVARCHAR(92) NOT NULL,
	Malop VARCHAR(16) NOT NULL,
	SoCMTND VARCHAR(24) NOT NULL,
	Quequan VARCHAR(92) NOT NULL
)
CREATE TABLE DMLop 
(
	Malop VARCHAR(16) NOT NULL PRIMARY KEY,
	Tenlop NVARCHAR(92) NOT NULL ,
	Chuyennganh NVARCHAR(48) NOT NULL

)
CREATE TABLE BiendongCT
(
	Ngay DATE NOT NULL,
	MaSV VARCHAR(16) NOT NULL,
	LoaiPS CHAR(1) ,
	Diengiai NVARCHAR(96) ,
	Sophieu VARCHAR(16) NOT NULL PRIMARY KEY,
	Tiencoc NUMERIC(18,0) NOT NULL
)
CREATE TABLE Biendongchitiet 
(
	Sophieu VARCHAR(16) NOT NULL,
	MaSach VARCHAR(16) NOT NULL,
	Soluong INT 
)

ALTER TABLE Biendongchitiet ADD CONSTRAINT Biendong FOREIGN KEY(masach)  REFERENCES DMsach(masach)
ALTER TABLE DMsinhvien ADD CONSTRAINT sv_lop FOREIGN KEY(malop)  REFERENCES DMlop(malop)

ALTER TABLE BiendongCT ADD CONSTRAINT fbd FOREIGN KEY(maSV)  REFERENCES DMsinhvien(masv)
ALTER TABLE Biendongchitiet ADD CONSTRAINT CT_bdct FOREIGN KEY(Sophieu)  REFERENCES Biendongct(sophieu)



-- Bài 1 Hiển thị danh sach sinh viên Lớp tin học 65A đã mượn sach trong tháng hiện tại

DECLARE @_Ngaydauthang DATETIME , @_Ngaycuoithang DATETIME 
DECLARE @_Ngayhientai DATE , @_khoangcachthang INT

SET @_Ngayhientai = GETDATE()
SET @_Ngaydauthang = DATEADD(DD, -DAY(@_Ngayhientai)+1,@_Ngayhientai)
SET @_Ngaycuoithang = EOMONTH(@_Ngayhientai)

SELECT SV.MaSV AS [MaSV], SV.TenSV AS [TenSV], BD.Tiencoc AS [Tongtiencoc]
FROM DMSinhvien AS SV INNER JOIN BiendongCT AS BD ON SV.MaSV = BD.MaSV
WHERE BD.Ngay BETWEEN @_Ngaydauthang AND @_Ngaycuoithang AND BD.LoaiPS = 1
UNION ALL
SELECT '' AS [MaSV], N'Tổng Cộng' AS [TenSV], SUM(BD.TienCoc) AS [Tongtiencoc]
FROM  DMSinhvien AS SV INNER JOIN BiendongCT AS BD ON SV.MaSV = BD.MaSV
WHERE BD.Ngay BETWEEN @_Ngaydauthang AND @_Ngaycuoithang AND BD.LoaiPS = 1



-- Bài 2 Hiển thị Sinh viên Mượn phát sinh trong khoảng @_ngayCT1 dến @_NgayCT2

DECLARE @_NgayCT1 DATETIME , @_NgayCT2 DATETIME 
SET @_NgayCT1 = '09-02-2015'
SET @_NgayCT2= '09-08-2025'
IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT BDDP.sophieu, BDDP.Ngay, BDDP.MaSV, BDDP.Diengiai, BDDP.Tiencoc, SV.TenSV INTO #bang1
FROM BiendongCT AS BDDP INNER JOIN DMSinhvien AS SV ON BDDP.MaSV = SV.maSV 
WHERE BDDP.Ngay BETWEEN @_ngayCT1 AND @_NgayCT2 AND LoaiPS = 1

SELECT Sophieu, Ngay, MaSV, Diengiai, Tiencoc 
FROM #bang1
UNION ALL
SELECT ''  AS Sophieu, NULL AS Ngay, MaSV, TenSV AS Diengiai, SUM(Tiencoc) AS Tiencoc
FROM #bang1
GROUP BY MaSV, TenSV
ORDER BY maSV, sophieu



-- Bài 3 : Hiển thị Tổng hợp nhập xuất tồn sách trong khoảng @_NgayCT1 TO @_NgayCT2
DECLARE @_NgayCT1 DATETIME , @_NgayCT2 DATETIME 
SET @_NgayCT1 = '09-02-2024'
SET @_NgayCT2= '09-08-2025'
IF OBJECT_ID('tempdb..#bangton') IS NOT NULL DROP TABLE #bangton
SELECT MaSach , SUM(Muon) AS Muon, SUM(tra) AS Xuat, SUM(Muon) - SUM(tra) AS Ton INTO #bangton FROM 

(		SELECT CT.MaSach, 
				CASE WHEN BD.LoaiPS = 1 THEN CT.SoLuong ELSE 0 END AS Muon,
				CASE WHEN BD.LoaiPS = 2 THEN CT.SoLuong ELSE 0 END AS tra
		FROM Biendongchitiet AS CT INNER JOIN BiendongCT AS BD ON BD.SOPhieu = CT.SoPhieu
		WHERE BD.Ngay < @_NgayCT1 ) AS K
GROUP BY maSach


IF OBJECT_ID('tempdb..#PS') IS NOT NULL DROP TABLE #PS
SELECT Ct.MaSach , S.TenSach,
				CASE WHEN BD.LoaiPS = 1 THEN CT.SoLuong ELSE 0 END AS Muon,
				CASE WHEN BD.LoaiPS = 2 THEN CT.SoLuong ELSE 0 END AS Tra
				INTO #PS
FROM Biendongchitiet AS CT INNER JOIN BiendongCT  AS BD ON CT.SoPhieu = BD.Sophieu 
						   INNER JOIN DMSach AS S ON S.MaSach =  CT.MaSach
WHERE BD.Ngay BETWEEN @_NgayCT1 AND @_NgayCT2

SELECT MaSach, TenSach, SUM(Muon) AS Muon, SUM(tra) AS Tra
FROM #PS  
GROUP BY MaSach, TenSach

SELECT MaSach, TenSach, ISNULL(SUM(Tondau,0)) AS TON,SUM(Muon), SUM(Tra) FROM  