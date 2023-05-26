package api.foren.pda2.dto.hspDto;

import java.io.Serializable;

public class Pdp100ukrvDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String compCode;
	private String divCode;
    private String workShopCode;
    private String inspectionDate;
    private String frTime;
    private String toTime;
    private String workPerson;
    private String inspectionRemark;
    private String nextDayFlag;
    
	private String saveFlag;

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
	public String getWorkShopCode() {
		return workShopCode;
	}
	public void setWorkShopCode(String workShopCode) {
		this.workShopCode = workShopCode;
	}
	public String getInspectionDate() {
		return inspectionDate;
	}
	public void setInspectionDate(String inspectionDate) {
		this.inspectionDate = inspectionDate;
	}
	public String getFrTime() {
		return frTime;
	}
	public void setFrTime(String frTime) {
		this.frTime = frTime;
	}
	public String getToTime() {
		return toTime;
	}
	public void setToTime(String toTime) {
		this.toTime = toTime;
	}
	public String getWorkPerson() {
		return workPerson;
	}
	public void setWorkPerson(String workPerson) {
		this.workPerson = workPerson;
	}
	public String getInspectionRemark() {
		return inspectionRemark;
	}
	public void setInspectionRemark(String inspectionRemark) {
		this.inspectionRemark = inspectionRemark;
	}
	public String getNextDayFlag() {
		return nextDayFlag;
	}
	public void setNextDayFlag(String nextDayFlag) {
		this.nextDayFlag = nextDayFlag;
	}
	
    public String getSaveFlag() {
		return saveFlag;
	}
	public void setSaveFlag(String saveFlag) {
		this.saveFlag = saveFlag;
	}
}
