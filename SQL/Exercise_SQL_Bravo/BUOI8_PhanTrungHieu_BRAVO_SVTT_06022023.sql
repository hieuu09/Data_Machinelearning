

-- Phan Trung Hiếu
-- Trường : Học Viện Tài Chính
-- Bài tập Buổi 8 06/02/2023


--  Bài 1 :Hiển thị : Ngayct, mavt, diengiai, slnhap , slxuat, ton

IF OBJECT_ID('tempdb..#bangton') IS NOT NULL DROP TABLE #bangton
SELECT MaVT, SUM(soluong) AS [toncuoi] INTO #bangton FROM Tondau
GROUP BY MaVT
IF OBJECT_ID('tempdb..#bangps') IS NOT NULL DROP TABLE #bangps
SELECT CT.LoaiCT, CT.NgayCT, CTCT.MaVT, CT.Diengiai, 
		CASE WHEN CT.LoaiCT = 0 THEN CTCT.Soluong ELSE 0 END AS slnhap
	   ,CASE WHEN CT.LoaiCT = 1 THEN CTCT.Soluong ELSE 0 END AS slxuat 
	   ,CAST(0 AS NUMERIC(15,3)) AS Toncuoi INTO #bangps
FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT

SELECT LoaiCT, NgayCT, MaVT, Diengiai, slnhap, Slxuat,
			IIF(LoaiCT = 2, 0, SUM(IIF(LoaiCT IN (0, 1), ISNULL(Toncuoi, 0) + ISNULL(slnhap, 0) - ISNULL(slxuat, 0), 0))  
		    OVER (PARTITION BY MaVT ORDER BY Mavt, LoaiCT, NgayCT ROWS UNBOUNDED PRECEDING )) AS Toncuoi
FROM (
			SELECT 0 AS [Loaict], NULL AS [NgayCT], DMVT.MaVT, N'TỒN ĐẦU' AS [Diengiai], 0 AS [slnhap], 0 AS [slxuat], Toncuoi 
			FROM #bangton RIGHT JOIN DMVT ON #bangton.MaVT = DMVT.MaVT
			UNION ALL
			SELECT * FROM #bangps
			UNION ALL
			SELECT 2 AS [LoaiCT], NULL AS [NgayCT], MaVT, N'Tổng nhập xuât' AS [Dieniai], SUM(slnhap) AS [slnhap], SUM(slxuat) AS [slxuat], 0 AS [Toncuoi] FROM #bangps
			GROUP BY MaVT
			UNION ALL
			SELECT 3 AS [LoaiCT], NULL AS [NgayCT], MaVT, N'Tồn cuối kì' AS [Dieniai], 0 AS [slnhap], 0 AS [slxuat], 0 AS [Toncuoi] FROM #bangps
			GROUP BY MaVT
			) AS K

			

-- '' trang thi no ko sap xep no len dau nen phai them  zzz dể cho nó xuống cuối

/*  Bài 1 : Cho biến @_loaibaocao nêu loại báo cao bằng 1 thif 
các dòng in đậm sẽ nhosmm theo mã vật tư , nếu dòng in đậm bằng 2 các dòng nhóm in đông theo nhóm đối tương 
STT , soct, ngayct, mavt, diengiai , tien
*/

DECLARE @_Loaibaocao INT;
IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT CT.SoCT, CT.NgayCT, CTCT.MaVT, CT.Diengiai, CTCT.SoLuong*CTCT.Dongia AS [Tien], DMVT.TenVT, DMDT.TenDT, DMDT.maDT  INTO #bang1
FROM CT INNER JOIN CTCT ON CT.SOCT = CTCT.SoCT
		INNER JOIN DMVT ON DMVT.MaVT = CTCT.MaVT
		INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT
