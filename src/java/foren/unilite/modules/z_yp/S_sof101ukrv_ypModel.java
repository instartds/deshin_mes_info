package foren.unilite.modules.z_yp;

import foren.framework.model.BaseVO;

public class S_sof101ukrv_ypModel extends BaseVO {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	

	
	/* Primary Key */
	private String  ORDER_NUM;
	private String  COMP_CODE;
	private String  DIV_CODE;

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
	private String DVRY_DATE;
	private String PJT_CODE;
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
	
	private String EXCHANGE_RATE;
	private String PAY_DURING;
	
	private String BANK_CODE;
	private String AGENT_CODE;
	private String CAL_NO;
	
	public String getAGENT_CODE() {
		return AGENT_CODE;
	}

	public void setAGENT_CODE(String aGENT_CODE) {
		AGENT_CODE = aGENT_CODE;
	}

	public String getBANK_CODE() {
		return BANK_CODE;
	}

	public void setBANK_CODE(String bANK_CODE) {
		BANK_CODE = bANK_CODE;
	}

	public void setNATION_INOUT( String nATION_INOUT ) {
		NATION_INOUT = nATION_INOUT;
	}

	public void setOFFER_NO( String oFFER_NO ) {
		OFFER_NO = oFFER_NO;
	}

	public void setDATE_DELIVERY( String dATE_DELIVERY ) {
		DATE_DELIVERY = dATE_DELIVERY;
	}

	public void setAGENT( String aGENT ) {
		AGENT = aGENT;
	}

	public void setDATE_DEPART( String dATE_DEPART ) {
		DATE_DEPART = dATE_DEPART;
	}

	public void setDATE_EXP( String dATE_EXP ) {
		DATE_EXP = dATE_EXP;
	}

	public void setPAY_METHODE1( String pAY_METHODE1 ) {
		PAY_METHODE1 = pAY_METHODE1;
	}

	public void setPAY_TERMS( String pAY_TERMS ) {
		PAY_TERMS = pAY_TERMS;
	}

	public void setTERMS_PRICE( String tERMS_PRICE ) {
		TERMS_PRICE = tERMS_PRICE;
	}

	public void setCOND_PACKING( String cOND_PACKING ) {
		COND_PACKING = cOND_PACKING;
	}

	public void setMETH_CARRY( String mETH_CARRY ) {
		METH_CARRY = mETH_CARRY;
	}

	public void setMETH_INSPECT( String mETH_INSPECT ) {
		METH_INSPECT = mETH_INSPECT;
	}

	public void setDEST_PORT( String dEST_PORT ) {
		DEST_PORT = dEST_PORT;
	}

	public void setDEST_PORT_NM( String dEST_PORT_NM ) {
		DEST_PORT_NM = dEST_PORT_NM;
	}

	public void setSHIP_PORT( String sHIP_PORT ) {
		SHIP_PORT = sHIP_PORT;
	}

	public void setSHIP_PORT_NM( String sHIP_PORT_NM ) {
		SHIP_PORT_NM = sHIP_PORT_NM;
	}

	public void setBANK_SENDING( String bANK_SENDING ) {
		BANK_SENDING = bANK_SENDING;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getNATION_INOUT() {
		return NATION_INOUT;
	}

	public String getOFFER_NO() {
		return OFFER_NO;
	}

	public String getDATE_DELIVERY() {
		return DATE_DELIVERY;
	}

	public String getAGENT() {
		return AGENT;
	}

	public String getDATE_DEPART() {
		return DATE_DEPART;
	}

	public String getDATE_EXP() {
		return DATE_EXP;
	}

	public String getPAY_METHODE1() {
		return PAY_METHODE1;
	}

	public String getPAY_TERMS() {
		return PAY_TERMS;
	}

	public String getTERMS_PRICE() {
		return TERMS_PRICE;
	}

	public String getCOND_PACKING() {
		return COND_PACKING;
	}

	public String getMETH_CARRY() {
		return METH_CARRY;
	}

	public String getMETH_INSPECT() {
		return METH_INSPECT;
	}

	public String getDEST_PORT() {
		return DEST_PORT;
	}

	public String getDEST_PORT_NM() {
		return DEST_PORT_NM;
	}

	public String getSHIP_PORT() {
		return SHIP_PORT;
	}

	public String getSHIP_PORT_NM() {
		return SHIP_PORT_NM;
	}

	public String getBANK_SENDING() {
		return BANK_SENDING;
	}

	private String NATION_INOUT;
	private String OFFER_NO;
	private String DATE_DELIVERY;   
	private String AGENT;	   
	private String DATE_DEPART; 
	private String DATE_EXP;	
	private String PAY_METHODE1;
	private String PAY_TERMS;   
	private String TERMS_PRICE; 
	private String COND_PACKING;
	private String METH_CARRY;  
	private String METH_INSPECT;
	private String DEST_PORT;   
	private String DEST_PORT_NM;
	private String SHIP_PORT;   
	private String SHIP_PORT_NM;
	private String BANK_SENDING;
	   /* Session Variables */
	private String  S_COMP_CODE;
	private String  S_AUTHORITY_LEVEL;
	private String  S_USER_ID;
  
	private String KEY_VALUE;	
	private String OPR_FLAG;
	
  
  
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
	

	public String getDVRY_DATE() {
		return DVRY_DATE;
	}

	public void setDVRY_DATE(String dVRY_DATE) {
		DVRY_DATE = dVRY_DATE;
	}

	public String getPJT_CODE() {
		return PJT_CODE;
	}

	public void setPJT_CODE(String pJT_CODE) {
		PJT_CODE = pJT_CODE;
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

	public String getEXCHANGE_RATE() {
		return EXCHANGE_RATE;
	}

	public void setEXCHANGE_RATE(String eXCHANGE_RATE) {
		EXCHANGE_RATE = eXCHANGE_RATE;
	}

	public String getPAY_DURING() {
		return PAY_DURING;
	}

	public void setPAY_DURING(String pAY_DURING) {
		PAY_DURING = pAY_DURING;
	}

	public String getCAL_NO() {
		return CAL_NO;
	}

	public void setCAL_NO(String cAL_NO) {
		CAL_NO = cAL_NO;
	}
	
	
}
