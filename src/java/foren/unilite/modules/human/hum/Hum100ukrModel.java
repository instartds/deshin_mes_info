package foren.unilite.modules.human.hum;

import java.lang.reflect.Array;

import foren.framework.model.BaseVO;

public class Hum100ukrModel extends BaseVO {

    private static final long serialVersionUID = 1L;
    
    private String S_COMP_CODE;
    private String S_USER_ID;
    
    private String  COMP_CODE			;
    private String  PERSON_NUMB			; 
    private	String	SECT_CODE			;
    private	String	DIV_CODE			;
    private	String	NAME				;
    private	String	NAME_ENG			;
    private	String	NAME_CHI			;
    private	String	NATION_CODE			;
    private	String	LIVE_CODE			;
	private	String	DEPT_CODE			;
    private	String	DEPT_NAME			;
    private	String	POST_CODE			;
    private	String	JOB_CODE			;
    private	String	ABIL_CODE			;
    private	String	JOIN_CODE			;
    private	String	REPRE_NUM			;
    private	String	SEX_CODE			;
    private	String	ORI_JOIN_DATE	    ;
    private	String	JOIN_DATE			;
    private	String	RETR_DATE			;
    private	String	RETR_RESN			;
    private	String	EMPLOY_TYPE			;
    private	String	ZIP_CODE			;
    private	String	KOR_ADDR			;
    private  String   ORI_ZIP_CODE		;		
    private	String	ORI_ADDR			;
    private	String	TELEPHON			;
    private	String	PHONE_NO			;
    private	String	EMAIL_ADDR			;
    private	String	SCHSHIP_CODE		;
    private	String	GRADU_TYPE			;
    private	String	BUSS_OFFICE_CODE	;
    private	String	PAY_CODE			;
    private	String	TAX_CODE			;
    private	String	PAY_PROV_YN			;
    private	String	HIRE_INSUR_TYPE		;
    private	String	PAY_PROV_FLAG		;
    private	String	YEAR_GIVE			;
    private	String	MONTH_GIVE			;
    private	String	COMP_TAX_I			;
    private	String	RETR_GIVE			;
    private	String	RETR_PENSION_KIND   ;
    private	String	YEAR_CALCU			;
    private	String	BANKBOOK_NAME		;
    private	String	BANK_CODE1			;
    private	String	BANK_ACCOUNT1		;
    private	String  MED_AVG_I			;
    private String  TAXRATE_BASE        ;

	private String  PERSONALINFO        ; 
	private String  FOREIGN_DISPATCH_YN;
	
	private String  YOUTH_EXEMP_RATE;
	private String  RETR_PENSION_BANK;
	
	private String  MED_INSUR_DED_RATE;	
	private String  OLD_INSUR_DED_RATE;
	
	private String  PJT_CODE           ;
	private String  YEARENDTAX_INSTALLMENTS_YN    ;
    

	public String getYOUTH_EXEMP_RATE() {
		return YOUTH_EXEMP_RATE;
	}
	public void setYOUTH_EXEMP_RATE(String yOUTH_EXEMP_RATE) {
		YOUTH_EXEMP_RATE = yOUTH_EXEMP_RATE;
	}
	public String getFOREIGN_DISPATCH_YN() {
		return FOREIGN_DISPATCH_YN;
	}
	public void setFOREIGN_DISPATCH_YN(String fOREIGN_DISPATCH_YN) {
		FOREIGN_DISPATCH_YN = fOREIGN_DISPATCH_YN;
	}
	public String getPERSONALINFO() {
		return PERSONALINFO;
	}
	public void setPERSONALINFO(String pERSONALINFO) {
		PERSONALINFO = pERSONALINFO;
	}
    
