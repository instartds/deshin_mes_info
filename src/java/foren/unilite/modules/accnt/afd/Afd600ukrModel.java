package foren.unilite.modules.accnt.afd;

import foren.framework.model.BaseVO;

public class Afd600ukrModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    

    
    /* Primary Key */
    private String  S_COMP_CODE;
	private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    private String  FR_EXT_DATE;
    private String  TO_EXT_DATE;
    private String  DATE_GUBUN;
    private String  ACCNT_DIV_CODE;
    private String  ACCOUNT_CODE;
    private String  ACCOUNT_NAME;
    private String  CON_CUSTOM_CODE;
    private String  CON_CUSTOM_NAME;
    private String  T_LOAN_NO;
    private String  T_LOAN_NAME;
    private String  T_REPAY_PERIOD;
    private String  T_ACCOUNT_CODE2;
    private String  T_ACCOUNT_NAME2;
    private String  T_EXCHG_RATE_O;
    private String  T_INT_PERIOD;
    private String  T_DIV_CODE;
    private String  T_AMT_I;
    private String  T_REPAY_AMT_I;
    private String  T_CUSTOM_CODE;
    private String  T_CUSTOM_NAME;
    private String  T_FOR_AMT_I;
    private String  T_FOR_REPAY_AMT_I;
    private String  T_DEPT_CODE;
    private String  T_DEPT_NAME;
    private String  T_PUB_DATE;
    private String  T_LC_NO;
    private String  T_LOAN_GUBUN;
    private String  T_EXP_DATE;
    private String  T_EX_NUM;
    private String  T_INT_RATE;
    private String  T_REPAY_DATE;
    private String  T_SLIP_NUM;
    private String  T_ACCOUNT_NUM;
    private String  T_RENEW_DATE;
    private String  T_REMARK;
    private String  T_MORT_PAGE;
    private String  ACCNT;
    private String  ACCNT_NAME;
    private String  LOANNO;
    private String  LOAN_NAME;
    private String  ACCOUNT_NUM;
    private String  CUSTOM;
    private String  CUSTOM_NAME	;
    private String  DIV_CODE;
    private String  DEPT_CODE;
    private String  DEPT_NAME;
    private String  LOAN_GUBUN;
    private String  PUB_DATE;
    private String  EXP_DATE;
    private String  RENEW_DATE;
    private String  AMT_I;
    private String  MONEY_UNIT;
    private String  EXCHG_RATE_O;
    private String  FOR_AMT_I;
    private String  REMARK;
    private String  INT_RATE;
    private String  LCNO;
    private String  REPAY_PERIOD;
    private String  INT_PERIOD;
    private String  MORTGAGE;
    private String  REPAY_DATE;
    private String  EX_DATE;
    private String  EX_NUM;
    private String  AGREE_YN;
    private String  AC_DATE;
    private String  SLIP_NUM;
    private String  T_MONEY_UNIT;
    private String  REPAY_AMT_I;
    private String  FORREPAY_AMT_I;
    private String  SAVE_FLAG_MASTER;
    private String  T_LOAN_NO_TEMP;
    private String  FG_INT;
    private String  TEMPC_01;
    private String  NOW_RATE;
    
    public String getS_NOW_RATE() {
		return NOW_RATE;
	}
	public void setS_NOW_RATE(String nOW_RATE) {
		NOW_RATE = nOW_RATE;
	}
    public String getS_TEMPC_01() {
		return TEMPC_01;
	}
	public void setS_TEMPC_01(String tEMPC_01) {
		TEMPC_01 = tEMPC_01;
	}
    public String getS_FG_INT() {
		return FG_INT;
	}
	public void setS_FG_INT(String fG_INT) {
		FG_INT = fG_INT;
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
	public String getFR_EXT_DATE() {
		return FR_EXT_DATE;
	}
	public void setFR_EXT_DATE(String fR_EXT_DATE) {
		FR_EXT_DATE = fR_EXT_DATE;
	}
	public String getTO_EXT_DATE() {
		return TO_EXT_DATE;
	}
	public void setTO_EXT_DATE(String tO_EXT_DATE) {
		TO_EXT_DATE = tO_EXT_DATE;
	}
	public String getDATE_GUBUN() {
		return DATE_GUBUN;
	}
	public void setDATE_GUBUN(String dATE_GUBUN) {
		DATE_GUBUN = dATE_GUBUN;
	}
	public String getACCNT_DIV_CODE() {
		return ACCNT_DIV_CODE;
	}
	public void setACCNT_DIV_CODE(String aCCNT_DIV_CODE) {
		ACCNT_DIV_CODE = aCCNT_DIV_CODE;
	}
	public String getACCOUNT_CODE() {
		return ACCOUNT_CODE;
	}
	public void setACCOUNT_CODE(String aCCOUNT_CODE) {
		ACCOUNT_CODE = aCCOUNT_CODE;
	}
	public String getACCOUNT_NAME() {
		return ACCOUNT_NAME;
	}
	public void setACCOUNT_NAME(String aCCOUNT_NAME) {
		ACCOUNT_NAME = aCCOUNT_NAME;
	}
	public String getCON_CUSTOM_CODE() {
		return CON_CUSTOM_CODE;
	}
	public void setCON_CUSTOM_CODE(String cON_CUSTOM_CODE) {
		CON_CUSTOM_CODE = cON_CUSTOM_CODE;
	}
	public String getCON_CUSTOM_NAME() {
		return CON_CUSTOM_NAME;
	}
	public void setCON_CUSTOM_NAME(String cON_CUSTOM_NAME) {
		CON_CUSTOM_NAME = cON_CUSTOM_NAME;
	}
	public String getT_LOAN_NO() {
		return T_LOAN_NO;
	}
	public void setT_LOAN_NO(String t_LOAN_NO) {
		T_LOAN_NO = t_LOAN_NO;
	}
	public String getT_LOAN_NAME() {
		return T_LOAN_NAME;
	}
	public void setT_LOAN_NAME(String t_LOAN_NAME) {
		T_LOAN_NAME = t_LOAN_NAME;
	}
	public String getT_REPAY_PERIOD() {
		return T_REPAY_PERIOD;
	}
	public void setT_REPAY_PERIOD(String t_REPAY_PERIOD) {
		T_REPAY_PERIOD = t_REPAY_PERIOD;
	}
	public String getT_ACCOUNT_CODE2() {
		return T_ACCOUNT_CODE2;
	}
	public void setT_ACCOUNT_CODE2(String t_ACCOUNT_CODE2) {
		T_ACCOUNT_CODE2 = t_ACCOUNT_CODE2;
	}
	public String getT_ACCOUNT_NAME2() {
		return T_ACCOUNT_NAME2;
	}
	public void setT_ACCOUNT_NAME2(String t_ACCOUNT_NAME2) {
		T_ACCOUNT_NAME2 = t_ACCOUNT_NAME2;
	}
	public String getT_EXCHG_RATE_O() {
		return T_EXCHG_RATE_O;
	}
	public void setT_EXCHG_RATE_O(String t_EXCHG_RATE_O) {
		T_EXCHG_RATE_O = t_EXCHG_RATE_O;
	}
	public String getT_INT_PERIOD() {
		return T_INT_PERIOD;
	}
	public void setT_INT_PERIOD(String t_INT_PERIOD) {
		T_INT_PERIOD = t_INT_PERIOD;
	}
	public String getT_DIV_CODE() {
		return T_DIV_CODE;
	}
	public void setT_DIV_CODE(String t_DIV_CODE) {
		T_DIV_CODE = t_DIV_CODE;
	}
	public String getT_AMT_I() {
		return T_AMT_I;
	}
	public void setT_AMT_I(String t_AMT_I) {
		T_AMT_I = t_AMT_I;
	}
	public String getT_REPAY_AMT_I() {
		return T_REPAY_AMT_I;
	}
	public void setT_REPAY_AMT_I(String t_REPAY_AMT_I) {
		T_REPAY_AMT_I = t_REPAY_AMT_I;
	}
	public String getT_CUSTOM_CODE() {
		return T_CUSTOM_CODE;
	}
	public void setT_CUSTOM_CODE(String t_CUSTOM_CODE) {
		T_CUSTOM_CODE = t_CUSTOM_CODE;
	}
	public String getT_CUSTOM_NAME() {
		return T_CUSTOM_NAME;
	}
	public void setT_CUSTOM_NAME(String t_CUSTOM_NAME) {
		T_CUSTOM_NAME = t_CUSTOM_NAME;
	}
	public String getT_FOR_AMT_I() {
		return T_FOR_AMT_I;
	}
	public void setT_FOR_AMT_I(String t_FOR_AMT_I) {
		T_FOR_AMT_I = t_FOR_AMT_I;
	}
	public String getT_FOR_REPAY_AMT_I() {
		return T_FOR_REPAY_AMT_I;
	}
	public void setT_FOR_REPAY_AMT_I(String t_FOR_REPAY_AMT_I) {
		T_FOR_REPAY_AMT_I = t_FOR_REPAY_AMT_I;
	}
	public String getT_DEPT_CODE() {
		return T_DEPT_CODE;
	}
	public void setT_DEPT_CODE(String t_DEPT_CODE) {
		T_DEPT_CODE = t_DEPT_CODE;
	}
	public String getT_DEPT_NAME() {
		return T_DEPT_NAME;
	}
	public void setT_DEPT_NAME(String t_DEPT_NAME) {
		T_DEPT_NAME = t_DEPT_NAME;
	}
	public String getT_PUB_DATE() {
		return T_PUB_DATE;
	}
	public void setT_PUB_DATE(String t_PUB_DATE) {
		T_PUB_DATE = t_PUB_DATE;
	}
	public String getT_LC_NO() {
		return T_LC_NO;
	}
	public void setT_LC_NO(String t_LC_NO) {
		T_LC_NO = t_LC_NO;
	}
	public String getT_LOAN_GUBUN() {
		return T_LOAN_GUBUN;
	}
	public void setT_LOAN_GUBUN(String t_LOAN_GUBUN) {
		T_LOAN_GUBUN = t_LOAN_GUBUN;
	}
	public String getT_EXP_DATE() {
		return T_EXP_DATE;
	}
	public void setT_EXP_DATE(String t_EXP_DATE) {
		T_EXP_DATE = t_EXP_DATE;
	}
	public String getT_EX_NUM() {
		return T_EX_NUM;
	}
	public void setT_EX_NUM(String t_EX_NUM) {
		T_EX_NUM = t_EX_NUM;
	}
	public String getT_INT_RATE() {
		return T_INT_RATE;
	}
	public void setT_INT_RATE(String t_INT_RATE) {
		T_INT_RATE = t_INT_RATE;
	}
	public String getT_REPAY_DATE() {
		return T_REPAY_DATE;
	}
	public void setT_REPAY_DATE(String t_REPAY_DATE) {
		T_REPAY_DATE = t_REPAY_DATE;
	}
	public String getT_SLIP_NUM() {
		return T_SLIP_NUM;
	}
	public void setT_SLIP_NUM(String t_SLIP_NUM) {
		T_SLIP_NUM = t_SLIP_NUM;
	}
	public String getT_ACCOUNT_NUM() {
		return T_ACCOUNT_NUM;
	}
	public void setT_ACCOUNT_NUM(String t_ACCOUNT_NUM) {
		T_ACCOUNT_NUM = t_ACCOUNT_NUM;
	}
	public String getT_RENEW_DATE() {
		return T_RENEW_DATE;
	}
	public void setT_RENEW_DATE(String t_RENEW_DATE) {
		T_RENEW_DATE = t_RENEW_DATE;
	}
	public String getT_REMARK() {
		return T_REMARK;
	}
	public void setT_REMARK(String t_REMARK) {
		T_REMARK = t_REMARK;
	}
	public String getT_MORT_PAGE() {
		return T_MORT_PAGE;
	}
	public void setT_MORT_PAGE(String t_MORT_PAGE) {
		T_MORT_PAGE = t_MORT_PAGE;
	}
	public String getACCNT() {
		return ACCNT;
	}
	public void setACCNT(String aCCNT) {
		ACCNT = aCCNT;
	}
	public String getACCNT_NAME() {
		return ACCNT_NAME;
	}
	public void setACCNT_NAME(String aCCNT_NAME) {
		ACCNT_NAME = aCCNT_NAME;
	}
	public String getLOANNO() {
		return LOANNO;
	}
	public void setLOANNO(String lOANNO) {
		LOANNO = lOANNO;
	}
	public String getLOAN_NAME() {
		return LOAN_NAME;
	}
	public void setLOAN_NAME(String lOAN_NAME) {
		LOAN_NAME = lOAN_NAME;
	}
	public String getACCOUNT_NUM() {
		return ACCOUNT_NUM;
	}
	public void setACCOUNT_NUM(String aCCOUNT_NUM) {
		ACCOUNT_NUM = aCCOUNT_NUM;
	}
	public String getCUSTOM() {
		return CUSTOM;
	}
	public void setCUSTOM(String cUSTOM) {
		CUSTOM = cUSTOM;
	}
	public String getCUSTOM_NAME() {
		return CUSTOM_NAME;
	}
	public void setCUSTOM_NAME(String cUSTOM_NAME) {
		CUSTOM_NAME = cUSTOM_NAME;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getDEPT_CODE() {
		return DEPT_CODE;
	}
	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}
	public String getDEPT_NAME() {
		return DEPT_NAME;
	}
	public void setDEPT_NAME(String dEPT_NAME) {
		DEPT_NAME = dEPT_NAME;
	}
	public String getLOAN_GUBUN() {
		return LOAN_GUBUN;
	}
	public void setLOAN_GUBUN(String lOAN_GUBUN) {
		LOAN_GUBUN = lOAN_GUBUN;
	}
	public String getPUB_DATE() {
		return PUB_DATE;
	}
	public void setPUB_DATE(String pUB_DATE) {
		PUB_DATE = pUB_DATE;
	}
	public String getEXP_DATE() {
		return EXP_DATE;
	}
	public void setEXP_DATE(String eXP_DATE) {
		EXP_DATE = eXP_DATE;
	}
	public String getRENEW_DATE() {
		return RENEW_DATE;
	}
	public void setRENEW_DATE(String rENEW_DATE) {
		RENEW_DATE = rENEW_DATE;
	}
	public String getAMT_I() {
		return AMT_I;
	}
	public void setAMT_I(String aMT_I) {
		AMT_I = aMT_I;
	}
	public String getMONEY_UNIT() {
		return MONEY_UNIT;
	}
	public void setMONEY_UNIT(String mONEY_UNIT) {
		MONEY_UNIT = mONEY_UNIT;
	}
	public String getEXCHG_RATE_O() {
		return EXCHG_RATE_O;
	}
	public void setEXCHG_RATE_O(String eXCHG_RATE_O) {
		EXCHG_RATE_O = eXCHG_RATE_O;
	}
	public String getFOR_AMT_I() {
		return FOR_AMT_I;
	}
	public void setFOR_AMT_I(String fOR_AMT_I) {
		FOR_AMT_I = fOR_AMT_I;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getINT_RATE() {
		return INT_RATE;
	}
	public void setINT_RATE(String iNT_RATE) {
		INT_RATE = iNT_RATE;
	}
	public String getLCNO() {
		return LCNO;
	}
	public void setLCNO(String lCNO) {
		LCNO = lCNO;
	}
	public String getREPAY_PERIOD() {
		return REPAY_PERIOD;
	}
	public void setREPAY_PERIOD(String rEPAY_PERIOD) {
		REPAY_PERIOD = rEPAY_PERIOD;
	}
	public String getINT_PERIOD() {
		return INT_PERIOD;
	}
	public void setINT_PERIOD(String iNT_PERIOD) {
		INT_PERIOD = iNT_PERIOD;
	}
	public String getMORTGAGE() {
		return MORTGAGE;
	}
	public void setMORTGAGE(String mORTGAGE) {
		MORTGAGE = mORTGAGE;
	}
	public String getREPAY_DATE() {
		return REPAY_DATE;
	}
	public void setREPAY_DATE(String rEPAY_DATE) {
		REPAY_DATE = rEPAY_DATE;
	}
	public String getEX_DATE() {
		return EX_DATE;
	}
	public void setEX_DATE(String eX_DATE) {
		EX_DATE = eX_DATE;
	}
	public String getEX_NUM() {
		return EX_NUM;
	}
	public void setEX_NUM(String eX_NUM) {
		EX_NUM = eX_NUM;
	}
	public String getAGREE_YN() {
		return AGREE_YN;
	}
	public void setAGREE_YN(String aGREE_YN) {
		AGREE_YN = aGREE_YN;
	}
	public String getAC_DATE() {
		return AC_DATE;
	}
	public void setAC_DATE(String aC_DATE) {
		AC_DATE = aC_DATE;
	}
	public String getSLIP_NUM() {
		return SLIP_NUM;
	}
	public void setSLIP_NUM(String sLIP_NUM) {
		SLIP_NUM = sLIP_NUM;
	}
	public String getT_MONEY_UNIT() {
		return T_MONEY_UNIT;
	}
	public void setT_MONEY_UNIT(String t_MONEY_UNIT) {
		T_MONEY_UNIT = t_MONEY_UNIT;
	}
	public String getREPAY_AMT_I() {
		return REPAY_AMT_I;
	}
	public void setREPAY_AMT_I(String rEPAY_AMT_I) {
		REPAY_AMT_I = rEPAY_AMT_I;
	}
	public String getFORREPAY_AMT_I() {
		return FORREPAY_AMT_I;
	}
	public void setFORREPAY_AMT_I(String fORREPAY_AMT_I) {
		FORREPAY_AMT_I = fORREPAY_AMT_I;
	}
	public String getSAVE_FLAG_MASTER() {
		return SAVE_FLAG_MASTER;
	}
	public void setSAVE_FLAG_MASTER(String sAVE_FLAG_MASTER) {
		SAVE_FLAG_MASTER = sAVE_FLAG_MASTER;
	}
	public String getT_LOAN_NO_TEMP() {
		return T_LOAN_NO_TEMP;
	}
	public void setT_LOAN_NO_TEMP(String t_LOAN_NO_TEMP) {
		T_LOAN_NO_TEMP = t_LOAN_NO_TEMP;
	}
    
    
    
}
