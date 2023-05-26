package api.foren.pda2.dto;

import java.io.Serializable;

public class StockOutMoveCellDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	
	private String itemCode;
	private double inoutQ;

	private String inoutPrsn;
	private String inoutDate;

	private String inWhCode;
	private String inWhCellCode;

	private String outWhCode;
	private String outWhCellCode;

	private String lotNo;

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

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public String getInoutPrsn() {
		return inoutPrsn;
	}

	public void setInoutPrsn(String inoutPrsn) {
		this.inoutPrsn = inoutPrsn;
	}

	public String getInoutDate() {
		return inoutDate;
	}

	public void setInoutDate(String inoutDate) {
		this.inoutDate = inoutDate;
	}

	public String getInWhCode() {
		return inWhCode;
	}

	public void setInWhCode(String inWhCode) {
		this.inWhCode = inWhCode;
	}

	public String getInWhCellCode() {
		return inWhCellCode;
	}

	public void setInWhCellCode(String inWhCellCode) {
		this.inWhCellCode = inWhCellCode;
	}

	public String getOutWhCode() {
		return outWhCode;
	}

	public void setOutWhCode(String outWhCode) {
		this.outWhCode = outWhCode;
	}

	public String getOutWhCellCode() {
		return outWhCellCode;
	}

	public void setOutWhCellCode(String outWhCellCode) {
		this.outWhCellCode = outWhCellCode;
	}

	public String getLotNo() {
		return lotNo;
	}

	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}

	public double getInoutQ() {
		return inoutQ;
	}

	public void setInoutQ(double inoutQ) {
		this.inoutQ = inoutQ;
	}

	@Override
	public String toString() {
		return "StockOutMoveCellDTO [compCode=" + compCode + ", divCode=" + divCode + ", itemCode=" + itemCode
				+ ", inoutQ=" + inoutQ + ", inoutPrsn=" + inoutPrsn + ", inoutDate=" + inoutDate + ", inWhCode="
				+ inWhCode + ", inWhCellCode=" + inWhCellCode + ", outWhCode=" + outWhCode + ", outWhCellCode="
				+ outWhCellCode + ", lotNo=" + lotNo + "]";
	}
	
}
