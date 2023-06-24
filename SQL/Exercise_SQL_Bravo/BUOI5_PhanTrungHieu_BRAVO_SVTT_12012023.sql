/*
Bài 1: Xử lý tiêu đề cột bị sai. Nếu để  [SELL 08/2020] thì truyền tháng 10 vào thì vẫn hiện tiêu đề là tháng 8. Không biết tổng số lượng này tương ứng với vật tư nào
Bài 2: mới hiện thì được tổng số lượng vật tư chứ ko iết được khách hàng nào mua vật tư nào trong tháng 8. Tiêu đề sai tương tự bài 1.
Bài 3: Làm sai kết quả rồi. GROUP theo số lượng thì không thể đúng được.
Bài 4: Địa chỉ ở Hà Nội thì chỉ cần lấy ở DMDT đâu cần đến bảng CT nên ko cần JOIN. ngoài ra thì ko dùng dấu bằng mà phải dùng LIKE.
bài 5: OKE
*/
-- Phan Trung Hiếu
-- Trường : Học Viện Tài Chính
-- Bài tập Buổi 5 12/1/2023


-- Bài tập 1 Hiển thị tổng số lượng vật tư đước bán ra trong tháng 8/2020, :hai biến ngày đầu , ngày cuối tháng 
DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATETIME , @_cuoithang DATETIME ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);

SELECT  CTCT.Mavt, SUM(CTCT.Soluong) AS [TongSL] FROM CTCT
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	--WHERE CT.LoaiCT = 1 AND CT.NgayCt >= @_dauthang AND CT.NgayCt <= @_cuoithang
	WHERE CT.LoaiCT = 1 AND CT.NgayCT BETWEEN @_dauthang AND @_cuoithang
	GROUP BY CTCT.MaVt


-- cacsh ngay 
DECLARE @_nam INT , @_thang INT, @_dauthang DATETIME
SET @_nam = 2020
SET @_thang= 8
SET @_dauthang = DATEADD(MM,@_thang-1,DATEADD(YY, @_nam-1900,0))
SELECT @_dauthang
SET @_dauthang = CONCAT(@_thang,'-01-',@_nam)

-- Bài 2 Hiển thị tống số lượng vật tư tương ứng với từng khách hàng được bán ra trong tháng 8/2020
DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATETIME , @_cuoithang DATETIME ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);

SELECT DMDT.MaDT, CTCT.MaVT, SUM(Soluong) AS [TongSL] FROM CTCT
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT
	WHERE CT.LoaiCT =1 AND CT.NgayCt >= @_dauthang AND CT.NgayCt <= @_cuoithang
	--WHERE CT.LoaiCT =1 AND CT.NgayCt BETWEEN @_dauthang AND  @_cuoithang
	GROUP BY DMDT.MaDT, CTCT.MaVT

-- Bài 3 hiển thi thông tin vât tư tổng tiền của vật tư những vật tư có tổng số lượng bán lớn hơn 3 nghìn trong tháng bất kì truyền vào 
DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATETIME , @_cuoithang DATETIME ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);

SELECT DMVT.MaVT, DMVT.TenVT , SUM(CTCT.Soluong*dongia) AS [So Luong Ban] FROM DMVT
	INNER JOIN CTCT ON DMVT.MaVT = CTCT.MaVT
	INNER JOIN CT ON CTCT.SoCT = CT.SoCT
	--WHERE CT.LoaiCT=1 AND CT.NgayCt >= @_dauthang AND CT.NgayCt <= @_cuoithang
	WHERE CT.LoaiCT=1 AND CT.NgayCT BETWEEN @_dauthang AND @_Cuoithang
	GROUP BY DMVT.MaVT, DMVT.TenVT
	HAVING SUM(CTCT.Soluong*dongia) >3000

-- cái này tổng 
-- Bài 4 Hiển thị 10 khách hàng có đại chỉ tại Hà nội

