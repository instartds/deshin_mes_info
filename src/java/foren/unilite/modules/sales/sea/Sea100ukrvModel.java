package foren.unilite.modules.sales.sea;

import foren.framework.model.BaseVO;

public class Sea100ukrvModel extends BaseVO {
	private static final long serialVersionUID = 1L;

	private String S_COMP_CODE;			//COMP_CODE
	private String COMP_CODE;
	private String S_USER_ID;			//사용자 계정
	private String DIV_CODE;			//DIV_CODE
	private String CUSTOM_CODE;			//거래처코드
	private String CUSTOM_NAME;			//거래처명
	private String ESTI_REQ_DATE;		//견적의뢰일
	private String SALE_PRSN;			//영업담당
	private String ESTI_NUM;			//견적의뢰번호
	private String ESTI_ITEM_CODE;		//픔목코드
	private String ESTI_ITEM_NAME;		//품목명
	private String ESTI_QTY;			//견적수량
	private String FILL_UNIT;			//충전단위
	private String PROD_PART;			//생산파트
	private String RES_PART;			//연구파트
	private String ESTI_TYPE;			//견적기준
	private String AGREE_PRSN;			//승인자
	private String BOM_SPEC;			//BOM 포장사양
	private String REMARK;				//특이사항
	private String CASE_SM_REMARK;
	private String AGREE_YN;
	private String USER_ID;				//승인자id(팝업용)
	private String USER_NAME;			//승인자명(팝업용)
	private String ITEM_CODE;			//보여주기용 팝업 데이터
	private String ITEM_NAME;			//보여주기용 팝업 데이터
	private String MAT_TYPE;			//20210907 추가: 자재구분


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
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}
	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}
	public String getCUSTOM_NAME() {
		return CUSTOM_NAME;
	}
	public void setCUSTOM_NAME(String cUSTOM_NAME) {
		CUSTOM_NAME = cUSTOM_NAME;
	}
	public String getESTI_REQ_DATE() {
		return ESTI_REQ_DATE;
	}
	public void setESTI_REQ_DATE(String eSTI_REQ_DATE) {
		ESTI_REQ_DATE = eSTI_REQ_DATE;
	}
	public String getSALE_PRSN() {
		return SALE_PRSN;
	}
	public void setSALE_PRSN(String sALE_PRSN) {
		SALE_PRSN = sALE_PRSN;
	}
	public String getESTI_NUM() {
		return ESTI_NUM;
	}
	public void setESTI_NUM(String eSTI_NUM) {
		ESTI_NUM = eSTI_NUM;
	}
	public String getESTI_ITEM_CODE() {
		return ESTI_ITEM_CODE;
	}
	public void setESTI_ITEM_CODE(String eSTI_ITEM_CODE) {
		ESTI_ITEM_CODE = eSTI_ITEM_CODE;
	}
	public String getESTI_ITEM_NAME() {
		return ESTI_ITEM_NAME;
	}
	public void setESTI_ITEM_NAME(String eSTI_ITEM_NAME) {
		ESTI_ITEM_NAME = eSTI_ITEM_NAME;
	}
	public String getESTI_QTY() {
		return ESTI_QTY;
	}
	public void setESTI_QTY(String eSTI_QTY) {
		ESTI_QTY = eSTI_QTY;
	}
	public String getFILL_UNIT() {
		return FILL_UNIT;
	}
	public void setFILL_UNIT(String fILL_UNIT) {
		FILL_UNIT = fILL_UNIT;
	}
	public String getPROD_PART() {
		return PROD_PART;
	}
	public void setPROD_PART(String pROD_PART) {
		PROD_PART = pROD_PART;
	}
	public String getRES_PART() {
		return RES_PART;
	}
	public void setRES_PART(String rES_PART) {
		RES_PART = rES_PART;
	}
	public String getESTI_TYPE() {
		return ESTI_TYPE;
	}
	public void setESTI_TYPE(String eSTI_TYPE) {
		ESTI_TYPE = eSTI_TYPE;
	}
	public String getAGREE_PRSN() {
		return AGREE_PRSN;
	}
	public void setAGREE_PRSN(String aGREE_PRSN) {
		AGREE_PRSN = aGREE_PRSN;
	}
	public String getBOM_SPEC() {
		return BOM_SPEC;
	}
	public void setBOM_SPEC(String bOM_SPEC) {
		BOM_SPEC = bOM_SPEC;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getCASE_SM_REMARK() {
		return CASE_SM_REMARK;
	}
	public void setCASE_SM_REMARK(String cASE_SM_REMARK) {
		CASE_SM_REMARK = cASE_SM_REMARK;
	}
	public String getAGREE_YN() {
		return AGREE_YN;
	}
	public void setAGREE_YN(String aGREE_YN) {
		AGREE_YN = aGREE_YN;
	}
	public String getUSER_ID() {
		return USER_ID;
	}
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	public String getUSER_NAME() {
		return USER_NAME;
	}
	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}
	public String getITEM_CODE() {
		return ITEM_CODE;
	}
	public void setITEM_CODE(String iTEM_CODE) {
		ITEM_CODE = iTEM_CODE;
	}
	public String getITEM_NAME() {
		return ITEM_NAME;
	}
	public void setITEM_NAME(String iTEM_NAME) {
		ITEM_NAME = iTEM_NAME;
	}
	//20210907 추가: 자재구분
	public String getMAT_TYPE() {
		return MAT_TYPE;
	}
	public void setMAT_TYPE(String mAT_TYPE) {
		MAT_TYPE = mAT_TYPE;
	}
}