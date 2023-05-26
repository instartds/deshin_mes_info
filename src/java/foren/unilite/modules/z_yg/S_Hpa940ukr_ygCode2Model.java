package foren.unilite.modules.z_yg;

import foren.framework.model.BaseVO;

public class S_Hpa940ukr_ygCode2Model extends BaseVO {
    /**
     * 
     */
	//근태코드
    private static final long serialVersionUID = 1L;
    
    String WAGES_CODE;
    String WAGES_NAME;
    String AMT;
	public String getWAGES_CODE() {
		return WAGES_CODE;
	}
	public void setWAGES_CODE(String wAGES_CODE) {
		WAGES_CODE = wAGES_CODE;
	}
	public String getWAGES_NAME() {
		return WAGES_NAME;
	}
	public void setWAGES_NAME(String wAGES_NAME) {
		WAGES_NAME = wAGES_NAME;
	}
	public String getAMT() {
		return AMT;
	}
	public void setAMT(String aMT) {
		AMT = aMT;
	}
	@Override
	public String toString() {
		return "S_Hpa940ukr_ygCode2Model [WAGES_CODE=" + WAGES_CODE
				+ ", WAGES_NAME=" + WAGES_NAME + ", AMT=" + AMT + "]";
	}
    
    
	
}
