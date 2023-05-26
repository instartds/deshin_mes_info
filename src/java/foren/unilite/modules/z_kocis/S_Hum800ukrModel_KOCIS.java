package foren.unilite.modules.z_kocis;

import foren.framework.model.BaseVO;

public class S_Hum800ukrModel_KOCIS extends BaseVO {

    private static final long serialVersionUID = 1L;
    
    private String S_COMP_CODE;
    private String S_USER_ID;
    
    private String PERSON_NUMB;
    private String INSURANCE_NAME;
    private String INSURANCE_NO;
    private String INSURANCE_COMPANY;
    private Double INSURANCE_FARE;
    private String GUARANTEE_PERIOD_FR;
    private String GUARANTEE_PERIOD_TO;
    private String GUARANTOR1_NAME;
    private String GUARANTOR1_RELATION;
    private String GUARANTOR1_RES_NO;
    private String GUARANTOR1_PERIOD_FR;
    private String GUARANTOR1_PERIOD_TO;
    private String GUARANTOR1_WORK_ZONE;
    private String GUARANTOR1_CLASS;
    private Double GUARANTOR1_INCOMETAX;
    private String GUARANTOR1_ZIP_CODE;
    private String GUARANTOR1_ADDR;
    private String GUARANTOR1_ADDR_DE;
    private String GUARANTOR2_NAME;
    private String GUARANTOR2_RELATION;
    private String GUARANTOR2_RES_NO;
    private String GUARANTOR2_PERIOD_FR;
    private String GUARANTOR2_PERIOD_TO;
    private String GUARANTOR2_WORK_ZONE;
    private String GUARANTOR2_CLASS;
    private Double GUARANTOR2_INCOMETAX;
    private String GUARANTOR2_ZIP_CODE;
    private String GUARANTOR2_ADDR;
    private String GUARANTOR2_ADDR_DE;
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getPERSON_NUMB() {
		return PERSON_NUMB;
	}
	public void setPERSON_NUMB(String pERSON_NUMB) {
		PERSON_NUMB = pERSON_NUMB;
	}
	public String getINSURANCE_NAME() {
		return INSURANCE_NAME;
	}
	public void setINSURANCE_NAME(String iNSURANCE_NAME) {
		INSURANCE_NAME = iNSURANCE_NAME;
	}
	public String getINSURANCE_NO() {
		return INSURANCE_NO;
	}
	public void setINSURANCE_NO(String iNSURANCE_NO) {
		INSURANCE_NO = iNSURANCE_NO;
	}
	public String getINSURANCE_COMPANY() {
		return INSURANCE_COMPANY;
	}
	public void setINSURANCE_COMPANY(String iNSURANCE_COMPANY) {
		INSURANCE_COMPANY = iNSURANCE_COMPANY;
	}
	public Double getINSURANCE_FARE() {
		return INSURANCE_FARE;
	}
	public void setINSURANCE_FARE(Double iNSURANCE_FARE) {
		if(iNSURANCE_FARE == null)	{
			INSURANCE_FARE = 0.0;
		}else {
			INSURANCE_FARE = iNSURANCE_FARE;
		}
	}
	public String getGUARANTEE_PERIOD_FR() {
		return GUARANTEE_PERIOD_FR;
	}
	public void setGUARANTEE_PERIOD_FR(String gUARANTEE_PERIOD_FR) {
		GUARANTEE_PERIOD_FR = gUARANTEE_PERIOD_FR;
	}
	public String getGUARANTEE_PERIOD_TO() {
		return GUARANTEE_PERIOD_TO;
	}
	public void setGUARANTEE_PERIOD_TO(String gUARANTEE_PERIOD_TO) {
		GUARANTEE_PERIOD_TO = gUARANTEE_PERIOD_TO;
	}
	public String getGUARANTOR1_NAME() {
		return GUARANTOR1_NAME;
	}
	public void setGUARANTOR1_NAME(String gUARANTOR1_NAME) {
		GUARANTOR1_NAME = gUARANTOR1_NAME;
	}
	public String getGUARANTOR1_RELATION() {
		return GUARANTOR1_RELATION;
	}
	public void setGUARANTOR1_RELATION(String gUARANTOR1_RELATION) {
		GUARANTOR1_RELATION = gUARANTOR1_RELATION;
	}
	public String getGUARANTOR1_RES_NO() {
		return GUARANTOR1_RES_NO;
	}
	public void setGUARANTOR1_RES_NO(String gUARANTOR1_RES_NO) {
		GUARANTOR1_RES_NO = gUARANTOR1_RES_NO;
	}
	public String getGUARANTOR1_PERIOD_FR() {
		return GUARANTOR1_PERIOD_FR;
	}
	public void setGUARANTOR1_PERIOD_FR(String gUARANTOR1_PERIOD_FR) {
		GUARANTOR1_PERIOD_FR = gUARANTOR1_PERIOD_FR;
	}
	public String getGUARANTOR1_PERIOD_TO() {
		return GUARANTOR1_PERIOD_TO;
	}
	public void setGUARANTOR1_PERIOD_TO(String gUARANTOR1_PERIOD_TO) {
		GUARANTOR1_PERIOD_TO = gUARANTOR1_PERIOD_TO;
	}
	public String getGUARANTOR1_WORK_ZONE() {
		return GUARANTOR1_WORK_ZONE;
	}
	public void setGUARANTOR1_WORK_ZONE(String gUARANTOR1_WORK_ZONE) {
		GUARANTOR1_WORK_ZONE = gUARANTOR1_WORK_ZONE;
	}
	public String getGUARANTOR1_CLASS() {
		return GUARANTOR1_CLASS;
	}
	public void setGUARANTOR1_CLASS(String gUARANTOR1_CLASS) {
		GUARANTOR1_CLASS = gUARANTOR1_CLASS;
	}
	public Double getGUARANTOR1_INCOMETAX() {
		return GUARANTOR1_INCOMETAX;
	}
	public void setGUARANTOR1_INCOMETAX(Double gUARANTOR1_INCOMETAX) {
		if(gUARANTOR1_INCOMETAX == null)	{
			GUARANTOR1_INCOMETAX = 0.0;
		}else {
			GUARANTOR1_INCOMETAX = gUARANTOR1_INCOMETAX;
		}
	}
	public String getGUARANTOR1_ZIP_CODE() {
		return GUARANTOR1_ZIP_CODE;
	}
	public void setGUARANTOR1_ZIP_CODE(String gUARANTOR1_ZIP_CODE) {
		GUARANTOR1_ZIP_CODE = gUARANTOR1_ZIP_CODE;
	}
	public String getGUARANTOR1_ADDR() {
		return GUARANTOR1_ADDR;
	}
	public void setGUARANTOR1_ADDR(String gUARANTOR1_ADDR) {
		GUARANTOR1_ADDR = gUARANTOR1_ADDR;
	}
	public String getGUARANTOR1_ADDR_DE() {
		return GUARANTOR1_ADDR_DE;
	}
	public void setGUARANTOR1_ADDR_DE(String gUARANTOR1_ADDR_DE) {
		GUARANTOR1_ADDR_DE = gUARANTOR1_ADDR_DE;
	}
	public String getGUARANTOR2_NAME() {
		return GUARANTOR2_NAME;
	}
	public void setGUARANTOR2_NAME(String gUARANTOR2_NAME) {
		GUARANTOR2_NAME = gUARANTOR2_NAME;
	}
	public String getGUARANTOR2_RELATION() {
		return GUARANTOR2_RELATION;
	}
	public void setGUARANTOR2_RELATION(String gUARANTOR2_RELATION) {
		GUARANTOR2_RELATION = gUARANTOR2_RELATION;
	}
	public String getGUARANTOR2_RES_NO() {
		return GUARANTOR2_RES_NO;
	}
	public void setGUARANTOR2_RES_NO(String gUARANTOR2_RES_NO) {
		GUARANTOR2_RES_NO = gUARANTOR2_RES_NO;
	}
	public String getGUARANTOR2_PERIOD_FR() {
		return GUARANTOR2_PERIOD_FR;
	}
	public void setGUARANTOR2_PERIOD_FR(String gUARANTOR2_PERIOD_FR) {
		GUARANTOR2_PERIOD_FR = gUARANTOR2_PERIOD_FR;
	}
	public String getGUARANTOR2_PERIOD_TO() {
		return GUARANTOR2_PERIOD_TO;
	}
	public void setGUARANTOR2_PERIOD_TO(String gUARANTOR2_PERIOD_TO) {
		GUARANTOR2_PERIOD_TO = gUARANTOR2_PERIOD_TO;
	}
	public String getGUARANTOR2_WORK_ZONE() {
		return GUARANTOR2_WORK_ZONE;
	}
	public void setGUARANTOR2_WORK_ZONE(String gUARANTOR2_WORK_ZONE) {
		GUARANTOR2_WORK_ZONE = gUARANTOR2_WORK_ZONE;
	}
	public String getGUARANTOR2_CLASS() {
		return GUARANTOR2_CLASS;
	}
	public void setGUARANTOR2_CLASS(String gUARANTOR2_CLASS) {
		GUARANTOR2_CLASS = gUARANTOR2_CLASS;
	}
	public Double getGUARANTOR2_INCOMETAX() {
		return GUARANTOR2_INCOMETAX;
	}
	public void setGUARANTOR2_INCOMETAX(Double gUARANTOR2_INCOMETAX) {
		if(gUARANTOR2_INCOMETAX == null)	{
			GUARANTOR2_INCOMETAX = 0.0;
		}else {
			GUARANTOR2_INCOMETAX = gUARANTOR2_INCOMETAX;
		}
	}
	public String getGUARANTOR2_ZIP_CODE() {
		return GUARANTOR2_ZIP_CODE;
	}
	public void setGUARANTOR2_ZIP_CODE(String gUARANTOR2_ZIP_CODE) {
		GUARANTOR2_ZIP_CODE = gUARANTOR2_ZIP_CODE;
	}
	public String getGUARANTOR2_ADDR() {
		return GUARANTOR2_ADDR;
	}
	public void setGUARANTOR2_ADDR(String gUARANTOR2_ADDR) {
		GUARANTOR2_ADDR = gUARANTOR2_ADDR;
	}
	public String getGUARANTOR2_ADDR_DE() {
		return GUARANTOR2_ADDR_DE;
	}
	public void setGUARANTOR2_ADDR_DE(String gUARANTOR2_ADDR_DE) {
		GUARANTOR2_ADDR_DE = gUARANTOR2_ADDR_DE;
	}
	
}
