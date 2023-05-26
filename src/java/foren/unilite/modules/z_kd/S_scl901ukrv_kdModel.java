package foren.unilite.modules.z_kd;

import foren.framework.model.BaseVO;

public class S_scl901ukrv_kdModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String COMP_CODE;  
    private String COMP_NAME;     
    private String CUSTOM_CODE;           
    private String CLAIM_DATE;     
    private String DIV_CODE;     
    private String CLAIM_NO;
	/* Session Variables */
    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    public static long getSerialversionuid() {
        return serialVersionUID;
    }
    public String getCOMP_CODE() {
        return COMP_CODE;
    }
    public String getCOMP_NAME() {
        return COMP_NAME;
    }
    public String getCUSTOM_CODE() {
        return CUSTOM_CODE;
    }
    public String getCLAIM_DATE() {
        return CLAIM_DATE;
    }
    public String getDIV_CODE() {
        return DIV_CODE;
    }
    public String getCLAIM_NO() {
        return CLAIM_NO;
    }
    public String getS_COMP_CODE() {
        return S_COMP_CODE;
    }
    public String getS_AUTHORITY_LEVEL() {
        return S_AUTHORITY_LEVEL;
    }
    public String getS_USER_ID() {
        return S_USER_ID;
    }
    public void setCOMP_CODE( String cOMP_CODE ) {
        COMP_CODE = cOMP_CODE;
    }
    public void setCOMP_NAME( String cOMP_NAME ) {
        COMP_NAME = cOMP_NAME;
    }
    public void setCUSTOM_CODE( String cUSTOM_CODE ) {
        CUSTOM_CODE = cUSTOM_CODE;
    }
    public void setCLAIM_DATE( String cLAIM_DATE ) {
        CLAIM_DATE = cLAIM_DATE;
    }
    public void setDIV_CODE( String dIV_CODE ) {
        DIV_CODE = dIV_CODE;
    }
    public void setCLAIM_NO( String cLAIM_NO ) {
        CLAIM_NO = cLAIM_NO;
    }
    public void setS_COMP_CODE( String s_COMP_CODE ) {
        S_COMP_CODE = s_COMP_CODE;
    }
    public void setS_AUTHORITY_LEVEL( String s_AUTHORITY_LEVEL ) {
        S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
    }
    public void setS_USER_ID( String s_USER_ID ) {
        S_USER_ID = s_USER_ID;
    }
    
    
}
