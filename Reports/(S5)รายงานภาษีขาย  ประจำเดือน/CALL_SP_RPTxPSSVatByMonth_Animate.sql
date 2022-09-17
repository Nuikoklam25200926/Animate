EXEC SP_RPTxPSSVatByMonth_Animate 
1,	--@pnLngID int , 
'Ada062',	--@pnComName Varchar(100),
'00001',	--@ptRptCode Varchar(100),
'00001',	--@ptUsrSession Varchar(255),
'2',	--@pnFilterType int, --1 BETWEEN 2 IN
	----สาขา
'',	--@ptBchL Varchar(8000), --กรณี Condition IN
'',	--@ptBchF Varchar(5),
'',	--@ptBchT Varchar(5),
	----Merchant
'',	--@ptMerL Varchar(8000), --กรณี Condition IN
'',	--@ptMerF Varchar(10),
'',	--@ptMerT Varchar(10),
	----Shop Code
'',	--@ptShpL Varchar(8000), --กรณี Condition IN
'',	--@ptShpF Varchar(10),
'',	--@ptShpT Varchar(10),
	----เครื่องจุดขาย
'',	--@ptPosL Varchar(8000), --กรณี Condition IN
'',	--@ptPosF Varchar(20),
'',	--@ptPosT Varchar(20),



'09',	--@ptMonth Varchar(2),
'2022',	--@ptYear Varchar(4),

0	--@FNResult INT OUTPUT

--TRUNCATE TABLE TRPTPSTaxMonthTmp_Animate