SET @_Loaibaocao = 1
IF @_Loaibaocao = 1
	BEGIN
	SELECT  ROW_NUMBER() OVER(PARTITION BY MaVT ORDER BY NgayCT ) AS STT, SoCT, NgayCT, MaVT, Diengiai, Tien FROM (
			SELECT '' AS [SoCT], NULL AS [NgayCT], MaVT , MaVT AS [Diengiai], SUM(Tien) AS [Tien] FROM #bang1
			GROUP BY MaVT
			UNION ALL
			SELECT SoCT, NgayCT, MaVT, Diengiai, Tien FROM #bang1
			UNION ALL
			SELECT '' AS [SoCT], NULL AS [NgayCT], 'Zmavt' AS [MaVT], N'Tổng cộng' AS [Diengiai], SUM(Tien) FROM #bang1 ) BB
	END
ELSE IF @_Loaibaocao = 2
	BEGIN
		SELECT ROW_NUMBER() OVER(PARTITION BY MaDT ORDER BY NgayCT) AS [STT], NgayCT, MaDT, Diengiai, Tien FROM(
			SELECT '' AS [SoCT],NULL AS  [NgayCT], MaDT, MaDT AS [Diengiai], SUM(Tien) AS Tien FROM #bang1
			GROUP BY MaDT
			UNION ALL
			SELECT SoCT, NgayCT, MaDT, Diengiai, Tien FROM #bang1
			UNION ALL 
			SELECT '' AS [SoCT], NULL AS [NgayCT], 'Z' AS [MaDT], N'Tổng Cộng' AS [Diengiai], SUM(Tien) AS [Tien] FROM #bang1) AS CC
	END
ELSE SELECT N'Bạn cần nhập lại 1 để theo mã vật tư , 2 nhóm theo mã đối tượng '

-- Chuỗi động 

DECLARE @_Loaibaocao INT ,@_ma NVARCHAR(20), @_ten NVARCHAR(20), @_Str NVARCHAR(1000);
IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT CT.SoCT, CT.NgayCT, CTCT.MaVT, CT.Diengiai, CTCT.Soluong* CTCT.Dongia AS [Tien], DMDT.TenDT, DMDT.MaDT INTO #bang1
FROM CT INNER JOIN CTCT ON CT.SOCT = CTCT.SOCT
		INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT
SET @_Loaibaocao = 2
IF @_Loaibaocao = 1 
		SELECT	@_ma = 'MaVT' ,@_ten = 'tenVT'
ELSE IF @_Loaibaocao = 2
		SELECT @_ma = 'MaDT' ,  @_ten = 'TenDT'
ELSE SELECT N'Bạn cần nhập lại 1 mavt, 2 madt'
SET @_Str = N'
SELECT ROW_NUMBER() OVER(PARTITION BY '+@_Ma+' ORDER BY NgayCT) AS [STT], SoCT, NgayCT, '+@_Ma+', Diengiai, Tien FROM (
		SELECT '''' AS [SoCT], NULL AS [NgayCT], '+@_Ma+', '+@_Ma+' AS [Diengiai] , SUM(Tien) AS [Tien] FROM #bang1
		GROUP BY '+@_Ma+'
		UNION ALL 
		SELECT SoCT, NgayCT, '+@_Ma+', Diengiai, Tien FROM #bang1
		UNION ALL
		SELECT '''' [SoCT], NULL AS [NgayCT], N''ZMa'' AS [MaVT], N''Tổng Cộng'', SUM(Tien) AS [Tien] FROM #bang1 ) B'
EXECUTE (@_Str)

-- Bài 2 : Hiển thị ngayct, mavt, diengiai, slnhap, slxuat, ton 

IF OBJECT_ID('tempdb..#tondau') IS NOT NULL DROP TABLE #tondau
SELECT MaVT, SUM(soLuong) AS soluong INTO #tondau
FROM TonDau GROUP BY MaVT

IF OBJECT_ID('tempdb..#bangps') IS NOT NULL DROP TABLE #bangps
SELECT CT.NgayCT, CTCT.MaVT, CT.Diengiai, 
		CASE WHEN CT.LoaiCT = 0 THEN CTCT.SoLuong ELSE 0 END AS Slnhap,
		CASE WHEN CT.LoaiCT = 1 THEN CTCT.SoLuong ELSE 0 END AS slxuat,
		CAST(0 AS NUMERIC(18,2)) AS Tondau, 1 AS SX
		INTO #bangps
FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT
UNION ALL
SELECT NULL AS Ngayct, DMVT.MaVT, N'Tồn đầu' AS [Diengiai], 0 AS slnhap, 0 AS slxuat, ISNULL(#tondau.soluong, 0) AS tondau, 0 AS SX
FROM #tondau INNER JOIN DMVT ON #tondau.MaVT = DMVT.MaVT

IF OBJECT_ID('tempdb..#baocao') IS NOT NULL DROP TABLE #baocao
SELECT NgayCT, MaVT, Diengiai, slnhap, slxuat, tondau, sx INTO #baocao
FROM #bangps
UNION ALL
SELECT NULL NgayCT, MaVT, N'Tồn cuối' AS [diengiai], 
			SUM(slnhap) AS slnhap, SUM(slxuat) AS slxuat, SUM(tondau)+SUM(slnhap)- SUM(slxuat) AS [toncuoi], 2 AS SX
FROM #bangps GROUP BY MaVT
ORDER BY MaVT, sx
-- casch 1 kieu update van sai

DECLARE @_ton INT , @_MaVT NVARCHAR(16)
SELECT @_ton = 0 , @_maVT =''
UPDATE #baocao SET @_ton = CASE WHEN mavt = @_MavT
		THEN @_ton + slnhap -slxuat ELSE Tondau END , Tondau = @_ton, @_mavt = mavt
SELECT * FROM #baocao ORDER BY MaVT, sx, NgayCT

-- Cach 3 Sử dụng pattion sum


IF OBJECT_ID('tempdb..#bangton') IS NOT NULL DROP TABLE #bangton
SELECT Mavt, SUM(soluong) AS [tondau] INTO #bangton 
FROM Tondau GROUP BY Mavt

IF OBJECT_ID('tempdb..#bangps') IS NOT NULL DROP TABLE #bangps
SELECT CT.NgayCT, CTCT.Mavt, CT.Diengiai,
		CASE WHEN CT.LoaiCT = 0 THEN CTCT.SoLuong ELSE 0 END AS slnhap,
		CASE WHEN CT.LoaiCT = 1 THEN CTCT.Soluong ELSE 0 END AS slxuat,
		CAST(0 AS NUMERIC(18, 2)) AS [Ton], 1 AS SX
		INTO #bangps
FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT

SELECT NgayCT, MaVT, Diengiai, slnhap, slxuat,
				IIF(SX =3, 0, SUM(ton + slnhap - slxuat) OVER(PARTITION BY MaVT ORDER BY SX, NgayCT )) AS toncuoi  FROM (
				SELECT NULL AS [NgayCT], DMVT.MaVt, N'Tồn đầu' AS [Diengiai], 0 AS slnhap, 0 AS slxuat, ISNULL(tondau, 0) AS Ton, 0 AS SX 
				FROM DMVT LEFT JOIN #bangton ON DMVT.MaVT = #bangton.MaVT
				UNION ALL
				SELECT NgayCT , MaVT, Diengiai, slnhap, slxuat, ton, sx FROM #bangps
				UNION ALL
				SELECT NULL NgayCT, MaVT, N'Tồn cuối' AS Diengiai, 0 AS slnhap, 0 AS slxuat , 0 AS ton, 2 AS SX FROM DMVT
				UNION ALL
				SELECT NULL AS NgayCT, MaVT, N'Tổng nhập xuât' AS [Diengiai], SUM(slnhap) AS slnhap, SUM(slxuat) AS [slxuat], 0 AS [ton] , 3 AS SX FROM #bangps
				GROUP BY MaVT
			) G

-- bai3 NgayCT, soct, MaVT, Diengiai, slnhap, tiennhap, slxuat, tienban, tienvon(giaTB * slxuat)


IF OBJECT_ID('tempdb..#nhapton') IS NOT NULL DROP TABLE #nhapton
SELECT NgayCT, SOCT, MaVT, Diengiai, slnhap, tiennhap, slban, tienban, sx INTO #nhapton
FROM (
	SELECT NULL AS NgayCT, '' AS SoCT, DMVT.MaVT, N'Đầu kì' AS [Diengiai], 
			SUM(ISNULL(soluong,0)) AS slnhap, SUM(ISNULL(Tien,0)) AS [tiennhap], 0 AS slban, 0 AS Tienban,  0 SX 
	FROM Tondau RIGHT JOIN DMVT ON Tondau.MaVT = DMVT.MaVT
	GROUP BY DMVT.MaVT
	UNION ALL
	SELECT CT.NgayCT, CT.SoCT, CTCT.MaVT, CT.Diengiai,
			CASE WHEN CT.LoaiCT = 0 THEN CTCT.Soluong ELSE 0 END AS slnhap,
			CASE WHEN CT.LoaiCT = 0 THEN CTCT.Tien ELSE 0 END AS tiennhap,
			CASE WHEN CT.LoaiCT = 1 THEN CTCT.SoLuong ELSE 0 END AS slban,
			CASE WHEN CT.LoaiCT = 1 THEN CTCT.Tien ELSE 0 END AS Tienban,
			1 AS SX
	FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT ) CC

-- Tính giá vốn bình quân từng vật tư 
IF OBJECT_ID('tempdb..#giavon') IS NOT NULL DROP TABLE #giavon
SELECT MaVT, (SUM(tiennhap)/ SUM(slnhap)) AS Giavon INTO #Giavon
FROM #nhapton
WHERE #nhapton.slnhap <> 0
GROUP BY MaVT

-- tính dòng tổng cộng thêm cột tiền vốn
IF OBJECT_ID('tempdb..#baocao') IS NOT NULL DROP TABLE #baocao
SELECT NULL AS NgayCT, '' AS SoCT, T1.MaVT, N'Tổng cộng vật tư' AS Diengiai, SUM(T1.Slnhap) AS Slnhap, SUM(T1.tiennhap) AS tiennhap,
				SUM(T1.Slban) AS Slban, SUM(T1.tienban) AS tienban, ISNULL(T2.Giavon*SUM(T1.Slban), 0) AS Tienvon , 2 AS SX
INTO #baocao
FROM #nhapton AS T1 LEFT JOIN #giavon AS T2 ON T1.MaVT = T2.MaVT
GROUP BY T1.MaVT, T2.giavon
UNION ALL
SELECT T1.NgayCT, T1.SOCT, T1.MaVT, T1.Diengiai, T1.Slnhap, T1.tiennhap, T1.slban, T1.Tienban, ISNULL(T2.Giavon*SUM(T1.slban),0) AS tienvon, SX
FROM #nhapton AS T1 LEFT JOIN #giavon AS T2 ON T1.MaVT = T2.MaVt
GROUP BY T1.NgayCT, T1.SoCT, T1.MaVT, T1.Diengiai, T1.Slnhap,T1.tiennhap, T1.slban, T1.Tienban, sx, t2.giavon
-- xuất báo cáo

SELECT Ngayct, Soct , Mavt, Diengiai, slnhap, tiennhap, slban, tienban, tienvon, sx , ROW_NUMBER() OVER(PARTITION BY Mavt ORDER BY sx) AS stt FROM (
		SELECT T1.NgayCT, T1.SOCT, T1.MaVT, T1.Diengiai, T1.slnhap, T1.Tiennhap, T1.slban, T1.tienban, T1.Tienvon, T1.Sx
		FROM #baocao AS T1
		UNION ALL
		SELECT NULL AS NgayCT, '' AS SoCT, T1.MaVT, N'Lợi nhuận' AS Diengiai, 0 AS slnhap, SUM(T1.tienban - T1.Tienvon)/2 AS tiennhap, 0 AS slban,
					0 AS Tienban, 0 AS tienvon , 3 AS SX
					FROM #baocao AS T1
		GROUP BY T1.MaVT ) J




-- bai 3

IF OBJECT_ID('tempdb..#nhapton') IS NOT NULL DROP TABLE #nhapton
SELECT NULL AS NgayCT, '' AS SoCT, DMVT.MaVT, N'Đầu Kì' AS Diengiai, SUM(ISNULL(Tondau.soluong, 0)) slnhap, 
				SUM(ISNULL(Tondau.Tien, 0)) AS Tiennhap, 0 AS slban, 0 AS Tienban , 0 AS SX INTO #nhapton
FROM TonDau RIGHT JOIN DMVT ON TonDau.MaVT = DMVT.MaVT
GROUP BY DMVT.MaVT
UNION ALL
SELECT CT.NgayCT, CT.SoCT, CTCT.MaVT, CT.Diengiai, 
			CASE WHEN CT.LoaiCT = 0 THEN CTCT.SoLuong ELSE 0 END AS slnhap,
			CASE WHEN CT.LoaiCT = 0 THEN CTCT.Tien ELSE 0 END AS tiennhap,
			CASE WHEN CT.LoaiCT = 1 THEN CTCT.Soluong ELSE 0 END AS slban,
			CASE WHEN CT.LoaiCT = 1 THEN CTCT.Tien ELSE 0 END AS tienban,
			1 AS SX
FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SOCT
-- Tinh gia trung binh
IF OBJECT_ID('tempdb..#giavon') IS NOT NULL DROP TABLE #giavon
SELECT MaVT, SUM(Tiennhap)/SUM(slnhap) AS Giavon INTO #giavon
FROM #nhapton 
WHERE #nhapton.slnhap <> 0
GROUP BY MaVT
-- Tính dòng tổng cộng thêm cột tiền vốn 
IF OBJECT_ID('tempdb..#baocao') IS NOT NULL DROP TABLE #baocao
SELECT NULL AS NgayCT, ''AS SoCT, T1.MavT AS MaVT, N'Tổng cộng vật tư' AS Diengiai, SUM(T1.slnhap) AS slnhap, SUM(T1.Tiennhap) AS tiennhap,
		SUM(T1.slban) AS slban, SUM(T1.Tienban) AS Tienban,ISNULL(SUM(T1.Slban)*T2.giavon, 0) AS [Tienvon], 2 AS SX
	INTO #baocao
FROM #nhapton AS T1 LEFT JOIN #giavon AS T2 ON T1.MaVT = T2.MaVT
GROUP BY T1.MaVT, T2.GiaVon
UNION ALL
SELECT T1.NgayCT, T1.SoCT, T1.MaVT, T1.Diengiai, T1.slnhap, T1.tiennhap, T1.Slban, T1.Tienban , iSNULL(T2.GiaVon * SUM(T1.slban), 0) AS Tienvon , SX
FROM #nhapton AS T1 LEFT JOIN #giavon AS T2 ON T1.MaVT = T2.MaVT 
GROUP BY T1.NgayCT, T1.SoCT, T1.MaVT, T1.Diengiai, T1.slnhap, T1.tiennhap, T1.Slban, T1.Tienban, T2.GiaVon, SX

--
SELECT ngayct, SOCT, MaVT, Diengiai, Slnhap, tiennhap, slban, tienban, tienvon, sx, ROW_NUMBER() OVER(PARTITION BY MaVT ORDER BY SX) AS STT FROM (
		SELECT T1.NgayCT, T1.SoCT, T1.MaVT, T1.Diengiai, T1.slnhap, T1.Tiennhap, T1.Slban, T1.Tienban, T1.Tienvon, T1.SX FROM #baocao AS T1
		UNION ALL 
		SELECT NULL AS NgayCT, '' AS SoCT, T1.MaVT, N'Lợi nhuận = tiền bán - Tiền vốn' AS Diengiai, 0 AS slnhap,
					SUM(T1.Tienban - T1.Tienvon)/2 AS Tiennhap, 0 AS slxuat, 0 AS Tienban , 0 AS Giavon , 3 AS SX 
					FROM #baocao AS T1
		GROUP BY T1.MaVT) AS  G