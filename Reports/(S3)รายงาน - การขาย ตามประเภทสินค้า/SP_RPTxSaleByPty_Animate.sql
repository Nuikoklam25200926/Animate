/****** Object:  StoredProcedure [dbo].[SP_RPTxSaleByPty_Animate]    Script Date: 28/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSaleByPty_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxSaleByPty_Animate
GO
CREATE PROCEDURE SP_RPTxSaleByPty_Animate 
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
	--ตัวแทนขาย
	@ptAgnL Varchar(8000), --กรณี Condition IN
	--@ptPosF Varchar(20),
	--@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtChanF Varchar(30),
	@ptPdtChanT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	--NUI 22-09-05 RQ2208-020
	@ptPbnF Varchar(5),
	@ptPbnT Varchar(5),

	@ptDateF Varchar(10),
	@ptDateT Varchar(10),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 28/09/2022
-- V.01.00.00
-- Temp name  SP_RPTxSaleByPty_Animate
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

-- @ptDateF จากวันที่
-- @ptDateT ถึงวันที่
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
	DECLARE @tSql2 VARCHAR(8000)
	DECLARE @tSql3 VARCHAR(8000)
	DECLARE @tSqlME VARCHAR(8000)
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
	--SET @tPosF  = @ptPosF 
	--SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtChanF = @ptPdtChanF
	SET @tPdtChanT = @ptPdtChanT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tPbnF = @ptPbnF
	SET @tPbnT = @ptPbnT


	SET @tDocDateF = @ptDateF
	SET @tDocDateT = @ptDateT
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

	IF @ptAgnL =null
	BEGIN
		SET @ptAgnL = ''
	END

	--IF @tPosF = null
	--BEGIN
	--	SET @tPosF = ''
	--END
	--IF @tPosT = null OR @tPosT = ''
	--BEGIN
	--	SET @tPosT = @tPosF
	--END

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
	SET @tSql1 = ''
	SET @tSqlPdt = ' WHERE 1=1'
	SET @tSql2 = ''
	SET @tSqlME = ''
	SET @tSql3 = ''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END


	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN		
			SET @tSql1 +=' AND (DT.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql1 +=' OR ISNULL(DT.FTBchCode,'''') = '''') '
			--SET @tSql3 +=' AND (Stk.FTBchCode IN (' + @ptBchL + ')'
			--SET @tSql3 +=' OR ISNULL(Stk.FTBchCode,'''') = '''') '
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql3 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlME +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql3 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlME +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptAgnL <> '')
		BEGIN
			SET @tSql1 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSql3 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSql2 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSqlME += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
		END		
	END
	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		--SET @tSql3 +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN

		SET @tSql1 +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		--SET @tSql3 +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN		
		SET @tSql1 += ' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		--SET @tSql3 += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSql1 += ' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		--SET @tSql3 += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		--PRINT @tSqlLast
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		--SET @tSql1 += ' AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @tDocDateF + '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= ''' + @tDocDateT + ''''
	END
	
	DELETE FROM TRPTSaleByPtyTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  =' INSERT INTO TRPTSaleByPtyTmp_Animate '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTPtyCode,FTPtyName,FCXsdCostAvg,FCXsdSaleTotal,FCStkCostBal,FCSalAmtBal'
	 SET @tSql +=' '
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' ISNULL(SalePty.FTPtyCode,'''') AS FTPtyCode,ISNULL(PtyL.FTPtyName,'''') AS FTPtyName,SUM(FCXsdCostAvg)/SUM(FCXsdQtyAll) AS FCXsdCostAvg,'
	SET @tSql +=' SUM(FCXsdSaleTotal) AS FCXsdSaleTotal,SUM(FCStkCostBal) AS FCStkCostBal,SUM(FCSalAmtBal) AS FCSalAmtBal'
	SET @tSql +=' FROM('
		SET @tSql +=' SELECT Cost1.FTBchCode,Cost1.FTPtyCode,(FCXsdCostTotal) AS FCXsdCostAvg,FCXsdQtyAll,Sale.FCXsdSaleTotal,Sale.FCStkQty AS FCStkQtyBal,(FCXsdCostTotal/FCXsdQtyAll) * Sale.FCStkQty AS FCStkCostBal,ISNULL(Sale.FCSalAmtBal,0) AS FCSalAmtBal'
		SET @tSql +=' FROM('
				SET @tSql +=' SELECT  DT.FTBchCode,Pdt.FTPtyCode,'
				SET @tSql +=' SUM((CASE WHEN FNXshDocType = ''1'' THEN FCXsdQtyAll ELSE FCXsdQtyAll*-1 END)) AS FCXsdQtyAll,'
				SET @tSql +=' SUM((CASE WHEN FNXshDocType = ''1'' THEN FCXsdQtyAll ELSE FCXsdQtyAll*-1 END)* FCXsdCostIN) AS FCXsdCostTotal'
				SET @tSql +=' FROM TPSTSalDT DT WITH (NOLOCK) INNER JOIN TPSTSalHD  HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo'
				SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode'
				SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
				SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode'
				SET @tSql +=' WHERE FCXsdCostIN <> 0'
				-- Condition
				SET @tSql += @tSql1
				SET @tSql +=' GROUP BY DT.FTBchCode,Pdt.FTPtyCode'
			SET @tSql +=' ) Cost1'
			SET @tSql +=' LEFT JOIN'
				SET @tSql +=' (SELECT  DT.FTBchCode,Pdt.FTPtyCode,'--DT.FTPdtCode,
				SET @tSql +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN FCXsdNetAfHD ELSE FCXsdNetAfHD*-1 END) AS FCXsdSaleTotal,'
				SET @tSql +=' SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,'
				SET @tSql +=' SUM(ISNULL(StkBal.FCStkQty,0)*ISNULL(FCPgdPriceRet,0))  AS FCSalAmtBal'
				SET @tSql +=' FROM TPSTSalDT DT WITH (NOLOCK) INNER JOIN TPSTSalHD  HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo'
				SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode'
				SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
				SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode'
				SET @tSql +=' LEFT JOIN'
					SET @tSql +=' (SELECT StkBal.FTBchCode,StkBal.FTPdtCode,FTPtyCode,'
						SET @tSql +=' SUM(ISNULL(FCStkQty,0)) AS FCStkQty'			    
						SET @tSql +=' FROM TCNTPdtStkBal StkBal WITH(NOLOCK)' 
						SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON StkBal.FTPdtCode = Pdt.FTPdtCode'
						SET @tSql +=' GROUP BY FTBchCode,StkBal.FTPdtCode,FTPtyCode'
					SET @tSql +=' ) StkBal ON DT.FTBchCode = StkBal.FTBchCode AND DT.FTPdtCode = StkBal.FTPdtCode'
				SET @tSql +=' LEFT JOIN'
					SET @tSql +=' (SELECT SUBSTRING(P4Pdt.FTPghDocNo,3,5) AS FTBchCode,P4Pdt.FTPdtCode,Pdt.FTPtyCode,MAX(P4Pdt.FDPghDStop) AS FDPghDStop,AVG(P4Pdt.FCPgdPriceRet) AS FCPgdPriceRet'
					  SET @tSql +=' FROM TCNTPdtPrice4PDT P4Pdt WITH(NOLOCK)'
					  SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON P4Pdt.FTPdtCode = Pdt.FTPdtCode'
					  SET @tSql +=' LEFT JOIN TCNMPdtPackSize Pzs WITH(NOLOCK) ON P4Pdt.FTPdtCode = Pzs.FTPdtCode'
					  SET @tSql +=' WHERE Pzs.FCPdtUnitFact = 1'
					  SET @tSql +=' GROUP BY SUBSTRING(FTPghDocNo,3,5) ,P4Pdt.FTPdtCode,Pdt.FTPtyCode'
					SET @tSql +=' ) P4Pdt ON DT.FTBchCode = P4Pdt.FTBchCode AND DT.FTPdtCode = P4Pdt.FTPdtCode'
				--WHERE FCXsdCostIN <> 0
				SET @tSql +=@tSql1
				SET @tSql +=' GROUP BY DT.FTBchCode,Pdt.FTPtyCode'--,DT.FTPdtCode
				SET @tSql +=' ) Sale ON Cost1.FTBchCode = Sale.FTBchCode AND Cost1.FTPtyCode = Sale.FTPtyCode'
	SET @tSql +=' )SalePty'
	SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON SalePty.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' GROUP BY ISNULL(SalePty.FTPtyCode,''''),PtyL.FTPtyName'

	--SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	PRINT @tSql
	EXECUTE(@tSql)

	--INSERT VD


	--RETURN SELECT * FROM TRPTSalDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	



