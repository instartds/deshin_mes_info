package api.foren.pda2.dto.covDto;

import java.io.Serializable;
import java.util.List;

public class Pds200ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String inoutDate;
	private String salesDate;
	private String inoutPrsn;
	private String outType;
	
	private List<Pds200ukrvDetailDTO> detailList;

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

	public String getSalesDate() {
		return salesDate;
	}

	public void setSalesDate(String salesDate) {
		this.salesDate = salesDate;
	}

	public String getInoutPrsn() {
		return inoutPrsn;
	}

	public void setInoutPrsn(String inoutPrsn) {
		this.inoutPrsn = inoutPrsn;
	}

	public String getOutType() {
		return outType;
	}

	public void setOutType(String outType) {
		this.outType = outType;
	}

	public List<Pds200ukrvDetailDTO> getDetailList() {
		return detailList;
	}

	public void setDetailList(List<Pds200ukrvDetailDTO> detailList) {
		this.detailList = detailList;
	}
	
	
}
