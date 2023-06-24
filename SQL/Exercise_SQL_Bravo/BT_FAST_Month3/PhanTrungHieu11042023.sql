
-- Họ và tên: Phan Trung Hiếu
-- Ngày: 11/04/2023

CREATE DATABASE Fast1104
GO
USE Fast1104
GO
-- Bài 1 tách chuỗi thành nhóm 

CREATE PROCEDURE Truyenchuoi
	@_chuoi VARCHAR(30)
AS
BEGIN
		IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
		CREATE TABLE #bang1 (kitu VARCHAR(10))
		DECLARE @_i INT, @_n INT, @_mang VARCHAR(100)
		SET @_n = LEN(TRIM(@_chuoi))
		SET @_i = 0
		WHILE (@_i < @_n)
		BEGIN
			SET @_i = @_i +1
			SET @_mang = SUBSTRING(@_chuoi, @_i, 1)
			INSERT INTO #bang1(kitu) VALUES (@_mang)
		END
		SELECT kitu, COUNT(*) AS Solanxuathien
		FROM #bang1
		GROUP BY kitu
END
EXEC truyenchuoi 'trrrfthh423'

-- Bài 2 xoay dữ liệu trong SQL 
CREATE TABLE #Bai2
(
	Mavt VARCHAR(10),
	Makho VARCHAR(10),
	Soluong INT
)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT1', 'K1', 10)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT2', 'K2', 12)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT3', 'K3', 11)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT4', 'K1', 14)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT1', 'K3', 15)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT1', 'K4', 15)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT1', 'K5', 15)
INSERT INTO #bai2(MaVT, Makho, Soluong) VALUES ('VT6', 'K10', 25)

ALTER PROCEDURE Origin
	@_chuoi VARCHAR(100)
AS 
BEGIN
		DECLARE @_chuoiisnull NVARCHAR(200) = '', @_Str NVARCHAR(500),  @_chuoi1 VARCHAR(100) = ''
	    IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
		IF (@_chuoi = '')
				SELECT @_chuoi = @_chuoi +', '+ Makho FROM #bai2 GROUP BY makho 
		ELSE SET @_chuoi= ', ' + @_chuoi
		SET @_chuoi = RIGHT(@_chuoi, LEN(@_chuoi)-1)
		--SET @_chuoiisnull = ', ISNULL(['+REPLACE(@_chuoi, ', ', '], 0) AS [+'REPLACE(@_chuoi, ', ', 'a')'+], ISNULL([') +'], 0)'
		SELECT TRIM(VALUE) AS ds INTO #bang1 FROM STRING_SPLIT(@_chuoi,',')

		SELECT @_chuoi1 = @_chuoi1 +', '+ds FROM #bang1
		SET @_chuoi1 = RIGHT(@_chuoi1, LEN(@_chuoi1)-1)
		SELECT @_chuoiisnull = @_chuoiisnull +', ISNULL([' + ds+'], 0) AS '+ds+' ' FROM #bang1

		SET @_str =N'SELECT MaVT '+@_chuoiisnull+' FROM
					(SELECT MaVT, MaKho, Soluong FROM #bai2) AS A
					PIVOT 
					(
						SUM(Soluong) FOR Makho IN ('+@_chuoi1+')
					) AS B'
	
		EXEC (@_str)
END
EXEC Origin 'K1, K2, K3, K4'



-- Bài 3: Xử lý xóa dữ liệu sao cho còn 1 trường duy nhất
IF OBJECT_ID('tempdb..#bai3') IS NOT NULL DROP TABLE #bai3
GO
CREATE TABLE #bai3
(
	Mavt VARCHAR(10),
	MaKho VARCHAR(5),
	MaLo VARCHAR(5),
	Mavitri VARCHAR(5),
	Soluong INT
)
GO
INSERT INTO #bai3(Mavt, Makho, Malo, Mavitri, Soluong) VALUES('VT1', 'K1', 'LO1', 'A12', 12)
INSERT INTO #bai3(Mavt, Makho, Malo, Mavitri, Soluong) VALUES('VT1', 'K1', 'LO1', 'A12', 13)
INSERT INTO #bai3(Mavt, Makho, Malo, Mavitri, Soluong) VALUES('VT1', 'K2', 'LO1', 'A12', 13)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT1', 'K2', 'LO1', 'A12', 12)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT1', 'K1', 'LO1', 'A12', 12)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT2', 'K1', 'LO1', 'A12', 15)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT2', 'K2', 'LO1', 'A12', 17)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT2', 'K2', 'LO1', 'A12', 17)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT2', 'K2', 'LO1', 'A12', 17)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT2', 'K2', 'LO1', 'A12', 17)
INSERT INTO #bai3(Mavt, Makho, Malo,  Mavitri,Soluong) VALUES('VT2', 'K2', 'LO1', 'A12', 18)
GO

WITH Bai3 AS 
(		-- cần phải gom nhóm all các trường trùng nhau, để xóa ko có trường giống mã những khác soluong j vẫn xóa
		SELECT MaVT, MaKho, MaLo, Mavitri, Soluong, 
			ROW_NUMBER() OVER (PARTITION BY MaVT, Makho, Malo, Mavitri, Soluong 
							   ORDER BY MaVT) AS STT -- đánh số thứ tự trùng nhau vẫn đánh theo thứ tự tăng dần
		FROM #bai3
)
DELETE FROM bai3 WHERE STT >1 -- hai lệnh cần đông thời thực hiện
SELECT * FROM #bai3

-- BÀi 4: Mã vật tư, tên vật tư đếm cho mỗi bên dực 5 -- sai phai them cot stt
IF OBJECT_ID('tempdb..#bai4') IS NOT NULL DROP TABLE #bai4
CREATE TABLE #bai4
(
	Mavt VARCHAR(5),
	TenVT NVARCHAR(100),
)
-- bo sttt
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT1', N'Tên vật tư 1')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT2', N'Tên vật tư 2')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT3', N'Tên vật tư 3')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT4', N'Tên vật tư 4')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT5', N'Tên vật tư 5')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT6', N'Tên vật tư 6')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT7', N'Tên vật tư 7')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT8', N'Tên vật tư 8')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT9', N'Tên vật tư 9')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT10', N'Tên vật tư 10')
INSERT INTO #bai4 (MaVT, TenVT) VALUES ('VT11', N'Tên vật tư 11')

