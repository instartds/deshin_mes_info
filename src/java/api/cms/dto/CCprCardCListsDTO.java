package api.cms.dto;

import java.util.List;

import foren.framework.utils.ObjUtils;

/**
 * 법인카드승인내역
 * @author chaeseongmin
 *
 */
public class CCprCardCListsDTO {

	
private String company_no;			//법인코드
private String cpr_card_no;			//카드번호
private String cpr_card_confm_no;	//승인번호
private String cpr_card_confm_dt;	//승인일자
private String cpr_card_confm_tm;	//승인시간
//private String cpr_card_seq;		//순번
private String cpr_card_confm_amt;	//승인금액
private String cpr_card_confm_vat;	//부가세
private String cpr_card_cancel_dt; 	//취소년월일
private String mrhst_reg_no;		//가맹점사업자번호
private String mrhst_cd;			//가맹점코드
private String mrhst_nm;			//가맹점명

private String erp_comp_code;		//erp법인코드

public String getErp_comp_code() {
	return erp_comp_code;
}
public void setErp_comp_code(String erp_comp_code) {
	this.erp_comp_code = erp_comp_code;
}
private List<CCprCardCListsDTO> data;

public String getCompany_no() {
	return company_no;
}

public void setCompany_no(String company_no) {
	this.company_no = company_no;
}

public String getCpr_card_no() {
	return cpr_card_no;
}

public void setCpr_card_no(String cpr_card_no) {
	this.cpr_card_no = cpr_card_no;
}

public String getCpr_card_confm_no() {
	return cpr_card_confm_no;
}

public void setCpr_card_confm_no(String cpr_card_confm_no) {
	this.cpr_card_confm_no = cpr_card_confm_no;
}

public String getCpr_card_confm_dt() {
	return cpr_card_confm_dt;
}

public void setCpr_card_confm_dt(String cpr_card_confm_dt) {
	this.cpr_card_confm_dt = cpr_card_confm_dt;
}

public String getCpr_card_confm_tm() {
	return cpr_card_confm_tm;
}

public void setCpr_card_confm_tm(String cpr_card_confm_tm) {
	this.cpr_card_confm_tm = cpr_card_confm_tm;
}

public String getCancel_yn() {
	String rtn = "";//승인취소 Y, N
	if(ObjUtils.isNotEmpty(cpr_card_cancel_dt)){
		rtn = "Y";
	}else{
		rtn = "N";
	}
	return rtn;
}

//public void setCpr_card_seq(String cpr_card_seq) {
//	this.cpr_card_seq = cpr_card_seq;
//}

public String getCpr_card_confm_amt() {
	return cpr_card_confm_amt;
}

public void setCpr_card_confm_amt(String cpr_card_confm_amt) {
	this.cpr_card_confm_amt = cpr_card_confm_amt;
}

public String getCpr_card_confm_vat() {
	return cpr_card_confm_vat;
}

public void setCpr_card_confm_vat(String cpr_card_confm_vat) {
	this.cpr_card_confm_vat = cpr_card_confm_vat;
}

public String getCpr_card_cancel_dt() {
	return cpr_card_cancel_dt;
}

public void setCpr_card_cancel_dt(String cpr_card_cancel_dt) {
	this.cpr_card_cancel_dt = cpr_card_cancel_dt;
}

public String getMrhst_reg_no() {
	return mrhst_reg_no;
}

public void setMrhst_reg_no(String mrhst_reg_no) {
	this.mrhst_reg_no = mrhst_reg_no;
}

public String getMrhst_cd() {
	return mrhst_cd;
}

public void setMrhst_cd(String mrhst_cd) {
	this.mrhst_cd = mrhst_cd;
}

public String getMrhst_nm() {
	return mrhst_nm;
}

public void setMrhst_nm(String mrhst_nm) {
	this.mrhst_nm = mrhst_nm;
}

public List<CCprCardCListsDTO> getData() {
	return data;
}

public void setData(List<CCprCardCListsDTO> data) {
	this.data = data;
}

	
	
}
