package foren.unilite.modules.sales.sat;

import foren.framework.model.BaseVO;

public class Sat610ukrvModel extends BaseVO {
	private static final long serialVersionUID = 1L;
	
	/* Primary Key */
	private String  S_COMP_CODE   ;
	private String  DIV_CODE    ;
	                                   ;
	private String  INOUT_NUM          ;                     // 수불번호
	private String  INOUT_SEQ          ;                     // 수불순번
	private String  INOUT_TYPE         ;                     // 수불유형 (1:입고, 2:출고)
	private String  INOUT_METH         ;                     // 수불방법 (1:정상, 2:연장, 3:이동)
	private String  ASST_CODE          ;                     // 자산코드
	private String  INOUT_DATE         ;                     // 수불일
	private String  CUSTOM_NAME        ;                     // 납품처명
	private String  AGENT_CUSTOM_CODE  ;                     // 대리점 거래처코드
	private String  AGENT_CUSTOM_NAME  ;                     // 대리점 거래처명
	private String  USE_GUBUN          ;                     // 사용구분
	private String  USE_FR_DATE        ;                     // 사용기간FR
	private String  USE_TO_DATE        ;                     // 사용기간TO
	private String  INOUT_USER         ;                     // 입출고담당자
	private String  REMARK             ;                     // 비고
	private String  REQ_NO             ;                     // 출고요청번호
	private String  REQ_SEQ            ;                     // 요청순번
	private String  BASIS_NUM          ;                     // 출고번호
	private String  BASIS_SEQ          ;                     // 출고순번
	;
	private String   S_USER_ID         ;
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public String getINOUT_NUM() {
		return INOUT_NUM;
	}
	public String getINOUT_SEQ() {
		return INOUT_SEQ;
	}
	public String getINOUT_TYPE() {
		return INOUT_TYPE;
	}
	public String getINOUT_METH() {
		return INOUT_METH;
	}
	public String getASST_CODE() {
		return ASST_CODE;
	}
	public String getINOUT_DATE() {
		return INOUT_DATE;
	}
	public String getCUSTOM_NAME() {
		return CUSTOM_NAME;
	}
	public String getAGENT_CUSTOM_CODE() {
		return AGENT_CUSTOM_CODE;
	}
	public String getAGENT_CUSTOM_NAME() {
		return AGENT_CUSTOM_NAME;
	}
	public void setAGENT_CUSTOM_NAME(String aGENT_CUSTOM_NAME) {
		AGENT_CUSTOM_NAME = aGENT_CUSTOM_NAME;
	}
	public String getUSE_GUBUN() {
		return USE_GUBUN;
	}
	public String getUSE_FR_DATE() {
		return USE_FR_DATE;
	}
	public String getUSE_TO_DATE() {
		return USE_TO_DATE;
	}
	public String getINOUT_USER() {
		return INOUT_USER;
	}
	public String getREMARK() {
		return REMARK;
	}
	public String getREQ_NO() {
		return REQ_NO;
	}
	public String getREQ_SEQ() {
		return REQ_SEQ;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public void setINOUT_NUM(String iNOUT_NUM) {
		INOUT_NUM = iNOUT_NUM;
	}
	public void setINOUT_SEQ(String iNOUT_SEQ) {
		INOUT_SEQ = iNOUT_SEQ;
	}
	public void setINOUT_TYPE(String iNOUT_TYPE) {
		INOUT_TYPE = iNOUT_TYPE;
	}
	public void setINOUT_METH(String iNOUT_METH) {
		INOUT_METH = iNOUT_METH;
	}
	public void setASST_CODE(String aSST_CODE) {
		ASST_CODE = aSST_CODE;
	}
	public void setINOUT_DATE(String iNOUT_DATE) {
		INOUT_DATE = iNOUT_DATE;
	}
	public void setCUSTOM_NAME(String cUSTOM_NAME) {
		CUSTOM_NAME = cUSTOM_NAME;
	}
	public void setAGENT_CUSTOM_CODE(String aGENT_CUSTOM_CODE) {
		AGENT_CUSTOM_CODE = aGENT_CUSTOM_CODE;
	}
	public void setUSE_GUBUN(String uSE_GUBUN) {
		USE_GUBUN = uSE_GUBUN;
	}
	public void setUSE_FR_DATE(String uSE_FR_DATE) {
		USE_FR_DATE = uSE_FR_DATE;
	}
	public void setUSE_TO_DATE(String uSE_TO_DATE) {
		USE_TO_DATE = uSE_TO_DATE;
	}
	public void setINOUT_USER(String iNOUT_USER) {
		INOUT_USER = iNOUT_USER;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public void setREQ_NO(String rEQ_NO) {
		REQ_NO = rEQ_NO;
	}
	public void setREQ_SEQ(String rEQ_SEQ) {
		REQ_SEQ = rEQ_SEQ;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	
	
	
}