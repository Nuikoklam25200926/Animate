/****** Object:  StoredProcedure [dbo].[SP_RPTxDailySaleByPdt_Animate]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxDailySaleByPdt_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxDailySaleByPdt_Animate
GO
CREATE PROCEDURE SP_RPTxDailySaleByPdt_Animate 
--ALTER PROCEDURE [dbo].[SP_RPTxDailySaleByPdt1001002] 

	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --กรณี Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),
	--Merchant
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),
	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),
	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtChanF Varchar(30),
	@ptPdtChanT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	--NUI 22-09-05 RQ2208-020
	@ptPbnF Varchar(5),
	@ptPbnT Varchar(5),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 16/09/2022
-- V.04.00.00
-- Temp name  TRPTSalDTTmp_Animate
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @ptShpF จากร้านค้า
-- @ptShpT ถึงร้านค้า
-- @ptPdtCodeF จากสินค้า
-- @ptPdtCodeT ถึงสินค้า
-- @ptPdtChanF จากกลุ่มสินค้า
-- @ptPdtChanT ถึงกลุ่มสินค้า
-- @ptPdtTypeF จากประเภทสินค้า
-- @ptPdtTypeT ถึงประเภท

-- @ptDocDateF จากวันที่
-- @ptDocDateT ถึงวันที่
-- @FNResult


--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlLast VARCHAR(8000)
	DECLARE @tSql1 VARCHAR(8000)
	DECLARE @tSqlPdt VARCHAR(8000)

	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)
	--Merchant
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)
	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)
	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tPdtCodeF Varchar(20)
	DECLARE @tPdtCodeT Varchar(20)
	DECLARE @tPdtChanF Varchar(30)
	DECLARE @tPdtChanT Varchar(30)
	DECLARE @tPdtTypeF Varchar(5)
	DECLARE @tPdtTypeT Varchar(5)

	DECLARE @tPbnF Varchar(5)
	DECLARE @tPbnT Varchar(5)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า
	--DECLARE @tCstF Varchar(20)
	--DECLARE @tCstT Varchar(20)


	
	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT
	--Merchant
	SET @tMerF  = @ptMerF
	SET @tMerT  = @ptMerT
	--Shop
	SET @tShpF  = @ptShpF
	SET @tShpT  = @ptShpT
	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtChanF = @ptPdtChanF
	SET @tPdtChanT = @ptPdtChanT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tPbnF = @ptPbnF
	SET @tPbnT = @ptPbnT


	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult= 0

	SET @tDocDateF = CONVERT(VARCHAR(10),@tDocDateF,121)
	SET @tDocDateT = CONVERT(VARCHAR(10),@tDocDateT,121)

	IF @nLngID = null
	BEGIN
		SET @nLngID = 1
	END	
	--Set ค่าให้ Paraleter กรณี T เป็นค่าว่างหรือ null


	IF @ptBchL = null
	BEGIN
		SET @ptBchL = ''
	END

	IF @tBchF = null
	BEGIN
		SET @tBchF = ''
	END
	IF @tBchT = null OR @tBchT = ''
	BEGIN
		SET @tBchT = @tBchF
	END

	IF @ptMerL =null
	BEGIN
		SET @ptMerL = ''
	END

	IF @tMerF =null
	BEGIN
		SET @tMerF = ''
	END
	IF @tMerT =null OR @tMerT = ''
	BEGIN
		SET @tMerT = @tMerF
	END 

	IF @ptShpL =null
	BEGIN
		SET @ptShpL = ''
	END

	IF @tShpF =null
	BEGIN
		SET @tShpF = ''
	END
	IF @tShpT =null OR @tShpT = ''
	BEGIN
		SET @tShpT = @tShpF
	END

	IF @ptPosL =null
	BEGIN
		SET @ptPosL = ''
	END

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tPdtCodeF = null
	BEGIN
		SET @tPdtCodeF = ''
	END 
	IF @tPdtCodeT = null OR @tPdtCodeT =''
	BEGIN
		SET @tPdtCodeT = @tPdtCodeF
	END 

	IF @tPdtChanF = null
	BEGIN
		SET @tPdtChanF = ''
	END 
	IF @tPdtChanT = null OR @tPdtChanT =''
	BEGIN
		SET @tPdtChanT = @tPdtChanF
	END 

	IF @tPdtTypeF = null
	BEGIN
		SET @tPdtTypeF = ''
	END 
	IF @tPdtTypeT = null OR @tPdtTypeT =''
	BEGIN
		SET @tPdtTypeT = @tPdtTypeF
	END 

	IF @tPbnF = null
	BEGIN
		SET @tPbnF = ''
	END 
	IF @tPbnT = null OR @tPbnT =''
	BEGIN
		SET @tPbnT = @tPbnF
	END 

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END
	SET @tSqlLast = ''
	SET @tSql1 = ''
	SET @tSqlPdt = ''
	SET @tSql1 =   ' WHERE FTXshStaDoc = ''1'' AND DT.FTXsdStaPdt <> ''4'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN		
			SET @tSql1 +=' AND DT.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlPdt +=' AND StkBal.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		
	END
	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSql1 +=' AND DT.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSql1 +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSql1 += ' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSql1 += ' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		--PRINT @tSqlLast
		IF @tSqlLast = ''
		BEGIN
			SET @tSql1 +=' AND (CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSql1 +=' OR CONVERT(VARCHAR(10),FDXshDocDate,121) = ''1900-01-01'')'
			SET @tSqlLast =' CONVERT(VARCHAR(10),Sal.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSqlLast += ' OR ISNULL(Sal.FDXshDocDate,''1900-01-01'') = ''1900-01-01'''
	   END
	   ELSE
	   BEGIN
			SET @tSql1 +=' AND (CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSql1 +=' OR CONVERT(VARCHAR(10),FDXshDocDate,121) = ''1900-01-01'')'
			SET @tSqlLast +=' AND (CONVERT(VARCHAR(10),Sal.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSqlLast += ' OR ISNULL(Sal.FDXshDocDate,''1900-01-01'') = ''1900-01-01'')'
	   END
	END

	DELETE FROM TRPTSalDTTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  =' INSERT INTO TRPTSalDTTmp_Animate '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTBchCode,FTBchName,FTXsdBarCode,FTPdtName,FTPgpChainName,FTPbnName,'
	 SET @tSql +=' FCXsdQtyAll,FCStkQty,FCSdtNetSale,FCPgdPriceRet,FCSdtNetAmt'
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' FTBchCode,FTBchName,ISNULL(FTXsdBarCode,'''') AS FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,'
	SET @tSql +=' SUM(ISNULL(FCXsdQtyAll,0)) AS FCXsdQtyAll,' --จำนวนขาย
	SET @tSql +=' ISNULL(FCStkQty,0) AS FCStkQty,' --สต๊อกคงเหลือ
	SET @tSql +=' SUM(FCSdtNetSale) AS FCSdtNetSale,' --ยอดขาย
	SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,' --ราคา/หน่วย
	SET @tSql +=' SUM(ISNULL(FCSdtNetAmt,0)) AS FCSdtNetAmt' --ยอดขายรวม
	--PRINT  @tSql
	SET @tSql +=' FROM'
		SET @tSql +=' (SELECT Bla.FTBchCode,FTBchName,Bla.FTPdtCode,Bla.FTBarCode AS FTXsdBarCode,FTPdtName,ISNULL(FTPgpChainName,'''') AS FTPgpChainName,ISNULL(FTPbnName,'''') AS FTPbnName,'
		SET @tSql +=' Sal.FTXshDocNo,ISNULL(Sal.FDXshDocDate, ''1900-01-01'') AS FDXshDocDate,ISNULL(Sal.FCXsdQtyAll,0) AS FCXsdQtyAll,Bla.FCStkQty,'
		SET @tSql +=' ISNULL(FCXsdDisPmt,0) AS FCXsdDisPmt,ISNULL(FCXsdDTDis,0) AS FCXsdDTDis,ISNULL(FCXsdHDDis,0) AS FCXsdHDDis,'
		--SET @tSql +=' ISNULL(FCXsdNet,0) - ISNULL(FCXsdDTDis,0) AS FCSdtNetSale,'
		SET @tSql +=' ISNULL(Sal.FCXsdQtyAll,0) * ISNULL(FCPgdPriceRet,0) AS FCSdtNetSale,'
		SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,'
		--SET @tSql +=' ISNULL(FCXsdNet,0) - (ISNULL(FCXsdDTDis,0)+ISNULL(FCXsdDisPmt,0)+ISNULL(FCXsdHDDis,0)) AS FCSdtNetAmt'
		SET @tSql +=' ISNULL(Sal.FCXsdNetAfHD,0) AS FCSdtNetAmt'
		
		SET @tSql +=' FROM'
			SET @tSql +=' (SELECT StkBal.FTBchCode,BchL.FTBchName ,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,'
			SET @tSql +=' PForPdt.FCPgdPriceRet'
			 SET @tSql +=' FROM  TCNTPdtStkBal StkBal WITH (NOLOCK)'
			 SET @tSql +=' INNER JOIN' 
			 SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = StkBal.FTPdtCode'
			 SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK)  ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK)  ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtGrp_L PgpL WITH(NOLOCK)  ON Pdt.FTPgpChain = PgpL.FTPgpChain AND PgpL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK)  ON StkBal.FTPdtCode = Ppz.FTPdtCode' --AND PdtBar.FTPunCode = Ppz.FTPunCode
			 --เพิ่ม BarCode
			 SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH (NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode'
			 SET @tSql +=' LEFT JOIN TCNMBranch_L BchL WITH(NOLOCK)  ON StkBal.FTBchCode = BchL.FTBchCode AND BchL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN'
			 --PRINT  @tSql
			 SET @tSql +=' ('
				SET @tSql +=' SELECT SUBSTRING(FTPghDocNo,3,5) AS FTBchCode,PForPdt.FTPdtCode,PForPdt.FTPunCode,MAX(FDPghDStop) AS FDPghDStop,AVG(FCPgdPriceRet) AS FCPgdPriceRet' 
				SET @tSql +=' FROM TCNTPdtPrice4PDT PForPdt WITH (NOLOCK)'
				SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH (NOLOCK) ON PForPdt.FTPdtCode = Ppz.FTPdtCode AND PForPdt.FTPunCode = Ppz.FTPunCode'
				SET @tSql +=' WHERE ISNULL(FTPplCode,'''') = '''' AND FCPdtUnitFact =1'
				SET @tSql +=' GROUP BY SUBSTRING(FTPghDocNo,3,5) ,PForPdt.FTPdtCode,PForPdt.FTPunCode'
			 SET @tSql +=' ) PForPdt ON StkBal.FTBchCode = PForPdt.FTBchCode AND StkBal.FTPdtCode = PForPdt.FTPdtCode'
			 SET @tSql +=' WHERE Ppz.FCPdtUnitFact =1'
			 
			 --PRINT @tSqlPdt
--			 PRINT  @tSql
			 SET @tSql += @tSqlPdt
			 --PRINT @tSql 
			 --Where 1 สินค้าเท่านั้น
			 SET @tSql +=' GROUP BY StkBal.FTBchCode,BchL.FTBchName,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,PForPdt.FCPgdPriceRet'
			SET @tSql +=' ) Bla'
			--SET @tSql += @tSqlLast
			SET @tSql +=' LEFT JOIN'
			SET @tSql +=' (SELECT  DT.FTBchCode, DT.FTXshDocNo,  FDXshDocDate, DT.FTPdtCode, FTXsdBarCode,' 
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdQtyAll ELSE (FCXsdQtyAll) * - 1 END AS FCXsdQtyAll,'
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdNet ELSE (FCXsdNet) * - 1 END AS FCXsdNet,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDisPmt,0) ELSE  ISNULL(FCXsdDisPmt,0)*-1 END  AS FCXsdDisPmt,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDTDis,0) ELSE ISNULL(FCXsdDTDis,0)*-1 END  AS FCXsdDTDis,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdHDDis,0) ELSE ISNULL(FCXsdHDDis,0)*-1 END AS FCXsdHDDis,'
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdNetAfHD ELSE (FCXsdNetAfHD) * - 1 END AS FCXsdNetAfHD'
			  SET @tSql +=' FROM  TPSTSalDT DT WITH (NOLOCK)' 
	 				SET @tSql +=' LEFT JOIN TPSTSalHD HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo'
					SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = DT.FTPdtCode'
					SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode ' 
					SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' (SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
					 SET @tSql +=' CASE FTXddDisChgType' 
					   SET @tSql +=' WHEN ''1'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''2'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''3'' THEN FCXddValue'
					   SET @tSql +=' WHEN ''4'' THEN FCXddValue'
					 SET @tSql +=' END AS FCXsdDisPmt'
					 SET @tSql +=' FROM TPSTSalDTDis DTDis  WITH (NOLOCK)'
					 SET @tSql +=' WHERE FNXddStaDis = 0'
					SET @tSql +=' ) DisPmt ON DT.FTBchCode = DisPmt.FTBchCode AND DT.FTXshDocNo = DisPmt.FTXshDocNo AND DT.FNXsdSeqNo = DisPmt.FNXsdSeqNo'

					SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' (SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
					 SET @tSql +=' CASE FTXddDisChgType' 
					   SET @tSql +=' WHEN ''1'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''2'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''3'' THEN FCXddValue'
					   SET @tSql +=' WHEN ''4'' THEN FCXddValue'
					 SET @tSql +=' END AS FCXsdDTDis'
					 SET @tSql +=' FROM TPSTSalDTDis DTDis  WITH (NOLOCK)'
					 SET @tSql +=' WHERE FNXddStaDis = 1'
					SET @tSql +=' ) DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo'

					SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' (SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
					 SET @tSql +=' CASE FTXddDisChgType' 
					   SET @tSql +=' WHEN ''1'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''2'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''3'' THEN FCXddValue'
					   SET @tSql +=' WHEN ''4'' THEN FCXddValue'
					 SET @tSql +=' END AS FCXsdHDDis'
					 SET @tSql +=' FROM TPSTSalDTDis DTDis  WITH (NOLOCK)'					 
					 SET @tSql +=' WHERE FNXddStaDis = 2'
					SET @tSql +=' ) HDDis ON DT.FTBchCode = HDDis.FTBchCode AND DT.FTXshDocNo = HDDis.FTXshDocNo AND DT.FNXsdSeqNo = HDDis.FNXsdSeqNo'
			  --SET @tSql +=' WHERE (FTXsdStaPdt <> ''4'')'
			  SET @tSql += @tSql1
			  -- Where Sale
			SET @tSql +=' ) Sal ON Bla.FTBchCode = Sal.FTBchCode AND Bla.FTPdtCode = Sal.FTPdtCode'
			--SET @tSql += ' WHERE ' + @tSqlLast
		SET @tSql +=' ) Pdt'
	SET @tSql +=' GROUP BY FTBchCode,FTBchName,FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,ISNULL(FCStkQty,0),ISNULL(FCPgdPriceRet,0)'
	

	--SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	PRINT @tSql
	EXECUTE(@tSql)

	--INSERT VD


	--RETURN SELECT * FROM TRPTSalDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	



