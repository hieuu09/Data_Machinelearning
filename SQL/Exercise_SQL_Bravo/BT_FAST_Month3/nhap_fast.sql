CREATE DATABASE moi
GO

USE Moi
GO

CREATE TABLE MOi
(
	hoten NVARCHAR(50),
	Masv VARCHAR(10)
)
INSERT INTO Moi(masv, hoten) VALUES('KHI01',N'Nguyễn thị trâm anh')

INSERT INTO Moi(masv, hoten) VALUES('KHI02',N'Nguyễn Văn nam'),('KHI03',N'Nguyễn văn nam')

INSERT INTO Moi(masv, hoten) VALUES('KHI04',N'Nguyễn Văn ANh'),('KHI05',N'Nguyễn văn Nguyễn ANH')

SELECT * FROM Moi


SELECT hoten FROM Moi
WHERE REVERSE(hoten) LIKE N'% a%'

DECLARE @_hoten NVARCHAR(50), @_ho NVARCHAR(10), @_ten NVARCHAR(10), @_Tendem NVARCHAR(16)
SET @_hoten = N'Nguyễn Thị Vân Nam'
SET @_ten = RIGHT(@_hoten, CHARINDEX(' ',REVERSE(@_hoten),1) - 1)
--SET @_ten = LEN(@_ten)
PRINT @_ten