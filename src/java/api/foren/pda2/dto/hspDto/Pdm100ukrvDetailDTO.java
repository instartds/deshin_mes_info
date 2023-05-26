package api.foren.pda2.dto.hspDto;

import java.io.Serializable;

public class Pdm100ukrvDetailDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String itemCode;

	private String itemName;

	private String spec;

	private Double inoutQ;

	private String orderUnit;
	
	private Double itemP;



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
	public Double getInoutQ() {
		return inoutQ;
	}

	public void setInoutQ(Double inoutQ) {
		this.inoutQ = inoutQ;
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

	public Double getItemP() {
		return itemP;
	}

	public void setItemP(Double itemP) {
		this.itemP = itemP;
	}
}
