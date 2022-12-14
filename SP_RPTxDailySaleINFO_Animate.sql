/****** Object:  StoredProcedure [dbo].[SP_RPTxDailySaleINFO_Animate]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxDailySaleINFO_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxDailySaleINFO_Animate
GO
CREATE PROCEDURE SP_RPTxDailySaleINFO_Animate 
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
	SET @tSql1 = ' WHERE 1=1'
	SET @tSqlPdt = ' WHERE 1=1'

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND Stk.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
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
			SET @tSql1 +=' AND (Stk.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql1 +=' OR ISNULL(Stk.FTBchCode,'''') = '''') '
			--SET @tSqlPdt +=' AND StkBal.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptAgnL <> '')
		BEGIN
			SET @tSql1 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
		END		
	END
	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSql1 +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSql1 +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSql1 += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSql1 += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		--PRINT @tSqlLast
		--SET @tSql1 +=' AND (CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSql1 += ' AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @tDocDateF + '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTSaleINFOTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  =' INSERT INTO TRPTSaleINFOTmp_Animate '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTPtyName,FTPbnName,FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,FCPdtStkSetPrice,FCPdtStkQtySale,FCPdtStkQtyIn,FCStkQtyBal'
	 SET @tSql +=' '
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' FTPtyName,FTPbnName,FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,ISNULL(FCPdtStkSetPrice,0) AS FCPdtStkSetPrice,ISNULL(FCPdtStkQtySale,0) AS FCPdtStkQtySale,'
	SET @tSql +=' ISNULL(FCPdtStkQtyIn,0) AS FCPdtStkQtyIn,ISNULL(FCStkQtyMthEnd,0)+ISNULL(FCPdtStkQtyIn,0)-ISNULL(FCPdtStkQtySale,0) AS FCStkQtyBal'
	SET @tSql +=' FROM('
			SET @tSql +=' SELECT FTPtyName,FTPbnName,STK.FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,StkSetPrice.FCPdtStkSetPrice,'
			SET @tSql +=' SUM(CASE FTStkType'
			SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
			SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
			SET @tSql +=' END) AS FCPdtStkQtySale,'
			SET @tSql +=' SUM(CASE FTStkType'
			SET @tSql +=' WHEN ''1'' THEN ISNULL(Stk.FCStkQty,0)' --เข้า
			SET @tSql +=' WHEN ''2'' THEN ISNULL(Stk.FCStkQty,0)*-1' --ออก
			SET @tSql +=' WHEN ''5'' THEN ISNULL(Stk.FCStkQty,0)' -- ปรับจำนวน + : เข้า , - : ออก
			SET @tSql +=' END) AS FCPdtStkQtyIn,SUM(ISNULL(MthEnd.FCStkQtyMthEnd,0))  + SUM(ISNULL(MthEnd1.FCStkQtyMthEnd,0)) AS FCStkQtyMthEnd'

			SET @tSql +=' FROM TCNTPdtStkCrd Stk WITH (NOLOCK)'
			SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk.FTPdtCode = PdtM.FTPdtCode'
			SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
			SET @tSql +=' LEFT JOIN'
			SET @tSql +=' (SELECT Stk.FTBchCode,FTWahCode,Stk.FTPdtCode,'
			 SET @tSql +=' CASE WHEN' 
					SET @tSql +=' SUM(CASE FTStkType'
					SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
					SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
					SET @tSql +=' END) = 0 THEN 0' 				
   			 SET @tSql +=' ELSE'			 
					SET @tSql +=' (SUM(CASE FTStkType'
			 			 SET @tSql +=' WHEN ''3'' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))'  --ขาย
						 SET @tSql +=' WHEN ''4'' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))*-1' --คืน
						 SET @tSql +=' END) /' 
					 SET @tSql +=' SUM(CASE FTStkType'
						 SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
						 SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
						SET @tSql +=' END))' 
			 SET @tSql +=' END AS FCPdtStkSetPrice'
			 SET @tSql +=' FROM TCNTPdtStkCrd Stk WITH (NOLOCK)'	
			 SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk.FTPdtCode = PdtM.FTPdtCode'
			 SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
			 SET @tSql +=' WHERE FTStkType IN (''3'',''4'') AND ISNULL(FCStkSetPrice,0) <> 0'
			 SET @tSql +=' GROUP BY Stk.FTBchCode,FTWahCode,Stk.FTPdtCode'
			 SET @tSql +=' ) StkSetPrice ON STK.FTBchCode = StkSetPrice.FTBchCode AND STK.FTPdtCode = StkSetPrice.FTPdtCode AND STK.FTWahCode = StkSetPrice.FTWahCode'
			 SET @tSql +=' LEFT JOIN'
					SET @tSql +=' ('--Pdt
						SET @tSql +=' SELECT Pdt.FTPdtCode,PdtL.FTPdtName,ISNULL(PdtL.FTPdtNameOth,'''') AS FTPdtNameOth,PdtBar.FTBarCode,ISNULL(PtyL.FTPtyName,'''') AS FTPtyName,ISNULL(PbnL.FTPbnName,'''') AS FTPbnName'
						SET @tSql +=' FROM TCNMPdt Pdt WITH(NOLOCK)'
						SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK) ON Pdt.FTPdtCode = Ppz.FTPdtCode AND FCPdtUnitFact = 1'
						SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode'
						SET @tSql += @tSqlPdt
					SET @tSql +=' ) Pdt ON Stk.FTpdtCode = Pdt.FTPdtCode'
			SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' ('--TCNTPdtStkCrdME
						SET @tSql +=' SELECT FDStkDate,StkME.FTBchCode,StkME.FTPdtCode,FCStkQty AS  FCStkQtyMthEnd,FORMAT(FDStkDate, ''yyyy-MM'') AS FTStkMonthYer'
						SET @tSql +=' FROM TCNTPdtStkCrdME StkME WITH(NOLOCK)'
						SET @tSql +=' WHERE FORMAT(FDStkDate, ''yyyy-MM'') = FORMAT(CONVERT(DATETIME,2022-07-25), ''yyyy-MM'')'
					SET @tSql +=' ) MthEnd ON Stk.FTBchCode = MthEnd.FTBchCode AND Stk.FTPdtCode = MthEnd.FTPdtCode AND FORMAT(Stk.FDStkDate, ''yyyy-MM'') = FORMAT(MthEnd.FDStkDate, ''yyyy-MM'')'
					  SET @tSql +=' LEFT JOIN'
					SET @tSql +=' ('--	TCNTPdtStkCrd ยอดยกมา เพื่อรวม กับ Qty ใน TCNTPdtStkCrdME						
						SET @tSql +=' SELECT FTBchCode,FTPdtCode,FORMAT(FDStkDate, ''yyyy-MM'') AS FTStkMonthYer,'
						SET @tSql +=' SUM(CASE FTStkType'
						SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk1.FCStkQty,0)*-1'  --ขาย
						SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk1.FCStkQty,0)' --คืน
						SET @tSql +=' WHEN ''1'' THEN ISNULL(Stk1.FCStkQty,0)' --เข้า
						SET @tSql +=' WHEN ''2'' THEN ISNULL(Stk1.FCStkQty,0)*-1' --ออก
						SET @tSql +=' WHEN ''5'' THEN ISNULL(Stk1.FCStkQty,0)' -- ปรับจำนวน + : เข้า , - : ออก
						SET @tSql +=' END) AS  FCStkQtyMthEnd'
						SET @tSql +=' FROM TCNTPdtStkCrd  Stk1 WITH(NOLOCK)'
						SET @tSql +=' WHERE CONVERT(VARCHAR(10),Stk1.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @ptDateF+ '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk1.FDStkDate,121) < '''+ @ptDateF+''''--@ptDateF
						SET @tSql +=' GROUP BY FTBchCode,FTPdtCode,FORMAT(FDStkDate, ''yyyy-MM'')'
					SET @tSql +=' ) MthEnd1 ON STK.FTBchCode = MthEnd1.FTBchCode AND STK.FTPdtCode = MthEnd1.FTPdtCode AND FORMAT(STK.FDStkDate, ''yyyy-MM'') = MthEnd1.FTStkMonthYer'
			--
			 --WHERE CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,@ptDateF), 'yyyy-MM-01') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= @ptDateT
			SET @tSql +=@tSql1
			SET @tSql +=' GROUP BY FTPtyName,FTPbnName,STK.FTPdtCode,Pdt.FTPdtName,Pdt.FTPdtNameOth,Pdt.FTBarCode,StkSetPrice.FCPdtStkSetPrice'--,ISNULL(MthEnd.FCStkQtyMthEnd,0)  + ISNULL(MthEnd1.FCStkQtyMthEnd,0) 
			SET @tSql +=' ) SalData'

	--SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	PRINT @tSql
	EXECUTE(@tSql)

	--INSERT VD


	--RETURN SELECT * FROM TRPTSalDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	