    public String getMED_AVG_I() {
		return MED_AVG_I;
	}
	public void setMED_AVG_I(String mED_AVG_I) {
		MED_AVG_I = mED_AVG_I;
	}
	public String getTAXRATE_BASE() {
		return TAXRATE_BASE;
	}
	public void setTAXRATE_BASE(String tAXRATE_BASE) {
		TAXRATE_BASE = tAXRATE_BASE;
	}
	private	String 	MED_INSUR_I			;
    public String getMED_INSUR_I() {
		return MED_INSUR_I;
	}
	public void setMED_INSUR_I(String mED_INSUR_I) {
		MED_INSUR_I = mED_INSUR_I;
	}
	private	String	MED_INSUR_NO		;
    private	String   	HIRE_AVG_I			;
    public String getHIRE_AVG_I() {
		return HIRE_AVG_I;
	}
	public void setHIRE_AVG_I(String hIRE_AVG_I) {
		HIRE_AVG_I = hIRE_AVG_I;
	}
	private	String   	HIRE_INSUR_I		;
    public String getHIRE_INSUR_I() {
		return HIRE_INSUR_I;
	}
	public void setHIRE_INSUR_I(String hIRE_INSUR_I) {
		HIRE_INSUR_I = hIRE_INSUR_I;
	}
	private	String   	ANU_BASE_I			;
    public String getANU_BASE_I() {
		return ANU_BASE_I;
	}
	public void setANU_BASE_I(String aNU_BASE_I) {
		ANU_BASE_I = aNU_BASE_I;
	}
	private	String   	ANU_INSUR_I			;
    public String getANU_INSUR_I() {
		return ANU_INSUR_I;
	}
	public void setANU_INSUR_I(String aNU_INSUR_I) {
		ANU_INSUR_I = aNU_INSUR_I;
	}
	private	String	SPOUSE				;
    private	String	WOMAN				;
    private  String  ONE_PARENT         ;
    private	String   	SUPP_AGED_NUM		;
    public String getSUPP_AGED_NUM() {
		return SUPP_AGED_NUM;
	}
	public void setSUPP_AGED_NUM(String sUPP_AGED_NUM) {
		SUPP_AGED_NUM = sUPP_AGED_NUM;
	}
	private	String	DEFORM_YN			;
    private	String   	DEFORM_NUM			;
    public String getDEFORM_NUM() {
		return DEFORM_NUM;
	}
	public void setDEFORM_NUM(String dEFORM_NUM) {
		DEFORM_NUM = dEFORM_NUM;
	}
	private	String   	CHILD_20_NUM		;
    public String getCHILD_20_NUM() {
		return CHILD_20_NUM;
	}
	public void setCHILD_20_NUM(String cHILD_20_NUM) {
		CHILD_20_NUM = cHILD_20_NUM;
	}
	private	String   	AGED_NUM			;
    public String getAGED_NUM() {
		return AGED_NUM;
	}
	public void setAGED_NUM(String aGED_NUM) {
		AGED_NUM = aGED_NUM;
	}
	private	String   	AGED_NUM70			;
    public String getAGED_NUM70() {
		return AGED_NUM70;
	}
	public void setAGED_NUM70(String aGED_NUM70) {
		AGED_NUM70 = aGED_NUM70;
	}
	private	String   	BRING_CHILD_NUM		;
    public String getBRING_CHILD_NUM() {
		return BRING_CHILD_NUM;
	}
	public void setBRING_CHILD_NUM(String bRING_CHILD_NUM) {
		BRING_CHILD_NUM = bRING_CHILD_NUM;
	}
	private	String   	ANNUAL_SALARY_I		;
    public String getANNUAL_SALARY_I() {
		return ANNUAL_SALARY_I;
	}
	public void setANNUAL_SALARY_I(String aNNUAL_SALARY_I) {
		ANNUAL_SALARY_I = aNNUAL_SALARY_I;
	}
	private	String   	WAGES_STD_I			;
    public String getWAGES_STD_I() {
		return WAGES_STD_I;
	}
	public void setWAGES_STD_I(String wAGES_STD_I) {
		WAGES_STD_I = wAGES_STD_I;
	}
	private	String   	PAY_PRESERVE_I		;
    public String getPAY_PRESERVE_I() {
		return PAY_PRESERVE_I;
	}
	public void setPAY_PRESERVE_I(String pAY_PRESERVE_I) {
		PAY_PRESERVE_I = pAY_PRESERVE_I;
	}
	private	String   	BONUS_STD_I			;
    public String getBONUS_STD_I() {
		return BONUS_STD_I;
	}
	public void setBONUS_STD_I(String bONUS_STD_I) {
		BONUS_STD_I = bONUS_STD_I;
	}
	private	int   	COM_DAY_WAGES		;
    private	String   	COM_YEAR_WAGES		;
    public String getCOM_YEAR_WAGES() {
		return COM_YEAR_WAGES;
	}
	public void setCOM_YEAR_WAGES(String cOM_YEAR_WAGES) {
		COM_YEAR_WAGES = cOM_YEAR_WAGES;
	}
	private	String	OT_KIND				;
    private	String	BONUS_KIND			;
    private	String	MIL_TYPE			;
    private	String	ARMY_KIND			;
    private	String	ARMY_STRT_DATE		;
    private	String	ARMY_LAST_DATE		;
    private	String	ARMY_GRADE			;
    private	String	ARMY_MAJOR			;
    private	String	ARMY_NO				;
    private	String	WEDDING_DATE		;
    private	String	BIRTH_DATE			;
    private	String	SOLAR_YN			;
    private	String	MAKE_SALE			;
    private	String	COST_KIND			;
    private	String	PAY_GUBUN			;
    private	String	PAY_GUBUN2			;
    private String  DED_TYPE            ;
    private	String	PAY_GRADE_01		;
    private	String	PAY_GRADE_02		;
    private	String	FOREIGN_NUM			;
    private	String	FOREIGN_YN          ;
    private	String	RECOGN_NUM			;
    private	String	LIVE_GUBUN			;
    private	String	CARD_NUM			;
    private	String	LABOR_UNON_YN		;
    private	String	TRIAL_TERM_END_DATE	;
    private	String	MARRY_YN			;
    private String  HOUSEHOLDER_YN		;
    private	String	EMAIL_SEND_YN		;
    private	String	PAY_PROV_STOP_YN	;
    private	String	BONUS_PROV_YN		;
    private	String	WORK_COMPEN_YN		;
    private	Integer 	TAX_CODE2		;
    private	int   	RETR_BASE_MONEY		;
    private	String	YOUTH_EXEMP_DATE    ;
    private	String	YOUTH_EXEMP_DATE2   ;
    private	String	BANK_CODE2			;
    private	String	BANK_ACCOUNT2		;
    private	String	RETR_OT_KIND        ;
    private	String	END_INSUR_NO		;
    private	String	SOCIAL_INSUR_YN		;
    private	String	NATION_TYPE			;
    private	String	POLITICAL_BELIF		;
    private	String	HOUSE_CODE			;
    private	String	CONTRACT_PERIOD		;
    private	String	CONTRACT_FRDATE		;
    private	String	CONTRACT_TODATE		;
    private String  CONTRACT_TYPE       ;
    private	int   	RESIDENTIAL_TERM	;
    private	String	RESIDENTIAL_FRDATE	;
    private	String	RESIDENTIAL_TODATE	;
    private String  DORMITORY_USE_YN    ;
    private String  PROMOTION_DATE      ;
    private String  FOREIGN_SKILL_YN    ;
    private String  REMARK              ;
    private	String	ESS_PASSWORD        ;
    private	String	ESS_USE_YN          ;
    private String  PAY_METHOD          ;
    private String  WORKMAN_TYPE1       ;
    private String  WORKMAN_TYPE2       ;
    private String  WORK_SHOP_CODE      ;
    private String  PROG_WORK_CODE      ;
    private	String	MED_GRADE			;
    private	String	PENS_GRADE			;
    private String  INPUT_PGMID         ;
    private String  AFFIL_CODE			;
    private String  PAY_GRADE_BASE		;
    private String  YEAR_GRADE_BASE		;	
    private String  YEAR_GRADE			;
    private String  YOUTH_EXEMP_DATE3	;
    private String		ORI_MED_INSUR_I		;
    private String TRIAL_SALARY_RATE    ;
    
