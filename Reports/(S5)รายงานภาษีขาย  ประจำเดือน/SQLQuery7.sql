SELECT  ROW_NUMBER() OVER (ORDER BY FTXshDocDate,FTBchCode,FTPosCode ) as rnDesc,
'1' AS FNAppType, 
        FTXshDocDate, FTBchCode,FTXshDocLegth,FTXshCstName, FTXshAddrTax, CAST(FCXshAmtNV AS DECIMAL(18,2)) AS FCXshAmtNV, CAST(FCXshVatable AS DECIMAL(18,2)) AS FCXshVatable, 
		CAST(FCXshVat AS DECIMAL(18,2)) AS FCXshVat,CAST(FCXshGrandAmt AS DECIMAL(18,2)) AS FCXshGrandAmt, FTXshMonthTH, FTXshMonthEN--,FDXshDocDateSort
FROM
    (		
	SELECT HDL.FTBchCode, FTPosCode, FORMAT(FDXshDocDate, 'dd/MMM/yyyy', 'en-US') AS FTXshDocDate, MIN(HDL.FTXshDocNo) + '-' + MAX(HDL.FTXshDocNo) AS FTXshDocLegth, 
            ISNULL(HDL.FTXshDocVatFull, '') AS FTXshDocVatFull,
            CASE WHEN ISNULL(HDL.FTXshDocVatFull, '') = '' THEN '1' ELSE '2' END AS FTXshGenTax, '' AS FTXshCstName, '' AS FTXshAddrTax,
            SUM(CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshAmtNV, 0) ELSE ISNULL(FCXshAmtNV, 0) * -1 END) AS FCXshAmtNV, 
            SUM(CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0)) * -1 END) AS FCXshVatable, 
            SUM(CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshVat, 0) ELSE ISNULL(FCXshVat, 0) * -1 END) AS FCXshVat, 
            SUM(CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0)) * -1 END) AS FCXshGrandAmt, 
            FORMAT(FDXshDocDate, 'MMMM yyyy', 'Th') AS FTXshMonthTH,  FORMAT(FDXshDocDate, 'MMMM yyyy', 'en-US') AS FTXshMonthEN,
			Max(HDL.FDXshDocDate) AS FDXshDocDateSort
    FROM TPSTSalHD HDL WITH(NOLOCK)
        LEFT JOIN TPSTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo
        LEFT JOIN TCNMShop Shp WITH(NOLOCK) ON HDL.FTBchCode = Shp.FTBchCode AND HDL.FTShpCode = Shp.FTShpCode

    WHERE FTXshStaDoc = '1'
            AND ISNULL(FTXshDocVatFull, '') = ''
            AND FORMAT(HDL.FDXshDocDate, 'MM', 'en-US') = '08'
            AND FORMAT(HDL.FDXshDocDate, 'yyyy', 'en-US') = '2022'
    GROUP BY HDL.FTBchCode,FTPosCode,  FORMAT(FDXshDocDate, 'dd/MMM/yyyy', 'en-US'),  ISNULL(HDL.FTXshDocVatFull, ''),   FORMAT(FDXshDocDate, 'MMMM yyyy', 'Th'),  FORMAT(FDXshDocDate, 'MMMM yyyy', 'en-US')
	UNION ALL
	SELECT 
			
			HD.FTBchCode, HD.FTPosCode,
			FORMAT(FDXshDocDate, 'dd/MMM/yyyy', 'en-US') AS FTXshDocDate,FTXshDocVatFull + '(' + HD.FTXshDocNo + ')' AS FTXshDocLegth, FTXshDocVatFull,
            CASE WHEN ISNULL(FTXshDocVatFull, '') = '' THEN '1' ELSE '2' END AS FTXshGenTax, 
            FTXshCstName, FTXshAddrTax,
            CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshAmtNV, 0) ELSE ISNULL(FCXshAmtNV, 0) * -1 END AS FCXshAmtNV,
            CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0)) * -1 END AS FCXshVatable,
            CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshVat, 0) ELSE ISNULL(FCXshVat, 0) END AS FCXshVat,
            CASE WHEN FNXshDocType = '1' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0)) * -1 END AS FCXshGrandAmt,
            FORMAT(FDXshDocDate, 'MMMM yyyy', 'Th') AS FTXshMonthTH,  FORMAT(FDXshDocDate, 'MMMM yyyy', 'en-US') AS FTXshMonthEN,
			HD.FDXshDocDate AS FDXshDocDateSort
    FROM TPSTSalHD HD WITH(NOLOCK)
        LEFT JOIN TPSTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo
        LEFT JOIN TCNMShop Shp WITH(NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode
    WHERE FTXshStaDoc = '1'
            AND ISNULL(FTXshDocVatFull, '') <> ''
            AND FORMAT(HD.FDXshDocDate, 'MM', 'en-US') = '08'
            AND FORMAT(HD.FDXshDocDate, 'yyyy', 'en-US') = '2022'
	--ORDER BY FORMAT(FDXshDocDate, 'dd/MMM/yyyy', 'en-US'),FTPosCode,ISNULL(FTXshDocVatFull, '')
) Sale
--ORDER BY FTBchCode,FTXshDocDate,FTPosCode,FDXshDocDateSort ASC
