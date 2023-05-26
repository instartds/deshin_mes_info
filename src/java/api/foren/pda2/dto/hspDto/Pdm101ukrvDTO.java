package api.foren.pda2.dto.hspDto;

import java.io.Serializable;
import java.util.List;

public class Pdm101ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;

	private String divCode;

	private String whCode;

	// 입고일자
	private String inoutDate;
	// 입고담당자
	private String inoutPrsn;
	
	private String customCode;

	private String itemCode;
	
	private Double inoutQ;

	
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

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public Double getInoutQ() {
		return inoutQ;
	}

	public void setInoutQ(Double inoutQ) {
		this.inoutQ = inoutQ;
	}

}
