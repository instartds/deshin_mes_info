package api.foren.pda2.dto.hspDto;

import java.io.Serializable;
import java.util.List;

public class Pdv200ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
	private String outItemCode;
	private String outLotNo;
	private Integer outSeq;
	private Double outQ;
	private String replaceItemCode;
	private String replaceLotNo;
//	private Integer replaceSeq;
	private Double replaceQ;
	private String replaceDate;
	private String replacePrsn;
	
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
	public String getOutItemCode() {
		return outItemCode;
	}
	public void setOutItemCode(String outItemCode) {
		this.outItemCode = outItemCode;
	}
	public String getOutLotNo() {
		return outLotNo;
	}
	public void setOutLotNo(String outLotNo) {
		this.outLotNo = outLotNo;
	}
	public Integer getOutSeq() {
		return outSeq;
	}
	public void setOutSeq(Integer outSeq) {
		this.outSeq = outSeq;
	}
	public Double getOutQ() {
		return outQ;
	}
	public void setOutQ(Double outQ) {
		this.outQ = outQ;
	}
	public String getReplaceItemCode() {
		return replaceItemCode;
	}
	public void setReplaceItemCode(String replaceItemCode) {
		this.replaceItemCode = replaceItemCode;
	}
	public String getReplaceLotNo() {
		return replaceLotNo;
	}
	public void setReplaceLotNo(String replaceLotNo) {
		this.replaceLotNo = replaceLotNo;
	}
//	public Integer getReplaceSeq() {
//		return replaceSeq;
//	}
//	public void setReplaceSeq(Integer replaceSeq) {
//		this.replaceSeq = replaceSeq;
//	}
	public Double getReplaceQ() {
		return replaceQ;
	}
	public void setReplaceQ(Double replaceQ) {
		this.replaceQ = replaceQ;
	}
	public String getReplaceDate() {
		return replaceDate;
	}
	public void setReplaceDate(String replaceDate) {
		this.replaceDate = replaceDate;
	}
	public String getReplacePrsn() {
		return replacePrsn;
	}
	public void setReplacePrsn(String replacePrsn) {
		this.replacePrsn = replacePrsn;
	}
	

	
}
