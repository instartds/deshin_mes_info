package foren.unilite.modules.sales.ssa;

import foren.framework.model.BaseVO;

public class Ssa390ukrvModel extends BaseVO {
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
    //20190730 추가
    private String CONT_STATE;
    private Double CONT_AMT;
    private Double TOT_SALES_AMT;
    private Double REMAIN_AMT;

	public String getSALE_PRSN() {
		return SALE_PRSN;
	}
	public void setSALE_PRSN(String sALE_PRSN) {
		SALE_PRSN = sALE_PRSN;
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
	public String getCONT_STATE() {
		return CONT_STATE;
	}
	public void setCONT_STATE(String cONT_STATE) {
		CONT_STATE = cONT_STATE;
	}
	public Double getCONT_AMT() {
		return CONT_AMT;
	}
	public void setCONT_AMT(Double cONT_AMT) {
		CONT_AMT = cONT_AMT;
	}
	public Double getTOT_SALES_AMT() {
		return TOT_SALES_AMT;
	}
	public void setTOT_SALES_AMT(Double tOT_SALES_AMT) {
		TOT_SALES_AMT = tOT_SALES_AMT;
	}
	public Double getREMAIN_AMT() {
		return REMAIN_AMT;
	}
	public void setREMAIN_AMT(Double rEMAIN_AMT) {
		REMAIN_AMT = rEMAIN_AMT;
	}
}
