package foren.unilite.modules.z_kd;

import foren.framework.model.BaseVO;

public class S_ryt200ukrv_kdModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String COMP_CODE;  
    private String DIV_CODE; 
    private String CUSTOM_CODE;  
    private String WORK_YEAR; 
    private String WORK_SEQ; 
    private String CUSTOM_NAME; 
    private String CON_FR_YYMM;  
    private String CON_TO_YYMM; 
    private String GUBUN1;  
    private String GUBUN2; 
    private String GUBUN3;  
    private String MONEY_UNIT; 
    private String RYT_P; 
    
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
    public String getDIV_CODE() {
        return DIV_CODE;
    }
    public String getCUSTOM_CODE() {
        return CUSTOM_CODE;
    }
    public String getWORK_YEAR() {
        return WORK_YEAR;
    }
    public String getWORK_SEQ() {
        return WORK_SEQ;
    }
    public String getCUSTOM_NAME() {
        return CUSTOM_NAME;
    }
    public String getCON_FR_YYMM() {
        return CON_FR_YYMM;
    }
    public String getCON_TO_YYMM() {
        return CON_TO_YYMM;
    }
    public String getGUBUN1() {
        return GUBUN1;
    }
    public String getGUBUN2() {
        return GUBUN2;
    }
    public String getGUBUN3() {
        return GUBUN3;
    }
    public String getMONEY_UNIT() {
        return MONEY_UNIT;
    }
    public String getRYT_P() {
        return RYT_P;
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
    public void setDIV_CODE( String dIV_CODE ) {
        DIV_CODE = dIV_CODE;
    }
    public void setCUSTOM_CODE( String cUSTOM_CODE ) {
        CUSTOM_CODE = cUSTOM_CODE;
    }
    public void setCUSTOM_NAME( String cUSTOM_NAME ) {
        CUSTOM_NAME = cUSTOM_NAME;
    }
    public void setCON_FR_YYMM( String cON_FR_YYMM ) {
        CON_FR_YYMM = cON_FR_YYMM;
    }
    public void setCON_TO_YYMM( String cON_TO_YYMM ) {
        CON_TO_YYMM = cON_TO_YYMM;
    }
    public void setGUBUN1( String gUBUN1 ) {
        GUBUN1 = gUBUN1;
    }
    public void setGUBUN2( String gUBUN2 ) {
        GUBUN2 = gUBUN2;
    }
    public void setGUBUN3( String gUBUN3 ) {
        GUBUN3 = gUBUN3;
    }
    public void setMONEY_UNIT( String mONEY_UNIT ) {
        MONEY_UNIT = mONEY_UNIT;
    }
    public void setRYT_P( String rYT_P ) {
        RYT_P = rYT_P;
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
    
    public void setWORK_YEAR(String wORK_YEAR) {
    	WORK_YEAR = wORK_YEAR;
    }
    public void setWORK_SEQ(String wORK_SEQ) {
    	 WORK_SEQ =  wORK_SEQ;
    }
   
    
}
