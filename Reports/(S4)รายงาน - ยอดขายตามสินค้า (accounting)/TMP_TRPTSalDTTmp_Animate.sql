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

	[FTBchCode] [varchar](5) NULL, --�����Ң�
	[FTBchName] [varchar](100) NULL, --�����Ң�
	[FTXsdBarCode] [varchar](25) NULL, --����⤴
	--[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](100) NULL, --�����Թ���
	[FTPgpChainName] [varchar](255) NULL, --������Թ���
	[FTPbnName]  [varchar](100) NULL, --������
	[FCXsdQtyAll] [numeric](18, 4) NULL, --�ӹǹ���
	[FCStkQty]  [numeric](18, 4) NULL, --ʵ�͡�������
	[FCSdtNetSale] [numeric](18, 4) NULL, --�ʹ���
	[FCPgdPriceRet] [numeric](18, 4) NULL, --�Ҥ�/˹���
	[FCSdtNetAmt] [numeric](18, 4) NULL,--�ʹ������
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


