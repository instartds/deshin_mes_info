package api.foren.pda2.dto.wmDto;

import java.io.Serializable;

public class Pdm300ukrvDetailDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String itemCode;
	private String itemName;
	private String spec;
	private String orderUnit;
	private Double receiptQ;
	private Double instockQ;
	private String receiptNum;
	private Integer receiptSeq;
	
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
	public String getOrderUnit() {
		return orderUnit;
	}
	public void setOrderUnit(String orderUnit) {
		this.orderUnit = orderUnit;
	}
	public Double getReceiptQ() {
		return receiptQ;
	}
	public void setReceiptQ(Double receiptQ) {
		this.receiptQ = receiptQ;
	}
	public Double getInstockQ() {
		return instockQ;
	}
	public void setInstockQ(Double instockQ) {
		this.instockQ = instockQ;
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
	
}
