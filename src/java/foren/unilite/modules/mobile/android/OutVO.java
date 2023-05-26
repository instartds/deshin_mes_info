package foren.unilite.modules.mobile.android;

import java.util.List;

public class OutVO {

	private String OutSpNo;
	private String Barcode;
	private String OutWh;
	private String OutCla;
	private String OutClaNm;
	private String OutWhNm;
	private String OutDt;
	private String OutCustNm;
	private String OrdNo;
	private String OutReqNo;
	private String DealReportNo;
	private String OutCustCd;
	private String VATTypeCd;
	private String PaymCondCd;
	private String ClaCd;
	private double TotOutGAmt;


	private List<OutdetailVO> Outdetail;
	private List<OutSetVO> OutSet;


	// Must have no-argument constructor
	public OutVO() {

	}


	public String getOutSpNo() {
		return OutSpNo;
	}


	public void setOutSpNo(String outSpNo) {
		OutSpNo = outSpNo;
	}


	public String getBarcode() {
		return Barcode;
	}


	public void setBarcode(String barcode) {
		Barcode = barcode;
	}


	public String getOutWh() {
		return OutWh;
	}


	public void setOutWh(String outWh) {
		OutWh = outWh;
	}


	public String getOutCla() {
		return OutCla;
	}


	public void setOutCla(String outCla) {
		OutCla = outCla;
	}


	public String getOutClaNm() {
		return OutClaNm;
	}


	public void setOutClaNm(String outClaNm) {
		OutClaNm = outClaNm;
	}


	public String getOutWhNm() {
		return OutWhNm;
	}


	public void setOutWhNm(String outWhNm) {
		OutWhNm = outWhNm;
	}


	public String getOutDt() {
		return OutDt;
	}


	public void setOutDt(String outDt) {
		OutDt = outDt;
	}


	public String getOutCustNm() {
		return OutCustNm;
	}


	public void setOutCustNm(String outCustNm) {
		OutCustNm = outCustNm;
	}


	public String getOrdNo() {
		return OrdNo;
	}


	public void setOrdNo(String ordNo) {
		OrdNo = ordNo;
	}


	public String getOutReqNo() {
		return OutReqNo;
	}


	public void setOutReqNo(String outReqNo) {
		OutReqNo = outReqNo;
	}


	public String getDealReportNo() {
		return DealReportNo;
	}


	public void setDealReportNo(String dealReportNo) {
		DealReportNo = dealReportNo;
	}


	public String getOutCustCd() {
		return OutCustCd;
	}


	public void setOutCustCd(String outCustCd) {
		OutCustCd = outCustCd;
	}


	public String getVATTypeCd() {
		return VATTypeCd;
	}


	public void setVATTypeCd(String vATTypeCd) {
		VATTypeCd = vATTypeCd;
	}


	public String getPaymCondCd() {
		return PaymCondCd;
	}


	public void setPaymCondCd(String paymCondCd) {
		PaymCondCd = paymCondCd;
	}


	public String getClaCd() {
		return ClaCd;
	}


	public void setClaCd(String claCd) {
		ClaCd = claCd;
	}



	public double getTotOutGAmt() {
		return TotOutGAmt;
	}


	public void setTotOutGAmt(double totOutGAmt) {
		TotOutGAmt = totOutGAmt;
	}


	public List<OutdetailVO> getOutdetail() {
		return Outdetail;
	}


	public void setOutdetail(List<OutdetailVO> outdetail) {
		Outdetail = outdetail;
	}


	public List<OutSetVO> getOutSet() {
		return OutSet;
	}


	public void setOutSet(List<OutSetVO> outSet) {
		OutSet = outSet;
	}




}