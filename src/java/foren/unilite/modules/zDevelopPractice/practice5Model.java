package foren.unilite.modules.zDevelopPractice;

import foren.framework.model.BaseVO;

public class practice5Model extends BaseVO {
	private static final long serialVersionUID = 1L;
	/* Primary Key */
	private String S_COMP_CODE;
	private String TREE_CODE;
	private String TREE_NAME;
	
	
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
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
	
	
	
}