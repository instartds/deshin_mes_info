package foren.unilite.modules.z_yg;

import foren.framework.model.BaseVO;

public class S_Hpa940ukr_ygCode3Model extends BaseVO {
    /**
     * 
     */
	//근태코드
    private static final long serialVersionUID = 1L;
    
    String SUB_CODE;
    String CODE_NAME;
    String AMT;
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
	public String getAMT() {
		return AMT;
	}
	public void setAMT(String aMT) {
		AMT = aMT;
	}
	@Override
	public String toString() {
		return "S_Hpa940ukr_ygCode3Model [SUB_CODE=" + SUB_CODE + ", CODE_NAME="
				+ CODE_NAME + ", AMT=" + AMT + "]";
	}
	
    
    
	
}
