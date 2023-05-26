package api.foren.pda2.dto.micsDto;

import java.io.Serializable;

/**
 * 패킹 저장 DTO
 * */

public class Pds510ukrvPackDTO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String flag;
	private String compCode;
	private String divCode;
	private String issueReqNum;
	private String issueReqSeq;
	private String packNo;
	private String itemCode;
	private String lotNo;
	private String packQty;
	
	private String packCode;
	private String packCellCode;
	
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
	public String getIssueReqSeq() {
		return issueReqSeq;
	}
	public void setIssueReqSeq(String issueReqSeq) {
		this.issueReqSeq = issueReqSeq;
	}
	public String getPackNo() {
		return packNo;
	}
	public void setPackNo(String packNo) {
		this.packNo = packNo;
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
	public String getPackQty() {
		return packQty;
	}
	public void setPackQty(String packQty) {
		this.packQty = packQty;
	}
	public String getPackCode() {
		return packCode;
	}
	public void setPackCode(String packCode) {
		this.packCode = packCode;
	}
	public String getPackCellCode() {
		return packCellCode;
	}
	public void setPackCellCode(String packCellCode) {
		this.packCellCode = packCellCode;
	}
}
