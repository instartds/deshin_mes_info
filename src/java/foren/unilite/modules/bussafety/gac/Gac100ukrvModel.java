package foren.unilite.modules.bussafety.gac;

import foren.framework.model.BaseVO;

public class Gac100ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String  COMP_CODE;
    private String  DIV_CODE;
    private String  ACCIDENT_NUM;
    private String  REGIST_DATE;
    private String  REGIST_TIME;
    private String  REGIST_PERSON_TYPE;
    private String  REGIST_PERSON;
    private String  ACCIDENT_DATE;
    private String  ACCIDENT_TIME;
    private String  VEHICLE_CODE;
    private String  DRIVER_CODE;
    private String  DRIVER_PHONE;
    private String  LICENCE_NUM;
    private String  EMPLOYMENT_PERIOD;
    private String  AGE;
    private String  EXPERIENCE_PERIOD;
    private String  MOBILE_PHONE;
    private String  DRIVER_TYPE;
    private String  ROUTE_CODE;
    private String  SURFACE_ROAD;
    private String  WHEATHER;
    private String  ACCIDENT_TYPE;
    private String  ACCIDENT_DIV;
    private String  MANAGE_DIV;
    private String  MANAGE_DATE;
    private String  APPROVAL_DATE;
    private String  ROAD_DIV;
    private String  ROAD_TYPE;
    private String  ACCIDENT_CAUSE;
    private String  ACCICENT_COURSE;
    private String   DRIVER_FAULT;
    private String   OTHER_FAULT;
    private String  ACCIDENT_PLACE;
    private String  PLACE_TYPE;
    private String  ACCIDENT_REPORT_TYPE;
    private String  POLICE_OFFICE;
    private String  POLICE_INCHARGE;
    private String  CASE_NUM;
    private String  POLICE_ACC_NUM;
    private String  POLICE_REPORT_NUM;
    private String  TEAM;
    private String  SPECIAL_EDU_YN;
    private String  OFFICE_CODE;
    private String  ACCIDENT_DESC;
    private String  COMMENTS;
    private String  SPECIAL_FEATURE;
    private String	DOC_NO;
    private String	CLAIM_NO;
    private String	CLAIM_DATE;
    private String	CLAIM_TIME;
    private String	CLAIM_PERSON;
    private String	VICTIM_INS_PRSN;
    private String	PROPERTY_INS_PRSN;
    private String	INFORM_PRSN;
    private String	INFORM_INS_TEL;

    
    
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
	public String getACCIDENT_NUM() {
		return ACCIDENT_NUM;
	}
	public void setACCIDENT_NUM(String aCCIDENT_NUM) {
		ACCIDENT_NUM = aCCIDENT_NUM;
	}
	public String getREGIST_DATE() {
		return REGIST_DATE;
	}
	public void setREGIST_DATE(String rEGIST_DATE) {
		REGIST_DATE = rEGIST_DATE;
	}
	public String getREGIST_TIME() {
		return REGIST_TIME;
	}
	public void setREGIST_TIME(String rEGIST_TIME) {
		REGIST_TIME = rEGIST_TIME;
	}
	public String getREGIST_PERSON_TYPE() {
		return REGIST_PERSON_TYPE;
	}
	public void setREGIST_PERSON_TYPE(String rEGIST_PERSON_TYPE) {
		REGIST_PERSON_TYPE = rEGIST_PERSON_TYPE;
	}
	public String getREGIST_PERSON() {
		return REGIST_PERSON;
	}
	public void setREGIST_PERSON(String rEGIST_PERSON) {
		REGIST_PERSON = rEGIST_PERSON;
	}
	public String getACCIDENT_DATE() {
		return ACCIDENT_DATE;
	}
	public void setACCIDENT_DATE(String aCCIDENT_DATE) {
		ACCIDENT_DATE = aCCIDENT_DATE;
	}
	public String getACCIDENT_TIME() {
		return ACCIDENT_TIME;
	}
	public void setACCIDENT_TIME(String aCCIDENT_TIME) {
		ACCIDENT_TIME = aCCIDENT_TIME;
	}
	public String getVEHICLE_CODE() {
		return VEHICLE_CODE;
	}
	public void setVEHICLE_CODE(String vEHICLE_CODE) {
		VEHICLE_CODE = vEHICLE_CODE;
	}
	public String getDRIVER_CODE() {
		return DRIVER_CODE;
	}
	public void setDRIVER_CODE(String dRIVER_CODE) {
		DRIVER_CODE = dRIVER_CODE;
	}
	public String getDRIVER_PHONE() {
		return DRIVER_PHONE;
	}
	public void setDRIVER_PHONE(String dRIVER_PHONE) {
		DRIVER_PHONE = dRIVER_PHONE;
	}
	public String getLICENCE_NUM() {
		return LICENCE_NUM;
	}
	public void setLICENCE_NUM(String lICENCE_NUM) {
		LICENCE_NUM = lICENCE_NUM;
	}
	public String getEMPLOYMENT_PERIOD() {
		return EMPLOYMENT_PERIOD;
	}
	public void setEMPLOYMENT_PERIOD(String eMPLOYMENT_PERIOD) {
		EMPLOYMENT_PERIOD = eMPLOYMENT_PERIOD;
	}
	public String getAGE() {
		return AGE;
	}
	public void setAGE(String aGE) {
		AGE = aGE;
	}
	public String getEXPERIENCE_PERIOD() {
		return EXPERIENCE_PERIOD;
	}
	public void setEXPERIENCE_PERIOD(String eXPERIENCE_PERIOD) {
		EXPERIENCE_PERIOD = eXPERIENCE_PERIOD;
	}
	public String getMOBILE_PHONE() {
		return MOBILE_PHONE;
	}
	public void setMOBILE_PHONE(String mOBILE_PHONE) {
		MOBILE_PHONE = mOBILE_PHONE;
	}
	public String getDRIVER_TYPE() {
		return DRIVER_TYPE;
	}
	public void setDRIVER_TYPE(String dRIVER_TYPE) {
		DRIVER_TYPE = dRIVER_TYPE;
	}
	public String getROUTE_CODE() {
		return ROUTE_CODE;
	}
	public void setROUTE_CODE(String rOUTE_CODE) {
		ROUTE_CODE = rOUTE_CODE;
	}
	public String getSURFACE_ROAD() {
		return SURFACE_ROAD;
	}
	public void setSURFACE_ROAD(String sURFACE_ROAD) {
		SURFACE_ROAD = sURFACE_ROAD;
	}
	public String getWHEATHER() {
		return WHEATHER;
	}
	public void setWHEATHER(String wHEATHER) {
		WHEATHER = wHEATHER;
	}
	public String getACCIDENT_TYPE() {
		return ACCIDENT_TYPE;
	}
	public void setACCIDENT_TYPE(String aCCIDENT_TYPE) {
		ACCIDENT_TYPE = aCCIDENT_TYPE;
	}
	public String getACCIDENT_DIV() {
		return ACCIDENT_DIV;
	}
	public void setACCIDENT_DIV(String aCCIDENT_DIV) {
		ACCIDENT_DIV = aCCIDENT_DIV;
	}
	public String getMANAGE_DIV() {
		return MANAGE_DIV;
	}
	public void setMANAGE_DIV(String mANAGE_DIV) {
		MANAGE_DIV = mANAGE_DIV;
	}
	public String getMANAGE_DATE() {
		return MANAGE_DATE;
	}
	public void setMANAGE_DATE(String mANAGE_DATE) {
		MANAGE_DATE = mANAGE_DATE;
	}
	public String getAPPROVAL_DATE() {
		return APPROVAL_DATE;
	}
	public void setAPPROVAL_DATE(String aPPROVAL_DATE) {
		APPROVAL_DATE = aPPROVAL_DATE;
	}
	public String getROAD_DIV() {
		return ROAD_DIV;
	}
	public void setROAD_DIV(String rOAD_DIV) {
		ROAD_DIV = rOAD_DIV;
	}
	public String getROAD_TYPE() {
		return ROAD_TYPE;
	}
	public void setROAD_TYPE(String rOAD_TYPE) {
		ROAD_TYPE = rOAD_TYPE;
	}
	public String getACCIDENT_CAUSE() {
		return ACCIDENT_CAUSE;
	}
	public void setACCIDENT_CAUSE(String aCCIDENT_CAUSE) {
		ACCIDENT_CAUSE = aCCIDENT_CAUSE;
	}
	public String getACCICENT_COURSE() {
		return ACCICENT_COURSE;
	}
	public void setACCICENT_COURSE(String aCCICENT_COURSE) {
		ACCICENT_COURSE = aCCICENT_COURSE;
	}
	public String getDRIVER_FAULT() {
		return DRIVER_FAULT;
	}
	public void setDRIVER_FAULT(String dRIVER_FAULT) {
		DRIVER_FAULT = dRIVER_FAULT;
	}
	public String getOTHER_FAULT() {
		return OTHER_FAULT;
	}
	public void setOTHER_FAULT(String oTHER_FAULT) {
		OTHER_FAULT = oTHER_FAULT;
	}
	public String getACCIDENT_PLACE() {
		return ACCIDENT_PLACE;
	}
	public void setACCIDENT_PLACE(String aCCIDENT_PLACE) {
		ACCIDENT_PLACE = aCCIDENT_PLACE;
	}
	public String getPLACE_TYPE() {
		return PLACE_TYPE;
	}
	public void setPLACE_TYPE(String pLACE_TYPE) {
		PLACE_TYPE = pLACE_TYPE;
	}
	public String getACCIDENT_REPORT_TYPE() {
		return ACCIDENT_REPORT_TYPE;
	}
	public void setACCIDENT_REPORT_TYPE(String aCCIDENT_REPORT_TYPE) {
		ACCIDENT_REPORT_TYPE = aCCIDENT_REPORT_TYPE;
	}
	public String getPOLICE_OFFICE() {
		return POLICE_OFFICE;
	}
	public void setPOLICE_OFFICE(String pOLICE_OFFICE) {
		POLICE_OFFICE = pOLICE_OFFICE;
	}
	public String getPOLICE_INCHARGE() {
		return POLICE_INCHARGE;
	}
	public void setPOLICE_INCHARGE(String pOLICE_INCHARGE) {
		POLICE_INCHARGE = pOLICE_INCHARGE;
	}
	public String getCASE_NUM() {
		return CASE_NUM;
	}
	public void setCASE_NUM(String cASE_NUM) {
		CASE_NUM = cASE_NUM;
	}
	public String getPOLICE_ACC_NUM() {
		return POLICE_ACC_NUM;
	}
	public void setPOLICE_ACC_NUM(String pOLICE_ACC_NUM) {
		POLICE_ACC_NUM = pOLICE_ACC_NUM;
	}
	public String getPOLICE_REPORT_NUM() {
		return POLICE_REPORT_NUM;
	}
	public void setPOLICE_REPORT_NUM(String pOLICE_REPORT_NUM) {
		POLICE_REPORT_NUM = pOLICE_REPORT_NUM;
	}
	public String getTEAM() {
		return TEAM;
	}
	public void setTEAM(String tEAM) {
		TEAM = tEAM;
	}
	public String getSPECIAL_EDU_YN() {
		return SPECIAL_EDU_YN;
	}
	public void setSPECIAL_EDU_YN(String sPECIAL_EDU_YN) {
		SPECIAL_EDU_YN = sPECIAL_EDU_YN;
	}
	public String getOFFICE_CODE() {
		return OFFICE_CODE;
	}
	public void setOFFICE_CODE(String oFFICE_CODE) {
		OFFICE_CODE = oFFICE_CODE;
	}
	public String getACCIDENT_DESC() {
		return ACCIDENT_DESC;
	}
	public void setACCIDENT_DESC(String aCCIDENT_DESC) {
		ACCIDENT_DESC = aCCIDENT_DESC;
	}
	public String getCOMMENTS() {
		return COMMENTS;
	}
	public void setCOMMENTS(String cOMMENTS) {
		COMMENTS = cOMMENTS;
	}
	public String getSPECIAL_FEATURE() {
		return SPECIAL_FEATURE;
	}
	public void setSPECIAL_FEATURE(String sPECIAL_FEATURE) {
		SPECIAL_FEATURE = sPECIAL_FEATURE;
	}
	public String getDOC_NO() {
		return DOC_NO;
	}
	public void setDOC_NO(String dOC_NO) {
		DOC_NO = dOC_NO;
	}	
	public String getCLAIM_NO() {
		return CLAIM_NO;
	}
	public void setCLAIM_NO(String cLAIM_NO) {
		CLAIM_NO = cLAIM_NO;
	}
	public String getCLAIM_DATE() {
		return CLAIM_DATE;
	}
	public void setCLAIM_DATE(String cLAIM_DATE) {
		CLAIM_DATE = cLAIM_DATE;
	}
	public String getCLAIM_TIME() {
		return CLAIM_TIME;
	}
	public void setCLAIM_TIME(String cLAIM_TIME) {
		CLAIM_TIME = cLAIM_TIME;
	}
	public String getCLAIM_PERSON() {
		return CLAIM_PERSON;
	}
	public void setCLAIM_PERSON(String cLAIM_PERSON) {
		CLAIM_PERSON = cLAIM_PERSON;
	}
	public String getVICTIM_INS_PRSN() {
		return VICTIM_INS_PRSN;
	}
	public void setVICTIM_INS_PRSN(String vICTIM_INS_PRSN) {
		VICTIM_INS_PRSN = vICTIM_INS_PRSN;
	}
	public String getPROPERTY_INS_PRSN() {
		return PROPERTY_INS_PRSN;
	}
	public void setPROPERTY_INS_PRSN(String pROPERTY_INS_PRSN) {
		PROPERTY_INS_PRSN = pROPERTY_INS_PRSN;
	}
	public String getINFORM_PRSN() {
		return INFORM_PRSN;
	}
	public void setINFORM_PRSN(String iNFORM_PRSN) {
		INFORM_PRSN = iNFORM_PRSN;
	}
	public String getINFORM_INS_TEL() {
		return INFORM_INS_TEL;
	}
	public void setINFORM_INS_TEL(String iNFORM_INS_TEL) {
		INFORM_INS_TEL = iNFORM_INS_TEL;
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
