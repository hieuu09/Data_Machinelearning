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

SELECT  SUM(CTCT.Soluong) AS [SELL 08/2020] FROM DMVT 
	INNER JOIN CTCT ON DMVT.Mavt = CTCT.Mavt 
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	WHERE CT.LoaiCT =1 AND CT.NgayCt >= @_dauthang AND CT.NgayCt <= @_cuoithang

-- Bài 2 Hiển thị tống số lượng vật tư tương ứng với từng khách hàng được bán ra trong tháng 8/2020
DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATETIME , @_cuoithang DATETIME ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);

SELECT DMVT.MaVT,DMVT.TenVT, SUM(Soluong) AS [SELL 08/2020] FROM DMVT 
	INNER JOIN CTCT ON DMVT.Mavt = CTCT.Mavt 
	INNER JOIN CT ON CTCT.Soct = CT.soCT
	WHERE CT.LoaiCT =1 AND CT.NgayCt >= @_dauthang AND CT.NgayCt <= @_cuoithang
	GROUP BY DMVT.MaVT,DMVT.TenVT

-- Bài 3 hiển thi thông tin vât tư tổng số lượng của vật tư những vật tư có tổng số lượng bán lớn hơn 3 nghìn trong tháng bất kì truyền vào 
DECLARE @_Thang INT , @_Nam INT ,@_dauthang DATETIME , @_cuoithang DATETIME ;
SET @_thang= 8;
SET @_Nam =2020;
SET @_dauthang =DATEADD(MM,(@_nam-1900)*12+@_thang-1,0);
SET @_cuoithang = EOMONTH(@_dauthang);

SELECT DMVT.MaVT, DMVT.TenVT, DMVT.LoaiVT, DMVT.DinhChi ,CTCT.SoLuong, SUM(CTCT.Soluong) AS [So Luong Ban] FROM DMVT
	INNER JOIN CTCT ON DMVT.MaVT = CTCT.MaVT
	INNER JOIN CT ON CTCT.SoCT = CT.SoCT
	WHERE CT.LoaiCT=1 AND CT.NgayCt >= @_dauthang AND CT.NgayCt <= @_cuoithang
	GROUP BY DMVT.MaVT, DMVT.TenVT, DMVT.LoaiVT, DMVT.DinhChi ,CTCT.SoLuong
	HAVING SUM(CTCT.Soluong) >3000

-- Bài 4 Hiển thị 10 khách hàng có đại chỉ tại Hà nội

SELECT DISTINCT  TOP 10 DMDT.MaDT, DMDT.TenDT, DMDT.DiaChi, DMDT.NgayBD, DMDT.NgayKT FROM DMDT 
	INNER JOIN CT ON DMDT.MaDT = CT.MaDT
	WHERE CT.LoaiCT=1 AND DMDT.Diachi =N'Hà Nội'

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