    public String getORI_MED_INSUR_I() {
		return ORI_MED_INSUR_I;
	}
	public void setORI_MED_INSUR_I(String oRI_MED_INSUR_I) {
		ORI_MED_INSUR_I = oRI_MED_INSUR_I;
	}
	private String		OLD_MED_INSUR_I		;
    public String getOLD_MED_INSUR_I() {
		return OLD_MED_INSUR_I;
	}
	public void setOLD_MED_INSUR_I(String oLD_MED_INSUR_I) {
		OLD_MED_INSUR_I = oLD_MED_INSUR_I;
	}
	private String  CIVIL_DEF_YN		;
    private String  CIVIL_DEF_NUM		;
    private String  REPRE_NUM_EXPOS     ;
	private String  BANK_ACCOUNT1_EXPOS     ;
    private String  BANK_ACCOUNT2_EXPOS     ;
    private String  FOREIGN_NUM_EXPOS     ;
    public String getBANK_ACCOUNT1_EXPOS() {
		return BANK_ACCOUNT1_EXPOS;
	}
	public void setBANK_ACCOUNT1_EXPOS(String bANK_ACCOUNT1_EXPOS) {
		BANK_ACCOUNT1_EXPOS = bANK_ACCOUNT1_EXPOS;
	}
	public String getBANK_ACCOUNT2_EXPOS() {
		return BANK_ACCOUNT2_EXPOS;
	}
	public void setBANK_ACCOUNT2_EXPOS(String bANK_ACCOUNT2_EXPOS) {
		BANK_ACCOUNT2_EXPOS = bANK_ACCOUNT2_EXPOS;
	}
	public String getFOREIGN_NUM_EXPOS() {
		return FOREIGN_NUM_EXPOS;
	}
	public void setFOREIGN_NUM_EXPOS(String fOREIGN_NUM_EXPOS) {
		FOREIGN_NUM_EXPOS = fOREIGN_NUM_EXPOS;
	}
    private String[] LABOR_UNON_CODE;   //가입노조 관련
    
    private String KNOC;
    private String REAL_WORK_PROD;
    private String BZNS_ATRB;
    private String HUMN_ATRB;
    
    private String CARD_NUM2;
    
    private String TEMP_STR1;
    private String TEMP_STR2;
    private String TEMP_STR3;
    private String TEMP_STR4;
    
