package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocPathLineModel extends BaseVO {
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
    private String LineType;
    private String Seq;
    private String SignType;
    private String SignUserID;
    
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

	public String getSignType() {
		return SignType;
	}

	public void setSignType(String signType) {
		SignType = signType;
	}

	public String getSignUserID() {
		return SignUserID;
	}

	public void setSignUserID(String signUserID) {
		SignUserID = signUserID;
	}
}
