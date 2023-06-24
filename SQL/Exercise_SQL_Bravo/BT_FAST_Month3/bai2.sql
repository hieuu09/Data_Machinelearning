
/*Bài 3: Cho bảng dữ liệu như sau: */
IF OBJECT_ID('TempDb..#dmvt') IS NOT NULL DROP TABLE #dmvt;
CREATE TABLE #dmvt
(
	Ma_vt CHAR(16), 
	Ten_vt NVARCHAR(218),
	Dvt NVARCHAR(10), 
	Loai_vt INT, 
	status INT
)
--loai_vt -> 0: dịch vụ; 1: vật tư; 2- sản phẩm
--status -> 0: không sử dụng; 1: sử dụng
INSERT INTO #DMVT(Ma_VT, Ten_Vt, DVT, Loai_VT, Status) VALUES ('VT01', N'Thước kẻ', N'cái', 1, 1)
INSERT INTO #DMVT(Ma_VT, Ten_Vt, DVT, Loai_VT, Status) VALUES ('VT02', N'Thước dây', N'cái', 1, 1)
INSERT INTO #DMVT(Ma_VT, Ten_Vt, DVT, Loai_VT, Status) VALUES ('VT03', N'Vở kẻ ngang', N'quyển', 1, 1)
INSERT INTO #DMVT(Ma_VT, Ten_Vt, DVT, Loai_VT, Status) VALUES ('VT04', N'Sổ tay', N'quyển', 2, 1)
INSERT INTO #DMVT(Ma_VT, Ten_Vt, DVT, Loai_VT, Status) VALUES ('VT05', N'Sổ cái', N'quyển', 1, 0)
--SELECT * FROM #DMVT
--SELECT DMVT.Ma_VT, DMVT.Ten_VT, DMVT.DVT, DMVT.Loai_VT, DMVT.Status
--FROM #DMVT AS DMVT

/*Viết store procduce truyền vào 2 giá trị
@list NVARCHAR(1024) -> nhận giá trị kiểu chuỗi hoặc để trắng. VD: 'A,B,C'
@type BIT -> nhận giá trị 0, 1
@trang_thai char(1) nhận gt '' hoặc '0' hoặc '1' muốn lấy toàn bộ vt, k còn sử dụng, đang sử dụng 
Yêu cầu: trả kết quá ra dữ liệu lấy từ bảng #dmvt. 
	Với biến @list = '' hiển thị toàn bộ dữ liệu bảng #dmvt. 
	Với biến @list <> ''.
		Khi @type = 0 hiển thị dữ liệu bảng #dmvt với điều kiện ma_vt bằng với các giá trị được truyền vào biến @list
		Khi @type = 1 hiển thị dữ liệu bảng #dmvt với điều kiện ten_vt bằng với các giá trị được truyền vào biến @list
*/
go
SELECT * FROM #tmp

CREATE PROC SQLb2 
	@list NVARCHAR(1024),
	@type BIT,
	@trang_thai BIT
AS BEGIN
	DECLARE @q NVARCHAR(4000), @key NVARCHAR(2000) 
	SELECT TRIM(VALUE) AS ds INTO #tmp FROM STRING_SPLIT(@list,',')
	--Key 
	SET @key = ' WHERE status = ' + RTRIM(@trang_thai)
	IF @list <> '' SET @key = @key + 
		CASE WHEN @type = 0 THEN ' AND EXISTS(SELECT * from #tmp WHERE ma_vt like ''%'' + ds + ''%'')' 
			ELSE ' AND EXISTS(SELECT * FROM #tmp WHERE ten_vt LIKE ''%'' + ds + ''%'')' 
		END
	SET @q = 'SELECT * FROM #dmvt '+ @key 
	PRINT @q
	EXEC SP_EXECUTESQL @q
END
GO
EXEC SQLb2 N'thước   ,     sổ', 1, 0
EXEC SQLb2 N' VT02   ,    VT05', 0,1

EXEC SQLb2 N'   ,    VT05', 0,1




SELECT TRIM(VALUE) AS ds INTO #tmp FROM STRING_SPLIT(@list,',')

	DECLARE @list NVARCHAR(1024), @type BIT, @trang_thai BIT
	SET @list = N'VT02, VT05'
	SET @type =0
	SET @Trang_thai =1
	DECLARE @q NVARCHAR(4000), @key NVARCHAR(2000) 
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	SELECT TRIM(VALUE) AS ds INTO #tmp FROM STRING_SPLIT(@list,',')
	--Key 
	SET @key = ' WHERE status = ' + RTRIM(@trang_thai)
	IF @list <> '' SET @key = @key + 
		CASE WHEN @type = 0 THEN ' AND EXISTS(SELECT * from #tmp WHERE ma_vt like ''%'' + ds + ''%'')' 
			ELSE ' AND EXISTS(SELECT * FROM #tmp WHERE ten_vt LIKE ''%'' + ds + ''%'')' 
		END
	SET @q = 'SELECT * FROM #dmvt '+ @key 
	PRINT @q
	EXEC SP_EXECUTESQL @q
	