package foren.unilite.modules.z_mit;

import foren.framework.model.BaseVO;
import foren.framework.utils.ObjUtils;

public class S_bpr120ukrv_mitModel extends BaseVO {
	private static final long serialVersionUID = 1L;
	
	/* Primary Key */
	private String  COMP_CODE   ;
	private String  DIV_CODE    ;
	private String  ITEM_CODE   ;

	private String  SPEC     ;
	private String  REMARK1     ;
	private String  REMARK2     ;
	private String  REMARK3     ;
	
	
	private String  S_COMP_CODE ;
	private String  S_USER_ID   ;
	
	
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
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
	public String getREMARK3() {
		return REMARK3;
	}
	public void setREMARK3(String rEMARK3) {
		REMARK3 = rEMARK3;
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
	public String getSPEC() {
		return SPEC;
	}
	public void setSPEC(String sPEC) {
		SPEC = sPEC;
	}
	
	
}