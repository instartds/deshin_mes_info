package foren.unilite.modules.z_mit;

import foren.framework.model.BaseVO;
import foren.framework.utils.ObjUtils;

public class S_sas100ukrv_mitModel extends BaseVO {
	private static final long serialVersionUID = 1L;
	
	/* Primary Key */
	private String  COMP_CODE   ;
	private String  DIV_CODE    ;
	private String  RECEIPT_NUM ;
	
	
	private String  RECEIPT_DATE;
	private String  SERIAL_NO   ;
	private String  ITEM_CODE   ;
	private String  ITEM_NAME	;
	private String  SALE_DATE 	;
	private String  CUSTOM_CODE	;
	private String  CUSTOM_NAME	;
	private String  MACHINE_TYPE;
	private String  WARR_MONTH	;
	private String  WARR_DATE   ;
	private String  AS_STATUS   ;
	private String  RECEIPT_PRSN;
	private String  CONT_FR_DATE;
	private String  CONT_TO_DATE;
	private String  CONT_GRADE  ;
	private String  BILL_NUM    ;
	private Integer BILL_SEQ    ;
	private String  REMARK		;
	private String  IN_DATE     ;
	private String  OUT_DATE    ;
	private String  FDA_Q1_YN   ;
	private String  FDA_Q2_YN   ;
	private String  FDA_Q3_YN   ;
	
	private String  S_COMP_CODE ;
	private String  S_USER_ID   ;
	
	
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
	public String getRECEIPT_NUM() {
		return RECEIPT_NUM;
	}
	public void setRECEIPT_NUM(String rECEIPT_NUM) {
		RECEIPT_NUM = rECEIPT_NUM;
	}
	public String getRECEIPT_DATE() {
		return RECEIPT_DATE;
	}
	public void setRECEIPT_DATE(String rECEIPT_DATE) {
		RECEIPT_DATE = rECEIPT_DATE;
	}
	public String getSERIAL_NO() {
		return SERIAL_NO;
	}
	public void setSERIAL_NO(String sERIAL_NO) {
		SERIAL_NO = sERIAL_NO;
	}
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
	public String getITEM_NAME() {
		return ITEM_NAME;
	}
	public void setITEM_NAME(String iTEM_NAME) {
		ITEM_NAME = iTEM_NAME;
	}
	public String getSALE_DATE() {
		return SALE_DATE;
	}
	public void setSALE_DATE(String sALE_DATE) {
		SALE_DATE = sALE_DATE;
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
	public String getMACHINE_TYPE() {
		return MACHINE_TYPE;
	}
	public void setMACHINE_TYPE(String mACHINE_TYPE) {
		MACHINE_TYPE = mACHINE_TYPE;
	}
	public String getWARR_MONTH() {
		return WARR_MONTH;
	}
	public void setWARR_MONTH(String wARR_MONTH) {
		WARR_MONTH = wARR_MONTH;
	}
	public String getWARR_DATE() {
		return WARR_DATE;
	}
	public void setWARR_DATE(String wARR_DATE) {
		WARR_DATE = wARR_DATE;
	}
	public String getAS_STATUS() {
		return AS_STATUS;
	}
	public void setAS_STATUS(String aS_STATUS) {
		AS_STATUS = aS_STATUS;
	}
	public String getRECEIPT_PRSN() {
		return RECEIPT_PRSN;
	}
	public void setRECEIPT_PRSN(String rECEIPT_PRSN) {
		RECEIPT_PRSN = rECEIPT_PRSN;
	}
	public String getCONT_FR_DATE() {
		return CONT_FR_DATE;
	}
	public void setCONT_FR_DATE(String cONT_FR_DATE) {
		CONT_FR_DATE = cONT_FR_DATE;
	}
	public String getCONT_TO_DATE() {
		return CONT_TO_DATE;
	}
	public void setCONT_TO_DATE(String cONT_TO_DATE) {
		CONT_TO_DATE = cONT_TO_DATE;
	}
	public String getCONT_GRADE() {
		return CONT_GRADE;
	}
	public void setCONT_GRADE(String cONT_GRADE) {
		CONT_GRADE = cONT_GRADE;
	}
	public String getBILL_NUM() {
		return BILL_NUM;
	}
	public void setBILL_NUM(String bILL_NUM) {
		BILL_NUM = bILL_NUM;
	}
	public Integer getBILL_SEQ() {
		return BILL_SEQ;
	}
	public void setBILL_SEQ(String bILL_SEQ) {
		BILL_SEQ = ObjUtils.parseInt(bILL_SEQ, 0);
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getIN_DATE() {
		return IN_DATE;
	}
	public void setIN_DATE(String iN_DATE) {
		IN_DATE = iN_DATE;
	}
	public String getOUT_DATE() {
		return OUT_DATE;
	}
	public void setOUT_DATE(String oUT_DATE) {
		OUT_DATE = oUT_DATE;
	}
	public String getFDA_Q1_YN() {
		return FDA_Q1_YN;
	}
	public void setFDA_Q1_YN(String fDA_Q1_YN) {
		FDA_Q1_YN = fDA_Q1_YN;
	}
	public String getFDA_Q2_YN() {
		return FDA_Q2_YN;
	}
	public void setFDA_Q2_YN(String fDA_Q2_YN) {
		FDA_Q2_YN = fDA_Q2_YN;
	}
	public String getFDA_Q3_YN() {
		return FDA_Q3_YN;
	}
	public void setFDA_Q3_YN(String fDA_Q3_YN) {
		FDA_Q3_YN = fDA_Q3_YN;
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
	
	
}