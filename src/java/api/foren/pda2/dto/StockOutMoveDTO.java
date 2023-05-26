package api.foren.pda2.dto;

import java.io.Serializable;
import java.util.List;

public class StockOutMoveDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String compCode;

	// 입고
	private String divCode;
	// 입고창고
	private String inoutCode;
	private String inoutCodeDetail;
	// 출고
	private String outDivCode;

	private String itemCode;

	private String projectNo;
	private String remark;

	private String orderNum;
	private int orderSeq;

	private String inoutPrsn;
	private String inoutDate;

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

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public String getOutDivCode() {
		return outDivCode;
	}

	public void setOutDivCode(String outDivCode) {
		this.outDivCode = outDivCode;
	}

	public String getProjectNo() {
		return projectNo;
	}

	public void setProjectNo(String projectNo) {
		this.projectNo = projectNo;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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

	public List<LotDTO> getLotList() {
		return lotList;
	}

	public void setLotList(List<LotDTO> lotList) {
		this.lotList = lotList;
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

	public String getInoutCode() {
		return inoutCode;
	}

	public void setInoutCode(String inoutCode) {
		this.inoutCode = inoutCode;
	}

	public String getInoutCodeDetail() {
		return inoutCodeDetail;
	}

	public void setInoutCodeDetail(String inoutCodeDetail) {
		this.inoutCodeDetail = inoutCodeDetail;
	}

	@Override
	public String toString() {
		return "StockOutMoveDTO [compCode=" + compCode + ", divCode=" + divCode + ", inoutCode=" + inoutCode
				+ ", inoutCodeDetail=" + inoutCodeDetail + ", outDivCode=" + outDivCode + ", itemCode=" + itemCode
				+ ", projectNo=" + projectNo + ", remark=" + remark + ", orderNum=" + orderNum + ", orderSeq="
				+ orderSeq + ", inoutPrsn=" + inoutPrsn + ", inoutDate=" + inoutDate + ", lotList=" + lotList + "]";
	}
	
}
