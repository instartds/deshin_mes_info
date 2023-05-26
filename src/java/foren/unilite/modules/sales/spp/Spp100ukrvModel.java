package foren.unilite.modules.sales.spp;

import foren.framework.model.BaseVO;

public class Spp100ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String COMP_CODE;  
    private String COMP_NAME;     
    private String COMP_ENG_NAME; 
    private String REPRE_NAME;    
    private String REPRE_ENG_NAME;
    private String REPRE_NO;      
    private String COMPANY_NUM;   
    private String COMP_OWN_NO;   
    private String COMP_KIND;     
    private String COMP_CLASS;    
    private String COMP_TYPE;     
    private int    SESSION;       
    private String ESTI_NUM;                                                           
    private String DIV_CODE;                                                           
    private String CUSTOM_CODE;                                              
    private String CUSTOM_NAME;                                              
    private String ESTI_DATE;           
    private String MONEY_UNIT;                                                         
    private double EXCHANGE_RATE;                                                      
    private String CONFIRM_FLAG;                                                       
    private String CONFIRM_DATE;     
    private double ESTI_AMT;                                                           
    private double ESTI_CFM_AMT;                                                       
    private double ESTI_TAX_AMT;                                                       
    private String ESTI_PRSN;                                                          
    private String CUST_PRSN;                                                          
    private String ESTI_TITLE;                                                         
    private String ESTI_VALIDTERM;                                                     
    private String ESTI_PAYCONDI;                                                      
    private String ESTI_DVRY_DATE;                                                     
    private String ESTI_DVRY_PLCE;                                                     
    private String REMARK;                                                             
    private double PROFIT_RATE;                                                        
    private double ESTI_EX_AMT;                                                        
    private double ESTI_CFM_TAX_AMT;                                                   
    private double ESTI_CFM_EX_AMT;
    

    private String  S_COMP_CODE;
    public void setS_COMP_CODE( String s_COMP_CODE ) {
        S_COMP_CODE = s_COMP_CODE;
    }
    public void setS_USER_ID( String s_USER_ID ) {
        S_USER_ID = s_USER_ID;
    }
    private String  S_USER_ID;
    
    public void setCOMP_CODE( String cOMP_CODE ) {
        COMP_CODE = cOMP_CODE;
    }
    public void setCOMP_NAME( String cOMP_NAME ) {
        COMP_NAME = cOMP_NAME;
    }
    public void setCOMP_ENG_NAME( String cOMP_ENG_NAME ) {
        COMP_ENG_NAME = cOMP_ENG_NAME;
    }
    public void setREPRE_NAME( String rEPRE_NAME ) {
        REPRE_NAME = rEPRE_NAME;
    }
    public void setREPRE_ENG_NAME( String rEPRE_ENG_NAME ) {
        REPRE_ENG_NAME = rEPRE_ENG_NAME;
    }
    public void setREPRE_NO( String rEPRE_NO ) {
        REPRE_NO = rEPRE_NO;
    }
    public void setCOMPANY_NUM( String cOMPANY_NUM ) {
        COMPANY_NUM = cOMPANY_NUM;
    }
    public void setCOMP_OWN_NO( String cOMP_OWN_NO ) {
        COMP_OWN_NO = cOMP_OWN_NO;
    }
    public void setCOMP_KIND( String cOMP_KIND ) {
        COMP_KIND = cOMP_KIND;
    }
    public void setCOMP_CLASS( String cOMP_CLASS ) {
        COMP_CLASS = cOMP_CLASS;
    }
    public void setCOMP_TYPE( String cOMP_TYPE ) {
        COMP_TYPE = cOMP_TYPE;
    }
    public void setSESSION( int sESSION ) {
        SESSION = sESSION;
    }
    public void setESTI_NUM( String eSTI_NUM ) {
        ESTI_NUM = eSTI_NUM;
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
    public void setESTI_DATE( String eSTI_DATE ) {
        ESTI_DATE = eSTI_DATE;
    }
    public void setMONEY_UNIT( String mONEY_UNIT ) {
        MONEY_UNIT = mONEY_UNIT;
    }
    public void setEXCHANGE_RATE( double eXCHANGE_RATE ) {
        EXCHANGE_RATE = eXCHANGE_RATE;
    }
    public void setCONFIRM_FLAG( String cONFIRM_FLAG ) {
        CONFIRM_FLAG = cONFIRM_FLAG;
    }
    public void setCONFIRM_DATE( String cONFIRM_DATE ) {
        CONFIRM_DATE = cONFIRM_DATE;
    }
    public void setESTI_AMT( double eSTI_AMT ) {
        ESTI_AMT = eSTI_AMT;
    }
    public void setESTI_CFM_AMT( double eSTI_CFM_AMT ) {
        ESTI_CFM_AMT = eSTI_CFM_AMT;
    }
    public void setESTI_TAX_AMT( double eSTI_TAX_AMT ) {
        ESTI_TAX_AMT = eSTI_TAX_AMT;
    }
    public void setESTI_PRSN( String eSTI_PRSN ) {
        ESTI_PRSN = eSTI_PRSN;
    }
    public void setCUST_PRSN( String cUST_PRSN ) {
        CUST_PRSN = cUST_PRSN;
    }
    public void setESTI_TITLE( String eSTI_TITLE ) {
        ESTI_TITLE = eSTI_TITLE;
    }
    public void setESTI_VALIDTERM( String eSTI_VALIDTERM ) {
        ESTI_VALIDTERM = eSTI_VALIDTERM;
    }
    public void setESTI_PAYCONDI( String eSTI_PAYCONDI ) {
        ESTI_PAYCONDI = eSTI_PAYCONDI;
    }
    public void setESTI_DVRY_DATE( String eSTI_DVRY_DATE ) {
        ESTI_DVRY_DATE = eSTI_DVRY_DATE;
    }
    public void setESTI_DVRY_PLCE( String eSTI_DVRY_PLCE ) {
        ESTI_DVRY_PLCE = eSTI_DVRY_PLCE;
    }
    public void setREMARK( String rEMARK ) {
        REMARK = rEMARK;
    }
    public void setPROFIT_RATE( double pROFIT_RATE ) {
        PROFIT_RATE = pROFIT_RATE;
    }
    public void setESTI_EX_AMT( double eSTI_EX_AMT ) {
        ESTI_EX_AMT = eSTI_EX_AMT;
    }
    public void setESTI_CFM_TAX_AMT( double eSTI_CFM_TAX_AMT ) {
        ESTI_CFM_TAX_AMT = eSTI_CFM_TAX_AMT;
    }
    public void setESTI_CFM_EX_AMT( double eSTI_CFM_EX_AMT ) {
        ESTI_CFM_EX_AMT = eSTI_CFM_EX_AMT;
    }
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
    public String getREPRE_NAME() {
        return REPRE_NAME;
    }
    public String getREPRE_ENG_NAME() {
        return REPRE_ENG_NAME;
    }
    public String getREPRE_NO() {
        return REPRE_NO;
    }
    public String getCOMPANY_NUM() {
        return COMPANY_NUM;
    }
    public String getCOMP_OWN_NO() {
        return COMP_OWN_NO;
    }
    public String getCOMP_KIND() {
        return COMP_KIND;
    }
    public String getCOMP_CLASS() {
        return COMP_CLASS;
    }
    public String getCOMP_TYPE() {
        return COMP_TYPE;
    }
    public int getSESSION() {
        return SESSION;
    }
    public String getESTI_NUM() {
        return ESTI_NUM;
    }
    public String getDIV_CODE() {
        return DIV_CODE;
    }
    public String getCUSTOM_CODE() {
        return CUSTOM_CODE;
    }
    public String getCUSTOM_NAME() {
        return CUSTOM_NAME;
    }
    public String getESTI_DATE() {
        return ESTI_DATE;
    }
    public String getMONEY_UNIT() {
        return MONEY_UNIT;
    }
    public double getEXCHANGE_RATE() {
        return EXCHANGE_RATE;
    }
    public String getCONFIRM_FLAG() {
        return CONFIRM_FLAG;
    }
    public String getCONFIRM_DATE() {
        return CONFIRM_DATE;
    }
    public double getESTI_AMT() {
        return ESTI_AMT;
    }
    public double getESTI_CFM_AMT() {
        return ESTI_CFM_AMT;
    }
    public double getESTI_TAX_AMT() {
        return ESTI_TAX_AMT;
    }
    public String getESTI_PRSN() {
        return ESTI_PRSN;
    }
    public String getCUST_PRSN() {
        return CUST_PRSN;
    }
    public String getESTI_TITLE() {
        return ESTI_TITLE;
    }
    public String getESTI_VALIDTERM() {
        return ESTI_VALIDTERM;
    }
    public String getESTI_PAYCONDI() {
        return ESTI_PAYCONDI;
    }
    public String getESTI_DVRY_DATE() {
        return ESTI_DVRY_DATE;
    }
    public String getESTI_DVRY_PLCE() {
        return ESTI_DVRY_PLCE;
    }
    public String getREMARK() {
        return REMARK;
    }
    public double getPROFIT_RATE() {
        return PROFIT_RATE;
    }
    public double getESTI_EX_AMT() {
        return ESTI_EX_AMT;
    }
    public double getESTI_CFM_TAX_AMT() {
        return ESTI_CFM_TAX_AMT;
    }
    public double getESTI_CFM_EX_AMT() {
        return ESTI_CFM_EX_AMT;
    }   	
}
