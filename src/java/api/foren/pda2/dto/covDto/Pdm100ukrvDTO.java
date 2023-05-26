package api.foren.pda2.dto.covDto;

import java.io.Serializable;
import java.util.List;

import api.foren.pda2.dto.covDto.Pdm100ukrvDetailDTO;

public class Pdm100ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;

	private String divCode;

	private String whCode;

	// 입고일자
	private String inoutDate;
	// 입고담당자
	private String inoutPrsn;
	
	private String customCode;
	
	private List<Pdm100ukrvDetailDTO> itemList;

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

	public String getCustomCode() {
		return customCode;
	}

	public void setCustomCode(String customCode) {
		this.customCode = customCode;
	}

	public List<Pdm100ukrvDetailDTO> getItemList() {
		return itemList;
	}

	public void setItemList(List<Pdm100ukrvDetailDTO> itemList) {
		this.itemList = itemList;
	}
	
}
