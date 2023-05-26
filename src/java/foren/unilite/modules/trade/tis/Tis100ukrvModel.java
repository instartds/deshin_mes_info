package foren.unilite.modules.trade.tis;

import foren.framework.model.BaseVO;

public class Tis100ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    private String KEY_VALUE;         
    private String OPR_FLAG;          
    private String COMP_CODE;         
    private String DIV_CODE;         
    private String BL_SER_NO;         
    private String SO_SER_NO;         
    private String BL_NO;         
    private String BL_DATE;         
    private String DATE_SHIPPING;         
    private String DATE_DEST;         
    private String METHD_CARRY;         
    private String VESSEL_NAME;         
    private String FORWARDER;         
    private String VESSEL_NATION_CODE;         
    private String REC_PLCE;         
    private String DELIVERY_PLCE;         
    private String DEST_PORT;         
    private String DEST_PORT_NM;         
    private String SHIP_PORT;         
    private String SHIP_PORT_NM;         
    private String DEST_FINAL;         
    private String BL_COUNT;         
    private String BL_PLCE;         
    private String PAY_METHD;         
    private String EXCHANGE_RATE;         
    private String BL_AMT;         
    private String BL_AMT_WON;         
    private String AMT_UNIT;         
    private String GROSS_WEIGHT;         
    private String WEIGHT_UNIT;         
    private String NET_WEIGHT;         
    private String GROSS_VOLUME;         
    private String VOLUME_UNIT;         
    private String TRANS_COEF;         
    private String PACKING_TYPE;         
    private String TOT_PACKING_COUNT;         
    private String REMARKS1;         
    private String REMARKS2;         
    private String NATION_INOUT;  
    private String TRADE_TYPE;         
    private String PROJECT_NO;         
    private String UPDATE_DB_USER;         
    private String UPDATE_DB_TIME;         
    private String INVOICE_DATE;         
    private String INVOICE_NO;         
    private String CUSTOMS;         
    private String EP_TYPE;         
    private String REPORTOR;         
    private String EXPORTER;         
    private String IMPORTER;
    private String EX_DATE;
    private Integer EX_NUM;
    
    private String  S_COMP_CODE;
    public void setS_COMP_CODE( String s_COMP_CODE ) {
        S_COMP_CODE = s_COMP_CODE;
    }
    public void setS_AUTHORITY_LEVEL( String s_AUTHORITY_LEVEL ) {
        S_AUTHORITY_LEVEL = s_AUTHORITY_LEVEL;
    }
    public void setS_USER_ID( String s_USER_ID ) {
        S_USER_ID = s_USER_ID;
    }
    public String getS_COMP_CODE() {
        return S_COMP_CODE;
    }
    public String getS_AUTHORITY_LEVEL() {
        return S_AUTHORITY_LEVEL;
    }
    public String getS_USER_ID() {
        return S_USER_ID;
    }
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    
    
    
    
    public static long getSerialversionuid() {
        return serialVersionUID;
    }
    public String getKEY_VALUE() {
        return KEY_VALUE;
    }
    public String getOPR_FLAG() {
        return OPR_FLAG;
    }
    public String getCOMP_CODE() {
        return COMP_CODE;
    }
    public String getDIV_CODE() {
        return DIV_CODE;
    }
    public String getBL_SER_NO() {
        return BL_SER_NO;
    }
    public String getSO_SER_NO() {
        return SO_SER_NO;
    }
    public String getBL_NO() {
        return BL_NO;
    }
    public String getBL_DATE() {
        return BL_DATE;
    }
    public String getDATE_SHIPPING() {
        return DATE_SHIPPING;
    }
    public String getDATE_DEST() {
        return DATE_DEST;
    }
    public String getMETHD_CARRY() {
        return METHD_CARRY;
    }
    public String getVESSEL_NAME() {
        return VESSEL_NAME;
    }
    public String getFORWARDER() {
        return FORWARDER;
    }
    public String getVESSEL_NATION_CODE() {
        return VESSEL_NATION_CODE;
    }
    public String getREC_PLCE() {
        return REC_PLCE;
    }
    public String getDELIVERY_PLCE() {
        return DELIVERY_PLCE;
    }
    public String getDEST_PORT() {
        return DEST_PORT;
    }
    public String getDEST_PORT_NM() {
        return DEST_PORT_NM;
    }
    public String getSHIP_PORT() {
        return SHIP_PORT;
    }
    public String getSHIP_PORT_NM() {
        return SHIP_PORT_NM;
    }
    public String getDEST_FINAL() {
        return DEST_FINAL;
    }
    public String getBL_COUNT() {
        return BL_COUNT;
    }
    public String getBL_PLCE() {
        return BL_PLCE;
    }
    public String getPAY_METHD() {
        return PAY_METHD;
    }
    public String getEXCHANGE_RATE() {
        return EXCHANGE_RATE;
    }
    public String getBL_AMT() {
        return BL_AMT;
    }
    public String getBL_AMT_WON() {
        return BL_AMT_WON;
    }
    public String getAMT_UNIT() {
        return AMT_UNIT;
    }
    public String getGROSS_WEIGHT() {
        return GROSS_WEIGHT;
    }
    public String getWEIGHT_UNIT() {
        return WEIGHT_UNIT;
    }
    public String getNET_WEIGHT() {
        return NET_WEIGHT;
    }
    public String getGROSS_VOLUME() {
        return GROSS_VOLUME;
    }
    public String getVOLUME_UNIT() {
        return VOLUME_UNIT;
    }
    public String getTRANS_COEF() {
        return TRANS_COEF;
    }
    public String getPACKING_TYPE() {
        return PACKING_TYPE;
    }
    public String getTOT_PACKING_COUNT() {
        return TOT_PACKING_COUNT;
    }
    public String getREMARKS1() {
        return REMARKS1;
    }
    public String getREMARKS2() {
        return REMARKS2;
    }
    public String getNATION_INOUT() {
        return NATION_INOUT;
    }
    public String getTRADE_TYPE() {
        return TRADE_TYPE;
    }
    public String getPROJECT_NO() {
        return PROJECT_NO;
    }
    public String getUPDATE_DB_USER() {
        return UPDATE_DB_USER;
    }
    public String getUPDATE_DB_TIME() {
        return UPDATE_DB_TIME;
    }
    public String getINVOICE_DATE() {
        return INVOICE_DATE;
    }
    public String getINVOICE_NO() {
        return INVOICE_NO;
    }
    public String getCUSTOMS() {
        return CUSTOMS;
    }
    public String getEP_TYPE() {
        return EP_TYPE;
    }
    public String getREPORTOR() {
        return REPORTOR;
    }
    public String getEXPORTER() {
        return EXPORTER;
    }
    public String getIMPORTER() {
        return IMPORTER;
    }
    public void setKEY_VALUE( String kEY_VALUE ) {
        KEY_VALUE = kEY_VALUE;
    }
    public void setOPR_FLAG( String oPR_FLAG ) {
        OPR_FLAG = oPR_FLAG;
    }
    public void setCOMP_CODE( String cOMP_CODE ) {
        COMP_CODE = cOMP_CODE;
    }
    public void setDIV_CODE( String dIV_CODE ) {
        DIV_CODE = dIV_CODE;
    }
    public void setBL_SER_NO( String bL_SER_NO ) {
        BL_SER_NO = bL_SER_NO;
    }
    public void setSO_SER_NO( String sO_SER_NO ) {
        SO_SER_NO = sO_SER_NO;
    }
    public void setBL_NO( String bL_NO ) {
        BL_NO = bL_NO;
    }
    public void setBL_DATE( String bL_DATE ) {
        BL_DATE = bL_DATE;
    }
    public void setDATE_SHIPPING( String dATE_SHIPPING ) {
        DATE_SHIPPING = dATE_SHIPPING;
    }
    public void setDATE_DEST( String dATE_DEST ) {
        DATE_DEST = dATE_DEST;
    }
    public void setMETHD_CARRY( String mETHD_CARRY ) {
        METHD_CARRY = mETHD_CARRY;
    }
    public void setVESSEL_NAME( String vESSEL_NAME ) {
        VESSEL_NAME = vESSEL_NAME;
    }
    public void setFORWARDER( String fORWARDER ) {
        FORWARDER = fORWARDER;
    }
    public void setVESSEL_NATION_CODE( String vESSEL_NATION_CODE ) {
        VESSEL_NATION_CODE = vESSEL_NATION_CODE;
    }
    public void setREC_PLCE( String rEC_PLCE ) {
        REC_PLCE = rEC_PLCE;
    }
    public void setDELIVERY_PLCE( String dELIVERY_PLCE ) {
        DELIVERY_PLCE = dELIVERY_PLCE;
    }
    public void setDEST_PORT( String dEST_PORT ) {
        DEST_PORT = dEST_PORT;
    }
    public void setDEST_PORT_NM( String dEST_PORT_NM ) {
        DEST_PORT_NM = dEST_PORT_NM;
    }
    public void setSHIP_PORT( String sHIP_PORT ) {
        SHIP_PORT = sHIP_PORT;
    }
    public void setSHIP_PORT_NM( String sHIP_PORT_NM ) {
        SHIP_PORT_NM = sHIP_PORT_NM;
    }
    public void setDEST_FINAL( String dEST_FINAL ) {
        DEST_FINAL = dEST_FINAL;
    }
    public void setBL_COUNT( String bL_COUNT ) {
        BL_COUNT = bL_COUNT;
    }
    public void setBL_PLCE( String bL_PLCE ) {
        BL_PLCE = bL_PLCE;
    }
    public void setPAY_METHD( String pAY_METHD ) {
        PAY_METHD = pAY_METHD;
    }
    public void setEXCHANGE_RATE( String eXCHANGE_RATE ) {
        EXCHANGE_RATE = eXCHANGE_RATE;
    }
    public void setBL_AMT( String bL_AMT ) {
        BL_AMT = bL_AMT;
    }
    public void setBL_AMT_WON( String bL_AMT_WON ) {
        BL_AMT_WON = bL_AMT_WON;
    }
    public void setAMT_UNIT( String aMT_UNIT ) {
        AMT_UNIT = aMT_UNIT;
    }
    public void setGROSS_WEIGHT( String gROSS_WEIGHT ) {
        GROSS_WEIGHT = gROSS_WEIGHT;
    }
    public void setWEIGHT_UNIT( String wEIGHT_UNIT ) {
        WEIGHT_UNIT = wEIGHT_UNIT;
    }
    public void setNET_WEIGHT( String nET_WEIGHT ) {
        NET_WEIGHT = nET_WEIGHT;
    }
    public void setGROSS_VOLUME( String gROSS_VOLUME ) {
        GROSS_VOLUME = gROSS_VOLUME;
    }
    public void setVOLUME_UNIT( String vOLUME_UNIT ) {
        VOLUME_UNIT = vOLUME_UNIT;
    }
    public void setTRANS_COEF( String tRANS_COEF ) {
        TRANS_COEF = tRANS_COEF;
    }
    public void setPACKING_TYPE( String pACKING_TYPE ) {
        PACKING_TYPE = pACKING_TYPE;
    }
    public void setTOT_PACKING_COUNT( String tOT_PACKING_COUNT ) {
        TOT_PACKING_COUNT = tOT_PACKING_COUNT;
    }
    public void setREMARKS1( String rEMARKS1 ) {
        REMARKS1 = rEMARKS1;
    }
    public void setREMARKS2( String rEMARKS2 ) {
        REMARKS2 = rEMARKS2;
    }
    public void setNATION_INOUT( String nATION_INOUT ) {
        NATION_INOUT = nATION_INOUT;
    }
    public void setTRADE_TYPE( String tRADE_TYPE ) {
        TRADE_TYPE = tRADE_TYPE;
    }
    public void setPROJECT_NO( String pROJECT_NO ) {
        PROJECT_NO = pROJECT_NO;
    }
    public void setUPDATE_DB_USER( String uPDATE_DB_USER ) {
        UPDATE_DB_USER = uPDATE_DB_USER;
    }
    public void setUPDATE_DB_TIME( String uPDATE_DB_TIME ) {
        UPDATE_DB_TIME = uPDATE_DB_TIME;
    }
    public void setINVOICE_DATE( String iNVOICE_DATE ) {
        INVOICE_DATE = iNVOICE_DATE;
    }
    public void setINVOICE_NO( String iNVOICE_NO ) {
        INVOICE_NO = iNVOICE_NO;
    }
    public void setCUSTOMS( String cUSTOMS ) {
        CUSTOMS = cUSTOMS;
    }
    public void setEP_TYPE( String eP_TYPE ) {
        EP_TYPE = eP_TYPE;
    }
    public void setREPORTOR( String rEPORTOR ) {
        REPORTOR = rEPORTOR;
    }
    public void setEXPORTER( String eXPORTER ) {
        EXPORTER = eXPORTER;
    }
    public void setIMPORTER( String iMPORTER ) {
        IMPORTER = iMPORTER;
    }
	public String getEX_DATE() {
		return EX_DATE;
	}
	public void setEX_DATE(String eX_DATE) {
		EX_DATE = eX_DATE;
	}
	public Integer getEX_NUM() {
		return EX_NUM;
	}
	public void setEX_NUM(Integer eX_NUM) {
		EX_NUM = eX_NUM;
	}  
	
    
    
    
}
