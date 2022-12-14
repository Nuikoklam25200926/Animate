
/****** Object:  StoredProcedure [dbo].[SP_RPTxPSSVatByMonth_Animate]    Script Date: 11/09/2022 10:26:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVatByMonth_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVatByMonth_Animate
GO
CREATE PROCEDURE SP_RPTxPSSVatByMonth_Animate 
--ALTER PROCEDURE [dbo].[SP_RPTxPSSVatByDate1001007] 
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



	@ptMonth Varchar(2),
	@ptYear Varchar(4),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 12/09/2022
-- Temp name  TRPTPSTaxMonthTmp_Animate
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @ptBchL สาขา เชือก
	--DECLARE @tPosCodeF Varchar(30)
	--DECLARE @tPosCodeT Varchar(30)
-- @@ptMonth เดือน
-- @@ptYear ปี
-- @FNResult

--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlDrop VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSqlSale VARCHAR(8000)
	DECLARE @tTblName Varchar(255)
	DECLARE @tSqlS Varchar(255)
	DECLARE @tSqlR Varchar(255)
	DECLARE @tSql2 VARCHAR(255)

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


	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--SET @tBchF = @ptBchF
	--SET @tBchT = @ptBchT

	--SET @tPosCodeF  = @ptPosCodeF 
	--SET @tPosCodeT = @ptPosCodeT 

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

	--SET @tDocDateF = @ptDocDateF
	--SET @tDocDateT = @ptDocDateT

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

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END


	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql2 =   ' WHERE FTXshStaDoc = ''1''AND ISNULL(FTXshDocVatFull,'''') = ''''' --เพิ่ม Where เฉพาะเอกสารที่ไม่มีการ GenVat
	SET @tSqlS =   ' WHERE FTXshStaDoc = ''1'' AND ISNULL(FTXshDocVatFull,'''') <> '''''
	SET @tSqlR =   ' WHERE FTXshStaDoc = ''1'' AND FNXshDocType = ''9'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSql2 +=' AND HDL.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSqlR +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSql2 +=' AND HDL.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSqlR +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSql2 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSqlR += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSql2 += ' AND HDL.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlR +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql2 +=' AND HDL.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlR +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlR +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND HDL.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSqlR += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSql2 += ' AND HDL.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	IF (@ptMonth <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	IF (@ptYear <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPSTaxMonthTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp

	--SET @tTblName = 'TRPTPSTaxTmp'+ @nComName + ''

	----if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].''+@tTblName''')) 
	--SET @tSqlDrop = ' if exists (select * from dbo.sysobjects where name = '''+@tTblName+ ''')'--id = object_id(N'[dbo].''+@tTblName'''))' 
	--SET @tSqlDrop += ' DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)

	--PRINT @tTblName 

	SET @tSqlSale  =' INSERT INTO TRPTPSTaxMonthTmp_Animate '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FNSeqNo,FNAppType,FTBchCode,FTXshDocDate,FTXshDocLegth,FTCstName,FTXshAddrTax,'
	SET @tSqlSale +=' FCXshAmtNV,FCXshVatable,FCXshVat,FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' ROW_NUMBER() OVER(ORDER BY FTXshDocDate, FTPosCode) AS rnDesc,' 
	SET @tSqlSale +=' FNAppType,FTBchCode, FTXshDocDate,FTXshDocLegth,FTXshCstName, FTXshAddrTax, FCXshAmtNV,FCXshGrandAmt-FCXshVat-FCXshAmtNV AS FCXshVatable, FCXshVat,FCXshGrandAmt, FTXshMonthTH, FTXshMonthEN'
	SET @tSqlSale +=' FROM('
			--SET @tSqlSale +=' SELECT OW_NUMBER() OVER (ORDER BY FTXshDocDate ,FTPosCode ) as rnDesc,'
			SET @tSqlSale +=' SELECT ''1'' AS FNAppType,FTBchCode,FTPosCode, FTXshDocDate,FTXshDocLegth,FTXshCstName, FTXshAddrTax,' 
			SET @tSqlSale +=' CAST(FCXshAmtNV AS DECIMAL(18,2)) AS FCXshAmtNV, CAST(FCXshVatable AS DECIMAL(18,2)) AS FCXshVatable, CAST(FCXshVat AS DECIMAL(18,2)) AS FCXshVat,CAST(FCXshGrandAmt AS DECIMAL(18,2)) AS FCXshGrandAmt,'
			--FCXshAmtNV, FCXshVatable, FCXshVat,FCXshGrandAmt, 
			SET @tSqlSale +=' FTXshMonthTH, FTXshMonthEN,FDXshDocDateSort'
			SET @tSqlSale +=' FROM'
				SET @tSqlSale +=' ('		
				SET @tSqlSale +=' SELECT HDL.FTBchCode,FTPosCode, FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'') AS FTXshDocDate, MIN(HDL.FTXshDocNo) + ''-'' + MAX(HDL.FTXshDocNo) AS FTXshDocLegth,'
						SET @tSqlSale +=' ISNULL(HDL.FTXshDocVatFull, '''') AS FTXshDocVatFull,'
						SET @tSqlSale +=' CASE WHEN ISNULL(HDL.FTXshDocVatFull, '''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax, '''' AS FTXshCstName, '''' AS FTXshAddrTax,'
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV, 0) ELSE ISNULL(FCXshAmtNV, 0) * -1 END) AS FCXshAmtNV,'
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0)) * -1 END) AS FCXshVatable,'
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat, 0) ELSE ISNULL(FCXshVat, 0) * -1 END) AS FCXshVat,' 
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0)) * -1 END) AS FCXshGrandAmt,'
						SET @tSqlSale +=' FORMAT(FDXshDocDate, ''MMMM yyyy'', ''Th'') AS FTXshMonthTH,  FORMAT(FDXshDocDate, ''MMMM yyyy'', ''en-US'') AS FTXshMonthEN,'
						SET @tSqlSale +=' Max(HDL.FDXshDocDate) AS FDXshDocDateSort'
				SET @tSqlSale +=' FROM TPSTSalHD HDL WITH(NOLOCK)'
					SET @tSqlSale +=' LEFT JOIN TPSTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo'
					SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH(NOLOCK) ON HDL.FTBchCode = Shp.FTBchCode AND HDL.FTShpCode = Shp.FTShpCode'
					SET @tSqlSale += @tSql2
				SET @tSqlSale +=' GROUP BY HDL.FTBchCode,  FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US''),FTPosCode,  ISNULL(HDL.FTXshDocVatFull, ''''),   FORMAT(FDXshDocDate, ''MMMM yyyy'', ''Th''),  FORMAT(FDXshDocDate, ''MMMM yyyy'', ''en-US'')'
				SET @tSqlSale +=' UNION'
				SET @tSqlSale +=' SELECT HD.FTBchCode,HD.FTPosCode, '
						SET @tSqlSale +=' FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'') AS FTXshDocDate,FTXshDocVatFull + ''('' + HD.FTXshDocNo + '')'' AS FTXshDocLegth, FTXshDocVatFull,'
						SET @tSqlSale +=' CASE WHEN ISNULL(FTXshDocVatFull, '''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax, '
						SET @tSqlSale +=' FTXshCstName, FTXshAddrTax,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV, 0) ELSE ISNULL(FCXshAmtNV, 0) * -1 END AS FCXshAmtNV,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0)) * -1 END AS FCXshVatable,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat, 0) ELSE ISNULL(FCXshVat, 0) END AS FCXshVat,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0)) * -1 END AS FCXshGrandAmt,'
						SET @tSqlSale +=' FORMAT(FDXshDocDate, ''MMMM yyyy'', ''Th'') AS FTXshMonthTH,  FORMAT(FDXshDocDate, ''MMMM yyyy'', ''en-US'') AS FTXshMonthEN,'
						SET @tSqlSale +=' HD.FDXshDocDate AS FDXshDocDateSort'
				SET @tSqlSale +=' FROM TPSTSalHD HD WITH(NOLOCK)'
					SET @tSqlSale +=' LEFT JOIN TPSTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo'
					SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH(NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode'
					SET @tSqlSale += @tSqlS
					--SET @tSqlSale +=' ORDER BY FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US''),FTPosCode,ISNULL(FTXshDocVatFull, '''')'
			SET @tSqlSale +=' ) Sale'
			--SET @tSqlSale +=' ORDER BY FDXshDocDateSort'
		SET @tSqlSale +=' ) Sale2'
	PRINT @tSqlSale
	EXECUTE(@tSqlSale)
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	