    private String DEFORM_GRD;
    
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
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getPERSON_NUMB() {
		return PERSON_NUMB;
	}
	public void setPERSON_NUMB(String pERSON_NUMB) {
		PERSON_NUMB = pERSON_NUMB;
	}
	public String getSECT_CODE() {
		return SECT_CODE;
	}
	public void setSECT_CODE(String sECT_CODE) {
		SECT_CODE = sECT_CODE;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String nAME) {
		NAME = nAME;
	}
	public String getNAME_ENG() {
		return NAME_ENG;
	}
	public void setNAME_ENG(String nAME_ENG) {
		NAME_ENG = nAME_ENG;
	}
	public String getNAME_CHI() {
		return NAME_CHI;
	}
	public void setNAME_CHI(String nAME_CHI) {
		NAME_CHI = nAME_CHI;
	}
	public String getNATION_CODE() {
		return NATION_CODE;
	}
	public void setNATION_CODE(String nATION_CODE) {
		NATION_CODE = nATION_CODE;
	}
	public String getLIVE_CODE() {
		return LIVE_CODE;
	}
	public void setLIVE_CODE(String lIVE_CODE) {
		LIVE_CODE = lIVE_CODE;
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
	public String getJOB_CODE() {
		return JOB_CODE;
	}
	public void setJOB_CODE(String jOB_CODE) {
		JOB_CODE = jOB_CODE;
	}
	public String getABIL_CODE() {
		return ABIL_CODE;
	}
	public void setABIL_CODE(String aBIL_CODE) {
		ABIL_CODE = aBIL_CODE;
	}
	public String getJOIN_CODE() {
		return JOIN_CODE;
	}
	public void setJOIN_CODE(String jOIN_CODE) {
		JOIN_CODE = jOIN_CODE;
	}
	public String getREPRE_NUM() {
		return REPRE_NUM;
	}
	public void setREPRE_NUM(String rEPRE_NUM) {
		REPRE_NUM = rEPRE_NUM;
	}
	public String getSEX_CODE() {
		return SEX_CODE;
	}
	public void setSEX_CODE(String sEX_CODE) {
		SEX_CODE = sEX_CODE;
	}
	public String getORI_JOIN_DATE() {
		return ORI_JOIN_DATE;
	}
	public void setORI_JOIN_DATE(String oRI_JOIN_DATE) {
		ORI_JOIN_DATE = oRI_JOIN_DATE;
	}
	public String getJOIN_DATE() {
		return JOIN_DATE;
	}
	public void setJOIN_DATE(String jOIN_DATE) {
		JOIN_DATE = jOIN_DATE;
	}
	public String getRETR_DATE() {
		return RETR_DATE;
	}
	public void setRETR_DATE(String rETR_DATE) {
		RETR_DATE = rETR_DATE;
	}
	public String getRETR_RESN() {
		return RETR_RESN;
	}
	public void setRETR_RESN(String rETR_RESN) {
		RETR_RESN = rETR_RESN;
	}
	public String getEMPLOY_TYPE() {
		return EMPLOY_TYPE;
	}
	public void setEMPLOY_TYPE(String eMPLOY_TYPE) {
		EMPLOY_TYPE = eMPLOY_TYPE;
	}
	public String getZIP_CODE() {
		return ZIP_CODE;
	}
	public void setZIP_CODE(String zIP_CODE) {
		ZIP_CODE = zIP_CODE;
	}
	public String getKOR_ADDR() {
		return KOR_ADDR;
	}
	public void setKOR_ADDR(String kOR_ADDR) {
		KOR_ADDR = kOR_ADDR;
	}
	public String getORI_ZIP_CODE() {
		return ORI_ZIP_CODE;
	}
	public void setORI_ZIP_CODE(String oRI_ZIP_CODE) {
		ORI_ZIP_CODE = oRI_ZIP_CODE;
	}
	public String getORI_ADDR() {
		return ORI_ADDR;
	}
	public void setORI_ADDR(String oRI_ADDR) {
		ORI_ADDR = oRI_ADDR;
	}
	public String getTELEPHON() {
		return TELEPHON;
	}
	public void setTELEPHON(String tELEPHON) {
		TELEPHON = tELEPHON;
	}
	public String getPHONE_NO() {
		return PHONE_NO;
	}
	public void setPHONE_NO(String pHONE_NO) {
		PHONE_NO = pHONE_NO;
	}
	public String getEMAIL_ADDR() {
		return EMAIL_ADDR;
	}
	public void setEMAIL_ADDR(String eMAIL_ADDR) {
		EMAIL_ADDR = eMAIL_ADDR;
	}
	public String getSCHSHIP_CODE() {
		return SCHSHIP_CODE;
	}
	public void setSCHSHIP_CODE(String sCHSHIP_CODE) {
		SCHSHIP_CODE = sCHSHIP_CODE;
	}
	public String getGRADU_TYPE() {
		return GRADU_TYPE;
	}
	public void setGRADU_TYPE(String gRADU_TYPE) {
		GRADU_TYPE = gRADU_TYPE;
	}
	public String getBUSS_OFFICE_CODE() {
		return BUSS_OFFICE_CODE;
	}
	public void setBUSS_OFFICE_CODE(String bUSS_OFFICE_CODE) {
		BUSS_OFFICE_CODE = bUSS_OFFICE_CODE;
	}
	public String getPAY_CODE() {
		return PAY_CODE;
	}
	public void setPAY_CODE(String pAY_CODE) {
		PAY_CODE = pAY_CODE;
	}
	public String getTAX_CODE() {
		return TAX_CODE;
	}
	public void setTAX_CODE(String tAX_CODE) {
		TAX_CODE = tAX_CODE;
	}
	public String getPAY_PROV_YN() {
		return PAY_PROV_YN;
	}
	public void setPAY_PROV_YN(String pAY_PROV_YN) {
		PAY_PROV_YN = pAY_PROV_YN;
	}
	public String getHIRE_INSUR_TYPE() {
		return HIRE_INSUR_TYPE;
	}
	public void setHIRE_INSUR_TYPE(String hIRE_INSUR_TYPE) {
		HIRE_INSUR_TYPE = hIRE_INSUR_TYPE;
	}
	public String getPAY_PROV_FLAG() {
		return PAY_PROV_FLAG;
	}
	public void setPAY_PROV_FLAG(String pAY_PROV_FLAG) {
		PAY_PROV_FLAG = pAY_PROV_FLAG;
	}
	public String getYEAR_GIVE() {
		return YEAR_GIVE;
	}
	public void setYEAR_GIVE(String yEAR_GIVE) {
		YEAR_GIVE = yEAR_GIVE;
	}
	public String getMONTH_GIVE() {
		return MONTH_GIVE;
	}
	public void setMONTH_GIVE(String mONTH_GIVE) {
		MONTH_GIVE = mONTH_GIVE;
	}
	public String getCOMP_TAX_I() {
		return COMP_TAX_I;
	}
	public void setCOMP_TAX_I(String cOMP_TAX_I) {
		COMP_TAX_I = cOMP_TAX_I;
	}
	public String getRETR_GIVE() {
		return RETR_GIVE;
	}
	public void setRETR_GIVE(String rETR_GIVE) {
		RETR_GIVE = rETR_GIVE;
	}
	public String getRETR_PENSION_KIND() {
		return RETR_PENSION_KIND;
	}
	public void setRETR_PENSION_KIND(String rETR_PENSION_KIND) {
		RETR_PENSION_KIND = rETR_PENSION_KIND;
	}
	public String getYEAR_CALCU() {
		return YEAR_CALCU;
	}
	public void setYEAR_CALCU(String yEAR_CALCU) {
		YEAR_CALCU = yEAR_CALCU;
	}
	public String getBANKBOOK_NAME() {
		return BANKBOOK_NAME;
	}
	public void setBANKBOOK_NAME(String bANKBOOK_NAME) {
		BANKBOOK_NAME = bANKBOOK_NAME;
	}
	public String getBANK_CODE1() {
		return BANK_CODE1;
	}
	public void setBANK_CODE1(String bANK_CODE1) {
		BANK_CODE1 = bANK_CODE1;
	}
	public String getBANK_ACCOUNT1() {
		return BANK_ACCOUNT1;
	}
	public void setBANK_ACCOUNT1(String bANK_ACCOUNT1) {
		BANK_ACCOUNT1 = bANK_ACCOUNT1;
	}

	public String getMED_INSUR_NO() {
		return MED_INSUR_NO;
	}
	public void setMED_INSUR_NO(String mED_INSUR_NO) {
		MED_INSUR_NO = mED_INSUR_NO;
	}
	public String getSPOUSE() {
		return SPOUSE;
	}
	public void setSPOUSE(String sPOUSE) {
		SPOUSE = sPOUSE;
	}
	public String getWOMAN() {
		return WOMAN;
	}
	public void setWOMAN(String wOMAN) {
		WOMAN = wOMAN;
	}
	public String getONE_PARENT() {
		return ONE_PARENT;
	}
	public void setONE_PARENT(String oNE_PARENT) {
		ONE_PARENT = oNE_PARENT;
	}
	public String getDEFORM_YN() {
		return DEFORM_YN;
	}
	public void setDEFORM_YN(String dEFORM_YN) {
		DEFORM_YN = dEFORM_YN;
	}
	public int getCOM_DAY_WAGES() {
		return COM_DAY_WAGES;
	}
	public void setCOM_DAY_WAGES(int cOM_DAY_WAGES) {
		COM_DAY_WAGES = cOM_DAY_WAGES;
	}
	public String getOT_KIND() {
		return OT_KIND;
	}
	public void setOT_KIND(String oT_KIND) {
		OT_KIND = oT_KIND;
	}
	public String getBONUS_KIND() {
		return BONUS_KIND;
	}
	public void setBONUS_KIND(String bONUS_KIND) {
		BONUS_KIND = bONUS_KIND;
	}
	public String getMIL_TYPE() {
		return MIL_TYPE;
	}
	public void setMIL_TYPE(String mIL_TYPE) {
		MIL_TYPE = mIL_TYPE;
	}
	public String getARMY_KIND() {
		return ARMY_KIND;
	}
	public void setARMY_KIND(String aRMY_KIND) {
		ARMY_KIND = aRMY_KIND;
	}
	public String getARMY_STRT_DATE() {
		return ARMY_STRT_DATE;
	}
	public void setARMY_STRT_DATE(String aRMY_STRT_DATE) {
		ARMY_STRT_DATE = aRMY_STRT_DATE;
	}
	public String getARMY_LAST_DATE() {
		return ARMY_LAST_DATE;
	}
	public void setARMY_LAST_DATE(String aRMY_LAST_DATE) {
		ARMY_LAST_DATE = aRMY_LAST_DATE;
	}
	public String getARMY_GRADE() {
		return ARMY_GRADE;
	}
	public void setARMY_GRADE(String aRMY_GRADE) {
		ARMY_GRADE = aRMY_GRADE;
	}
	public String getARMY_MAJOR() {
		return ARMY_MAJOR;
	}
	public void setARMY_MAJOR(String aRMY_MAJOR) {
		ARMY_MAJOR = aRMY_MAJOR;
	}
	public String getARMY_NO() {
		return ARMY_NO;
	}
	public void setARMY_NO(String aRMY_NO) {
		ARMY_NO = aRMY_NO;
	}
	public String getWEDDING_DATE() {
		return WEDDING_DATE;
	}
	public void setWEDDING_DATE(String wEDDING_DATE) {
		WEDDING_DATE = wEDDING_DATE;
	}
	public String getBIRTH_DATE() {
		return BIRTH_DATE;
	}
	public void setBIRTH_DATE(String bIRTH_DATE) {
		BIRTH_DATE = bIRTH_DATE;
	}
	public String getSOLAR_YN() {
		return SOLAR_YN;
	}
	public void setSOLAR_YN(String sOLAR_YN) {
		SOLAR_YN = sOLAR_YN;
	}
	public String getMAKE_SALE() {
		return MAKE_SALE;
	}
	public void setMAKE_SALE(String mAKE_SALE) {
		MAKE_SALE = mAKE_SALE;
	}
	public String getCOST_KIND() {
		return COST_KIND;
	}
	public void setCOST_KIND(String cOST_KIND) {
		COST_KIND = cOST_KIND;
	}
	public String getPAY_GUBUN() {
		return PAY_GUBUN;
	}
	public void setPAY_GUBUN(String pAY_GUBUN) {
		PAY_GUBUN = pAY_GUBUN;
	}
	public String getPAY_GUBUN2() {
		return PAY_GUBUN2;
	}
	public void setPAY_GUBUN2(String pAY_GUBUN2) {
		PAY_GUBUN2 = pAY_GUBUN2;
	}
	public String getDED_TYPE() {
		return DED_TYPE;
	}
	public void setDED_TYPE(String dED_TYPE) {
		DED_TYPE = dED_TYPE;
	}
	public String getPAY_GRADE_01() {
		return PAY_GRADE_01;
	}
	public void setPAY_GRADE_01(String pAY_GRADE_01) {
		PAY_GRADE_01 = pAY_GRADE_01;
	}
	public String getPAY_GRADE_02() {
		return PAY_GRADE_02;
	}
	public void setPAY_GRADE_02(String pAY_GRADE_02) {
		PAY_GRADE_02 = pAY_GRADE_02;
	}
	public String getFOREIGN_NUM() {
		return FOREIGN_NUM;
	}
	public void setFOREIGN_NUM(String fOREIGN_NUM) {
		FOREIGN_NUM = fOREIGN_NUM;
	}
	public String getFOREIGN_YN() {
		return FOREIGN_YN;
	}
	public void setFOREIGN_YN(String fOREIGN_YN) {
		FOREIGN_YN = fOREIGN_YN;
	}
	public String getRECOGN_NUM() {
		return RECOGN_NUM;
	}
	public void setRECOGN_NUM(String rECOGN_NUM) {
		RECOGN_NUM = rECOGN_NUM;
	}
	public String getLIVE_GUBUN() {
		return LIVE_GUBUN;
	}
	public void setLIVE_GUBUN(String lIVE_GUBUN) {
		LIVE_GUBUN = lIVE_GUBUN;
	}
	public String getCARD_NUM() {
		return CARD_NUM;
	}
	public void setCARD_NUM(String cARD_NUM) {
		CARD_NUM = cARD_NUM;
	}
	public String getLABOR_UNON_YN() {
		return LABOR_UNON_YN;
	}
	public void setLABOR_UNON_YN(String lABOR_UNON_YN) {
		LABOR_UNON_YN = lABOR_UNON_YN;
	}
	public String getTRIAL_TERM_END_DATE() {
		return TRIAL_TERM_END_DATE;
	}
	public void setTRIAL_TERM_END_DATE(String tRIAL_TERM_END_DATE) {
		TRIAL_TERM_END_DATE = tRIAL_TERM_END_DATE;
	}
	public String getMARRY_YN() {
		return MARRY_YN;
	}
	public void setMARRY_YN(String mARRY_YN) {
		MARRY_YN = mARRY_YN;
	}
	public String getHOUSEHOLDER_YN() {
		return HOUSEHOLDER_YN;
	}
	public void setHOUSEHOLDER_YN(String hOUSEHOLDER_YN) {
		HOUSEHOLDER_YN = hOUSEHOLDER_YN;
	}
	public String getEMAIL_SEND_YN() {
		return EMAIL_SEND_YN;
	}
	public void setEMAIL_SEND_YN(String eMAIL_SEND_YN) {
		EMAIL_SEND_YN = eMAIL_SEND_YN;
	}
	public String getPAY_PROV_STOP_YN() {
		return PAY_PROV_STOP_YN;
	}
	public void setPAY_PROV_STOP_YN(String pAY_PROV_STOP_YN) {
		PAY_PROV_STOP_YN = pAY_PROV_STOP_YN;
	}
	public String getBONUS_PROV_YN() {
		return BONUS_PROV_YN;
	}
	public void setBONUS_PROV_YN(String bONUS_PROV_YN) {
		BONUS_PROV_YN = bONUS_PROV_YN;
	}
	public String getWORK_COMPEN_YN() {
		return WORK_COMPEN_YN;
	}
	public void setWORK_COMPEN_YN(String wORK_COMPEN_YN) {
		WORK_COMPEN_YN = wORK_COMPEN_YN;
	}
	public Integer getTAX_CODE2() {
		return TAX_CODE2;
	}
	public void setTAX_CODE2(Integer tAX_CODE2) {		
			TAX_CODE2 = tAX_CODE2;
	}
	public int getRETR_BASE_MONEY() {
		return RETR_BASE_MONEY;
	}
	public void setRETR_BASE_MONEY(int rETR_BASE_MONEY) {
		RETR_BASE_MONEY = rETR_BASE_MONEY;
	}
	public String getYOUTH_EXEMP_DATE() {
		return YOUTH_EXEMP_DATE;
	}
	public void setYOUTH_EXEMP_DATE(String yOUTH_EXEMP_DATE) {
		YOUTH_EXEMP_DATE = yOUTH_EXEMP_DATE;
	}
	public String getYOUTH_EXEMP_DATE2() {
		return YOUTH_EXEMP_DATE2;
	}
	public void setYOUTH_EXEMP_DATE2(String yOUTH_EXEMP_DATE2) {
		YOUTH_EXEMP_DATE2 = yOUTH_EXEMP_DATE2;
	}
	public String getBANK_CODE2() {
		return BANK_CODE2;
	}
	public void setBANK_CODE2(String bANK_CODE2) {
		BANK_CODE2 = bANK_CODE2;
	}
	public String getBANK_ACCOUNT2() {
		return BANK_ACCOUNT2;
	}
	public void setBANK_ACCOUNT2(String bANK_ACCOUNT2) {
		BANK_ACCOUNT2 = bANK_ACCOUNT2;
	}
	public String getRETR_OT_KIND() {
		return RETR_OT_KIND;
	}
	public void setRETR_OT_KIND(String rETR_OT_KIND) {
		RETR_OT_KIND = rETR_OT_KIND;
	}
	public String getEND_INSUR_NO() {
		return END_INSUR_NO;
	}
	public void setEND_INSUR_NO(String eND_INSUR_NO) {
		END_INSUR_NO = eND_INSUR_NO;
	}
	public String getSOCIAL_INSUR_YN() {
		return SOCIAL_INSUR_YN;
	}
	public void setSOCIAL_INSUR_YN(String sOCIAL_INSUR_YN) {
		SOCIAL_INSUR_YN = sOCIAL_INSUR_YN;
	}
	public String getNATION_TYPE() {
		return NATION_TYPE;
	}
	public void setNATION_TYPE(String nATION_TYPE) {
		NATION_TYPE = nATION_TYPE;
	}
	public String getPOLITICAL_BELIF() {
		return POLITICAL_BELIF;
	}
	public void setPOLITICAL_BELIF(String pOLITICAL_BELIF) {
		POLITICAL_BELIF = pOLITICAL_BELIF;
	}
	public String getHOUSE_CODE() {
		return HOUSE_CODE;
	}
	public void setHOUSE_CODE(String hOUSE_CODE) {
		HOUSE_CODE = hOUSE_CODE;
	}
	public String getCONTRACT_PERIOD() {
		return CONTRACT_PERIOD;
	}
	public void setCONTRACT_PERIOD(String cONTRACT_PERIOD) {
		CONTRACT_PERIOD = cONTRACT_PERIOD;
	}
	public String getCONTRACT_FRDATE() {
		return CONTRACT_FRDATE;
	}
	public void setCONTRACT_FRDATE(String cONTRACT_FRDATE) {
		CONTRACT_FRDATE = cONTRACT_FRDATE;
	}
	public String getCONTRACT_TODATE() {
		return CONTRACT_TODATE;
	}
	public void setCONTRACT_TODATE(String cONTRACT_TODATE) {
		CONTRACT_TODATE = cONTRACT_TODATE;
	}
	public String getCONTRACT_TYPE() {
		return CONTRACT_TYPE;
	}
	public void setCONTRACT_TYPE(String cONTRACT_TYPE) {
		CONTRACT_TYPE = cONTRACT_TYPE;
	}
	public int getRESIDENTIAL_TERM() {
		return RESIDENTIAL_TERM;
	}
	public void setRESIDENTIAL_TERM(int rESIDENTIAL_TERM) {
		RESIDENTIAL_TERM = rESIDENTIAL_TERM;
	}
	public String getRESIDENTIAL_FRDATE() {
		return RESIDENTIAL_FRDATE;
	}
	public void setRESIDENTIAL_FRDATE(String rESIDENTIAL_FRDATE) {
		RESIDENTIAL_FRDATE = rESIDENTIAL_FRDATE;
	}
	public String getRESIDENTIAL_TODATE() {
		return RESIDENTIAL_TODATE;
	}
	public void setRESIDENTIAL_TODATE(String rESIDENTIAL_TODATE) {
		RESIDENTIAL_TODATE = rESIDENTIAL_TODATE;
	}
	public String getDORMITORY_USE_YN() {
		return DORMITORY_USE_YN;
	}
	public void setDORMITORY_USE_YN(String dORMITORY_USE_YN) {
		DORMITORY_USE_YN = dORMITORY_USE_YN;
	}
	public String getPROMOTION_DATE() {
		return PROMOTION_DATE;
	}
	public void setPROMOTION_DATE(String pROMOTION_DATE) {
		PROMOTION_DATE = pROMOTION_DATE;
	}
	public String getFOREIGN_SKILL_YN() {
		return FOREIGN_SKILL_YN;
	}
	public void setFOREIGN_SKILL_YN(String fOREIGN_SKILL_YN) {
		FOREIGN_SKILL_YN = fOREIGN_SKILL_YN;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getESS_PASSWORD() {
		return ESS_PASSWORD;
	}
	public void setESS_PASSWORD(String eSS_PASSWORD) {
		ESS_PASSWORD = eSS_PASSWORD;
	}
	public String getESS_USE_YN() {
		return ESS_USE_YN;
	}
	public void setESS_USE_YN(String eSS_USE_YN) {
		ESS_USE_YN = eSS_USE_YN;
	}
	public String getPAY_METHOD() {
		return PAY_METHOD;
	}
	public void setPAY_METHOD(String pAY_METHOD) {
		PAY_METHOD = pAY_METHOD;
	}
	public String getWORKMAN_TYPE1() {
		return WORKMAN_TYPE1;
	}
	public void setWORKMAN_TYPE1(String wORKMAN_TYPE1) {
		WORKMAN_TYPE1 = wORKMAN_TYPE1;
	}
	public String getWORKMAN_TYPE2() {
		return WORKMAN_TYPE2;
	}
	public void setWORKMAN_TYPE2(String wORKMAN_TYPE2) {
		WORKMAN_TYPE2 = wORKMAN_TYPE2;
	}
	public String getWORK_SHOP_CODE() {
		return WORK_SHOP_CODE;
	}
	public void setWORK_SHOP_CODE(String wORK_SHOP_CODE) {
		WORK_SHOP_CODE = wORK_SHOP_CODE;
	}
	public String getPROG_WORK_CODE() {
		return PROG_WORK_CODE;
	}
	public void setPROG_WORK_CODE(String pROG_WORK_CODE) {
		PROG_WORK_CODE = pROG_WORK_CODE;
	}
	public String getMED_GRADE() {
		return MED_GRADE;
	}
	public void setMED_GRADE(String mED_GRADE) {
		MED_GRADE = mED_GRADE;
	}
	public String getPENS_GRADE() {
		return PENS_GRADE;
	}
	public void setPENS_GRADE(String pENS_GRADE) {
		PENS_GRADE = pENS_GRADE;
	}
	public String getINPUT_PGMID() {
		return INPUT_PGMID;
	}
	public void setINPUT_PGMID(String iNPUT_PGMID) {
		INPUT_PGMID = iNPUT_PGMID;
	}
	public String getAFFIL_CODE() {
		return AFFIL_CODE;
	}
	public void setAFFIL_CODE(String aFFIL_CODE) {
		AFFIL_CODE = aFFIL_CODE;
	}
	public String getPAY_GRADE_BASE() {
		return PAY_GRADE_BASE;
	}
	public void setPAY_GRADE_BASE(String pAY_GRADE_BASE) {
		PAY_GRADE_BASE = pAY_GRADE_BASE;
	}
	public String getYEAR_GRADE_BASE() {
		return YEAR_GRADE_BASE;
	}
	public void setYEAR_GRADE_BASE(String yEAR_GRADE_BASE) {
		YEAR_GRADE_BASE = yEAR_GRADE_BASE;
	}
	public String getYOUTH_EXEMP_DATE3() {
		return YOUTH_EXEMP_DATE3;
	}
	public void setYOUTH_EXEMP_DATE3(String yOUTH_EXEMP_DATE3) {
		YOUTH_EXEMP_DATE3 = yOUTH_EXEMP_DATE3;
	}
	public String getCIVIL_DEF_YN() {
		return CIVIL_DEF_YN;
	}
	public void setCIVIL_DEF_YN(String cIVIL_DEF_YN) {
		CIVIL_DEF_YN = cIVIL_DEF_YN;
	}
	public String getCIVIL_DEF_NUM() {
		return CIVIL_DEF_NUM;
	}
	public void setCIVIL_DEF_NUM(String cIVIL_DEF_NUM) {
		CIVIL_DEF_NUM = cIVIL_DEF_NUM;
	}
	public String getYEAR_GRADE() {
		return YEAR_GRADE;
	}
	public void setYEAR_GRADE(String yEAR_GRADE) {
		YEAR_GRADE = yEAR_GRADE;
	}
    public String getREPRE_NUM_EXPOS() {
        return REPRE_NUM_EXPOS;
    }
    public void setREPRE_NUM_EXPOS(String rEPRE_NUM_EXPOS) {
        REPRE_NUM_EXPOS = rEPRE_NUM_EXPOS;
    }
    
    public String[] getLABOR_UNON_CODE() {
        return LABOR_UNON_CODE;
    }
    public void setLABOR_UNON_CODE( String[] lABOR_UNON_CODE ) {
        LABOR_UNON_CODE = lABOR_UNON_CODE;
    }
    
    public String getKNOC() {
        return KNOC;
    }
    public void setKNOC( String kNOC ) {
        KNOC = kNOC;
    }
    public String getREAL_WORK_PROD() {
        return REAL_WORK_PROD;
    }
    public void setREAL_WORK_PROD( String rEAL_WORK_PROD ) {
        REAL_WORK_PROD = rEAL_WORK_PROD;
    }
    public String getBZNS_ATRB() {
        return BZNS_ATRB;
    }
    public void setBZNS_ATRB( String bZNS_ATRB ) {
        BZNS_ATRB = bZNS_ATRB;
    }
    public String getHUMN_ATRB() {
        return HUMN_ATRB;
    }
    public void setHUMN_ATRB( String hUMN_ATRB ) {
        HUMN_ATRB = hUMN_ATRB;
    }
    
    public String getTEMP_STR1() {
        return TEMP_STR1;
    }
    public void setTEMP_STR1( String tEMP_STR1 ) {
        TEMP_STR1 = tEMP_STR1;
    }
    public String getTEMP_STR2() {
        return TEMP_STR2;
    }
    public void setTEMP_STR2( String tEMP_STR2 ) {
        TEMP_STR2 = tEMP_STR2;
    }
    public String getTEMP_STR3() {
        return TEMP_STR3;
    }
    public void setTEMP_STR3( String tEMP_STR3 ) {
        TEMP_STR3 = tEMP_STR3;
    }
    public String getTEMP_STR4() {
        return TEMP_STR4;
    }
    public void setTEMP_STR4( String tEMP_STR4 ) {
        TEMP_STR4 = tEMP_STR4;
    }
    public String getCARD_NUM2() {
        return CARD_NUM2;
    }
    public void setCARD_NUM2( String cARD_NUM2 ) {
        CARD_NUM2 = cARD_NUM2;
    }
    
    public String getDEFORM_GRD() {
        return DEFORM_GRD;
    }
    public void setDEFORM_GRD( String dEFORM_GRD ) {
        DEFORM_GRD = dEFORM_GRD;
    }
    
    public String getRETR_PENSION_BANK() {
		return RETR_PENSION_BANK;
	}
	public void setRETR_PENSION_BANK(String rETR_PENSION_BANK) {
		RETR_PENSION_BANK = rETR_PENSION_BANK;
	}
	
	public String getMED_INSUR_DED_RATE() {
		return MED_INSUR_DED_RATE;
	}
	public void setMED_INSUR_DED_RATE(String mED_INSUR_DED_RATE) {
		MED_INSUR_DED_RATE = mED_INSUR_DED_RATE;
	}
	
	public String getOLD_INSUR_DED_RATE() {
		return OLD_INSUR_DED_RATE;
	}
	public void setOLD_INSUR_DED_RATE(String oLD_INSUR_DED_RATE) {
		OLD_INSUR_DED_RATE = oLD_INSUR_DED_RATE;
	}
	public String getPJT_CODE() {
		return PJT_CODE;
	}
	public void setPJT_CODE(String pJT_CODE) {
		PJT_CODE = pJT_CODE;
	}
	public String getYEARENDTAX_INSTALLMENTS_YN() {
		return YEARENDTAX_INSTALLMENTS_YN;
	}
	public void setYEARENDTAX_INSTALLMENTS_YN(String yEARENDTAX_INSTALLMENTS_YN) {
		YEARENDTAX_INSTALLMENTS_YN = yEARENDTAX_INSTALLMENTS_YN;
	}
	public String getTRIAL_SALARY_RATE() {
		return TRIAL_SALARY_RATE;
	}
	public void setTRIAL_SALARY_RATE(String tRIAL_SALARY_RATE) {
		TRIAL_SALARY_RATE = tRIAL_SALARY_RATE;
	}
	
}
