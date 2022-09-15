/****** Object:  Table [dbo].[TRPTPSTaxMonthTmp_Animate]    Script Date: 11/09/2022 11:21:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTPSTaxMonthTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTPSTaxMonthTmp_Animate
GO
CREATE TABLE [dbo].[TRPTPSTaxMonthTmp_Animate](
--CREATE TABLE [dbo].[TRPTPSTaxHDDateTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FNAppType] [int] NULL, -- 1 : Pos, 2 : Vending
	[FTBchCode] [varchar](5) NULL, -- สาขา
	--[FTBchName] [varchar](100) NULL,

	[FTXshDocLegth] [varchar](100) NULL, -- ใบกำกับภาษี (เลขที่)
	[FTXshDocDate] [varchar](30) NULL, -- ใบกำกับภาษี  (วันที่)

	[FTCstCode] [varchar](20) NULL, 
	[FTCstName] [varchar](255) NULL, --ผู้ซื้อสินค้า/ผู้รับบริการ
	[FTXshMonthTH] [varchar](30) NULL, -- รายงานภาษีขายประจำเดือน ไทย
	[FTXshMonthEN] [varchar](30) NULL, -- รายงานภาษีขายประจำเดือน Eng

	[FTXshAddrTax] [varchar](30) NULL, --เลขประจำตัวผู้เสียภาษี
	[FCXshAmtNV] [numeric](18, 4) NULL, -- Before Vat(0%)
	[FCXshVatable] [numeric](18, 4) NULL, --Before Vat
	[FCXshVat] [numeric](18, 4) NULL, --จำนวนเงินภาษี
	[FCXshGrandAmt] [numeric](18, 4) NULL, --จำนวนเงินรวม

	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTPSTaxMonthTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO


