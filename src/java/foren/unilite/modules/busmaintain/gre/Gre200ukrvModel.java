package foren.unilite.modules.busmaintain.gre;

import foren.framework.model.BaseVO;

public class Gre200ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    
    /* Primary Key */
    private String  COMP_CODE;
    private String  DIV_CODE;
    private String  MAINTAIN_NUM;
    private String  MAINTAIN_DATE;
    private String  MAINTAIN_TYPE;
    private Integer  VEHICLE_COUNT;
    private String  VEHICLE_CODE;
    private Integer  RUN_DISTANCE;
    
    private String  ROUTE_CODE;	
    private String  MAINTAIN_PLACE;	
    private String  START_DATE;	
    private String  START_TIME;	
    private String  END_DATE;	
    private String  END_TIME;	
    private String  MAINTAIN_GROUND;	
    private String  TASK_NUM;
    private String  OUT_FACTORY;
    private String  OURSOURCE_DESC;	
    private Integer  WORKING_TIME;	
    private Integer  WT_PER_VEHICLE;
    private String  MECHANIC_TEAM;
    private String  AM_PM;
    private Integer  MECHANIC_NUMBER;
    private Integer  WT_PER_MECHANIC;
   
    private String  REMARK;
     
	   /* Session Variables */
    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getMAINTAIN_NUM() {
		return MAINTAIN_NUM;
	}
	public void setMAINTAIN_NUM(String mAINTAIN_NUM) {
		MAINTAIN_NUM = mAINTAIN_NUM;
	}
	public String getMAINTAIN_DATE() {
		return MAINTAIN_DATE;
	}
	public void setMAINTAIN_DATE(String mAINTAIN_DATE) {
		MAINTAIN_DATE = mAINTAIN_DATE;
	}
	public String getMAINTAIN_TYPE() {
		return MAINTAIN_TYPE;
	}
	public void setMAINTAIN_TYPE(String mAINTAIN_TYPE) {
		MAINTAIN_TYPE = mAINTAIN_TYPE;
	}
	public Integer getVEHICLE_COUNT() {
		return VEHICLE_COUNT;
	}
	public void setVEHICLE_COUNT(Integer vEHICLE_COUNT) {
		VEHICLE_COUNT = vEHICLE_COUNT;
	}
	public String getVEHICLE_CODE() {
		return VEHICLE_CODE;
	}
	public void setVEHICLE_CODE(String vEHICLE_CODE) {
		VEHICLE_CODE = vEHICLE_CODE;
	}
	public Integer getRUN_DISTANCE() {
		return RUN_DISTANCE;
	}
	public void setRUN_DISTANCE(Integer rUN_DISTANCE) {
		RUN_DISTANCE = rUN_DISTANCE;
	}
	public String getROUTE_CODE() {
		return ROUTE_CODE;
	}
	public void setROUTE_CODE(String rOUTE_CODE) {
		ROUTE_CODE = rOUTE_CODE;
	}
	public String getMAINTAIN_PLACE() {
		return MAINTAIN_PLACE;
	}
	public void setMAINTAIN_PLACE(String mAINTAIN_PLACE) {
		MAINTAIN_PLACE = mAINTAIN_PLACE;
	}
	public String getSTART_DATE() {
		return START_DATE;
	}
	public void setSTART_DATE(String sTART_DATE) {
		START_DATE = sTART_DATE;
	}
	public String getSTART_TIME() {
		return START_TIME;
	}
	public void setSTART_TIME(String sTART_TIME) {
		START_TIME = sTART_TIME;
	}
	public String getEND_DATE() {
		return END_DATE;
	}
	public void setEND_DATE(String eND_DATE) {
		END_DATE = eND_DATE;
	}
	public String getEND_TIME() {
		return END_TIME;
	}
	public void setEND_TIME(String eND_TIME) {
		END_TIME = eND_TIME;
	}
	public String getMAINTAIN_GROUND() {
		return MAINTAIN_GROUND;
	}
	public void setMAINTAIN_GROUND(String mAINTAIN_GROUND) {
		MAINTAIN_GROUND = mAINTAIN_GROUND;
	}
	public String getTASK_NUM() {
		return TASK_NUM;
	}
	public void setTASK_NUM(String tASK_NUM) {
		TASK_NUM = tASK_NUM;
	}
	public String getOUT_FACTORY() {
		return OUT_FACTORY;
	}
	public void setOUT_FACTORY(String oUT_FACTORY) {
		OUT_FACTORY = oUT_FACTORY;
	}
	public String getOURSOURCE_DESC() {
		return OURSOURCE_DESC;
	}
	public void setOURSOURCE_DESC(String oURSOURCE_DESC) {
		OURSOURCE_DESC = oURSOURCE_DESC;
	}
	public Integer getWORKING_TIME() {
		return WORKING_TIME;
	}
	public void setWORKING_TIME(Integer wORKING_TIME) {
		WORKING_TIME = wORKING_TIME;
	}
	public Integer getWT_PER_VEHICLE() {
		return WT_PER_VEHICLE;
	}
	public void setWT_PER_VEHICLE(Integer wT_PER_VEHICLE) {
		WT_PER_VEHICLE = wT_PER_VEHICLE;
	}
	public String getMECHANIC_TEAM() {
		return MECHANIC_TEAM;
	}
	public void setMECHANIC_TEAM(String mECHANIC_TEAM) {
		MECHANIC_TEAM = mECHANIC_TEAM;
	}
	public String getAM_PM() {
		return AM_PM;
	}
	public void setAM_PM(String aM_PM) {
		AM_PM = aM_PM;
	}
	public Integer getMECHANIC_NUMBER() {
		return MECHANIC_NUMBER;
	}
	public void setMECHANIC_NUMBER(Integer mECHANIC_NUMBER) {
		MECHANIC_NUMBER = mECHANIC_NUMBER;
	}
	public Integer getWT_PER_MECHANIC() {
		return WT_PER_MECHANIC;
	}
	public void setWT_PER_MECHANIC(Integer wT_PER_MECHANIC) {
		WT_PER_MECHANIC = wT_PER_MECHANIC;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public String getS_AUTHORITY_LEVEL() {
		return S_AUTHORITY_LEVEL;
	}
	public void setS_AUTHORITY_LEVEL(String s_AUTHORITY_LEVEL) {
		S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	
}
