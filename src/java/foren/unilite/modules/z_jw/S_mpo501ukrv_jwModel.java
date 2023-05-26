package foren.unilite.modules.z_jw;

import foren.framework.model.BaseVO;

public class S_mpo501ukrv_jwModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String  ORDER_NUM;
    private String  COMP_CODE;
    private String  DIV_CODE;

    private String AGREE_DATE;
    private String AGREE_STATUS;
    private String AGREE_PRSN;
    private String LC_NUM;
    public void setAGREE_DATE( String aGREE_DATE ) {
        AGREE_DATE = aGREE_DATE;
    }

    public void setAGREE_STATUS( String aGREE_STATUS ) {
        AGREE_STATUS = aGREE_STATUS;
    }

    public void setAGREE_PRSN( String aGREE_PRSN ) {
        AGREE_PRSN = aGREE_PRSN;
    }

    public void setLC_NUM( String lC_NUM ) {
        LC_NUM = lC_NUM;
    }

    public void setRECEIPT_TYPE( String rECEIPT_TYPE ) {
        RECEIPT_TYPE = rECEIPT_TYPE;
    }

    public void setSumOrderO( String sumOrderO ) {
        SumOrderO = sumOrderO;
    }

    public void setSumOrderLocO( String sumOrderLocO ) {
        SumOrderLocO = sumOrderLocO;
    }

    public void setDRAFT_YN( String dRAFT_YN ) {
        DRAFT_YN = dRAFT_YN;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getAGREE_DATE() {
        return AGREE_DATE;
    }

    public String getAGREE_STATUS() {
        return AGREE_STATUS;
    }

    public String getAGREE_PRSN() {
        return AGREE_PRSN;
    }

    public String getLC_NUM() {
        return LC_NUM;
    }

    public String getRECEIPT_TYPE() {
        return RECEIPT_TYPE;
    }

    public String getSumOrderO() {
        return SumOrderO;
    }

    public String getSumOrderLocO() {
        return SumOrderLocO;
    }

    public String getDRAFT_YN() {
        return DRAFT_YN;
    }
    
    private String KEY_VALUE;    
    private String OPR_FLAG;

    private String RECEIPT_TYPE;
    public void setKEY_VALUE( String kEY_VALUE ) {
        KEY_VALUE = kEY_VALUE;
    }

    public void setOPR_FLAG( String oPR_FLAG ) {
        OPR_FLAG = oPR_FLAG;
    }

    public String getKEY_VALUE() {
        return KEY_VALUE;
    }

    public String getOPR_FLAG() {
        return OPR_FLAG;
    }

    private String UPDATE_DB_USER;
    private String UPDATE_DB_TIME;
    private String INSERT_DB_USER;
    public void setUPDATE_DB_USER( String uPDATE_DB_USER ) {
        UPDATE_DB_USER = uPDATE_DB_USER;
    }

    public void setUPDATE_DB_TIME( String uPDATE_DB_TIME ) {
        UPDATE_DB_TIME = uPDATE_DB_TIME;
    }

    public void setINSERT_DB_USER( String iNSERT_DB_USER ) {
        INSERT_DB_USER = iNSERT_DB_USER;
    }

    public void setINSERT_DB_TIME( String iNSERT_DB_TIME ) {
        INSERT_DB_TIME = iNSERT_DB_TIME;
    }

    public String getUPDATE_DB_USER() {
        return UPDATE_DB_USER;
    }

    public String getUPDATE_DB_TIME() {
        return UPDATE_DB_TIME;
    }

    public String getINSERT_DB_USER() {
        return INSERT_DB_USER;
    }

    public String getINSERT_DB_TIME() {
        return INSERT_DB_TIME;
    }

    private String INSERT_DB_TIME;
    private String SumOrderO;
    private String SumOrderLocO;
    private String DRAFT_YN;
    private String CUSTOM_CODE;
    private String AGENT_TYPE;
    private String ORDER_DATE;
    private String ORDER_TYPE;
    private String MONEY_UNIT;
    private double ORDER_O;
    private double ORDER_TAX_O;
    private double EXCHG_RATE_O;
    private String ORDER_PRSN;
    private String DEPT_CODE;
    private String PO_NUM;
    private String CREATE_LOC;
    private String TAX_INOUT;
    private String BILL_TYPE;
    private String RECEIPT_SET_METH;
    private String PROJECT_NO;
    private String REMARK;
    private String PROMO_NUM;
    private String STATUS;
    private String APP_1_ID;
    private String APP_1_DATE;
    private String AGREE_1_YN;
    private String APP_2_ID;
    private String APP_2_DATE;
    private String AGREE_2_YN;
    private String APP_3_ID;
    private String APP_3_DATE;
    private String AGREE_3_YN;
    private String APP_STEP;
    private String RETURN_ID;
    private String RETURN_DATE;
    private String RETURN_MSG;

    private String ORDER_NAME;
    private String PAY_METHOD;
    private String INSPECT_ORG;
    private String DEF_RATE;
    private String DEF_TERM;
    private String DEF_RESP_TERM;
    private String DEFERMENT_RATE;
    private String PAY_COND;
    private String gsDraftFlag;
	   /* Session Variables */
    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
  
    
  
  
	public String getORDER_NUM() {
		return ORDER_NUM;
	}

	public void setORDER_NUM(String oRDER_NUM) {
		ORDER_NUM = oRDER_NUM;
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

	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}

	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}

	public String getAGENT_TYPE() {
		return AGENT_TYPE;
	}

	public void setAGENT_TYPE(String aGENT_TYPE) {
		AGENT_TYPE = aGENT_TYPE;
	}

	public String getORDER_DATE() {
		return ORDER_DATE;
	}

	public void setORDER_DATE(String oRDER_DATE) {
		ORDER_DATE = oRDER_DATE;
	}

	public String getORDER_TYPE() {
		return ORDER_TYPE;
	}

	public void setORDER_TYPE(String oRDER_TYPE) {
		ORDER_TYPE = oRDER_TYPE;
	}

	public String getMONEY_UNIT() {
		return MONEY_UNIT;
	}

	public void setMONEY_UNIT(String mONEY_UNIT) {
		MONEY_UNIT = mONEY_UNIT;
	}

	public double getORDER_O() {
		return ORDER_O;
	}

	public void setORDER_O(double oRDER_O) {
		ORDER_O = oRDER_O;
	}

	public double getORDER_TAX_O() {
		return ORDER_TAX_O;
	}

	public void setORDER_TAX_O(double oRDER_TAX_O) {
		ORDER_TAX_O = oRDER_TAX_O;
	}

	public double getEXCHG_RATE_O() {
		return EXCHG_RATE_O;
	}

	public void setEXCHG_RATE_O(double eXCHG_RATE_O) {
		EXCHG_RATE_O = eXCHG_RATE_O;
	}

	public String getORDER_PRSN() {
		return ORDER_PRSN;
	}

	public void setORDER_PRSN(String oRDER_PRSN) {
		ORDER_PRSN = oRDER_PRSN;
	}

	public String getDEPT_CODE() {
		return DEPT_CODE;
	}

	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}

	public String getPO_NUM() {
		return PO_NUM;
	}

	public void setPO_NUM(String pO_NUM) {
		PO_NUM = pO_NUM;
	}

	public String getCREATE_LOC() {
		return CREATE_LOC;
	}

	public void setCREATE_LOC(String cREATE_LOC) {
		CREATE_LOC = cREATE_LOC;
	}

	public String getTAX_INOUT() {
		return TAX_INOUT;
	}

	public void setTAX_INOUT(String tAX_INOUT) {
		TAX_INOUT = tAX_INOUT;
	}

	public String getBILL_TYPE() {
		return BILL_TYPE;
	}

	public void setBILL_TYPE(String bILL_TYPE) {
		BILL_TYPE = bILL_TYPE;
	}

	public String getRECEIPT_SET_METH() {
		return RECEIPT_SET_METH;
	}

	public void setRECEIPT_SET_METH(String rECEIPT_SET_METH) {
		RECEIPT_SET_METH = rECEIPT_SET_METH;
	}

	public String getPROJECT_NO() {
		return PROJECT_NO;
	}

	public void setPROJECT_NO(String pROJECT_NO) {
		PROJECT_NO = pROJECT_NO;
	}

	public String getREMARK() {
		return REMARK;
	}

	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}

	public String getPROMO_NUM() {
		return PROMO_NUM;
	}

	public void setPROMO_NUM(String pROMO_NUM) {
		PROMO_NUM = pROMO_NUM;
	}

	public String getSTATUS() {
		return STATUS;
	}

	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}

	public String getAPP_1_ID() {
		return APP_1_ID;
	}

	public void setAPP_1_ID(String aPP_1_ID) {
		APP_1_ID = aPP_1_ID;
	}

	public String getAPP_1_DATE() {
		return APP_1_DATE;
	}

	public void setAPP_1_DATE(String aPP_1_DATE) {
		APP_1_DATE = aPP_1_DATE;
	}

	public String getAGREE_1_YN() {
		return AGREE_1_YN;
	}

	public void setAGREE_1_YN(String aGREE_1_YN) {
		AGREE_1_YN = aGREE_1_YN;
	}

	public String getAPP_2_ID() {
		return APP_2_ID;
	}

	public void setAPP_2_ID(String aPP_2_ID) {
		APP_2_ID = aPP_2_ID;
	}

	public String getAPP_2_DATE() {
		return APP_2_DATE;
	}

	public void setAPP_2_DATE(String aPP_2_DATE) {
		APP_2_DATE = aPP_2_DATE;
	}

	public String getAGREE_2_YN() {
		return AGREE_2_YN;
	}

	public void setAGREE_2_YN(String aGREE_2_YN) {
		AGREE_2_YN = aGREE_2_YN;
	}

	public String getAPP_3_ID() {
		return APP_3_ID;
	}

	public void setAPP_3_ID(String aPP_3_ID) {
		APP_3_ID = aPP_3_ID;
	}

	public String getAPP_3_DATE() {
		return APP_3_DATE;
	}

	public void setAPP_3_DATE(String aPP_3_DATE) {
		APP_3_DATE = aPP_3_DATE;
	}

	public String getAGREE_3_YN() {
		return AGREE_3_YN;
	}

	public void setAGREE_3_YN(String aGREE_3_YN) {
		AGREE_3_YN = aGREE_3_YN;
	}

	public String getAPP_STEP() {
		return APP_STEP;
	}

	public void setAPP_STEP(String aPP_STEP) {
		APP_STEP = aPP_STEP;
	}

	public String getRETURN_ID() {
		return RETURN_ID;
	}

	public void setRETURN_ID(String rETURN_ID) {
		RETURN_ID = rETURN_ID;
	}

	public String getRETURN_DATE() {
		return RETURN_DATE;
	}

	public void setRETURN_DATE(String rETURN_DATE) {
		RETURN_DATE = rETURN_DATE;
	}

	public String getRETURN_MSG() {
		return RETURN_MSG;
	}

	public void setRETURN_MSG(String rETURN_MSG) {
		RETURN_MSG = rETURN_MSG;
	}

	public String getORDER_NAME() {
		return ORDER_NAME;
	}

	public void setORDER_NAME(String oRDER_NAME) {
		ORDER_NAME = oRDER_NAME;
	}

	public String getPAY_METHOD() {
		return PAY_METHOD;
	}

	public void setPAY_METHOD(String pAY_METHOD) {
		PAY_METHOD = pAY_METHOD;
	}

	public String getINSPECT_ORG() {
		return INSPECT_ORG;
	}

	public void setINSPECT_ORG(String iNSPECT_ORG) {
		INSPECT_ORG = iNSPECT_ORG;
	}

	public String getDEF_RATE() {
		return DEF_RATE;
	}

	public void setDEF_RATE(String dEF_RATE) {
		DEF_RATE = dEF_RATE;
	}

	public String getDEF_TERM() {
		return DEF_TERM;
	}

	public void setDEF_TERM(String dEF_TERM) {
		DEF_TERM = dEF_TERM;
	}

	public String getDEF_RESP_TERM() {
		return DEF_RESP_TERM;
	}

	public void setDEF_RESP_TERM(String dEF_RESP_TERM) {
		DEF_RESP_TERM = dEF_RESP_TERM;
	}

	public String getDEFERMENT_RATE() {
		return DEFERMENT_RATE;
	}

	public void setDEFERMENT_RATE(String dEFERMENT_RATE) {
		DEFERMENT_RATE = dEFERMENT_RATE;
	}

	public String getPAY_COND() {
		return PAY_COND;
	}

	public void setPAY_COND(String pAY_COND) {
		PAY_COND = pAY_COND;
	}

	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}

	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	
	public String getS_USER_ID() {
		return S_USER_ID;
	}

	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}

	public String getS_AUTHORITY_LEVEL() {
		return S_AUTHORITY_LEVEL;
	}

	public void setS_AUTHORITY_LEVEL(String s_AUTHORITY_LEVEL) {
		S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
	}

	public String getGsDraftFlag() {
		return gsDraftFlag;
	}

	public void setGsDraftFlag(String gsDraftFlag) {
		this.gsDraftFlag = gsDraftFlag;
	}
	
	
}
