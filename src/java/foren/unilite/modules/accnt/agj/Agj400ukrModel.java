package foren.unilite.modules.accnt.agj;

import foren.framework.model.BaseVO;

public class Agj400ukrModel extends BaseVO {
	private static final long serialVersionUID = 1L;
	
	private String  S_COMP_CODE;
    private String  S_USER_ID;
   
    private String PAY_DRAFT_NO  ;       //지출결의번호
    private String PAY_DATE      ;       //지출결의일
    private String SLIP_DATE     ;       //전표일
    private String DRAFTER_PN    ;       //기안자
    private String PAY_USER_PN      ;       //사용자
    private String DEPT_CODE     ;       //부서
    private String DIV_CODE      ;       //사업장
    private Double TOT_AMT_I  = 0d   ;       //총금액
    private String TITLE         ;       //제목
    private String TITLE_DESC    ;       //지출내용
    private String RETURN_REASON ;       //반려사유(사용안함)
    private String RETURN_PRSN   ;       //반려자(사용안함)
    private String RETURN_DATE   ;       //반려일(YYYYMMDD)(사용안함)
    private String RETURN_TIME   ;       //반려시간(HHMMSS)(사용안함)
    private String STATUS        ;       //상태(사용안함)
    private String CONFIRM_YN    ;       //확정여부(필요에 따라 사용)
    private String EX_DATE       ;       //결의일자
    private String EX_NUM        ;
	private String  FILE_NUM	;
	private String  ADD_FID   ;
	private String  DEL_FID   ;
    
    
    
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public String getPAY_DRAFT_NO() {
		return PAY_DRAFT_NO;
	}
	public String getPAY_DATE() {
		return PAY_DATE;
	}
	public String getSLIP_DATE() {
		return SLIP_DATE;
	}
	public String getDRAFTER_PN() {
		return DRAFTER_PN;
	}
	public String getDEPT_CODE() {
		return DEPT_CODE;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public Double getTOT_AMT_I() {
		return TOT_AMT_I;
	}
	public String getTITLE() {
		return TITLE;
	}
	public String getTITLE_DESC() {
		return TITLE_DESC;
	}
	public String getRETURN_REASON() {
		return RETURN_REASON;
	}
	public String getRETURN_PRSN() {
		return RETURN_PRSN;
	}
	public String getRETURN_DATE() {
		return RETURN_DATE;
	}
	public String getRETURN_TIME() {
		return RETURN_TIME;
	}
	public String getSTATUS() {
		return STATUS;
	}
	public String getCONFIRM_YN() {
		return CONFIRM_YN;
	}
	public String getEX_DATE() {
		return EX_DATE;
	}
	public String getEX_NUM() {
		return EX_NUM;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public void setPAY_DRAFT_NO(String pAY_DRAFT_NO) {
		PAY_DRAFT_NO = pAY_DRAFT_NO;
	}
	public void setPAY_DATE(String pAY_DATE) {
		PAY_DATE = pAY_DATE;
	}
	public void setSLIP_DATE(String sLIP_DATE) {
		SLIP_DATE = sLIP_DATE;
	}
	public void setDRAFTER_PN(String dRAFTER_PN) {
		DRAFTER_PN = dRAFTER_PN;
	}

	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public void setTOT_AMT_I(Double tOT_AMT_I) {
		if(tOT_AMT_I == null)	{
			TOT_AMT_I = 0d;
		} else {
			TOT_AMT_I = tOT_AMT_I;
		}
	}
	public void setTITLE(String tITLE) {
		TITLE = tITLE;
	}
	public void setTITLE_DESC(String tITLE_DESC) {
		TITLE_DESC = tITLE_DESC;
	}
	public void setRETURN_REASON(String rETURN_REASON) {
		RETURN_REASON = rETURN_REASON;
	}
	public void setRETURN_PRSN(String rETURN_PRSN) {
		RETURN_PRSN = rETURN_PRSN;
	}
	public void setRETURN_DATE(String rETURN_DATE) {
		RETURN_DATE = rETURN_DATE;
	}
	public void setRETURN_TIME(String rETURN_TIME) {
		RETURN_TIME = rETURN_TIME;
	}
	public void setSTATUS(String sTATUS) {
		STATUS = sTATUS;
	}
	public void setCONFIRM_YN(String cONFIRM_YN) {
		CONFIRM_YN = cONFIRM_YN;
	}
	public void setEX_DATE(String eX_DATE) {
		EX_DATE = eX_DATE;
	}
	public void setEX_NUM(String eX_NUM) {
		EX_NUM = eX_NUM;
	}
	public String getPAY_USER_PN() {
		return PAY_USER_PN;
	}
	public void setPAY_USER_PN(String pAY_USER_PN) {
		PAY_USER_PN = pAY_USER_PN;
	}
	public String getFILE_NUM() {
		return FILE_NUM;
	}
	public String getADD_FID() {
		return ADD_FID;
	}
	public String getDEL_FID() {
		return DEL_FID;
	}
	public void setFILE_NUM(String fILE_NUM) {
		FILE_NUM = fILE_NUM;
	}
	public void setADD_FID(String aDD_FID) {
		ADD_FID = aDD_FID;
	}
	public void setDEL_FID(String dEL_FID) {
		DEL_FID = dEL_FID;
	}       
    
    
    
}
