package api.foren.pda2.dto.wmDto;

import java.io.Serializable;
import java.util.List;

public class Pdm400ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String whCode;
	private String whCellCode;
	private String inoutPrsn;
	private String inoutDate;
	private String wkordNum;
	
	private List<Pdm400ukrvDetailDTO> itemList;

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

	public String getInoutPrsn() {
		return inoutPrsn;
	}

	public void setInoutPrsn(String inoutPrsn) {
		this.inoutPrsn = inoutPrsn;
	}

	public List<Pdm400ukrvDetailDTO> getItemList() {
		return itemList;
	}

	public void setItemList(List<Pdm400ukrvDetailDTO> itemList) {
		this.itemList = itemList;
	}

	public String getInoutDate() {
		return inoutDate;
	}

	public void setInoutDate(String inoutDate) {
		this.inoutDate = inoutDate;
	}

	public String getWkordNum() {
		return wkordNum;
	}

	public void setWkordNum(String wkordNum) {
		this.wkordNum = wkordNum;
	}

	
	

}
