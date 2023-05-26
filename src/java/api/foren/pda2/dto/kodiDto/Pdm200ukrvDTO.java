package api.foren.pda2.dto.kodiDto;

import java.io.Serializable;
import java.util.List;

public class Pdm200ukrvDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	private String compCode;
	private String divCode;
	private String customCode;
	// (입고)-창고코드
	private String toWhCode;
	// cell코드
	private String toCellCode;
	// 입고처
	private String inoutCode;
	// 출고일
	private String inoutDate;


	// 입고담당자
	private String inoutPrsn;
	private String moneyUnit;
	private Double exchgRateO;
	private String itemCode;
	private String lotNo;
	// 발주번호(작지번호)
	private String orderNum;
	private int orderSeq;
	private String orderUnit;
	private Double trnsRate;
	private Double orderUnitP;
	// 근거번호
	private String basisNum;
	// 근거순번
	private int basisSeq;
	// PATH_CODE
	private String pathCode;
	// 출고요청번호
	private String outStockNum;
	// 작업지시번호
	private String refWkordNum;
	private String remark;
	private String projectNo;
	private String sGubunKd;

	// 리스트
	private List<Kodi_LotDTO> lotList;

	public String getCustomCode() {
		return customCode;
	}

	public void setCustomCode(String customCode) {
		this.customCode = customCode;
	}

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

	public String getInoutDate() {
		return inoutDate;
	}

	public void setInoutDate(String inoutDate) {
		this.inoutDate = inoutDate;
	}

	public String getInoutPrsn() {
		return inoutPrsn;
	}

	public void setInoutPrsn(String inoutPrsn) {
		this.inoutPrsn = inoutPrsn;
	}

	public String getMoneyUnit() {
		return moneyUnit;
	}

	public void setMoneyUnit(String moneyUnit) {
		this.moneyUnit = moneyUnit;
	}

	public Double getExchgRateO() {
		return exchgRateO;
	}

	public void setExchgRateO(Double exchgRateO) {
		this.exchgRateO = exchgRateO;
	}

	public String getToWhCode() {
		return toWhCode;
	}

	public void setToWhCode(String toWhCode) {
		this.toWhCode = toWhCode;
	}

	public String getToCellCode() {
		return toCellCode;
	}

	public void setToCellCode(String toCellCode) {
		this.toCellCode = toCellCode;
	}

	public String getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}

	public String getBasisNum() {
		return basisNum;
	}

	public void setBasisNum(String basisNum) {
		this.basisNum = basisNum;
	}

	public String getPathCode() {
		return pathCode;
	}

	public void setPathCode(String pathCode) {
		this.pathCode = pathCode;
	}

	public String getInoutCode() {
		return inoutCode;
	}

	public void setInoutCode(String inoutCode) {
		this.inoutCode = inoutCode;
	}

	public String getRefWkordNum() {
		return refWkordNum;
	}

	public void setRefWkordNum(String refWkordNum) {
		this.refWkordNum = refWkordNum;
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

	public String getOrderUnit() {
		return orderUnit;
	}

	public void setOrderUnit(String orderUnit) {
		this.orderUnit = orderUnit;
	}

	public int getOrderSeq() {
		return orderSeq;
	}

	public void setOrderSeq(int orderSeq) {
		this.orderSeq = orderSeq;
	}

	public Double getTrnsRate() {
		return trnsRate;
	}

	public void setTrnsRate(Double trnsRate) {
		this.trnsRate = trnsRate;
	}

	public Double getOrderUnitP() {
		return orderUnitP;
	}

	public void setOrderUnitP(Double orderUnitP) {
		this.orderUnitP = orderUnitP;
	}

	public int getBasisSeq() {
		return basisSeq;
	}

	public void setBasisSeq(int basisSeq) {
		this.basisSeq = basisSeq;
	}

	public String getOutStockNum() {
		return outStockNum;
	}

	public void setOutStockNum(String outStockNum) {
		this.outStockNum = outStockNum;
	}

	public String getsGubunKd() {
		return sGubunKd;
	}

	public void setsGubunKd(String sGubunKd) {
		this.sGubunKd = sGubunKd;
	}

	public List<Kodi_LotDTO> getLotList() {
		return lotList;
	}

	public void setLotList(List<Kodi_LotDTO> lotList) {
		this.lotList = lotList;
	}

	@Override
	public String toString() {
		return "Pdm200ukrvDTO [compCode=" + compCode + ", divCode=" + divCode
				+ ", customCode=" + customCode + ", toWhCode=" + toWhCode
				+ ", toCellCode=" + toCellCode + ", inoutCode=" + inoutCode
				+ ", inoutDate=" + inoutDate + ", inoutPrsn=" + inoutPrsn
				+ ", moneyUnit=" + moneyUnit + ", exchgRateO=" + exchgRateO
				+ ", itemCode=" + itemCode + ", lotNo=" + lotNo + ", orderNum="
				+ orderNum + ", orderSeq=" + orderSeq + ", orderUnit="
				+ orderUnit + ", trnsRate=" + trnsRate + ", orderUnitP="
				+ orderUnitP + ", basisNum=" + basisNum + ", basisSeq="
				+ basisSeq + ", pathCode=" + pathCode + ", outStockNum="
				+ outStockNum + ", refWkordNum=" + refWkordNum + ", remark="
				+ remark + ", projectNo=" + projectNo + ", sGubunKd="
				+ sGubunKd + ", lotList=" + lotList + "]";
	}
}
