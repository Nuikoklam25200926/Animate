EXEC SP_RPTxSaleByPty_Animate 
--ALTER PROCEDURE [dbo].[SP_RPTxDailySaleByPdt1001002] 

	1,--@pnLngID int , 
	'Ada062',--@pnComName Varchar(100),
	'000001',--@ptRptCode Varchar(100),
	'000001',--@ptUsrSession Varchar(255),
	2,--@pnFilterType int, --1 BETWEEN 2 IN

	----สาขา
	'',--@ptBchL Varchar(8000), --กรณี Condition IN
	'',--@ptBchF Varchar(5),
	'',--@ptBchT Varchar(5),
	----Merchant
	'',--@ptMerL Varchar(8000), --กรณี Condition IN
	'',--@ptMerF Varchar(10),
	'',--@ptMerT Varchar(10),
	----Shop Code
	'',--@ptShpL Varchar(8000), --กรณี Condition IN
	'',--@ptShpF Varchar(10),
	'',--@ptShpT Varchar(10),
	----ตัวแทนขาย
	'',--@ptAgnL Varchar(8000), --กรณี Condition IN

	'',--@ptPdtCodeF Varchar(20),
	'',--@ptPdtCodeT Varchar(20),
	'',--@ptPdtChanF Varchar(30),
	'',--@ptPdtChanT Varchar(30),
	'',--@ptPdtTypeF Varchar(5),
	'',--@ptPdtTypeT Varchar(5),

	----NUI 22-09-05 RQ2208-020
	'',--@ptPbnF Varchar(5),
	'',--@ptPbnT Varchar(5),

	'2021-01-01',--@ptDocDateF Varchar(10),
	'2022-09-26',--@ptDocDateT Varchar(10),
	------ลูกค้า
	----@ptCstF Varchar(20),
	----@ptCstT Varchar(20),
	0--@FNResult INT OUTPUT 