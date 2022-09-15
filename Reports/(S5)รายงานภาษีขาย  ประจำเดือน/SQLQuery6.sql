SELECT '1' AS FNAppType,
HDL.FTBchCode,FTXshDocDate,CASE WHEN HDL.FTXshDocVatFull = '' THEN FTXshDocLegth ELSE HDFull.FTXshDocVat END AS FTXshDocLegth ,
CASE WHEN FTXshGenTax = '2' THEN ISNULL(HDFull.FTXshCstName,'') ELSE ISNULL(HDl.FTXshCstName,'') END AS FTXshCstName,ISNULL(HDFull.FTXshAddrTax,'') AS FTXshAddrTax,
CASE WHEN FTXshGenTax = '2' THEN HDFull.FCXshAmtNV ELSE HDL.FCXshAmtNV END AS FCXshAmtNV,
CASE WHEN FTXshGenTax = '2' THEN HDFull.FCXshVatable ELSE HDL.FCXshVatable END AS FCXshVatable,
CASE WHEN FTXshGenTax = '2' THEN HDFull.FCXshVat ELSE HDL.FCXshVat END AS FCXshVat,
CASE WHEN FTXshGenTax = '2' THEN HDFull.FCXshGrandAmt ELSE HDL.FCXshGrandAmt END AS FCXshGrandAmt,
FTXshMonthTH, FTXshMonthEN--,
--FTXshGenTax
--,HDL.FDXshDocDateSort
FROM(
	SELECT HDL.FTBchCode,FORMAT( FDXshDocDate, 'dd/MMM/yyyy', 'en-US' )  AS FTXshDocDate,
	MIN(HDL.FTXshDocNo) + '-' + Max(HDL.FTXshDocNo) AS FTXshDocLegth,Max(HDL.FDXshDocDate) AS FDXshDocDateSort,
	ISNULL(HDL.FTXshDocVatFull,'') AS FTXshDocVatFull , 
	CASE WHEN ISNULL(HDL.FTXshDocVatFull,'') = '' THEN '1' ELSE '2' END AS FTXshGenTax --'2'
	,ISNULL(HDCst.FTXshCstName,'')  AS FTXshCstName,
	SUM(ISNULL(FCXshAmtNV,0)) AS FCXshAmtNV,SUM(ISNULL(FCXshVatable,0)) AS FCXshVatable,SUM(ISNULL(FCXshVat,0)) AS FCXshVat,
	SUM(ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)) AS FCXshGrandAmt,
	FORMAT( FDXshDocDate, ' MMMM yyyy', 'Th' )  AS FTXshMonthTH,FORMAT( FDXshDocDate, ' MMMM yyyy', 'en-US' )  AS FTXshMonthEN

	FROM TPSTSalHD HDL WITH(NOLOCK)
	LEFT JOIN TPSTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo
	GROUP BY HDL.FTBchCode,FORMAT( FDXshDocDate, 'dd/MMM/yyyy', 'en-US' ),ISNULL(HDL.FTXshDocVatFull,''),FNXshDocType,ISNULL(HDCst.FTXshCstName,''), FORMAT( FDXshDocDate, ' MMMM yyyy', 'Th' ) ,FORMAT( FDXshDocDate, ' MMMM yyyy', 'en-US' )
	) AS HDL
	LEFT JOIN 
	(
	  SELECT HD.FTBchCode,FTXshDocVatFull,FTXshDocVatFull + '(' + HD.FTXshDocNo + ')' AS FTXshDocVat,FTXshCstName,FTXshAddrTax,
	  ISNULL(FCXshAmtNV,0) AS FCXshAmtNV,ISNULL(FCXshVatable,0) AS FCXshVatable,
	  ISNULL(FCXshVat,0) AS FCXshVat,
	  ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) AS FCXshGrandAmt
	  FROM TPSTSalHD HD WITH(NOLOCK)
	  LEFT JOIN TPSTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo
	  WHERE ISNULL(FTXshDocVatFull,'') <> ''
	) AS HDFull ON HDL.FTBchCode = HDFull.FTBchCode AND HDL.FTXshDocVatFull = HDFull.FTXshDocVatFull
ORDER BY HDL.FDXshDocDateSort --FTXshDocDate