SELECT TOP 10 DMDT.MaDT, DMDT.TenDT, DMDT.DiaChi, DMDT.NgayBD, DMDT.NgayKT FROM DMDT 
	WHERE DMDT.Diachi LIKE N'%Hà Nội%'

-- Bài 5 Hiển thị tổng số lượng của từng vật tư được bán trong từng tháng trong năm 2021

DECLARE @_thang INT, @_Nam INT, @_daunam DATETIME , @_cuoinam DATETIME
SET @_Nam =2020
SET @_daunam = DATEADD(YY,@_nam-1900,0)
SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))

SELECT CTCT.MaVT, MONTH(CT.NgayCT) AS THANG, SUM(CTCT.Soluong) AS TongSL 
	FROM CTCT INNER JOIN CT ON CTCT.SoCT= CT.SoCT
	WHERE CT.LoaiCT=1 AND CT.NgayCT >= @_daunam AND CT.NgayCT <= @_cuoinam
	--WHERE CT.LoaiCT=1 AND CT.NgayCT BETWEEN @_daunam AND @_Cuoinam
	GROUP By CTCT.MaVT , MONTH(CT.NgayCT)
	WITH CUBE

-- từng tháng trong các năm 

DECLARE @_thang INT, @_Nam INT, @_daunam DATETIME , @_cuoinam DATETIME
SET @_Nam =2020
SET @_daunam = DATEADD(YY,@_nam-1900,0)
SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))

SELECT CTCT.MaVT, YEAR(CT.NgayCT) AS [nam], MONTH(CT.NgayCT) AS [THANG], SUM(CTCT.Soluong) AS [TongSL ]
	FROM CTCT INNER JOIN CT ON CTCT.SoCT= CT.SoCT
	WHERE CT.LoaiCT=1 
	--WHERE CT.LoaiCT=1 AND CT.NgayCT BETWEEN @_daunam AND @_Cuoinam
	GROUP By CTCT.MaVT , MONTH(CT.NgayCT),YEAR(CT.NgayCT) 
	ORDER BY YEAR(NgayCT) , CTCT.MaVT , MONTH(NgayCT)
	WITH CUBE

	--WITH ROLLUP

-- bìa 2 cách làm chuỗi động 

DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATE , @_cuoithang DATE, @_ExecSTr NVARCHAR(1000) ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);
DECLARE @_Parameter NVARCHAR(500)=N'@dauthang DATE, @cuoithang DATE'

SET @_ExecStr =N'
SELECT CT.MaDT, CTCT.MaVT, SUM(Soluong) AS ['+'Thang'+FORMAT(@_thang,' 0')+'] FROM CTCT
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	WHERE CT.LoaiCT =1 AND CT.NgayCt >= @dauthang AND CT.NgayCt <= @cuoithang
	GROUP BY CT.MaDT, CTCT.MaVT'
PRINT @_Execstr
EXEC SP_EXECUTESQL @_ExecSTr,@_Parameter, @dauthang = @_dauthang, @cuoithang = @_cuoithang


-- cách 2 dễ bị ịnection

DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATE , @_cuoithang DATE, @_ExecSTr NVARCHAR(1000) ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);

SET @_ExecStr =N'
SELECT CT.MaDT, CTCT.MaVT, SUM(Soluong) AS ['+'Thang'+FORMAT(@_thang,' 0')+'] FROM CTCT
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	WHERE CT.LoaiCT =1 AND CT.NgayCt >= '''+FORMAT(@_dauthang,'MM/dd/yy')+''' 
	AND CT.NgayCt <= '''+FORMAT(@_cuoithang,'MM/dd/yy')+'''
	GROUP BY CT.MaDT, CTCT.MaVT'

PRINT @_ExecStr
EXEC (@_ExecStr)



