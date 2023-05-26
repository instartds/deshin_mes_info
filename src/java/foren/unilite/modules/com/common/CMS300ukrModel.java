package foren.unilite.modules.com.common;

import foren.framework.model.BaseVO;

/**
 * 수시거래내역조회  Model
 */
public class CMS300ukrModel extends BaseVO {

	private static final long serialVersionUID = -3776763394727633964L;

	class InputClass {
		private String 계좌번호;
		private String 조회시작일;
		private String 조회종료일;
		private String 거래검증유무;
		private String 딜레이;
		private String 페이지별건수;
		
		public String get계좌번호() {
			return 계좌번호;
		}
		public void set계좌번호(String 계좌번호) {
			this.계좌번호 = 계좌번호;
		}
		public String get조회시작일() {
			return 조회시작일;
		}
		public void set조회시작일(String 조회시작일) {
			this.조회시작일 = 조회시작일;
		}
		public String get조회종료일() {
			return 조회종료일;
		}
		public void set조회종료일(String 조회종료일) {
			this.조회종료일 = 조회종료일;
		}
		public String get거래검증유무() {
			return 거래검증유무;
		}
		public void set거래검증유무(String 거래검증유무) {
			this.거래검증유무 = 거래검증유무;
		}
		public String get딜레이() {
			return 딜레이;
		}
		public void set딜레이(String 딜레이) {
			this.딜레이 = 딜레이;
		}
		public String get페이지별건수() {
			return 페이지별건수;
		}
		public void set페이지별건수(String 페이지별건수) {
			this.페이지별건수 = 페이지별건수;
		}
	}
	
	class OutputClass {
		
		private String ErrorCode;
		private String ErrorMessage;
		private Result Result;
		
		public String getErrorCode() {
			return ErrorCode;
		}
		public void setErrorCode(String errorCode) {
			ErrorCode = errorCode;
		}
		public String getErrorMessage() {
			return ErrorMessage;
		}
		public void setErrorMessage(String errorMessage) {
			ErrorMessage = errorMessage;
		}
		public Result getResult() {
			return Result;
		}
		public void setResult(Result result) {
			Result = result;
		}
	}
	// Result
	class Result{
		private String 페이지번호;
		private String 내역정렬순서;
		private TransHistory[] 수시거래내역조회;
		
		public String get페이지번호() {
			return 페이지번호;
		}
		public void set페이지번호(String 페이지번호) {
			this.페이지번호 = 페이지번호;
		}
		public String get내역정렬순서() {
			return 내역정렬순서;
		}
		public void set내역정렬순서(String 내역정렬순서) {
			this.내역정렬순서 = 내역정렬순서;
		}
		public TransHistory[] get수시거래내역조회() {
			return 수시거래내역조회;
		}
		public void set수시거래내역조회(TransHistory[] 수시거래내역조회) {
			this.수시거래내역조회 = 수시거래내역조회;
		}
	}

	// 수시거래내역 조회
	class TransHistory{
		
		private String 거래일자;
		private String 거래시각;
		private String 통화코드;
		private String 출금액;
		private String 입금액;
		private String 거래후잔액;
		private String 기재사항1;
		private String 기재사항2;
		private String 거래수단1;
		private String 거래수단2;
		private String 거래수단3;
		private String 계좌번호;
		private String 상대계좌예금주명;
		private String 상대계좌번호;
		
		public String get거래일자() {
			return 거래일자;
		}
		public void set거래일자(String 거래일자) {
			this.거래일자 = 거래일자;
		}
		public String get거래시각() {
			return 거래시각;
		}
		public void set거래시각(String 거래시각) {
			this.거래시각 = 거래시각;
		}
		public String get통화코드() {
			return 통화코드;
		}
		public void set통화코드(String 통화코드) {
			this.통화코드 = 통화코드;
		}
		public String get출금액() {
			return 출금액;
		}
		public void set출금액(String 출금액) {
			this.출금액 = 출금액;
		}
		public String get입금액() {
			return 입금액;
		}
		public void set입금액(String 입금액) {
			this.입금액 = 입금액;
		}
		public String get거래후잔액() {
			return 거래후잔액;
		}
		public void set거래후잔액(String 거래후잔액) {
			this.거래후잔액 = 거래후잔액;
		}
		public String get기재사항1() {
			return 기재사항1;
		}
		public void set기재사항1(String 기재사항1) {
			this.기재사항1 = 기재사항1;
		}
		public String get기재사항2() {
			return 기재사항2;
		}
		public void set기재사항2(String 기재사항2) {
			this.기재사항2 = 기재사항2;
		}
		public String get거래수단1() {
			return 거래수단1;
		}
		public void set거래수단1(String 거래수단1) {
			this.거래수단1 = 거래수단1;
		}
		public String get거래수단2() {
			return 거래수단2;
		}
		public void set거래수단2(String 거래수단2) {
			this.거래수단2 = 거래수단2;
		}
		public String get거래수단3() {
			return 거래수단3;
		}
		public void set거래수단3(String 거래수단3) {
			this.거래수단3 = 거래수단3;
		}
		public String get계좌번호() {
			return 계좌번호;
		}
		public void set계좌번호(String 계좌번호) {
			this.계좌번호 = 계좌번호;
		}
		public String get상대계좌예금주명() {
			return 상대계좌예금주명;
		}
		public void set상대계좌예금주명(String 상대계좌예금주명) {
			this.상대계좌예금주명 = 상대계좌예금주명;
		}
		public String get상대계좌번호() {
			return 상대계좌번호;
		}
		public void set상대계좌번호(String 상대계좌번호) {
			this.상대계좌번호 = 상대계좌번호;
		}
	}
}