SELECT * FROM #bai4

ALTER PROCEDURE getRecordPage1
		@_a INT,
		@_b INT
AS BEGIN 
	DECLARE @_b1 INT, @_b2 INT
	SET @_b1 = (@_a * @_b) - @_b +1
	SET @_b2 = @_b * @_a

	SELECT MaVT, TenVT 
	FROM ( SELECT MaVT, TenVT, ROW_NUMBER() OVER (ORDER BY CONVERT(INT, RIGHT(MaVT, LEN(MaVT) -2))) AS A FROM #bai4 ) AS B
	WHERE B.A BETWEEN @_b1 AND @_b2
END
GO
-- trang số, số bản ghi 1 trang
EXEC getRecordPage1 4, 1



-- Bài 5: Link server connect

EXEC SP_ADDLINKEDSERVER
    @server = 'ExcelServer2',
    @srvproduct = 'Excel',
    @provider = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc = 'C:\Users\Admin\Downloads\Thuchanh2SQL.xlsx',
    @provstr = 'Excel 12.0;IMEX=1;HDR=YES;'

SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
   'Excel 12.0;Database=C:\excel-sql-server.xlsx', [Sheet1$])

SELECT * FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0',
   'Data Source=C:\Users\Admin\Downloads\Thuchanh2SQL.xlsx;Extended Properties=Excel 12.0')...[Sheet1$]

IF OBJECT_ID('tempdb..#chungtu') IS NOT NULL DROP TABLE #Chungtu
CREATE TABLE #CHUNGTU
(
	NgayLap datetime ,
	MaVT nvarchar(10) ,
	MaQuay nvarchar(10),
	GiaBan INT NOT NULL
)
SP_CONFIGURE 'Show Advanced Options', 1;
RECONFIGURE;
GO
SP_CONFIGURE 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
--
EXEC SP_MSSET_OLEDB_PROP N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO
EXEC SP_MSSET_OLEDB_PROP N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO
--
INSERT INTO #Chungtu SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
  'Excel 12.0;Database=C:\Users\Admin\Downloads\Thuchanh2SQL.xlsx', [Sheet1$])
