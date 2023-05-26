package foren.unilite.modules.accnt.aba;
import foren.framework.model.BaseVO;

public class Aba060ukrvModel extends BaseVO{
	private static final long serialVersionUID = 1L;
	
	private String S012_1;
	private String S012_2;
	private String S012_3;
	private String S012_4;
	private String S012_5;
	private String S012_6;
	private String S012_7;
	private String S012_8;
	
	private String S022_1;
	private String S022_2;
	private String S022_3;
	private String S022_4;
	private String S022_5;
	private String S022_6;
	
	private String S026_1;
	private String S019_1;
	private String TAX;
	private String S025_1;
	private String S031_1;
	private String S029_1;
	private String S033_1;
	private String S034_1;
	private String S035_1;
	private String S038_1;
	private String S044_1;
	
	private String FORMAT_QTY;
	private String FORMAT_PRICE;
	private String FORMAT_IN;
	private String FORMAT_OUT;
	private String FORMAT_RATE;
	
	private String  S_COMP_CODE;
	private String  S_USER_ID;
	//회계기준설정 관련 
	private String BASE_CODE;
	private String SLIP_NUM1;		
	private String SLIP_NUM2;		
	private String PROD_ACCNT;	
	private String CIRCUL_ACCNT;	
	private String CONT_ACCNT;	
	private String SELL_ACCNT;	
	private String AMT_POINT;		
	private String BUDG_YN;	
	private String BUDG_BASE;		
	private String REPAY_BASE;	
	private String REPAY_METHOD;	
	private String REPAY_COMPUTE;	
	private String SALE_BASE;		
	private String SALE_METHOD;	
	private String EXCHG_BASE;	
	private String PEND_YN;		
	private String DEL_DATE;		
	private String TAX_BASE;
	
    private String ASST_AUTOCD;   
	private String PAY_TYPE;      
	private String PJT_CODE_ESS;  
	private String ITEM_CODE_ESS; 
	
	private String PAY_AP_BASE;
	private String GOV_GRANT_CONT;
	private String BASE_BALANCE_DATE_YN;
	
