

/*Bài 1: Tạo biến kiểu ngày. Truyền vào 1 ngày bất kì. Select kết quả trả ra ngày đầu tháng và ngày cuối tháng của ngày truyền vào.*/
DECLARE @_Ngaynhap DATE, @_ngaydauthang DATE, @_Ngaycuoithang DATE
SET @_Ngaynhap ='10-20-2023'
SET @_ngaydauthang = DATEADD(DD, - DAY(@_ngaynhap) + 1 , @_Ngaynhap)
SET @_Ngaycuoithang = EOMONTH(@_ngaydauthang)
SELECT @_ngaydauthang AS N'Ngày đầu tháng', @_ngaycuoithang AS N'Ngày cuối tháng'

/*Bài 2: Cho bảng dữ liệu như sau: */
IF OBJECT_ID('TempDb..#ctct') IS NOT NULL DROP TABLE #ctct;
CREATE TABLE #CTCT
(
	So_CT VARCHAR(10),
	Ma_VT VARCHAR(16),
	So_luong NUMERIC(19, 4),
	Don_gia NUMERIC(19, 4),
	Tien NUMERIC(19, 4)
)
SELECT * FROM #CTCT
INSERT INTO #CTCT(So_CT, Ma_VT, So_Luong, Don_Gia, Tien) VALUES ('KH001','HJI009', 10000.000, 1000, 100)
SELECT CT.Ma_VT, CT.So_Luong, CT.Don_Gia, CT.Tien AS N'Tiền thanh toán', CT.Tien/CT.So_luong AS N'Đơn giá thực tế', CT.Don_gia - (CT.Tien/CT.So_Luong) AS N'Đơn giá chênh lệch'
FROM #CTCT AS [CT]


/* Viết câu lệnh truy vấn hiển thị ma_vt, so_luong, don_gia, tt_hoa_don(tien), dg_thuc_te(tien/so_luong), dg_chenh_lech(don_gia - dg_thuc_te)*/
--Bài 2 các bạn có thể insert thêm dữ liệu để thấy rõ kết quả hơn. Sử dụng câu lệnh insert into