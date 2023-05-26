package api.foren.pda2.dto;

import java.io.Serializable;

public class ItemDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String compCode;

	private String itemCode;

	private String itemName;

	private String spec;

	private String itemNo;

	private Double inoutQ;

	private Double inoutP;

	private String orderUnit;


	private String lotNo;
	

	private String num;
	private String seq;
	private Double qty;
	
	public String getCompCode() {
		return compCode;
	}

	public void setCompCode(String compCode) {
		this.compCode = compCode;
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

	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}

	public String getLotNo() {
		return lotNo;
	}

	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}

	public Double getInoutQ() {
		return inoutQ;
	}

	public void setInoutQ(Double inoutQ) {
		this.inoutQ = inoutQ;
	}

	public Double getInoutP() {
		return inoutP;
	}

	public void setInoutP(Double inoutP) {
		this.inoutP = inoutP;
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

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public Double getQty() {
		return qty;
	}

	public void setQty(Double qty) {
		this.qty = qty;
	}
	@Override
	public String toString() {
		return "ItemDTO [compCode=" + compCode + ", itemCode=" + itemCode
				+ ", itemName=" + itemName + ", spec=" + spec + ", itemNo="
				+ itemNo + ", inoutQ=" + inoutQ + ", inoutP=" + inoutP
				+ ", orderUnit=" + orderUnit + ", lotNo=" + lotNo + ", num="
				+ num + ", seq=" + seq + ", qty=" + qty + "]";
	}

}
