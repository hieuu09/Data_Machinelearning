/*Bài tập: Cho bảng dữ liệu như sau: */
IF OBJECT_ID('TempDb..#ct') IS NOT NULL DROP TABLE #ct
CREATE TABLE #ct
(
	so_ct VARCHAR(10),
	ngay_ct SMALLDATETIME, 
	ma_kh VARCHAR(16), loai_ct INT,
	dien_giai NVARCHAR(256), 
	status INT
)

--status -> 0: không sử dụng; 1: sử dụng

IF OBJECT_ID('TempDb..#ctct') IS NOT NULL DROP TABLE #ctct;
CREATE TABLE #ctct
(
	so_ct VARCHAR(10),
	ma_vt VARCHAR(16), so_luong NUMERIC(19, 4),
	don_gia NUMERIC(19, 4), tien NUMERIC(19, 4)
)

INSERT INTO #ct VALUES ('CT1', '2023-05-02', 'KH01', 0, 'TAN BEO', 1)
INSERT INTO #ct VALUES ('CT2', '2023-10-04', 'KH01', 1, 'BEO NGO', 0)
INSERT INTO #ct VALUES ('CT3', '2023-03-02', 'KH02', 0, 'PHONG YEN MOC', 1)
INSERT INTO #ct VALUES ('CT4', '2023-02-02', 'KH03', 1, 'CHO BEO', 0)
INSERT INTO #ct VALUES ('CT5', '2023-01-02', 'KH05', 0, 'CHO LON', 1)
INSERT INTO #ct VALUES ('CT6', '2023-05-05', 'KH06', 1, 'LON BEO', 0)
INSERT INTO #ct VALUES ('CT7', '2023-05-05', 'KH06', 1, 'LON BEO', 0)
INSERT INTO #ct VALUES ('CT8', '2023-10-31', 'KH06', 1, 'CHO BEO', 0)

INSERT INTO #ctct VALUES ('CT1', 'VT1', 200, 2000, 4000)
INSERT INTO #ctct VALUES ('CT2', 'VT2', 20, 200, 4000)
INSERT INTO #ctct VALUES ('CT3', 'VT3', 10, 400, 2050)
INSERT INTO #ctct VALUES ('CT4', 'VT5', 2, 5, 2001)
INSERT INTO #ctct VALUES ('CT5', 'VT6', 5, 2000, 4000)
INSERT INTO #ctct VALUES ('CT6', 'VT1', 4, 10, 2001)
INSERT INTO #ctct VALUES ('CT1', 'VT5', 10, 100, 6000)
INSERT INTO #ctct VALUES ('CT2', 'VT2', 25, 300, 550)
INSERT INTO #ctct VALUES ('CT7', 'VT1', 25, 300, 550)
INSERT INTO #ctct VALUES ('CT8', 'VT1', 25, 300, 780)

--so_ct linked so_ct của #ct
--ma_ct linked ma_vt của #dmvt


/*Viết câu lệnh truy vấn hiển thị theo các dạng sau:*/
/*(1) Thống kê số lượng các loại vật tư mà khách hàng đã mua
	-----------------------------------------------------
	|  Mã khách   |    A    |    B    |   C    |    D   |   -- A,B,C,D là các mã vật tư
	-----------------------------------------------------
	|			  |         |         |        |        |
	|			  |         |		  |	       |        |
	|			  |			|         |        |        |
*/

-- bien chon doanh thu hay hay tiep
-- bai 1 bai 2 
-- Chon 1 thong ke theo so luong, cho 2 thong ke theo doanh thu, khasc thi ban phai nhap lai

/*(2) Thống kê số tiền mua hàng của khách hàng trong từng tháng của năm hiện tại
	-----------------------------------------------------
	|  Mã khách   |    A    |    B    |   C    |    D   |   -- A,B,C,D là các tháng, hiển thị đầy đủ 12 tháng
	-----------------------------------------------------
	|			  |         |         |        |        |
	|			  |         |		  |	       |        |
	|			  |			|         |        |        |
*/

/*(3) Thống kê doanh thu từng ngày của các tháng trong năm hiện tại
	-----------------------------------------------------
	|    Ngày     |    A    |    B    |   C    |    D   |   -- A,B,C,D là các tháng, hiển thị đầy đủ 12 tháng, và hiển thị đầy đủ 31 ngày
	-----------------------------------------------------
	|			  |         |         |        |        |
	|			  |         |		  |	       |        |
	|			  |			|         |        |        |
*/



-- Bai 1 va bai 2 
-- Lua chon 1 thong ke theo so luong, 2 thong ke theo doanh thu
ALTER PROC Bai12
	@_chon INT,
	@_nam INT
