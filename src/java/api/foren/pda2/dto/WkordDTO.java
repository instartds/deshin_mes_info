package api.foren.pda2.dto;

import java.io.Serializable;
import java.util.List;

public class WkordDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String prodtNum;
	private String workShopCode;
	private String wkordNum;
	private String itemCode;
	private String prodtDate;
	private Double prodtQ;
	private Double goodProdtQ;
	private Double badProdtQ;
	private String controlStatus;
	private Double manHour;
	private String lotNo;
	private String workMan;
	private String workTime;
	private String prodtTime;
	private String frTime;
	private String toTime;
	
	private String bizType;
	
	public String getBizType() {
		return bizType;
	}

	public void setBizType(String bizType) {
		this.bizType = bizType;
	}

	private List<WkordBadDTO> badList;

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

	public String getProdtNum() {
		return prodtNum;
	}

	public void setProdtNum(String prodtNum) {
		this.prodtNum = prodtNum;
	}

	public String getWorkShopCode() {
		return workShopCode;
	}

	public void setWorkShopCode(String workShopCode) {
		this.workShopCode = workShopCode;
	}

	public String getWkordNum() {
		return wkordNum;
	}

	public void setWkordNum(String wkordNum) {
		this.wkordNum = wkordNum;
	}

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public String getProdtDate() {
		return prodtDate;
	}

	public void setProdtDate(String prodtDate) {
		this.prodtDate = prodtDate;
	}

	public Double getProdtQ() {
		return prodtQ;
	}

	public void setProdtQ(Double prodtQ) {
		this.prodtQ = prodtQ;
	}

	public Double getGoodProdtQ() {
		return goodProdtQ;
	}

	public void setGoodProdtQ(Double goodProdtQ) {
		this.goodProdtQ = goodProdtQ;
	}

	public Double getBadProdtQ() {
		return badProdtQ;
	}

	public void setBadProdtQ(Double badProdtQ) {
		this.badProdtQ = badProdtQ;
	}

	public String getControlStatus() {
		return controlStatus;
	}

	public void setControlStatus(String controlStatus) {
		this.controlStatus = controlStatus;
	}

	public Double getManHour() {
		return manHour;
	}

	public void setManHour(Double manHour) {
		this.manHour = manHour;
	}

	public String getLotNo() {
		return lotNo;
	}

	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}

	public String getWorkMan() {
		return workMan;
	}

	public void setWorkMan(String workMan) {
		this.workMan = workMan;
	}

	public String getWorkTime() {
		return workTime;
	}

	public void setWorkTime(String workTime) {
		this.workTime = workTime;
	}

	public String getProdtTime() {
		return prodtTime;
	}

	public void setProdtTime(String prodtTime) {
		this.prodtTime = prodtTime;
	}

	public String getFrTime() {
		return frTime;
	}

	public void setFrTime(String frTime) {
		this.frTime = frTime;
	}

	public String getToTime() {
		return toTime;
	}

	public void setToTime(String toTime) {
		this.toTime = toTime;
	}

	public List<WkordBadDTO> getBadList() {
		return badList;
	}

	public void setBadList(List<WkordBadDTO> badList) {
		this.badList = badList;
	}

	@Override
	public String toString() {
		return "WkordDTO [compCode=" + compCode + ", divCode=" + divCode + ", prodtNum=" + prodtNum + ", workShopCode="
				+ workShopCode + ", wkordNum=" + wkordNum + ", itemCode=" + itemCode + ", prodtDate=" + prodtDate
				+ ", prodtQ=" + prodtQ + ", goodProdtQ=" + goodProdtQ + ", badProdtQ=" + badProdtQ + ", controlStatus="
				+ controlStatus + ", manHour=" + manHour + ", lotNo=" + lotNo + ", workMan=" + workMan + ", workTime="
				+ workTime + ", prodtTime=" + prodtTime + ", frTime=" + frTime + ", toTime=" + toTime + ", badList="
				+ badList + "]";
	}
	
}