--
SELECT Ngaylap, MaVT, Maquay, Giaban FROM #Chungtu
ALTER PROC Giaban
(
	@_date DATETIME,
	@_mavt NVARCHAR(10),
	@_maquay NVARCHAR(10)
	)
AS
BEGIN
	SELECT TOP 1 Ngaylap, MaVT, Maquay, Giaban FROM #CHUNGTU
	WHERE NgayLap <= @_date AND MaVT= @_mavt AND MaQuay = @_maquay
	ORDER BY NgayLap DESC
END 
GO
EXEC Giaban '2016-02-01','VT2','Q1'

-- Bài 6 Tìm Khách hàng có cùng địa chỉ
-- Tìm khách hàng có cùng địa chỉ 
-- Sắp xếp lại nếu cùng tên thành phố hoặc địa chỉ thì gom vào một nhóm
IF OBJECT_ID('tempdb..#bang6') IS NOT NULL DROP TABLE #bai6
CREATE TABLE #bai6
(
	CustomerID INT,
	CustomerName NVARCHAR(50), 
	city NVARCHAR(50), 
	street NVARCHAR(100), 
	so_nha INT
)
SELECT CustomerID, CustomerName, city, street, so_nha 
FROM bai8 ORDER BY  street ASC
-- viết câu lệnh cùng thành phố
SELECT CustomerID, CustomerName, city, street, so_nha 
FROM bai8 ORDER BY  City ASC

-- Bài 7: Viết truyền vào mavt, Số lượng kết quả trả về 
IF OBJECT_ID('tempdb..#bang7') IS NOT NULL DROP TABLE #bang7
CREATE TABLE #bang7
(
	Mavt VARCHAR(10),
	Soluongtu INT,
	soluongden INT,
	Soluongkm INT,
	Vattukm VARCHAR(10),
	soluong INT
)
INSERT INTO #bang7(Mavt, Soluongtu, soluongden, soluongkm, vattukm, soluong)
VALUES  ('VT1', 1, 100, 1, '', 0),
		('VT1', 101, 200, 1, 'VTKM1', 1),
		('VT1', 201, 500, 2, 'VTKM1', 1),
		('VT1', 201, 500, 2, 'VTKM2', 1),
		('VT2', 1, 100, 0, 'VTKM1', 1),
		('VT2', 101, 300, 1, 'VTKM3', 2)

ALTER PROCEDURE Storevattukm
	@_mavt NVARCHAR(10),
	@_soluong INT
AS
BEGIN
IF OBJECT_ID('tempdb..#b11') IS NOT NULL DROP TABLE #b11
SELECT Mavt, Soluong INTO #b11 FROM (
		SELECT MaVT, COUNT(soluongkm) AS soluong
		FROM #bang7 WHERE (@_soluong BETWEEN soluongtu AND soluongden) AND MaVT = @_maVT
		GROUP BY MaVT
		UNION ALL
		SELECT vattukm, soluong 
		FROM #bang7 WHERE (@_soluong BETWEEN soluongtu AND soluongden) AND MaVT = @_mavt) AS B
SELECT Mavt, soluong FROM #b11 WHERE soluong <> 0
END
GO
EXEC Storevattukm 'VT1', 2
GO


-- Bài 8 Tính tồn cuối của mã vật tư,, mã kho
CREATE TABLE #bang8
(
	Mavt VARCHAR(5),
	MaKho VARCHAR(5),
	Dudau NUMERIC(18,3),
	Slnhap NUMERIC(18,3),
	Slxuat NUMERIC(18,3)
)
GO
delete #bang8
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K01', 100 , 12, 3)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K01', 0, 6, 0)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K01',0, 1, 50)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K02', 25, 0, 4)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K02', 0, 7, 3)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K02', 0, 2, 6)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT2', 'K02', 0, 2, 6)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K02', 0, 2, 6)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K01', 0, 2, 9)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT2', 'K12', 0, 10, 6)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT2', 'K12', 0, 9, 9)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K16', 0, 7, 9)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K16', 0, 10, 0)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT2', 'K12', 12, 23, 0)
INSERT INTO #bang8 (Mavt, MaKho, Dudau, slnhap, slxuat) VALUES ('VT1', 'K01', 0, 23, 0)
-- lan trung


