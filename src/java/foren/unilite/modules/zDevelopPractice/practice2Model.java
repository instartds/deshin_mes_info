package foren.unilite.modules.zDevelopPractice;

import foren.framework.model.BaseVO;

public class practice2Model extends BaseVO {
	private static final long serialVersionUID = 1L;
	/* Primary Key */
	private String S_COMP_CODE;
	private String S_USER_ID;
	private String TYPE_LEVEL;
	private String TREE_CODE;
	private String TREE_NAME;
	private String GROUP_CD;
	private String USE_YN;

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
	public String getTYPE_LEVEL() {
		return TYPE_LEVEL;
	}
	public void setTYPE_LEVEL(String tYPE_LEVEL) {
		TYPE_LEVEL = tYPE_LEVEL;
	}
	public String getTREE_CODE() {
		return TREE_CODE;
	}
	public void setTREE_CODE(String tREE_CODE) {
		TREE_CODE = tREE_CODE;
	}
	public String getTREE_NAME() {
		return TREE_NAME;
	}
	public void setTREE_NAME(String tREE_NAME) {
		TREE_NAME = tREE_NAME;
	}
	public String getGROUP_CD() {
		return GROUP_CD;
	}
	public void setGROUP_CD(String gROUP_CD) {
		GROUP_CD = gROUP_CD;
	}
	public String getUSE_YN() {
		return USE_YN;
	}
	public void setUSE_YN(String uSE_YN) {
		USE_YN = uSE_YN;
	}
}