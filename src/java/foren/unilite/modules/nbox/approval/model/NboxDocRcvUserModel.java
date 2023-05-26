package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocRcvUserModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String DocumentID ;
    private String RcvType;
    private String DeptType;
    private String RcvUserID;
    
    private String ReadDate;
    private String RcvUserName;
    private String RcvDeptID;
    private String RcvDeptName;
    private String RcvUserPos;
    private String CurDeptName;
    
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

	public String getRcvType() {
		return RcvType;
	}

	public void setRcvType(String rcvType) {
		RcvType = rcvType;
	}

	public String getRcvUserID() {
		return RcvUserID;
	}

	public void setRcvUserID(String rcvUserID) {
		RcvUserID = rcvUserID;
	}

	public String getDeptType() {
		return DeptType;
	}

	public void setDeptType(String deptType) {
		DeptType = deptType;
	}

	public String getReadDate() {
		return ReadDate;
	}

	public void setReadDate(String readDate) {
		ReadDate = readDate;
	}

	public String getRcvUserName() {
		return RcvUserName;
	}

	public void setRcvUserName(String rcvUserName) {
		RcvUserName = rcvUserName;
	}

	public String getRcvDeptID() {
		return RcvDeptID;
	}

	public void setRcvDeptID(String rcvDeptID) {
		RcvDeptID = rcvDeptID;
	}

	public String getRcvDeptName() {
		return RcvDeptName;
	}

	public void setRcvDeptName(String rcvDeptName) {
		RcvDeptName = rcvDeptName;
	}

	public String getRcvUserPos() {
		return RcvUserPos;
	}

	public void setRcvUserPos(String rcvUserPos) {
		RcvUserPos = rcvUserPos;
	}

	public String getCurDeptName() {
		return CurDeptName;
	}

	public void setCurDeptName(String curDeptName) {
		CurDeptName = curDeptName;
	}

	
    
}
