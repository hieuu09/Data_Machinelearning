

/*Bài 1: Tạo biến dữ liệu kiểu chuỗi. Truyền vào tên của mình. Select kết quả tra họ, tên đệm, tên của biến vừa truyền vào.*/
DECLARE @_Hoten NVARCHAR(100), @_ho NVARCHAR(15), @_Tendem NVARCHAR(30), @_Ten NVARCHAR(20)
SET @_hoten = N'Phan Trung Hiếu'
SET @_Ho = LEFT(@_Hoten, CHARINDEX(' ', @_hoten, 1) -1)
SET @_Ten = RIGHT(@_hoten, CHARINDEX(' ', REVERSE(@_hoten),1 ) -1)
SET @_tendem = SUBSTRING(@_hoten,LEN(@_ho) + 2, LEN(@_hoten) -LEN(@_ho) - LEN(@_ten) - 2)
SELECT @_Ho AS [ho], @_Tendem AS [Ten dem], @_Ten AS [Ten]

/*Bài 2: Cho bảng dữ liệu như sau: */
IF OBJECT_ID('TempDb..#dmvt') IS NOT NULL DROP TABLE #dmvt;
CREATE TABLE #dmvt
(
	ma_vt VARCHAR(16),
	ten_vt NVARCHAR(218),
	dvt NVARCHAR(10), 
	loai_vt INT, status INT
)

--loai_vt -> 0: dịch vụ; 1: vật tư; 2- sản phẩm
--status -> 0: không sử dụng; 1: sử dụng

IF OBJECT_ID('TempDb..#ct') IS NOT NULL DROP TABLE #ct
CREATE TABLE #ct
(
	so_ct VARCHAR(10), 
	ngay_ct SMALLDATETIME, 
	ma_dt VARCHAR(16), loai_ct INT,
	dien_giai NVARCHAR(256), 
	status INT
)
--loai_ct -> 0: nhập; 1: xuất
--status -> 0: không sử dụng; 1: sử dụng
IF OBJECT_ID('TempDb..#ctct') IS NOT NULL DROP TABLE #ctct;
CREATE TABLE #ctct
(
	so_ct VARCHAR(10), 
	ma_vt VARCHAR(16), 
	so_luong NUMERIC(19, 4), 
	don_gia NUMERIC(19, 4),
	tien NUMERIC(19, 4)
)
--so_ct linked so_ct của #ct
--ma_ct linked ma_vt của #dmvt
/*Viết câu lệnh truy vấn hiển thị so_ct, ma_vt, so_luong, don_gia, tien, loai_vt(Dịch vụ/Vật tư/Sản phẩm) của các chứng từ đã xuất của năm hiện tại*/

DECLARE @_Ngayhientai DATE, @_Ngaydaunam DATE, @_Ngaycuoinam DATE
SET @_Ngayhientai = GETDATE()
SET @_ngaydaunam = DATEADD(YY, YEAR(@_Ngayhientai) -1900, 0)
SET @_Ngaycuoinam = DATEADD(DD, -1, DATEADD(YY, 1, @_ngaydaunam))
SELECT CT.SO_CT, CTCT.Ma_VT, CTCT.So_luong, CTCT.don_Gia, CTCT.Tien, DMVT.Loai_VT
FROM #CTCT AS CTCT INNER JOIN #CT AS CT ON CT.SO_CT = CTCT.So_CT
				   INNER JOIN #DMVT AS DMVT ON DMVT.Ma_VT= CTCT.Ma_VT
WHERE CT.Ngay_CT BETWEEN @_Ngaydaunam AND @_ngaycuoinam AND CT.Loai_CT = 1


/*Bài 3: Cho bảng dữ liệu như sau: */
IF OBJECT_ID('TempDb..#dmvt') IS NOT NULL DROP TABLE #dmvt;
CREATE TABLE #dmvt
(
	Ma_vt VARCHAR(16), 
	Ten_vt NVARCHAR(218),
	Dvt NVARCHAR(10), 
	Loai_vt INT, 
	status INT
)
INSERT INTO #DMVT(Ma_VT, Ten_Vt, DVT, Loai_VT, Status) VALUES ('HJI001', N'Nguyen van anh', 'KG', 0, 1)
SELECT * FROM #DMVT

DECLARE @_List NVARCHAR(1024), @_type BIT


SELECT DMVT.Ma_VT, DMVT.Ten_VT, DMVT.DVT, DMVT.Loai_VT, DMVT.Status
FROM #DMVT AS DMVT

--loai_vt -> 0: dịch vụ; 1: vật tư; 2- sản phẩm
--status -> 0: không sử dụng; 1: sử dụng
/*Viết store procduce truyền vào 2 giá trị
@list NVARCHAR(1024) -> nhận giá trị kiểu chuỗi hoặc để trắng. VD: 'A,B,C'
@type BIT -> nhận giá trị 0, 1
Yêu cầu: trả kết quá ra dữ liệu lấy từ bảng #dmvt. 
	Với biến @list = '' hiển thị toàn bộ dữ liệu bảng #dmvt. 
	Với biến @list <> ''.
		Khi @type = 0 hiển thị dữ liệu bảng #dmvt với điều kiện ma_vt bằng với các giá trị được truyền vào biến @list
		Khi @type = 1 hiển thị dữ liệu bảng #dmvt với điều kiện ten_vt bằng với các giá trị được truyền vào biến @list
*/

CREATE PROCEDURE Bai3
	@_list NVARCHAR(1024),
	@_Type BIT
AS BEGIN
	DECLARE @_q NVARCHAR(4000), @_key NVARCHAR(2000)
	SET @_key = 'WHERE STATUS = 1'
	IF @_List <> '' SET @_key + 
	CASE WHEN @_Type = 0 THEN 'WHERE CHARINDEX(RTRIM(Ma_VT),'''+@_List+''')>0' ELSE 'WHERE CHARINDEX(RTRIM(Ten_VT), '''+@_List+''')>0' END
	PRINT @_Key
	SET @_q = 'SELECT * FROM #DMVT' +@_key
	PRINT @_Q
	EXEC SP_EXECUTESQL @_Q
END
EXEC Bai3 'VT02', 'VT05', 0