	public String getBASE_CODE() {
		return BASE_CODE;
	}
	public void setBASE_CODE(String sBASE_CODE) {
		BASE_CODE = sBASE_CODE;
	}
	public String getSLIP_NUM1() {
		return SLIP_NUM1;
	}
	public void setSLIP_NUM1(String sLIP_NUM1) {
		SLIP_NUM1 = sLIP_NUM1;
	}
	public String getSLIP_NUM2() {
		return SLIP_NUM2;
	}
	public void setSLIP_NUM2(String sLIP_NUM2) {
		SLIP_NUM2 = sLIP_NUM2;
	}
	public String getPROD_ACCNT() {
		return PROD_ACCNT;
	}
	public void setPROD_ACCNT(String pROD_ACCNT) {
		PROD_ACCNT = pROD_ACCNT;
	}
	public String getCIRCUL_ACCNT() {
		return CIRCUL_ACCNT;
	}
	public void setCIRCUL_ACCNT(String cIRCUL_ACCNT) {
		CIRCUL_ACCNT = cIRCUL_ACCNT;
	}
	public String getCONT_ACCNT() {
		return CONT_ACCNT;
	}
	public void setCONT_ACCNT(String cONT_ACCNT) {
		CONT_ACCNT = cONT_ACCNT;
	}
	public String getSELL_ACCNT() {
		return SELL_ACCNT;
	}
	public void setSELL_ACCNT(String sELL_ACCNT) {
		SELL_ACCNT = sELL_ACCNT;
	}
	public String getAMT_POINT() {
		return AMT_POINT;
	}
	public void setAMT_POINT(String aMT_POINT) {
		AMT_POINT = aMT_POINT;
	}
	public String getBUDG_YN() {
		return BUDG_YN;
	}
	public void setBUDG_YN(String bUDG_YN) {
		BUDG_YN = bUDG_YN;
	}
	public String getBUDG_BASE() {
		return BUDG_BASE;
	}
	public void setBUDG_BASE(String bUDG_BASE) {
		BUDG_BASE = bUDG_BASE;
	}
	public String getREPAY_BASE() {
		return REPAY_BASE;
	}
	public void setREPAY_BASE(String rEPAY_BASE) {
		REPAY_BASE = rEPAY_BASE;
	}
	public String getREPAY_METHOD() {
		return REPAY_METHOD;
	}
	public void setREPAY_METHOD(String rEPAY_METHOD) {
		REPAY_METHOD = rEPAY_METHOD;
	}
	public String getREPAY_COMPUTE() {
		return REPAY_COMPUTE;
	}
	public void setREPAY_COMPUTE(String rEPAY_COMPUTE) {
		REPAY_COMPUTE = rEPAY_COMPUTE;
	}
	public String getSALE_BASE() {
		return SALE_BASE;
	}
	public void setSALE_BASE(String sALE_BASE) {
		SALE_BASE = sALE_BASE;
	}
	public String getSALE_METHOD() {
		return SALE_METHOD;
	}
	public void setSALE_METHOD(String sALE_METHOD) {
		SALE_METHOD = sALE_METHOD;
	}
	public String getEXCHG_BASE() {
		return EXCHG_BASE;
	}
	public void setEXCHG_BASE(String eXCHG_BASE) {
		EXCHG_BASE = eXCHG_BASE;
	}
	public String getPEND_YN() {
		return PEND_YN;
	}
	public void setPEND_YN(String pEND_YN) {
		PEND_YN = pEND_YN;
	}
	public String getDEL_DATE() {
		return DEL_DATE;
	}
	public void setDEL_DATE(String dEL_DATE) {
		DEL_DATE = dEL_DATE;
	}
	public String getTAX_BASE() {
		return TAX_BASE;
	}
	public void setTAX_BASE(String tAX_BASE) {
		TAX_BASE = tAX_BASE;
	}
	public String getBILL_DIV_CODE() {
		return BILL_DIV_CODE;
	}
	public void setBILL_DIV_CODE(String bILL_DIV_CODE) {
		BILL_DIV_CODE = bILL_DIV_CODE;
	}
	public String getUPDATE_DB_USER() {
		return UPDATE_DB_USER;
	}
	public void setUPDATE_DB_USER(String uPDATE_DB_USER) {
		UPDATE_DB_USER = uPDATE_DB_USER;
	}
	public String getUPDATE_DB_TIME() {
		return UPDATE_DB_TIME;
	}
	public void setUPDATE_DB_TIME(String uPDATE_DB_TIME) {
		UPDATE_DB_TIME = uPDATE_DB_TIME;
	}
	public String getRETURN_YN() {
		return RETURN_YN;
	}
	public void setRETURN_YN(String rETURN_YN) {
		RETURN_YN = rETURN_YN;
	}
	public String getSLIP_PRINT() {
		return SLIP_PRINT;
	}
	public void setSLIP_PRINT(String sLIP_PRINT) {
		SLIP_PRINT = sLIP_PRINT;
	}
	public String getPRINT_LINE() {
		return PRINT_LINE;
	}
	public void setPRINT_LINE(String pRINT_LINE) {
		PRINT_LINE = pRINT_LINE;
	}
	public String getAPP_NUM() {
		return APP_NUM;
	}
	public void setAPP_NUM(String aPP_NUM) {
		APP_NUM = aPP_NUM;
	}
	public String getMATRL_YN() {
		return MATRL_YN;
	}
	public void setMATRL_YN(String mATRL_YN) {
		MATRL_YN = mATRL_YN;
	}
	public String getASST_QTY_YN() {
		return ASST_QTY_YN;
	}
	public void setASST_QTY_YN(String aSST_QTY_YN) {
		ASST_QTY_YN = aSST_QTY_YN;
	}
	public String getIWOL_DIVI_YN() {
		return IWOL_DIVI_YN;
	}
	public void setIWOL_DIVI_YN(String iWOL_DIVI_YN) {
		IWOL_DIVI_YN = iWOL_DIVI_YN;
	}
	public String getSLIP_MSG() {
		return SLIP_MSG;
	}
	public void setSLIP_MSG(String sLIP_MSG) {
		SLIP_MSG = sLIP_MSG;
	}
	public String getASST_PRICE_YN() {
		return ASST_PRICE_YN;
	}
	public void setASST_PRICE_YN(String aSST_PRICE_YN) {
		ASST_PRICE_YN = aSST_PRICE_YN;
	}
	public String getBUDG_PRO_BASE() {
		return BUDG_PRO_BASE;
	}
	public void setBUDG_PRO_BASE(String bUDG_PRO_BASE) {
		BUDG_PRO_BASE = bUDG_PRO_BASE;
	}
	private String BILL_DIV_CODE;	
	private String UPDATE_DB_USER;
	private String UPDATE_DB_TIME;
	private String RETURN_YN;		
	private String SLIP_PRINT;	
	private String PRINT_LINE;	
	private String APP_NUM;		
	private String MATRL_YN;		
	private String ASST_QTY_YN;	
	private String IWOL_DIVI_YN;	
	private String SLIP_MSG;		
	private String ASST_PRICE_YN;	
	private String BUDG_PRO_BASE;	
	
	
	
	
	
	
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
	
