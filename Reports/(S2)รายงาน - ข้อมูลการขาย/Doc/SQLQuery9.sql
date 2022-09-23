        SELECT StkBal.FTBchCode,BchL.FTBchName, StkBal.FTPdtCode, PdtBar.FTBarCode, PdtL.FTPdtName, PgpL.FTPgpChainName, PbnL.FTPbnName, 
               SUM(ISNULL(StkBal.FCStkQty, 0)) AS FCStkQty, 
               PForPdt.FCPgdPriceRet
        FROM TCNTPdtStkBal StkBal WITH(NOLOCK)
             INNER JOIN TCNMPdt Pdt WITH(NOLOCK) ON Pdt.FTPdtCode = StkBal.FTPdtCode
             LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '1'
             LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = '1'
             LEFT JOIN TCNMPdtGrp_L PgpL WITH(NOLOCK) ON Pdt.FTPgpChain = PgpL.FTPgpChain AND PgpL.FNLngID = '1'
             LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK) ON StkBal.FTPdtCode = Ppz.FTPdtCode AND FCPdtUnitFact = 1
             LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode
             LEFT JOIN TCNMBranch_L BchL WITH(NOLOCK) ON StkBal.FTBchCode = BchL.FTBchCode AND BchL.FNLngID = '1'
             LEFT JOIN
        (
            SELECT SUBSTRING(FTPghDocNo, 3, 5) AS FTBchCode, 
                   FTPdtCode, FTPunCode, MAX(FDPghDStop) AS FDPghDStop, AVG(FCPgdPriceRet) AS FCPgdPriceRet
            FROM TCNTPdtPrice4PDT
            GROUP BY SUBSTRING(FTPghDocNo, 3, 5),  FTPdtCode,  FTPunCode
        ) PForPdt ON StkBal.FTBchCode = PForPdt.FTBchCode AND StkBal.FTPdtCode = PForPdt.FTPdtCode
        WHERE Ppz.FCPdtUnitFact = 1
        GROUP BY StkBal.FTBchCode,  BchL.FTBchName, StkBal.FTPdtCode, PdtBar.FTBarCode, PdtL.FTPdtName, PgpL.FTPgpChainName, PbnL.FTPbnName, PForPdt.FCPgdPriceRet


		SELECT * FROM TCNTPdtStkCrd WHERE FTPdtCode = '00001'
		SELECT * FROM TCNTPdtStkCrdMe
		SELECT * FROM TCNTPdtStkCrdBch
