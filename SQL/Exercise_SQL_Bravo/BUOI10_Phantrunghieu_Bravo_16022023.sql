
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

IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT SV.MaSV, SV.TenSV, BD.Tiencoc INTO #bang1
FROM DMSinhVien AS SV INNER JOIN BiendongCT AS BD ON SV.MaSV = BD.MaSV
					  INNER JOIN DMLop AS L ON L.MaLop = SV.MaLop
WHERE BD.Ngay BETWEEN @_Ngaydauthang AND @_ngaycuoithang AND L.TenLop LIKE N'%KB%'
		AND BD.LoaiPS = 1

SELECT MaSV, TenSV, SUM(Tiencoc) AS Tiencoc
FROM #bang1 GROUP BY MaSV, TenSV
UNION ALL
SELECT '' AS MaSV, N'Tổng cộng', SUM(Tiencoc) AS Tiencoc
FROM #bang1


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
UNION ALL
SELECT '' AS Sophieu, NULL AS Ngay, 'z' AS maSV, N'Tổng cộng', SUM(Tiencoc) AS Tiencoc
FROM #bang1
ORDER BY maSV, sophieu


s
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




-- Bài 3 Hiển tổng nhâp xuất tồn sách trong khaong từ ngày @_NgayCT1 đến @_ngayCT2
DECLARE @_NgayCT1 DATETIME, @_NgayCT2 DATETIME
SET @_NgayCT1 ='2023/05/12'
SET @_NgayCT2 = '2024/08/12'

SELECT S.MaSach, BD.Ngay,
		CASE WHEN BD.LoaiPS = 2 THEN BDCT.SoLuong ELSE 0 END AS Tra,
		CASE WHEN BD.LoaiPS = 1 THEN BDCT.SoLuong ELSE 0 END AS Muon
FROM DMSach AS S LEFT JOIN Biendongchitiet AS BDCT ON S.MaSach = BDCT.MaSach
				 LEFT JOIN BiendongCT AS BD	 ON BD.SoPhieu = BDCT.SoPhieu
WHERE BD.Ngay < @_ngayCT1

