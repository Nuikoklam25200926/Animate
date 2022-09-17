

--SELECT DT.FTBchCode, DT.FTXshDocNo, FTXsdBarCode, Pdt.FTPgpChain,PdtL.FTPdtName,
--SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdQtyAll,0) ELSE ISNULL(FCXsdQtyAll,0)-1 END) AS FCXsdQtyAll,
--SUM(CASE WHEN FNXshDocType = 1 THEN DisPmt.FCXsdDisPmt ELSE DisPmt.FCXsdDisPmt*-1 END ) AS FCXsdDisPmt,
--SUM(CASE WHEN FNXshDocType = 1 THEN DTDis.FCXsdDTDis ELSE DTDis.FCXsdDTDis*-1 END ) AS FCXsdDTDis,
--SUM(CASE WHEN FNXshDocType = 1 THEN HDDis.FCXsdHDDis ELSE HDDis.FCXsdHDDis*-1 END ) AS FCXsdHDDis

SELECT  --DT.FTBchCode, DT.FTPdtCode, FTXsdBarCode, Pdt.FTPgpChain,
SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdQtyAll,0) ELSE ISNULL(FCXsdQtyAll,0) * - 1 END) AS FCXsdQtyAll,
SUM(CASE WHEN FNXshDocType = 1 THEN FCXsdNet ELSE FCXsdNet * - 1 END) AS FCXsdNet,
SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDisPmt,0) ELSE  ISNULL(FCXsdDisPmt,0)*-1 END)  AS FCXsdDisPmt,
SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDTDis,0) ELSE ISNULL(FCXsdDTDis,0)*-1 END)  AS FCXsdDTDis,
SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdHDDis,0) ELSE ISNULL(FCXsdHDDis,0)*-1 END) AS FCXsdHDDis,
SUM(CASE WHEN FNXshDocType = 1 THEN FCXsdNet ELSE FCXsdNet * - 1 END)-SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDTDis,0) ELSE ISNULL(FCXsdDTDis,0)*-1 END) AS FCSdtNetSale,
SUM(CASE WHEN FNXshDocType = 1 THEN FCXsdNet ELSE FCXsdNet * - 1 END)-SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDTDis,0) ELSE ISNULL(FCXsdDTDis,0)*-1 END)-SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDisPmt,0) ELSE  ISNULL(FCXsdDisPmt,0)*-1 END)+SUM(CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdHDDis,0) ELSE ISNULL(FCXsdHDDis,0)*-1 END) AS FCSdtNetAmt

FROM TPSTSalDT DT 
INNER JOIN TPSTSalHD HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
LEFT JOIN TCNMPdt Pdt WITH (NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode
LEFT JOIN TCNMPdt_L PdtL WITH (NOLOCK) ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = 1
LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode  
LEFT JOIN 
(SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,
					  CASE FTXddDisChgType 
					    WHEN '1' THEN FCXddValue *-1
					    WHEN '2' THEN FCXddValue *-1
					    WHEN '3' THEN FCXddValue
					    WHEN '4' THEN FCXddValue
					  END AS FCXsdDisPmt
					  FROM TPSTSalDTDis DTDis  WITH (NOLOCK)
					  WHERE FNXddStaDis = 0
) DisPmt ON DT.FTBchCode = DisPmt.FTBchCode AND DT.FTXshDocNo = DisPmt.FTXshDocNo AND DT.FNXsdSeqNo = DisPmt.FNXsdSeqNo

LEFT JOIN 
(SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,
					  CASE FTXddDisChgType 
					    WHEN '1' THEN FCXddValue *-1
					    WHEN '2' THEN FCXddValue *-1
					    WHEN '3' THEN FCXddValue
					    WHEN '4' THEN FCXddValue
					  END AS FCXsdDTDis
					  FROM TPSTSalDTDis DTDis  WITH (NOLOCK)
					  WHERE FNXddStaDis = 1
) DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo

LEFT JOIN 
(SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,
					  CASE FTXddDisChgType 
					    WHEN '1' THEN FCXddValue *-1
					    WHEN '2' THEN FCXddValue *-1
					    WHEN '3' THEN FCXddValue
					    WHEN '4' THEN FCXddValue
					  END AS FCXsdHDDis
					  FROM TPSTSalDTDis DTDis  WITH (NOLOCK)				 
					  WHERE FNXddStaDis = 2
) HDDis ON DT.FTBchCode = HDDis.FTBchCode AND DT.FTXshDocNo = HDDis.FTXshDocNo AND DT.FNXsdSeqNo = HDDis.FNXsdSeqNo
WHERE CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN '2022-08-01' AND '2022-09-17'
AND HD.FTBchCode IN ('00001','00005') AND DT.FTXsdStaPdt <> '4'
--GROUP BY DT.FTBchCode,  DT.FTPdtCode, FTXsdBarCode, Pdt.FTPgpChain


SELECT SUM(FCXsdQtyAll) AS FCXsdQtyAll , SUM(FCSdtNetSale) AS FCSdtNetSale, SUM(FCSdtNetAmt) AS FCSdtNetAmt
FROM TRPTSalDTTmp_Animate
WHERE FCXsdQtyAll <> 0

