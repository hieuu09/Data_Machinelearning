-- CTRL + R để đóng của số
-- Phan Trung Hiếu
-- Trường : Học Viện Tài Chính
-- Bài tập Buổi 6 30/1/2023

/* bài 1 : Hiển thị thông tin những chứng từ , sắp xếp theo thứ tự ngày chứng từ tăng dần, 
		số chững từ giảm dần, phần bôi đậm se được tăng dần*/
-- Cacsh 1 truy vấn quá nhiều select lấy lại bản gốc khiến nó ko dc giải phóng, nên yếu
IF OBJECT_ID('tempdb..#tam1') IS NOT NULL DROP TABLE #tam1
SELECT NULL AS [NgayCT],'' AS [SoCT],CT.MaDT+' : '+DMDT.TenDT AS [Diengiai],'' AS [MaVT], '' AS [TenVT]
		, SUM(SoLuong) AS [Tongsoluong] ,CT.MaDT INTO #tam1 
		    FROM CT
			INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT
			INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT
			GROUP BY CT.MaDT, DMDT.TenDT

SELECT NgayCT, SoCT, Diengiai,MaVT, TenVT, Tongsoluong  
FROM (
	SELECT NgayCT, SOCT, DienGiai, MaVT, tenVT, Tongsoluong, MaDT FROM #tam1
	   UNION ALL
	SELECT CT.NgayCT, CT.SoCt, CT.DienGiai, CTCT.MaVT, DMVT.TenVT, CTCT.SoLuong, DMDT.MaDT 
	FROM CT
			INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT
			INNER JOIN DMVT ON CTCT.MaVT = DMVT.MaVT 
			INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT) KKKK
	ORDER BY MaDT ASC , NgayCT ASC , SOCT DESC

-- cách 2 nó tiện khi bảng có index , tốc đpk đọc ram nhanh hơn ở ổ cưungs, bảng tạm nó giải phóng ra ổ cứng  , hdd < ss

/*Bài 2 Hiển thị báo cáo nhập xuất dang sau : Mavt, TenVT, Tondau, Soluongnhap, Soluongxuat, Toncuoi*/
-- có thể trường hợp có tồn đầu nhưng ko có nhập xuất , thì vần hiện tồn đầu
-- Quan hệ nhiều ko join dc , tạo 1 chung , đổ dữ liệu 2 bảng b
-- khi union thì không sắp xếp dc các trường ko có trong list nên cần có thêm 1 select 
IF OBJECT_ID ('tempdb.dbo.#Bang1') IS NOT NULL DROP TABLE #Bang1 
SELECT CT.MaDt, DMDT.TenDt, SUM(CTCT.SoLuong) AS Soluong 
 INTO #Bang1
 FROM CTCT INNER JOIN CT ON CT.SoCt = CTCT.SoCt
        INNER JOIN DMDT ON DMDT.MaDt = CT.MaDt
 GROUP BY CT.MaDt, DMDT.TenDt
IF OBJECT_ID ('tempdb.dbo.#Bang2') IS NOT NULL DROP TABLE #Bang2
SELECT CT.NgayCt, CT.SoCt, CT.DienGiai, CTCT.MaVt, DMVT.TenVt, CTCT.SoLuong, CT.MaDt
 INTO #Bang2
 FROM CT INNER JOIN CTCT ON CT.SoCt = CTCT.SoCt
 INNER JOIN DMVT ON DMVT.MaVt = CTCT.MaVt

SELECT NgayCT, SoCT, Diengiai,MaVT,TenVT,Soluong FROM
	(SELECT NULL AS NgayCt, '' AS SoCt, #Bang1.MaDt + ': ' + #Bang1.TenDt AS DienGiai
		 , '' AS MaVt, '' AS TenVt, #Bang1.Soluong, #Bang1.MaDt AS MaDt 
	 FROM #Bang1
	 UNION ALL
	 SELECT * FROM #Bang2 
		) a
ORDER BY MaDT ASC, NgayCT ASC , SOCT DESC

-- cách 3 có cả mã đối tượng
IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT DMDT.MaDT, DMDT.TenDT, SUM(CTCT.SoLuong) AS [Soluong] INTO #bang1
FROM CTCT INNER JOIN CT ON CTCT.SoCT = CT.SOCT
		  INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT
GROUP BY DMDT.MaDT, DMDT.TenDT
ORDER BY DMDT.MaDT
IF OBJECT_ID('tempdb..#bang2') IS NOT NULL DROP TABLE #bang2
SELECT CT.NgayCT, CT.SoCT, CT.Diengiai, DMVT.MaVT, DMVT.TenVT, CTCT.SoLuong, CT.MaDT INTO #bang2
FROM CTCT INNER JOIN CT ON CTCT.SoCT = CT.SOCT 
		  INNER JOIN DMVT ON CTCT.MaVT = DMVT.MaVT 
SELECT NULL AS [NgayCT], '' AS [SoCT], #bang1.MaDT+' : '+ #bang1.TenDT AS [Diengiai]
		, ''AS[MaVT], '' AS [TenVT],#bang1.soluong AS [soluong],#bang1.MaDT 
FROM #bang1
UNION ALL
SELECT NgayCT, SOCT, DienGiai, MaVT, TenVT,Soluong, MaDT FROM #bang2
ORDER BY MaDT ASC, NgayCT ASC, SoCT DESC
-- cách 4 tạo ra 1 bảng tạm


IF OBJECT_ID ('tempdb..#Bang3') IS NOT NULL DROP TABLE #Bang3
GO
SELECT CT.NgayCt, CT.SoCt, CT.DienGiai, CTCT.MaVt, DMVT.TenVt, CTCT.SoLuong, CT.MaDt
 INTO #Bang3
 FROM CT INNER JOIN CTCT ON CT.SoCt = CTCT.SoCt
 INNER JOIN DMVT ON DMVT.MaVt = CTCT.MaVt
 ORDER BY CT.NgayCt ASC, CT.SoCt DESC
SELECT tmp.NgayCt, tmp.SoCt, tmp.DienGiai, tmp.MaVt, tmp.TenVt, tmp.SoLuong, tmp.MaDt 
FROM #Bang3 AS tmp -- tú
UNION ALL
SELECT NULL AS NgayCt, '' AS SoCt, tmp.MaDt + ': ' + DMDT.TenDt AS DienGiai
 , '' AS MaVt, '' AS TenVt, SUM(tmp.SoLuong), tmp.MaDt AS MaDt 
FROM #Bang3 AS tmp INNER JOIN DMDT ON DMDT.MaDt = tmp.MaDt
GROUP BY tmp.MaDt, DMDT.TenDt
ORDER BY tmp.MaDt ASC, tmp.NgayCt ASC, tmp.SoCt DESC
--
IF OBJECT_ID('tempdb..#bang3') IS NOT NULL DROP TABLE #bang3
SELECT CT.NgayCT, CT.SoCT, CT.DIengiai, CTCT.MaVT, DMVT.TenVT, CTCT.SoLuong , CT.MaDT INTO #bang3
FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT 
		INNER JOIN DMVT ON CTCT.MaVT = DMVT.MaVT

SELECT NgayCT, SoCT, dienGiai, MaVT, TenVT, Soluong FROM 
		(SELECT NULL AS [NgayCT], '' AS [SoCT], DMDT.MaDT +': '+DMDT.TenDT AS [Diengiai], '' AS [MaVT],
				'' AS [TenVT], SUM(#bang3.soluong) AS [Soluong], DMDT.MaDT 
		FROM #bang3 INNER JOIN DMDT ON #bang3.MaDT = DMDT.MaDT
		GROUP BY DMDT.MaDT, DMDT.TenDT
		UNION ALL 
		SELECT NgayCT, SoCT, dienGiai, MaVT, TenVT, Soluong, maDT FROM #bang3 ) D
ORDER BY MaDT ASC, NgayCT ASC , SoCT DESC


SELECT * FROM CTCT ORDER BY MaVT


-- bài 2 : 
IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT MaVT, Tondau, slnhap, slxuat INTO #bang1
FROM (
		SELECT MaVT, TonDau.soluong AS [TonDau], 0 AS [slnhap], 0 AS [Slxuat] FROM TonDau
		UNION ALL
		SELECT CTCT.MaVT, 0 AS [Tondau],
			CASE WHEN CT.LoaiCT = 0 THEN CTCT.SoLuong ELSE 0 END AS slnhap,
			CASE WHEN CT.LoaiCT = 1 THEN CTCT.Soluong ELSE 0 END AS slxuat
		FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT 
		) AS AA

SELECT DMVT.MaVT, DMVT.TenVT, SUM(T.Tondau) AS [Tondau],  SUM(T.slnhap) AS [slnhap], SUM(T.slxuat) AS [slxuat]
		,SUM(T.Tondau) + SUM(T.slnhap) - SUM(T.slxuat) AS [TonCuoi]
FROM #bang1 AS T INNER JOIN DMVT ON T.MaVT = DMVT.MaVT
GROUP BY DMVT.MaVT, DMVT.TenVT
UNION ALL
SELECT '' AS [MaVT], N'Tổng Cổng',SUM(Tondau), SUM(slnhap), SUM(slxuat),SUM(Tondau) + SUM(slnhap) - SUM(slxuat)   FROM #bang1

-- làm lại bài 2
IF OBJECT_ID('tempdb..#bang2') IS NOT NULL DROP TABLE #bang2
SELECT MaVT, Tondau, slnhap, slxuat INTO #bang2
FROM (
		SELECT MaVT,Tondau.soluong AS [Tondau], 0 AS [slnhap],0 AS [slxuat] FROM Tondau
		UNION ALL
		SELECT CTCT.MaVT,0 AS [Tondau],
			CASE WHEN CT.LoaiCT = 0 THEN CTCT.Soluong ELSE 0 END AS [slnhap],
			CASE WHEN CT.loaiCT = 1 THEN CTCT.Soluong ELSE 0 END AS [slxuat]
		FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT 		) BB

SELECT B.MaVT, DMVT.TenVT , SUM(B.tondau) AS [Tondau], SUM(B.slnhap) AS [Slnhap], SUM(B.slxuat) AS [slxuat],
		SUM(B.Tondau) + SUM(B.slnhap)- SUM(B.slxuat) AS [Toncuoi]
FROM #bang2 AS B INNER JOIN DMVT ON B.MaVT = DMVT.MaVT
GROUP BY B.MaVT, DMVT.TenVT
UNION ALL
SELECT '',N'Tổng Cộng', SUM(Tondau),SUM(Slnhap),SUM(slxuat),SUM(Tondau)+ SUM(Slnhap) -SUM(slxuat)  FROM #bang2


-- delete khi có indentity 14 xóa , kho delete dữ liệu hết những nhập mới nó sẽ bắt đầu từ 15 ,
-- delete xóa với dk lọc dc , trunscate thì ko xóa dc all
--  truncate xóa hết hết đi thì no nhanh nhiều so với delete 

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

-- bai f a quyền thì theo customer
-- do tên cột không cho phép là số 0 , Viết sai tên cột để [] tránh kiểu kí tự , kiểu số 
-- ko cho phép tạo tên cột kiểu số 

SELECT * FROM #Tmp
PIVOT
(
	SUM(AMOUNT) FOR Productid IN([1], [2], [3], [4], [5])
) AS BB


SELECT * FROM #Tmp
PIVOT
(
	SUM(AMOUNT) FOR Productid IN([1], [2], [3], [4], [5])
) AS BB

SELECT * FROM #Tmp
PIVOT
(
	SUM(AMOUNT) FOR Productid IN([1], [2], [3], [4], [5])
) AS BB

-- bai 2 1 dòng 1, 2,3
SELECT ISNULL([1],0) AS [1], ISNULL([2],0) AS [2], ISNULL([3],0) AS [3], ISNULL([4],0) AS [4], ISNULL([5],0) AS [5] FROM #Tmp
PIVOT
(
	SUM(AMOUNT) FOR Productid IN([1], [2], [3], [4], [5])
) AS BB



DECLARE @_Product NVARCHAR(100) , @_Exec NVARCHAR(1000)
SET @_Product =N'1, 2, 3, 4, 5'
SET @_Exec = N'SELECT CustomerCode, Quantity, ['+REPLACE(@_product,', ','], [')+N'] FROM #Tmp
		PIVOT 
		(
			SUM(Amount) FOR Productid IN (['+ REPLACE(@_Product,', ','],[')+N'])
		) AS J'
EXECUTE (@_Exec)

-- đúng

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




-- pivot theo quys 

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

-- pivot theo thang
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