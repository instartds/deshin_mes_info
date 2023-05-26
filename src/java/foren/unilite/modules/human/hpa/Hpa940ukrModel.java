package foren.unilite.modules.human.hpa;

import foren.framework.model.BaseVO;

public class Hpa940ukrModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    



	@Override
	public String toString() {
		return "Hpa940ukrModel [gubun=" + gubun + ", S_COMP_CODE=" + S_COMP_CODE + ", PAY_YYYYMM=" + PAY_YYYYMM + ", SUPP_TYPE=" + SUPP_TYPE + ", DIV_CODE=" + DIV_CODE + ", DEPT_CODE=" + DEPT_CODE + ", DEPT_NAME=" + DEPT_NAME
				+ ", POST_CODE=" + POST_CODE + ", NAME=" + NAME + ", PERSON_NUMB=" + PERSON_NUMB + ", EMAIL_ADDR=" + EMAIL_ADDR + ", COMMENTS=" + COMMENTS + ", SUPP_NAME=" + SUPP_NAME + ", FROM_ADDR=" + FROM_ADDR + ", TITLE=" + TITLE
				+ ", YEAR_YN=" + YEAR_YN + ", WORK_YN=" + WORK_YN + "]";
	}
	/* Primary Key */
    private String gubun;
    private String S_COMP_CODE;
    private String PAY_YYYYMM;
    private String SUPP_TYPE;
    private String DIV_CODE;
    private String DEPT_CODE;
    
    private String  DEPT_NAME;
    private String POST_CODE;
    private String NAME;
    private String PERSON_NUMB;
    private String EMAIL_ADDR;
    private String COMMENTS;
    private String SUPP_NAME;
    private String FROM_ADDR;
    private String TITLE;
    private String CONTAIN_ZERO;
    private String DETAIL_ZERO;
    private String S_USER_ID;
    
    
    public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getDETAIL_ZERO() {
		return DETAIL_ZERO;
	}
	public void setDETAIL_ZERO(String dETAIL_ZERO) {
		DETAIL_ZERO = dETAIL_ZERO;
	}
	public String getCONTAIN_ZERO() {
		return CONTAIN_ZERO;
	}
	public void setCONTAIN_ZERO(String cONTAIN_ZERO) {
		CONTAIN_ZERO = cONTAIN_ZERO;
	}
	public String getTITLE() {
		return TITLE;
	}
	public void setTITLE(String tITLE) {
		TITLE = tITLE;
	}
	public String getSUPP_NAME() {
		return SUPP_NAME;
	}
	public void setSUPP_NAME(String sUPP_NAME) {
		SUPP_NAME = sUPP_NAME;
	}
	public String getYEAR_YN() {
		return YEAR_YN;
	}
	public void setYEAR_YN(String yEAR_YN) {
		YEAR_YN = yEAR_YN;
	}
	public String getWORK_YN() {
		return WORK_YN;
	}
	public void setWORK_YN(String wORK_YN) {
		WORK_YN = wORK_YN;
	}
	private String YEAR_YN;
    private String WORK_YN;
    
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getPAY_YYYYMM() {
		return PAY_YYYYMM;
	}
	public void setPAY_YYYYMM(String pAY_YYYYMM) {
		PAY_YYYYMM = pAY_YYYYMM;
	}
	public String getSUPP_TYPE() {
		return SUPP_TYPE;
	}
	public void setSUPP_TYPE(String sUPP_TYPE) {
		SUPP_TYPE = sUPP_TYPE;
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
	public String getPOST_CODE() {
		return POST_CODE;
	}
	public void setPOST_CODE(String pOST_CODE) {
		POST_CODE = pOST_CODE;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String nAME) {
		NAME = nAME;
	}
	public String getPERSON_NUMB() {
		return PERSON_NUMB;
	}
	public void setPERSON_NUMB(String pERSON_NUMB) {
		PERSON_NUMB = pERSON_NUMB;
	}
	public String getEMAIL_ADDR() {
		return EMAIL_ADDR;
	}
	public void setEMAIL_ADDR(String eMAIL_ADDR) {
		EMAIL_ADDR = eMAIL_ADDR;
	}
	
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public String getCOMMENTS() {
		return COMMENTS;
	}
	public void setCOMMENTS(String cOMMENTS) {
		COMMENTS = cOMMENTS;
	}
	public String getFROM_ADDR() {
		return FROM_ADDR;
	}
	public void setFROM_ADDR(String fROM_ADDR) {
		FROM_ADDR = fROM_ADDR;
	}

	
}
