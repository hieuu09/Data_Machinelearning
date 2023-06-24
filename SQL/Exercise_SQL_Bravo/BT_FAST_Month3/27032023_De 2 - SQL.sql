
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
SELECT '20120831', '0011', N'Chứng từ số 11','1111', '1311',  9119, 'BP09' 

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
go
CREATE proc trangpthtest
	@Dfrom smalldatetime,
	@DTo smalldatetime,
	@list_Dt nvarchar(1000) = '',
	@list_Cp nvarchar(1000) = ''
as begin
	print 1 
	select top 0 0 as sysorder, Ma_Bp, Dien_Giai, Tien into #tmp from #CtTmp
	/*
	select LEFT(tk_co,3), SUM(Tien) from #CtTmp where exists(select * from string_split(@list_Dt,',') where tk_co like RTRIM(value)+ '%' )
		and Ngay_Ct between @Dfrom and @DTo
		group by left(Tk_Co,3)
	select LEFT(tk_co,3), SUM(Tien) from #CtTmp a join (select * from string_split(@list_Dt,',')) b on a.Tk_Co like RTRIM(b.value) + '%'
		and Ngay_Ct between @Dfrom and @DTo
		group by left(Tk_Co,3)
	select LEFT(tk_co,3), SUM(Tien) from #CtTmp where CHARINDEX(LEFT(tk_co,3),@list_Dt) > 0
		and Ngay_Ct between @Dfrom and @DTo
		group by left(Tk_Co,3)
	*/
	insert into #tmp
	select 3, ma_bp,space(4) + '+'+ LEFT(tk_co,3), SUM(Tien) from #CtTmp where exists(select * from string_split(@list_Dt,',') where tk_co like RTRIM(value)+ '%' )
		and Ngay_Ct between @Dfrom and @DTo
		group by left(Tk_Co,3), Ma_Bp

	insert into #tmp
	select 5, ma_bp,space(4) + '+'+ LEFT(tk_no,3), SUM(Tien) from #CtTmp where exists(select * from string_split(@list_Cp,',') where tk_no like RTRIM(value)+ '%' )
		and Ngay_Ct between @Dfrom and @DTo
		group by left(Tk_No,3), Ma_Bp
	
	--
	
	insert into #tmp
	select 2, b.Ma_Bp,space(2) + N'Doanh thu', isnull(SUM(Tien),0) from #tmp a right join (select distinct ma_bp from #tmp)b on a.Ma_Bp = b.Ma_Bp and sysorder = 3
		group by  b.Ma_Bp
	insert into #tmp
	select 4, b.Ma_Bp,space(2) + N'Chi phí', isnull(SUM(Tien),0) from #tmp a right join (select distinct ma_bp from #tmp)b on a.Ma_Bp = b.Ma_Bp and sysorder = 5
		group by  b.Ma_Bp
	insert into #tmp
	select 6, a.ma_bp,space(2) + N'Lợi nhuận', a.Tien - b.Tien from  #tmp a join #tmp b on a.Ma_Bp = b.Ma_Bp and a.sysorder = 2 and b.sysorder = 4

	---
	insert into #tmp 
	select 1,Ma_Bp, Ten_Bp, 0 from #DmBp where Ma_Bp in (select Ma_Bp from #tmp)
	
	select Dien_Giai as [Nội dung], case when sysorder = 1 then '' else LTRIM(tien) end as [Giá trị] from #tmp order by Ma_Bp, sysorder
	--
	--SELECT * FROM ( SELECT sysorder, Dien_Giai, Tien, Ma_Bp from #tmp WHERE sysorder >1) as InTable
	--		PIVOT (SUM( tien) FOR ma_bp IN (BP01, BP02,BP05)) AS PivotTable order by sysorder

	--
	declare @q nvarchar(1000)='', @list_bp nvarchar(1000) = '', @list_header nvarchar(1000) = ''
	select @list_bp = @list_bp + case when @list_bp = '' then '' else ',' end + ma_bp from #tmp group by Ma_Bp
	select @list_header = @list_header + case when @list_header = '' then '' else ',' end + 'isnull('+ma_bp+',0) as '+Ma_Bp from #tmp group by Ma_Bp

	select @q = N'SELECT Dien_giai as [Nội dung], '+@list_header+' FROM ( SELECT sysorder, Dien_Giai, tien, Ma_Bp from #tmp WHERE sysorder >1) as InTable
			PIVOT (SUM( tien) FOR ma_bp IN ('+ltrim(@list_bp)+')) AS PivotTable order by sysorder'
	exec sp_executesql @q
end
go
exec trangpthtest '20120801', '20120830', '5111,512,521', '641,642,622'
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
	Lợi nhuận		|	-12000	|	13000	|	5000

	*/
