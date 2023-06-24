-- Phan Trung Hiếu
-- Học Viện Tài Chính 
-- Bài tập ngày 30/12/2022
-- bài tập buổi 4


--Bài 1 Hiển thị các chứng từ có phiếu xuất cso phát sinh từ ngày hiện tai đến 60 ngày trờ về trước bao gồm : soct, ngayct , loaict
--WHERE mỗi 1 dòng nó phải tính hàm ta 1 dòng nó ko tính dc index , dũ liệu nhiều ản ghi nó rất chậm , tìm mục lục của ngày 
--

DECLARE @_Ngaykt DATE
SET @_Ngaykt = DATEADD(DD, -60,GETDATE())
SELECT SoCT, NgayCT, LoaiCT FROM CT
		WHERE CT.NgayCT>=@_Ngaykt

SELECT SoCT, NgayCT, LoaiCT FROM CT
	WHERE DATEDIFF(DD, CT.NgayCT, GETDATE()) <=60
-- dug hàm where thì ko tận dụng dc indexx dẫn đến chậm 
--SELECT SoCT, Ngayct, Loaict FROM CT 
--	   WHERE DATEDIFF(DD,CT.NgayCT,GETDATE())<=60

-- Bài 2: Hiển thị ngày đầu quý và ngày cuối quý của tháng hiện tạsi

DECLARE @_dauquy DATE , @_Ngayhientai DATE ,@_cuoiquy DATE, @_Dauquysau DATE
SET @_Ngayhientai = '2021-04-06'--GETDATE()
SET @_Dauquy = DATEADD(QQ,DATEDIFF(QQ,0,@_ngayhientai),0)
SET @_dauquysau = DATEADD(QQ,1,@_Dauquy)
SET @_cuoiquy = DATEADD(DD,-1,@_dauquysau)
SELECT @_dauquy AS Dauquy, @_Cuoiquy AS CuoiQuy , @_dauquysau AS Dauquysau
-- cach 2

DECLARE @_dauquy DATE ,@_Ngayhientai DATE ,@_dauquysau DATE
SET @_Ngayhientai =  GETDATE()
SET @_Dauquy = DATEADD(QQ,DATEDIFF(QQ, 0, @_Ngayhientai),0)
SET @_Dauquysau = DATEADD(QQ, 1 ,@_Dauquy)
SELECT @_DauQuy AS Ngaydauquy, DATEADD(DD,-1,@_dauquysau) AS Ngaycuoiquy



-- Hàm emonth hiển thị ngày cuối tháng
SELECT EOMONTH('2022-01-04') AS [Cuối tháng]

-- Bài 3: Hiển thị các phiếu bán vào thứ 6 ngày 13
-- dd ngày , dw thứ , mm thấng , qq quý , yy năm , dayofyear ngày trong năm 
-- nên tạo ra 1 cột ngày tháng kiểm campus suy ra rừ trường ngàdy
-- dw = 6 hoặc 5 thì phụ thuộc cào ngôn ngữ ví dị pháp anh


SELECT soct, Ngayct, madt, loaict,diengiai, dinhchi FROM CT 
		WHERE Loaict=1 AND DATEPART(DW,Ngayct)=6 AND DATEPART(DD,NgayCT)=13

-- Bài 4 Sử dụng các hàm ngày tháng để hiện thị thông tin của bảng chứng từ 
--thêm cột tháng quý năm được tính từ cột ngày chứng tư
-- quys ko có hàm pahir dùng datepart

SELECT soct, Ngayct, madt, loaict,diengiai, dinhchi,
	DATEPART(mm,Ngayct) AS [Tháng], DATEPART(QQ,Ngayct) AS Quý, DATEPART(YY,Ngayct) AS NĂM FROM CT 

-- Bài 5: Hiển thị ngày đầu tháng, cuối tháng của ngày hiện tại và hiển thị cùng kỳ năm ngoái của ngày 
-- đầu tháng , cuối tháng vừa tính được 
DECLARE @_Ngaydauthang DATETIME , @_Ngaycuoithang DATETIME ,
@_Ngaydauthangnamngoai DATETIME , @_Ngaycuoithangnamngoai DATETIME, 
@_Ngayhientai DATE , @_khoangcachthang INT

SET @_Ngayhientai ='2021-02-14'
SET @_Ngaydauthang = DATEADD(DD, -DAY(@_Ngayhientai)+1,@_Ngayhientai)
SET @_Ngaycuoithang = EOMONTH(@_Ngayhientai)
SET @_Ngaydauthangnamngoai = DATEADD(YY, -1, @_Ngaydauthang)
SET @_Ngaycuoithangnamngoai = EOMONTH(@_Ngaydauthangnamngoai)

SELECT @_Ngaydauthang [Ngày đầu tháng], @_Ngaycuoithang [Ngày cuối tháng] ,
				@_Ngaydauthangnamngoai [Ngày đầu tháng năm ngoái] ,
				@_Ngaycuoithangnamngoai [Ngày cuối tháng năm ngoái]




-- WITH ROLLUP tu chen dong tổng, utung max doois tuong, 
SELECT madt, mavt, sum(soluong)
	FROM CTCT INNER JOIN CT ON CT.soct = CTCT.soct
	GROUP BY madt, mavt
	WITH CUBE 
	--WITH ROLLUP

SELECT madt, mavt, sum(soluong)
	FROM CTCT INNER JOIN CT ON CT.soct = CTCT.soct
	GROUP BY madt, mavt
	--WITH CUBE 
	WITH ROLLUP



-- hiển thj ngay đầu tháng , ngày cuối tháng , đầu tháng , cuối tháng năm trươc
DECLARE @_dauthang DATETIME, @_cuoithang DATETIME , @_ngayhientai DATETIME, @_dauthangnamtruoc DATETIME , @_Cuoithangnamtruoc DATETIME
SET @_ngayhientai = '2021-02-05'
SET @_Dauthang = DATEADD(DD,-DAY(@_ngayhientai)+1,@_ngayhientai)
SET @_cuoithang = EOMONTH(@_dauthang)
SET @_dauthangnamtruoc= DATEADD(YY,-1,@_dauthang)
SET @_cuoithangnamtruoc= EOMONTH(@_dauthangnamtruoc)
SELECT @_dauthang AS Dauthang , @_cuoithang AS Cuoithang ,@_dauthangnamtruoc AS Dauthangnamtruoc,
		@_Cuoithangnamtruoc AS Cuoithangnamtruoc

-- BÀi tập 1 Hiển thị tổng số lượng vật tư đước bán ra trong tháng 8/2020, :hai biến ngày đầu , ngày cuối tháng 
-- nhập 1 ngày bất kì trong tháng 
DECLARE @_Ngaydauthang DATETIME , @_Ngaycuoithang DATETIME ,
		@_Ngayhientai DATE
SET @_Ngayhientai='2020-08-09'
SET @_Ngaydauthang = DATEADD(DD, -DAY(@_Ngayhientai)+1,@_Ngayhientai)
SET @_Ngaycuoithang = EOMONTH(@_Ngayhientai)

SELECT  CTCT.MaVT,SUM(CTCT.Soluong) AS [Tongsl] FROM DMVT 
	INNER JOIN CTCT ON DMVT.Mavt = CTCT.Mavt 
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	WHERE CT.LoaiCT =1 AND CT.NgayCt >= @_Ngaydauthang AND CT.NgayCt <= @_Ngaycuoithang
	GROUP BY CTCT.MaVT
	


-- Bài 2 Hiển thị tống số lượng vật tư tương ứng với từng khách hàng được bán ra trong tháng 8/2020
DECLARE @_Ngaydauthang DATETIME , @_Ngaycuoithang DATETIME ,
		@_Ngayhientai DATE
SET @_Ngayhientai='2020-08-09'
SET @_Ngaydauthang = DATEADD(DD, -DAY(@_Ngayhientai)+1,@_Ngayhientai)
SET @_Ngaycuoithang = EOMONTH(@_Ngayhientai)

SELECT DMVT.MaVT,DMVT.TenVT, SUM(Soluong) AS [TongSL] FROM DMVT 
	INNER JOIN CTCT ON DMVT.Mavt = CTCT.Mavt 
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	WHERE CT.LoaiCT =1 AND CT.NgayCt >= @_Ngaydauthang AND CT.NgayCt <= @_Ngaycuoithang
	GROUP BY DMVT.MaVT,DMVT.TenVT

-- Bài 3 hiển thi thông tin vât tư tổng số lượng của vật tư những vật tư có tổng số lượng bán lớn hơn 3 nghìn trong tháng bất kì truyền vào 
DECLARE @_Ngaydauthang DATETIME , @_Ngaycuoithang DATETIME ,
		@_Ngayhientai DATE
SET @_Ngayhientai='2020-08-09'
SET @_Ngaydauthang = DATEADD(DD, -DAY(@_Ngayhientai)+1,@_Ngayhientai)
SET @_Ngaycuoithang = EOMONTH(@_Ngayhientai)

SELECT DMVT.MaVT, DMVT.TenVT, DMVT.LoaiVT, DMVT.DinhChi, SUM(CTCT.Soluong) AS [So Luong Ban] FROM DMVT
	INNER JOIN CTCT ON DMVT.MaVT = CTCT.MaVT
	INNER JOIN CT ON CTCT.SoCT = CT.SoCT
	WHERE CT.LoaiCT=1 AND CT.NgayCt >= @_Ngaydauthang AND CT.NgayCt <= @_Ngaycuoithang
	GROUP BY DMVT.MaVT, DMVT.TenVT, DMVT.LoaiVT, DMVT.DinhChi 
	HAVING SUM(CTCT.Soluong) >3000

-- Bài 4 Hiển thị 10 khách hàng có đại chỉ tại Hà nội

SELECT DISTINCT  TOP 10 DMDT.MaDT, DMDT.TenDT, DMDT.DiaChi, DMDT.NgayBD, DMDT.NgayKT FROM DMDT 
	WHERE  DMDT.Diachi LIKE  =N'Hà Nội'

-- Bài 5 Hiển thị tổng số lượng của từng vật tư được bán trong từng tháng trong năm 2021

DECLARE @_thang INT, @_Nam INT, @_daunam DATETIME , @_cuoinam DATETIME
SET @_Nam =2020
SET @_daunam = DATEADD(YY,@_nam-1900,0)
SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))

SELECT CTCT.MaVT, MONTH(CT.NgayCT) AS THANG, SUM(CTCT.Soluong) AS TongSL 
	FROM CTCT INNER JOIN CT ON CTCT.SoCT= CT.SoCT
	WHERE CT.LoaiCT=1 AND CT.NgayCT >= @_daunam AND CT.NgayCT <= @_cuoinam
	GROUP By CTCT.MaVT , MONTH(CT.NgayCT)
	WITH CUBE


	-- group by theo năm thì nó hiện thông tin từng năm thàn thì hiện thông tin theo từng tháng
-- ham pivot table 
-- bên dưới group by theo tháng thì nó hiện theo từng tháng, thì thông tin hiện 12 tháng
-- lập báo cao 12 tháng am pivot
DECLARE @_nam INT , @_daunam DATETIME , @_cuoinam DATETIME ;
SET @_nam = 2020;
SET @_daunam = DATEADD(YY, @_nam -1900, 0);
SET @_cuoinam = DATEADD(DD, -1,DATEADD(YY, 1 , @_daunam))

