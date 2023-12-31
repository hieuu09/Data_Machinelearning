
--1.Tạo CSDL
-- Khach_Hang (Ma_KH, Ten_KH, MST, Gioi_Tinh) (MST: dạng ký tự không bắt buộc nhập, Gioi_Tinh kiểu INT nhận giá trị 1.Nam, 2.Nữ)
-- Hoa_Don (SoHD, Ngay, Ma_KH, Dien_Giai, TK_No, TK_Co, Tong_Tien) 

--2.Đề bài
--Câu 1. Lấy ra danh sách khách hàng
--Câu 2. Lấy ra các hóa đơn có mã khách hàng là KH01
--Câu 3. Lấy ra các hóa đơn có tổng tiền trên hóa đơn không lớn hơn 50
--Câu 4. Lấy ra các hóa đơn có mã khách hàng là KH01 và số tiền trên hóa đơn không lớn hơn 30000
--Câu 5. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc số tiền trên hóa đơn không lớn hơn 30000
--Câu 6. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc KH02 và số tiền trên hóa đơn không lớn hơn 30000
--Câu 7. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc KH02 và có năm là 2013
--Câu 8. Lấy ra các khách hàng có mã số thuế null
--Câu 9. Lấy ra các hóa đơn có diễn giải chứa kí tự Bán hàng
--Câu 10. Lấy ra các hóa đơn có diễn giải bắt đầu với kí tự Bán hàng
--Câu 11. Lấy ra các khách hàng có kí tự thứ 2 của mã khách hàng là H
--Câu 12. Lấy ra các hóa đơn có mã khách hàng là KH01 hoặc KH02 và có năm là 2013
--Câu 13. Lấy ra các khách hàng có phát sinh hóa đơn trong năm 2013 và có mã số thuế không null
--Câu 14. Lấy ra ds khách hàng và các hóa đơn phát sinh
--Câu 15. Lấy ra ds tất cả khách hàng và các hóa đơn phát sinh
--Câu 16. Lấy ra ds tất cả khách hàng và tất cả các hóa đơn phát sinh
--Câu 17. Lấy các hóa đơn có năm 2015, đẩy vào bảng tạm #HD2015
--Câu 18. Lấy tất cả các khách hàng, nếu trường MST là Null thì gán giá trị 123
--Câu 19. Lấy ra danh sách khách hàng và giới tính (1.Nam, 2 Nữ)
/*Câu 20. Viết ra báo cáo dạng sau :
xem báo cáo phát sinh doanh thu từ trong tháng 1, nhóm theo khách hàng
	|Số HD           Diễn giải			             Ngày	        Tổng tiền       KEY 
	|---------------- ----------------------        ----- -       ------------- 
	|				  KH01 - Khách hàng KH01                            7000		ma_kh
	|HD01			  Số hóa đơn : HD01 (15/01/2017)  15/01/2017        1000		
	|HD02			  Số hóa đơn : HD02 (15/01/2017)  15/01/2017        2000      
	|HD03			  Số hóa đơn : HD03 (17/01/2017)  17/01/2017        4000    
	|				  KH02 - Khách hàng KH02                            8000
	|HD05			  Số hóa đơn : HD05 (15/01/2017)  15/01/2017        1000 
	|HD06			  Số hóa đơn : HD06 (16/01/2017)  16/01/2017        3000      
	|HD07			  Số hóa đơn : HD07 (17/01/2017)  17/01/2017        4000    
	| 				  Tổng cộng			                                15000            
	|---------------- ---------------- -------------- -------------- -------------- ------------
*/
--create table hoa_don(
--	so_hd char(12),
--	ma_kh char(16),
--	ngay smalldatetime,
--	dien_giai nvarchar(4000), 
--	tong_tien numeric(16,2)
--	)
--drop table khach_hang
--select * from hoa_don
--	create table khach_hang(
--	ma_kh char(16),
--	ten_kh nvarchar(1000)
--	)

--insert into khach_hang select 'KH01',N'Khách hàng KH01'
--insert into khach_hang select 'KH02',N'Khách hàng KH02'
--insert into hoa_don select 'HD002','KH01','20170115', N'Số hóa đơn : HD02 (15/01/2017)',2000
--insert into hoa_don select 'HD003','KH01','20170117', N'Số hóa đơn : HD03 (17/01/2017)',4000
--insert into hoa_don select 'HD005','KH02','20170115', N'Số hóa đơn : HD05 (15/01/2017)',1000
--insert into hoa_don select 'HD006','KH02','20170116', N'Số hóa đơn : HD06 (16/01/2017)',3000
--insert into hoa_don select 'HD007','KH02','20170117', N'Số hóa đơn : HD07 (17/01/2017)',4000
ALTER PROC [dbo].[baocao1] 
	@ma_kh NVARCHAR(1000),-- danh sách KH muốn xem báo cáo
	@ngay_tu SMALLDATETIME, 
	@ngay_den SMALLDATETIME,
	@type char(1) -- xem theo theo nhóm hay không
AS BEGIN
	SELECT TOP 0  ma_kh, so_hd, dien_giai, ngay, tong_tien INTO #report FROM hoa_don

	INSERT INTO #report select  ma_kh, so_hd, dien_giai, ngay, tong_tien from hoa_don 
			WHERE ngay between @ngay_tu and @ngay_den and (@ma_kh = '' or CHARINDEX(ma_kh, @ma_kh)>0)
	if @type = 1 
		INSERT INTO #report
			SELECT  a.MA_KH,null, a.ma_kh + ' - '+ max(ten_kh), null, SUM(TONG_TIEN) FROM #report a left join khach_hang b ON a.ma_kh = b.ma_kh GROUP BY a.MA_KH


	INSERT INTO #report 
		SELECT 'z','',N'Tổng cộng', NULL, SUM(tong_tien) FROM #report WHERE so_hd is not null
	SELECT * FROM #report ORDER BY  ma_kh, so_hd
END
