package foren.unilite.modules.sales.ssa;

import foren.framework.model.BaseVO;

public class Ssa100ukrvModel extends BaseVO {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String  BILL_TYPE;
	private String  CARD_CUST_CD;
	private String  ORDER_TYPE;
	private String  PROJECT_NO;
	private String  TAX_TYPE;
	private String  REMARK;
	private String  COMP_CODE;
	private String  DIV_CODE;
	private String  BILL_NUM;
	private String  MONEY_UNIT;
	private String  EXCHG_RATE_O;
	//20190709 추가
	private String SALE_PRSN;
	//20200629 추가: 구매확인서 번호, 발급일자
	private String PURCH_DOC_NO;
	private String ISSUE_DATE;
	
	// 20210222 : 카드사(CARD_CUSTOM_CODE) 추가
	private String CARD_CUSTOM_CODE;
	
	// 20210705 : 결제조건(PAYMENT_TERM), 결제예정일(PAYMENT_DAY) 추가
	private String PAYMENT_TERM;
	private String PAYMENT_DAY;
	
	//20190709 추가
	public String getSALE_PRSN() {
		return SALE_PRSN;
	}
	public void setSALE_PRSN(String sALE_PRSN) {
		SALE_PRSN = sALE_PRSN;
	}
	//20200629 추가: 구매확인서 번호, 발급일자
	public String getPURCH_DOC_NO() {
		return PURCH_DOC_NO;
	}
	public void setPURCH_DOC_NO(String pURCH_DOC_NO) {
		PURCH_DOC_NO = pURCH_DOC_NO;
	}
	public String getISSUE_DATE() {
		return ISSUE_DATE;
	}
	public void setISSUE_DATE(String iSSUE_DATE) {
		ISSUE_DATE = iSSUE_DATE;
	}
	public String getBILL_TYPE() {
		return BILL_TYPE;
	}
	public void setBILL_TYPE(String bILL_TYPE) {
		BILL_TYPE = bILL_TYPE;
	}
	public String getCARD_CUST_CD() {
		return CARD_CUST_CD;
	}
	public void setCARD_CUST_CD(String cARD_CUST_CD) {
		CARD_CUST_CD = cARD_CUST_CD;
	}
	public String getORDER_TYPE() {
		return ORDER_TYPE;
	}
	public void setORDER_TYPE(String oRDER_TYPE) {
		ORDER_TYPE = oRDER_TYPE;
	}
	public String getPROJECT_NO() {
		return PROJECT_NO;
	}
	public void setPROJECT_NO(String pROJECT_NO) {
		PROJECT_NO = pROJECT_NO;
	}
	public String getTAX_TYPE() {
		return TAX_TYPE;
	}
	public void setTAX_TYPE(String tAX_TYPE) {
		TAX_TYPE = tAX_TYPE;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
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
	public String getBILL_NUM() {
		return BILL_NUM;
	}
	public void setBILL_NUM(String bILL_NUM) {
		BILL_NUM = bILL_NUM;
	}
	public String getEXCHG_RATE_O() {
		return EXCHG_RATE_O;
	}
	public void setEXCHG_RATE_O(String eXCHG_RATE_O) {
		EXCHG_RATE_O = eXCHG_RATE_O;
	}
	public String getMONEY_UNIT() {
		return MONEY_UNIT;
	}
	public void setMONEY_UNIT(String mONEY_UNIT) {
		MONEY_UNIT = mONEY_UNIT;
	}
	public String getCARD_CUSTOM_CODE() {
		return CARD_CUSTOM_CODE;
	}
	public void setCARD_CUSTOM_CODE(String cARD_CUSTOM_CODE) {
		CARD_CUSTOM_CODE = cARD_CUSTOM_CODE;
	}
	public String getPAYMENT_TERM() {
		return PAYMENT_TERM;
	}
	public void setPAYMENT_TERM(String pAYMENT_TERM) {
		PAYMENT_TERM = pAYMENT_TERM;
	}
	public String getPAYMENT_DAY() {
		return PAYMENT_DAY;
	}
	public void setPAYMENT_DAY(String pAYMENT_DAY) {
		PAYMENT_DAY = pAYMENT_DAY;
	}
}