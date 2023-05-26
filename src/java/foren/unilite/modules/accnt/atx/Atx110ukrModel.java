package foren.unilite.modules.accnt.atx;

import foren.framework.model.BaseVO;

public class Atx110ukrModel extends BaseVO {
    /** 세금계산서 등록 panelSearch (L_ATX110T)
	 * 
	 */
	private static long serialVersionUID = 1L;
    
    private String KEY_VALUE;
    private String OPR_FLAG;
    private String FLAG;
    
    private String COMP_CODE; 
    private String DIV_CODE; 
    private String PUB_NUM; 
    private String BILL_TYPE; 
    private String BILL_DATE; 
    private String PUB_FR_DATE; 
    private String PUB_TO_DATE; 
    private String CUSTOM_CODE; 
    private int    SALE_AMT_O; 
    private int    SALE_LOC_AMT_I; 
    private int    TAX_AMT_O; 
    private int    COLET_AMT; 
    private String COLET_CUST_CD; 
    private String REMARK; 
    private String PROJECT_NO; 
    private String SALE_PROFIT; 
    private String SALE_DIV_CODE; 
    private String COLLECT_CARE; 
    private String EX_DATE; 
    private int    EX_NUM; 
    private String AC_DATE; 
    private int    AC_NUM; 
    private String AGREE_YN; 
    private String RECEIPT_PLAN_DATE; 
    private String TAX_CALC_TYPE; 
    private String CLOSING_YN; 
    private String BILL_GUBUN; 
    private String BILL_PUBLISH_TYPE; 
    private String BILL_FLAG; 
    private String MODI_REASON; 
    private String SERVANT_COMPANY_NUM; 
    private String BUSI_TYPE; 
    private String PROOF_KIND; 
    private String DEPT_CODE; 
    private String SEND_NAME; 
    private String SEND_EMAIL; 
    private String PJT_CODE; 
    private String PRSN_NAME; 
    private String PRSN_EMAIL;
    private String PRSN_PHONE;
    private String PRSN_HANDPHONE;
    private String SMS_CHECK;
    private String BEFORE_PUB_NUM; 
    private String ORIGINAL_PUB_NUM; 
    private String PLUS_MINUS_TYPE; 
    private String BFO_ISSU_ID; 
    private String BROK_CUSTOM_CODE; 
    private String BROK_PRSN_NAME; 
    private String BROK_PRSN_EMAIL; 
    private String BROK_PRSN_PHONE; 
    private String BILL_SEND_YN; 
    private String EB_NUM; 
    private int    EB_SEQ; 
    private String COMPANY_NUM; 
    private String CUSTOM_NAME; 
    private String TOP_NAME; 
    private String ADDR; 
    private String COMP_CLASS; 
    private String COMP_TYPE; 
    private String RECEIVE_PRSN_NAME; 
    private String RECEIVE_PRSN_EMAIL; 
    private String RECEIVE_PRSN_TEL; 
    private String RECEIVE_PRSN_MOBL; 
    private String ISSU_ID; 
    private String STAT_CODE; 
    private String REQ_STAT_CODE; 
    private String ERR_CD; 
    private String ERR_MSG; 
    private String APP_ID; 
    private String IF_NUM; 
    private String SEND_PNAME; 
    private String INSERT_DB_USER; 
    private String INSERT_DB_TIME;
    private String MODE;
    private String S_USER_ID;
    private String INPUT_PATH;
    
    
	public String getKEY_VALUE() {
		return KEY_VALUE;
	}
	public void setKEY_VALUE(String kEY_VALUE) {
		KEY_VALUE = kEY_VALUE;
	}
	public String getOPR_FLAG() {
		return OPR_FLAG;
	}
	public void setOPR_FLAG(String oPR_FLAG) {
		OPR_FLAG = oPR_FLAG;
	}
	public String getFLAG() {
		return FLAG;
	}
	public void setFLAG(String fLAG) {
		FLAG = fLAG;
	}
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getPUB_NUM() {
		return PUB_NUM;
	}
	public void setPUB_NUM(String pUB_NUM) {
		PUB_NUM = pUB_NUM;
	}
	public String getBILL_TYPE() {
		return BILL_TYPE;
	}
	public void setBILL_TYPE(String bILL_TYPE) {
		BILL_TYPE = bILL_TYPE;
	}
	public String getBILL_DATE() {
		return BILL_DATE;
	}
	public void setBILL_DATE(String bILL_DATE) {
		BILL_DATE = bILL_DATE;
	}
	public String getPUB_FR_DATE() {
		return PUB_FR_DATE;
	}
	public void setPUB_FR_DATE(String pUB_FR_DATE) {
		PUB_FR_DATE = pUB_FR_DATE;
	}
	public String getPUB_TO_DATE() {
		return PUB_TO_DATE;
	}
	public void setPUB_TO_DATE(String pUB_TO_DATE) {
		PUB_TO_DATE = pUB_TO_DATE;
	}
	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}
	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}
	public int getSALE_AMT_O() {
		return SALE_AMT_O;
	}
	public void setSALE_AMT_O(int sALE_AMT_O) {
		SALE_AMT_O = sALE_AMT_O;
	}
	public int getSALE_LOC_AMT_I() {
		return SALE_LOC_AMT_I;
	}
	public void setSALE_LOC_AMT_I(int sALE_LOC_AMT_I) {
		SALE_LOC_AMT_I = sALE_LOC_AMT_I;
	}
	public int getTAX_AMT_O() {
		return TAX_AMT_O;
	}
	public void setTAX_AMT_O(int tAX_AMT_O) {
		TAX_AMT_O = tAX_AMT_O;
	}
	public int getCOLET_AMT() {
		return COLET_AMT;
	}
	public void setCOLET_AMT(int cOLET_AMT) {
		COLET_AMT = cOLET_AMT;
	}
	public String getCOLET_CUST_CD() {
		return COLET_CUST_CD;
	}
	public void setCOLET_CUST_CD(String cOLET_CUST_CD) {
		COLET_CUST_CD = cOLET_CUST_CD;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getPROJECT_NO() {
		return PROJECT_NO;
	}
	public void setPROJECT_NO(String pROJECT_NO) {
		PROJECT_NO = pROJECT_NO;
	}
	public String getSALE_PROFIT() {
		return SALE_PROFIT;
	}
	public void setSALE_PROFIT(String sALE_PROFIT) {
		SALE_PROFIT = sALE_PROFIT;
	}
	public String getSALE_DIV_CODE() {
		return SALE_DIV_CODE;
	}
	public void setSALE_DIV_CODE(String sALE_DIV_CODE) {
		SALE_DIV_CODE = sALE_DIV_CODE;
	}
	public String getCOLLECT_CARE() {
		return COLLECT_CARE;
	}
	public void setCOLLECT_CARE(String cOLLECT_CARE) {
		COLLECT_CARE = cOLLECT_CARE;
	}
	public String getEX_DATE() {
		return EX_DATE;
	}
	public void setEX_DATE(String eX_DATE) {
		EX_DATE = eX_DATE;
	}
	public int getEX_NUM() {
		return EX_NUM;
	}
	public void setEX_NUM(int eX_NUM) {
		EX_NUM = eX_NUM;
	}
	public String getAC_DATE() {
		return AC_DATE;
	}
	public void setAC_DATE(String aC_DATE) {
		AC_DATE = aC_DATE;
	}
	public int getAC_NUM() {
		return AC_NUM;
	}
	public void setAC_NUM(int aC_NUM) {
		AC_NUM = aC_NUM;
	}
	public String getAGREE_YN() {
		return AGREE_YN;
	}
	public void setAGREE_YN(String aGREE_YN) {
		AGREE_YN = aGREE_YN;
	}
	public String getRECEIPT_PLAN_DATE() {
		return RECEIPT_PLAN_DATE;
	}
	public void setRECEIPT_PLAN_DATE(String rECEIPT_PLAN_DATE) {
		RECEIPT_PLAN_DATE = rECEIPT_PLAN_DATE;
	}
	public String getTAX_CALC_TYPE() {
		return TAX_CALC_TYPE;
	}
	public void setTAX_CALC_TYPE(String tAX_CALC_TYPE) {
		TAX_CALC_TYPE = tAX_CALC_TYPE;
	}
	public String getCLOSING_YN() {
		return CLOSING_YN;
	}
	public void setCLOSING_YN(String cLOSING_YN) {
		CLOSING_YN = cLOSING_YN;
	}
	public String getBILL_GUBUN() {
		return BILL_GUBUN;
	}
	public void setBILL_GUBUN(String bILL_GUBUN) {
		BILL_GUBUN = bILL_GUBUN;
	}
	public String getBILL_PUBLISH_TYPE() {
		return BILL_PUBLISH_TYPE;
	}
	public void setBILL_PUBLISH_TYPE(String bILL_PUBLISH_TYPE) {
		BILL_PUBLISH_TYPE = bILL_PUBLISH_TYPE;
	}
	public String getBILL_FLAG() {
		return BILL_FLAG;
	}
	public void setBILL_FLAG(String bILL_FLAG) {
		BILL_FLAG = bILL_FLAG;
	}
	public String getMODI_REASON() {
		return MODI_REASON;
	}
	public void setMODI_REASON(String mODI_REASON) {
		MODI_REASON = mODI_REASON;
	}
	public String getSERVANT_COMPANY_NUM() {
		return SERVANT_COMPANY_NUM;
	}
	public void setSERVANT_COMPANY_NUM(String sERVANT_COMPANY_NUM) {
		SERVANT_COMPANY_NUM = sERVANT_COMPANY_NUM;
	}
	public String getBUSI_TYPE() {
		return BUSI_TYPE;
	}
	public void setBUSI_TYPE(String bUSI_TYPE) {
		BUSI_TYPE = bUSI_TYPE;
	}
	public String getPROOF_KIND() {
		return PROOF_KIND;
	}
	public void setPROOF_KIND(String pROOF_KIND) {
		PROOF_KIND = pROOF_KIND;
	}
	public String getDEPT_CODE() {
		return DEPT_CODE;
	}
	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}
	public String getSEND_NAME() {
		return SEND_NAME;
	}
	public void setSEND_NAME(String sEND_NAME) {
		SEND_NAME = sEND_NAME;
	}
	public String getsEND_EMAIL() {
		return SEND_EMAIL;
	}
	public void setSEND_EMAIL(String sEND_EMAIL) {
		SEND_EMAIL = sEND_EMAIL;
	}
	public String getPJT_CODE() {
		return PJT_CODE;
	}
	public void setPJT_CODE(String pJT_CODE) {
		PJT_CODE = pJT_CODE;
	}
	public String getPRSN_NAME() {
		return PRSN_NAME;
	}
	public void setPRSN_NAME(String pRSN_NAME) {
		PRSN_NAME = pRSN_NAME;
	}
	public String getPRSN_EMAIL() {
		return PRSN_EMAIL;
	}
	public void setPRSN_EMAIL(String pRSN_EMAIL) {
		PRSN_EMAIL = pRSN_EMAIL;
	}
	public String getPRSN_PHONE() {
		return PRSN_PHONE;
	}
	public void setPRSN_PHONE(String pRSN_PHONE) {
		PRSN_PHONE = pRSN_PHONE;
	}
	public String getPRSN_HANDPHONE() {
		return PRSN_HANDPHONE;
	}
	public void setPRSN_HANDPHONE(String pRSN_HANDPHONE) {
		PRSN_HANDPHONE = pRSN_HANDPHONE;
	}
	public String getSMS_CHECK() {
		return SMS_CHECK;
	}
	public void setSMS_CHECK(String sMS_CHECK) {
		SMS_CHECK = sMS_CHECK;
	}
	public String getBEFORE_PUB_NUM() {
		return BEFORE_PUB_NUM;
	}
	public void setBEFORE_PUB_NUM(String bEFORE_PUB_NUM) {
		BEFORE_PUB_NUM = bEFORE_PUB_NUM;
	}
	public String getORIGINAL_PUB_NUM() {
		return ORIGINAL_PUB_NUM;
	}
	public void setORIGINAL_PUB_NUM(String oRIGINAL_PUB_NUM) {
		ORIGINAL_PUB_NUM = oRIGINAL_PUB_NUM;
	}
	public String getPLUS_MINUS_TYPE() {
		return PLUS_MINUS_TYPE;
	}
	public void setPLUS_MINUS_TYPE(String pLUS_MINUS_TYPE) {
		PLUS_MINUS_TYPE = pLUS_MINUS_TYPE;
	}
	public String getBFO_ISSU_ID() {
		return BFO_ISSU_ID;
	}
	public void setBFO_ISSU_ID(String bFO_ISSU_ID) {
		BFO_ISSU_ID = bFO_ISSU_ID;
	}
	public String getBROK_CUSTOM_CODE() {
		return BROK_CUSTOM_CODE;
	}
	public void setBROK_CUSTOM_CODE(String bROK_CUSTOM_CODE) {
		BROK_CUSTOM_CODE = bROK_CUSTOM_CODE;
	}
	public String getBROK_PRSN_NAME() {
		return BROK_PRSN_NAME;
	}
	public void setBROK_PRSN_NAME(String bROK_PRSN_NAME) {
		BROK_PRSN_NAME = bROK_PRSN_NAME;
	}
	public String getBROK_PRSN_EMAIL() {
		return BROK_PRSN_EMAIL;
	}
	public void setBROK_PRSN_EMAIL(String bROK_PRSN_EMAIL) {
		BROK_PRSN_EMAIL = bROK_PRSN_EMAIL;
	}
	public String getBROK_PRSN_PHONE() {
		return BROK_PRSN_PHONE;
	}
	public void setBROK_PRSN_PHONE(String bROK_PRSN_PHONE) {
		BROK_PRSN_PHONE = bROK_PRSN_PHONE;
	}
	public String getBILL_SEND_YN() {
		return BILL_SEND_YN;
	}
	public void setBILL_SEND_YN(String bILL_SEND_YN) {
		BILL_SEND_YN = bILL_SEND_YN;
	}
	public String getEB_NUM() {
		return EB_NUM;
	}
	public void setEB_NUM(String eB_NUM) {
		EB_NUM = eB_NUM;
	}
	public int getEB_SEQ() {
		return EB_SEQ;
	}
	public void setEB_SEQ(int eB_SEQ) {
		EB_SEQ = eB_SEQ;
	}
	public String getCOMPANY_NUM() {
		return COMPANY_NUM;
	}
	public void setCOMPANY_NUM(String cOMPANY_NUM) {
		COMPANY_NUM = cOMPANY_NUM;
	}
	public String getCUSTOM_NAME() {
		return CUSTOM_NAME;
	}
	public void setCUSTOM_NAME(String cUSTOM_NAME) {
		CUSTOM_NAME = cUSTOM_NAME;
	}
	public String getTOP_NAME() {
		return TOP_NAME;
	}
	public void setTOP_NAME(String tOP_NAME) {
		TOP_NAME = tOP_NAME;
	}
	public String getADDR() {
		return ADDR;
	}
	public void setADDR(String aDDR) {
		ADDR = aDDR;
	}
	public String getCOMP_CLASS() {
		return COMP_CLASS;
	}
	public void setCOMP_CLASS(String cOMP_CLASS) {
		COMP_CLASS = cOMP_CLASS;
	}
	public String getCOMP_TYPE() {
		return COMP_TYPE;
	}
	public void setCOMP_TYPE(String cOMP_TYPE) {
		COMP_TYPE = cOMP_TYPE;
	}
	public String getRECEIVE_PRSN_NAME() {
		return RECEIVE_PRSN_NAME;
	}
	public void setRECEIVE_PRSN_NAME(String rECEIVE_PRSN_NAME) {
		RECEIVE_PRSN_NAME = rECEIVE_PRSN_NAME;
	}
	public String getRECEIVE_PRSN_EMAIL() {
		return RECEIVE_PRSN_EMAIL;
	}
	public void setRECEIVE_PRSN_EMAIL(String rECEIVE_PRSN_EMAIL) {
		RECEIVE_PRSN_EMAIL = rECEIVE_PRSN_EMAIL;
	}
	public String getRECEIVE_PRSN_TEL() {
		return RECEIVE_PRSN_TEL;
	}
	public void setRECEIVE_PRSN_TEL(String rECEIVE_PRSN_TEL) {
		RECEIVE_PRSN_TEL = rECEIVE_PRSN_TEL;
	}
	public String getRECEIVE_PRSN_MOBL() {
		return RECEIVE_PRSN_MOBL;
	}
	public void setRECEIVE_PRSN_MOBL(String rECEIVE_PRSN_MOBL) {
		RECEIVE_PRSN_MOBL = rECEIVE_PRSN_MOBL;
	}
	public String getISSU_ID() {
		return ISSU_ID;
	}
	public void setISSU_ID(String iSSU_ID) {
		ISSU_ID = iSSU_ID;
	}
	public String getSTAT_CODE() {
		return STAT_CODE;
	}
	public void setSTAT_CODE(String sTAT_CODE) {
		STAT_CODE = sTAT_CODE;
	}
	public String getREQ_STAT_CODE() {
		return REQ_STAT_CODE;
	}
	public void setREQ_STAT_CODE(String rEQ_STAT_CODE) {
		REQ_STAT_CODE = rEQ_STAT_CODE;
	}
	public String getERR_CD() {
		return ERR_CD;
	}
	public void setERR_CD(String eRR_CD) {
		ERR_CD = eRR_CD;
	}
	public String getERR_MSG() {
		return ERR_MSG;
	}
	public void setERR_MSG(String eRR_MSG) {
		ERR_MSG = eRR_MSG;
	}
	public String getAPP_ID() {
		return APP_ID;
	}
	public void setAPP_ID(String aPP_ID) {
		APP_ID = aPP_ID;
	}
	public String getIF_NUM() {
		return IF_NUM;
	}
	public void setIF_NUM(String iF_NUM) {
		IF_NUM = iF_NUM;
	}
	public String getSEND_PNAME() {
		return SEND_PNAME;
	}
	public void setSEND_PNAME(String sEND_PNAME) {
		SEND_PNAME = sEND_PNAME;
	}
	public String getINSERT_DB_USER() {
		return INSERT_DB_USER;
	}
	public void setINSERT_DB_USER(String iNSERT_DB_USER) {
		INSERT_DB_USER = iNSERT_DB_USER;
	}
	public String getINSERT_DB_TIME() {
		return INSERT_DB_TIME;
	}
	public void setINSERT_DB_TIME(String iNSERT_DB_TIME) {
		INSERT_DB_TIME = iNSERT_DB_TIME;
	} 
	public String getMODE() {
		return MODE;
	}
	public void setMODE(String mODE) {
		MODE = mODE;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getINPUT_PATH() {
		return INPUT_PATH;
	}
	public void setINPUT_PATH(String iNPUT_PATH) {
		INPUT_PATH = iNPUT_PATH;
	}
}
