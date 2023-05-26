package api.cms.dto;

import java.util.List;

/**
 * 법인카드청구내역
 * @author chaeseongmin
 *
 */
public class CCprCardRListsDTO {

private String company_no;			//	법인코드
private String cpr_card_no;			//	카드번호
//	substring(cpr_card_pre_dt,1,6)	출금예정월
//private String cpr_card_seq;		//	순번
private String cpr_card_sett_dt;		//  결제일
private String cpr_card_use_dt;		//	이용일자
private String mrhst_nm;			//	가맹점명
private String mrhst_reg_no;		//	가맹점사업자번호
//private String 	가맹점번호
private String cpr_card_use_amt;	//	이용금액
private String cpr_card_req_amt;	//	청구금액
private String cpr_card_use_fee;	//	수수료
private String cpr_card_blce_amt;	//	결제후잔액
private String cpr_card_instlmt_pd;	//	할부개월
private String input_seq;			//	입금회차	

private String erp_comp_code;		//erp법인코드

public String getErp_comp_code() {
	return erp_comp_code;
}
public void setErp_comp_code(String erp_comp_code) {
	this.erp_comp_code = erp_comp_code;
}
	
private List<CCprCardRListsDTO> data;


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


//public String getCpr_card_seq() {
//	return cpr_card_seq;
//}
//
//
//public void setCpr_card_seq(String cpr_card_seq) {
//	this.cpr_card_seq = cpr_card_seq;
//}


public String getCpr_card_sett_dt() {
	return cpr_card_sett_dt;
}


public void setCpr_card_sett_dt(String cpr_card_sett_dt) {
	this.cpr_card_sett_dt = cpr_card_sett_dt;
}


public String getCpr_card_use_dt() {
	return cpr_card_use_dt;
}


public void setCpr_card_use_dt(String cpr_card_use_dt) {
	this.cpr_card_use_dt = cpr_card_use_dt;
}


public String getMrhst_nm() {
	return mrhst_nm;
}


public void setMrhst_nm(String mrhst_nm) {
	this.mrhst_nm = mrhst_nm;
}


public String getMrhst_reg_no() {
	return mrhst_reg_no;
}


public void setMrhst_reg_no(String mrhst_reg_no) {
	this.mrhst_reg_no = mrhst_reg_no;
}


public String getCpr_card_use_amt() {
	return cpr_card_use_amt;
}


public void setCpr_card_use_amt(String cpr_card_use_amt) {
	this.cpr_card_use_amt = cpr_card_use_amt;
}


public String getCpr_card_req_amt() {
	return cpr_card_req_amt;
}


public void setCpr_card_req_amt(String cpr_card_req_amt) {
	this.cpr_card_req_amt = cpr_card_req_amt;
}


public String getCpr_card_use_fee() {
	return cpr_card_use_fee;
}


public void setCpr_card_use_fee(String cpr_card_use_fee) {
	this.cpr_card_use_fee = cpr_card_use_fee;
}


public String getCpr_card_blce_amt() {
	return cpr_card_blce_amt;
}


public void setCpr_card_blce_amt(String cpr_card_blce_amt) {
	this.cpr_card_blce_amt = cpr_card_blce_amt;
}


public String getCpr_card_instlmt_pd() {
	return cpr_card_instlmt_pd;
}


public void setCpr_card_instlmt_pd(String cpr_card_instlmt_pd) {
	this.cpr_card_instlmt_pd = cpr_card_instlmt_pd;
}


public String getInput_seq() {
	return input_seq;
}


public void setInput_seq(String input_seq) {
	this.input_seq = input_seq;
}


public List<CCprCardRListsDTO> getData() {
	return data;
}


public void setData(List<CCprCardRListsDTO> data) {
	this.data = data;
}

	
}
