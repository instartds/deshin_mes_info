package foren.unilite.modules.accnt.atx;

import foren.framework.model.BaseVO;

public class Atx301ukrModel extends BaseVO {
	
	private static final long serialVersionUID = 1L;
	
	private String txtFrPubDate;
	private String txtToPubDate;
	private String txtBillDivCode;
	private String rdoElectric;
	private String txtBillDivCode_sub;
	private String rdoSum;
	private String DEGREE;
	
	private String SAVE_FLAG;
	private String RE_REFERENCE;
	
	private String AMT_1;
	private String TAX_1;
	private String AMT_57;
	private String TAX_57;
	private String AMT_62;
	private String TAX_62;
	private String AMT_2;
	private String TAX_2;
	private String AMT_3;
	private String TAX_3;
	private String AMT_4;
	private String TAX_4;
	private String AMT_5;
	private String TAX_5;
	private String AMT_6;
	private String TAX_6;
	private String AMT_TOT_7;
	private String TAX_TOT_7;
	private String AMT_8;
	private String TAX_8;
	private String AMT_9;
	private String TAX_9;
	private String TAX_10_1;
	private String AMT_TOT_10_34;
	private String TAX_TOT_10_34;
	private String AMT_58;
	private String TAX_58;
	private String AMT_10;
	private String TAX_10;
	private String AMT_TOT_11;
	private String TAX_TOT_11;
	private String AMT_TOT_12;
	private String TAX_TOT_12;
	private String AMT_TOT_13;
	private String TAX_TOT_13;
	private String PAY_TAX;
	private String AMT_15;
	private String TAX_15;
	private String AMT_14;
	private String TAX_14;
	private String AMT_TOT_16;
	private String TAX_TOT_16;
	private String AMT_17;
	private String TAX_17;
	private String AMT_18;
	private String TAX_18;
	private String AMT_23;
	private String TAX_23;
	private String AMT_59;
	private String TAX_59;
	private String TAX_77;
	private String TAX_78;
	private String AMT_TOT_19;
	private String TAX_TOT_19;
	private String AMT_TOT_20;
	private String TAX_TOT_20;
	
	
	//sumTableSub1
	private String AMT_26;
	private String TAX_26;
	private String AMT_27;
	private String TAX_27;
	private String AMT_28;
	private String AMT_29;
	
	//sumTableSub2
	private String AMT_10_32;
	private String TAX_10_32;
	private String AMT_10_33;
	private String TAX_10_33;
	
	//sumTableSub3
	private String AMT_31;
	private String TAX_31;
	private String AMT_63;
	private String TAX_63;
	private String AMT_32;
	private String TAX_32;
	private String AMT_33;
	private String TAX_33;
	private String TAX_55;
	private String TAX_34;
	private String TAX_35;
	private String TAX_14_47;
	
	//sumTableSub4
	private String AMT_37;
	private String TAX_37;
	private String AMT_38;
	private String TAX_38;
	private String AMT_39;
	private String TAX_39;
	private String AMT_12;
	private String TAX_12;
	
	//sumTableSub5
	private String TAX_16_46;
	private String TAX_64;
	private String TAX_41;
	private String TAX_16_47;
	private String TAX_42;
		
	//sumTableSub6
	private String AMT_44;
	private String TAX_44;
	private String AMT_67;
	private String TAX_67;
	private String AMT_69;
	private String TAX_69;
	private String AMT_61;
	private String TAX_61;
	private String AMT_65;
	private String TAX_65;
	private String AMT_66;
	private String TAX_66;
	private String AMT_45;
	private String TAX_45;
	private String AMT_70;
	private String TAX_70;
	private String AMT_46;
	private String TAX_46;
	private String AMT_71;
	private String TAX_71;
	private String AMT_72;
	private String TAX_72;
	private String AMT_73;
	private String TAX_73;
	private String AMT_47;
	private String TAX_47;
	private String AMT_48;
	private String TAX_48;
	private String AMT_56;
	private String TAX_56;
	private String AMT_74;
	private String TAX_74;
	private String AMT_75;
	private String TAX_75;
	private String AMT_76;
	private String TAX_76;
	private String AMT_19;
	private String TAX_19;
	
	//sumTableSetUp
	private String DIVI;
	private String PRE_RE_CANCEL;
	private String BUSINESS_BANK_CODE;
	private String BUSINESS_BANK_NAME;
	private String BANK_CODE;
	private String BRANCH_NAME;
	private String BANK_ACCOUNT;
	private String CLOSE_DATE;
	private String CLOSE_REASON;
	private String COMP_TYPE1;
	private String COMP_CLASS1;
	private String COMP_CODE1;
	private String COMP_AMT1;
	private String COMP_TYPE2;
	private String COMP_CLASS2;
	private String COMP_CODE2;
	private String COMP_AMT2;
	private String COMP_TYPE3;
	private String COMP_CLASS3;
	private String COMP_CODE3;
	private String COMP_AMT3;
	private String COMP_CLASS4;
	private String COMP_CODE4;
	private String COMP_AMT4;
	private String FREE_TYPE1;
	private String FREE_CLASS1;
	private String FREE_CODE1;
	private String FREE_AMT1;
	private String FREE_TYPE2;
	private String FREE_CLASS2;
	private String FREE_CODE2;
	private String FREE_AMT2;
	private String FREE_CLASS3;
	private String FREE_CODE3;
	private String FREE_AMT3;
	private String AMT_53;
	private String AMT_54;
	private String DECLARE_DATE;
	private String AMT_TOT_25;
	private String AMT_TOT_52;
	
