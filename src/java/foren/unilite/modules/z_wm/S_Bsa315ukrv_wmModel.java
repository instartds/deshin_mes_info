package foren.unilite.modules.z_wm;

import foren.framework.model.BaseVO;

public class S_Bsa315ukrv_wmModel extends BaseVO {
	private static final long serialVersionUID = 1L;

	/* Primary Key */
	private String COMP_CODE;
	private String USER_ID;
	private String USER_NAME;
	private String USER_SIGN;

	private String DOC_NO;
	private String FILE_NO;
	private String ADD_FID;
	private String DEL_FID;

	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getUSER_ID() {
		return USER_ID;
	}
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	public String getUSER_NAME() {
		return USER_NAME;
	}
	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}
	public String getUSER_SIGN() {
		return USER_SIGN;
	}
	public void setUSER_SIGN(String uSER_SIGN) {
		USER_SIGN = uSER_SIGN;
	}
	public String getDOC_NO() {
		return DOC_NO;
	}
	public void setDOC_NO(String dOC_NO) {
		DOC_NO = dOC_NO;
	}
	public String getFILE_NO() {
		return FILE_NO;
	}
	public void setFILE_NO(String fILE_NO) {
		FILE_NO = fILE_NO;
	}
	public String getADD_FID() {
		return ADD_FID;
	}
	public void setADD_FID(String aDD_FID) {
		ADD_FID = aDD_FID;
	}
	public String getDEL_FID() {
		return DEL_FID;
	}
	public void setDEL_FID(String dEL_FID) {
		DEL_FID = dEL_FID;
	}
}