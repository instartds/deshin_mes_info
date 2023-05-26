package api.foren.pda2.dto;

import java.io.Serializable;

public class WkordBadDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String compCode;

	private String divCode;

	private String workShopCode;
	
	private String prodtNum;
	
	private String progWorkCode;

	private String wkordNum;

	private String prodtDate;

	private String itemCode;

	private String badCode;

	private Double badQ;

	private String remark;

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

	public String getProdtDate() {
		return prodtDate;
	}

	public void setProdtDate(String prodtDate) {
		this.prodtDate = prodtDate;
	}

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public String getBadCode() {
		return badCode;
	}

	public void setBadCode(String badCode) {
		this.badCode = badCode;
	}

	public Double getBadQ() {
		return badQ;
	}

	public void setBadQ(Double badQ) {
		this.badQ = badQ;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getProgWorkCode() {
		return progWorkCode;
	}

	public void setProgWorkCode(String progWorkCode) {
		this.progWorkCode = progWorkCode;
	}

	public String getProdtNum() {
		return prodtNum;
	}

	public void setProdtNum(String prodtNum) {
		this.prodtNum = prodtNum;
	}

	@Override
	public String toString() {
		return "WkordBadDTO [compCode=" + compCode + ", divCode=" + divCode + ", workShopCode=" + workShopCode
				+ ", prodtNum=" + prodtNum + ", progWorkCode=" + progWorkCode + ", wkordNum=" + wkordNum
				+ ", prodtDate=" + prodtDate + ", itemCode=" + itemCode + ", badCode=" + badCode + ", badQ=" + badQ
				+ ", remark=" + remark + "]";
	}

}
