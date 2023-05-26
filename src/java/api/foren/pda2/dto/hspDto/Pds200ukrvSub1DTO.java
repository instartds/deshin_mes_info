package api.foren.pda2.dto.hspDto;

import java.io.Serializable;
import java.util.List;

public class Pds200ukrvSub1DTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String issueReqNum;
	private String issueReqSeq;
	private String customCode;
	private String itemCode;
	private String lotNo;
	private String lotSn;
	private String outQ;
	private String applyYn;
	private String whCode;
	
	public String getSaveFlag() {
		return saveFlag;
	}
	public void setSaveFlag(String saveFlag) {
		this.saveFlag = saveFlag;
	}
	public String getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	private String saveFlag;
	private String deleteFlag;
	
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
	public String getIssueReqSeq() {
		return issueReqSeq;
	}
	public void setIssueReqSeq(String issueReqSeq) {
		this.issueReqSeq = issueReqSeq;
	}
	public String getCustomCode() {
		return customCode;
	}
	public void setCustomCode(String customCode) {
		this.customCode = customCode;
	}
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getLotNo() {
		return lotNo;
	}
	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}
	public String getLotSn() {
		return lotSn;
	}
	public void setLotSn(String lotSn) {
		this.lotSn = lotSn;
	}
	public String getOutQ() {
		return outQ;
	}
	public void setOutQ(String outQ) {
		this.outQ = outQ;
	}
	public String getApplyYn() {
		return applyYn;
	}
	public void setApplyYn(String applyYn) {
		this.applyYn = applyYn;
	}
	
	public String getWhCode() {
		return whCode;
	}
	public void setWhCode(String whCode) {
		this.whCode = whCode;
	}
}
