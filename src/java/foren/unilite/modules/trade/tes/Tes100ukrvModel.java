package foren.unilite.modules.trade.tes;

import foren.framework.model.BaseVO;

public class Tes100ukrvModel extends BaseVO {
    /**
     *
     */
    private static final long serialVersionUID = 1L;

    private String KEY_VALUE;
    private String OPR_FLAG;
    private String COMP_CODE;
    private String DIV_CODE;
    private String SO_SER_NO;
    private String NATION_INOUT;
    private String PASS_SER_NO;
    private String INVOICE_NO;
    private String CUSTOMS;
    private String INVOICE_DATE;
    private Double EXCHANGE_RATE;
    private String BL_SER_NO;
    private String BL_NO;
    private String BL_DATE;
    private String DATE_SHIPPING;
    private String FORWARDER;
    private String TRADE_TYPE;
    private String ORDER_TYPE;
    private String IMPORTER;
    private String EXPORTER;
    private String DATE_DEST;
    private String RECEIPT_PLAN_DATE;
    private String DELIVERY_PLCE;
    private String METHD_CARRY;
    private String VESSEL_NAME;
    private String DEST_FINAL;
    private String SHIP_PORT;
    private String SHIP_PORT_NM;
    private String DEST_PORT;
    private String DEST_PORT_NM;
    private String AMT_UNIT;
    private Double GROSS_WEIGHT;
    private String WEIGHT_UNIT;
    private Double GROSS_VOLUME;
    private String VOLUME_UNIT;
    private String PAY_METHD;
    private String REMARKS1;
    private String ED_NO;
    private String ED_DATE;
    private String EP_DATE;
    private String FORM_TRANS;
    private Double TOT_PACKING_COUNT;
    private String PKG_NO;
    private String CTNR_NO;
    private String CTNR_SEAL_NO;
    private String CARTON_NUM;
    private String CTNR_NUM;
    private String PALLET_NUM;
    private String PACK_UNIT;
    private String CARGO_NAME;
    private String CARGO_CAR_NO;
    private String REMARKS2;
    private String TERMS_PRICE;
    private String PAY_TERMS;

    private Double BL_AMT;
    private Double BL_AMT_WON;

    private String UPDATE_DB_TIME;
    private String UPDATE_DB_USER;


    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    
    private String  SAILING_DATE;
    private String  INV_DATE;
    
    private String PAYMENT_DAY;

    public String getINV_DATE() {
		return INV_DATE;
	}
	public void setINV_DATE(String iNV_DATE) {
		INV_DATE = iNV_DATE;
	}
	public String getSAILING_DATE() {
		return SAILING_DATE;
	}
	public void setSAILING_DATE(String sAILING_DATE) {
		SAILING_DATE = sAILING_DATE;
	}
	public Double getBL_AMT() {
        return BL_AMT;
    }
    public void setBL_AMT(Double bL_AMT) {
        BL_AMT = bL_AMT;
    }

