package foren.unilite.modules.base.bsa;

import foren.framework.model.BaseVO;

public class Bsa800ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    private String  USER_ID;
    private String  PGM_ID;
    
    private String  PT_COMPANY_YN;                 
    private String  PT_PAGENUM_YN;                  
    private String  PT_OUTPUTDATE_YN;               
    private String  PT_TITLENAME;                   
    private String  PT_SANCTION_YN;                   
    private String  BA_TOTAL_YN;                   
    private String  BA_GRDFOCUS_YN;                   
    private String  PT_COVER_YN;
	 
    private String  PT_SANCTION_NO;
    private String  PT_SANCTION_PO;
    private String  PT_SANCTION_NM1;
    private String  PT_SANCTION_NM2;
    private String  PT_SANCTION_NM3;
    private String  PT_SANCTION_NM4;
    private String  PT_SANCTION_NM5;
    private String  PT_SANCTION_NM6;
    private String  PT_SANCTION_NM7;
    private String  PT_SANCTION_NM8;
    
    private String  GUBUN_FLAG;
    private String  PT_SANCTION_NO_SEC;
    private String  PT_SANCTION_PO_SEC;
    private String  PT_SANCTION_NM1_SEC;
    private String  PT_SANCTION_NM2_SEC;
    private String  PT_SANCTION_NM3_SEC;
    private String  PT_SANCTION_NM4_SEC;
    private String  PT_SANCTION_NM5_SEC;
    private String  PT_SANCTION_NM6_SEC;
    private String  PT_SANCTION_NM7_SEC;
    private String  PT_SANCTION_NM8_SEC;
    
	/* Session Variables */
    private String  S_COMP_CODE;
    private String  S_USER_ID;
    private String  S_LANG_CODE;

    
	public String getUSER_ID() {
		return USER_ID;
	}
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	public String getPGM_ID() {
		return PGM_ID;
	}
	public void setPGM_ID(String pGM_ID) {
		PGM_ID = pGM_ID;
	}
	
	public String getPT_COMPANY_YN() {
		return PT_COMPANY_YN;
	}
	public void setPT_COMPANY_YN(String pT_COMPANY_YN) {
		PT_COMPANY_YN = pT_COMPANY_YN;
	}
	public String getPT_PAGENUM_YN() {
		return PT_PAGENUM_YN;
	}
	public void setPT_PAGENUM_YN(String pT_PAGENUM_YN) {
		PT_PAGENUM_YN = pT_PAGENUM_YN;
	}
	public String getPT_OUTPUTDATE_YN() {
		return PT_OUTPUTDATE_YN;
	}
	public void setPT_OUTPUTDATE_YN(String pT_OUTPUTDATE_YN) {
		PT_OUTPUTDATE_YN = pT_OUTPUTDATE_YN;
	}
	public String getPT_TITLENAME() {
		return PT_TITLENAME;
	}
	public void setPT_TITLENAME(String pT_TITLENAME) {
		PT_TITLENAME = pT_TITLENAME;
	}
	
	
	public String getBA_TOTAL_YN() {
		return BA_TOTAL_YN;
	}
	public void setBA_TOTAL_YN(String bA_TOTAL_YN) {
		BA_TOTAL_YN = bA_TOTAL_YN;
	}
	public String getBA_GRDFOCUS_YN() {
		return BA_GRDFOCUS_YN;
	}
	public void setBA_GRDFOCUS_YN(String bA_GRDFOCUS_YN) {
		BA_GRDFOCUS_YN = bA_GRDFOCUS_YN;
	}
	public String getPT_COVER_YN() {
		return PT_COVER_YN;
	}
	public void setPT_COVER_YN(String pT_COVER_YN) {
		PT_COVER_YN = pT_COVER_YN;
	}
	public String getPT_SANCTION_YN() {
		return PT_SANCTION_YN;
	}
	public void setPT_SANCTION_YN(String pT_SANCTION_YN) {
		PT_SANCTION_YN = pT_SANCTION_YN;
	}
	public String getPT_SANCTION_NO() {
		return PT_SANCTION_NO;
	}
	public void setPT_SANCTION_NO(String pT_SANCTION_NO) {
		PT_SANCTION_NO = pT_SANCTION_NO;
	}
	public String getPT_SANCTION_PO() {
		return PT_SANCTION_PO;
	}
	public void setPT_SANCTION_PO(String pT_SANCTION_PO) {
		PT_SANCTION_PO = pT_SANCTION_PO;
	}
	public String getPT_SANCTION_NM1() {
		return PT_SANCTION_NM1;
	}
	public void setPT_SANCTION_NM1(String pT_SANCTION_NM1) {
		PT_SANCTION_NM1 = pT_SANCTION_NM1;
	}
	public String getPT_SANCTION_NM2() {
		return PT_SANCTION_NM2;
	}
	public void setPT_SANCTION_NM2(String pT_SANCTION_NM2) {
		PT_SANCTION_NM2 = pT_SANCTION_NM2;
	}
	public String getPT_SANCTION_NM3() {
		return PT_SANCTION_NM3;
	}
	public void setPT_SANCTION_NM3(String pT_SANCTION_NM3) {
		PT_SANCTION_NM3 = pT_SANCTION_NM3;
	}
	public String getPT_SANCTION_NM4() {
		return PT_SANCTION_NM4;
	}
	public void setPT_SANCTION_NM4(String pT_SANCTION_NM4) {
		PT_SANCTION_NM4 = pT_SANCTION_NM4;
	}
	public String getPT_SANCTION_NM5() {
		return PT_SANCTION_NM5;
	}
	public void setPT_SANCTION_NM5(String pT_SANCTION_NM5) {
		PT_SANCTION_NM5 = pT_SANCTION_NM5;
	}
	public String getPT_SANCTION_NM6() {
		return PT_SANCTION_NM6;
	}
	public void setPT_SANCTION_NM6(String pT_SANCTION_NM6) {
		PT_SANCTION_NM6 = pT_SANCTION_NM6;
	}
	public String getPT_SANCTION_NM7() {
		return PT_SANCTION_NM7;
	}
	public void setPT_SANCTION_NM7(String pT_SANCTION_NM7) {
		PT_SANCTION_NM7 = pT_SANCTION_NM7;
	}
	public String getPT_SANCTION_NM8() {
		return PT_SANCTION_NM8;
	}
	public void setPT_SANCTION_NM8(String pT_SANCTION_NM8) {
		PT_SANCTION_NM8 = pT_SANCTION_NM8;
	}
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
	public String getS_LANG_CODE() {
		return S_LANG_CODE;
	}
	public void setS_LANG_CODE(String s_LANG_CODE) {
		S_LANG_CODE = s_LANG_CODE;
	}
	
	public String getGUBUN_FLAG() {
        return GUBUN_FLAG;
    }
    public void setGUBUN_FLAG( String gUBUN_FLAG ) {
        GUBUN_FLAG = gUBUN_FLAG;
    }
    public String getPT_SANCTION_NO_SEC() {
        return PT_SANCTION_NO_SEC;
    }
    public void setPT_SANCTION_NO_SEC( String pT_SANCTION_NO_SEC ) {
        PT_SANCTION_NO_SEC = pT_SANCTION_NO_SEC;
    }
    public String getPT_SANCTION_PO_SEC() {
        return PT_SANCTION_PO_SEC;
    }
    public void setPT_SANCTION_PO_SEC( String pT_SANCTION_PO_SEC ) {
        PT_SANCTION_PO_SEC = pT_SANCTION_PO_SEC;
    }
    public String getPT_SANCTION_NM1_SEC() {
        return PT_SANCTION_NM1_SEC;
    }
    public void setPT_SANCTION_NM1_SEC( String pT_SANCTION_NM1_SEC ) {
        PT_SANCTION_NM1_SEC = pT_SANCTION_NM1_SEC;
    }
    public String getPT_SANCTION_NM2_SEC() {
        return PT_SANCTION_NM2_SEC;
    }
    public void setPT_SANCTION_NM2_SEC( String pT_SANCTION_NM2_SEC ) {
        PT_SANCTION_NM2_SEC = pT_SANCTION_NM2_SEC;
    }
    public String getPT_SANCTION_NM3_SEC() {
        return PT_SANCTION_NM3_SEC;
    }
    public void setPT_SANCTION_NM3_SEC( String pT_SANCTION_NM3_SEC ) {
        PT_SANCTION_NM3_SEC = pT_SANCTION_NM3_SEC;
    }
    public String getPT_SANCTION_NM4_SEC() {
        return PT_SANCTION_NM4_SEC;
    }
    public void setPT_SANCTION_NM4_SEC( String pT_SANCTION_NM4_SEC ) {
        PT_SANCTION_NM4_SEC = pT_SANCTION_NM4_SEC;
    }
    public String getPT_SANCTION_NM5_SEC() {
        return PT_SANCTION_NM5_SEC;
    }
    public void setPT_SANCTION_NM5_SEC( String pT_SANCTION_NM5_SEC ) {
        PT_SANCTION_NM5_SEC = pT_SANCTION_NM5_SEC;
    }
    public String getPT_SANCTION_NM6_SEC() {
        return PT_SANCTION_NM6_SEC;
    }
    public void setPT_SANCTION_NM6_SEC( String pT_SANCTION_NM6_SEC ) {
        PT_SANCTION_NM6_SEC = pT_SANCTION_NM6_SEC;
    }
    public String getPT_SANCTION_NM7_SEC() {
        return PT_SANCTION_NM7_SEC;
    }
    public void setPT_SANCTION_NM7_SEC( String pT_SANCTION_NM7_SEC ) {
        PT_SANCTION_NM7_SEC = pT_SANCTION_NM7_SEC;
    }
    public String getPT_SANCTION_NM8_SEC() {
        return PT_SANCTION_NM8_SEC;
    }
    public void setPT_SANCTION_NM8_SEC( String pT_SANCTION_NM8_SEC ) {
        PT_SANCTION_NM8_SEC = pT_SANCTION_NM8_SEC;
    }
}
