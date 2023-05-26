package foren.unilite.modules.z_kd;

import foren.framework.model.BaseVO;

public class S_tex900ukrv_kdModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String  ORDER_NUM;
    private String  COMP_CODE;
    private String  DIV_CODE;

    private String RETURN_DATE;
    private String RETURN_NO;
    private String HS_NO;
    private String RETURN_RATE;
    private String RETURN_AMT;
    private String REMARK;
	   /* Session Variables */
    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
  
    
  
  
	
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}

	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	
	public String getS_USER_ID() {
		return S_USER_ID;
	}

	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}

	public String getS_AUTHORITY_LEVEL() {
		return S_AUTHORITY_LEVEL;
	}

	public void setS_AUTHORITY_LEVEL(String s_AUTHORITY_LEVEL) {
		S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
	}

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getORDER_NUM() {
        return ORDER_NUM;
    }

    public String getCOMP_CODE() {
        return COMP_CODE;
    }

    public String getDIV_CODE() {
        return DIV_CODE;
    }

    public String getRETURN_DATE() {
        return RETURN_DATE;
    }

    public String getRETURN_NO() {
        return RETURN_NO;
    }

    public String getHS_NO() {
        return HS_NO;
    }

    public String getRETURN_RATE() {
        return RETURN_RATE;
    }

    public String getRETURN_AMT() {
        return RETURN_AMT;
    }

    public String getREMARK() {
        return REMARK;
    }

    public void setORDER_NUM( String oRDER_NUM ) {
        ORDER_NUM = oRDER_NUM;
    }

    public void setCOMP_CODE( String cOMP_CODE ) {
        COMP_CODE = cOMP_CODE;
    }

    public void setDIV_CODE( String dIV_CODE ) {
        DIV_CODE = dIV_CODE;
    }

    public void setRETURN_DATE( String rETURN_DATE ) {
        RETURN_DATE = rETURN_DATE;
    }

    public void setRETURN_NO( String rETURN_NO ) {
        RETURN_NO = rETURN_NO;
    }

    public void setHS_NO( String hS_NO ) {
        HS_NO = hS_NO;
    }

    public void setRETURN_RATE( String rETURN_RATE ) {
        RETURN_RATE = rETURN_RATE;
    }

    public void setRETURN_AMT( String rETURN_AMT ) {
        RETURN_AMT = rETURN_AMT;
    }

    public void setREMARK( String rEMARK ) {
        REMARK = rEMARK;
    }
	
	
}
