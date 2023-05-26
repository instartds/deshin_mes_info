package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocBasisModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String DocumentID ;
    private String Seq;
    
    private String RefDocumentID;
    private String RefDocumentNo;
    private String ReturnDocFlag;
    
    /* Session Variables */
    private String S_COMP_CODE;
    private String S_USER_ID;
    private String S_LANG_CODE;
    
	public String getDocumentID() {
		return DocumentID;
	}

	public void setDocumentID(String documentID) {
		DocumentID = documentID;
	}
	
	public String getSeq() {
		return Seq;
	}

	public void setSeq(String seq) {
		Seq = seq;
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

	public String getS_LANG_CODE() {
		return S_LANG_CODE;
	}

	public void setS_LANG_CODE(String s_LANG_CODE) {
		S_LANG_CODE = s_LANG_CODE;
	}

	public String getRefDocumentID() {
		return RefDocumentID;
	}

	public void setRefDocumentID(String refDocumentID) {
		RefDocumentID = refDocumentID;
	}

	public String getRefDocumentNo() {
		return RefDocumentNo;
	}

	public void setRefDocumentNo(String refDocumentNo) {
		RefDocumentNo = refDocumentNo;
	}

	public String getReturnDocFlag() {
		return ReturnDocFlag;
	}

	public void setReturnDocFlag(String returnDocFlag) {
		ReturnDocFlag = returnDocFlag;
	}

}