alter PROCEDURE zcProcBai81
	@_mavt VARCHAR(10),
	@_makho VARCHAR(10)
AS
BEGIN
	DECLARE @_chuoi NVARCHAR(200), @_Str NVARCHAR(1000), @_key NVARCHAR(100)

	IF @_MaVT <> '' AND @_maKho <> '' SET @_key = ' WHERE MaVt LIKE N'''+@_mavt+''' AND MaKho LIKE N'''+@_makho+''''
	ELSE IF @_MaVT <> '' AND @_maKho = '' SET @_key = ' WHERE MaVt LIKE N'''+@_mavt+''''
	ELSE IF @_MaVT = '' AND @_maKho <> '' SET @_key = ' WHERE MaKho LIKE N'''+@_makho+''''
	ELSE SET @_key =''

	SET @_Str =N'
		SELECT MaVT, MaKho, Dudau, slnhap, slxuat,
			SUM(ISNULL(dudau, 0) + ISNULL(slnhap, 0) - ISNULL(slxuat, 0))
		OVER ( PARTITION BY MaVT, MaKho ORDER BY MaKho, Mavt ROWS UNBOUNDED PRECEDING ) AS Toncuoi
		FROM #bang8' + @_key
EXEC (@_Str)
END
GO
-- Chọn mã ma vật tư, chọn mã kho
EXEC zcProcBai81 '', 'k01'

-- Bài 9: Hoạt động của Trigger
CREATE TABLE KK
(
	Makhach VARCHAR(10) PRIMARY KEY,
	Tenkhach NVARCHAR(100),
	Diachi NVARCHAR(100),
	Ncc BIT,
	kk BIT
)
CREATE TABLE NCC
(
	MaKhach VARCHAR(10),
	Tenkhach NVARCHAR(50),
	Diachi NVARCHAR(100),
	Ncc BIT
)
SELECT * FROM KK
SELECT * FROM NCC
TRUNCATE TABLE KK
TRUNCATE TABLE NCC

INSERT INTO KK(Makhach, TenKhach, Diachi, Ncc, KK) 
VALUES ('KH01', N'Cong ty Fast', N'Tầng 3 - CT1B - Khu VOV - Mễ Tri', 1, 0)
INSERT INTO KK(Makhach, TenKhach, Diachi, Ncc, KK) 
VALUES ('KH02', 'Cong ty ABC', N'Hà Nội', 1,1)

INSERT INTO NCC(Makhach, Tenkhach, Diachi, Ncc) 
VALUES ('KH01', 'Cong ty Fast', N'Tầng 3 - CT1B - Khu VOV - Mễ Tri', 1)

-- thêm dữ liệu
ALTER TRIGGER Add_KK1
ON KK AFTER INSERT
AS
BEGIN	
	IF ((SELECT Ncc FROM INSERTED) = 1)
		BEGIN 
			INSERT INTO NCC (MaKhach, TenKhach, Diachi, Ncc) 
			SELECT INSERTED.MaKhach, INSERTED.TenKhach, INSERTED.Diachi, INSERTED.Ncc FROM INSERTED;
		END 
END
GO
-- cập nhật dữ liệu
ALTER TRIGGER Update_KK1
ON KK AFTER UPDATE
AS
BEGIN

	IF EXISTS (SELECT MaKhach FROM NCC WHERE MaKhach IN (SELECT Makhach FROM INSERTED))
		UPDATE NCC SET TenKhach = INSERTED.Tenkhach, Diachi = INSERTED.Diachi, NCC = INSERTED.NCC 
				   FROM INSERTED WHERE NCC.Makhach= INSERTED.MaKhach
	-- Nếu trường = 1 thì chỉnh sửa, nếu chỉnh sửa = 0 thì ko phải nhà cung cấp nên tự động xóa
	IF ((SELECT NCC FROM INSERTED) = 0)
		DELETE FROM NCC WHERE NCC.MaKhach IN (SELECT MaKhach FROM DELETED)
END

GO 
-- xóa dữ liệu
ALTER TRIGGER delete_KK1 
ON KK AFTER DELETE
AS
BEGIN
	DELETE FROM NCC WHERE NCC.MaKhach IN (SELECT Makhach FROM DELETED)
END
GO

