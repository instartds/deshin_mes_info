package foren.unilite.modules.accnt.agc;

import foren.framework.model.BaseVO;

public class Agc135skrModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
 
    private String FR_DATE;
    private String TO_DATE;
    private String REMARK1;
    private String REMARK2;
    
    private String  S_COMP_CODE;
    private String  S_USER_ID;
	public String getFR_DATE() {
		return FR_DATE;
	}
	public void setFR_DATE(String fR_DATE) {
		FR_DATE = fR_DATE;
	}
	public String getTO_DATE() {
		return TO_DATE;
	}
	public void setTO_DATE(String tO_DATE) {
		TO_DATE = tO_DATE;
	}
	public String getREMARK1() {
		return REMARK1;
	}
	public void setREMARK1(String rEMARK1) {
		REMARK1 = rEMARK1;
	}
	public String getREMARK2() {
		return REMARK2;
	}
	public void setREMARK2(String rEMARK2) {
		REMARK2 = rEMARK2;
	}
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
}
