package api.foren.pda2.dto;

import java.io.Serializable;
import java.util.List;

public class StockOutProductDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String customCode;
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
	private String orderType;
	private String orderUnit;
	private Double trnsRate;
	private Double orderUnitP;

	// PATH_CODE
	private String pathCode;
	// 출고요청번호
	private String outStockNum;
	// 작업지시번호
	private String refWkordNum;
	private String remark;
	private String projectNo;

	private String issueReqNum;
	private int issueReqSeq;
	private String billType;
	private String saleType;
	private String taxType;
	private String priceYn;
	private String salePrsn;
	private String saleDivCode;
	private String saleCustomCode;
	private String tradeLoc;
	private String accountYnc;

	private Double issueReqPrice;
	private Double issueReqAmt;
	private Double issueReqTaxAmt;

	public Double getIssueReqPrice() {
		return issueReqPrice;
	}

	public void setIssueReqPrice(Double issueReqPrice) {
		this.issueReqPrice = issueReqPrice;
	}

	public Double getIssueReqAmt() {
		return issueReqAmt;
	}

	public void setIssueReqAmt(Double issueReqAmt) {
		this.issueReqAmt = issueReqAmt;
	}

	public Double getIssueReqTaxAmt() {
		return issueReqTaxAmt;
	}

	public void setIssueReqTaxAmt(Double issueReqTaxAmt) {
		this.issueReqTaxAmt = issueReqTaxAmt;
	}

	// 리스트
	private List<LotDTO> lotList;

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

	public String getCustomCode() {
		return customCode;
	}

	public void setCustomCode(String customCode) {
		this.customCode = customCode;
	}

	public String getInoutCode() {
		return inoutCode;
	}

	public void setInoutCode(String inoutCode) {
		this.inoutCode = inoutCode;
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

	public String getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}

	public int getOrderSeq() {
		return orderSeq;
	}

	public void setOrderSeq(int orderSeq) {
		this.orderSeq = orderSeq;
	}

	public String getOrderUnit() {
		return orderUnit;
	}

	public void setOrderUnit(String orderUnit) {
		this.orderUnit = orderUnit;
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

	public String getPathCode() {
		return pathCode;
	}

	public void setPathCode(String pathCode) {
		this.pathCode = pathCode;
	}

	public String getOutStockNum() {
		return outStockNum;
	}

	public void setOutStockNum(String outStockNum) {
		this.outStockNum = outStockNum;
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

	public String getIssueReqNum() {
		return issueReqNum;
	}

	public void setIssueReqNum(String issueReqNum) {
		this.issueReqNum = issueReqNum;
	}

	public int getIssueReqSeq() {
		return issueReqSeq;
	}

	public void setIssueReqSeq(int issueReqSeq) {
		this.issueReqSeq = issueReqSeq;
	}

	public String getBillType() {
		return billType;
	}

	public void setBillType(String billType) {
		this.billType = billType;
	}

	public String getSaleType() {
		return saleType;
	}

	public void setSaleType(String saleType) {
		this.saleType = saleType;
	}

	public String getTaxType() {
		return taxType;
	}

	public void setTaxType(String taxType) {
		this.taxType = taxType;
	}

	public String getPriceYn() {
		return priceYn;
	}

	public void setPriceYn(String priceYn) {
		this.priceYn = priceYn;
	}

	public String getSalePrsn() {
		return salePrsn;
	}

	public void setSalePrsn(String salePrsn) {
		this.salePrsn = salePrsn;
	}

	public String getSaleDivCode() {
		return saleDivCode;
	}

	public void setSaleDivCode(String saleDivCode) {
		this.saleDivCode = saleDivCode;
	}

	public String getSaleCustomCode() {
		return saleCustomCode;
	}

	public void setSaleCustomCode(String saleCustomCode) {
		this.saleCustomCode = saleCustomCode;
	}

	public String getTradeLoc() {
		return tradeLoc;
	}

	public void setTradeLoc(String tradeLoc) {
		this.tradeLoc = tradeLoc;
	}

	public String getAccountYnc() {
		return accountYnc;
	}

	public void setAccountYnc(String accountYnc) {
		this.accountYnc = accountYnc;
	}

	public List<LotDTO> getLotList() {
		return lotList;
	}

	public void setLotList(List<LotDTO> lotList) {
		this.lotList = lotList;
	}

	public String getOrderType() {
		return orderType;
	}

	public void setOrderType(String orderType) {
		this.orderType = orderType;
	}

	@Override
	public String toString() {
		return "StockOutProductDTO [compCode=" + compCode + ", divCode=" + divCode + ", customCode=" + customCode
				+ ", inoutCode=" + inoutCode + ", inoutDate=" + inoutDate + ", inoutPrsn=" + inoutPrsn + ", moneyUnit="
				+ moneyUnit + ", exchgRateO=" + exchgRateO + ", itemCode=" + itemCode + ", lotNo=" + lotNo
				+ ", orderNum=" + orderNum + ", orderSeq=" + orderSeq + ", orderType=" + orderType + ", orderUnit="
				+ orderUnit + ", trnsRate=" + trnsRate + ", orderUnitP=" + orderUnitP + ", pathCode=" + pathCode
				+ ", outStockNum=" + outStockNum + ", refWkordNum=" + refWkordNum + ", remark=" + remark
				+ ", projectNo=" + projectNo + ", issueReqNum=" + issueReqNum + ", issueReqSeq=" + issueReqSeq
				+ ", billType=" + billType + ", saleType=" + saleType + ", taxType=" + taxType + ", priceYn=" + priceYn
				+ ", salePrsn=" + salePrsn + ", saleDivCode=" + saleDivCode + ", saleCustomCode=" + saleCustomCode
				+ ", tradeLoc=" + tradeLoc + ", accountYnc=" + accountYnc + ", issueReqPrice=" + issueReqPrice
				+ ", issueReqAmt=" + issueReqAmt + ", issueReqTaxAmt=" + issueReqTaxAmt + ", lotList=" + lotList + "]";
	}
	
}
