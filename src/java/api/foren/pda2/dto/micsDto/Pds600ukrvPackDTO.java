package api.foren.pda2.dto.micsDto;

import java.io.Serializable;

/**
 * 패킹 저장 DTO
 * */

public class Pds600ukrvPackDTO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String flag;
	private String compCode;
	private String divCode;
	private String issueReqNum;
	private String packNo;
	private String issueDate;
	private String customCode;
	private String issuePrsn;
	
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getCompCode() {
		return compCode;
	}
	public void setCompCode(String compCode) {
		this.compCode = compCode;
	}
	public String getDivCode() {
		return divCode;
	}
	public void setDivCode(String divCode) {
		this.divCode = divCode;
	}
	public String getIssueReqNum() {
		return issueReqNum;
	}
	public void setIssueReqNum(String issueReqNum) {
		this.issueReqNum = issueReqNum;
	}
	public String getPackNo() {
		return packNo;
	}
	public void setPackNo(String packNo) {
		this.packNo = packNo;
	}
	public String getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(String issueDate) {
		this.issueDate = issueDate;
	}
	public String getCustomCode() {
		return customCode;
	}
	public void setCustomCode(String customCode) {
		this.customCode = customCode;
	}
	public String getIssuePrsn() {
		return issuePrsn;
	}
	public void setIssuePrsn(String issuePrsn) {
		this.issuePrsn = issuePrsn;
	}
}
