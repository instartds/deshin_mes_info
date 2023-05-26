package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocCommentModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String DocumentID ;
    private String Seq;
    
    private String Comment;
    
    /* Session Variables */
    private String S_COMP_CODE;
    private String S_USER_ID;
    private String S_LANG_CODE;
    
	public String getDocumentID() {
		return this.DocumentID;
	}
	public void setDocumentID(String DocumentID) {
		this.DocumentID = DocumentID;
	}
	public String getSeq() {
		return this.Seq;
	}
	public void setSeq(String Seq) {
		this.Seq = Seq;
	}
	public String getComment() {
		return this.Comment;
	}
	public void setComment(String Comment) {
		this.Comment = Comment;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String S_USER_ID) {
		this.S_USER_ID = S_USER_ID;
	}
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String S_COMP_CODE) {
		this.S_COMP_CODE = S_COMP_CODE;
	}
	public String getS_LANG_CODE() {
		return S_LANG_CODE;
	}
	public void setS_LANG_CODE(String S_LANG_CODE) {
		this.S_LANG_CODE = S_LANG_CODE;
	}
	
}
