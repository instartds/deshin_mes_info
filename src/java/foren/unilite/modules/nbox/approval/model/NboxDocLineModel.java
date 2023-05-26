package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocLineModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String DocumentID ;
    
    private String LineType;
    private String Seq;
    private String SignType;
    private String SignTypeName;
    private String SignUserID;
    private String SignUserName;
    private String SignUserDeptName;
    private String SignUserPosName;
    private String SignDate;
    private String SignImgUrl;
    private String SignFlag;
    private String LastFlag;
    private String FormName;
    
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

	public String getLineType() {
		return LineType;
	}

	public void setLineType(String lineType) {
		LineType = lineType;
	}

	public String getSeq() {
		return Seq;
	}

	public void setSeq(String seq) {
		Seq = seq;
	}

	public String getSignUserID() {
		return SignUserID;
	}

	public void setSignUserID(String signUserID) {
		SignUserID = signUserID;
	}

	public String getSignUserName() {
		return SignUserName;
	}

	public void setSignUserName(String signUserName) {
		SignUserName = signUserName;
	}

	public String getSignUserDeptName() {
		return SignUserDeptName;
	}

	public void setSignUserDeptName(String signUserDeptName) {
		SignUserDeptName = signUserDeptName;
	}

	public String getSignUserPosName() {
		return SignUserPosName;
	}

	public void setSignUserPosName(String signUserPosName) {
		SignUserPosName = signUserPosName;
	}

	public String getLastFlag() {
		return LastFlag;
	}

	public void setLastFlag(String lastFlag) {
		LastFlag = lastFlag;
	}

	public String getSignType() {
		return SignType;
	}

	public void setSignType(String signType) {
		SignType = signType;
	}

	public String getSignDate() {
		return SignDate;
	}

	public void setSignDate(String signDate) {
		SignDate = signDate;
	}

	public String getSignFlag() {
		return SignFlag;
	}

	public void setSignFlag(String signFlag) {
		SignFlag = signFlag;
	}

	public String getSignImgUrl() {
		return SignImgUrl;
	}

	public void setSignImgUrl(String signImgUrl) {
		SignImgUrl = signImgUrl;
	}

	public String getFormName() {
		return FormName;
	}

	public void setFormName(String formName) {
		FormName = formName;
	}

	public String getSignTypeName() {
		return SignTypeName;
	}

	public void setSignTypeName(String signTypeName) {
		SignTypeName = signTypeName;
	}
    
}
