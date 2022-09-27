
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

	[FTBarCode] [varchar](25) NULL, --����⤴
	[FTPdtCode] [varchar](25) NULL, --�����Թ���
	[FTPdtName] [varchar](200) NULL, --�����Թ���
	[FTPdtNameOth] [varchar](200) NULL, --�����Թ������ҭ����
	[FTPtyName]  [varchar](100) NULL, --������	
	[FTPbnName]  [varchar](100) NULL, --������
	[FCPdtStkSetPrice] [numeric](18, 4) NULL, --�ҤҢ��/���
	[FCPdtStkQtyIn] [numeric](18, 4) NULL, --�ӹǹ�Ѻ���
	[FCPdtStkQtySale] [numeric](18, 4) NULL, --�ӹǹ���
	[FCStkQtyBal]  [numeric](18, 4) NULL, --ʵ�͡�������
	
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