-- cach 3 dungf betwwen
DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATE , @_cuoithang DATE, @_ExecSTr NVARCHAR(1000) ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);
SET @_ExecStr =N'
SELECT CT.MaDT, CTCT.MaVT, SUM(Soluong) AS [Thang '+FORMAT(@_thang,' 0')+' '+CHAR(47)+''+FORMAT(@_nam,' 0')+'] FROM CTCT
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	WHERE CT.LoaiCT =1 AND CT.NgayCt BETWEEN '''+FORMAT(@_dauthang,'MM/dd/yy')+''' 
	AND  '''+FORMAT(@_cuoithang,'MM/dd/yy')+'''
	GROUP BY CT.MaDT, CTCT.MaVT'
PRINT @_EXECSTR
EXEC (@_EXECSTR)


SELECT UNICODE('/')

--UNION loại trừ các trường bị trùng , đa phân dùng all, theo thứ tự ccas dấu phẩy , khác dữ liệu ko thể kết nối 
-- khi nối độ dài lỡn nhất, số lượng các cột phải bằng nhau 
-- 2 người tạo cùng 1 bảng tạm giống nhau khi refresh khác nhau
-- 1 dấu thăng mất khi đóng phiên giao dịch 
-- 2 dấu thăng mất đi khi drop table ..., thì nó ở nhiêu seation khác nhau , mất khi drop bảng hoặc restart
IF OBJECT_ID('tempdb..#tenbangntam') IS NOT NULL DROP TABLE 
		 
IF OBJECT_ID('TEMPDB..#tonkho') IS NOT NULL DROP TABLE #tonkho -- nó se tạo bảng tạm đấy neenus co 
INSERT INTO DMVt(mavt, tenvt, loaiVT) 
VALUES (N'VT02',N'caiban',1)
,(N'VT03',N'caiban''1')
,(N'VT04',N'caiban','0')
,(N'VT05',N'caiban','1')
,(N'VT06',N'caiban','1')
-- lấy các trường chính
IF OBJECT_ID('TEMPDB..#DMDT') IS NOT NULL DROP TABLE #DMDT
SELECT Madt, TenDT INTO #DMDT FROM DMDT
SELECT *FROM #DMDT
-- lấy all cấc trường bằng dấu *
IF OBJECT_ID('TEMPDB..#DMDT') IS NOT NULL DROP TABLE #DMDT
SELECT * INTO #DMDT FROM DMDT
SELECT *FROM #DMDT
-- union ccas trường 
SELECT mavt, soluong, dongia FROM CTCT
UNION 
SELeCT mavt, soluong,0 AS dongia FROM CTCT

IF OBJECT_ID('tempdb..#bangtam') IS NOT NULL DROP TABLE #bangtam
SELECT SoCT, NgayCT,Madt INTO #bangtam FROM CT -- tao 1 bangr mois dua vao bang co san
INSERT INTO #bangtam SELECT SoCT, NgayCT, MaDT FROM CT -- caau lenh sao chep du lieu
SELECT *FROM #bangtam





/* bài 1 : Hiển thị thông tin những chứng từ , sắp xếp theo thứ tự ngày chứng từ tăng dần, 
		số chững từ giảm dần, phần bôi đậm se được tăng dần*/

-- Cách 2
IF OBJECT_ID('tempdb..#tam1') IS NOT NULL DROP TABLE #tam1
SELECT NULL AS [NgayCT],'' AS [SoCT],CT.MaDT+' : '+DMDT.TenDT AS [Diengiai],'' AS [MaVT], '' AS [TenVT]
		, SUM(SoLuong) AS [Tongsoluong] ,CT.MaDT INTO #tam1 
		    FROM CT
			INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT
			INNER JOIN DMVT ON CTCT.MaVT = DMVT.MaVT 
			INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT
			GROUP BY CT.MaDT, DMDT.TenDT