	// 20210526 추가
	private String ZERO_TAX_RECIP1;
	private String ZERO_TAX_CLASS1;
	private String ZERO_TAX_CODE1;
	private String ZERO_TAX_NATION1;
	private String ZERO_TAX_RECIP2;
	private String ZERO_TAX_CLASS2;
	private String ZERO_TAX_CODE2;
	private String ZERO_TAX_NATION2;
	private String ZERO_TAX_RECIP3;
	private String ZERO_TAX_CLASS3;
	private String ZERO_TAX_CODE3;
	private String ZERO_TAX_NATION3;
	
	
	
	private String  S_COMP_CODE;
	private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
	

	
	
	public String getZERO_TAX_RECIP1() {
		return ZERO_TAX_RECIP1;
	}
	public void setZERO_TAX_RECIP1(String zERO_TAX_RECIP1) {
		ZERO_TAX_RECIP1 = zERO_TAX_RECIP1;
	}
	public String getZERO_TAX_CLASS1() {
		return ZERO_TAX_CLASS1;
	}
	public void setZERO_TAX_CLASS1(String zERO_TAX_CLASS1) {
		ZERO_TAX_CLASS1 = zERO_TAX_CLASS1;
	}
	public String getZERO_TAX_CODE1() {
		return ZERO_TAX_CODE1;
	}
	public void setZERO_TAX_CODE1(String zERO_TAX_CODE1) {
		ZERO_TAX_CODE1 = zERO_TAX_CODE1;
	}
	public String getZERO_TAX_NATION1() {
		return ZERO_TAX_NATION1;
	}
	public void setZERO_TAX_NATION1(String zERO_TAX_NATION1) {
		ZERO_TAX_NATION1 = zERO_TAX_NATION1;
	}
	public String getZERO_TAX_RECIP2() {
		return ZERO_TAX_RECIP2;
	}
	public void setZERO_TAX_RECIP2(String zERO_TAX_RECIP2) {
		ZERO_TAX_RECIP2 = zERO_TAX_RECIP2;
	}
	public String getZERO_TAX_CLASS2() {
		return ZERO_TAX_CLASS2;
	}
	public void setZERO_TAX_CLASS2(String zERO_TAX_CLASS2) {
		ZERO_TAX_CLASS2 = zERO_TAX_CLASS2;
	}
	public String getZERO_TAX_CODE2() {
		return ZERO_TAX_CODE2;
	}
	public void setZERO_TAX_CODE2(String zERO_TAX_CODE2) {
		ZERO_TAX_CODE2 = zERO_TAX_CODE2;
	}
	public String getZERO_TAX_NATION2() {
		return ZERO_TAX_NATION2;
	}
	public void setZERO_TAX_NATION2(String zERO_TAX_NATION2) {
		ZERO_TAX_NATION2 = zERO_TAX_NATION2;
	}
	public String getZERO_TAX_RECIP3() {
		return ZERO_TAX_RECIP3;
	}
	public void setZERO_TAX_RECIP3(String zERO_TAX_RECIP3) {
		ZERO_TAX_RECIP3 = zERO_TAX_RECIP3;
	}
	public String getZERO_TAX_CLASS3() {
		return ZERO_TAX_CLASS3;
	}
	public void setZERO_TAX_CLASS3(String zERO_TAX_CLASS3) {
		ZERO_TAX_CLASS3 = zERO_TAX_CLASS3;
	}
	public String getZERO_TAX_CODE3() {
		return ZERO_TAX_CODE3;
	}
	public void setZERO_TAX_CODE3(String zERO_TAX_CODE3) {
		ZERO_TAX_CODE3 = zERO_TAX_CODE3;
	}
	public String getZERO_TAX_NATION3() {
		return ZERO_TAX_NATION3;
	}
	public void setZERO_TAX_NATION3(String zERO_TAX_NATION3) {
		ZERO_TAX_NATION3 = zERO_TAX_NATION3;
	}
	public String getBUSINESS_BANK_CODE() {
        return BUSINESS_BANK_CODE;
    }
    public void setBUSINESS_BANK_CODE( String bUSINESS_BANK_CODE ) {
        BUSINESS_BANK_CODE = bUSINESS_BANK_CODE;
    }
    public String getBUSINESS_BANK_NAME() {
        return BUSINESS_BANK_NAME;
    }
    public void setBUSINESS_BANK_NAME( String bUSINESS_BANK_NAME ) {
        BUSINESS_BANK_NAME = bUSINESS_BANK_NAME;
    }
    public String getTxtFrPubDate() {
		return txtFrPubDate;
	}
	public void setTxtFrPubDate(String txtFrPubDate) {
		this.txtFrPubDate = txtFrPubDate;
	}
	public String getTxtToPubDate() {
		return txtToPubDate;
	}
	public void setTxtToPubDate(String txtToPubDate) {
		this.txtToPubDate = txtToPubDate;
	}
	public String getTxtBillDivCode() {
		return txtBillDivCode;
	}
	public void setTxtBillDivCode(String txtBillDivCode) {
		this.txtBillDivCode = txtBillDivCode;
	}
	public String getRdoElectric() {
		return rdoElectric;
	}
	public void setRdoElectric(String rdoElectric) {
		this.rdoElectric = rdoElectric;
	}
	public String getTxtBillDivCode_sub() {
		return txtBillDivCode_sub;
	}
	public void setTxtBillDivCode_sub(String txtBillDivCode_sub) {
		this.txtBillDivCode_sub = txtBillDivCode_sub;
	}
	public String getRdoSum() {
		return rdoSum;
	}
	public void setRdoSum(String rdoSum) {
		this.rdoSum = rdoSum;
	}
	public String getDEGREE() {
		return DEGREE;
	}
	public void setDEGREE(String dEGREE) {
		DEGREE = dEGREE;
	}
	public String getSAVE_FLAG() {
		return SAVE_FLAG;
	}
	public void setSAVE_FLAG(String sAVE_FLAG) {
		SAVE_FLAG = sAVE_FLAG;
	}
	public String getRE_REFERENCE() {
		return RE_REFERENCE;
	}
	public void setRE_REFERENCE(String rE_REFERENCE) {
		RE_REFERENCE = rE_REFERENCE;
	}
	
