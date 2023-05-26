package foren.unilite.modules.z_kocis;

import foren.framework.model.BaseVO;

public class S_Afb730ukrkocisModel extends BaseVO {
	
	private static final long serialVersionUID = 1L;

	private String COMP_CODE;
    private String DEPT_CODE;
    private String AC_YYYY;
    private int IDX;
    private String DOC_NO;
    private String EX_DATE;
    private String AC_TYPE;
    private String BUDG_CODE;
    private Double EX_AMT;
    private String ACCT_NO;
    private String REMARK;     
    private String AP_STS;
    private String REF_DOC_NO;
	
	private String SAVE_FLAG;
	
	private String  S_COMP_CODE;
	private String  S_DEPT_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    
   
    private String BUDG_YYYYMM;
    private Double BUDG_I;
    private Double BUDG_CONF_I;
    
    private String STATUS;
    
    private int REF_DOC_SEQ;
    
    private Double CURR_RATE;
    private String CURR_UNIT;
    private Double CURR_AMT;
    

    private String AC_GUBUN;

    private String REF_EX_DATE;
    
    
    
    
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
    public String getAC_YYYY() {
        return AC_YYYY;
    }
    public void setAC_YYYY( String aC_YYYY ) {
        AC_YYYY = aC_YYYY;
    }
    public int getIDX() {
        return IDX;
    }
    public void setIDX( int iDX ) {
        IDX = iDX;
    }
    public String getDOC_NO() {
        return DOC_NO;
    }
    public void setDOC_NO( String dOC_NO ) {
        DOC_NO = dOC_NO;
    }
    public String getEX_DATE() {
        return EX_DATE;
    }
    public void setEX_DATE( String eX_DATE ) {
        EX_DATE = eX_DATE;
    }
    public String getAC_TYPE() {
        return AC_TYPE;
    }
    public void setAC_TYPE( String aC_TYPE ) {
        AC_TYPE = aC_TYPE;
    }
    public String getBUDG_CODE() {
        return BUDG_CODE;
    }
    public void setBUDG_CODE( String bUDG_CODE ) {
        BUDG_CODE = bUDG_CODE;
    }
    public Double getEX_AMT() {
        return EX_AMT;
    }
    public void setEX_AMT( Double eX_AMT ) {
        EX_AMT = eX_AMT;
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
    public String getAP_STS() {
        return AP_STS;
    }
    public void setAP_STS( String aP_STS ) {
        AP_STS = aP_STS;
    }
    public String getREF_DOC_NO() {
        return REF_DOC_NO;
    }
    public void setREF_DOC_NO( String rEF_DOC_NO ) {
        REF_DOC_NO = rEF_DOC_NO;
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
    
    public String getSTATUS() {
        return STATUS;
    }
    public void setSTATUS( String sTATUS ) {
        STATUS = sTATUS;
    }
    public int getREF_DOC_SEQ() {
        return REF_DOC_SEQ;
    }
    public void setREF_DOC_SEQ( int rEF_DOC_SEQ ) {
        REF_DOC_SEQ = rEF_DOC_SEQ;
    }
    
    public Double getCURR_RATE() {
        return CURR_RATE;
    }
    public void setCURR_RATE( Double cURR_RATE ) {
        CURR_RATE = cURR_RATE;
    }
    public String getCURR_UNIT() {
        return CURR_UNIT;
    }
    public void setCURR_UNIT( String cURR_UNIT ) {
        CURR_UNIT = cURR_UNIT;
    }
    public Double getCURR_AMT() {
        return CURR_AMT;
    }
    public void setCURR_AMT( Double cURR_AMT ) {
        CURR_AMT = cURR_AMT;
    }
    public String getAC_GUBUN() {
        return AC_GUBUN;
    }
    public void setAC_GUBUN( String aC_GUBUN ) {
        AC_GUBUN = aC_GUBUN;
    }
    
    public String getREF_EX_DATE() {
        return REF_EX_DATE;
    }
    public void setREF_EX_DATE( String rEF_EX_DATE ) {
        REF_EX_DATE = rEF_EX_DATE;
    }
    
}
