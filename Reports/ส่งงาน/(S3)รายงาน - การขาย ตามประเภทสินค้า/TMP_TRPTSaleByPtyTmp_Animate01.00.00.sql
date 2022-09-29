
/****** Object:  Table [dbo].[TRPTSaleByPtyTmp_Animate]    Script Date: 28/09/2022 13:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTSaleByPtyTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTSaleByPtyTmp_Animate
GO
CREATE TABLE [dbo].[TRPTSaleByPtyTmp_Animate](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FTPtyCode]  [varchar](5) NULL, --รหัสประเภท
	[FTPtyName]  [varchar](100) NULL, --ชื่อประเภท	
	[FCXsdCostAvg] [numeric](18, 4) NULL, --ทุนขายรวม
	[FCXsdSaleTotal] [numeric](18, 4) NULL, --ยอดขายรวม
	[FCStkCostBal] [numeric](18, 4) NULL, --มูลค่าทุนคงเหลือหน้าร้าน
	[FCSalAmtBal]  [numeric](18, 4) NULL, --มูลค่าขายคงเหลือหน้าร้าน
	
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTSaleByPtyTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO



