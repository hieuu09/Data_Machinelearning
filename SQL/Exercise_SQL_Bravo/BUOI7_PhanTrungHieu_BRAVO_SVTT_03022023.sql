
-- Phan Trung Hiếu
-- Trường : Học Viện Tài Chính
-- Bài tập Buổi 7 03/02/2023

-- date ko dc covert , nó sẽ sắp xếp sai 

IF OBJECT_ID('Tempdb..#Tmp') IS NOT NULL DROP TABLE #Tmp
SELECT 1 AS ProductId, 'CUS001' AS CustomerCode, 2 AS Quantity, 100000 AS Amount
INTO #Tmp
UNION ALL
SELECT 2 AS ProductId, 'CUS004' AS CustomerCode, 1 AS Quantity, 200000 AS Amount
UNION ALL
SELECT 3 AS ProductId, 'CUS003' AS CustomerCode, 5 AS Quantity, 1000000 AS Amount
UNION ALL
SELECT 4 AS ProductId, 'CUS001' AS CustomerCode, 6 AS Quantity, 500000 AS Amount
UNION ALL
SELECT 5 AS ProductId, 'CUS002' AS CustomerCode, 2 AS Quantity, 100000 AS Amount
UNION ALL
SELECT 4 AS ProductId, 'CUS003' AS CustomerCode, 2 AS Quantity, 300000 AS Amount
UNION ALL
SELECT 1 AS ProductId, 'CUS003' AS CustomerCode, 3 AS Quantity, 400000 AS Amount
SELECT *  FROM #Tmp

-- do tên cột không cho phép là số 0 , Viết sai tên cột để [] tránh kiểu kí tự , kiểu số 

/* Bài 1 Viết câu lệnh pivot ProductID
   Bài 2 Viết câu lệnh để pivot theo Productid theo nhóm Customercode
   Bài 3 Xử lí hiển thị kết quả sau ko còn null
   Bài 4 Xử lí động các cột theo dữ liệu phát sinh
   Bài 5 Viết câu lênh pivot số lượng và tiền lên thành cột theo mã khách hàng , Productid, SL_CUST001,Tien_CUST001, SL_CUST002, TienCUST002
*/

-- Bài 1 :  Viết câu lệnh pivot ProductID
SELECT CustomerCode, Quantity, [1], [2], [3], [4], [5]  FROM #Tmp
PIVOT
(
	SUM(AMOUNT) FOR Productid IN([1], [2], [3], [4], [5])
) AS BB


-- Bài 2 Viết câu lệnh để pivot theo Productid theo nhóm Customercode
-- pivot nó tự group by , lấy các trường cần thiết 

SELECT CustomerCode, [1], [2], [3], [4], [5] 
FROM (  SELECT CustomerCode, Amount, ProductID FROM #Tmp ) AS A
PIVOT
(
	SUM(Amount) FOR ProductID IN ([1], [2], [3], [4], [5])
) AS B

-- Bài 3 Xử lí hiển thị kết quả sau ko còn null

SELECT ISNULL([1],0) AS [1], ISNULL([2],0) AS [2], ISNULL([3],0) AS [3], ISNULL([4],0) AS [4], ISNULL([5],0) AS [5]
FROM #Tmp
PIVOT
(
	SUM(AMOUNT) FOR Productid IN([1], [2], [3], [4], [5])
) AS BB


--  Bài 4 Xử lí động các cột theo dữ liệu phát sinh
--từ select chuyển về chuỗi tạo 1 biến , @_ProductList
-- lấy các trường từ cột id rồi biến thành chuỗi 

DECLARE @_ProductList NVARCHAR(100)='', @_ExeStr NVARCHAR(1000), @_ISNULLProduct NVARCHAR(1000)=''
SELECT @_ProductList = @_ProductList+'['+FORMAT(Productid, '') +'] ,' FROM #Tmp GROUP BY Productid
SET @_ProductList = LEFT(@_ProductList,LEN(@_ProductList)-1)
print @_ProductList
SELECT @_ISNULLProduct = @_ISNULLProduct + ', ISNULL(['+FORMAT(Productid, '')+'], 0) AS ['+FORMAT(Productid, '')+ ']' 
FROM #Tmp GROUP BY Productid
print @_ISNULLProduct

SET @_ExeStr = N'SELECT CustomerCode '+@_ISNULLProduct+' 
				 FROM  (SELECT CustomerCode, Amount, Productid FROm #Tmp) AS TP
						PIVOT 
						(
								SUM(Amount) FOR Productid IN ('+@_ProductList+')
						) AS T'
EXECUTE(@_ExeStr)

-- Làm lại và thêm print kiểu tĩnh , rổi exec mới =viêt sđộng 

DECLARE @_ProductList NVARCHAR(100)= '', @_ExeStr NVARCHAR(1000), @_ISNULLProduct NVARCHAR(200)=''
SELECT @_ProductList = @_ProductList + '['+ FORMAT(productid, '') + '], ' FROM #Tmp GROUP By Productid 
SET @_ProductList = LEFT(@_ProductList, Len(@_ProductList) - 1)
SELECT @_ISNULLProduct = @_ISNULLProduct + ', ISNULL(['+FORMAT(Productid, '')+ '], 0) AS ['+FORMAT(Productid, '')+ ']' 
	FROM #Tmp Group by productid 

SET @_ExeStr= N'SELECT CustomerCode '+ @_isnullproduct + ' 
				FROM (SELECT CustomerCode, Amount, productid FROM #Tmp) AS T
				PIVOT(
						SUM(Amount) FOR Productid In ('+ @_ProductList+ ')
				) AS m'
PRINT @_ExeStr
EXEC (@_ExeStr)
-- ISNULL([1],0) AS [@]
--pattition by dvt, order by mavt thif nó sắp sắp xếp đơn vị tính sắp xếp , rồi trong lhu vực đó mới sapqs xếp theo tên 
-- rank trung đáng trung số
--   rownumber sẽ tự tăng ko 

-- gias trung binh = (giá trị tồn đâu+ giá trị nhập)/(sltoon dau + slnhap)

--  Bài 5 Viết câu lênh pivot số lượng và tiền lên thành cột theo mã khách hàng , Productid, SL_CUST001,Tien_CUST001, SL_CUST002, TienCUST002


SELECT * 
FROM (SELECT Productid, 'Tien_'+ CustomerCode AS [CodeTien],'SL_'+ CustomerCode AS [CodeLuong], Amount , Quantity FROM #Tmp) AS N
PIVOT 
(
	SUM(Amount) FOR Codetien IN (Tien_CUS001, Tien_CUS002, Tien_CUS003, Tien_CUS004)
) AS PV
PIVOT
(
	SUM(Quantity) FOR CodeLuong IN (SL_CUS001, SL_CUS002, SL_CUS003, SL_CUS004)
) AS PV


-- casch 2
SELECT * 
FROM (SELECT Productid, 'Tien_'+CustomerCode AS CustomerCode, Amount FROm #Tmp 
	  UNION ALL 
	  SELECT Productid, 'SL_'+CustomerCode AS CustomerCode , Amount FROM #Tmp ) AS AA
PIVOT 
(
	SUM(AMOUNT) FOR CustomerCode IN (SL_CUS001, Tien_CUS001,SL_CUS002, Tien_CUS002,SL_CUS003, Tien_CUS003,SL_CUS004, Tien_CUS004)
) AS D

-- chuooix 
DECLARE @_StrExec NVARCHAR(2000), @_Columns NVARCHAR(256) , @_Select NVARCHAR(512) = ''
SET @_Columns = ''
SELECT @_Columns = @_Columns + ','+'SL_' +CustomerCode + ',Tien_'+ CustomerCode FROM #Tmp
GROUP BY CustomerCode 
print @_Columns

SET @_Columns = RIGHT(@_Columns, LEN(@_Columns)-1)
SELECT @_Select = @_Select+ ',' + 'ISNULL(SL_' +CustomerCode +','''') AS SL_'
	+CustomerCode + ', ISNULL(Tien_' + CustomerCode + ','''') AS Tien_' + CustomerCode FROM #Tmp
GROUP BY  CustomerCode
SET @_StrExec = 'SELECT Productid '+@_Select+' FROM (SELECT Productid, ''SL_'' + Customercode AS SL, QUantity FROM #Tmp
UNION ALL
SELECT Productid, ''Tien_'' + CustomerCode, Amount FROM #tmp) AS Tmp
PIVOT
(
	SUM(Quantity) FOR SL IN (' +@_Columns + ')
) AS pv'
print @_StrExec
EXEC (@_StrExec)





-- pivot theo thansg

DECLARE @_thang INT, @_Nam INT, @_daunam DATETIME , @_cuoinam DATETIME
SET @_Nam =2020
SET @_daunam = DATEADD(YY,@_nam-1900,0)
SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))

DECLARE @_ListMonth NVARCHAR(200)= '', @_ExeStr NVARCHAR(1300), @_ISNULLMonth NVARCHAR(400)='', @_tongsl NVARCHAR(400) = ''
SELECT @_ListMonth = @_ListMonth + '['+ FORMAT(MONTH(Ngayct), '') + '], ' FROM CT GROUP By MONTH(ngayct)
SET @_ListMonth = LEFT(@_ListMonth, Len(@_ListMonth) - 1)
SELECT @_ISNULLMonth = @_ISNULLMonth + ', ISNULL(['+FORMAT(MONTH(Ngayct), '')+ '], 0) AS ['+FORMAT(MONTH(Ngayct),'')+ ']' 
	FROM CT Group by MONTH(NgayCT)
SELECT @_tongsl = @_tongsl + '+ISNULL(['+FORMAT(MONTH(NgayCT), '')+'], 0)' FROM CT GROUP BY MONTH(NgayCT)
SET @_tongsl = RIGHT(@_Tongsl, LEN(@_tongsl) - 1)
SET	@_ExeStr ='SELECT MaVT  '+@_ISNULLMonth+' , '+@_Tongsl+' AS [SLTong]
		 FROM 	(SELECT CTCT.MaVT, MONTH(CT.Ngayct) AS [thang], SUM(CTCT.Soluong) AS [TongSL]
					FROM CTCT INNER JOIN CT ON CTCT.SoCT= CT.SoCT
					WHERE CT.LoaiCT=1 AND CT.NgayCT BETWEEN '''+FORMAT(@_daunam,'MM/dd/yy')+''' AND '''+FORMAT(@_cuoinam,'MM/dd/yy')+'''
					GROUP By CTCT.MaVT ,  MONTH(CT.Ngayct)) A
		 PIVOT 
		 (
		    	SUM(TongSL) FOR thang IN ('+@_ListMonth+')
	     ) B'

		 print @_Exestr
EXECUTE (@_exestr)


-- pivot theo quy
DECLARE @_thang INT, @_Nam INT, @_daunam DATETIME , @_cuoinam DATETIME
SET @_Nam =2020
SET @_daunam = DATEADD(YY,@_nam-1900,0)
SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))

DECLARE @_ListQuy NVARCHAR(100)= '', @_ExeStr NVARCHAR(1000), @_ISNULLQuy NVARCHAR(200)='', @_tongquy NVARCHAR(200) =''
SELECT @_ListQuy = @_ListQuy + '['+ FORMAT(DATEPART(QQ,NgayCT), '') + '], ' FROM CT GROUP By DATEPART(QQ,NgayCT)
SET @_ListQuy = LEFT(@_ListQuy, Len(@_ListQuy) - 1)
SELECT @_ISNULLQuy = @_ISNULLQuy + ', ISNULL(['+FORMAT(DATEPART(QQ,NgayCT), '')+ '], 0) AS ['+FORMAT(DATEPART(QQ,NgayCT),'')+ ']' 
	FROM CT Group by DATEPART(QQ,NgayCT)
SELECT @_Tongquy = @_tongquy + '+ ISNULL(['+FORMAT(DATEPART(QQ,NgayCT), '') +'],0)' FROM CT GROUP BY DATEPART(QQ, Ngayct)
SET @_Tongquy = RIGHT(@_Tongquy, LEN(@_tongquy)-1)
SET	@_ExeStr ='SELECT MaVT  '+@_ISNULLQuy+', '+@_tongquy+' AS [TongQuy]
		 FROM 	(SELECT CTCT.MaVT, DATEPART(QQ,NgayCT) AS [thang], SUM(CTCT.Soluong) AS [TongSL]
					FROM CTCT INNER JOIN CT ON CTCT.SoCT= CT.SoCT
					WHERE CT.LoaiCT=1 AND CT.NgayCT BETWEEN '''+FORMAT(@_daunam,'MM/dd/yy')+''' AND '''+FORMAT(@_cuoinam,'MM/dd/yy')+'''
					GROUP By CTCT.MaVT ,  DATEPART(QQ,NgayCT)) A
		 PIVOT 
		 (
		    	SUM(TongSL) FOR thang IN ('+@_ListQuy+')
	     ) B'

		 print @_Exestr
EXECUTE (@_exestr)





-- buổi 8
DECLARE @_Loaibaocao INT ,@_ma NVARCHAR(20), @_ten NVARCHAR(20), @_Str NVARCHAR(1000);
IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT CT.SoCT, CT.NgayCT, CTCT.MaVT, CT.Diengiai, CTCT.Soluong* CTCT.Dongia AS [Tien], DMDT.TenDT, DMDT.MaDT INTO #bang1
FROM CT INNER JOIN CTCT ON CT.SOCT = CTCT.SOCT
		INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT
SET @_Loaibaocao = 1
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
		SELECT '''' [SoCT], NULL AS [NgayCT], ''ZMa'' AS [MaVT], N''Tổng Cộng'', SUM(Tien) AS [Tien] FROM #bang1 ) B'
EXECUTE (@_Str)

-- cách 2 sử dụng câu lệnh if else

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


-- cash2 

IF OBJECT_ID('tempdb..#bangton') IS NOT NULL DROP TABLE #bangton
SELECT MaVT, SUM(soluong) AS [toncuoi] INTO #bangton FROM Tondau
GROUP BY MaVT
IF OBJECT_ID('tempdb..#bangps') IS NOT NULL DROP TABLE #bangps
SELECT CT.LoaiCT, CT.NgayCT, CTCT.MaVT, CT.Diengiai, 
		CASE WHEN CT.LoaiCT = 0 THEN CTCT.Soluong ELSE 0 END AS slnhap
	   ,CASE WHEN CT.LoaiCT = 1 THEN CTCT.Soluong ELSE 0 END AS slxuat 
	   , CAST(0 AS NUMERIC(15,3)) AS Toncuoi INTO #bangps
FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT

SELECT LoaiCT, NgayCT, MaVT, Diengiai, slnhap, Slxuat,
			IIF(LoaiCT = 2, 0, SUM(IIF(LoaiCT IN (0, 1), ISNULL(Toncuoi, 0) + ISNULL(slnhap, 0) - ISNULL(slxuat, 0), 0))  
		    OVER (PARTITION BY MaVT ORDER BY Mavt, LoaiCT, NgayCT ROWS UNBOUNDED PRECEDING )) AS Toncuoi FROM (

			SELECT 0 AS [Loaict], NULL AS [NgayCT], DMVT.MaVT, N'Tồn đầu kì' AS [Diengiai], 0 AS [slnhap], 0 AS [slxuat], Toncuoi 
			FROM #bangton RIGHT JOIN DMVT ON #bangton.MaVT = DMVT.MavT
			UNION ALL
			SELECT * FROM #bangps
			UNION ALL
			SELECT 2 AS [LoaiCT], NULL AS [NgayCT], MaVT, N'Tổng nhập xuât' AS [Dieniai], SUM(slnhap) AS [slnhap], SUM(slxuat) AS [slxuat], 0 AS [Toncuoi] FROM #bangps
			GROUP BY MaVT
			UNION ALL
			SELECT 3 AS [LoaiCT], NULL AS [NgayCT], MaVT, N'Tồn cuối kì' AS [Dieniai], 0 AS [slnhap], 0 AS [slxuat], 0 AS [Toncuoi] FROM #bangps
			GROUP BY MaVT
			) AS K



-- cách 2 sử dụng hàm cộng 


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



-- bài 3

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