    public Double getBL_AMT_WON() {
        return BL_AMT_WON;
    }
    public void setBL_AMT_WON(Double bL_AMT_WON) {
        BL_AMT_WON = bL_AMT_WON;
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
    public String getKEY_VALUE() {
        return KEY_VALUE;
    }
    public void setKEY_VALUE(String kEY_VALUE) {
        KEY_VALUE = kEY_VALUE;
    }
    public String getOPR_FLAG() {
        return OPR_FLAG;
    }
    public void setOPR_FLAG(String oPR_FLAG) {
        OPR_FLAG = oPR_FLAG;
    }
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
    public String getSO_SER_NO() {
        return SO_SER_NO;
    }
    public void setSO_SER_NO(String sO_SER_NO) {
        SO_SER_NO = sO_SER_NO;
    }
    public String getNATION_INOUT() {
        return NATION_INOUT;
    }
    public void setNATION_INOUT(String nATION_INOUT) {
        NATION_INOUT = nATION_INOUT;
    }
    public String getPASS_SER_NO() {
        return PASS_SER_NO;
    }
    public void setPASS_SER_NO(String pASS_SER_NO) {
        PASS_SER_NO = pASS_SER_NO;
    }
    public String getINVOICE_NO() {
        return INVOICE_NO;
    }
    public void setINVOICE_NO(String iNVOICE_NO) {
        INVOICE_NO = iNVOICE_NO;
    }
    public String getCUSTOMS() {
        return CUSTOMS;
    }
    public void setCUSTOMS(String cUSTOMS) {
        CUSTOMS = cUSTOMS;
    }
    public String getINVOICE_DATE() {
        return INVOICE_DATE;
    }
    public void setINVOICE_DATE(String iNVOICE_DATE) {
        INVOICE_DATE = iNVOICE_DATE;
    }
    public Double getEXCHANGE_RATE() {
        return EXCHANGE_RATE;
    }
    public void setEXCHANGE_RATE(Double eXCHANGE_RATE) {
        EXCHANGE_RATE = eXCHANGE_RATE;
    }
    public String getBL_SER_NO() {
        return BL_SER_NO;
    }
    public void setBL_SER_NO(String bL_SER_NO) {
        BL_SER_NO = bL_SER_NO;
    }
    public String getBL_NO() {
        return BL_NO;
    }
    public void setBL_NO(String bL_NO) {
        BL_NO = bL_NO;
    }
    public String getBL_DATE() {
        return BL_DATE;
    }
    public void setBL_DATE(String bL_DATE) {
        BL_DATE = bL_DATE;
    }
    public String getDATE_SHIPPING() {
        return DATE_SHIPPING;
    }
    public void setDATE_SHIPPING(String dATE_SHIPPING) {
        DATE_SHIPPING = dATE_SHIPPING;
    }
    public String getFORWARDER() {
        return FORWARDER;
    }
    public void setFORWARDER(String fORWARDER) {
        FORWARDER = fORWARDER;
    }
    public String getTRADE_TYPE() {
        return TRADE_TYPE;
    }
    public void setTRADE_TYPE(String tRADE_TYPE) {
        TRADE_TYPE = tRADE_TYPE;
    }
    public String getORDER_TYPE() {
        return ORDER_TYPE;
    }
    public void setORDER_TYPE(String oRDER_TYPE) {
        ORDER_TYPE = oRDER_TYPE;
    }
    public String getIMPORTER() {
        return IMPORTER;
    }
    public void setIMPORTER(String iMPORTER) {
        IMPORTER = iMPORTER;
    }
    public String getEXPORTER() {
        return EXPORTER;
    }
    public void setEXPORTER(String eXPORTER) {
        EXPORTER = eXPORTER;
    }
    public String getDATE_DEST() {
        return DATE_DEST;
    }
    public void setDATE_DEST(String dATE_DEST) {
        DATE_DEST = dATE_DEST;
    }
    public String getRECEIPT_PLAN_DATE() {
        return RECEIPT_PLAN_DATE;
    }
    public void setRECEIPT_PLAN_DATE(String rECEIPT_PLAN_DATE) {
        RECEIPT_PLAN_DATE = rECEIPT_PLAN_DATE;
    }
    public String getDELIVERY_PLCE() {
        return DELIVERY_PLCE;
    }
    public void setDELIVERY_PLCE(String dELIVERY_PLCE) {
        DELIVERY_PLCE = dELIVERY_PLCE;
    }
    public String getMETHD_CARRY() {
        return METHD_CARRY;
    }
    public void setMETHD_CARRY(String mETHD_CARRY) {
        METHD_CARRY = mETHD_CARRY;
    }
    public String getVESSEL_NAME() {
        return VESSEL_NAME;
    }
    public void setVESSEL_NAME(String vESSEL_NAME) {
        VESSEL_NAME = vESSEL_NAME;
    }
    public String getDEST_FINAL() {
        return DEST_FINAL;
    }
    public void setDEST_FINAL(String dEST_FINAL) {
        DEST_FINAL = dEST_FINAL;
    }
    public String getSHIP_PORT() {
        return SHIP_PORT;
    }
    public void setSHIP_PORT(String sHIP_PORT) {
        SHIP_PORT = sHIP_PORT;
    }
    public String getSHIP_PORT_NM() {
        return SHIP_PORT_NM;
    }
    public void setSHIP_PORT_NM(String sHIP_PORT_NM) {
        SHIP_PORT_NM = sHIP_PORT_NM;
    }
    public String getDEST_PORT() {
        return DEST_PORT;
    }
    public void setDEST_PORT(String dEST_PORT) {
        DEST_PORT = dEST_PORT;
    }
    public String getDEST_PORT_NM() {
        return DEST_PORT_NM;
    }
    public void setDEST_PORT_NM(String dEST_PORT_NM) {
        DEST_PORT_NM = dEST_PORT_NM;
    }
    public String getAMT_UNIT() {
        return AMT_UNIT;
    }
    public void setAMT_UNIT(String aMT_UNIT) {
        AMT_UNIT = aMT_UNIT;
    }
    public Double getGROSS_WEIGHT() {
        return GROSS_WEIGHT;
    }
    public void setGROSS_WEIGHT(Double gROSS_WEIGHT) {
        GROSS_WEIGHT = gROSS_WEIGHT;
    }
    public String getWEIGHT_UNIT() {
        return WEIGHT_UNIT;
    }
    public void setWEIGHT_UNIT(String wEIGHT_UNIT) {
        WEIGHT_UNIT = wEIGHT_UNIT;
    }
    public Double getGROSS_VOLUME() {
        return GROSS_VOLUME;
    }
    public void setGROSS_VOLUME(Double gROSS_VOLUME) {
        GROSS_VOLUME = gROSS_VOLUME;
    }
    public String getVOLUME_UNIT() {
        return VOLUME_UNIT;
    }
    public void setVOLUME_UNIT(String vOLUME_UNIT) {
        VOLUME_UNIT = vOLUME_UNIT;
    }
    public String getPAY_METHD() {
        return PAY_METHD;
    }
    public void setPAY_METHD(String pAY_METHD) {
        PAY_METHD = pAY_METHD;
    }
    public String getREMARKS1() {
        return REMARKS1;
    }
    public void setREMARKS1(String rEMARKS1) {
        REMARKS1 = rEMARKS1;
    }
    public String getED_NO() {
        return ED_NO;
    }
    public void setED_NO(String eD_NO) {
        ED_NO = eD_NO;
    }
    public String getED_DATE() {
        return ED_DATE;
    }
    public void setED_DATE(String eD_DATE) {
        ED_DATE = eD_DATE;
    }
    public String getEP_DATE() {
        return EP_DATE;
    }
    public void setEP_DATE(String eP_DATE) {
        EP_DATE = eP_DATE;
    }
    public String getFORM_TRANS() {
        return FORM_TRANS;
    }
    public void setFORM_TRANS(String fORM_TRANS) {
        FORM_TRANS = fORM_TRANS;
    }
    public Double getTOT_PACKING_COUNT() {
        return TOT_PACKING_COUNT;
    }
    public void setTOT_PACKING_COUNT(Double tOT_PACKING_COUNT) {
        TOT_PACKING_COUNT = tOT_PACKING_COUNT;
    }
    public String getPKG_NO() {
        return PKG_NO;
    }
    public void setPKG_NO(String pKG_NO) {
        PKG_NO = pKG_NO;
    }
    public String getCTNR_NO() {
        return CTNR_NO;
    }
    public void setCTNR_NO(String cTNR_NO) {
        CTNR_NO = cTNR_NO;
    }
    public String getCTNR_SEAL_NO() {
        return CTNR_SEAL_NO;
    }
    public void setCTNR_SEAL_NO(String cTNR_SEAL_NO) {
        CTNR_SEAL_NO = cTNR_SEAL_NO;
    }
    public String getCARTON_NUM() {
        return CARTON_NUM;
    }
    public void setCARTON_NUM(String cARTON_NUM) {
        CARTON_NUM = cARTON_NUM;
    }
    public String getCTNR_NUM() {
        return CTNR_NUM;
    }
    public void setCTNR_NUM(String cTNR_NUM) {
        CTNR_NUM = cTNR_NUM;
    }
    public String getPALLET_NUM() {
        return PALLET_NUM;
    }
    public void setPALLET_NUM(String pALLET_NUM) {
        PALLET_NUM = pALLET_NUM;
    }
    public String getPACK_UNIT() {
        return PACK_UNIT;
    }
    public void setPACK_UNIT(String pACK_UNIT) {
        PACK_UNIT = pACK_UNIT;
    }
    public String getCARGO_NAME() {
        return CARGO_NAME;
    }
    public void setCARGO_NAME(String cARGO_NAME) {
        CARGO_NAME = cARGO_NAME;
    }
    public String getCARGO_CAR_NO() {
        return CARGO_CAR_NO;
    }
    public void setCARGO_CAR_NO(String cARGO_CAR_NO) {
        CARGO_CAR_NO = cARGO_CAR_NO;
    }
    public String getREMARKS2() {
        return REMARKS2;
    }
    public void setREMARKS2(String rEMARKS2) {
        REMARKS2 = rEMARKS2;
    }
    public String getTERMS_PRICE() {
        return TERMS_PRICE;
    }
    public void setTERMS_PRICE(String tERMS_PRICE) {
        TERMS_PRICE = tERMS_PRICE;
    }
    public String getPAY_TERMS() {
        return PAY_TERMS;
    }
    public void setPAY_TERMS(String pAY_TERMS) {
        PAY_TERMS = pAY_TERMS;
    }
    public String getUPDATE_DB_TIME() {
        return UPDATE_DB_TIME;
    }
    public void setUPDATE_DB_TIME(String uPDATE_DB_TIME) {
        UPDATE_DB_TIME = uPDATE_DB_TIME;
    }
    public String getUPDATE_DB_USER() {
        return UPDATE_DB_USER;
    }
    public void setUPDATE_DB_USER(String uPDATE_DB_USER) {
        UPDATE_DB_USER = uPDATE_DB_USER;
    }
	public String getPAYMENT_DAY() {
		return PAYMENT_DAY;
	}
	public void setPAYMENT_DAY(String pAYMENT_DAY) {
		PAYMENT_DAY = pAYMENT_DAY;
	}

}
