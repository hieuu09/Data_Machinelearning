USE [Release_FBOSP2264_App]
GO

/****** Object:  Table [dbo].[pth_dmkh]    Script Date: 24/04/2023 9:28:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[b2_pth_dmcn](
	[ma_nganh] [char](8) NOT NULL,
	[ma_cn] [char](8) NOT NULL,
	[ten_cn] [nvarchar](128) NOT NULL,
	[ten_cn2] [nvarchar](128) NULL,
	[stt_sx] [INT] NULL,
	[ghi_chu] [nvarchar](256) NULL,
	[status] [char](1) NULL,
	[datetime0] [datetime] NULL,
	[datetime2] [datetime] NULL,
	[user_id0] [int] NULL,
	[user_id2] [int] NULL,
 CONSTRAINT [PK_b2_pth_dmcn] PRIMARY KEY CLUSTERED 
(
	[ma_cn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SELECT * FROM b2_pth_dmcn
-- bai 2








USE [Release_FBOSP2264_App]
GO

/****** Object:  Table [dbo].[pth_dmkh]    Script Date: 24/04/2023 9:28:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[b2_pth_dmmh](
	[ma_nganh] [char](8) NOT NULL,
	[ma_cn] [char](8) NOT NULL,
	[ma_mh] [char](8) NOT NULL,
	[ten_mh] [nvarchar](128) NOT NULL,
	[ten_mh2] [nvarchar](128) NULL,
	[loai] [char](1) NULL,
	[so_tin_chi] [INT] NULL,
	[so_tiet] [INT] NULL,
	[ghi_chu] [nvarchar](256) NULL,
	[status] [char](1) NULL,
	[datetime0] [datetime] NULL,
	[datetime2] [datetime] NULL,
	[user_id0] [int] NULL,
	[user_id2] [int] NULL,
 CONSTRAINT [PK_b2_pth_dmmh] PRIMARY KEY CLUSTERED 
(
	[ma_mh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SELECT * FROM b2_pth_dmmh



-- bài 3

USE [Release_FBOSP2264_App]
GO

/****** Object:  Table [dbo].[pth_dmkh]    Script Date: 24/04/2023 9:28:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[b2_pth_dmmh](
	[ma_nganh] [char](8) NOT NULL,
	[ma_cn] [char](8) NOT NULL,
	[ma_mh] [char](8) NOT NULL,
	[ten_mh] [nvarchar](128) NOT NULL,
	[ten_mh2] [nvarchar](128) NULL,
	[loai] [char](1) NULL,
	[so_tin_chi] [INT] NULL,
	[so_tiet] [INT] NULL,
	[ghi_chu] [nvarchar](256) NULL,
	[status] [char](1) NULL,
	[datetime0] [datetime] NULL,
	[datetime2] [datetime] NULL,
	[user_id0] [int] NULL,
	[user_id2] [int] NULL,
 CONSTRAINT [PK_b2_pth_dmmh] PRIMARY KEY CLUSTERED 
(
	[ma_cn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SELECT * FROM b2_pth_dmcn
SELECT * FROM b2_pth_dmmh







/****** Object:  Table [dbo].[pth_dmkh]    Script Date: 24/04/2023 9:28:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[b2_pth_dkmh](
	[ma_sv] [char](8) NOT NULL,
	[ma_nganh] [char](8) NOT NULL,
	[ma_cn] [char](8) NOT NULL,
	[ma_mh] [char](8) NOT NULL,
	[ngay_dk] [DATETIME] NULL,
	[hoc_ky] [int] NOT NULL,
	[hoc_lai_yn] [char](1) NULL,

	[ghi_chu] [nvarchar](256) NULL,
	[status] [char](1) NULL,
	[datetime0] [datetime] NULL,
	[datetime2] [datetime] NULL,
	[user_id0] [int] NULL,
	[user_id2] [int] NULL,
 CONSTRAINT [PK_b2_pth_dkmh] PRIMARY KEY CLUSTERED 
(
	[ma_sv], [ma_nganh], [ma_cn], [ma_mh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SELECT * FROM b2_pth_dkmh
SELECT * FROM b2_pth_dmmh

SELECT * FROM b2_pth_dmcn





SELECT  * FROM b2_pth_dmmh


