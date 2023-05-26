package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocUserConfigModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Session Variables */
    private String S_COMP_CODE;
    private String S_USER_ID;
    private String S_LANG_CODE;
    
    /* Primary Key */
    
    /* General Column */
    private String AlarmType;
    private Boolean SignAlarmFlag;
    private Boolean CloseAlarmFlag;
    private Boolean LeaveFlag;
    
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
	public String getAlarmType() {
		return AlarmType;
	}
	public void setAlarmType(String alarmType) {
		AlarmType = alarmType;
	}
	public Boolean getSignAlarmFlag() {
		return SignAlarmFlag;
	}
	public void setSignAlarmFlag(Boolean signAlarmFlag) {
		SignAlarmFlag = signAlarmFlag;
	}
	public Boolean getCloseAlarmFlag() {
		return CloseAlarmFlag;
	}
	public void setCloseAlarmFlag(Boolean closeAlarmFlag) {
		CloseAlarmFlag = closeAlarmFlag;
	}
	public Boolean getLeaveFlag() {
		return LeaveFlag;
	}
	public void setLeaveFlag(Boolean leaveFlag) {
		LeaveFlag = leaveFlag;
	}
    
}
