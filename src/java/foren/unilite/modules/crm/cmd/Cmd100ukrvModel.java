package foren.unilite.modules.crm.cmd;

import foren.framework.model.BaseVO;

public class Cmd100ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String  DOC_NO;
    private String CREATE_EMP;
    private String CLIENT;
    private String CLIENT_NM;
    /* Plan Data */
	private String  PLAN_CLIENT;
	private String  PLAN_CUSTOM_NAME;
	private String  PLAN_CUSTOM_CODE;
	private String  PLAN_DVRY_CUST_NM;
	private String  PLAN_DVRY_CUST_CODE;
	private String  PLAN_DATE;
	private String  PLAN_TIME;
	private String  PLAN_SALE_TYPE;
	private String  PLAN_GROUP_YN;
	private String  PLAN_TARGET;
	private String  ACTION_TYPE;
	
	
	/* Result Data */
	private String  RESULT_CLIENT_NM;
	private String  RESULT_CLIENT;
	private String  RESULT_ETC_CLIENT_NM;
	private String  RESULT_DATE;
	private String  RESULT_TIME;
	private String  CUSTOM_NAME;
	private String  CUSTOM_CODE;
	private String  DVRY_CUST_SEQ;
	private String  DVRY_CUST_NM;
	private String  PROCESS_TYPE;
	private String  SALE_TYPE;
	private String  SALE_STATUS;
	private String  PROJECT_NO;
	private String  PROJECT_NO_NM;
	private String  ITEM_NAME;
	private String  IMPORTANCE_STATUS;
	private String  SALE_EMP;
	private String  SALE_ATTEND;
	private String  SUMMARY_STR;
	private String  CONTENT_STR;
	private String  REQ_STR;
	private String  OPINION_STR;
	private String  WRITE_EMP1;
	private String  OPINION_STR2;
	private String  WRITE_EMP2;
	private String  OPINION_STR3;
	private String  WRITE_EMP3;
	private String  REMARK;
	private String  KEYWORD;
	private double 	SALES_PROJECTION;
	
	private String PLAN_SAVE_YN;
	private String RESULT_SAVE_YN;
    
    private String	FILE_NO;
    private int		DOC_SEQ;
    private String	DOC_TYPE;
    private String	OPINION_TYPE;
    private String	DEL_FID;
    private String	ADD_FID;

	public String getDOC_NO() {
		return DOC_NO;
	}
	
	public void setDOC_NO(String dOC_NO) {
		DOC_NO = dOC_NO;
	}
	
	

	public String getCREATE_EMP() {
		return CREATE_EMP;
	}

	public void setCREATE_EMP(String cREATE_EMP) {
		CREATE_EMP = cREATE_EMP;
	}

	public String getCLIENT() {
		return CLIENT;
	}

	public void setCLIENT(String cLIENT) {
		CLIENT = cLIENT;
	}

	public String getCLIENT_NM() {
		return CLIENT_NM;
	}

	public void setCLIENT_NM(String cLIENT_NM) {
		CLIENT_NM = cLIENT_NM;
	}

	public String getPLAN_CLIENT() {
		return PLAN_CLIENT;
	}

	public void setPLAN_CLIENT(String pLAN_CLIENT) {
		PLAN_CLIENT = pLAN_CLIENT;
	}

	public String getPLAN_CUSTOM_NAME() {
		return PLAN_CUSTOM_NAME;
	}

	public void setPLAN_CUSTOM_NAME(String pLAN_CUSTOM_NAME) {
		PLAN_CUSTOM_NAME = pLAN_CUSTOM_NAME;
	}

	public String getPLAN_CUSTOM_CODE() {
		return PLAN_CUSTOM_CODE;
	}

	public void setPLAN_CUSTOM_CODE(String pLAN_CUSTOM_CODE) {
		PLAN_CUSTOM_CODE = pLAN_CUSTOM_CODE;
	}

	public String getPLAN_DVRY_CUST_NM() {
		return PLAN_DVRY_CUST_NM;
	}

	public void setPLAN_DVRY_CUST_NM(String pLAN_DVRY_CUST_NM) {
		PLAN_DVRY_CUST_NM = pLAN_DVRY_CUST_NM;
	}

	public String getPLAN_DVRY_CUST_CODE() {
		return PLAN_DVRY_CUST_CODE;
	}

	public void setPLAN_DVRY_CUST_CODE(String pLAN_DVRY_CUST_CODE) {
		PLAN_DVRY_CUST_CODE = pLAN_DVRY_CUST_CODE;
	}

	public String getPLAN_DATE() {
		return PLAN_DATE;
	}

	public void setPLAN_DATE(String pLAN_DATE) {
		PLAN_DATE = pLAN_DATE;
	}

	public String getPLAN_TIME() {
		return PLAN_TIME;
	}

	public void setPLAN_TIME(String pLAN_TIME) {
		PLAN_TIME = pLAN_TIME;
	}

	public String getPLAN_SALE_TYPE() {
		return PLAN_SALE_TYPE;
	}

	public void setPLAN_SALE_TYPE(String pLAN_SALE_TYPE) {
		PLAN_SALE_TYPE = pLAN_SALE_TYPE;
	}

	public String getPLAN_GROUP_YN() {
		return PLAN_GROUP_YN;
	}

	public void setPLAN_GROUP_YN(String pLAN_GROUP_YN) {
		PLAN_GROUP_YN = pLAN_GROUP_YN;
	}

	public String getPLAN_TARGET() {
		return PLAN_TARGET;
	}

	public void setPLAN_TARGET(String pLAN_TARGET) {
		PLAN_TARGET = pLAN_TARGET;
	}

	public String getACTION_TYPE() {
		return ACTION_TYPE;
	}

	public void setACTION_TYPE(String aCTION_TYPE) {
		ACTION_TYPE = aCTION_TYPE;
	}

	public String getRESULT_CLIENT_NM() {
		return RESULT_CLIENT_NM;
	}

	public void setRESULT_CLIENT_NM(String rESULT_CLIENT_NM) {
		RESULT_CLIENT_NM = rESULT_CLIENT_NM;
	}

	public String getRESULT_CLIENT() {
		return RESULT_CLIENT;
	}

	public void setRESULT_CLIENT(String rESULT_CLIENT) {
		RESULT_CLIENT = rESULT_CLIENT;
	}

	public String getRESULT_ETC_CLIENT_NM() {
		return RESULT_ETC_CLIENT_NM;
	}

	public void setRESULT_ETC_CLIENT_NM(String rESULT_ETC_CLIENT_NM) {
		RESULT_ETC_CLIENT_NM = rESULT_ETC_CLIENT_NM;
	}

	public String getRESULT_DATE() {
		return RESULT_DATE;
	}

	public void setRESULT_DATE(String rESULT_DATE) {
		RESULT_DATE = rESULT_DATE;
	}

	public String getRESULT_TIME() {
		return RESULT_TIME;
	}

	public void setRESULT_TIME(String rESULT_TIME) {
		RESULT_TIME = rESULT_TIME;
	}

	public String getCUSTOM_NAME() {
		return CUSTOM_NAME;
	}

	public void setCUSTOM_NAME(String cUSTOM_NAME) {
		CUSTOM_NAME = cUSTOM_NAME;
	}

	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}

	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}

	public String getDVRY_CUST_SEQ() {
		return DVRY_CUST_SEQ;
	}

	public void setDVRY_CUST_SEQ(String dVRY_CUST_SEQ) {
		DVRY_CUST_SEQ = dVRY_CUST_SEQ;
	}

	public String getDVRY_CUST_NM() {
		return DVRY_CUST_NM;
	}

	public void setDVRY_CUST_NM(String dVRY_CUST_NM) {
		DVRY_CUST_NM = dVRY_CUST_NM;
	}

	public String getPROCESS_TYPE() {
		return PROCESS_TYPE;
	}

	public void setPROCESS_TYPE(String pROCESS_TYPE) {
		PROCESS_TYPE = pROCESS_TYPE;
	}

	
	public String getSALE_TYPE() {
		return SALE_TYPE;
	}

	public void setSALE_TYPE(String sALE_TYPE) {
		SALE_TYPE = sALE_TYPE;
	}

	
	public String getSALE_STATUS() {
		return SALE_STATUS;
	}

	public void setSALE_STATUS(String sALE_STATUS) {
		SALE_STATUS = sALE_STATUS;
	}

	public String getPROJECT_NO() {
		return PROJECT_NO;
	}

	public void setPROJECT_NO(String pROJECT_NO) {
		PROJECT_NO = pROJECT_NO;
	}

	public String getOPINION_STR2() {
		return OPINION_STR2;
	}

	public void setOPINION_STR2(String oPINION_STR2) {
		OPINION_STR2 = oPINION_STR2;
	}

	public String getOPINION_STR3() {
		return OPINION_STR3;
	}

	public void setOPINION_STR3(String oPINION_STR3) {
		OPINION_STR3 = oPINION_STR3;
	}

	public String getPROJECT_NO_NM() {
		return PROJECT_NO_NM;
	}

	public void setPROJECT_NO_NM(String pROJECT_NO_NM) {
		PROJECT_NO_NM = pROJECT_NO_NM;
	}

	public String getITEM_NAME() {
		return ITEM_NAME;
	}

	public void setITEM_NAME(String iTEM_NAME) {
		ITEM_NAME = iTEM_NAME;
	}

	public String getIMPORTANCE_STATUS() {
		return IMPORTANCE_STATUS;
	}

	public void setIMPORTANCE_STATUS(String iMPORTANCE_STATUS) {
		IMPORTANCE_STATUS = iMPORTANCE_STATUS;
	}

	public String getSALE_EMP() {
		return SALE_EMP;
	}

	public void setSALE_EMP(String sALE_EMP) {
		SALE_EMP = sALE_EMP;
	}

	public String getSALE_ATTEND() {
		return SALE_ATTEND;
	}

	public void setSALE_ATTEND(String sALE_ATTEND) {
		SALE_ATTEND = sALE_ATTEND;
	}

	public String getSUMMARY_STR() {
		return SUMMARY_STR;
	}

	public void setSUMMARY_STR(String sUMMARY_STR) {
		SUMMARY_STR = sUMMARY_STR;
	}

	public String getCONTENT_STR() {
		return CONTENT_STR;
	}

	public void setCONTENT_STR(String cONTENT_STR) {
		CONTENT_STR = cONTENT_STR;
	}

	public String getREQ_STR() {
		return REQ_STR;
	}

	public void setREQ_STR(String rEQ_STR) {
		REQ_STR = rEQ_STR;
	}

	public String getOPINION_STR() {
		return OPINION_STR;
	}

	public void setOPINION_STR(String oPINION_STR) {
		OPINION_STR = oPINION_STR;
	}

	public String getREMARK() {
		return REMARK;
	}

	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}

	public String getKEYWORD() {
		return KEYWORD;
	}

	public void setKEYWORD(String kEYWORD) {
		KEYWORD = kEYWORD;
	}
	
	
	
	public double getSALES_PROJECTION() {
		return SALES_PROJECTION;
	}

	public void setSALES_PROJECTION(double sALES_PROJECTION) {
		SALES_PROJECTION = sALES_PROJECTION;
	}

	public String getWRITE_EMP1() {
		return WRITE_EMP1;
	}

	public void setWRITE_EMP1(String wRITE_EMP1) {
		WRITE_EMP1 = wRITE_EMP1;
	}

	public String getWRITE_EMP2() {
		return WRITE_EMP2;
	}

	public void setWRITE_EMP2(String wRITE_EMP2) {
		WRITE_EMP2 = wRITE_EMP2;
	}

	public String getWRITE_EMP3() {
		return WRITE_EMP3;
	}

	public void setWRITE_EMP3(String wRITE_EMP3) {
		WRITE_EMP3 = wRITE_EMP3;
	}

	public String getPLAN_SAVE_YN() {
		return PLAN_SAVE_YN;
	}

	public void setPLAN_SAVE_YN(String pLAN_SAVE_YN) {
		PLAN_SAVE_YN = pLAN_SAVE_YN;
	}

	public String getRESULT_SAVE_YN() {
		return RESULT_SAVE_YN;
	}

	public void setRESULT_SAVE_YN(String rESULT_SAVE_YN) {
		RESULT_SAVE_YN = rESULT_SAVE_YN;
	}

	public String getFILE_NO() {
		return FILE_NO;
	}

	public void setFILE_NO(String fILE_NO) {
		FILE_NO = fILE_NO;
	}

	public int getDOC_SEQ() {
		return DOC_SEQ;
	}

	public void setDOC_SEQ(int dOC_SEQ) {
		DOC_SEQ = dOC_SEQ;
	}

	public String getDOC_TYPE() {
		return DOC_TYPE;
	}

	public void setDOC_TYPE(String dOC_TYPE) {
		DOC_TYPE = dOC_TYPE;
	}

	public String getOPINION_TYPE() {
		return OPINION_TYPE;
	}

	public void setOPINION_TYPE(String oPINION_TYPE) {
		OPINION_TYPE = oPINION_TYPE;
	}

	public String getDEL_FID() {
		return DEL_FID;
	}

	public void setDEL_FID(String dEL_FID) {
		DEL_FID = dEL_FID;
	}

	public String getADD_FID() {
		return ADD_FID;
	}

	public void setADD_FID(String aDD_FID) {
		ADD_FID = aDD_FID;
	}

		
	
	   /* Session Variables */
  private String  S_COMP_CODE;
  private String  S_AUTHORITY_LEVEL;
  private String  S_USER_ID;
  
  
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
}
