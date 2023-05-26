package foren.unilite.modules.sales.scn;

import foren.framework.model.BaseVO;
import foren.framework.utils.ObjUtils;

public class Scn100ukrvModel extends BaseVO {
	private static final long serialVersionUID = 1L;
	
	/* Primary Key */
	private String	S_COMP_CODE;			//COMP_CODE
	private String	COMP_CODE;  
	private String	DIV_CODE;				//DIV_CODE
	private String	S_USER_ID;				//사용자 계정
	private String	CONT_NUM;				//계약번호
	private String	CUSTOM_CODE;			//거래처코드
	private String	CONT_GUBUN;				//계약구분 
	private String	CONT_DATE;				//계약일
	private String	CONT_GRADE;				//계약등급
	private double	CONT_AMT;				//계약금액
	private String	SALE_PRSN;				//영업담당
	private String	CONT_STATE;				//계약상태(1:계약, 9:종료)
	private String	CONT_FR_DATE;			//계약기간FR
	private String	CONT_TO_DATE;			//계약기간TO
	private String	CONT_MONTH;				//계약월수
	private double	MONTH_MAINT_AMT;		//월유지보수비
	private String	CHAGE_DAY;				//청구일
	private String	TAX_IN_OUT;				//세액포함여부(B030 - 1:별도, 2:포함)
	private String	REMARK;					//비고
	private String	FILE_NO;				//첨부파일 번호

//사진업로드용 변수
	private String	MANAGE_NO;
	private int		SEQ;
	private String	IMAGE_DIR;
	private String	CHANGE_YN;				//이미지 REFRESH하기 위한 값
	private String FILE_TYPE;

	public String getMANAGE_NO() {
		return MANAGE_NO;
	}
	public void setMANAGE_NO(String mANAGE_NO) {
		MANAGE_NO = mANAGE_NO;
	}
	public int getSEQ() {
		return SEQ;
	}
	public void setSEQ(int sEQ) {
		SEQ = sEQ;
	}
	public String getIMAGE_DIR() {
		return IMAGE_DIR;
	}
	public void setIMAGE_DIR(String iMAGE_DIR) {
		IMAGE_DIR = iMAGE_DIR;
	}
	public String getCHANGE_YN() {
		return CHANGE_YN;
	}
	public void setCHANGE_YN(String cHANGE_YN) {
		CHANGE_YN = cHANGE_YN;
	}
	public String getFILE_TYPE() {
		return FILE_TYPE;
	}
	public void setFILE_TYPE(String fILE_TYPE) {
		FILE_TYPE = fILE_TYPE;
	}
//여기까지

	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
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
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getCONT_NUM() {
		return CONT_NUM;
	}
	public void setCONT_NUM(String cONT_NUM) {
		CONT_NUM = cONT_NUM;
	}
	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}
	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}
	public String getCONT_GUBUN() {
		return CONT_GUBUN;
	}
	public void setCONT_GUBUN(String cONT_GUBUN) {
		CONT_GUBUN = cONT_GUBUN;
	}
	public String getCONT_DATE() {
		return CONT_DATE;
	}
	public void setCONT_DATE(String cONT_DATE) {
		CONT_DATE = cONT_DATE;
	}
	public String getCONT_GRADE() {
		return CONT_GRADE;
	}
	public void setCONT_GRADE(String cONT_GRADE) {
		CONT_GRADE = cONT_GRADE;
	}
	public double getCONT_AMT() {
		return CONT_AMT;
	}
	public void setCONT_AMT(double cONT_AMT) {
		CONT_AMT = cONT_AMT;
	}
	public String getSALE_PRSN() {
		return SALE_PRSN;
	}
	public void setSALE_PRSN(String sALE_PRSN) {
		SALE_PRSN = sALE_PRSN;
	}
	public String getCONT_STATE() {
		return CONT_STATE;
	}
	public void setCONT_STATE(String cONT_STATE) {
		CONT_STATE = cONT_STATE;
	}
	public String getCONT_FR_DATE() {
		return CONT_FR_DATE;
	}
	public void setCONT_FR_DATE(String cONT_FR_DATE) {
		CONT_FR_DATE = cONT_FR_DATE;
	}
	public String getCONT_TO_DATE() {
		return CONT_TO_DATE;
	}
	public void setCONT_TO_DATE(String cONT_TO_DATE) {
		CONT_TO_DATE = cONT_TO_DATE;
	}
	public String getCONT_MONTH() {
		return CONT_MONTH;
	}
	public void setCONT_MONTH(String cONT_MONTH) {
		CONT_MONTH = cONT_MONTH;
	}
	public double getMONTH_MAINT_AMT() {
		return MONTH_MAINT_AMT;
	}
	public void setMONTH_MAINT_AMT(double mONTH_MAINT_AMT) {
		MONTH_MAINT_AMT = mONTH_MAINT_AMT;
	}
	public String getCHAGE_DAY() {
		return CHAGE_DAY;
	}
	public void setCHAGE_DAY(String cHAGE_DAY) {
		CHAGE_DAY = cHAGE_DAY;
	}
	public String getTAX_IN_OUT() {
		return TAX_IN_OUT;
	}
	public void setTAX_IN_OUT(String tAX_IN_OUT) {
		TAX_IN_OUT = tAX_IN_OUT;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getFILE_NO() {
		return FILE_NO;
	}
	public void setFILE_NO(String fILE_NO) {
		FILE_NO = fILE_NO;
	}
}
