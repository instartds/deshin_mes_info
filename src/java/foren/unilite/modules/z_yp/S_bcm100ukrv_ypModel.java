package foren.unilite.modules.z_yp;

import foren.framework.model.BaseVO;

public class S_bcm100ukrv_ypModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String S_COMP_CODE;
    private String CUSTOM_CODE;
    private String TYPE;
    private String CERT_NO;
    private String IMAGE_DIR;
    private String S_USER_ID;
    private String CHANGE_YN;				//이미지 REFRESH하기 위한 값

    
	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}
	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}
	public String getTYPE() {
		return TYPE;
	}
	public void setTYPE(String tYPE) {
		TYPE = tYPE;
	}
	public String getCERT_NO() {
		return CERT_NO;
	}
	public void setCERT_NO(String cERT_NO) {
		CERT_NO = cERT_NO;
	}
	public String getIMAGE_DIR() {
		return IMAGE_DIR;
	}
	public void setIMAGE_DIR(String iMAGE_DIR) {
		IMAGE_DIR = iMAGE_DIR;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getCHANGE_YN() {
		return CHANGE_YN;
	}
	public void setCHANGE_YN(String cHANGE_YN) {
		CHANGE_YN = cHANGE_YN;
	}
    public String getS_COMP_CODE() {
        return S_COMP_CODE;
    }
    public void setS_COMP_CODE(String s_COMP_CODE) {
        S_COMP_CODE = s_COMP_CODE;
    }
}
