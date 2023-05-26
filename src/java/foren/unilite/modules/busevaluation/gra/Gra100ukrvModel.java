package foren.unilite.modules.busevaluation.gra;

import foren.framework.model.BaseVO;

public class Gra100ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String COMP_CODE;
    private String SERVICE_YEAR;
    private String COMP_NAME;
    private String COMP_ID;
    private String COMPANY_NUM;
    private String ADDR1;
    private String ADDR2;
    private String ADDR3;
    private String ADDR4;
    private double CAPITAL_AMT;
    private String STOCKHOLDER_NUM;
    private String STOCKHOLDER_NAME1;
    private String STOCKHOLDER_NAME2;
    private String STOCKHOLDER_NAME3;
    private String STOCKHOLDER_NAME4;
    private double STOCK_NUM1;
    private double STOCK_NUM2;
    private double STOCK_NUM3;
    private double STOCK_NUM4;
    private double STOCK_NUM_ETC;
    private double STOCK_NUM_TOT;
    private double EXECUTIVE_NUM;
    private double ADMINISTRATIVE_NUM;
    private double DRIVER_NUM;
    private double MECHANIC_NUM;
    private double IN_LARGE_GEN;
    private double IN_LARGE_CTR;
    private double IN_LARGE_PUB;
    private double IN_MEDIUM_GEN;
    private double IN_MEDIUM_CTR;
    private double IN_MEDIUM_PUB;
    private double IN_EXPRESS_GEN;
    private double IN_NONSTOP_GEN;
    private double OUT_SLOW_GEN;
    private double OUT_NONSTOP_GEN;
    private double OUT_AIR_GEN;
    private double AIR_LIMIT_GEN;
    private double ETC_VILLEAGE_GEN;
    private String UPDATE_DB_USER;
   public String getUPDATE_DB_USER() {
		return UPDATE_DB_USER;
	}
	public void setUPDATE_DB_USER(String uPDATE_DB_USER) {
		UPDATE_DB_USER = uPDATE_DB_USER;
	}
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
	public String getCOMP_NAME() {
		return COMP_NAME;
	}
	public void setCOMP_NAME(String cOMP_NAME) {
		COMP_NAME = cOMP_NAME;
	}
	public String getCOMP_ID() {
		return COMP_ID;
	}
	public void setCOMP_ID(String cOMP_ID) {
		COMP_ID = cOMP_ID;
	}
	public String getCOMPANY_NUM() {
		return COMPANY_NUM;
	}
	public void setCOMPANY_NUM(String cOMPANY_NUM) {
		COMPANY_NUM = cOMPANY_NUM;
	}
	public String getADDR1() {
		return ADDR1;
	}
	public void setADDR1(String aDDR1) {
		ADDR1 = aDDR1;
	}
	public String getADDR2() {
		return ADDR2;
	}
	public void setADDR2(String aDDR2) {
		ADDR2 = aDDR2;
	}
	public String getADDR3() {
		return ADDR3;
	}
	public void setADDR3(String aDDR3) {
		ADDR3 = aDDR3;
	}
	public String getADDR4() {
		return ADDR4;
	}
	public void setADDR4(String aDDR4) {
		ADDR4 = aDDR4;
	}
	public double getCAPITAL_AMT() {
		return CAPITAL_AMT;
	}
	public void setCAPITAL_AMT(double cAPITAL_AMT) {
		CAPITAL_AMT = cAPITAL_AMT;
	}
	public String getSTOCKHOLDER_NUM() {
		return STOCKHOLDER_NUM;
	}
	public void setSTOCKHOLDER_NUM(String sTOCKHOLDER_NUM) {
		STOCKHOLDER_NUM = sTOCKHOLDER_NUM;
	}
	public String getSTOCKHOLDER_NAME1() {
		return STOCKHOLDER_NAME1;
	}
	public void setSTOCKHOLDER_NAME1(String sTOCKHOLDER_NAME1) {
		STOCKHOLDER_NAME1 = sTOCKHOLDER_NAME1;
	}
	public String getSTOCKHOLDER_NAME2() {
		return STOCKHOLDER_NAME2;
	}
	public void setSTOCKHOLDER_NAME2(String sTOCKHOLDER_NAME2) {
		STOCKHOLDER_NAME2 = sTOCKHOLDER_NAME2;
	}
	public String getSTOCKHOLDER_NAME3() {
		return STOCKHOLDER_NAME3;
	}
	public void setSTOCKHOLDER_NAME3(String sTOCKHOLDER_NAME3) {
		STOCKHOLDER_NAME3 = sTOCKHOLDER_NAME3;
	}
	public String getSTOCKHOLDER_NAME4() {
		return STOCKHOLDER_NAME4;
	}
	public void setSTOCKHOLDER_NAME4(String sTOCKHOLDER_NAME4) {
		STOCKHOLDER_NAME4 = sTOCKHOLDER_NAME4;
	}
	public double getSTOCK_NUM1() {
		return STOCK_NUM1;
	}
	public void setSTOCK_NUM1(double sTOCK_NUM1) {
		STOCK_NUM1 = sTOCK_NUM1;
	}
	public double getSTOCK_NUM2() {
		return STOCK_NUM2;
	}
	public void setSTOCK_NUM2(double sTOCK_NUM2) {
		STOCK_NUM2 = sTOCK_NUM2;
	}
	public double getSTOCK_NUM3() {
		return STOCK_NUM3;
	}
	public void setSTOCK_NUM3(double sTOCK_NUM3) {
		STOCK_NUM3 = sTOCK_NUM3;
	}
	public double getSTOCK_NUM4() {
		return STOCK_NUM4;
	}
	public void setSTOCK_NUM4(double sTOCK_NUM4) {
		STOCK_NUM4 = sTOCK_NUM4;
	}
	public double getSTOCK_NUM_ETC() {
		return STOCK_NUM_ETC;
	}
	public void setSTOCK_NUM_ETC(double sTOCK_NUM_ETC) {
		STOCK_NUM_ETC = sTOCK_NUM_ETC;
	}
	public double getSTOCK_NUM_TOT() {
		return STOCK_NUM_TOT;
	}
	public void setSTOCK_NUM_TOT(double sTOCK_NUM_TOT) {
		STOCK_NUM_TOT = sTOCK_NUM_TOT;
	}
	public double getEXECUTIVE_NUM() {
		return EXECUTIVE_NUM;
	}
	public void setEXECUTIVE_NUM(double eXECUTIVE_NUM) {
		EXECUTIVE_NUM = eXECUTIVE_NUM;
	}
	public double getADMINISTRATIVE_NUM() {
		return ADMINISTRATIVE_NUM;
	}
	public void setADMINISTRATIVE_NUM(double aDMINISTRATIVE_NUM) {
		ADMINISTRATIVE_NUM = aDMINISTRATIVE_NUM;
	}
	public double getDRIVER_NUM() {
		return DRIVER_NUM;
	}
	public void setDRIVER_NUM(double dRIVER_NUM) {
		DRIVER_NUM = dRIVER_NUM;
	}
	public double getMECHANIC_NUM() {
		return MECHANIC_NUM;
	}
	public void setMECHANIC_NUM(double mECHANIC_NUM) {
		MECHANIC_NUM = mECHANIC_NUM;
	}
	public double getIN_LARGE_GEN() {
		return IN_LARGE_GEN;
	}
	public void setIN_LARGE_GEN(double iN_LARGE_GEN) {
		IN_LARGE_GEN = iN_LARGE_GEN;
	}
	public double getIN_LARGE_CTR() {
		return IN_LARGE_CTR;
	}
	public void setIN_LARGE_CTR(double iN_LARGE_CTR) {
		IN_LARGE_CTR = iN_LARGE_CTR;
	}
	public double getIN_LARGE_PUB() {
		return IN_LARGE_PUB;
	}
	public void setIN_LARGE_PUB(double iN_LARGE_PUB) {
		IN_LARGE_PUB = iN_LARGE_PUB;
	}
	public double getIN_MEDIUM_GEN() {
		return IN_MEDIUM_GEN;
	}
	public void setIN_MEDIUM_GEN(double iN_MEDIUM_GEN) {
		IN_MEDIUM_GEN = iN_MEDIUM_GEN;
	}
	public double getIN_MEDIUM_CTR() {
		return IN_MEDIUM_CTR;
	}
	public void setIN_MEDIUM_CTR(double iN_MEDIUM_CTR) {
		IN_MEDIUM_CTR = iN_MEDIUM_CTR;
	}
	public double getIN_MEDIUM_PUB() {
		return IN_MEDIUM_PUB;
	}
	public void setIN_MEDIUM_PUB(double iN_MEDIUM_PUB) {
		IN_MEDIUM_PUB = iN_MEDIUM_PUB;
	}
	public double getIN_EXPRESS_GEN() {
		return IN_EXPRESS_GEN;
	}
	public void setIN_EXPRESS_GEN(double iN_EXPRESS_GEN) {
		IN_EXPRESS_GEN = iN_EXPRESS_GEN;
	}
	public double getIN_NONSTOP_GEN() {
		return IN_NONSTOP_GEN;
	}
	public void setIN_NONSTOP_GEN(double iN_NONSTOP_GEN) {
		IN_NONSTOP_GEN = iN_NONSTOP_GEN;
	}
	public double getOUT_SLOW_GEN() {
		return OUT_SLOW_GEN;
	}
	public void setOUT_SLOW_GEN(double oUT_SLOW_GEN) {
		OUT_SLOW_GEN = oUT_SLOW_GEN;
	}
	public double getOUT_NONSTOP_GEN() {
		return OUT_NONSTOP_GEN;
	}
	public void setOUT_NONSTOP_GEN(double oUT_NONSTOP_GEN) {
		OUT_NONSTOP_GEN = oUT_NONSTOP_GEN;
	}
	public double getOUT_AIR_GEN() {
		return OUT_AIR_GEN;
	}
	public void setOUT_AIR_GEN(double oUT_AIR_GEN) {
		OUT_AIR_GEN = oUT_AIR_GEN;
	}
	public double getAIR_LIMIT_GEN() {
		return AIR_LIMIT_GEN;
	}
	public void setAIR_LIMIT_GEN(double aIR_LIMIT_GEN) {
		AIR_LIMIT_GEN = aIR_LIMIT_GEN;
	}
	public double getETC_VILLEAGE_GEN() {
		return ETC_VILLEAGE_GEN;
	}
	public void setETC_VILLEAGE_GEN(double eTC_VILLEAGE_GEN) {
		ETC_VILLEAGE_GEN = eTC_VILLEAGE_GEN;
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
