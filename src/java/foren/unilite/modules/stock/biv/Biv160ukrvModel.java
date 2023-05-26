package foren.unilite.modules.stock.biv;

import foren.framework.model.BaseVO;

public class Biv160ukrvModel extends BaseVO {

	private static final long serialVersionUID = 1L;

	private String DIV_CODE;
	private String COUNT_DATE;
	private String WH_CODE;
	private String ITEM_CODE;
	private String LOT_NO;
	private Long ADJ_STOCK_Q;
	private String ERR_DESC;
	
	private String COMP_CODE;
	private String USER_ID;
	
	private String S_COMP_CODE;
	private String S_DIV_CODE;
	private String S_USER_ID;
	
	
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getCOUNT_DATE() {
		return COUNT_DATE;
	}
	public void setCOUNT_DATE(String cOUNT_DATE) {
		COUNT_DATE = cOUNT_DATE;
	}
	public String getWH_CODE() {
		return WH_CODE;
	}
	public void setWH_CODE(String wH_CODE) {
		WH_CODE = wH_CODE;
	}
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
	public String getLOT_NO() {
		return LOT_NO;
	}
	public void setLOT_NO(String lOT_NO) {
		LOT_NO = lOT_NO;
	}
	public Long getADJ_STOCK_Q() {
		return ADJ_STOCK_Q;
	}
	public void setADJ_STOCK_Q(Long aDJ_STOCK_Q) {
		ADJ_STOCK_Q = aDJ_STOCK_Q;
	}
	public String getERR_DESC() {
		return ERR_DESC;
	}
	public void setERR_DESC(String eRR_DESC) {
		ERR_DESC = eRR_DESC;
	}
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getUSER_ID() {
		return USER_ID;
	}
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public String getS_DIV_CODE() {
		return S_DIV_CODE;
	}
	public void setS_DIV_CODE(String s_DIV_CODE) {
		S_DIV_CODE = s_DIV_CODE;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	
}