SELECT MaVT, ISNULL([1],0) AS'Thang 1', ISNULL([2],0) AS 'Thang 2', ISNULL([3],0) AS 'Thang3', ISNULL([4],0) AS'Thang 4',
			 ISNULL([5],0) AS'Thang 5', ISNULL([6],0) AS'Thang 6', ISNULL([7],0) AS'Thang 7',ISNULL([8],0) AS 'Thang 8',
			 ISNULL([9],0) AS 'Thang 9', ISNULL([10],0) AS'Thang 10', ISNULL([11],0) AS'Thang 11', ISNULL([12],0) AS'Thang 12',
			 ISNULL([1],0)+ ISNULL([2],0)+ ISNULL([3],0)+ISNULL([4],0)+ ISNULL([5],0)+ ISNULL([6],0)+ ISNULL([7],0)+
			 ISNULL([8],0)+ ISNULL([9],0)+ ISNULL([10],0)+ ISNULL([11],0)+ ISNULL([12],0) AS 'Tong 12 thang'
FROM (SELECT CTCT.MaVT , MONTH(CT.NgayCT) AS 'Thang', SUM(CTCT.Soluong) AS 'Tongsl' FROM CT
		INNER JOIN CTCT ON CT.SoCT= CTCT.SoCT
		WHERE CT.LoaiCT = 1 AND CT.NgayCT BETWEEN @_daunam AND @_cuoinam
		GROUP BY MONTH(CT.NgayCT), CTCT.MaVT) A
PIVOT
(
	SUM(TongSL) FOR Thang IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) B


-- dữ liệu 4 quý 1 năm , vì null cộng 1 số vẫn bằng null nên chuyển về 0 để cộng
DECLARE @_thang INT, @_Nam INT, @_daunam DATETIME , @_cuoinam DATETIME
SET @_Nam =2020
SET @_daunam = DATEADD(YY,@_nam-1900,0)
SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))

SELECT MaVT ,ISNULL([1],0) AS 'Quý 1',ISNULL([2],0) AS 'Quý 2',ISNULL([3],0) AS 'Quý 3',ISNULL([4],0) AS 'Quý 4' ,
			ISNULL([1],0) +ISNULL([2],0)+ISNULL([3],0)+ISNULL([4],0) AS 'Tổng 4 Quý'    -- ko dc ddeer ctct.mavt vậy sẽ sai
FROM 	(SELECT CTCT.MaVT, DATEPART(QQ,CT.NgayCT) AS 'QUY', SUM(CTCT.Soluong) AS 'TongSL '
			FROM CTCT INNER JOIN CT ON CTCT.SoCT= CT.SoCT
			WHERE CT.LoaiCT = 1 AND CT.NgayCT >= @_daunam AND CT.NgayCT <= @_cuoinam
			GROUP By CTCT.MaVT , DATEPART(QQ,CT.NgayCT)) A
PIVOT 
(
	SUM(TongSL) FOR QUY IN ([1],[2],[3],[4])
) B

-- pivot theo thasng

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

-- pivot tho quý 
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

-- rank
DECLARE @_thang INT, @_Nam INT, @_daunam DATETIME , @_cuoinam DATETIME
SET @_Nam =2020
SET @_daunam = DATEADD(YY,@_nam-1900,0)
SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))

SELECT CTCT.MaVT, MONTH(CT.NgayCT) AS THANG, SUM(CTCT.Soluong) AS TongSL 
--	, RANK() OVER (ORDER BY SUM(CTCT.Soluong) ASC) AS [Name rank]
	, RANK() OVER (ORDER BY SUM(CTCT.Soluong) ASC) AS [Name rank quantity]

	FROM CTCT INNER JOIN CT ON CTCT.SoCT= CT.SoCT
	--WHERE CT.LoaiCT=1 AND CT.NgayCT >= @_daunam AND CT.NgayCT <= @_cuoinam
	WHERE CT.LoaiCT=1 AND CT.NgayCT BETWEEN @_daunam AND @_cuoinam
	GROUP By CTCT.MaVT , MONTH(CT.NgayCT)

