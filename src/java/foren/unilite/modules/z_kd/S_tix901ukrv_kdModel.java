package foren.unilite.modules.z_kd;

import foren.framework.model.BaseVO;

public class S_tix901ukrv_kdModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String COMP_CODE;  
    private String COMP_NAME;     
    private String COMP_ENG_NAME;  
    private String DIV_CODE;    
    private String OFFER_NO;    
    private int EXCHG_RATE_O;    
    private int LC_RATE;    
    private int FOB_FOR_AMT;    
    private int CBM;    
    private int IMPORT_TAX_RATE;    
    private int UNLOAD_AMT;    
    private String UNLOAD_PLACE;    
    private int ETC_AMT;    
    private String REMARK;  
    private String INSERT_DB_USER;  
    private String INSERT_DB_TIME;  
    private String UPDATE_DB_USER;  
    private String UPDATE_DB_TIME;  
    
	public void setINSERT_DB_USER( String iNSERT_DB_USER ) {
        INSERT_DB_USER = iNSERT_DB_USER;
    }
    public void setINSERT_DB_TIME( String iNSERT_DB_TIME ) {
        INSERT_DB_TIME = iNSERT_DB_TIME;
    }
    public void setUPDATE_DB_USER( String uPDATE_DB_USER ) {
        UPDATE_DB_USER = uPDATE_DB_USER;
    }
    public void setUPDATE_DB_TIME( String uPDATE_DB_TIME ) {
        UPDATE_DB_TIME = uPDATE_DB_TIME;
    }
    public String getINSERT_DB_USER() {
        return INSERT_DB_USER;
    }
    public String getINSERT_DB_TIME() {
        return INSERT_DB_TIME;
    }
    public String getUPDATE_DB_USER() {
        return UPDATE_DB_USER;
    }
    public String getUPDATE_DB_TIME() {
        return UPDATE_DB_TIME;
    }
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
    public String getCOMP_ENG_NAME() {
        return COMP_ENG_NAME;
    }
    public String getDIV_CODE() {
        return DIV_CODE;
    }
    public String getOFFER_NO() {
        return OFFER_NO;
    }
    public int getEXCHG_RATE_O() {
        return EXCHG_RATE_O;
    }
    public int getLC_RATE() {
        return LC_RATE;
    }
    public int getFOB_FOR_AMT() {
        return FOB_FOR_AMT;
    }
    public int getCBM() {
        return CBM;
    }
    public int getIMPORT_TAX_RATE() {
        return IMPORT_TAX_RATE;
    }
    public int getUNLOAD_AMT() {
        return UNLOAD_AMT;
    }
    public String getUNLOAD_PLACE() {
        return UNLOAD_PLACE;
    }
    public int getETC_AMT() {
        return ETC_AMT;
    }
    public String getREMARK() {
        return REMARK;
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
    public void setCOMP_ENG_NAME( String cOMP_ENG_NAME ) {
        COMP_ENG_NAME = cOMP_ENG_NAME;
    }
    public void setDIV_CODE( String dIV_CODE ) {
        DIV_CODE = dIV_CODE;
    }
    public void setOFFER_NO( String oFFER_NO ) {
        OFFER_NO = oFFER_NO;
    }
    public void setEXCHG_RATE_O( int eXCHG_RATE_O ) {
        EXCHG_RATE_O = eXCHG_RATE_O;
    }
    public void setLC_RATE( int lC_RATE ) {
        LC_RATE = lC_RATE;
    }
    public void setFOB_FOR_AMT( int fOB_FOR_AMT ) {
        FOB_FOR_AMT = fOB_FOR_AMT;
    }
    public void setCBM( int cBM ) {
        CBM = cBM;
    }
    public void setIMPORT_TAX_RATE( int iMPORT_TAX_RATE ) {
        IMPORT_TAX_RATE = iMPORT_TAX_RATE;
    }
    public void setUNLOAD_AMT( int uNLOAD_AMT ) {
        UNLOAD_AMT = uNLOAD_AMT;
    }
    public void setUNLOAD_PLACE( String uNLOAD_PLACE ) {
        UNLOAD_PLACE = uNLOAD_PLACE;
    }
    public void setETC_AMT( int eTC_AMT ) {
        ETC_AMT = eTC_AMT;
    }
    public void setREMARK( String rEMARK ) {
        REMARK = rEMARK;
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
