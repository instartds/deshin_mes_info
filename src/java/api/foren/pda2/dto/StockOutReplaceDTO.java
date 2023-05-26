package api.foren.pda2.dto;

import java.io.Serializable;

public class StockOutReplaceDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String compCode;
	private String inoutDate;
	private String divCode;
	private String whCode;
	private String whCellCode;
	private String itemCode;
	private Double inoutP;
	private Double inoutI;
	private Double inoutQ;
	private Double goodStockQ;
	private Double badStockQ;
	private String lotNo;
	private String oDivCode;
	private String oWhCode;
	private String oWhCellCode;
	private String oItemCode;
	private Double oInoutP;
	private Double oInoutQ;
	private Double oGoodStockQ;
	private Double oBadStockQ;
	private Double oInoutI;
	private String oLotNo;
	private String inoutPrsn;

	public String getCompCode() {
		return compCode;
	}

	public void setCompCode(String compCode) {
		this.compCode = compCode;
	}

	public String getInoutDate() {
		return inoutDate;
	}

	public void setInoutDate(String inoutDate) {
		this.inoutDate = inoutDate;
	}

	public String getDivCode() {
		return divCode;
	}

	public void setDivCode(String divCode) {
		this.divCode = divCode;
	}

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

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public Double getInoutP() {
		return inoutP;
	}

	public void setInoutP(Double inoutP) {
		this.inoutP = inoutP;
	}

	public Double getInoutI() {
		return inoutI;
	}

	public void setInoutI(Double inoutI) {
		this.inoutI = inoutI;
	}

	public Double getInoutQ() {
		return inoutQ;
	}

	public void setInoutQ(Double inoutQ) {
		this.inoutQ = inoutQ;
	}

	public Double getGoodStockQ() {
		return goodStockQ;
	}

	public void setGoodStockQ(Double goodStockQ) {
		this.goodStockQ = goodStockQ;
	}

	public Double getBadStockQ() {
		return badStockQ;
	}

	public void setBadStockQ(Double badStockQ) {
		this.badStockQ = badStockQ;
	}

	public String getLotNo() {
		return lotNo;
	}

	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}

	public String getoDivCode() {
		return oDivCode;
	}

	public void setoDivCode(String oDivCode) {
		this.oDivCode = oDivCode;
	}

	public String getoWhCode() {
		return oWhCode;
	}

	public void setoWhCode(String oWhCode) {
		this.oWhCode = oWhCode;
	}

	public String getoWhCellCode() {
		return oWhCellCode;
	}

	public void setoWhCellCode(String oWhCellCode) {
		this.oWhCellCode = oWhCellCode;
	}

	public String getoItemCode() {
		return oItemCode;
	}

	public void setoItemCode(String oItemCode) {
		this.oItemCode = oItemCode;
	}

	public Double getoInoutP() {
		return oInoutP;
	}

	public void setoInoutP(Double oInoutP) {
		this.oInoutP = oInoutP;
	}

	public Double getoInoutQ() {
		return oInoutQ;
	}

	public void setoInoutQ(Double oInoutQ) {
		this.oInoutQ = oInoutQ;
	}

	public Double getoGoodStockQ() {
		return oGoodStockQ;
	}

	public void setoGoodStockQ(Double oGoodStockQ) {
		this.oGoodStockQ = oGoodStockQ;
	}

	public Double getoBadStockQ() {
		return oBadStockQ;
	}

	public void setoBadStockQ(Double oBadStockQ) {
		this.oBadStockQ = oBadStockQ;
	}

	public Double getoInoutI() {
		return oInoutI;
	}

	public void setoInoutI(Double oInoutI) {
		this.oInoutI = oInoutI;
	}

	public String getoLotNo() {
		return oLotNo;
	}

	public void setoLotNo(String oLotNo) {
		this.oLotNo = oLotNo;
	}

	public String getInoutPrsn() {
		return inoutPrsn;
	}

	public void setInoutPrsn(String inoutPrsn) {
		this.inoutPrsn = inoutPrsn;
	}

	@Override
	public String toString() {
		return "StockOutReplaceDTO [compCode=" + compCode + ", inoutDate=" + inoutDate + ", divCode=" + divCode
				+ ", whCode=" + whCode + ", whCellCode=" + whCellCode + ", itemCode=" + itemCode + ", inoutP=" + inoutP
				+ ", inoutI=" + inoutI + ", inoutQ=" + inoutQ + ", goodStockQ=" + goodStockQ + ", badStockQ="
				+ badStockQ + ", lotNo=" + lotNo + ", oDivCode=" + oDivCode + ", oWhCode=" + oWhCode + ", oWhCellCode="
				+ oWhCellCode + ", oItemCode=" + oItemCode + ", oInoutP=" + oInoutP + ", oInoutQ=" + oInoutQ
				+ ", oGoodStockQ=" + oGoodStockQ + ", oBadStockQ=" + oBadStockQ + ", oInoutI=" + oInoutI + ", oLotNo="
				+ oLotNo + ", inoutPrsn=" + inoutPrsn + "]";
	}

}
