package api.foren.pda2.dto.hspDto;

import java.io.Serializable;

public class Pds200ukrvDetailDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String issueReqNum;
    private String issueReqSeq;
    private String customCode;
    private String customName;
    private String bookingNum;
    private String containerNo;
    private String sealNo;
    private String itemCode;
    private String itemName;
    private String spec;
    private Double orderQ;
    private Double pdaOutQ;
    private Double erpInoutQ;
    private Double remainQ;
    private String whCode;

    private String orderNum;
	private String orderSeq;
    
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
	public String getCustomName() {
		return customName;
	}
	public void setCustomName(String customName) {
		this.customName = customName;
	}
	public String getBookingNum() {
		return bookingNum;
	}
	public void setBookingNum(String bookingNum) {
		this.bookingNum = bookingNum;
	}
	public String getContainerNo() {
		return containerNo;
	}
	public void setContainerNo(String containerNo) {
		this.containerNo = containerNo;
	}
	public String getSealNo() {
		return sealNo;
	}
	public void setSealNo(String sealNo) {
		this.sealNo = sealNo;
	}
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public String getSpec() {
		return spec;
	}
	public void setSpec(String spec) {
		this.spec = spec;
	}
	public Double getOrderQ() {
		return orderQ;
	}
	public void setOrderQ(Double orderQ) {
		this.orderQ = orderQ;
	}
	public Double getPdaOutQ() {
		return pdaOutQ;
	}
	public void setPdaOutQ(Double pdaOutQ) {
		this.pdaOutQ = pdaOutQ;
	}
	public Double getErpInoutQ() {
		return erpInoutQ;
	}
	public void setErpInoutQ(Double erpInoutQ) {
		this.erpInoutQ = erpInoutQ;
	}
	public Double getRemainQ() {
		return remainQ;
	}
	public void setRemainQ(Double remainQ) {
		this.remainQ = remainQ;
	}
	public String getWhCode() {
		return whCode;
	}
	public void setWhCode(String whCode) {
		this.whCode = whCode;
	}
	

    public String getOrderNum() {
		return orderNum;
	}
	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}
	public String getOrderSeq() {
		return orderSeq;
	}
	public void setOrderSeq(String orderSeq) {
		this.orderSeq = orderSeq;
	}

}
