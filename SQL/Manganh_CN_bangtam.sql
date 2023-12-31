USE [Release_FBOSP2264_App]
GO
/****** Object:  StoredProcedure [dbo].[Baocao4]    Script Date: 25/06/2023 9:58:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





















ALTER PROCEDURE [dbo].[Baocao4]
		@nam_hoc INT,
		@Hoc_ky INT,
		@ma_nganh VARCHAR(8),
		@ma_cn VARCHAR(8), 
		@ma_dvcs VARCHAR(8)
AS
BEGIN
	DECLARE  @_key NVARCHAR(300), @_str NVARCHAR(2000)
	SET @_key = CASE WHEN @Ma_nganh <> '' THEN ' AND DK.Ma_nganh ='''+@Ma_nganh+'''' ELSE '' END
			  + CASE WHEN @nam_hoc <> 1900 THEN 'AND DK.Nam_hoc ='+FORMAT(@nam_hoc, '0')+''   ELSE '' END
	   		  + CASE WHEN @hoc_ky <> 0 THEN ' AND DK.Hoc_ky = '+FORMAT(@hoc_ky, '0')+'' ELSE '' END
			  + CASE WHEN @ma_cn <> '' THEN ' AND DK.Ma_cn = '''+@ma_cn+'''' ELSE '' END
			  + CASE WHEN @ma_dvcs <> '' THEN ' AND DV.Ma_dvcs = '''+@ma_dvcs+''' ' ELSE '' END

	IF OBJECT_ID('tempdb..#bang1') IS NOT NULL DROP TABLE #bang1
	CREATE TABLE #bang1 
	(
			ma_mh VARCHAR(8), Ten_mh NVARCHAR(200), SL INT, Ma_nganh VARCHAR(8), Ma_cn VARCHAR(8)
	)
	-- trong Store thi ko viet dc copy nen can phai co bang moi insert dc 
	SET @_Str =N'
		INSERT INTO #bang1
		SELECT DK.Ma_mh, MAX(MH.Ten_mh), COUNT(*) AS SL, DK.Ma_nganh, DK.Ma_cn
		FROM b2_pth_dkmh AS DK INNER JOIN b2_pth_dmmh AS MH ON MH.Ma_mh = DK.Ma_mh
							   INNER JOIN pth_dmnh AS NH ON NH.Ma_nh = DK.ma_nganh
							   INNER JOIN dmdvcs AS DV ON DV.Ma_dvcs = NH.Ma_dvcs
							   WHERE DK.Ma_Mh = MH.Ma_mh AND DK.Ma_nganh = MH.Ma_nganh AND DK.Ma_cn = MH.Ma_CN AND 1 = 1 '+@_Key+'
		GROUP BY DK.Ma_mh, DK.Ma_nganh, DK.Ma_cn'
	PRINT @_str
	EXEC (@_str)

SELECT STT, Ma_MH, Ten_MH, SL FROM(
SELECT NULL AS STT, NULL AS Ma_MH, RTRIM(NH.ma_nh) +' - '+ MAX(NH.Ten_nh) AS Ten_MH,NULL AS SL, B1.Ma_nganh, B1.Ma_cn, 1 AS SX
	FROM #bang1 AS B1 LEFT JOIN pth_dmnh AS NH ON NH.Ma_nh = B1.ma_nganh GROUP BY NH.Ma_NH, B1.Ma_nganh, B1.Ma_cn
	UNION
	SELECT ROW_NUMBER() OVER (PARTITION BY B1.Ma_CN ORDER BY B1.Ma_CN) AS STT, B1.Ma_mh,SPACE(8)+ B1.Ten_mh, B1.SL, B1.Ma_nganh, B1.Ma_cn, 3 AS SX FROM #bang1 AS B1
	UNION
	SELECT NULL AS STT, NULL AS Ma_MH, SPACE(3)+ RTRIM(CN.ma_cn) +' - '+ RTRIM(CN.Ten_CN) AS Ten_MH,NULL AS SL, B1.Ma_nganh, CN.Ma_cn , 2 AS SX
	FROM #bang1 AS B1 LEFT JOIN b2_pth_dmcn AS CN ON CN.ma_cn = B1.ma_cn 
					  LEFT JOIN b2_pth_dmmh AS MH ON MH.Ma_MH = B1.Ma_MH
	WHERE B1.Ma_CN = CN.Ma_CN AND CN.Ma_nganh = B1.Ma_nganh ) AS B
	ORDER BY Ma_nganh, Ma_CN, SX
END
