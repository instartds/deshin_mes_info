package foren.unilite.modules.z_kocis;

import foren.framework.model.BaseVO;

public class S_Afb503ukrkocisModel extends BaseVO {
	
	private static final long serialVersionUID = 1L;

	private String COMP_CODE;
    private String DEPT_CODE;
	private String DOC_NO;
    private String AC_YYYY;
    private String AC_DATE;
	private String AC_GUBUN;
	private String BUDG_CODE;
	private String CURR_UNIT;
	private Double WON_AMT;
	private String ACCT_NO;
	private String REMARK;
    private String AC_TYPE;
	
	private String SAVE_FLAG;
	
	private String  S_COMP_CODE;
	private String  S_DEPT_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    
   
    private String BUDG_YYYYMM;
    private Double BUDG_I;
    private Double BUDG_CONF_I;
    
    public String getCOMP_CODE() {
        return COMP_CODE;
    }
    public void setCOMP_CODE( String cOMP_CODE ) {
        COMP_CODE = cOMP_CODE;
    }
    public String getDEPT_CODE() {
        return DEPT_CODE;
    }
    public void setDEPT_CODE( String dEPT_CODE ) {
        DEPT_CODE = dEPT_CODE;
    }
    public String getDOC_NO() {
        return DOC_NO;
    }
    public void setDOC_NO( String dOC_NO ) {
        DOC_NO = dOC_NO;
    }
    public String getAC_YYYY() {
        return AC_YYYY;
    }
    public void setAC_YYYY( String aC_YYYY ) {
        AC_YYYY = aC_YYYY;
    }
    public String getAC_DATE() {
        return AC_DATE;
    }
    public void setAC_DATE( String aC_DATE ) {
        AC_DATE = aC_DATE;
    }
    public String getAC_GUBUN() {
        return AC_GUBUN;
    }
    public void setAC_GUBUN( String aC_GUBUN ) {
        AC_GUBUN = aC_GUBUN;
    }
    public String getBUDG_CODE() {
        return BUDG_CODE;
    }
    public void setBUDG_CODE( String bUDG_CODE ) {
        BUDG_CODE = bUDG_CODE;
    }
    public String getCURR_UNIT() {
        return CURR_UNIT;
    }
    public void setCURR_UNIT( String cURR_UNIT ) {
        CURR_UNIT = cURR_UNIT;
    }
    public Double getWON_AMT() {
        return WON_AMT;
    }
    public void setWON_AMT( Double wON_AMT ) {
        WON_AMT = wON_AMT;
    }
    public String getACCT_NO() {
        return ACCT_NO;
    }
    public void setACCT_NO( String aCCT_NO ) {
        ACCT_NO = aCCT_NO;
    }
    public String getREMARK() {
        return REMARK;
    }
    public void setREMARK( String rEMARK ) {
        REMARK = rEMARK;
    }
    public String getAC_TYPE() {
        return AC_TYPE;
    }
    public void setAC_TYPE( String aC_TYPE ) {
        AC_TYPE = aC_TYPE;
    }
    public String getSAVE_FLAG() {
        return SAVE_FLAG;
    }
    public void setSAVE_FLAG( String sAVE_FLAG ) {
        SAVE_FLAG = sAVE_FLAG;
    }
    public String getS_COMP_CODE() {
        return S_COMP_CODE;
    }
    public void setS_COMP_CODE( String s_COMP_CODE ) {
        S_COMP_CODE = s_COMP_CODE;
    }
    public String getS_DEPT_CODE() {
        return S_DEPT_CODE;
    }
    public void setS_DEPT_CODE( String s_DEPT_CODE ) {
        S_DEPT_CODE = s_DEPT_CODE;
    }
    public String getS_AUTHORITY_LEVEL() {
        return S_AUTHORITY_LEVEL;
    }
    public void setS_AUTHORITY_LEVEL( String s_AUTHORITY_LEVEL ) {
        S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
    }
    public String getS_USER_ID() {
        return S_USER_ID;
    }
    public void setS_USER_ID( String s_USER_ID ) {
        S_USER_ID = s_USER_ID;
    }
    
    public String getBUDG_YYYYMM() {
        return BUDG_YYYYMM;
    }
    public void setBUDG_YYYYMM( String bUDG_YYYYMM ) {
        BUDG_YYYYMM = bUDG_YYYYMM;
    }
    public Double getBUDG_I() {
        return BUDG_I;
    }
    public void setBUDG_I( Double bUDG_I ) {
        BUDG_I = bUDG_I;
    }
    public Double getBUDG_CONF_I() {
        return BUDG_CONF_I;
    }
    public void setBUDG_CONF_I( Double bUDG_CONF_I ) {
        BUDG_CONF_I = bUDG_CONF_I;
    }
}
