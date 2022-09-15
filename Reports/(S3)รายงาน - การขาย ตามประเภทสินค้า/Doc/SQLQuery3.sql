SELECT --(SELECT FTSysUsrValue FROM TSysConfig WHERE FTSysNameTha = 'คลังสินค้า สำหรับขายปลีก - ขาย') AS FTWahSale ,
StkSum.FTBchCode,StkSum.FTWahCode,StkSum.FTPdtCode,StkSum.FDStkDate,
          --FDStkSTSaleDate,
          StkSum.FDStkMonth AS FNStkMonth, StkSum.FDStkYear AS FNStkYear,
		  FCStkQtyMonthEnd,
		  FCStkQtyIn,
		  FCStkQtySale,
		  FCStkQtyBalance,
		  --CASE WHEN FCStkQtySale = 0 THEN 0 ELSE FCStkSaleAmt/FCStkQtySale END AS FCStkSalePrice,
		  --ISNULL(FCStkSalePrice,TCNMPdt.FCPdtRetPriS1) AS FCStkSalePrice,
		  FCStkCostIn,
		  FCStkCostEx,
		  FCStkCostSaleIn,
		  FCStkCostSaleEx,
		  FCStkSaleAmt,
		  FCStkCostMonthEndIN ,
		  FCStkCostMonthEndEx ,
		  FCStkCostRcvIn,
		  FCStkCostRcvEx,
		  FCStkCostAdjIn,
		  FCStkCostAdjInEx		  
