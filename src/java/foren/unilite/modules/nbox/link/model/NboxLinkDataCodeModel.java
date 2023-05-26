package foren.unilite.modules.nbox.link.model;

import foren.framework.model.BaseVO;

public class NboxLinkDataCodeModel extends BaseVO {
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
    private String CompanyID ;
    private String DataID ;
    
    /* General Column */
    private String DataCode;
    private String DataName;
    private String DataType;
    private String InputType;
    private String ReferenceCode;
    private String ControlWidth;
    private String SortSeq;
    private String Remark;
    
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
	public String getCompanyID() {
		return CompanyID;
	}
	public void setCompanyID(String companyID) {
		CompanyID = companyID;
	}
	public String getDataID() {
		return DataID;
	}
	public void setDataID(String dataID) {
		DataID = dataID;
	}
	public String getDataCode() {
		return DataCode;
	}
	public void setDataCode(String dataCode) {
		DataCode = dataCode;
	}
	public String getDataName() {
		return DataName;
	}
	public void setDataName(String dataName) {
		DataName = dataName;
	}
	public String getDataType() {
		return DataType;
	}
	public void setDataType(String dataType) {
		DataType = dataType;
	}
	public String getInputType() {
		return InputType;
	}
	public void setInputType(String inputType) {
		InputType = inputType;
	}
	public String getReferenceCode() {
		return ReferenceCode;
	}
	public void setReferenceCode(String referenceCode) {
		ReferenceCode = referenceCode;
	}
	public String getControlWidth() {
		return ControlWidth;
	}
	public void setControlWidth(String controlWidth) {
		ControlWidth = controlWidth;
	}
	public String getSortSeq() {
		return SortSeq;
	}
	public void setSortSeq(String sortSeq) {
		SortSeq = sortSeq;
	}
	public String getRemark() {
		return Remark;
	}
	public void setRemark(String remark) {
		Remark = remark;
	}
}
