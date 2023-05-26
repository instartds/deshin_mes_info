package foren.unilite.modules.com.ext;

import foren.framework.model.BaseVO;

public class ExtJsStateProviderModel extends BaseVO{

	private static final long serialVersionUID = 1L;
	
	/* Primary Key */
    private String  COMP_CODE;
    private String  USER_ID;
    private String  PGM_ID;
    private String  SHT_ID;
    private int  	SHT_SEQ;
    
	private String  SHT_NAME;
    private String  SHT_DESC;
    private String  SHT_TYPE;
    private String  SHT_INFO;    
    private String  DEFAULT_YN;
    private String  QLIST_YN;
    private String  COLUMN_INFO;
    private String  BASE_SHT_INFO;
    
    private String  TEMPC_01;
    private String  TEMPC_02;
    private String  TEMPC_03;
    
    private double  TEMPN_01;
    private double  TEMPN_02;
    private double  TEMPN_03;    
    
    /* Session Variables */
    private String  S_COMP_CODE;
    private String  S_AUTHORITY_LEVEL;
    private String  S_USER_ID;
    
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
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
	public String getSHT_ID() {
		return SHT_ID;
	}
	public void setSHT_ID(String sHT_ID) {
		SHT_ID = sHT_ID;
	}
    public int getSHT_SEQ() {
		return SHT_SEQ;
	}
	public void setSHT_SEQ(int sHT_SEQ) {
		SHT_SEQ = sHT_SEQ;
	}
	public String getSHT_NAME() {
		return SHT_NAME;
	}
	public void setSHT_NAME(String sHT_NAME) {
		SHT_NAME = sHT_NAME;
	}
	public String getSHT_DESC() {
		return SHT_DESC;
	}
	public void setSHT_DESC(String sHT_DESC) {
		SHT_DESC = sHT_DESC;
	}
	public String getSHT_TYPE() {
		return SHT_TYPE;
	}
	public void setSHT_TYPE(String sHT_TYPE) {
		SHT_TYPE = sHT_TYPE;
	}
	public String getSHT_INFO() {
		return SHT_INFO;
	}
	public void setSHT_INFO(String sHT_INFO) {
		SHT_INFO = sHT_INFO;
	}
	public String getDEFAULT_YN() {
		return DEFAULT_YN;
	}
	public void setDEFAULT_YN(String dEFAULT_YN) {
		DEFAULT_YN = dEFAULT_YN;
	}	
	public String getQLIST_YN() {
		return QLIST_YN;
	}
	public void setQLIST_YN(String qLIST_YN) {
		QLIST_YN = qLIST_YN;
	}
	
	public String getCOLUMN_INFO() {
		return COLUMN_INFO;
	}
	public void setCOLUMN_INFO(String cOLUMN_INFO) {
		COLUMN_INFO = cOLUMN_INFO;
	}
	public String getBASE_SHT_INFO() {
		return BASE_SHT_INFO;
	}
	public void setBASE_SHT_INFO(String bASE_SHT_INFO) {
		BASE_SHT_INFO = bASE_SHT_INFO;
	}
	public String getTEMPC_01() {
		return TEMPC_01;
	}
	public void setTEMPC_01(String tEMPC_01) {
		TEMPC_01 = tEMPC_01;
	}
	public String getTEMPC_02() {
		return TEMPC_02;
	}
	public void setTEMPC_02(String tEMPC_02) {
		TEMPC_02 = tEMPC_02;
	}
	public String getTEMPC_03() {
		return TEMPC_03;
	}
	public void setTEMPC_03(String tEMPC_03) {
		TEMPC_03 = tEMPC_03;
	}
	public double getTEMPN_01() {
		return TEMPN_01;
	}
	public void setTEMPN_01(double tEMPN_01) {
		TEMPN_01 = tEMPN_01;
	}
	public double getTEMPN_02() {
		return TEMPN_02;
	}
	public void setTEMPN_02(double tEMPN_02) {
		TEMPN_02 = tEMPN_02;
	}
	public double getTEMPN_03() {
		return TEMPN_03;
	}
	public void setTEMPN_03(double tEMPN_03) {
		TEMPN_03 = tEMPN_03;
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
        
}
