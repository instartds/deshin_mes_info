package foren.unilite.modules.accnt.afn;

import foren.framework.model.BaseVO;

public class Afn210ukrModel extends BaseVO {
	private static final long serialVersionUID = 1L;
	
	private String  S_COMP_CODE;
	private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    
    private String txtInDt;
    private String txtTag;
    private String txtBank;
    
	private String txtFrNo1;
    private String txtFrNo2;
    private String txtToNo2;
    
	private String NOTE_NUM;
    
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public String getS_AUTHORITY_LEVEL() {
		return S_AUTHORITY_LEVEL;
	}
	public void setS_AUTHORITY_LEVEL(String s_AUTHORITY_LEVEL) {
		S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getTxtInDt() {
		return txtInDt;
	}
	public void setTxtInDt(String txtInDt) {
		this.txtInDt = txtInDt;
	}
	public String getTxtTag() {
		return txtTag;
	}
	public void setTxtTag(String txtTag) {
		this.txtTag = txtTag;
	}
	 public String getTxtBank() {
		return txtBank;
	}
	public void setTxtBank(String txtBank) {
		this.txtBank = txtBank;
	}
	public String getTxtFrNo1() {
		return txtFrNo1;
	}
	public void setTxtFrNo1(String txtFrNo1) {
		this.txtFrNo1 = txtFrNo1;
	}
	public String getTxtFrNo2() {
		return txtFrNo2;
	}
	public void setTxtFrNo2(String txtFrNo2) {
		this.txtFrNo2 = txtFrNo2;
	}
	public String getTxtToNo2() {
		return txtToNo2;
	}
	public void setTxtToNo2(String txtToNo2) {
		this.txtToNo2 = txtToNo2;
	}
	public String getNOTE_NUM() {
		return NOTE_NUM;
	}
	public void setNOTE_NUM(String nOTE_NUM) {
		NOTE_NUM = nOTE_NUM;
	}
	
    
    
    
}
