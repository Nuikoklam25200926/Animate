
SELECT	FTBchCode,FTPdtCode,FTWahCode,
SUM(CASE FTStkType
				   WHEN '3' THEN ISNULL(FCStkQty,0)*ISNULL(FCStkCostIn,0)
				   WHEN '4' THEN (ISNULL(FCStkQty,0)*ISNULL(FCStkCostIn,0))*-1
				END) AS FCStkCostSaleIn	,
				SUM(CASE FTStkType
				   WHEN '3' THEN ISNULL(FCStkQty,0)*ISNULL(FCStkSetPrice,0)
				   WHEN '4' THEN (ISNULL(FCStkQty,0)*ISNULL(FCStkSetPrice,0))*-1
				END) AS FCStkSaleIn	,
 SUM(CASE FTStkType				   
				   WHEN '1' THEN ISNULL(FCStkQty,0)*ISNULL(FCStkCostIn,0)
				   WHEN '2' THEN (ISNULL(FCStkQty,0)*ISNULL(FCStkCostIn,0))*-1
				   WHEN '3' THEN (ISNULL(FCStkQty,0)*ISNULL(FCStkCostIn,0))*-1
				   WHEN '4' THEN (ISNULL(FCStkQty,0)*ISNULL(FCStkCostIn,0))
				   WHEN '5' THEN (ISNULL(FCStkQty,0)*ISNULL(FCStkCostIn,0))
				END) AS FCStkCostIn,
-SUM(CASE FTStkType				   
				   WHEN '1' THEN ISNULL(FCStkQty,0)
				   WHEN '2' THEN (ISNULL(FCStkQty,0))*-1
				   WHEN '3' THEN (ISNULL(FCStkQty,0))*-1
				   WHEN '4' THEN (ISNULL(FCStkQty,0))
				   WHEN '5' THEN (ISNULL(FCStkQty,0))
				END) AS FCStkSumQty

FROM TCNTPdtStkCrd
GROUP BY FTBchCode ,FTPdtCode,FTWahCode


--SELECT * FROM TCNTPdtStkCrdME