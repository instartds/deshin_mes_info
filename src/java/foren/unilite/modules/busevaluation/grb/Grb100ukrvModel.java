package foren.unilite.modules.busevaluation.grb;

import foren.framework.model.BaseVO;

public class Grb100ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String COMP_CODE;
    private String SERVICE_YEAR;
    private double IN_LARGE_GEN_FULL;
    private double IN_LARGE_GEN_PART;
    private double IN_LARGE_CTR_FULL;
    private double IN_LARGE_CTR_PART;
    private double IN_LARGE_PUB_FULL;
    private double IN_LARGE_PUB_PART;
    private double IN_MEDIUM_GEN_FULL;
    private double IN_MEDIUM_GEN_PART;
    private double IN_MEDIUM_CTR_FULL;
    private double IN_MEDIUM_CTR_PART;
    private double IN_MEDIUM_PUB_FULL;
    private double IN_MEDIUM_PUB_PART;
    private double IN_EXPRESS_GEN_FULL;
    private double IN_EXPRESS_GEN_PART;
    private double IN_NONSTOP_GEN_FULL;
    private double IN_NONSTOP_GEN_PART;
    private double OUT_SLOW_GEN_FULL;
    private double OUT_SLOW_GEN_PART;
    private double OUT_NONSTOP_GEN_FULL;
    private double OUT_NONSTOP_GEN_PART;
    private double OUT_AIR_GEN_FULL;
    private double OUT_AIR_GEN_PART;
    private double AIR_LIMIT_GEN_FULL;
    private double AIR_LIMIT_GEN_PART;
    private double ETC_VILLEAGE_GEN_FULL;
    private double ETC_VILLEAGE_GEN_PART;
    private double EXECUTIVE_FULL;
    private double EXECUTIVE_PART;
    private double ADMINISTRATIVE_FULL;
    private double ADMINISTRATIVE_PART;
    private double MECHANIC_FULL;
    private double MECHANIC_PART;
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
	public String getSERVICE_YEAR() {
		return SERVICE_YEAR;
	}
	public void setSERVICE_YEAR(String sERVICE_YEAR) {
		SERVICE_YEAR = sERVICE_YEAR;
	}
	public double getIN_LARGE_GEN_FULL() {
		return IN_LARGE_GEN_FULL;
	}
	public void setIN_LARGE_GEN_FULL(double iN_LARGE_GEN_FULL) {
		IN_LARGE_GEN_FULL = iN_LARGE_GEN_FULL;
	}
	public double getIN_LARGE_GEN_PART() {
		return IN_LARGE_GEN_PART;
	}
	public void setIN_LARGE_GEN_PART(double iN_LARGE_GEN_PART) {
		IN_LARGE_GEN_PART = iN_LARGE_GEN_PART;
	}
	public double getIN_LARGE_CTR_FULL() {
		return IN_LARGE_CTR_FULL;
	}
	public void setIN_LARGE_CTR_FULL(double iN_LARGE_CTR_FULL) {
		IN_LARGE_CTR_FULL = iN_LARGE_CTR_FULL;
	}
	public double getIN_LARGE_CTR_PART() {
		return IN_LARGE_CTR_PART;
	}
	public void setIN_LARGE_CTR_PART(double iN_LARGE_CTR_PART) {
		IN_LARGE_CTR_PART = iN_LARGE_CTR_PART;
	}
	public double getIN_LARGE_PUB_FULL() {
		return IN_LARGE_PUB_FULL;
	}
	public void setIN_LARGE_PUB_FULL(double iN_LARGE_PUB_FULL) {
		IN_LARGE_PUB_FULL = iN_LARGE_PUB_FULL;
	}
	public double getIN_LARGE_PUB_PART() {
		return IN_LARGE_PUB_PART;
	}
	public void setIN_LARGE_PUB_PART(double iN_LARGE_PUB_PART) {
		IN_LARGE_PUB_PART = iN_LARGE_PUB_PART;
	}
	public double getIN_MEDIUM_GEN_FULL() {
		return IN_MEDIUM_GEN_FULL;
	}
	public void setIN_MEDIUM_GEN_FULL(double iN_MEDIUM_GEN_FULL) {
		IN_MEDIUM_GEN_FULL = iN_MEDIUM_GEN_FULL;
	}
	public double getIN_MEDIUM_GEN_PART() {
		return IN_MEDIUM_GEN_PART;
	}
	public void setIN_MEDIUM_GEN_PART(double iN_MEDIUM_GEN_PART) {
		IN_MEDIUM_GEN_PART = iN_MEDIUM_GEN_PART;
	}
	public double getIN_MEDIUM_CTR_FULL() {
		return IN_MEDIUM_CTR_FULL;
	}
	public void setIN_MEDIUM_CTR_FULL(double iN_MEDIUM_CTR_FULL) {
		IN_MEDIUM_CTR_FULL = iN_MEDIUM_CTR_FULL;
	}
	public double getIN_MEDIUM_CTR_PART() {
		return IN_MEDIUM_CTR_PART;
	}
	public void setIN_MEDIUM_CTR_PART(double iN_MEDIUM_CTR_PART) {
		IN_MEDIUM_CTR_PART = iN_MEDIUM_CTR_PART;
	}
	public double getIN_MEDIUM_PUB_FULL() {
		return IN_MEDIUM_PUB_FULL;
	}
	public void setIN_MEDIUM_PUB_FULL(double iN_MEDIUM_PUB_FULL) {
		IN_MEDIUM_PUB_FULL = iN_MEDIUM_PUB_FULL;
	}
	public double getIN_MEDIUM_PUB_PART() {
		return IN_MEDIUM_PUB_PART;
	}
	public void setIN_MEDIUM_PUB_PART(double iN_MEDIUM_PUB_PART) {
		IN_MEDIUM_PUB_PART = iN_MEDIUM_PUB_PART;
	}
	public double getIN_EXPRESS_GEN_FULL() {
		return IN_EXPRESS_GEN_FULL;
	}
	public void setIN_EXPRESS_GEN_FULL(double iN_EXPRESS_GEN_FULL) {
		IN_EXPRESS_GEN_FULL = iN_EXPRESS_GEN_FULL;
	}
	public double getIN_EXPRESS_GEN_PART() {
		return IN_EXPRESS_GEN_PART;
	}
	public void setIN_EXPRESS_GEN_PART(double iN_EXPRESS_GEN_PART) {
		IN_EXPRESS_GEN_PART = iN_EXPRESS_GEN_PART;
	}
	public double getIN_NONSTOP_GEN_FULL() {
		return IN_NONSTOP_GEN_FULL;
	}
	public void setIN_NONSTOP_GEN_FULL(double iN_NONSTOP_GEN_FULL) {
		IN_NONSTOP_GEN_FULL = iN_NONSTOP_GEN_FULL;
	}
	public double getIN_NONSTOP_GEN_PART() {
		return IN_NONSTOP_GEN_PART;
	}
	public void setIN_NONSTOP_GEN_PART(double iN_NONSTOP_GEN_PART) {
		IN_NONSTOP_GEN_PART = iN_NONSTOP_GEN_PART;
	}
	public double getOUT_SLOW_GEN_FULL() {
		return OUT_SLOW_GEN_FULL;
	}
	public void setOUT_SLOW_GEN_FULL(double oUT_SLOW_GEN_FULL) {
		OUT_SLOW_GEN_FULL = oUT_SLOW_GEN_FULL;
	}
	public double getOUT_SLOW_GEN_PART() {
		return OUT_SLOW_GEN_PART;
	}
	public void setOUT_SLOW_GEN_PART(double oUT_SLOW_GEN_PART) {
		OUT_SLOW_GEN_PART = oUT_SLOW_GEN_PART;
	}
	public double getOUT_NONSTOP_GEN_FULL() {
		return OUT_NONSTOP_GEN_FULL;
	}
	public void setOUT_NONSTOP_GEN_FULL(double oUT_NONSTOP_GEN_FULL) {
		OUT_NONSTOP_GEN_FULL = oUT_NONSTOP_GEN_FULL;
	}
	public double getOUT_NONSTOP_GEN_PART() {
		return OUT_NONSTOP_GEN_PART;
	}
	public void setOUT_NONSTOP_GEN_PART(double oUT_NONSTOP_GEN_PART) {
		OUT_NONSTOP_GEN_PART = oUT_NONSTOP_GEN_PART;
	}
	public double getOUT_AIR_GEN_FULL() {
		return OUT_AIR_GEN_FULL;
	}
	public void setOUT_AIR_GEN_FULL(double oUT_AIR_GEN_FULL) {
		OUT_AIR_GEN_FULL = oUT_AIR_GEN_FULL;
	}
	public double getOUT_AIR_GEN_PART() {
		return OUT_AIR_GEN_PART;
	}
	public void setOUT_AIR_GEN_PART(double oUT_AIR_GEN_PART) {
		OUT_AIR_GEN_PART = oUT_AIR_GEN_PART;
	}
	public double getAIR_LIMIT_GEN_FULL() {
		return AIR_LIMIT_GEN_FULL;
	}
	public void setAIR_LIMIT_GEN_FULL(double aIR_LIMIT_GEN_FULL) {
		AIR_LIMIT_GEN_FULL = aIR_LIMIT_GEN_FULL;
	}
	public double getAIR_LIMIT_GEN_PART() {
		return AIR_LIMIT_GEN_PART;
	}
	public void setAIR_LIMIT_GEN_PART(double aIR_LIMIT_GEN_PART) {
		AIR_LIMIT_GEN_PART = aIR_LIMIT_GEN_PART;
	}
	public double getETC_VILLEAGE_GEN_FULL() {
		return ETC_VILLEAGE_GEN_FULL;
	}
	public void setETC_VILLEAGE_GEN_FULL(double eTC_VILLEAGE_GEN_FULL) {
		ETC_VILLEAGE_GEN_FULL = eTC_VILLEAGE_GEN_FULL;
	}
	public double getETC_VILLEAGE_GEN_PART() {
		return ETC_VILLEAGE_GEN_PART;
	}
	public void setETC_VILLEAGE_GEN_PART(double eTC_VILLEAGE_GEN_PART) {
		ETC_VILLEAGE_GEN_PART = eTC_VILLEAGE_GEN_PART;
	}
	public double getEXECUTIVE_FULL() {
		return EXECUTIVE_FULL;
	}
	public void setEXECUTIVE_FULL(double eXECUTIVE_FULL) {
		EXECUTIVE_FULL = eXECUTIVE_FULL;
	}
	public double getEXECUTIVE_PART() {
		return EXECUTIVE_PART;
	}
	public void setEXECUTIVE_PART(double eXECUTIVE_PART) {
		EXECUTIVE_PART = eXECUTIVE_PART;
	}
	public double getADMINISTRATIVE_FULL() {
		return ADMINISTRATIVE_FULL;
	}
	public void setADMINISTRATIVE_FULL(double aDMINISTRATIVE_FULL) {
		ADMINISTRATIVE_FULL = aDMINISTRATIVE_FULL;
	}
	public double getADMINISTRATIVE_PART() {
		return ADMINISTRATIVE_PART;
	}
	public void setADMINISTRATIVE_PART(double aDMINISTRATIVE_PART) {
		ADMINISTRATIVE_PART = aDMINISTRATIVE_PART;
	}
	public double getMECHANIC_FULL() {
		return MECHANIC_FULL;
	}
	public void setMECHANIC_FULL(double mECHANIC_FULL) {
		MECHANIC_FULL = mECHANIC_FULL;
	}
	public double getMECHANIC_PART() {
		return MECHANIC_PART;
	}
	public void setMECHANIC_PART(double mECHANIC_PART) {
		MECHANIC_PART = mECHANIC_PART;
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