	public String getAMT_1() {
		return AMT_1;
	}
	public void setAMT_1(String aMT_1) {
		AMT_1 = aMT_1;
	}
	public String getTAX_1() {
		return TAX_1;
	}
	public void setTAX_1(String tAX_1) {
		TAX_1 = tAX_1;
	}
	public String getAMT_57() {
		return AMT_57;
	}
	public void setAMT_57(String aMT_57) {
		AMT_57 = aMT_57;
	}
	public String getTAX_57() {
		return TAX_57;
	}
	public void setTAX_57(String tAX_57) {
		TAX_57 = tAX_57;
	}
	public String getAMT_62() {
		return AMT_62;
	}
	public void setAMT_62(String aMT_62) {
		AMT_62 = aMT_62;
	}
	public String getTAX_62() {
		return TAX_62;
	}
	public void setTAX_62(String tAX_62) {
		TAX_62 = tAX_62;
	}
	public String getAMT_2() {
		return AMT_2;
	}
	public void setAMT_2(String aMT_2) {
		AMT_2 = aMT_2;
	}
	public String getTAX_2() {
		return TAX_2;
	}
	public void setTAX_2(String tAX_2) {
		TAX_2 = tAX_2;
	}
	public String getAMT_3() {
		return AMT_3;
	}
	public void setAMT_3(String aMT_3) {
		AMT_3 = aMT_3;
	}
	public String getTAX_3() {
		return TAX_3;
	}
	public void setTAX_3(String tAX_3) {
		TAX_3 = tAX_3;
	}
	public String getAMT_4() {
		return AMT_4;
	}
	public void setAMT_4(String aMT_4) {
		AMT_4 = aMT_4;
	}
	public String getTAX_4() {
		return TAX_4;
	}
	public void setTAX_4(String tAX_4) {
		TAX_4 = tAX_4;
	}
	public String getAMT_5() {
		return AMT_5;
	}
	public void setAMT_5(String aMT_5) {
		AMT_5 = aMT_5;
	}
	public String getTAX_5() {
		return TAX_5;
	}
	public void setTAX_5(String tAX_5) {
		TAX_5 = tAX_5;
	}
	public String getAMT_6() {
		return AMT_6;
	}
	public void setAMT_6(String aMT_6) {
		AMT_6 = aMT_6;
	}
	public String getTAX_6() {
		return TAX_6;
	}
	public void setTAX_6(String tAX_6) {
		TAX_6 = tAX_6;
	}
	public String getAMT_TOT_7() {
		return AMT_TOT_7;
	}
	public void setAMT_TOT_7(String aMT_TOT_7) {
		AMT_TOT_7 = aMT_TOT_7;
	}
	public String getTAX_TOT_7() {
		return TAX_TOT_7;
	}
	public void setTAX_TOT_7(String tAX_TOT_7) {
		TAX_TOT_7 = tAX_TOT_7;
	}
	public String getAMT_8() {
		return AMT_8;
	}
	public void setAMT_8(String aMT_8) {
		AMT_8 = aMT_8;
	}
	public String getTAX_8() {
		return TAX_8;
	}
	public void setTAX_8(String tAX_8) {
		TAX_8 = tAX_8;
	}
	public String getAMT_9() {
		return AMT_9;
	}
	public void setAMT_9(String aMT_9) {
		AMT_9 = aMT_9;
	}
	public String getTAX_9() {
		return TAX_9;
	}
	public void setTAX_9(String tAX_9) {
		TAX_9 = tAX_9;
	}
	public String getAMT_TOT_10_34() {
		return AMT_TOT_10_34;
	}
	public void setAMT_TOT_10_34(String aMT_TOT_10_34) {
		AMT_TOT_10_34 = aMT_TOT_10_34;
	}
	public String getTAX_TOT_10_34() {
		return TAX_TOT_10_34;
	}
	public void setTAX_TOT_10_34(String tAX_TOT_10_34) {
		TAX_TOT_10_34 = tAX_TOT_10_34;
	}
	public String getAMT_58() {
		return AMT_58;
	}
	public void setAMT_58(String aMT_58) {
		AMT_58 = aMT_58;
	}
	public String getTAX_58() {
		return TAX_58;
	}
	public void setTAX_58(String tAX_58) {
		TAX_58 = tAX_58;
	}
	public String getAMT_10() {
		return AMT_10;
	}
	public void setAMT_10(String aMT_10) {
		AMT_10 = aMT_10;
	}
	public String getTAX_10() {
		return TAX_10;
	}
	public void setTAX_10(String tAX_10) {
		TAX_10 = tAX_10;
	}
	public String getAMT_TOT_11() {
		return AMT_TOT_11;
	}
	public void setAMT_TOT_11(String aMT_TOT_11) {
		AMT_TOT_11 = aMT_TOT_11;
	}
	public String getTAX_TOT_11() {
		return TAX_TOT_11;
	}
	public void setTAX_TOT_11(String tAX_TOT_11) {
		TAX_TOT_11 = tAX_TOT_11;
	}
	public String getAMT_TOT_12() {
		return AMT_TOT_12;
	}
	public void setAMT_TOT_12(String aMT_TOT_12) {
		AMT_TOT_12 = aMT_TOT_12;
	}
	public String getTAX_TOT_12() {
		return TAX_TOT_12;
	}
	public void setTAX_TOT_12(String tAX_TOT_12) {
		TAX_TOT_12 = tAX_TOT_12;
	}
	public String getAMT_TOT_13() {
		return AMT_TOT_13;
	}
	public void setAMT_TOT_13(String aMT_TOT_13) {
		AMT_TOT_13 = aMT_TOT_13;
	}
	public String getTAX_TOT_13() {
		return TAX_TOT_13;
	}
	public void setTAX_TOT_13(String tAX_TOT_13) {
		TAX_TOT_13 = tAX_TOT_13;
	}
	public String getPAY_TAX() {
		return PAY_TAX;
	}
	public void setPAY_TAX(String pAY_TAX) {
		PAY_TAX = pAY_TAX;
	}
	public String getAMT_15() {
		return AMT_15;
	}
	public void setAMT_15(String aMT_15) {
		AMT_15 = aMT_15;
	}
	public String getTAX_15() {
		return TAX_15;
	}
	public void setTAX_15(String tAX_15) {
		TAX_15 = tAX_15;
	}
	public String getAMT_14() {
		return AMT_14;
	}
	public void setAMT_14(String aMT_14) {
		AMT_14 = aMT_14;
	}
	public String getTAX_14() {
		return TAX_14;
	}
	public void setTAX_14(String tAX_14) {
		TAX_14 = tAX_14;
	}
	public String getAMT_TOT_16() {
		return AMT_TOT_16;
	}
	public void setAMT_TOT_16(String aMT_TOT_16) {
		AMT_TOT_16 = aMT_TOT_16;
	}
	public String getTAX_TOT_16() {
		return TAX_TOT_16;
	}
	public void setTAX_TOT_16(String tAX_TOT_16) {
		TAX_TOT_16 = tAX_TOT_16;
	}
	public String getAMT_17() {
		return AMT_17;
	}
	public void setAMT_17(String aMT_17) {
		AMT_17 = aMT_17;
	}
	public String getTAX_17() {
		return TAX_17;
	}
	public void setTAX_17(String tAX_17) {
		TAX_17 = tAX_17;
	}
	public String getAMT_18() {
		return AMT_18;
	}
	public void setAMT_18(String aMT_18) {
		AMT_18 = aMT_18;
	}
	public String getTAX_18() {
		return TAX_18;
	}
	public void setTAX_18(String tAX_18) {
		TAX_18 = tAX_18;
	}
	public String getAMT_23() {
		return AMT_23;
	}
	public void setAMT_23(String aMT_23) {
		AMT_23 = aMT_23;
	}
	public String getTAX_23() {
		return TAX_23;
	}
	public void setTAX_23(String tAX_23) {
		TAX_23 = tAX_23;
	}
	public String getAMT_59() {
		return AMT_59;
	}
	public void setAMT_59(String aMT_59) {
		AMT_59 = aMT_59;
	}
	public String getTAX_59() {
		return TAX_59;
	}
	public void setTAX_59(String tAX_59) {
		TAX_59 = tAX_59;
	}
	public String getAMT_TOT_19() {
		return AMT_TOT_19;
	}
	public void setAMT_TOT_19(String aMT_TOT_19) {
		AMT_TOT_19 = aMT_TOT_19;
	}
	public String getTAX_TOT_19() {
		return TAX_TOT_19;
	}
	public void setTAX_TOT_19(String tAX_TOT_19) {
		TAX_TOT_19 = tAX_TOT_19;
	}
	public String getAMT_TOT_20() {
		return AMT_TOT_20;
	}
	public void setAMT_TOT_20(String aMT_TOT_20) {
		AMT_TOT_20 = aMT_TOT_20;
	}
	public String getTAX_TOT_20() {
		return TAX_TOT_20;
	}
	public void setTAX_TOT_20(String tAX_TOT_20) {
		TAX_TOT_20 = tAX_TOT_20;
	}
	
	
	
	
	public String getAMT_26() {
		return AMT_26;
	}
	public void setAMT_26(String aMT_26) {
		AMT_26 = aMT_26;
	}
	public String getTAX_26() {
		return TAX_26;
	}
	public void setTAX_26(String tAX_26) {
		TAX_26 = tAX_26;
	}
	public String getAMT_27() {
		return AMT_27;
	}
	public void setAMT_27(String aMT_27) {
		AMT_27 = aMT_27;
	}
	public String getTAX_27() {
		return TAX_27;
	}
	public void setTAX_27(String tAX_27) {
		TAX_27 = tAX_27;
	}
	public String getAMT_28() {
		return AMT_28;
	}
	public void setAMT_28(String aMT_28) {
		AMT_28 = aMT_28;
	}
	public String getAMT_29() {
		return AMT_29;
	}
	public void setAMT_29(String aMT_29) {
		AMT_29 = aMT_29;
	}
	public String getAMT_10_32() {
		return AMT_10_32;
	}
	public void setAMT_10_32(String aMT_10_32) {
		AMT_10_32 = aMT_10_32;
	}
	public String getTAX_10_32() {
		return TAX_10_32;
	}
	public void setTAX_10_32(String tAX_10_32) {
		TAX_10_32 = tAX_10_32;
	}
	public String getAMT_10_33() {
		return AMT_10_33;
	}
	public void setAMT_10_33(String aMT_10_33) {
		AMT_10_33 = aMT_10_33;
	}
	public String getTAX_10_33() {
		return TAX_10_33;
	}
	public void setTAX_10_33(String tAX_10_33) {
		TAX_10_33 = tAX_10_33;
	}
	public String getAMT_31() {
		return AMT_31;
	}
	public void setAMT_31(String aMT_31) {
		AMT_31 = aMT_31;
	}
	public String getTAX_31() {
		return TAX_31;
	}
	public void setTAX_31(String tAX_31) {
		TAX_31 = tAX_31;
	}
	public String getAMT_63() {
		return AMT_63;
	}
	public void setAMT_63(String aMT_63) {
		AMT_63 = aMT_63;
	}
	public String getTAX_63() {
		return TAX_63;
	}
	public void setTAX_63(String tAX_63) {
		TAX_63 = tAX_63;
	}
	public String getAMT_32() {
		return AMT_32;
	}
	public void setAMT_32(String aMT_32) {
		AMT_32 = aMT_32;
	}
	public String getTAX_32() {
		return TAX_32;
	}
	public void setTAX_32(String tAX_32) {
		TAX_32 = tAX_32;
	}
	public String getAMT_33() {
		return AMT_33;
	}
	public void setAMT_33(String aMT_33) {
		AMT_33 = aMT_33;
	}
	public String getTAX_33() {
		return TAX_33;
	}
	public void setTAX_33(String tAX_33) {
		TAX_33 = tAX_33;
	}
	public String getTAX_55() {
		return TAX_55;
	}
	public void setTAX_55(String tAX_55) {
		TAX_55 = tAX_55;
	}
	public String getTAX_34() {
		return TAX_34;
	}
	public void setTAX_34(String tAX_34) {
		TAX_34 = tAX_34;
	}
	public String getTAX_35() {
		return TAX_35;
	}
	public void setTAX_35(String tAX_35) {
		TAX_35 = tAX_35;
	}
	public String getTAX_14_47() {
		return TAX_14_47;
	}
	public void setTAX_14_47(String tAX_14_47) {
		TAX_14_47 = tAX_14_47;
	}
	public String getAMT_37() {
		return AMT_37;
	}
	public void setAMT_37(String aMT_37) {
		AMT_37 = aMT_37;
	}
	public String getTAX_37() {
		return TAX_37;
	}
	public void setTAX_37(String tAX_37) {
		TAX_37 = tAX_37;
	}
	public String getAMT_38() {
		return AMT_38;
	}
	public void setAMT_38(String aMT_38) {
		AMT_38 = aMT_38;
	}
	public String getTAX_38() {
		return TAX_38;
	}
	public void setTAX_38(String tAX_38) {
		TAX_38 = tAX_38;
	}
	public String getAMT_39() {
		return AMT_39;
	}
	public void setAMT_39(String aMT_39) {
		AMT_39 = aMT_39;
	}
	public String getTAX_39() {
		return TAX_39;
	}
	public void setTAX_39(String tAX_39) {
		TAX_39 = tAX_39;
	}
	public String getAMT_12() {
		return AMT_12;
	}
	public void setAMT_12(String aMT_12) {
		AMT_12 = aMT_12;
	}
	public String getTAX_12() {
		return TAX_12;
	}
	public void setTAX_12(String tAX_12) {
		TAX_12 = tAX_12;
	}
	public String getTAX_16_46() {
		return TAX_16_46;
	}
	public void setTAX_16_46(String tAX_16_46) {
		TAX_16_46 = tAX_16_46;
	}
	public String getTAX_64() {
		return TAX_64;
	}
	public void setTAX_64(String tAX_64) {
		TAX_64 = tAX_64;
	}
	public String getTAX_41() {
		return TAX_41;
	}
	public void setTAX_41(String tAX_41) {
		TAX_41 = tAX_41;
	}
	public String getTAX_16_47() {
		return TAX_16_47;
	}
	public void setTAX_16_47(String tAX_16_47) {
		TAX_16_47 = tAX_16_47;
	}
	public String getTAX_42() {
		return TAX_42;
	}
	public void setTAX_42(String tAX_42) {
		TAX_42 = tAX_42;
	}
	public String getAMT_44() {
		return AMT_44;
	}
	public void setAMT_44(String aMT_44) {
		AMT_44 = aMT_44;
	}
	public String getTAX_44() {
		return TAX_44;
	}
	public void setTAX_44(String tAX_44) {
		TAX_44 = tAX_44;
	}
	public String getAMT_67() {
		return AMT_67;
	}
	public void setAMT_67(String aMT_67) {
		AMT_67 = aMT_67;
	}
	public String getTAX_67() {
		return TAX_67;
	}
	public void setTAX_67(String tAX_67) {
		TAX_67 = tAX_67;
	}
	public String getAMT_69() {
		return AMT_69;
	}
	public void setAMT_69(String aMT_69) {
		AMT_69 = aMT_69;
	}
	public String getTAX_69() {
		return TAX_69;
	}
	public void setTAX_69(String tAX_69) {
		TAX_69 = tAX_69;
	}
	public String getAMT_61() {
		return AMT_61;
	}
	public void setAMT_61(String aMT_61) {
		AMT_61 = aMT_61;
	}
	public String getTAX_61() {
		return TAX_61;
	}
	public void setTAX_61(String tAX_61) {
		TAX_61 = tAX_61;
	}
	public String getAMT_65() {
		return AMT_65;
	}
	public void setAMT_65(String aMT_65) {
		AMT_65 = aMT_65;
	}
	public String getTAX_65() {
		return TAX_65;
	}
	public void setTAX_65(String tAX_65) {
		TAX_65 = tAX_65;
	}
	public String getAMT_66() {
		return AMT_66;
	}
	public void setAMT_66(String aMT_66) {
		AMT_66 = aMT_66;
	}
	public String getTAX_66() {
		return TAX_66;
	}
	public void setTAX_66(String tAX_66) {
		TAX_66 = tAX_66;
	}
	public String getAMT_45() {
		return AMT_45;
	}
	public void setAMT_45(String aMT_45) {
		AMT_45 = aMT_45;
	}
	public String getTAX_45() {
		return TAX_45;
	}
	public void setTAX_45(String tAX_45) {
		TAX_45 = tAX_45;
	}
	public String getAMT_70() {
		return AMT_70;
	}
	public void setAMT_70(String aMT_70) {
		AMT_70 = aMT_70;
	}
	public String getTAX_70() {
		return TAX_70;
	}
	public void setTAX_70(String tAX_70) {
		TAX_70 = tAX_70;
	}
	public String getAMT_46() {
		return AMT_46;
	}
	public void setAMT_46(String aMT_46) {
		AMT_46 = aMT_46;
	}
	public String getTAX_46() {
		return TAX_46;
	}
	public void setTAX_46(String tAX_46) {
		TAX_46 = tAX_46;
	}
	public String getAMT_71() {
		return AMT_71;
	}
	public void setAMT_71(String aMT_71) {
		AMT_71 = aMT_71;
	}
	public String getTAX_71() {
		return TAX_71;
	}
	public void setTAX_71(String tAX_71) {
		TAX_71 = tAX_71;
	}
	public String getAMT_72() {
		return AMT_72;
	}
	public void setAMT_72(String aMT_72) {
		AMT_72 = aMT_72;
	}
	public String getTAX_72() {
		return TAX_72;
	}
	public void setTAX_72(String tAX_72) {
		TAX_72 = tAX_72;
	}
	public String getAMT_73() {
		return AMT_73;
	}
	public void setAMT_73(String aMT_73) {
		AMT_73 = aMT_73;
	}
	public String getTAX_73() {
		return TAX_73;
	}
	public void setTAX_73(String tAX_73) {
		TAX_73 = tAX_73;
	}
	public String getAMT_47() {
		return AMT_47;
	}
	public void setAMT_47(String aMT_47) {
		AMT_47 = aMT_47;
	}
	public String getTAX_47() {
		return TAX_47;
	}
	public void setTAX_47(String tAX_47) {
		TAX_47 = tAX_47;
	}
	public String getAMT_48() {
		return AMT_48;
	}
	public void setAMT_48(String aMT_48) {
		AMT_48 = aMT_48;
	}
	public String getTAX_48() {
		return TAX_48;
	}
	public void setTAX_48(String tAX_48) {
		TAX_48 = tAX_48;
	}
	public String getAMT_56() {
		return AMT_56;
	}
	public void setAMT_56(String aMT_56) {
		AMT_56 = aMT_56;
	}
	public String getTAX_56() {
		return TAX_56;
	}
	public void setTAX_56(String tAX_56) {
		TAX_56 = tAX_56;
	}
	public String getAMT_74() {
		return AMT_74;
	}
	public void setAMT_74(String aMT_74) {
		AMT_74 = aMT_74;
	}
	public String getTAX_74() {
		return TAX_74;
	}
	public void setTAX_74(String tAX_74) {
		TAX_74 = tAX_74;
	}
	public String getAMT_75() {
		return AMT_75;
	}
	public void setAMT_75(String aMT_75) {
		AMT_75 = aMT_75;
	}
	public String getTAX_75() {
		return TAX_75;
	}
	public void setTAX_75(String tAX_75) {
		TAX_75 = tAX_75;
	}
	public String getAMT_76() {
		return AMT_76;
	}
	public void setAMT_76(String aMT_76) {
		AMT_76 = aMT_76;
	}
	public String getTAX_76() {
		return TAX_76;
	}
	public void setTAX_76(String tAX_76) {
		TAX_76 = tAX_76;
	}
	public String getAMT_19() {
		return AMT_19;
	}
	public void setAMT_19(String aMT_19) {
		AMT_19 = aMT_19;
	}
	public String getTAX_19() {
		return TAX_19;
	}
	public void setTAX_19(String tAX_19) {
		TAX_19 = tAX_19;
	}
	public String getDIVI() {
		return DIVI;
	}
	public void setDIVI(String dIVI) {
		DIVI = dIVI;
	}
	public String getPRE_RE_CANCEL() {
		return PRE_RE_CANCEL;
	}
	public void setPRE_RE_CANCEL(String pRE_RE_CANCEL) {
		PRE_RE_CANCEL = pRE_RE_CANCEL;
	}
	public String getBANK_CODE() {
		return BANK_CODE;
	}
	public void setBANK_CODE(String bANK_CODE) {
		BANK_CODE = bANK_CODE;
	}
	public String getBRANCH_NAME() {
		return BRANCH_NAME;
	}
	public void setBRANCH_NAME(String bRANCH_NAME) {
		BRANCH_NAME = bRANCH_NAME;
	}
	public String getBANK_ACCOUNT() {
		return BANK_ACCOUNT;
	}
	public void setBANK_ACCOUNT(String bANK_ACCOUNT) {
		BANK_ACCOUNT = bANK_ACCOUNT;
	}
	public String getCLOSE_DATE() {
		return CLOSE_DATE;
	}
	public void setCLOSE_DATE(String cLOSE_DATE) {
		CLOSE_DATE = cLOSE_DATE;
	}
	public String getCLOSE_REASON() {
		return CLOSE_REASON;
	}
	public void setCLOSE_REASON(String cLOSE_REASON) {
		CLOSE_REASON = cLOSE_REASON;
	}
	public String getCOMP_TYPE1() {
		return COMP_TYPE1;
	}
	public void setCOMP_TYPE1(String cOMP_TYPE1) {
		COMP_TYPE1 = cOMP_TYPE1;
	}
	public String getCOMP_CLASS1() {
		return COMP_CLASS1;
	}
	public void setCOMP_CLASS1(String cOMP_CLASS1) {
		COMP_CLASS1 = cOMP_CLASS1;
	}
	public String getCOMP_CODE1() {
		return COMP_CODE1;
	}
	public void setCOMP_CODE1(String cOMP_CODE1) {
		COMP_CODE1 = cOMP_CODE1;
	}
	public String getCOMP_AMT1() {
		return COMP_AMT1;
	}
	public void setCOMP_AMT1(String cOMP_AMT1) {
		COMP_AMT1 = cOMP_AMT1;
	}
	public String getCOMP_TYPE2() {
		return COMP_TYPE2;
	}
	public void setCOMP_TYPE2(String cOMP_TYPE2) {
		COMP_TYPE2 = cOMP_TYPE2;
	}
	public String getCOMP_CLASS2() {
		return COMP_CLASS2;
	}
	public void setCOMP_CLASS2(String cOMP_CLASS2) {
		COMP_CLASS2 = cOMP_CLASS2;
	}
	public String getCOMP_CODE2() {
		return COMP_CODE2;
	}
	public void setCOMP_CODE2(String cOMP_CODE2) {
		COMP_CODE2 = cOMP_CODE2;
	}
	public String getCOMP_AMT2() {
		return COMP_AMT2;
	}
	public void setCOMP_AMT2(String cOMP_AMT2) {
		COMP_AMT2 = cOMP_AMT2;
	}
	public String getCOMP_TYPE3() {
		return COMP_TYPE3;
	}
	public void setCOMP_TYPE3(String cOMP_TYPE3) {
		COMP_TYPE3 = cOMP_TYPE3;
	}
	public String getCOMP_CLASS3() {
		return COMP_CLASS3;
	}
	public void setCOMP_CLASS3(String cOMP_CLASS3) {
		COMP_CLASS3 = cOMP_CLASS3;
	}
	public String getCOMP_CODE3() {
		return COMP_CODE3;
	}
	public void setCOMP_CODE3(String cOMP_CODE3) {
		COMP_CODE3 = cOMP_CODE3;
	}
	public String getCOMP_AMT3() {
		return COMP_AMT3;
	}
	public void setCOMP_AMT3(String cOMP_AMT3) {
		COMP_AMT3 = cOMP_AMT3;
	}
	public String getCOMP_CLASS4() {
		return COMP_CLASS4;
	}
	public void setCOMP_CLASS4(String cOMP_CLASS4) {
		COMP_CLASS4 = cOMP_CLASS4;
	}
	public String getCOMP_CODE4() {
		return COMP_CODE4;
	}
	public void setCOMP_CODE4(String cOMP_CODE4) {
		COMP_CODE4 = cOMP_CODE4;
	}
	public String getCOMP_AMT4() {
		return COMP_AMT4;
	}
	public void setCOMP_AMT4(String cOMP_AMT4) {
		COMP_AMT4 = cOMP_AMT4;
	}
	public String getFREE_TYPE1() {
		return FREE_TYPE1;
	}
	public void setFREE_TYPE1(String fREE_TYPE1) {
		FREE_TYPE1 = fREE_TYPE1;
	}
	public String getFREE_CLASS1() {
		return FREE_CLASS1;
	}
	public void setFREE_CLASS1(String fREE_CLASS1) {
		FREE_CLASS1 = fREE_CLASS1;
	}
	public String getFREE_CODE1() {
		return FREE_CODE1;
	}
	public void setFREE_CODE1(String fREE_CODE1) {
		FREE_CODE1 = fREE_CODE1;
	}
	public String getFREE_AMT1() {
		return FREE_AMT1;
	}
	public void setFREE_AMT1(String fREE_AMT1) {
		FREE_AMT1 = fREE_AMT1;
	}
	public String getFREE_TYPE2() {
		return FREE_TYPE2;
	}
	public void setFREE_TYPE2(String fREE_TYPE2) {
		FREE_TYPE2 = fREE_TYPE2;
	}
	public String getFREE_CLASS2() {
		return FREE_CLASS2;
	}
	public void setFREE_CLASS2(String fREE_CLASS2) {
		FREE_CLASS2 = fREE_CLASS2;
	}
	public String getFREE_CODE2() {
		return FREE_CODE2;
	}
	public void setFREE_CODE2(String fREE_CODE2) {
		FREE_CODE2 = fREE_CODE2;
	}
	public String getFREE_AMT2() {
		return FREE_AMT2;
	}
	public void setFREE_AMT2(String fREE_AMT2) {
		FREE_AMT2 = fREE_AMT2;
	}
	public String getFREE_CLASS3() {
		return FREE_CLASS3;
	}
	public void setFREE_CLASS3(String fREE_CLASS3) {
		FREE_CLASS3 = fREE_CLASS3;
	}
	public String getFREE_CODE3() {
		return FREE_CODE3;
	}
	public void setFREE_CODE3(String fREE_CODE3) {
		FREE_CODE3 = fREE_CODE3;
	}
	public String getFREE_AMT3() {
		return FREE_AMT3;
	}
	public void setFREE_AMT3(String fREE_AMT3) {
		FREE_AMT3 = fREE_AMT3;
	}
	public String getAMT_53() {
		return AMT_53;
	}
	public void setAMT_53(String aMT_53) {
		AMT_53 = aMT_53;
	}
	public String getAMT_54() {
		return AMT_54;
	}
	public void setAMT_54(String aMT_54) {
		AMT_54 = aMT_54;
	}
	public String getDECLARE_DATE() {
		return DECLARE_DATE;
	}
	public void setDECLARE_DATE(String dECLARE_DATE) {
		DECLARE_DATE = dECLARE_DATE;
	}
	public String getAMT_TOT_25() {
		return AMT_TOT_25;
	}
	public void setAMT_TOT_25(String aMT_TOT_25) {
		AMT_TOT_25 = aMT_TOT_25;
	}
	public String getAMT_TOT_52() {
		return AMT_TOT_52;
	}
	public void setAMT_TOT_52(String aMT_TOT_52) {
		AMT_TOT_52 = aMT_TOT_52;
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
	public String getTAX_10_1() {
		return TAX_10_1;
	}
	public void setTAX_10_1(String tAX_10_1) {
		TAX_10_1 = tAX_10_1;
	}
	public String getTAX_77() {
		return TAX_77;
	}
	public void setTAX_77(String tAX_77) {
		TAX_77 = tAX_77;
	}
	public String getTAX_78() {
		return TAX_78;
	}
	public void setTAX_78(String tAX_78) {
		TAX_78 = tAX_78;
	}
	
}