	public String getS012_1() {
		return S012_1;
	}
	public void setS012_1(String s012_1) {
		S012_1 = s012_1;
	}
	public String getS012_2() {
		return S012_2;
	}
	public void setS012_2(String s012_2) {
		S012_2 = s012_2;
	}
	public String getS012_3() {
		return S012_3;
	}
	public void setS012_3(String s012_3) {
		S012_3 = s012_3;
	}
	public String getS012_4() {
		return S012_4;
	}
	public void setS012_4(String s012_4) {
		S012_4 = s012_4;
	}
	public String getS012_5() {
		return S012_5;
	}
	public void setS012_5(String s012_5) {
		S012_5 = s012_5;
	}
	public String getS012_6() {
		return S012_6;
	}
	public void setS012_6(String s012_6) {
		S012_6 = s012_6;
	}
	public String getS012_7() {
		return S012_7;
	}
	public void setS012_7(String s012_7) {
		S012_7 = s012_7;
	}
	public String getS012_8() {
		return S012_8;
	}
	public void setS012_8(String s012_8) {
		S012_8 = s012_8;
	}
	public String getS022_1() {
		return S022_1;
	}
	public void setS022_1(String s022_1) {
		S022_1 = s022_1;
	}
	public String getS022_2() {
		return S022_2;
	}
	public void setS022_2(String s022_2) {
		S022_2 = s022_2;
	}
	public String getS022_3() {
		return S022_3;
	}
	public void setS022_3(String s022_3) {
		S022_3 = s022_3;
	}
	public String getS022_4() {
		return S022_4;
	}
	public void setS022_4(String s022_4) {
		S022_4 = s022_4;
	}
	public String getS022_5() {
		return S022_5;
	}
	public void setS022_5(String s022_5) {
		S022_5 = s022_5;
	}
	public String getS022_6() {
		return S022_6;
	}
	public void setS022_6(String s022_6) {
		S022_6 = s022_6;
	}
	public String getS026_1() {
		return S026_1;
	}
	public void setS026_1(String s026_1) {
		S026_1 = s026_1;
	}
	public String getS019_1() {
		return S019_1;
	}
	public void setS019_1(String s019_1) {
		S019_1 = s019_1;
	}
	public String getTAX() {
		return TAX;
	}
	public void setTAX(String tAX) {
		TAX = tAX;
	}
	public String getS025_1() {
		return S025_1;
	}
	public void setS025_1(String s025_1) {
		S025_1 = s025_1;
	}
	public String getS031_1() {
		return S031_1;
	}
	public void setS031_1(String s031_1) {
		S031_1 = s031_1;
	}
	public String getS029_1() {
		return S029_1;
	}
	public void setS029_1(String s029_1) {
		S029_1 = s029_1;
	}
	public String getS033_1() {
		return S033_1;
	}
	public void setS033_1(String s033_1) {
		S033_1 = s033_1;
	}
	public String getS034_1() {
		return S034_1;
	}
	public void setS034_1(String s034_1) {
		S034_1 = s034_1;
	}
	public String getS035_1() {
		return S035_1;
	}
	public void setS035_1(String s035_1) {
		S035_1 = s035_1;
	}
	public String getS038_1() {
		return S038_1;
	}
	public void setS038_1(String s038_1) {
		S038_1 = s038_1;
	}
	public String getS044_1() {
		return S044_1;
	}
	public void setS044_1(String s044_1) {
		S044_1 = s044_1;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getFORMAT_QTY() {
		return FORMAT_QTY;
	}
	public void setFORMAT_QTY(String fORMAT_QTY) {
		FORMAT_QTY = fORMAT_QTY;
	}
	public String getFORMAT_PRICE() {
		return FORMAT_PRICE;
	}
	public void setFORMAT_PRICE(String fORMAT_PRICE) {
		FORMAT_PRICE = fORMAT_PRICE;
	}
	public String getFORMAT_IN() {
		return FORMAT_IN;
	}
	public void setFORMAT_IN(String fORMAT_IN) {
		FORMAT_IN = fORMAT_IN;
	}
	public String getFORMAT_OUT() {
		return FORMAT_OUT;
	}
	public void setFORMAT_OUT(String fORMAT_OUT) {
		FORMAT_OUT = fORMAT_OUT;
	}
	public String getFORMAT_RATE() {
		return FORMAT_RATE;
	}
	public void setFORMAT_RATE(String fORMAT_RATE) {
		FORMAT_RATE = fORMAT_RATE;
	}
	
	public String getASST_AUTOCD() {
        return ASST_AUTOCD;
    }
    public void setASST_AUTOCD( String aSST_AUTOCD ) {
        ASST_AUTOCD = aSST_AUTOCD;
    }
    public String getPAY_TYPE() {
        return PAY_TYPE;
    }
    public void setPAY_TYPE( String pAY_TYPE ) {
        PAY_TYPE = pAY_TYPE;
    }
    public String getPJT_CODE_ESS() {
        return PJT_CODE_ESS;
    }
    public void setPJT_CODE_ESS( String pJT_CODE_ESS ) {
        PJT_CODE_ESS = pJT_CODE_ESS;
    }
    public String getITEM_CODE_ESS() {
        return ITEM_CODE_ESS;
    }
    public void setITEM_CODE_ESS( String iTEM_CODE_ESS ) {
        ITEM_CODE_ESS = iTEM_CODE_ESS;
    }
    public String getPAY_AP_BASE() {
        return PAY_AP_BASE;
    }
    public void setPAY_AP_BASE( String pAY_AP_BASE ) {
        PAY_AP_BASE = pAY_AP_BASE;
    }
	public String getGOV_GRANT_CONT() {
		return GOV_GRANT_CONT;
	}
	public void setGOV_GRANT_CONT(String gOV_GRANT_CONT) {
		GOV_GRANT_CONT = gOV_GRANT_CONT;
	}
	public String getBASE_BALANCE_DATE_YN() {
		return BASE_BALANCE_DATE_YN;
	}
	public void setBASE_BALANCE_DATE_YN(String bASE_BALANCE_DATE_YN) {
		BASE_BALANCE_DATE_YN = bASE_BALANCE_DATE_YN;
	}
    
    
}
