package api.foren.pda2.dto.wmDto;

import java.io.Serializable;
import java.util.List;

public class Pdm300ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	
	private String compCode;
	private String divCode;
	private String customPrsn;
	private String receiptPrsn;
	private String phoneNum;
	private String arrivalDate;
	
	private List<Pdm300ukrvDetailDTO> itemList;

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

	public String getCustomPrsn() {
		return customPrsn;
	}

	public void setCustomPrsn(String customPrsn) {
		this.customPrsn = customPrsn;
	}

	public String getReceiptPrsn() {
		return receiptPrsn;
	}

	public void setReceiptPrsn(String receiptPrsn) {
		this.receiptPrsn = receiptPrsn;
	}

	public String getPhoneNum() {
		return phoneNum;
	}

	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}

	public String getArrivalDate() {
		return arrivalDate;
	}

	public void setArrivalDate(String arrivalDate) {
		this.arrivalDate = arrivalDate;
	}

	public List<Pdm300ukrvDetailDTO> getItemList() {
		return itemList;
	}

	public void setItemList(List<Pdm300ukrvDetailDTO> itemList) {
		this.itemList = itemList;
	}


}
