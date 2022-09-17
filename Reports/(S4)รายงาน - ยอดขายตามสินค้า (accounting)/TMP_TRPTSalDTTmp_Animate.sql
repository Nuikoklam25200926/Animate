/****** Object:  Table [dbo].[TRPTSalDTTmp_Animate]    Script Date: 05/09/2022 18:36:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTSalDTTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTSalDTTmp_Animate
GO
CREATE TABLE [dbo].[TRPTSalDTTmp_Animate](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FNAppType] [int] NULL,

	[FTBchCode] [varchar](5) NULL, --รหัสสาขา
	[FTBchName] [varchar](100) NULL, --ชื่อสาขา
	[FTXsdBarCode] [varchar](25) NULL, --บาร์โคด
	--[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](100) NULL, --ชื่อสินค้า
	[FTPgpChainName] [varchar](255) NULL, --กลุ่มสินค้า
	[FTPbnName]  [varchar](100) NULL, --ยี่ห้อ
	[FCXsdQtyAll] [numeric](18, 4) NULL, --จำนวนขาย
	[FCStkQty]  [numeric](18, 4) NULL, --สต๊อกคงเหลือ
	[FCSdtNetSale] [numeric](18, 4) NULL, --ยอดขาย
	[FCPgdPriceRet] [numeric](18, 4) NULL, --ราคา/หน่วย
	[FCSdtNetAmt] [numeric](18, 4) NULL,--ยอดขายรวม
	[FTRptCode] [varchar](50) NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,	

PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTSalDTTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO


