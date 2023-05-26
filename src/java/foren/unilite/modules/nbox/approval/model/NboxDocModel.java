package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String DocumentID ;
    
    private String CompanyID;
    private String DraftUserID;
    private String DraftUserName;
    private String DraftDeptName;
    private String DraftUserPos;
    private String Subject;
    private String Contents;
    private String EditorContents;
    private String InterfaceKey;
    private String Gubun;
    private String MultiType;
    private String Status;
    private String FormID;
    private String SecureGrade;
    private String CabinetID;
    private String WorkCode;
    private String HolidayCode;
    
    /* Session Variables */
    private String S_COMP_CODE;
    private String S_DIV_CODE;
    private String S_USER_ID;
    private String S_LANG_CODE;
    
    private String ActionType;
    private String ExecType;
    
    /* KOCIS */
    private String InnerApprovalFlag;
    private String InputRcvUser;
    private String InputRcvFlag;
    private String InputRefUser;
    private String InputRefFlag;
    private String OpenFlag;
    
	public String getDocumentID() {
		return DocumentID;
	}

	public void setDocumentID(String documentID) {
		DocumentID = documentID;
	}

	public String getCompanyID() {
		return CompanyID;
	}

	public void setCompanyID(String companyID) {
		CompanyID = companyID;
	}

	public String getDraftUserID() {
		return DraftUserID;
	}

	public void setDraftUserID(String draftUserID) {
		DraftUserID = draftUserID;
	}

	public String getDraftUserName() {
		return DraftUserName;
	}

	public void setDraftUserName(String draftUserName) {
		DraftUserName = draftUserName;
	}

	public String getDraftDeptName() {
		return DraftDeptName;
	}

	public void setDraftDeptName(String draftDeptName) {
		DraftDeptName = draftDeptName;
	}

	public String getDraftUserPos() {
		return DraftUserPos;
	}

	public void setDraftUserPos(String draftUserPos) {
		DraftUserPos = draftUserPos;
	}

	public String getSubject() {
		return Subject;
	}

	public void setSubject(String subject) {
		Subject = subject;
	}

	public String getContents() {
		return Contents;
	}

	public void setContents(String contents) {
		Contents = contents;
	}
	
	public String getEditorContents() {
		return EditorContents;
	}

	public void setEditorContents(String editorContents) {
		EditorContents = editorContents;
	}
	
	public String getInterfaceKey() {
		return InterfaceKey;
	}

	public void setInterfaceKey(String interfaceKey) {
		InterfaceKey = interfaceKey;
	}

	public String getGubun() {
		return Gubun;
	}

	public void setGubun(String gubun) {
		Gubun = gubun;
	}	
	
	public String getFormID() {
		return FormID;
	}

	public void setFormID(String formID) {
		FormID = formID;
	}

	public String getWorkCode() {
		return WorkCode;
	}

	public void setWorkCode(String workCode) {
		WorkCode = workCode;
	}

	public String getHolidayCode() {
		return HolidayCode;
	}

	public void setHolidayCode(String holidayCode) {
		HolidayCode = holidayCode;
	}
	
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}

	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	
	public String getS_DIV_CODE() {
		return S_DIV_CODE;
	}

	public void setS_DIV_CODE(String s_DIV_CODE) {
		S_DIV_CODE = s_DIV_CODE;
	}

	public String getS_USER_ID() {
		return S_USER_ID;
	}

	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}

	public String getMultiType() {
		return MultiType;
	}

	public void setMultiType(String multiType) {
		MultiType = multiType;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
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

	public String getExecType() {
		return ExecType;
	}

	public void setExecType(String execType) {
		ExecType = execType;
	}

	public String getSecureGrade() {
		return SecureGrade;
	}

	public void setSecureGrade(String secureGrade) {
		SecureGrade = secureGrade;
	}

	public String getCabinetID() {
		return CabinetID;
	}

	public void setCabinetID(String cabinetID) {
		CabinetID = cabinetID;
	}
	
	public String getInnerApprovalFlag() {
		return InnerApprovalFlag;
	}

	public void setInnerApprovalFlag(String innerApprovalFlag) {
		InnerApprovalFlag = innerApprovalFlag;
	}
    
	public String getInputRcvUser() {
		return InputRcvUser;
	}

	public void setInputRcvUser(String inputRcvUser) {
		InputRcvUser = inputRcvUser;
	}
	
	public String getInputRcvFlag() {
		return InputRcvFlag;
	}

	public void setInputRcvFlag(String inputRcvFlag) {
		InputRcvFlag = inputRcvFlag;
	}
	
	public String getInputRefUser() {
		return InputRefUser;
	}

	public void setInputRefUser(String inputRefUser) {
		InputRefUser = inputRefUser;
	}
	
	public String getInputRefFlag() {
		return InputRefFlag;
	}

	public void setInputRefFlag(String inputRefFlag) {
		InputRefFlag = inputRefFlag;
	}
	
	public String getOpenFlag() {
		return OpenFlag;
	}

	public void setOpenFlag(String openFlag) {
		OpenFlag = openFlag;
	}

}
