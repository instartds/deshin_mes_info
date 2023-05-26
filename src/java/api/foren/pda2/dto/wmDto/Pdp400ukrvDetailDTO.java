package api.foren.pda2.dto.wmDto;

import java.io.Serializable;

public class Pdp400ukrvDetailDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String itemCode;
	private String itemName;
	private String spec;
	private Double notInspecQ;
	private String receiptNum;
	private Integer receiptSeq;
	private String lotNo;
	private String prodtNum;
	private String wkordNum;
	private String invoiceNum;
	private String receiverName;
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
	public Double getNotInspecQ() {
		return notInspecQ;
	}
	public void setNotInspecQ(Double notInspecQ) {
		this.notInspecQ = notInspecQ;
	}
	public String getReceiptNum() {
		return receiptNum;
	}
	public void setReceiptNum(String receiptNum) {
		this.receiptNum = receiptNum;
	}
	public Integer getReceiptSeq() {
		return receiptSeq;
	}
	public void setReceiptSeq(Integer receiptSeq) {
		this.receiptSeq = receiptSeq;
	}
	public String getLotNo() {
		return lotNo;
	}
	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}
	public String getProdtNum() {
		return prodtNum;
	}
	public void setProdtNum(String prodtNum) {
		this.prodtNum = prodtNum;
	}
	public String getWkordNum() {
		return wkordNum;
	}
	public void setWkordNum(String wkordNum) {
		this.wkordNum = wkordNum;
	}
	public String getInvoiceNum() {
		return invoiceNum;
	}
	public void setInvoiceNum(String invoiceNum) {
		this.invoiceNum = invoiceNum;
	}
	public String getReceiverName() {
		return receiverName;
	}
	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}
	
	
}
