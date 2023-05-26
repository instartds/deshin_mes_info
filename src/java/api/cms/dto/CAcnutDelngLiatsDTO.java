package api.cms.dto;

import java.util.List;

/**
 * 계좌거래내역
 * @author chaeseongmin
 *
 */
public class CAcnutDelngLiatsDTO {
	private String company_no;		//법인코드
	private String dealing_dt;		//거래일자
	private String dealing_tm;		//거래시간
	//private	String dealing_seq;		//데이터 순번
	private String acnut_no;		//계좌번호
	private String crncy_cd;		//화폐
	private String defray_amt;		//출금액
	private String rcpmny_amt;		//입금액
	private String blce_amt;		//잔액
	private String state_matter_1;	//비고

	private String erp_comp_code;		//erp법인코드

	public String getErp_comp_code() {
		return erp_comp_code;
	}
	public void setErp_comp_code(String erp_comp_code) {
		this.erp_comp_code = erp_comp_code;
	}
	
	private List<CAcnutDelngLiatsDTO> data;
	
	public String getCompany_no() {
		return company_no;
	}
	public void setCompany_no(String company_no) {
		this.company_no = company_no;
	}
	public String getDealing_dt() {
		return dealing_dt;
	}
	public void setDealing_dt(String dealing_dt) {
		this.dealing_dt = dealing_dt;
	}
	public String getDealing_tm() {
		return dealing_tm;
	}
	public void setDealing_tm(String dealing_tm) {
		this.dealing_tm = dealing_tm;
	}

//	public String getDealing_seq() {
//		return dealing_seq;
//	}
//	public void setDealing_seq(String dealing_seq) {
//		this.dealing_seq = dealing_seq;
//	}
	
	public String getAcnut_no() {
		return acnut_no;
	}
	public void setAcnut_no(String acnut_no) {
		this.acnut_no = acnut_no;
	}
	public String getCrncy_cd() {
		return crncy_cd;
	}
	public void setCrncy_cd(String crncy_cd) {
		this.crncy_cd = crncy_cd;
	}
	public String getDefray_amt() {
		return defray_amt;
	}
	public void setDefray_amt(String defray_amt) {
		this.defray_amt = defray_amt;
	}
	public String getRcpmny_amt() {
		return rcpmny_amt;
	}
	public void setRcpmny_amt(String rcpmny_amt) {
		this.rcpmny_amt = rcpmny_amt;
	}
	public String getBlce_amt() {
		return blce_amt;
	}
	public void setBlce_amt(String blce_amt) {
		this.blce_amt = blce_amt;
	}
	public String getState_matter_1() {
		return state_matter_1;
	}
	public void setState_matter_1(String state_matter_1) {
		this.state_matter_1 = state_matter_1;
	}
	
	
	public List<CAcnutDelngLiatsDTO> getData() {
		return data;
	}
	public void setData(List<CAcnutDelngLiatsDTO> data) {
		this.data = data;
	}

}
