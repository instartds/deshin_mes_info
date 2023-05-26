package api.foren.pda2.dto.mitDto;

import java.io.Serializable;
import java.util.List;

public class Pdp200ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String prodtNum;
	private String prodtDate;
	private String progWorkCode;
	private Double wkordQ;
	private Double goodWorkQ;
	private Double badWorkQ;
	private String wkordNum;
	private String wkPlanNum;
	private String controlStatus;
	private Double manHour;
	private String remark;
	private String lotNo;
	private String equipCode;
	private String prodtPrsn;
	private String expirationDate;
	
	private List<Pdp200ukrvSub1DTO> sub1List;

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

	public String getProdtDate() {
		return prodtDate;
	}

	public void setProdtDate(String prodtDate) {
		this.prodtDate = prodtDate;
	}

	public String getProgWorkCode() {
		return progWorkCode;
	}

	public void setProgWorkCode(String progWorkCode) {
		this.progWorkCode = progWorkCode;
	}

	public Double getWkordQ() {
		return wkordQ;
	}

	public void setWkordQ(Double wkordQ) {
		this.wkordQ = wkordQ;
	}

	public Double getGoodWorkQ() {
		return goodWorkQ;
	}

	public void setGoodWorkQ(Double goodWorkQ) {
		this.goodWorkQ = goodWorkQ;
	}

	public Double getBadWorkQ() {
		return badWorkQ;
	}

	public void setBadWorkQ(Double badWorkQ) {
		this.badWorkQ = badWorkQ;
	}

	public String getWkordNum() {
		return wkordNum;
	}

	public void setWkordNum(String wkordNum) {
		this.wkordNum = wkordNum;
	}

	public String getWkPlanNum() {
		return wkPlanNum;
	}

	public void setWkPlanNum(String wkPlanNum) {
		this.wkPlanNum = wkPlanNum;
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

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getLotNo() {
		return lotNo;
	}

	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}

	public String getEquipCode() {
		return equipCode;
	}

	public void setEquipCode(String equipCode) {
		this.equipCode = equipCode;
	}

	public String getProdtPrsn() {
		return prodtPrsn;
	}

	public void setProdtPrsn(String prodtPrsn) {
		this.prodtPrsn = prodtPrsn;
	}

	public String getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(String expirationDate) {
		this.expirationDate = expirationDate;
	}

	public List<Pdp200ukrvSub1DTO> getSub1List() {
		return sub1List;
	}

	public void setSub1List(List<Pdp200ukrvSub1DTO> sub1List) {
		this.sub1List = sub1List;
	}
}
