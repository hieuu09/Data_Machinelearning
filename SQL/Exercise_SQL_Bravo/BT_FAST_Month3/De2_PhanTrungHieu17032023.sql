
-- Cho dữ liệu có sẵn như sau:
SET NOCOUNT ON;
IF OBJECT_ID('TempDb..#CtTmp') IS NOT NULL DROP TABLE #CtTmp;
CREATE TABLE #CtTmp 
	(
		Ngay_Ct		Smalldatetime	NOT NULL DEFAULT '',
		So_Ct		NVARCHAR(20)	NOT NULL DEFAULT '',
		Dien_Giai	NVARCHAR(254)	NOT NULL DEFAULT '',
		Tk_No		NVARCHAR(16)	NOT NULL DEFAULT '',
		Tk_Co		NVARCHAR(16)	NOT NULL DEFAULT '',
		Tien		NUMERIC(18, 0)	NOT NULL DEFAULT 0,
		Ma_Bp		NVARCHAR(16)	NOT NULL DEFAULT '',
	)

DROP TABLE #CTTMP
INSERT INTO #CtTmp (Ngay_Ct, So_Ct, Dien_Giai, Tk_No, Tk_Co, Tien, Ma_Bp)
SELECT '20120802', '0001', N'Chứng từ số 1', '1311', '5111', 12000, 'BP01' UNION ALL 
SELECT '20120802', '0001', N'Chứng từ số 1', '1311', '33311', 1200, 'BP01' UNION ALL 
SELECT '20120813', '0002', N'Chứng từ số 2', '1311', '5121', 15000, 'BP01' UNION ALL 
SELECT '20120813', '0003', N'Chứng từ số 3', '6411', '1111', 11000, 'BP01' UNION ALL 
SELECT '20120814', '0004', N'Chứng từ số 4', '6421', '1121', 10000, 'BP01' UNION ALL 
SELECT '20120822', '0005', N'Chứng từ số 5', '6418', '1112', 18000, 'BP01' UNION ALL 

SELECT '20120822', '0006', N'Chứng từ số 6', '1311', '5212',  5000, 'BP05' UNION ALL 
SELECT '20120825', '0007', N'Chứng từ số 7', '1111', '5121', 12000, 'BP02' UNION ALL 
SELECT '20120831', '0008', N'Chứng từ số 8', '6211', '1521', 17000, 'BP02' UNION ALL 
SELECT '20120831', '0009', N'Chứng từ số 9', '6211', '1521', 17000, 'BP02' UNION ALL 
SELECT '20120831', '0010', N'Chứng từ số 10','1311', '5211',  9000, 'BP02'  UNION ALL 
SELECT '20120831', '0011', N'Chứng từ số 11','1111', '1311',  9119, 'BP09' UNION ALL

SELECT '20120831', '0011', N'Chứng từ số 12','1311', '5213',  9119, 'BP04' UNION ALL
SELECT '20120831', '0011', N'Chứng từ số 12','6421', '1111',  900, 'BP04'

SELECT FROM #CT
IF OBJECT_ID('TempDb..#DmBp') IS NOT NULL DROP TABLE #DmBp;
CREATE TABLE #DmBp 
	(
		Ma_Bp NVARCHAR(16) NOT NULL DEFAULT '',
		Ten_Bp NVARCHAR(128) NOT NULL DEFAULT ''
	)

INSERT INTO #DmBp (Ma_Bp, Ten_Bp)
SELECT N'BP01', N'Bộ phận 1' UNION ALL 
SELECT N'BP02', N'Bộ phận 2' UNION ALL 
SELECT N'BP03', N'Bộ phận 3' UNION ALL 
SELECT N'BP04', N'Bộ phận 4' UNION ALL 
SELECT N'BP05', N'Bộ phận 5'

SELECT * FROM #CtTmp

/*-------------------------------------
Yêu cầu: Viết query có các điều kiện truyền vào :
	+ Từ ngày...Đến ngày...
	+ Tk_DoanhThu dạng danh sách: Ví dụ [511,512,521]
	+ Tk_ChiPhi dạng danh sách: Ví dụ [641,642,622]
- Doanh thu luôn lấy phát sinh Có của các Tk trong list Tk_DoanhThu (Bỏ qua trường hợp giảm trừ)
- Chi phí luôn lấy phát sinh Nợ của các Tk trong list Tk_ChiPhi (Bỏ qua trường hợp giảm trừ)
- Lợi nhuận = Tổng doanh thu - Tổng chi phí
- Doanh thu, Chi phí chi tiết theo từng tài khoản

1/	Lên được báo cáo liệt kê chi tiết Doanh thu, Chi phí, Lợi nhuận của từng bộ phận, dạng như sau: (8 điểm)
	----------------|------------
	|   Nội dung	|  Giá trị	|
	----------------|------------
	Bộ phận 1		|	
	  Doanh thu		|	27000
		+ 511		|	12000
		+ 512		|	15000
	  Chi phí		|	39000
		+ 641		|	29000
		+ 642		|	10000
	  Lợi nhuận		|	-12000
	Bộ phận 2		|	
	  Doanh thu		|	21000
		+ 512		|	12000
		+ 521		|	9000
	  Chi phí		|	8000
		+ 642		|	8000
	  Lợi nhuận		|	13000
	Bộ phận 5		|	
	  Doanh thu		|	5000
		+ 521		|	5000
	  Chi phí		|	0
	  Lợi nhuận		|	5000
	----------------------------
*/



