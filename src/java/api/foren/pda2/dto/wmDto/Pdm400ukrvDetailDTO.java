package api.foren.pda2.dto.wmDto;

import java.io.Serializable;

public class Pdm400ukrvDetailDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String workShopCode;
	private String itemCode;
	private String itemName;
	private String spec;
	private String orderUnit;
	private Double notQ;
	private Double outQ;
	private String wkordNum;
	private String lotNo;
	private String remark;
	private String projectNo;
	
	public String getWorkShopCode() {
		return workShopCode;
	}
	public void setWorkShopCode(String workShopCode) {
		this.workShopCode = workShopCode;
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
	public String getOrderUnit() {
		return orderUnit;
	}
	public void setOrderUnit(String orderUnit) {
		this.orderUnit = orderUnit;
	}
	public Double getNotQ() {
		return notQ;
	}
	public void setNotQ(Double notQ) {
		this.notQ = notQ;
	}
	public Double getOutQ() {
		return outQ;
	}
	public void setOutQ(Double outQ) {
		this.outQ = outQ;
	}
	public String getWkordNum() {
		return wkordNum;
	}
	public void setWkordNum(String wkordNum) {
		this.wkordNum = wkordNum;
	}
	public String getLotNo() {
		return lotNo;
	}
	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getProjectNo() {
		return projectNo;
	}
	public void setProjectNo(String projectNo) {
		this.projectNo = projectNo;
	}
}
