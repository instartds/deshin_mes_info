package api.foren.pda2.dto.mitDto;

import java.io.Serializable;

public class Pdv100ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String gubun;
	private String outWhCode;
	private String outWhCellCode;
	private String inWhCode;
	private String inWhCellCode;
	
	private String saveFlag;
	
	private String inoutPrsn;
	private String inoutDate;
	
	private String itemCode;
	private String lotNo;

	private String barCode;
	
	private Double qty;
	
	private String remark;
	
	private String seq;
	
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
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
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
	public String getSaveFlag() {
		return saveFlag;
	}
	public void setSaveFlag(String saveFlag) {
		this.saveFlag = saveFlag;
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
	public String getBarCode() {
		return barCode;
	}
	public void setBarCode(String barCode) {
		this.barCode = barCode;
	}
	public Double getQty() {
		return qty;
	}
	public void setQty(Double qty) {
		this.qty = qty;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	
}
