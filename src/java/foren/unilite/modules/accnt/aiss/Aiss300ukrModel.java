package foren.unilite.modules.accnt.aiss;

import foren.framework.model.BaseVO;

/**
 * @author jangwonhyeok
 *
 */
public class Aiss300ukrModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String COMP_CODE;
    private String USER_ID;   
    private String ASST;             
    private String ASST_NAME;        
    private String SPEC;             
    private String ACCNT;            
    private String DIV_CODE;         
    private String DEPT_CODE;        
    private String DEPT_NAME;        
    private String PJT_CODE;         
    private String DRB_YEAR;         
    private String MONEY_UNIT;       
    private Double EXCHG_RATE_O;     
    private Double FOR_ACQ_AMT_I;    
    private Double ACQ_AMT_I;        
    private String ACQ_Q;            
    private String STOCK_Q;          
    private String QTY_UNIT;         
    private String ACQ_DATE;         
    private String USE_DATE;         
    private String COST_POOL_CODE;   
    private String COST_DIRECT;      
    private String ITEM_LEVEL1;      
    private String ITEM_LEVEL2;      
    private String ITEM_LEVEL3;      
    private String CUSTOM_CODE;      
    private String CUSTOM_NAME;      
    private String PERSON_NUMB;      
    private String PLACE_INFO;       
    private String SERIAL_NO;        
    private String BAR_CODE;         
    private String REMARK;           
    private String DPR_STS;          
    private Double SALE_MANAGE_COST; 
    private Double PRODUCE_COST;     
    private Double SALE_COST;        
    private Double SUBCONTRACT_COST;        
    private String DEP_ACCNT;
    private Double FI_CAPI_TOT_I;    
    private Double FI_SALE_TOT_I;    
    private Double FI_SALE_DPR_TOT_I;
    private Double FI_DPR_TOT_I;     
    private Double FL_BALN_I;        
    private String WASTE_YYYYMM;     
    private String WASTE_SW;         
    private String DPR_YYYYMM;       
    private String DPR_STS2;         
    private String SET_TYPE;         
    private String PROOF_KIND;       
    private Double SUPPLY_AMT_I;     
    private Double TAX_AMT_I;        
    private String AC_CUSTOM_CODE;   
    private String SAVE_CODE;        
    private String CRDT_NUM;         
    private String REASON_CODE;      
    private String PAY_DATE;         
    private String EB_YN;
    private String ASST_DIVI;
    private String MAKER_NAME;
	private String PURCHASE_DEPT_CODE;
    private String PURCHASE_DEPT_NAME;
    private String SAVE_FLAG;
    private String AUTO_TYPE;
    private String DEP_CTL;    
    private String ASST_STS;    
    private String PAT_YN;      
    private String DMG_OJ_YN;  
    private Double FI_REVAL_TOT_I;   
    private Double FI_REVAL_DPR_TOT_I;
    private Double FI_DMGLOS_TOT_I;
    private String WDAMT_MTD;
    private Double H_ACQ_AMT_I;
    
	private String SALE_MANAGE_DEPT_CODE;
    private String SALE_MANAGE_DEPT_NAME;
    private String PRODUCE_DEPT_CODE;
    private String PRODUCE_DEPT_NAME;
    private String SALE_DEPT_CODE;    
    private String SALE_DEPT_NAME;    
    private String SUBCONTRACT_DEPT_CODE;      
    private String SUBCONTRACT_DEPT_NAME;  
    
    private String GOV_GRANT_ACCNT	   ;   /*  국가보조금 계정과목   */
    private Double GOV_GRANT_AMT_I     ;   /*  국가보조금               */
    private Double GOV_GRANT_DPR_TOT_I ;   /*  국가보조금 상각누계액 */
    private Double GOV_GRANT_BALN_I    ;   /*  국가보조금 미상각잔액 */
    
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}	
	public String getUSER_ID() {
		return USER_ID;
	}
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	public String getASST() {
		return ASST;
	}
	public void setASST(String aSST) {
		ASST = aSST;
	}
	public String getASST_NAME() {
		return ASST_NAME;
	}
	public void setASST_NAME(String aSST_NAME) {
		ASST_NAME = aSST_NAME;
	}
	public String getSPEC() {
		return SPEC;
	}
	public void setSPEC(String sPEC) {
		SPEC = sPEC;
	}
	public String getACCNT() {
		return ACCNT;
	}
	public void setACCNT(String aCCNT) {
		ACCNT = aCCNT;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getDEPT_CODE() {
		return DEPT_CODE;
	}
	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}
	public String getDEPT_NAME() {
		return DEPT_NAME;
	}
	public void setDEPT_NAME(String dEPT_NAME) {
		DEPT_NAME = dEPT_NAME;
	}
	public String getPJT_CODE() {
		return PJT_CODE;
	}
	public void setPJT_CODE(String pJT_CODE) {
		PJT_CODE = pJT_CODE;
	}
	public String getDRB_YEAR() {
		return DRB_YEAR;
	}
	public void setDRB_YEAR(String dRB_YEAR) {
		DRB_YEAR = dRB_YEAR;
	}
	public String getMONEY_UNIT() {
		return MONEY_UNIT;
	}
	public void setMONEY_UNIT(String mONEY_UNIT) {
		MONEY_UNIT = mONEY_UNIT;
	}
	public Double getEXCHG_RATE_O() {
		return EXCHG_RATE_O;
	}
	public void setEXCHG_RATE_O(Double eXCHG_RATE_O) {
		EXCHG_RATE_O = eXCHG_RATE_O;
	}
	public Double getFOR_ACQ_AMT_I() {
		return FOR_ACQ_AMT_I;
	}
	public void setFOR_ACQ_AMT_I(Double fOR_ACQ_AMT_I) {
		FOR_ACQ_AMT_I = fOR_ACQ_AMT_I;
	}
	public Double getACQ_AMT_I() {
		return ACQ_AMT_I;
	}
	public void setACQ_AMT_I(Double aCQ_AMT_I) {
		ACQ_AMT_I = aCQ_AMT_I;
	}
	public String getACQ_Q() {
		return ACQ_Q;
	}
	public void setACQ_Q(String aCQ_Q) {
		ACQ_Q = aCQ_Q;
	}
	public String getSTOCK_Q() {
		return STOCK_Q;
	}
	public void setSTOCK_Q(String sTOCK_Q) {
		STOCK_Q = sTOCK_Q;
	}
	public String getQTY_UNIT() {
		return QTY_UNIT;
	}
	public void setQTY_UNIT(String qTY_UNIT) {
		QTY_UNIT = qTY_UNIT;
	}
	public String getACQ_DATE() {
		return ACQ_DATE;
	}
	public void setACQ_DATE(String aCQ_DATE) {
		ACQ_DATE = aCQ_DATE;
	}
	public String getUSE_DATE() {
		return USE_DATE;
	}
	public void setUSE_DATE(String uSE_DATE) {
		USE_DATE = uSE_DATE;
	}
	public String getCOST_POOL_CODE() {
		return COST_POOL_CODE;
	}
	public void setCOST_POOL_CODE(String cOST_POOL_CODE) {
		COST_POOL_CODE = cOST_POOL_CODE;
	}
	public String getCOST_DIRECT() {
		return COST_DIRECT;
	}
	public void setCOST_DIRECT(String cOST_DIRECT) {
		COST_DIRECT = cOST_DIRECT;
	}
	public String getITEM_LEVEL1() {
		return ITEM_LEVEL1;
	}
	public void setITEM_LEVEL1(String iTEM_LEVEL1) {
		ITEM_LEVEL1 = iTEM_LEVEL1;
	}
	public String getITEM_LEVEL2() {
		return ITEM_LEVEL2;
	}
	public void setITEM_LEVEL2(String iTEM_LEVEL2) {
		ITEM_LEVEL2 = iTEM_LEVEL2;
	}
	public String getITEM_LEVEL3() {
		return ITEM_LEVEL3;
	}
	public void setITEM_LEVEL3(String iTEM_LEVEL3) {
		ITEM_LEVEL3 = iTEM_LEVEL3;
	}
	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}
	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}
	public String getCUSTOM_NAME() {
		return CUSTOM_NAME;
	}
	public void setCUSTOM_NAME(String cUSTOM_NAME) {
		CUSTOM_NAME = cUSTOM_NAME;
	}
	public String getPERSON_NUMB() {
		return PERSON_NUMB;
	}
	public void setPERSON_NUMB(String pERSON_NUMB) {
		PERSON_NUMB = pERSON_NUMB;
	}
	public String getPLACE_INFO() {
		return PLACE_INFO;
	}
	public void setPLACE_INFO(String pLACE_INFO) {
		PLACE_INFO = pLACE_INFO;
	}
	public String getSERIAL_NO() {
		return SERIAL_NO;
	}
	public void setSERIAL_NO(String sERIAL_NO) {
		SERIAL_NO = sERIAL_NO;
	}
	public String getBAR_CODE() {
		return BAR_CODE;
	}
	public void setBAR_CODE(String bAR_CODE) {
		BAR_CODE = bAR_CODE;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getDPR_STS() {
		return DPR_STS;
	}
	public void setDPR_STS(String dPR_STS) {
		DPR_STS = dPR_STS;
	}
	public Double getSALE_MANAGE_COST() {
		return SALE_MANAGE_COST;
	}
	public void setSALE_MANAGE_COST(Double sALE_MANAGE_COST) {
		SALE_MANAGE_COST = sALE_MANAGE_COST;
	}
	public Double getPRODUCE_COST() {
		return PRODUCE_COST;
	}
	public void setPRODUCE_COST(Double pRODUCE_COST) {
		PRODUCE_COST = pRODUCE_COST;
	}
	public Double getSALE_COST() {
		return SALE_COST;
	}
	public void setSALE_COST(Double sALE_COST) {
		SALE_COST = sALE_COST;
	}
	
	public Double getSUBCONTRACT_COST() {
		return SUBCONTRACT_COST;
	}
	public void setSUBCONTRACT_COST(Double sUBCONTRACT_COST) {
		SUBCONTRACT_COST = sUBCONTRACT_COST;
	}
	public String getDEP_ACCNT() {
		return DEP_ACCNT;
	}
	public void setDEP_ACCNT(String dEP_ACCNT) {
		DEP_ACCNT = dEP_ACCNT;
	}
	public Double getFI_CAPI_TOT_I() {
		return FI_CAPI_TOT_I;
	}
	public void setFI_CAPI_TOT_I(Double fI_CAPI_TOT_I) {
		FI_CAPI_TOT_I = fI_CAPI_TOT_I;
	}
	public Double getFI_SALE_TOT_I() {
		return FI_SALE_TOT_I;
	}
	public void setFI_SALE_TOT_I(Double fI_SALE_TOT_I) {
		FI_SALE_TOT_I = fI_SALE_TOT_I;
	}
	public Double getFI_SALE_DPR_TOT_I() {
		return FI_SALE_DPR_TOT_I;
	}
	public void setFI_SALE_DPR_TOT_I(Double fI_SALE_DPR_TOT_I) {
		FI_SALE_DPR_TOT_I = fI_SALE_DPR_TOT_I;
	}
	public Double getFI_DPR_TOT_I() {
		return FI_DPR_TOT_I;
	}
	public void setFI_DPR_TOT_I(Double fI_DPR_TOT_I) {
		FI_DPR_TOT_I = fI_DPR_TOT_I;
	}
	public Double getFL_BALN_I() {
		return FL_BALN_I;
	}
	public void setFL_BALN_I(Double fL_BALN_I) {
		FL_BALN_I = fL_BALN_I;
	}
	public String getWASTE_YYYYMM() {
		return WASTE_YYYYMM;
	}
	public void setWASTE_YYYYMM(String wASTE_YYYYMM) {
		WASTE_YYYYMM = wASTE_YYYYMM;
	}
	public String getWASTE_SW() {
		return WASTE_SW;
	}
	public void setWASTE_SW(String wASTE_SW) {
		WASTE_SW = wASTE_SW;
	}
	public String getDPR_YYYYMM() {
		return DPR_YYYYMM;
	}
	public void setDPR_YYYYMM(String dPR_YYYYMM) {
		DPR_YYYYMM = dPR_YYYYMM;
	}
	public String getDPR_STS2() {
		return DPR_STS2;
	}
	public void setDPR_STS2(String dPR_STS2) {
		DPR_STS2 = dPR_STS2;
	}
	public String getSET_TYPE() {
		return SET_TYPE;
	}
	public void setSET_TYPE(String sET_TYPE) {
		SET_TYPE = sET_TYPE;
	}
	public String getPROOF_KIND() {
		return PROOF_KIND;
	}
	public void setPROOF_KIND(String pROOF_KIND) {
		PROOF_KIND = pROOF_KIND;
	}
	public Double getSUPPLY_AMT_I() {
		return SUPPLY_AMT_I;
	}
	public void setSUPPLY_AMT_I(Double sUPPLY_AMT_I) {
		SUPPLY_AMT_I = sUPPLY_AMT_I;
	}
	public Double getTAX_AMT_I() {
		return TAX_AMT_I;
	}
	public void setTAX_AMT_I(Double tAX_AMT_I) {
		TAX_AMT_I = tAX_AMT_I;
	}
	public String getAC_CUSTOM_CODE() {
		return AC_CUSTOM_CODE;
	}
	public void setAC_CUSTOM_CODE(String aC_CUSTOM_CODE) {
		AC_CUSTOM_CODE = aC_CUSTOM_CODE;
	}
	public String getSAVE_CODE() {
		return SAVE_CODE;
	}
	public void setSAVE_CODE(String sAVE_CODE) {
		SAVE_CODE = sAVE_CODE;
	}
	public String getCRDT_NUM() {
		return CRDT_NUM;
	}
	public void setCRDT_NUM(String cRDT_NUM) {
		CRDT_NUM = cRDT_NUM;
	}
	public String getREASON_CODE() {
		return REASON_CODE;
	}
	public void setREASON_CODE(String rEASON_CODE) {
		REASON_CODE = rEASON_CODE;
	}
	public String getPAY_DATE() {
		return PAY_DATE;
	}
	public void setPAY_DATE(String pAY_DATE) {
		PAY_DATE = pAY_DATE;
	}
	public String getEB_YN() {
		return EB_YN;
	}
	public void setEB_YN(String eB_YN) {
		EB_YN = eB_YN;
	}   
	public String getASST_DIVI() {
		return ASST_DIVI;
	}
	public void setASST_DIVI(String aSST_DIVI) {
		ASST_DIVI = aSST_DIVI;
	}
	public String getMAKER_NAME() {
		return MAKER_NAME;
	}
	public void setMAKER_NAME(String mAKER_NAME) {
		MAKER_NAME = mAKER_NAME;
	}
	public String getPURCHASE_DEPT_CODE() {
		return PURCHASE_DEPT_CODE;
	}
	public void setPURCHASE_DEPT_CODE(String pURCHASE_DEPT_CODE) {
		PURCHASE_DEPT_CODE = pURCHASE_DEPT_CODE;
	}
	public String getPURCHASE_DEPT_NAME() {
		return PURCHASE_DEPT_NAME;
	}
	public void setPURCHASE_DEPT_NAME(String pURCHASE_DEPT_NAME) {
		PURCHASE_DEPT_NAME = pURCHASE_DEPT_NAME;
	}
	public String getSAVE_FLAG() {
		return SAVE_FLAG;
	}
	public void setSAVE_FLAG(String sAVE_FLAG) {
		SAVE_FLAG = sAVE_FLAG;
	}
	public String getAUTO_TYPE() {
		return AUTO_TYPE;
	}
	public void setAUTO_TYPE(String aUTO_TYPE) {
		AUTO_TYPE = aUTO_TYPE;
	}
	public String getDEP_CTL() {
		return DEP_CTL;
	}
	public void setDEP_CTL(String dEP_CTL) {
		DEP_CTL = dEP_CTL;
	}
	public String getASST_STS() {
		return ASST_STS;
	}
	public void setASST_STS(String aSST_STS) {
		ASST_STS = aSST_STS;
	}
	public String getPAT_YN() {
		return PAT_YN;
	}
	public void setPAT_YN(String pAT_YN) {
		PAT_YN = pAT_YN;
	}
	public String getDMG_OJ_YN() {
		return DMG_OJ_YN;
	}
	public void setDMG_OJ_YN(String dMG_OJ_YN) {
		DMG_OJ_YN = dMG_OJ_YN;
	}
	public Double getFI_REVAL_TOT_I() {
		return FI_REVAL_TOT_I;
	}
	public void setFI_REVAL_TOT_I(Double fI_REVAL_TOT_I) {
		FI_REVAL_TOT_I = fI_REVAL_TOT_I;
	}
	public Double getFI_REVAL_DPR_TOT_I() {
		return FI_REVAL_DPR_TOT_I;
	}
	public void setFI_REVAL_DPR_TOT_I(Double fI_REVAL_DPR_TOT_I) {
		FI_REVAL_DPR_TOT_I = fI_REVAL_DPR_TOT_I;
	}
	public Double getFI_DMGLOS_TOT_I() {
		return FI_DMGLOS_TOT_I;
	}
	public void setFI_DMGLOS_TOT_I(Double fI_DMGLOS_TOT_I) {
		FI_DMGLOS_TOT_I = fI_DMGLOS_TOT_I;
	}
	public String getWDAMT_MTD() {
		return WDAMT_MTD;
	}
	public void setWDAMT_MTD(String wDAMT_MTD) {
		WDAMT_MTD = wDAMT_MTD;
	}
	public Double getH_ACQ_AMT_I() {
		return H_ACQ_AMT_I;
	}
	public void setH_ACQ_AMT_I(Double h_ACQ_AMT_I) {
		H_ACQ_AMT_I = h_ACQ_AMT_I;
	}
	public String getSALE_MANAGE_DEPT_CODE() {
		return SALE_MANAGE_DEPT_CODE;
	}
	public void setSALE_MANAGE_DEPT_CODE(String sALE_MANAGE_DEPT_CODE) {
		SALE_MANAGE_DEPT_CODE = sALE_MANAGE_DEPT_CODE;
	}
	public String getSALE_MANAGE_DEPT_NAME() {
		return SALE_MANAGE_DEPT_NAME;
	}
	public void setSALE_MANAGE_DEPT_NAME(String sALE_MANAGE_DEPT_NAME) {
		SALE_MANAGE_DEPT_NAME = sALE_MANAGE_DEPT_NAME;
	}
	public String getPRODUCE_DEPT_CODE() {
		return PRODUCE_DEPT_CODE;
	}
	public void setPRODUCE_DEPT_CODE(String pRODUCE_DEPT_CODE) {
		PRODUCE_DEPT_CODE = pRODUCE_DEPT_CODE;
	}
	public String getPRODUCE_DEPT_NAME() {
		return PRODUCE_DEPT_NAME;
	}
	public void setPRODUCE_DEPT_NAME(String pRODUCE_DEPT_NAME) {
		PRODUCE_DEPT_NAME = pRODUCE_DEPT_NAME;
	}
	public String getSALE_DEPT_CODE() {
		return SALE_DEPT_CODE;
	}
	public void setSALE_DEPT_CODE(String sALE_DEPT_CODE) {
		SALE_DEPT_CODE = sALE_DEPT_CODE;
	}
	public String getSALE_DEPT_NAME() {
		return SALE_DEPT_NAME;
	}
	public void setSALE_DEPT_NAME(String sALE_DEPT_NAME) {
		SALE_DEPT_NAME = sALE_DEPT_NAME;
	}
	public String getSUBCONTRACT_DEPT_CODE() {
		return SUBCONTRACT_DEPT_CODE;
	}
	public void setSUBCONTRACT_DEPT_CODE(String sUBCONTRACT_DEPT_CODE) {
		SUBCONTRACT_DEPT_CODE = sUBCONTRACT_DEPT_CODE;
	}
	public String getSUBCONTRACT_DEPT_NAME() {
		return SUBCONTRACT_DEPT_NAME;
	}
	public void setSUBCONTRACT_DEPT_NAME(String sUBCONTRACT_DEPT_NAME) {
		SUBCONTRACT_DEPT_NAME = sUBCONTRACT_DEPT_NAME;
	}
	public String getGOV_GRANT_ACCNT() {
		return GOV_GRANT_ACCNT;
	}
	public Double getGOV_GRANT_AMT_I() {
		return GOV_GRANT_AMT_I;
	}
	public Double getGOV_GRANT_DPR_TOT_I() {
		return GOV_GRANT_DPR_TOT_I;
	}
	public Double getGOV_GRANT_BALN_I() {
		return GOV_GRANT_BALN_I;
	}
	public void setGOV_GRANT_ACCNT(String gOV_GRANT_ACCNT) {
		GOV_GRANT_ACCNT = gOV_GRANT_ACCNT;
	}
	public void setGOV_GRANT_AMT_I(Double gOV_GRANT_AMT_I) {
		GOV_GRANT_AMT_I = gOV_GRANT_AMT_I;
	}
	public void setGOV_GRANT_DPR_TOT_I(Double gOV_GRANT_DPR_TOT_I) {
		GOV_GRANT_DPR_TOT_I = gOV_GRANT_DPR_TOT_I;
	}
	public void setGOV_GRANT_BALN_I(Double gOV_GRANT_BALN_I) {
		GOV_GRANT_BALN_I = gOV_GRANT_BALN_I;
	}
	
}
