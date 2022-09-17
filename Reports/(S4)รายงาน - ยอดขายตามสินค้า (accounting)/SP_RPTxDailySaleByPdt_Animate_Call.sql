EXEC SP_RPTxDailySaleByPdt1001002 
--ALTER PROCEDURE [dbo].[SP_RPTxDailySaleByPdt1001002] 

1,	--@pnLngID int , 
'Ada062',	--@pnComName Varchar(100),
'0000001',	--@ptRptCode Varchar(100),
'0000001',	--@ptUsrSession Varchar(255),
2,	--@pnFilterType int, --1 BETWEEN 2 IN

	----สาขา
'',	--@ptBchL Varchar(8000), --กรณี Condition IN
'',	--@ptBchF Varchar(5),
'''00001'',''00004'',''00007'',''00011''',	--@ptBchT Varchar(5),
	----Merchant
'',	--@ptMerL Varchar(8000), --กรณี Condition IN
'',	--@ptMerF Varchar(10),
'''''',	--@ptMerT Varchar(10),
	----Shop Code
'',	--@ptShpL Varchar(8000), --กรณี Condition IN
'',	--@ptShpF Varchar(10),
'''''',	--@ptShpT Varchar(10),
	----เครื่องจุดขาย
'',	--@ptPosL Varchar(8000), --กรณี Condition IN
'',	--@ptPosF Varchar(20),
'''''',	--@ptPosT Varchar(20),

'',	--@ptPdtCodeF Varchar(20),
'',	--@ptPdtCodeT Varchar(20),
'',	--@ptPdtChanF Varchar(30),
'',	--@ptPdtChanT Varchar(30),
'',	--@ptPdtTypeF Varchar(5),
'',	--@ptPdtTypeT Varchar(5),

	----NUI 22-09-05 RQ2208-020
'',	--@ptPbnF Varchar(5),
'',	--@ptPbnT Varchar(5),

'2022-07-01',	--@ptDocDateF Varchar(10),
'2022-09-05',	--@ptDocDateT Varchar(10),
	------ลูกค้า
	----@ptCstF Varchar(20),
	----@ptCstT Varchar(20),
1	--@FNResult INT OUTPUT 