IF OBJECT_ID('tempdb..#doanhthu') IS NOT NULL DROP TABLE #doanhthu
SELECT BP.Ma_BP, CT.TK_Co, SUM(Tien) AS Doanhthu INTO #Doanhthu
FROM #DMBP AS BP LEFT JOIN #CTTMP AS CT ON CT.Ma_BP= BP.Ma_BP
WHERE CT.TK_Co LIKE '5%'
GROUP BY BP.Ma_BP, CT.TK_Co

IF OBJECT_ID('tempdb..#Chiphi') IS NOT NULL DROP TABLE #Chiphi
SELECT BP.Ma_BP, CT.TK_No, SUM(Tien) AS Chiphi INTO #chiphi
FROM #DMBP AS BP LEFT JOIN #CTTMP AS CT ON CT.Ma_BP= BP.Ma_BP
WHERE CT.TK_No LIKE '6%'
GROUP BY BP.Ma_BP, CT.TK_NO

SELECT Ma_BP, TK_Co AS Noidung, Doanhthu AS Tong, 3 AS STT FROM #Doanhthu
UNION ALL
SELECT Ma_BP, TK_No AS Noidung, Chiphi AS Tong, 5 AS STT FROM #chiphi
UNION ALL
SELECT Ma_BP, Ten_BP AS NOidung, 0 AS Tong, 1 AS STT FROM #DMBP
UNION ALL
SELECT Ma_BP, N'Doanh thu' AS Noidung, SUM(Doanhthu) AS Tong, 2 AS STT  FROM #Doanhthu GROUP BY Ma_BP
UNION ALL
SELECT Ma_BP, N'Chi phí' AS Noidung, SUM(chiphi) AS Tong, 4 AS STT  FROM #chiphi GROUP BY Ma_BP
UNION ALL
SELECT Ma_BP, N'Lợi nhuận' AS Noidung, SUM(doanhthu) - SUM(Chiphi) AS Tong, 6 AS STT FROM(
		SELECT Ma_BP ,CAST(0 AS NUMERIC(10,3)) AS Chiphi, SUM(Doanhthu) AS Doanhthu FROM #doanhthu GROUP BY Ma_BP
		UNION ALL
		SELECT Ma_BP, SUM(chiphi) AS Chiphi, CAST(0 AS NUMERIC(10,3)) AS Doanhthu FROM #chiphi GROUP BY Ma_BP) AS A
GROUP BY MA_BP
ORDER BY Ma_BP, STT



/*
2/	Dựa trên kết quả bài 1, lên được báo cáo dạng cột cho từng bộ phận như sau: (2 điểm)
	----------------|------------------------------------
	|   Nội dung	|	BP01	|	BP02	|	BP05	|
	----------------|------------------------------------
	Doanh thu		|	27000	|	21000	|	5000
		+ 511		|	12000	|	0		|	0
		+ 512		|	15000	|	12000	|	0
		+ 521		|	0		|	9000	|	5000
	Chi phí			|	39000	|	8000	|	0
		+ 641		|	29000	|	0		|	0
		+ 642		|	10000	|	8000	|	0
	Lợi nhuận		|	-12000	|	13000	|	5000 */


DECLARE @_ListBophan NVARCHAR(300), @_ISNULLBophan NVARCHAR(500)
SET @_ListBophan =''
SET @_Isnullbophan =''
SELECT @_ListBophan = @_listbophan +', '+ Ma_BP FROM #DMBP
SET @_ListBophan = RIGHT(@_listbophan,LEN(@_ListBophan) - 1)
SELECT @_Isnullbophan = @_Isnullbophan +', ISNULL(['+Ma_BP+'], 0) AS '+Ma_BP+'' FROM #DMBP

PRINT @_isnullbophan
SELECT 
FROM #CTTMP AS CT INNER JOIN #DMBP AS BP ON BP.Ma_BP = CT.Ma_BP