SELECT NgayCT, SoCT, Diengiai,MaVT, TenVT, Tongsoluong  FROM (
	SELECT NgayCT, SOCT, DienGiai, MaVT, tenVT, Tongsoluong, MaDT FROM #tam1
	   UNION ALL
	SELECT CT.NgayCT, CT.SoCt, CT.DienGiai, CTCT.MaVT, DMVT.TenVT, CTCT.SoLuong, DMDT.MaDT FROM CT
			INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT
			INNER JOIN DMVT ON CTCT.MaVT = DMVT.MaVT 
			INNER JOIN DMDT ON CT.MaDT = DMDT.MaDT) KKKK
			ORDER BY MaDT ASC, NgayCT ASC , SOCT DESC 

-- cachs 2 anh quyen chuaw

IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT CT.NgayCT, CT.SoCT, CT.Diengiai, CTCT.MaVT, DMVT.TenVT, CTCT.SoLuong, CT.MaDT
	INTO #bang1
	FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT
	INNER JOIN DMVT ON CTCT.MaVT = DMVT.MaVT
	ORDER BY CT.NgayCT ASC, CT.SoCT DESC

SELECT TT.NgayCT, TT.SoCT, TT.Diengiai, TT.MaVT, TT.TenVT, TT.SoLuong, TT.MaDT
FROM #bang1 AS TT
UNION ALL
SELECT NULL AS [NgayCT], '' AS [SoCT], TT.MaDT + ' : '+ DMDT.TenDT AS [DienGiai], '' AS [MaVT],
			'' AS[TenVT],SUM(TT.SoLuong) AS [Soluong],TT.MaDT
	FROM #bang1 AS TT INNER JOIN DMDT ON DMDT.MaDT = TT.MaDT
	GROUP BY TT.MaDT, DMDT.TenDT

ORDER BY TT.MaDT ASC, TT.NgayCT ASC , TT.SoCT DESC

-- cần có 1 cấu select lấy các trường vì khi union , thì ko thể sắp xếp các trường ko có trong list trong tdans sách đó 

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


/*Bài 2 Hiển thị báo cáo nhập xuất dang sau : Mavt, TenVT, Tondau, Soluongnhap, Soluongxuat, Toncuoi*/
-- gom lần lượt từ đầu cho gom các nhóm trùng vào 1 bảng tam, rồi tính tổng của các trường đó vào , 
-- rồi tao 1 bảng trường 3 có các trường đơn lẻ và tổng cộng từng cái , gom vào kết hơp các bảng với nhau 
-- bảng 3 chuẩn 2 bảng tạm

IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
SELECT MaVT, Tondau, slnhap, slxuat INTO #bang1
FROM (
		SELECT MaVT, TonDau.soluong AS [TonDau], 0 AS [slnhap], 0 AS [Slxuat] FROM TonDau
		UNION ALL
		SELECT CTCT.MaVT, 0 AS [Tondau],
			CASE WHEN CT.LoaiCT = 1 THEN CTCT.SoLuong ELSE 0 END AS slnhap,
			CASE WHEN CT.LoaiCT = 0 THEN CTCT.Soluong ELSE 0 END AS slxuat
		FROM CT INNER JOIN CTCT ON CT.SoCT = CTCT.SoCT 
		) AS AA

SELECT DMVT.MaVT, DMVT.TenVT, SUM(T.Tondau) AS [Tondau],  SUM(T.slnhap) AS [slnhap], SUM(T.slxuat) AS [slxuat]
		,SUM(T.Tondau) + SUM(T.slnhap) - SUM(T.slxuat) AS [TonCuoi]
FROM #bang1 AS T INNER JOIN DMVT ON T.MaVT = DMVT.MaVT
GROUP BY DMVT.MaVT, DMVT.TenVT
UNION ALL
SELECT '' AS [MaVT], N'Tổng Cổng',SUM(Tondau), SUM(slnhap), SUM(slxuat),SUM(Tondau) + SUM(slnhap) - SUM(slxuat)   FROM #bang1


