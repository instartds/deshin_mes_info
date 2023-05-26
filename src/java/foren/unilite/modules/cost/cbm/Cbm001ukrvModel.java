package foren.unilite.modules.cost.cbm;

import foren.framework.model.BaseVO;

public class Cbm001ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    private String APPLY_TYPE;
    private String APPLY_UNIT;
    private String DIST_KIND;
    private String DIST_KIND2;
    private String DIST_KIND3;
    private String DIST_KIND4;
    private String M_COST_CODE;
    private String M_COST_NAME;
    private String SUMMARY_DATA;
    private String SUMMARY_REF02_DATA;
    
	/* Session Variables */
    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    
	public String getAPPLY_TYPE() {
		return APPLY_TYPE;
	}
	public void setAPPLY_TYPE(String aPPLY_TYPE) {
		APPLY_TYPE = aPPLY_TYPE;
	}
	public String getAPPLY_UNIT() {
		return APPLY_UNIT;
	}
	public void setAPPLY_UNIT(String aPPLY_UNIT) {
		APPLY_UNIT = aPPLY_UNIT;
	}
	public String getDIST_KIND() {
		return DIST_KIND;
	}
	public void setDIST_KIND(String dIST_KIND) {
		DIST_KIND = dIST_KIND;
	}
	
	public String getDIST_KIND2() {
		return DIST_KIND2;
	}
	public void setDIST_KIND2(String dIST_KIND2) {
		DIST_KIND2 = dIST_KIND2;
	}
	public String getDIST_KIND3() {
		return DIST_KIND3;
	}
	public void setDIST_KIND3(String dIST_KIND3) {
		DIST_KIND3 = dIST_KIND3;
	}
	public String getDIST_KIND4() {
		return DIST_KIND4;
	}
	public void setDIST_KIND4(String dIST_KIND4) {
		DIST_KIND4 = dIST_KIND4;
	}
	public void setM_COST_CODE(String m_COST_CODE) {
		M_COST_CODE = m_COST_CODE;
	}
	public String getM_COST_NAME() {
		return M_COST_NAME;
	}
	public void setM_COST_NAME(String m_COST_NAME) {
		M_COST_NAME = m_COST_NAME;
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
	public String getM_COST_CODE() {
		return M_COST_CODE;
	}
	public String getSUMMARY_DATA() {
		return SUMMARY_DATA;
	}
	public void setSUMMARY_DATA(String sUMMARY_DATA) {
		SUMMARY_DATA = sUMMARY_DATA;
	}
	
	public String getSUMMARY_REF02_DATA() {
		return SUMMARY_REF02_DATA;
	}
	public void setSUMMARY_REF02_DATA(String sUMMARY_REF02_DATA) {
		SUMMARY_REF02_DATA = sUMMARY_REF02_DATA;
	}
	
}
