
/****** Object:  Table [dbo].[TRPTSalDTTmp_Animate]    Script Date: 05/09/2022 18:36:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTSaleINFOTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTSaleINFOTmp_Animate
GO
CREATE TABLE [dbo].[TRPTSaleINFOTmp_Animate](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FTBarCode] [varchar](25) NULL, --บาร์โคด
	[FTPdtCode] [varchar](25) NULL, --รหัสสินค้า
	[FTPdtName] [varchar](200) NULL, --ชื่อสินค้า
	[FTPdtNameOth] [varchar](200) NULL, --ชื่อสินค้าภาษาญี่ปุ่น
	[FTPtyName]  [varchar](100) NULL, --ประเภท	
	[FTPbnName]  [varchar](100) NULL, --ยี่ห้อ
	[FCPdtStkSetPrice] [numeric](18, 4) NULL, --ราคาขาย/ชิ้น
	[FCPdtStkQtyIn] [numeric](18, 4) NULL, --จำนวนรับเข้า
	[FCPdtStkQtySale] [numeric](18, 4) NULL, --จำนวนขาย
	[FCStkQtyBal]  [numeric](18, 4) NULL, --สต๊อกคงเหลือ
	
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTSaleINFOTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO



