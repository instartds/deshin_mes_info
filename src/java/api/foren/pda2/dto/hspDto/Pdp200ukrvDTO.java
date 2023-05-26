package api.foren.pda2.dto.hspDto;

import java.io.Serializable;

public class Pdp200ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
    private String workShopCode;
    
    private String wkordNum;
    private String itemCode;

    private String prodtPrsn;
    
	private String prodtDate;
    private Double prodtQ;
    private Double goodProdtQ;
    private Double badProdtQ;
    private String controlStatus;
    private Double manHour;
    private String lotNo;
    private Integer lotSn;
//    private String workTime;
    

	private String frTime;
    private String toTime;

    private String whCode;

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

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

    public String getProdtPrsn() {
		return prodtPrsn;
	}

	public void setProdtPrsn(String prodtPrsn) {
		this.prodtPrsn = prodtPrsn;
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
	
	public Integer getLotSn() {
		return lotSn;
	}

	public void setLotSn(Integer lotSn) {
		this.lotSn = lotSn;
	}
/*
	public String getWorkTime() {
		return workTime;
	}

	public void setWorkTime(String workTime) {
		this.workTime = workTime;
	}
*/
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

	public String getWhCode() {
		return whCode;
	}

	public void setWhCode(String whCode) {
		this.whCode = whCode;
	}
}
