package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocPathRcvUserModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Session Variables */
    private String S_COMP_CODE;
    private String S_USER_ID;
    private String S_LANG_CODE;
    
    /* ActionType Variables */
    private String ActionType;
    
    /* Primary Key */
    private String PathID ;
    
    /* General Column */
    private String RcvType;
    private String DeptType;
    private String RcvUserID;
    private String RcvUserDeptID;
    
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

	public String getActionType() {
		return ActionType;
	}

	public void setActionType(String actionType) {
		ActionType = actionType;
	}

	public String getPathID() {
		return PathID;
	}

	public void setPathID(String pathID) {
		PathID = pathID;
	}

	public String getRcvType() {
		return RcvType;
	}

	public void setRcvType(String rcvType) {
		RcvType = rcvType;
	}

	public String getDeptType() {
		return DeptType;
	}

	public void setDeptType(String deptType) {
		DeptType = deptType;
	}

	public String getRcvUserID() {
		return RcvUserID;
	}

	public void setRcvUserID(String rcvUserID) {
		RcvUserID = rcvUserID;
	}

	public String getRcvUserDeptID() {
		return RcvUserDeptID;
	}

	public void setRcvUserDeptID(String rcvUserDeptID) {
		RcvUserDeptID = rcvUserDeptID;
	}
}
