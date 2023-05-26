package api.foren.pda2.dto;

import java.io.Serializable;

public class LotDTO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String whCode;

	private String whName;

	private String lotNo;

	private String whCellCode;

	private Double orderUnitQ;
	
	private String barcode;
	
	private Double boxQty;

	public String getWhCode() {
		return whCode;
	}

	public void setWhCode(String whCode) {
		this.whCode = whCode;
	}

	public String getWhCellCode() {
		return whCellCode;
	}

	public void setWhCellCode(String whCellCode) {
		this.whCellCode = whCellCode;
	}

	public Double getOrderUnitQ() {
		return orderUnitQ;
	}

	public void setOrderUnitQ(Double orderUnitQ) {
		this.orderUnitQ = orderUnitQ;
	}

	public String getWhName() {
		return whName;
	}

	public void setWhName(String whName) {
		this.whName = whName;
	}

	public String getLotNo() {
		return lotNo;
	}

	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}

	public String getBarcode() {
		return barcode;
	}

	public void setBarcode(String barcode) {
		this.barcode = barcode;
	}
	

	public Double getBoxQty() {
		return boxQty;
	}

	public void setBoxQty(Double boxQty) {
		this.boxQty = boxQty;
	}

	@Override
	public String toString() {
		return "LotDTO [whCode=" + whCode + ", whName=" + whName + ", lotNo=" + lotNo + ", whCellCode=" + whCellCode
				+ ", orderUnitQ=" + orderUnitQ + ", barcode=" + barcode + ", boxQty=" + boxQty + "]";
	}

}
