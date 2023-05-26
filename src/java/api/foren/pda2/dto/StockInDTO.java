package api.foren.pda2.dto;

import java.io.Serializable;
import java.util.List;

public class StockInDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String compCode;

	private String divCode;

	private String whCode;
	// cell코드
	private String whCellCode;
	// 입고일자
	private String inoutDate;
	// 입고담당자
	private String inoutPrsn;
	
	private String receiptNum;
	
	private String receiptSeq;
	

	private List<ItemDTO> itemList;

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

	public List<ItemDTO> getItemList() {
		return itemList;
	}

	public void setItemList(List<ItemDTO> itemList) {
		this.itemList = itemList;
	}

	public String getReceiptNum() {
		return receiptNum;
	}

	public void setReceiptNum(String receiptNum) {
		this.receiptNum = receiptNum;
	}

	public String getReceiptSeq() {
		return receiptSeq;
	}

	public void setReceiptSeq(String receiptSeq) {
		this.receiptSeq = receiptSeq;
	}
	
	@Override
	public String toString() {
		return "StockInDTO [compCode=" + compCode + ", divCode=" + divCode + ", whCode=" + whCode + ", whCellCode="
				+ whCellCode + ", inoutDate=" + inoutDate + ", inoutPrsn=" + inoutPrsn + ", receiptNum=" + receiptNum
				+ ", receiptSeq=" + receiptSeq + ", itemList=" + itemList + "]";
	}
}
