package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocFormModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String FormID ;
    
    private String CompanyID;
    private String CategoryID;
    private String Subject;
    private String Contents;
    private String StoreYear;
    private String DocuType;
    private String CabinetID;
    private String SecureGrade;
    private String OrgType;
    
    /* Session Variables */
    private String S_COMP_CODE;
    private String S_USER_ID;
    
    private String ActionType;
	
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String S_COMP_CODE) {
		this.S_COMP_CODE = S_COMP_CODE;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String S_USER_ID) {
		this.S_USER_ID = S_USER_ID;
	}
	public String getFormID() {
		return FormID;
	}
	public void setFormID(String formID) {
		FormID = formID;
	}
	public String getCompanyID() {
		return CompanyID;
	}
	public void setCompanyID(String companyID) {
		CompanyID = companyID;
	}
	public String getCategoryID() {
		return CategoryID;
	}
	public void setCategoryID(String categoryID) {
		CategoryID = categoryID;
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
	public String getStoreYear() {
		return StoreYear;
	}
	public void setStoreYear(String storeYear) {
		StoreYear = storeYear;
	}
	public String getDocuType() {
		return DocuType;
	}
	public void setDocuType(String docuType) {
		DocuType = docuType;
	}
	public String getCabinetID() {
		return CabinetID;
	}
	public void setCabinetID(String cabinetID) {
		CabinetID = cabinetID;
	}
	public String getSecureGrade() {
		return SecureGrade;
	}
	public void setSecureGrade(String secureGrade) {
		SecureGrade = secureGrade;
	}
	public String getOrgType() {
		return OrgType;
	}
	public void setOrgType(String orgType) {
		OrgType = orgType;
	}
	public String getActionType() {
		return ActionType;
	}
	public void setActionType(String actionType) {
		ActionType = actionType;
	}
    
}
