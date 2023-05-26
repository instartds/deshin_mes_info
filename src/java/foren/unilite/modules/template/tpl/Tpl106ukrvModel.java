package foren.unilite.modules.template.tpl;

import foren.framework.model.BaseVO;

public class Tpl106ukrvModel extends BaseVO {
    /**
     * 폼 전송 참조 model
     */
   
    /* Primary Key */
    private String  DOC_NO;   
    
    private String	FILE_NO;
    private int		DOC_SEQ;
    private String	DOC_TYPE;
    private String	OPINION_TYPE;
    private String	DEL_FID;
    private String	S_COMP_CODE;
    
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
	public int getDOC_SEQ() {
		return DOC_SEQ;
	}
	public void setDOC_SEQ(int dOC_SEQ) {
		DOC_SEQ = dOC_SEQ;
	}
	public String getDOC_TYPE() {
		return DOC_TYPE;
	}
	public void setDOC_TYPE(String dOC_TYPE) {
		DOC_TYPE = dOC_TYPE;
	}
	public String getOPINION_TYPE() {
		return OPINION_TYPE;
	}
	public void setOPINION_TYPE(String oPINION_TYPE) {
		OPINION_TYPE = oPINION_TYPE;
	}
	public String getDEL_FID() {
		return DEL_FID;
	}
	public void setDEL_FID(String dEL_FID) {
		DEL_FID = dEL_FID;
	}
	public String getADD_FID() {
		return ADD_FID;
	}
	public void setADD_FID(String aDD_FID) {
		ADD_FID = aDD_FID;
	}
	private String	ADD_FID;

	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}

	
	
}