AS BEGIN
		DECLARE @_bien NVARCHAR(40)  ---,  @_chon INT 
		IF @_chon = 1 	
			SET @_bien = 'CTCT.So_Luong'
		ELSE IF @_chon = 2 
			SET @_bien = 'CTCT.so_luong*CTCT.Don_gia'
		ELSE SELECT  N'Bạn cần nhập lại' AS [Notification]
		DECLARE @_thang INT, @_daunam DATETIME , @_cuoinam DATETIME
		SET @_daunam = DATEADD(YY,@_nam-1900,0)
		SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))
		DECLARE @_ListMonth NVARCHAR(200)= '', @_ExeStr NVARCHAR(1300), @_ISNULLMonth NVARCHAR(400)='', @_tongsl NVARCHAR(400) = ''
		SELECT @_ListMonth = @_ListMonth + '['+ FORMAT(MONTH(Ngay_ct), '') + '], ' FROM #CT GROUP By MONTH(ngay_ct)
		SET @_ListMonth = LEFT(@_ListMonth, Len(@_ListMonth) - 1)
		SELECT @_ISNULLMonth = @_ISNULLMonth + ', ISNULL(['+FORMAT(MONTH(Ngay_ct), '')+ '], 0) AS ['+FORMAT(MONTH(Ngay_ct),'')+ ']' 
			FROM #CT GROUP BY MONTH(Ngay_CT)
		SET	@_ExeStr ='SELECT Ma_KH  '+@_ISNULLMonth+'
				 FROM 	(SELECT CT.Ma_KH, MONTH(CT.Ngay_ct) AS [thang], SUM('+@_bien+') AS [TongSL]
							FROM #CTCT AS CTCT INNER JOIN #CT AS CT ON CTCT.So_CT= CT.So_CT
							WHERE CT.Loai_CT=1 AND CT.Ngay_CT BETWEEN '''+FORMAT(@_daunam,'MM/dd/yy')+''' AND '''+FORMAT(@_cuoinam,'MM/dd/yy')+'''
							GROUP By CT.Ma_Kh ,  MONTH(CT.Ngay_ct)) A
				 PIVOT 
				 (
		    			SUM(TongSL) FOR thang IN ('+@_ListMonth+')
				 ) B'
		PRINT @_ExeStr
		EXECUTE (@_exestr)
END
GO

EXEC BAI12 1, 2023
GO





--- Bai 3

ALTER PROC Bai13
	@_nam INT
AS BEGIN
		DECLARE @_thang INT, @_daunam DATETIME , @_cuoinam DATETIME
		SET @_daunam = DATEADD(YY,@_nam-1900,0)
		SET @_cuoinam = DATEADD(DD, -1, DATEADD(YY, 1,@_daunam))
		DECLARE @_ListMonth NVARCHAR(200)= '', @_ExeStr NVARCHAR(1300), @_ISNULLMonth NVARCHAR(400)='', @_tongsl NVARCHAR(400) = ''
		SELECT @_ListMonth = @_ListMonth + '['+ FORMAT(MONTH(Ngay_ct), '') + '], ' FROM #CT GROUP By MONTH(ngay_ct)
		SET @_ListMonth = LEFT(@_ListMonth, Len(@_ListMonth) - 1)
		SELECT @_ISNULLMonth = @_ISNULLMonth + ', ISNULL(['+FORMAT(MONTH(Ngay_ct), '')+ '], 0) AS ['+FORMAT(MONTH(Ngay_ct),'')+ ']' 
			FROM #CT GROUP BY MONTH(Ngay_CT)

		SET	@_ExeStr ='SELECT Ngay  '+@_ISNULLMonth+'
				 FROM 	(SELECT DAY(CT.Ngay_CT) AS ngay , MONTH(CT.Ngay_ct) AS [thang], SUM(CTCT.Tien) AS [TongSL]
							FROM #CTCT AS CTCT INNER JOIN #CT AS CT ON CTCT.So_CT= CT.So_CT
							WHERE CT.Loai_CT=1 AND CT.Ngay_CT BETWEEN '''+FORMAT(@_daunam,'MM/dd/yy')+''' AND '''+FORMAT(@_cuoinam,'MM/dd/yy')+'''
							GROUP By MONTH(CT.Ngay_CT) ,  DAY(CT.Ngay_CT)) A
				 PIVOT 
				 (
		    			SUM(TongSL) FOR thang IN ('+@_ListMonth+')
				 ) B'
		PRINT @_Exestr
		EXECUTE (@_exestr)
END
GO
EXEC Bai13 2023
GO





		SET	@_ExeStr ='SELECT Ngay  '+@_ISNULLMonth+'
				 FROM 	(SELECT DAY(CT.Ngay_CT) AS ngay , MONTH(CT.Ngay_ct) AS [thang], SUM(CTCT.Tien) AS [TongSL]
							FROM #CTCT AS CTCT INNER JOIN #CT AS CT ON CTCT.So_CT= CT.So_CT
							WHERE CT.Loai_CT=1 AND CT.Ngay_CT BETWEEN '''+FORMAT(@_daunam,'MM/dd/yy')+''' AND '''+FORMAT(@_cuoinam,'MM/dd/yy')+'''
							GROUP By MONTH(CT.Ngay_CT) ,  DAY(CT.Ngay_CT)) A
				 PIVOT 
				 (
		    			SUM(TongSL) FOR thang IN ('+@_ListMonth+')
				 ) B'
		PRINT @_Exestr
		EXECUTE (@_exestr)
