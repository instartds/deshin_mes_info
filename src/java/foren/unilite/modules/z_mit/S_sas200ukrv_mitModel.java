package foren.unilite.modules.z_mit;

import foren.framework.model.BaseVO;

public class S_sas200ukrv_mitModel extends BaseVO {
	private static final long serialVersionUID = 1L;
	
	/* Primary Key */
	private String  COMP_CODE   ;
	private String  DIV_CODE    ;
	private String  QUOT_NUM ;
	
	
	private String  QUOT_DATE;
	private String  QUOT_PRSN   ;
	private String  REPAIR_RANK   ;
	private String  ITEM_NAME	;
	private String  COST_YN 	;
	private String  BAD_REMARK	;
	private String  REMARK	;
	private String  RECEIPT_NUM;
	private String  FILE_NUM	;
	private String  ADD_FID   ;
	private String  DEL_FID   ;
	private String  MACHINE_TYPE;
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
	public String getQUOT_NUM() {
		return QUOT_NUM;
	}
	public void setQUOT_NUM(String qUOT_NUM) {
		QUOT_NUM = qUOT_NUM;
	}

	public String getQUOT_PRSN() {
		return QUOT_PRSN;
	}
	public void setQUOT_PRSN(String qUOT_PRSN) {
		QUOT_PRSN = qUOT_PRSN;
	}
	public String getREPAIR_RANK() {
		return REPAIR_RANK;
	}
	public void setREPAIR_RANK(String rEPAIR_RANK) {
		REPAIR_RANK = rEPAIR_RANK;
	}
	public String getITEM_NAME() {
		return ITEM_NAME;
	}
	public void setITEM_NAME(String iTEM_NAME) {
		ITEM_NAME = iTEM_NAME;
	}
	public String getCOST_YN() {
		return COST_YN;
	}
	public void setCOST_YN(String cOST_YN) {
		COST_YN = cOST_YN;
	}
	public String getBAD_REMARK() {
		return BAD_REMARK;
	}
	public void setBAD_REMARK(String bAD_REMARK) {
		BAD_REMARK = bAD_REMARK;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getRECEIPT_NUM() {
		return RECEIPT_NUM;
	}
	public void setRECEIPT_NUM(String rECEIPT_NUM) {
		RECEIPT_NUM = rECEIPT_NUM;
	}
	public String getFILE_NUM() {
		return FILE_NUM;
	}
	public void setFILE_NUM(String fILE_NUM) {
		FILE_NUM = fILE_NUM;
	}
	public String getADD_FID() {
		return ADD_FID;
	}
	public void setADD_FID(String aDD_FID) {
		ADD_FID = aDD_FID;
	}
	public String getDEL_FID() {
		return DEL_FID;
	}
	public void setDEL_FID(String dEL_FID) {
		DEL_FID = dEL_FID;
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
	public String getMACHINE_TYPE() {
		return MACHINE_TYPE;
	}
	public void setMACHINE_TYPE(String mACHINE_TYPE) {
		MACHINE_TYPE = mACHINE_TYPE;
	}
	public String getQUOT_DATE() {
		return QUOT_DATE;
	}
	public void setQUOT_DATE(String qUOT_DATE) {
		QUOT_DATE = qUOT_DATE;
	}
	
}