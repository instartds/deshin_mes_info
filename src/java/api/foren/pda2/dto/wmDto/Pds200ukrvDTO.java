package api.foren.pda2.dto.wmDto;

import java.io.Serializable;
import java.util.List;

public class Pds200ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	
	private String compCode;
	private String divCode;
	private String whCode;
	private String whCellCode;
	private String inoutPrsn;
	
	private List<Pds200ukrvDetailDTO> itemList;

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

	public List<Pds200ukrvDetailDTO> getItemList() {
		return itemList;
	}

	public void setItemList(List<Pds200ukrvDetailDTO> itemList) {
		this.itemList = itemList;
	}


}
