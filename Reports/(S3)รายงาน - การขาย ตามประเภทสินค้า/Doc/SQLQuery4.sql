SELECT SalePty.FTPtyCode,ISNULL(PtyL.FTPtyName,'') AS FTPtyName,SUM(FCXsdCostAvg)/SUM(FCXsdQtyAll) AS FCXsdCostAvg,
SUM(FCXsdSaleTotal) AS FCXsdSaleTotal,SUM(FCStkCostBal) AS FCStkCostBal,SUM(FCSalAmtBal) AS FCSalAmtBal
FROM(
		SELECT	Cost1.FTBchCode,Cost1.FTPtyCode,(FCXsdCostTotal) AS FCXsdCostAvg,FCXsdQtyAll,Sale.FCXsdSaleTotal,Sale.FCStkQty AS FCStkQtyBal,(FCXsdCostTotal/FCXsdQtyAll) * Sale.FCStkQty AS FCStkCostBal,ISNULL(Sale.FCSalAmtBal,0) AS FCSalAmtBal
		FROM(
				SELECT  DT.FTBchCode,Pdt.FTPtyCode,
				SUM((CASE WHEN FNXshDocType = '1' THEN FCXsdQtyAll ELSE FCXsdQtyAll*-1 END)) AS FCXsdQtyAll,
				SUM((CASE WHEN FNXshDocType = '1' THEN FCXsdQtyAll ELSE FCXsdQtyAll*-1 END)* FCXsdCostIN) AS FCXsdCostTotal
				FROM TPSTSalDT DT WITH (NOLOCK) INNER JOIN TPSTSalHD  HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
				LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode
				LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = 1
				LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode
				WHERE FCXsdCostIN <> 0
				-- Condition
				GROUP BY DT.FTBchCode,Pdt.FTPtyCode
			) Cost1
			LEFT JOIN
				(SELECT  DT.FTBchCode,Pdt.FTPtyCode,--DT.FTPdtCode,
				SUM(CASE WHEN FNXshDocType = '1' THEN FCXsdNetAfHD ELSE FCXsdNetAfHD*-1 END) AS FCXsdSaleTotal,
				SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,
				SUM(ISNULL(StkBal.FCStkQty,0)*ISNULL(FCPgdPriceRet,0))  AS FCSalAmtBal 
				--FCXsdCostIN
				FROM TPSTSalDT DT WITH (NOLOCK) INNER JOIN TPSTSalHD  HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
				LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode
				LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = 1
				LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode
				LEFT JOIN 
					(SELECT StkBal.FTBchCode,StkBal.FTPdtCode,FTPtyCode,
						SUM(ISNULL(FCStkQty,0)) AS FCStkQty			    
						FROM TCNTPdtStkBal StkBal WITH(NOLOCK) 
						LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON StkBal.FTPdtCode = Pdt.FTPdtCode
						GROUP BY FTBchCode,StkBal.FTPdtCode,FTPtyCode
					) StkBal ON DT.FTBchCode = StkBal.FTBchCode AND DT.FTPdtCode = StkBal.FTPdtCode
				LEFT JOIN
					(SELECT SUBSTRING(P4Pdt.FTPghDocNo,3,5) AS FTBchCode,P4Pdt.FTPdtCode,Pdt.FTPtyCode,MAX(P4Pdt.FDPghDStop) AS FDPghDStop,AVG(P4Pdt.FCPgdPriceRet) AS FCPgdPriceRet 
					  FROM TCNTPdtPrice4PDT P4Pdt WITH(NOLOCK)
					  LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON P4Pdt.FTPdtCode = Pdt.FTPdtCode
					  LEFT JOIN TCNMPdtPackSize Pzs WITH(NOLOCK) ON P4Pdt.FTPdtCode = Pzs.FTPdtCode
					  WHERE Pzs.FCPdtUnitFact = 1
					  GROUP BY SUBSTRING(FTPghDocNo,3,5) ,P4Pdt.FTPdtCode,Pdt.FTPtyCode
					) P4Pdt ON DT.FTBchCode = P4Pdt.FTBchCode AND DT.FTPdtCode = P4Pdt.FTPdtCode
				--WHERE FCXsdCostIN <> 0
				GROUP BY DT.FTBchCode,Pdt.FTPtyCode--,DT.FTPdtCode
				) Sale ON Cost1.FTBchCode = Sale.FTBchCode AND Cost1.FTPtyCode = Sale.FTPtyCode
	)SalePty
	LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON SalePty.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = 1
	GROUP BY SalePty.FTPtyCode,PtyL.FTPtyName



--SELECT * FROM TCNTPdtStkBal
--SELECT * FROM TCNMPdtType_L
--SELECT * FROM TCNTPdtStkCrdME
--SELECT * FROM TPSTSalDT
--SELECT * FROM TCNMPdtPackSize