package foren.unilite.modules.nbox.approval.model;

import foren.framework.model.BaseVO;

public class NboxDocExpenseDetailModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String DocumentID;
    private int    Seq;
    
    /* General Key */
    private String ExpenseDate;
    private String ExpenseReason;
    private String AcctName;
    private String Supply;
    private String Vat;
    private String Remark;
    
    /* Session Variables */
    private String S_COMP_CODE;
    private String S_USER_ID;
    private String S_LANG_CODE;
    
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

	public int getSeq() {
		return Seq;
	}

	public void setSeq(int seq) {
		Seq = seq;
	}

	public String getDocumentID() {
		return DocumentID;
	}

	public void setDocumentID(String documentID) {
		DocumentID = documentID;
	}

	public String getExpenseDate() {
		return ExpenseDate;
	}

	public void setExpenseDate(String expenseDate) {
		ExpenseDate = expenseDate;
	}

	public String getExpenseReason() {
		return ExpenseReason;
	}

	public void setExpenseReason(String expenseReason) {
		ExpenseReason = expenseReason;
	}

	public String getAcctName() {
		return AcctName;
	}

	public void setAcctName(String acctName) {
		AcctName = acctName;
	}

	public String getSupply() {
		return Supply;
	}

	public void setSupply(String supply) {
		Supply = supply;
	}

	public String getVat() {
		return Vat;
	}

	public void setVat(String vat) {
		Vat = vat;
	}

	public String getRemark() {
		return Remark;
	}

	public void setRemark(String remark) {
		Remark = remark;
	}

	
    
}
