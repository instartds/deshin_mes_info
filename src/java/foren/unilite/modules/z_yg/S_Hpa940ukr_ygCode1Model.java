package foren.unilite.modules.z_yg;

import foren.framework.model.BaseVO;

public class S_Hpa940ukr_ygCode1Model extends BaseVO {
    /**
     * 
     */
	//근태코드
    private static final long serialVersionUID = 1L;
    
    String SUB_CODE;
    String CODE_NAME;
    String DUTY_CODE;
	
	public String getSUB_CODE() {
		return SUB_CODE;
	}
	public void setSUB_CODE(String sUB_CODE) {
		SUB_CODE = sUB_CODE;
	}
	public String getCODE_NAME() {
		return CODE_NAME;
	}
	public void setCODE_NAME(String cODE_NAME) {
		CODE_NAME = cODE_NAME;
	}
	
	public String getDUTY_CODE() {
		return DUTY_CODE;
	}
	public void setDUTY_CODE(String dUTY_CODE) {
		DUTY_CODE = dUTY_CODE;
	}
	
	@Override
	public String toString() {
		return "S_Hpa940ukr_ygCode1Model [DUTY_CODE=" + DUTY_CODE + ", CODE_NAME="
				+ CODE_NAME + "]";
	}
	
}
