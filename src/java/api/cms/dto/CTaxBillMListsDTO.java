package api.cms.dto;

import java.util.List;

/**
 * 전자세금계산서정보
 * @author chaeseongmin
 *
 */
public class CTaxBillMListsDTO {
	private String company_no;			//법인코드
	private String confirm_no;			//승인번호
	private String tax_kind;			//매입매출구분
	private String bill_kind;			//분류
	private String writing_dt;			//작성일자
	private String issue_dt;			//발급일자
	private String trnsmis_dt;			//전송일자
	private String supler_reg_no;		//공급자사업자등록번호
	private String supler_site_no;		//공급자종사업장번호
	private String supler_company_nm;	//공급자상호
	private String supler_ceo_nm;		//공급자대표자명
	private String recipter_reg_no;		//공급받는자등록번호
	private String recipter_site_no;	//공급받는자종사업장번호
	private String recipter_company_nm;	//공급받는자상호
	private String recipter_ceo_nm;		//공급받는자대표자명
	private String tot_amt;				//합계금액
	private String supply_amt;			//공급가액
	private String tax_amt;				//세액

	private String e_bill_no;		//전자계산서종류			스마트파인더cms 에서 BILL_KIND = '전자세금계산서' OR '전자계산서'  1전자세금계산서, 2전자계산서		 BILL_KIND = '전자계산서' 일때 데이터 들어오는 컬럼
	private String e_tax_bill_kind;		//전자세금계산서종류		스마트파인더cms 에서 BILL_KIND = '전자세금계산서' OR '전자계산서'  1전자세금계산서, 2전자계산서		 BILL_KIND = '전자세금계산서' 일때 데이터 들어오는 컬럼
	private String issue_tp;			//발급유형

	private String erp_comp_code;		//erp법인코드

	public String getErp_comp_code() {
		return erp_comp_code;
	}
	public void setErp_comp_code(String erp_comp_code) {
		this.erp_comp_code = erp_comp_code;
	}
	private List<CTaxBillMListsDTO> data;

	public String getCompany_no() {
		return company_no;
	}
	
	public void setCompany_no(String company_no) {
		this.company_no = company_no;
	}

	public String getConfirm_no() {
		return confirm_no;
	}

	public void setConfirm_no(String confirm_no) {
		this.confirm_no = confirm_no;
	}

	public String getTax_kind() {
		return tax_kind;
	}

	public void setTax_kind(String tax_kind) {
		this.tax_kind = tax_kind;
	}

	public String getBill_kind() {
		return bill_kind;
	}

	public void setBill_kind(String bill_kind) {
		this.bill_kind = bill_kind;
	}

	public String getWriting_dt() {
		return writing_dt;
	}

	public void setWriting_dt(String writing_dt) {
		this.writing_dt = writing_dt;
	}

	public String getIssue_dt() {
		return issue_dt;
	}

	public void setIssue_dt(String issue_dt) {
		this.issue_dt = issue_dt;
	}

	public String getTrnsmis_dt() {
		return trnsmis_dt;
	}

	public void setTrnsmis_dt(String trnsmis_dt) {
		this.trnsmis_dt = trnsmis_dt;
	}

	public String getSupler_reg_no() {
		return supler_reg_no;
	}

	public void setSupler_reg_no(String supler_reg_no) {
		this.supler_reg_no = supler_reg_no;
	}

	public String getSupler_site_no() {
		return supler_site_no;
	}

	public void setSupler_site_no(String supler_site_no) {
		this.supler_site_no = supler_site_no;
	}

	public String getSupler_company_nm() {
		return supler_company_nm;
	}

	public void setSupler_company_nm(String supler_company_nm) {
		this.supler_company_nm = supler_company_nm;
	}

	public String getSupler_ceo_nm() {
		return supler_ceo_nm;
	}

	public void setSupler_ceo_nm(String supler_ceo_nm) {
		this.supler_ceo_nm = supler_ceo_nm;
	}

	public String getRecipter_reg_no() {
		return recipter_reg_no;
	}

	public void setRecipter_reg_no(String recipter_reg_no) {
		this.recipter_reg_no = recipter_reg_no;
	}

	public String getRecipter_site_no() {
		return recipter_site_no;
	}

	public void setRecipter_site_no(String recipter_site_no) {
		this.recipter_site_no = recipter_site_no;
	}

	public String getRecipter_company_nm() {
		return recipter_company_nm;
	}

	public void setRecipter_company_nm(String recipter_company_nm) {
		this.recipter_company_nm = recipter_company_nm;
	}

	public String getRecipter_ceo_nm() {
		return recipter_ceo_nm;
	}

	public void setRecipter_ceo_nm(String recipter_ceo_nm) {
		this.recipter_ceo_nm = recipter_ceo_nm;
	}

	public String getTot_amt() {
		return tot_amt;
	}

	public void setTot_amt(String tot_amt) {
		this.tot_amt = tot_amt;
	}

	public String getSupply_amt() {
		return supply_amt;
	}

	public void setSupply_amt(String supply_amt) {
		this.supply_amt = supply_amt;
	}

	public String getTax_amt() {
		return tax_amt;
	}

	public void setTax_amt(String tax_amt) {
		this.tax_amt = tax_amt;
	}

	public String getE_bill_no() {
		return e_bill_no;
	}

	public void setE_bill_no(String e_bill_no) {
		this.e_bill_no = e_bill_no;
	}
	public String getE_tax_bill_kind() {
		return e_tax_bill_kind;
	}

	public void setE_tax_bill_kind(String e_tax_bill_kind) {
		this.e_tax_bill_kind = e_tax_bill_kind;
	}

	public String getIssue_tp() {
		return issue_tp;
	}

	public void setIssue_tp(String issue_tp) {
		this.issue_tp = issue_tp;
	}

	public List<CTaxBillMListsDTO> getData() {
		return data;
	}

	public void setData(List<CTaxBillMListsDTO> data) {
		this.data = data;
	}
	


	
}
