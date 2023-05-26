package foren.unilite.modules.z_kocis;

import foren.framework.model.BaseVO;

/**
 * @author jangwonhyeok
 *
 */
public class S_Ass900ukrModel_KOCIS extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
    private String ITEM_CODE;
    private String ITEM_NM;
	private String DEPT_CODE;
    private String DEPT_NAME;
    private String ADDR;					//소재지
    private String APP_USER;				//담당자
    private String ACQ_AMT_I;
    private String EXPECT_AMT_I;
    private String INSUR_YN;
    private String OPEN_YN;
    private String REMARK;
    private String ITEM_DESC;
    private String ITEM_GBN;
    private String AUTHOR;
    private String AUTHOR_HO;
    private String X_LENGTH;
    private String Y_LENGTH;
    private String Z_LENGTH;
    private String ITEM_DIR;
    private String PURCHASE_WHY;
    private String VALUE_GUBUN;
    private String ITEM_STATE;
    private String PURCHASE_DATE;
    private String ESTATE_AMT_I;
    private String SALES_AMT_I;
    private String CLOSING_YEAR;
    private String FIRST_CHECK_YN;
    private String FIRST_CHECK_DATE;
    private String FIRST_CHECK_DESC;
    private String FIRST_CHECK_USR;
    private String SECOND_CHECK_YN;
    private String SECOND_CHECK_DATE;
    private String SECOND_CHECK_DESC;
    private String SECOND_CHECK_USR;
    private String SPEC;					//작품크기
    private String SAVE_FLAG;
    private String IMAGE_DIR;
    private String S_USER_ID;
    private String CHANGE_YN;				//이미지 REFRESH하기 위한 값

    
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
    public String getITEM_NM() {
		return ITEM_NM;
	}
	public void setITEM_NM(String iTEM_NM) {
		ITEM_NM = iTEM_NM;
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
	public String getADDR() {
		return ADDR;
	}
	public void setADDR(String aDDR) {
		ADDR = aDDR;
	}
	public String getAPP_USER() {
		return APP_USER;
	}
	public void setAPP_USER(String aPP_USER) {
		APP_USER = aPP_USER;
	}
	public String getACQ_AMT_I() {
		return ACQ_AMT_I;
	}
	public void setACQ_AMT_I(String aCQ_AMT_I) {
		ACQ_AMT_I = aCQ_AMT_I;
	}
	public String getEXPECT_AMT_I() {
		return EXPECT_AMT_I;
	}
	public void setEXPECT_AMT_I(String eXPECT_AMT_I) {
		EXPECT_AMT_I = eXPECT_AMT_I;
	}
	public String getINSUR_YN() {
		return INSUR_YN;
	}
	public void setINSUR_YN(String iNSUR_YN) {
		INSUR_YN = iNSUR_YN;
	}
	public String getOPEN_YN() {
		return OPEN_YN;
	}
	public void setOPEN_YN(String oPEN_YN) {
		OPEN_YN = oPEN_YN;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getITEM_DESC() {
		return ITEM_DESC;
	}
	public void setITEM_DESC(String iTEM_DESC) {
		ITEM_DESC = iTEM_DESC;
	}
	public String getITEM_GBN() {
		return ITEM_GBN;
	}
	public void setITEM_GBN(String iTEM_GBN) {
		ITEM_GBN = iTEM_GBN;
	}
	public String getAUTHOR() {
		return AUTHOR;
	}
	public void setAUTHOR(String aUTHOR) {
		AUTHOR = aUTHOR;
	}
	public String getAUTHOR_HO() {
		return AUTHOR_HO;
	}
	public void setAUTHOR_HO(String aUTHOR_HO) {
		AUTHOR_HO = aUTHOR_HO;
	}
	public String getX_LENGTH() {
		return X_LENGTH;
	}
	public void setX_LENGTH(String x_LENGTH) {
		X_LENGTH = x_LENGTH;
	}
	public String getY_LENGTH() {
		return Y_LENGTH;
	}
	public void setY_LENGTH(String y_LENGTH) {
		Y_LENGTH = y_LENGTH;
	}
	public String getZ_LENGTH() {
		return Z_LENGTH;
	}
	public void setZ_LENGTH(String z_LENGTH) {
		Z_LENGTH = z_LENGTH;
	}
	public String getITEM_DIR() {
		return ITEM_DIR;
	}
	public void setITEM_DIR(String iTEM_DIR) {
		ITEM_DIR = iTEM_DIR;
	}
	public String getPURCHASE_WHY() {
		return PURCHASE_WHY;
	}
	public void setPURCHASE_WHY(String pURCHASE_WHY) {
		PURCHASE_WHY = pURCHASE_WHY;
	}
	public String getVALUE_GUBUN() {
		return VALUE_GUBUN;
	}
	public void setVALUE_GUBUN(String vALUE_GUBUN) {
		VALUE_GUBUN = vALUE_GUBUN;
	}
	public String getITEM_STATE() {
		return ITEM_STATE;
	}
	public void setITEM_STATE(String iTEM_STATE) {
		ITEM_STATE = iTEM_STATE;
	}
	public String getPURCHASE_DATE() {
		return PURCHASE_DATE;
	}
	public void setPURCHASE_DATE(String pURCHASE_DATE) {
		PURCHASE_DATE = pURCHASE_DATE;
	}
	public String getESTATE_AMT_I() {
		return ESTATE_AMT_I;
	}
	public void setESTATE_AMT_I(String eSTATE_AMT_I) {
		ESTATE_AMT_I = eSTATE_AMT_I;
	}
	public String getSALES_AMT_I() {
		return SALES_AMT_I;
	}
	public void setSALES_AMT_I(String sALES_AMT_I) {
		SALES_AMT_I = sALES_AMT_I;
	}
	public String getCLOSING_YEAR() {
		return CLOSING_YEAR;
	}
	public void setCLOSING_YEAR(String cLOSING_YEAR) {
		CLOSING_YEAR = cLOSING_YEAR;
	}
	public String getFIRST_CHECK_YN() {
		return FIRST_CHECK_YN;
	}
	public void setFIRST_CHECK_YN(String fIRST_CHECK_YN) {
		FIRST_CHECK_YN = fIRST_CHECK_YN;
	}
	public String getFIRST_CHECK_DATE() {
		return FIRST_CHECK_DATE;
	}
	public void setFIRST_CHECK_DATE(String fIRST_CHECK_DATE) {
		FIRST_CHECK_DATE = fIRST_CHECK_DATE;
	}
	public String getFIRST_CHECK_DESC() {
		return FIRST_CHECK_DESC;
	}
	public void setFIRST_CHECK_DESC(String fIRST_CHECK_DESC) {
		FIRST_CHECK_DESC = fIRST_CHECK_DESC;
	}
	public String getFIRST_CHECK_USR() {
		return FIRST_CHECK_USR;
	}
	public void setFIRST_CHECK_USR(String fIRST_CHECK_USR) {
		FIRST_CHECK_USR = fIRST_CHECK_USR;
	}
	public String getSECOND_CHECK_YN() {
		return SECOND_CHECK_YN;
	}
	public void setSECOND_CHECK_YN(String sECOND_CHECK_YN) {
		SECOND_CHECK_YN = sECOND_CHECK_YN;
	}
	public String getSECOND_CHECK_DATE() {
		return SECOND_CHECK_DATE;
	}
	public void setSECOND_CHECK_DATE(String sECOND_CHECK_DATE) {
		SECOND_CHECK_DATE = sECOND_CHECK_DATE;
	}
	public String getSECOND_CHECK_DESC() {
		return SECOND_CHECK_DESC;
	}
	public void setSECOND_CHECK_DESC(String sECOND_CHECK_DESC) {
		SECOND_CHECK_DESC = sECOND_CHECK_DESC;
	}
	public String getSECOND_CHECK_USR() {
		return SECOND_CHECK_USR;
	}
	public void setSECOND_CHECK_USR(String sECOND_CHECK_USR) {
		SECOND_CHECK_USR = sECOND_CHECK_USR;
	}
	public String getSPEC() {
		return SPEC;
	}
	public void setSPEC(String sPEC) {
		SPEC = sPEC;
	}
	public String getSAVE_FLAG() {
		return SAVE_FLAG;
	}
	public void setSAVE_FLAG(String sAVE_FLAG) {
		SAVE_FLAG = sAVE_FLAG;
	}
	public String getIMAGE_DIR() {
		return IMAGE_DIR;
	}
	public void setIMAGE_DIR(String iMAGE_DIR) {
		IMAGE_DIR = iMAGE_DIR;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getCHANGE_YN() {
		return CHANGE_YN;
	}
	public void setCHANGE_YN(String cHANGE_YN) {
		CHANGE_YN = cHANGE_YN;
	}
}
