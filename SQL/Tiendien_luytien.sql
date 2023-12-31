USE [Release_FBOSP2264_App]
GO
/****** Object:  StoredProcedure [dbo].[Reporst_Final]    Script Date: 25/06/2023 10:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[Reporst_Final]
		@nhom BIT,
		@ma_kh NVARCHAR(8),
		@thang INT,
		@nam INT
AS
BEGIN 
		DECLARE @a NUMERIC(10, 3), @b  NUMERIC(10, 3), @c  NUMERIC(10, 3) , @d INT, @e  NUMERIC(10, 3) , @f  NUMERIC(10, 3), @Key VARCHAR(1000), @Str NVARCHAR(2000)
		SET @a = 50 *1.484
		SET @b = 50*1.533 + 50 *1.484
		SET @c = 100*1.786 + 50*1.533 + 50 *1.484
		SET @d = 100*2.242 + 100*1.786 + 50*1.533 + 50 *1.484
		SET @e = 100*2.503 + 100*2.242 + 100*1.786 + 50*1.533 + 50 *1.484
		IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1 
		SELECT UP.ma_kh,UP.tieuthu_tu, UP.tieuthu_den, UP.tieuthu_den-UP.tieuthu_tu AS TT,UP.Thang, UP.Nam, KH.loai_kh, 
			CASE  WHEN (UP.tieuthu_den-UP.tieuthu_tu) <= 50 THEN (UP.tieuthu_den-UP.tieuthu_tu)*1.484 ELSE 0 END +
			CASE  WHEN (UP.tieuthu_den-UP.tieuthu_tu) BETWEEN 51 AND 100 THEN ((UP.tieuthu_den-UP.tieuthu_tu)-50)*1.533 + @a ELSE 0 END+
			CASE  WHEN (UP.tieuthu_den-UP.tieuthu_tu) BETWEEN 101 AND 200 THEN ((UP.tieuthu_den-UP.tieuthu_tu)-100)*1.786 + @b ELSE 0 END +
			CASE  WHEN (UP.tieuthu_den-UP.tieuthu_tu) BETWEEN 201 AND 300 THEN ((UP.tieuthu_den-UP.tieuthu_tu)-200)*2.242 + @c ELSE 0 END+
			CASE  WHEN (UP.tieuthu_den-UP.tieuthu_tu) BETWEEN 301 AND 400 THEN ((UP.tieuthu_den-UP.tieuthu_tu)-300)*2.503 + @d ELSE 0 END+
			CASE  WHEN (UP.tieuthu_den-UP.tieuthu_tu) >= 401 THEN ((UP.tieuthu_den-UP.tieuthu_tu)-400)*2.587 + @e ELSE 0 END  AS ST INTO #bang1
		FROM pth_updatett AS UP INNER JOIN pth_dmkhachhang AS KH ON KH.Ma_kh = UP.Ma_kh

		IF OBJECT_ID('tempdb..#bang2') IS NOT NULL DROP TABLE #bang2
		CREATE TABLE #bang2
		( Ma_kh VARCHAR(8), tieuthu_tu NUMERIC(10, 3), tieuthu_den NUMERIC(10, 3), TT NUMERIC(10, 3), Thang INT, nam INT, loai_kh BIT, ST NUMERIC(18, 3) )

		SET @key = CASE WHEN @Ma_kh <> '' THEN ' AND B1.Ma_kh ='''+@Ma_kh+'''' ELSE '' END
				 + CASE WHEN @thang <> 0 THEN 'AND B1.thang='+FORMAT(@thang, '0')+''   ELSE '' END
				 + CASE WHEN @nam <> 0 THEN ' AND B1.nam='+FORMAT(@nam, '0')+''   ELSE '' END

		SET @Str ='INSERT INTO #bang2 SELECT Ma_Kh, tieuthu_tu, tieuthu_den, TT, thang, nam, loai_kh, ST FROM #bang1 AS B1 WHERE 1 = 1 '+@key+''
		EXEC (@Str)

		IF (@nhom = 1)
		BEGIN 
			SELECT DISTINCT NULL AS STT, NULL AS Ma_kh,SPACE(3)+ N'DOANH NGHIỆP' AS Ten_kh, SUM(TT) AS TT, SUM(ST) AS ST, 1 AS Loai FROM #bang2 WHERE Loai_kh = 1
			UNION ALL
			SELECT ROW_NUMBER() OVER( PARTITION BY B2.Loai_KH ORDER BY B2.Loai_KH) AS STT, B2.Ma_kh,  KH.Ten_kh, B2.TT, B2.ST, B2.Loai_kh
			FROM #bang2 AS B2 INNER JOIN pth_dmkhachhang AS KH ON KH.Ma_Kh = B2.Ma_kh
			UNION ALL
			SELECT DISTINCT NULL AS STT, NULL AS Ma_kh, SPACE(3)+ N'CÁ NHÂN' AS Ten_kh, SUM(TT) AS TT, SUM(ST) AS ST, 0 AS Loai FROM #bang2 WHERE Loai_kh = 0
			ORDER BY Loai, Ma_Kh
		END
		ELSE IF (@nhom = 0)
		BEGIN 
			SELECT ROW_NUMBER() OVER (ORDER BY CONVERT(INT, RIGHT(B2.Ma_kh, LEN(B2.Ma_kh) -2))) AS STT, B2.Ma_kh,  KH.Ten_kh, B2.TT, B2.ST, B2.Loai_kh
			FROM #bang2 AS B2 INNER JOIN pth_dmkhachhang AS KH ON KH.Ma_Kh = B2.Ma_kh
			ORDER BY Ma_kh
		END

END
