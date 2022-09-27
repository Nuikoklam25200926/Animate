DECLARE @ptDateF VARCHAR(10) = '2022-07-25'
DECLARE @ptDateT VARCHAR(10)= '2022-08-30'
SELECT FTPtyName,FTPbnName,FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,ISNULL(FCPdtStkSetPrice,0) AS FCPdtStkSetPrice,ISNULL(FCPdtStkQtySale,0) AS FCPdtStkQtySale,
ISNULL(FCPdtStkQtyIn,0) AS FCPdtStkQtyIn,ISNULL(FCStkQtyMthEnd,0)+ISNULL(FCPdtStkQtyIn,0)-ISNULL(FCPdtStkQtySale,0) AS FCStkQtyBal
FROM(
		SELECT FTPtyName,FTPbnName,STK.FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,StkSetPrice.FCPdtStkSetPrice,
		SUM(CASE FTStkType
		WHEN '3' THEN ISNULL(Stk.FCStkQty,0)  --ขาย
		WHEN '4' THEN ISNULL(Stk.FCStkQty,0)*-1 --คืน
		END) AS FCPdtStkQtySale,
		SUM(CASE FTStkType
		WHEN '1' THEN ISNULL(Stk.FCStkQty,0) --เข้า
		WHEN '2' THEN ISNULL(Stk.FCStkQty,0)*-1 --ออก
		WHEN '5' THEN ISNULL(Stk.FCStkQty,0) -- ปรับจำนวน + : เข้า , - : ออก
		END) AS FCPdtStkQtyIn,SUM(ISNULL(MthEnd.FCStkQtyMthEnd,0))  + SUM(ISNULL(MthEnd1.FCStkQtyMthEnd,0)) AS FCStkQtyMthEnd

		FROM TCNTPdtStkCrd Stk WITH (NOLOCK)
		LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk.FTPdtCode = PdtM.FTPdtCode
		LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode
		LEFT JOIN 
		(SELECT FTBchCode,FTWahCode,Stk.FTPdtCode,
		 CASE WHEN 
				SUM(CASE FTStkType
				WHEN '3' THEN ISNULL(Stk.FCStkQty,0)  --ขาย
				WHEN '4' THEN ISNULL(Stk.FCStkQty,0)*-1 --คืน
				END) = 0 THEN 0 				
   		 ELSE			 
				(SUM(CASE FTStkType
			 	     WHEN '3' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))  --ขาย
				     WHEN '4' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))*-1 --คืน
				     END) / 
				 SUM(CASE FTStkType
				     WHEN '3' THEN ISNULL(Stk.FCStkQty,0)  --ขาย
				     WHEN '4' THEN ISNULL(Stk.FCStkQty,0)*-1 --คืน
				    END)) 
		 END AS FCPdtStkSetPrice
		 FROM TCNTPdtStkCrd Stk WITH (NOLOCK)		 
		 WHERE FTStkType IN ('3','4') AND ISNULL(FCStkSetPrice,0) <> 0
		 GROUP BY FTBchCode,FTWahCode,Stk.FTPdtCode
		 ) StkSetPrice ON STK.FTBchCode = StkSetPrice.FTBchCode AND STK.FTPdtCode = StkSetPrice.FTPdtCode AND STK.FTWahCode = StkSetPrice.FTWahCode
		 LEFT JOIN
				(--Pdt
					SELECT Pdt.FTPdtCode,PdtL.FTPdtName,ISNULL(PdtL.FTPdtNameOth,'') AS FTPdtNameOth,PdtBar.FTBarCode,ISNULL(PtyL.FTPtyName,'') AS FTPtyName,ISNULL(PbnL.FTPbnName,'') AS FTPbnName
					FROM TCNMPdt Pdt WITH(NOLOCK)
					LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = '1'
					LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '1'
					LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPbnCode = PtyL.FTPtyCode AND PtyL.FNLngID = '1'
					LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK) ON Pdt.FTPdtCode = Ppz.FTPdtCode AND FCPdtUnitFact = 1
					LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode
				) Pdt ON Stk.FTpdtCode = Pdt.FTPdtCode
		LEFT JOIN 
				(--TCNTPdtStkCrdME
					SELECT FDStkDate,StkME.FTBchCode,StkME.FTPdtCode,FCStkQty AS  FCStkQtyMthEnd,FORMAT(FDStkDate, 'yyyy-MM') AS FTStkMonthYer
					FROM TCNTPdtStkCrdME StkME WITH(NOLOCK)
					WHERE FORMAT(FDStkDate, 'yyyy-MM') = FORMAT(CONVERT(DATETIME,2022-07-25), 'yyyy-MM')
				) MthEnd ON Stk.FTBchCode = MthEnd.FTBchCode AND Stk.FTPdtCode = MthEnd.FTPdtCode AND FORMAT(Stk.FDStkDate, 'yyyy-MM') = FORMAT(MthEnd.FDStkDate, 'yyyy-MM')
				  LEFT JOIN
				(--	TCNTPdtStkCrd ยอดยกมา เพื่อรวม กับ Qty ใน TCNTPdtStkCrdME						
					SELECT FTBchCode,FTPdtCode,FORMAT(FDStkDate, 'yyyy-MM') AS FTStkMonthYer,
					SUM(CASE FTStkType
					WHEN '3' THEN ISNULL(Stk1.FCStkQty,0)*-1  --ขาย
					WHEN '4' THEN ISNULL(Stk1.FCStkQty,0) --คืน
					WHEN '1' THEN ISNULL(Stk1.FCStkQty,0) --เข้า
					WHEN '2' THEN ISNULL(Stk1.FCStkQty,0)*-1 --ออก
					WHEN '5' THEN ISNULL(Stk1.FCStkQty,0) -- ปรับจำนวน + : เข้า , - : ออก
					END) AS  FCStkQtyMthEnd
					FROM TCNTPdtStkCrd  Stk1 WITH(NOLOCK)
					WHERE CONVERT(VARCHAR(10),Stk1.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,@ptDateF), 'yyyy-MM-01') AND CONVERT(VARCHAR(10),Stk1.FDStkDate,121) < @ptDateF--@ptDateF
					GROUP BY FTBchCode,FTPdtCode,FORMAT(FDStkDate, 'yyyy-MM')
				) MthEnd1 ON STK.FTBchCode = MthEnd1.FTBchCode AND STK.FTPdtCode = MthEnd1.FTPdtCode AND FORMAT(STK.FDStkDate, 'yyyy-MM') = MthEnd1.FTStkMonthYer
		--
		 --WHERE CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,@ptDateF), 'yyyy-MM-01') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= @ptDateT
		GROUP BY FTPtyName,FTPbnName,STK.FTPdtCode,Pdt.FTPdtName,Pdt.FTPdtNameOth,Pdt.FTBarCode,StkSetPrice.FCPdtStkSetPrice--,ISNULL(MthEnd.FCStkQtyMthEnd,0)  + ISNULL(MthEnd1.FCStkQtyMthEnd,0) 
	) SalData
		--SELECT * FROM TCNTPdtStkCrdMe
		--SELECT * FROM TCNTPdtStkCrdBch

		--SELECT FCStkSetPrice,* FROM TCNTPdtStkCrd Stk WITH (NOLOCK) WHERE FTPdtCode = '00008'