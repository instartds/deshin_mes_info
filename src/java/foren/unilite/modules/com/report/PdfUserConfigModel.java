package foren.unilite.modules.com.report;

import foren.framework.model.BaseVO;

public class PdfUserConfigModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    
    private String PT_TITLENAME=null;
    private String PT_COMPANY_YN=null;
    private String PT_SANCTION_YN=null;
    private String PT_PAGENUM_YN=null;
    private String PT_OUTPUTDATE_YN=null;
    
    /* Session Variables */
    private String  S_COMP_CODE;
    private String  S_USER_ID;
    private String  PGM_ID;
    public String getPT_TITLENAME() {
        return PT_TITLENAME;
    }
    public void setPT_TITLENAME(String pT_TITLENAME) {
        PT_TITLENAME = pT_TITLENAME;
    }
    public String getPT_COMPANY_YN() {
        return PT_COMPANY_YN;
    }
    public void setPT_COMPANY_YN(String pT_COMPANY_YN) {
        PT_COMPANY_YN = pT_COMPANY_YN;
    }
    public String getPT_SANCTION_YN() {
        return PT_SANCTION_YN;
    }
    public void setPT_SANCTION_YN(String pT_SANCTION_YN) {
        PT_SANCTION_YN = pT_SANCTION_YN;
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
    public String getPGM_ID() {
        return PGM_ID;
    }
    public void setPGM_ID(String pGM_ID) {
        PGM_ID = pGM_ID;
    }
    
}
