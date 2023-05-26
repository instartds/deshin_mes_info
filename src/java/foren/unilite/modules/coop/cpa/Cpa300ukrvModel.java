package foren.unilite.modules.coop.cpa;

import foren.framework.model.BaseVO;

public class Cpa300ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String COMP_CODE;  
    
    private String COOP_YYYY;     
    private String COOP_SEQ; 
    
    private String PL_BASE;       
	   /* Session Variables */
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getCOOP_YYYY() {
		return COOP_YYYY;
	}
	public void setCOOP_YYYY(String cOOP_YYYY) {
		COOP_YYYY = cOOP_YYYY;
	}
	public String getCOOP_SEQ() {
		return COOP_SEQ;
	}
	public void setCOOP_SEQ(String cOOP_SEQ) {
		COOP_SEQ = cOOP_SEQ;
	}
	public String getPL_BASE() {
		return PL_BASE;
	}
	public void setPL_BASE(String pL_BASE) {
		PL_BASE = pL_BASE;
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
    
}
