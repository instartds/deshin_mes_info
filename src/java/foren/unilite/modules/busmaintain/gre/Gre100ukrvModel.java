package foren.unilite.modules.busmaintain.gre;

import foren.framework.model.BaseVO;

public class Gre100ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String  COMP_CODE;
    private String  DIV_CODE;
    private String  REQUEST_NUM;
    private String  REQUEST_DATE;
    private String  VEHICLE_CODE;
    private String  DRIVER_CODE;
    private String  ROUTE_CODE;
    private String  COMMENTS;

    
    private String  REMARK;
     
	   /* Session Variables */
    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
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
	
	public String getREQUEST_NUM() {
		return REQUEST_NUM;
	}
	public void setREQUEST_NUM(String rEQUEST_NUM) {
		REQUEST_NUM = rEQUEST_NUM;
	}
	public String getREQUEST_DATE() {
		return REQUEST_DATE;
	}
	public void setREQUEST_DATE(String rEQUEST_DATE) {
		REQUEST_DATE = rEQUEST_DATE;
	}
	public String getVEHICLE_CODE() {
		return VEHICLE_CODE;
	}
	public void setVEHICLE_CODE(String vEHICLE_CODE) {
		VEHICLE_CODE = vEHICLE_CODE;
	}
	public String getDRIVER_CODE() {
		return DRIVER_CODE;
	}
	public void setDRIVER_CODE(String dRIVER_CODE) {
		DRIVER_CODE = dRIVER_CODE;
	}
	public String getROUTE_CODE() {
		return ROUTE_CODE;
	}
	public void setROUTE_CODE(String rOUTE_CODE) {
		ROUTE_CODE = rOUTE_CODE;
	}
	public String getCOMMENTS() {
		return COMMENTS;
	}
	public void setCOMMENTS(String cOMMENTS) {
		COMMENTS = cOMMENTS;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public String getS_AUTHORITY_LEVEL() {
		return S_AUTHORITY_LEVEL;
	}
	public void setS_AUTHORITY_LEVEL(String s_AUTHORITY_LEVEL) {
		S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	
    
	
	
}