FROM(		
	SELECT FTBchCode,FTWahCode,StkSum1.FTPdtCode,FDStkDate,FDStkMonth, FDStkYear,
		 (ISNULL(FCStkQtyMonthEnd,0)) AS FCStkQtyMonthEnd,
		  (ISNULL(FCStkQtyIn,0)) AS FCStkQtyIn,
		  (ISNULL(FCStkQtySale,0)) AS FCStkQtySale,
		  (ISNULL(FCStkQtyBalance,0)) AS FCStkQtyBalance,
		  (ISNULL(FCStkCostIn,0)) AS FCStkCostIn,
		  (ISNULL(FCStkCostEX,0)) AS FCStkCostEX,
		  (ISNULL(FCStkCostSaleIn,0)) AS FCStkCostSaleIn,
		  (ISNULL(FCStkCostSaleEx,0)) AS FCStkCostSaleEx,
		  (ISNULL(FCStkSaleAmt,0)) AS FCStkSaleAmt,
		  ISNULL(FCStkCostMonthEndIN,0) AS FCStkCostMonthEndIN ,
		  ISNULL(FCStkCostMonthEndEx,0) AS FCStkCostMonthEndEx ,
		  ISNULL(FCStkCostRcvIn,0) AS FCStkCostRcvIn,
		  ISNULL(FCStkCostRcvEx,0) AS FCStkCostRcvEx,
		  ISNULL(FCStkCostAdjIn,0) AS FCStkCostAdjIn,
		  ISNULL(FCStkCostAdjEx,0) AS FCStkCostAdjInEx
		  
	FROM(
		SELECT FTBchCode,FTWahCode,FTPdtCode,FDStkDate,MONTH(FDStkDate) AS FDStkMonth,YEAR(FDStkDate) AS FDStkYear,
   			   MIN(CASE FTStkType
			      WHEN '0' THEN FCStkQty
			   END) AS FCStkQtyMonthEnd			,
			   SUM(CASE FTStkType
				   WHEN '1' THEN FCStkQty
				   WHEN '2' THEN FCStkQty*-1
				END) AS FCStkQtyIn	,
			   SUM(CASE FTStkType
				   WHEN '3' THEN FCStkQty*-1
				   WHEN '4' THEN FCStkQty
				END) AS FCStkQtySale	,
			   SUM(CASE FTStkType
				   --WHEN '0' THEN FCStkQty
				   WHEN '1' THEN FCStkQty
				   WHEN '2' THEN FCStkQty*-1
				   WHEN '3' THEN FCStkQty*-1
				   WHEN '4' THEN FCStkQty		   
				   WHEN '5' THEN FCStkQty
				END) AS FCStkQtyBalance	,

			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostIn)
				   WHEN '1' THEN FCStkQty*FCStkCostIn
				   WHEN '2' THEN (FCStkQty*FCStkCostIn)*-1
				   WHEN '3' THEN (FCStkQty*FCStkCostIn)*-1
				   WHEN '4' THEN (FCStkQty*FCStkCostIn)
				   WHEN '5' THEN (FCStkQty*FCStkCostIn)
				END) AS FCStkCostIn,

			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostEX)
				   WHEN '1' THEN FCStkQty*FCStkCostEX
				   WHEN '2' THEN (FCStkQty*FCStkCostEX)*-1
				   WHEN '3' THEN (FCStkQty*FCStkCostEX)*-1
				   WHEN '4' THEN (FCStkQty*FCStkCostEX)
				   WHEN '5' THEN (FCStkQty*FCStkCostEX)
				END) AS FCStkCostEX,

			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostIn)
				END) AS FCStkCostMonthEndIN,			
				
			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostEx)
				END) AS FCStkCostMonthEndEx,			
				
			   SUM(CASE FTStkType
				   WHEN '1' THEN (FCStkQty*FCStkCostIn)
				   WHEN '2' THEN (FCStkQty*FCStkCostIn)*-1
				END) AS FCStkCostRcvIn,				

			   SUM(CASE FTStkType
				   WHEN '1' THEN (FCStkQty*FCStkCostEx)
				   WHEN '2' THEN (FCStkQty*FCStkCostEx)*-1
				END) AS FCStkCostRcvEx,
				
			   SUM(CASE FTStkType
				   WHEN '5' THEN (FCStkQty*FCStkCostIn)
				END) AS FCStkCostAdjIn,				

			   SUM(CASE FTStkType
				   WHEN '5' THEN (FCStkQty*FCStkCostEx)
				END) AS FCStkCostAdjEx,

										
					
			   SUM(CASE FTStkType
				   WHEN '3' THEN (FCStkQty*FCStkCostIn)*-1
				   WHEN '4' THEN FCStkQty*FCStkCostIn
				END) AS FCStkCostSaleIn,				
				
			   SUM(CASE FTStkType
				   WHEN '3' THEN (FCStkQty*FCStkCostEX)*-1
				   WHEN '4' THEN FCStkQty*FCStkCostEX
				END) AS FCStkCostSaleEx,
								
			   SUM(CASE FTStkType
				   WHEN '3' THEN FCStkSetPrice*-1
				   WHEN '4' THEN FCStkSetPrice
				END) AS FCStkSaleAmt
		
		FROM TCNTPdtStkCrd

		WHERE FTBchCode NOT IN(SELECT FTBchCode FROM TCNTPdtStkCrdBch) AND FTWahCode IN ('00001','00002','00003','00004','00005') 

			   --AND ((MONTH(FDStkDate) between 4 and 4) AND YEAR(FDStkDate) = 2015)  AND FTPdtCode = '1159-0250008491' AND FTBchCode = '001'
			  --AND FTPdtCode = '1159-0250008491' AND MONTH(FDStkDate) = 5 	AND 	YEAR(FDStkDate) = 2015 AND FTStkType in ('3','4')
		GROUP BY FTBchCode,FTWahCode,FTStkType,FTPdtCode,FDStkDate,MONTH(FDStkDate),YEAR(FDStkDate)

		UNION ALL
		SELECT FTBchCode,FTWahCode,StkBck.FTPdtCode,FDStkDate,MONTH(FDStkDate) AS FDStkMonth,YEAR(FDStkDate) AS FDStkYear,
				SUM(CASE FTStkType
				   WHEN '0' THEN FCStkQty
				END) AS FCStkQtyMonthEnd	,				
			   SUM(CASE FTStkType
				   WHEN '1' THEN FCStkQty
				   WHEN '2' THEN FCStkQty*-1
				END) AS FCStkQtyIn,
			   SUM(CASE FTStkType
				   WHEN '3' THEN FCStkQty*-1
				   WHEN '4' THEN FCStkQty
				END) AS FCStkQtySale	,
			   SUM(CASE FTStkType
				   --WHEN '0' THEN FCStkQty
				   WHEN '1' THEN FCStkQty
				   WHEN '2' THEN FCStkQty*-1
				   WHEN '3' THEN FCStkQty*-1
				   WHEN '4' THEN FCStkQty		   
				   WHEN '5' THEN FCStkQty
				END) AS FCStkQtyBalance	,
			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostIn)
				   WHEN '1' THEN (FCStkQty*FCStkCostIn)
				   WHEN '2' THEN (FCStkQty*FCStkCostIn)*-1
				   WHEN '3' THEN (FCStkQty*FCStkCostIn)*-1
				   WHEN '4' THEN (FCStkQty*FCStkCostIn)
				   WHEN '5' THEN (FCStkQty*FCStkCostIn)
				END) AS FCStkCostIn,

			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostEX)
				   WHEN '1' THEN (FCStkQty*FCStkCostEX)
				   WHEN '2' THEN (FCStkQty*FCStkCostEX)*-1
				   WHEN '3' THEN (FCStkQty*FCStkCostEX)*-1
				   WHEN '4' THEN (FCStkQty*FCStkCostEX)
				   WHEN '5' THEN (FCStkQty*FCStkCostEX)
				END) AS FCStkCostEX,
				

			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostIn)
				END) AS FCStkCostMonthEndIN,			
				
			   SUM(CASE FTStkType
				   WHEN '0' THEN (FCStkQty*FCStkCostEx)
				END) AS FCStkCostMonthEndEx,			
				
			   SUM(CASE FTStkType
				   WHEN '1' THEN (FCStkQty*FCStkCostIn)
				   WHEN '2' THEN (FCStkQty*FCStkCostIn)*-1
				END) AS FCStkCostRcvIn,				

			   SUM(CASE FTStkType
				   WHEN '1' THEN (FCStkQty*FCStkCostEx)
				   WHEN '2' THEN (FCStkQty*FCStkCostEx)*-1
				END) AS FCStkCostRcvEx,
				
			   SUM(CASE FTStkType
				   WHEN '5' THEN (FCStkQty*FCStkCostIn)
				END) AS FCStkCostAdjIn,				

			   SUM(CASE FTStkType
				   WHEN '5' THEN (FCStkQty*FCStkCostEx)
				END) AS FCStkCostAdjEx,
				
				
		   SUM(CASE FTStkType
				   WHEN '3' THEN (FCStkQty*FCStkCostIn)
				   WHEN '4' THEN (FCStkQty*FCStkCostIn) *-1
				END) AS FCStkCostSaleIn,				
				
			   SUM(CASE FTStkType
				   WHEN '3' THEN (FCStkQty*FCStkCostEX)
				   WHEN '4' THEN (FCStkQty*FCStkCostEX)*-1
				END) AS FCStkCostSaleEx,							
				
			   SUM(CASE FTStkType
				   WHEN '3' THEN FCStkSetPrice
				   WHEN '4' THEN FCStkSetPrice*-1
				END) AS FCStkSaleAmt
				
		FROM TCNTPdtStkCrdBch StkBck
		INNER JOIN
                      TCNMPdt ON StkBck.FTPdtCode = TCNMPdt.FTPdtCode   LEFT OUTER JOIN
                      TCNMPdtType ON TCNMPdt.FTPtyCode = TCNMPdtType.FTPtyCode
		WHERE FTWahCode IN ('00001','00002','00003','00004','00005')	
		GROUP BY FTBchCode,FTWahCode,FTStkType,StkBck.FTPdtCode,FDStkDate,MONTH(FDStkDate),YEAR(FDStkDate)
		) StkSum1
	
)StkSum LEFT JOIN    
	

	--Sale Price
	(SELECT FTPdtCode,FDStkMonth,FDStkYear,
		   --SUM(ISNULL(FCStkSetPrice,0))  AS FCStkSetPrice,
		   --SUM(ISNULL(FCStkQty,0)) AS FCStkQty,
		   CASE WHEN SUM(ISNULL(FCStkQty,0)) = 0 THEN 0 ELSE (SUM(ISNULL(FCStkSetPrice,0))/SUM(ISNULL(FCStkQty,0))) END AS FCStkSalePrice
	FROM(
		SELECT FTPdtCode,MONTH(FDStkDate) AS FDStkMonth,YEAR(FDStkDate) AS FDStkYear, SUM(FCStkSetPrice) AS FCStkSetPrice, SUM(FCStkQty) AS FCStkQty
		FROM TCNTPdtStkCrd
		WHERE FTStkType in ('3') AND FTWahCode IN ('001','002','003','004','005')
		GROUP BY FTPdtCode,MONTH(FDStkDate) ,YEAR(FDStkDate) 
		UNION ALL
		SELECT FTPdtCode,MONTH(FDStkDate) AS FDStkMonth,YEAR(FDStkDate) AS FDStkYear, SUM(FCStkSetPrice) AS FCStkSetPrice, SUM(FCStkQty) AS FCStkQty
		FROM TCNTPdtStkCrdBch
		WHERE FTStkType in ('3') AND FTWahCode IN ('001','002','003','004','005')
		GROUP BY FTPdtCode,MONTH(FDStkDate) ,YEAR(FDStkDate) 
) Stk
GROUP BY FTPdtCode,FDStkMonth,FDStkYear		   	
			) SaleP ON                
		                StkSum.FTPdtCode = SaleP.FTPdtCode AND 
		                StkSum.FDStkMonth = SaleP.FDStkMonth AND 
		                StkSum.FDStkYear = SaleP.FDStkYear	

		
		INNER JOIN
                      TCNMPdt ON StkSum.FTPdtCode = TCNMPdt.FTPdtCode   