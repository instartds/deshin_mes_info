package foren.unilite.modules.z_wm;

import foren.framework.model.BaseVO;

public class S_Mpo015ukrv_wmModel extends BaseVO {
	private static final long serialVersionUID = 1L;

	/* Primary Key */
	private String S_COMP_CODE;			//COMP_CODE
	private String COMP_CODE;
	private String DIV_CODE;			//DIV_CODE
	private String S_USER_ID;			//사용자 계정
	private String CUSTOM_CODE;			//거래처코드
	private String ORDER_PRSN;			//영업담당 
	private String RECEIPT_NUM;			//접수번호
	private String CUSTOM_PRSN;			//고객명
	private String RECEIPT_PRSN;		//접수담당
	private String RECEIPT_DATE;		//접수일
	private String PHONE_NUM;			//연락처
	private String RECEIPT_TYPE;		//접수구분
	private String WH_CODE;				//입고처
	private String REPRE_NUM;			//주민등록번호
	private String E_MAIL;				//이메일
	private String BANK_NAME;			//은행명
	private String BANK_ACCOUNT;		//계좌번호
	private String PRICE_TYPE;			//단가구분
	private String ADDR;				//주소
	private String HOME_TITLE;			//제목(홈페이지 제목)
	private String HOME_REMARK;			//내용(홈페이지 입력내용)
	private String REMARK;				//비고
	private String REPRE_NUM_EXPOS;		//주민등록번호(암호화)
	private String BANK_ACCOUNT_EXPOS;	//계좌번호(암호화)
	private String HOME_PURCHAS_NO;		//홈페이지 접수번호
	private String AGREE_STATUS;		//승인여부
	private String TAX_INOUT;			//세액포함여부 - 20210526 추가
	private String AUTOIN_YN;			//자동입고여부 - 20210603 추가

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
	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}
	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}
	public String getORDER_PRSN() {
		return ORDER_PRSN;
	}
	public void setORDER_PRSN(String oRDER_PRSN) {
		ORDER_PRSN = oRDER_PRSN;
	}
	public String getRECEIPT_NUM() {
		return RECEIPT_NUM;
	}
	public void setRECEIPT_NUM(String rECEIPT_NUM) {
		RECEIPT_NUM = rECEIPT_NUM;
	}
	public String getCUSTOM_PRSN() {
		return CUSTOM_PRSN;
	}
	public void setCUSTOM_PRSN(String cUSTOM_PRSN) {
		CUSTOM_PRSN = cUSTOM_PRSN;
	}
	public String getRECEIPT_PRSN() {
		return RECEIPT_PRSN;
	}
	public void setRECEIPT_PRSN(String rECEIPT_PRSN) {
		RECEIPT_PRSN = rECEIPT_PRSN;
	}
	public String getRECEIPT_DATE() {
		return RECEIPT_DATE;
	}
	public void setRECEIPT_DATE(String rECEIPT_DATE) {
		RECEIPT_DATE = rECEIPT_DATE;
	}
	public String getPHONE_NUM() {
		return PHONE_NUM;
	}
	public void setPHONE_NUM(String pHONE_NUM) {
		PHONE_NUM = pHONE_NUM;
	}
	public String getRECEIPT_TYPE() {
		return RECEIPT_TYPE;
	}
	public void setRECEIPT_TYPE(String rECEIPT_TYPE) {
		RECEIPT_TYPE = rECEIPT_TYPE;
	}
	public String getWH_CODE() {
		return WH_CODE;
	}
	public void setWH_CODE(String wH_CODE) {
		WH_CODE = wH_CODE;
	}
	public String getREPRE_NUM() {
		return REPRE_NUM;
	}
	public void setREPRE_NUM(String rEPRE_NUM) {
		REPRE_NUM = rEPRE_NUM;
	}
	public String getE_MAIL() {
		return E_MAIL;
	}
	public void setE_MAIL(String e_MAIL) {
		E_MAIL = e_MAIL;
	}
	public String getBANK_NAME() {
		return BANK_NAME;
	}
	public void setBANK_NAME(String bANK_NAME) {
		BANK_NAME = bANK_NAME;
	}
	public String getBANK_ACCOUNT() {
		return BANK_ACCOUNT;
	}
	public void setBANK_ACCOUNT(String bANK_ACCOUNT) {
		BANK_ACCOUNT = bANK_ACCOUNT;
	}
	public String getPRICE_TYPE() {
		return PRICE_TYPE;
	}
	public void setPRICE_TYPE(String pRICE_TYPE) {
		PRICE_TYPE = pRICE_TYPE;
	}
	public String getADDR() {
		return ADDR;
	}
	public void setADDR(String aDDR) {
		ADDR = aDDR;
	}
	public String getHOME_TITLE() {
		return HOME_TITLE;
	}
	public void setHOME_TITLE(String hOME_TITLE) {
		HOME_TITLE = hOME_TITLE;
	}
	public String getHOME_REMARK() {
		return HOME_REMARK;
	}
	public void setHOME_REMARK(String hOME_REMARK) {
		HOME_REMARK = hOME_REMARK;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getREPRE_NUM_EXPOS() {
		return REPRE_NUM_EXPOS;
	}
	public void setREPRE_NUM_EXPOS(String rEPRE_NUM_EXPOS) {
		REPRE_NUM_EXPOS = rEPRE_NUM_EXPOS;
	}
	public String getBANK_ACCOUNT_EXPOS() {
		return BANK_ACCOUNT_EXPOS;
	}
	public void setBANK_ACCOUNT_EXPOS(String bANK_ACCOUNT_EXPOS) {
		BANK_ACCOUNT_EXPOS = bANK_ACCOUNT_EXPOS;
	}
	public String getHOME_PURCHAS_NO() {
		return HOME_PURCHAS_NO;
	}
	public void setHOME_PURCHAS_NO(String hOME_PURCHAS_NO) {
		HOME_PURCHAS_NO = hOME_PURCHAS_NO;
	}
	public String getAGREE_STATUS() {
		return AGREE_STATUS;
	}
	public void setAGREE_STATUS(String aGREE_STATUS) {
		AGREE_STATUS = aGREE_STATUS;
	}
	public String getTAX_INOUT() {									//세액포함여부 - 20210526 추가
		return TAX_INOUT;
	}
	public void setTAX_INOUT(String tAX_INOUT) {
		TAX_INOUT = tAX_INOUT;
	}
	public String getAUTOIN_YN() {									//자동입고여부 - 20210603 추가
		return AUTOIN_YN;
	}
	public void setAUTOIN_YN(String aUTOIN_YN) {
		AUTOIN_YN = aUTOIN_YN;
	}
}