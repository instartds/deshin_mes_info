package foren.unilite.modules.base.bor;

import foren.framework.model.BaseVO;

public class Bor100ukrvModel extends BaseVO {
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
    private String FN_DATE;       
    private String TO_DATE;       
    private String ESTABLISH_DATE;
    private double CAPITAL;       
    private String ZIP_CODE;      
    private String ADDR;          
    private String ENG_ADDR;      
    private String TELEPHON;      
    private String FAX_NUM;       
    private String HTTP_ADDR;     
    private String EMAIL;         
    private String CURRENCY;      
    private String NATION_CODE;   
    private String DOMAIN;        
    private String PL_BASE;       
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
	public String getCOMP_NAME() {
		return COMP_NAME;
	}
	public void setCOMP_NAME(String cOMP_NAME) {
		COMP_NAME = cOMP_NAME;
	}
	public String getCOMP_ENG_NAME() {
		return COMP_ENG_NAME;
	}
	public void setCOMP_ENG_NAME(String cOMP_ENG_NAME) {
		COMP_ENG_NAME = cOMP_ENG_NAME;
	}
	public String getREPRE_NAME() {
		return REPRE_NAME;
	}
	public void setREPRE_NAME(String rEPRE_NAME) {
		REPRE_NAME = rEPRE_NAME;
	}
	public String getREPRE_ENG_NAME() {
		return REPRE_ENG_NAME;
	}
	public void setREPRE_ENG_NAME(String rEPRE_ENG_NAME) {
		REPRE_ENG_NAME = rEPRE_ENG_NAME;
	}
	public String getREPRE_NO() {
		return REPRE_NO;
	}
	public void setREPRE_NO(String rEPRE_NO) {
		REPRE_NO = rEPRE_NO;
	}
	public String getCOMPANY_NUM() {
		return COMPANY_NUM;
	}
	public void setCOMPANY_NUM(String cOMPANY_NUM) {
		COMPANY_NUM = cOMPANY_NUM;
	}
	public String getCOMP_OWN_NO() {
		return COMP_OWN_NO;
	}
	public void setCOMP_OWN_NO(String cOMP_OWN_NO) {
		COMP_OWN_NO = cOMP_OWN_NO;
	}
	public String getCOMP_KIND() {
		return COMP_KIND;
	}
	public void setCOMP_KIND(String cOMP_KIND) {
		COMP_KIND = cOMP_KIND;
	}
	public String getCOMP_CLASS() {
		return COMP_CLASS;
	}
	public void setCOMP_CLASS(String cOMP_CLASS) {
		COMP_CLASS = cOMP_CLASS;
	}
	public String getCOMP_TYPE() {
		return COMP_TYPE;
	}
	public void setCOMP_TYPE(String cOMP_TYPE) {
		COMP_TYPE = cOMP_TYPE;
	}
	public int getSESSION() {
		return SESSION;
	}
	public void setSESSION(int sESSION) {
		SESSION = sESSION;
	}
	public String getFN_DATE() {
		return FN_DATE;
	}
	public void setFN_DATE(String fN_DATE) {
		FN_DATE = fN_DATE;
	}
	public String getTO_DATE() {
		return TO_DATE;
	}
	public void setTO_DATE(String tO_DATE) {
		TO_DATE = tO_DATE;
	}
	public String getESTABLISH_DATE() {
		return ESTABLISH_DATE;
	}
	public void setESTABLISH_DATE(String eSTABLISH_DATE) {
		ESTABLISH_DATE = eSTABLISH_DATE;
	}
	public double getCAPITAL() {
		return CAPITAL;
	}
	public void setCAPITAL(double cAPITAL) {
		CAPITAL = cAPITAL;
	}
	public String getZIP_CODE() {
		return ZIP_CODE;
	}
	public void setZIP_CODE(String zIP_CODE) {
		ZIP_CODE = zIP_CODE;
	}
	public String getADDR() {
		return ADDR;
	}
	public void setADDR(String aDDR) {
		ADDR = aDDR;
	}
	public String getENG_ADDR() {
		return ENG_ADDR;
	}
	public void setENG_ADDR(String eNG_ADDR) {
		ENG_ADDR = eNG_ADDR;
	}
	public String getTELEPHON() {
		return TELEPHON;
	}
	public void setTELEPHON(String tELEPHON) {
		TELEPHON = tELEPHON;
	}
	public String getFAX_NUM() {
		return FAX_NUM;
	}
	public void setFAX_NUM(String fAX_NUM) {
		FAX_NUM = fAX_NUM;
	}
	public String getHTTP_ADDR() {
		return HTTP_ADDR;
	}
	public void setHTTP_ADDR(String hTTP_ADDR) {
		HTTP_ADDR = hTTP_ADDR;
	}
	public String getEMAIL() {
		return EMAIL;
	}
	public void setEMAIL(String eMAIL) {
		EMAIL = eMAIL;
	}
	public String getCURRENCY() {
		return CURRENCY;
	}
	public void setCURRENCY(String cURRENCY) {
		CURRENCY = cURRENCY;
	}
	public String getNATION_CODE() {
		return NATION_CODE;
	}
	public void setNATION_CODE(String nATION_CODE) {
		NATION_CODE = nATION_CODE;
	}
	public String getDOMAIN() {
		return DOMAIN;
	}
	public void setDOMAIN(String dOMAIN) {
		DOMAIN = dOMAIN;
	}
	public String getPL_BASE() {
		return PL_BASE;
	}
	public void setPL_BASE(String pL_BASE) {
		PL_BASE = pL_BASE;
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
