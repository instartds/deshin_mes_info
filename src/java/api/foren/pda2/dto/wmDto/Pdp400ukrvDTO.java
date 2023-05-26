package api.foren.pda2.dto.wmDto;

import java.io.Serializable;
import java.util.List;

public class Pdp400ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	
	private String compCode;
	private String divCode;
    private String whCode;
    private String whCellCode;
	private String inspecPrsn;
	private String inspecDate;
	
	private List<Pdp400ukrvDetailDTO> itemList;

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

	public String getInspecPrsn() {
		return inspecPrsn;
	}

	public void setInspecPrsn(String inspecPrsn) {
		this.inspecPrsn = inspecPrsn;
	}

	public String getInspecDate() {
		return inspecDate;
	}

	public void setInspecDate(String inspecDate) {
		this.inspecDate = inspecDate;
	}

	public List<Pdp400ukrvDetailDTO> getItemList() {
		return itemList;
	}

	public void setItemList(List<Pdp400ukrvDetailDTO> itemList) {
		this.itemList = itemList;
	}


}
