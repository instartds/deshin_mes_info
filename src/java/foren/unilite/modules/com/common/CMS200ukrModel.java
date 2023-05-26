package foren.unilite.modules.com.common;

import foren.framework.model.BaseVO;

/**
 * 수시전계좌조회  Model
 */
public class CMS200ukrModel extends BaseVO {

	private static final long serialVersionUID = 2353473409433843888L;

	class InputClass {
		
		private String 계좌번호;

		public String get계좌번호() {
			return 계좌번호;
		}
		public void set계좌번호(String 계좌번호) {
			this.계좌번호 = 계좌번호;
		}
	}
	
	class OutputClass{
		
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
		private Account[] 수시전계좌조회;

		public Account[] get수시전계좌조회() {
			return 수시전계좌조회;
		}
		public void set수시전계좌조회(Account[] 수시전계좌조회) {
			this.수시전계좌조회 = 수시전계좌조회;
		}
	}
	// 수시전계좌조회
	class Account{
		private String 예금명="";
		private String 계좌번호="";
		private String 통화코드="";
		private String 잔액="";
		private String 신규일자="";
		
		public String get예금명() {
			return 예금명;
		}
		public void set예금명(String 예금명) {
			this.예금명 = 예금명;
		}
		public String get계좌번호() {
			return 계좌번호;
		}
		public void set계좌번호(String 계좌번호) {
			this.계좌번호 = 계좌번호;
		}
		public String get통화코드() {
			return 통화코드;
		}
		public void set통화코드(String 통화코드) {
			this.통화코드 = 통화코드;
		}
		public String get잔액() {
			return 잔액;
		}
		public void set잔액(String 잔액) {
			this.잔액 = 잔액;
		}
		public String get신규일자() {
			return 신규일자;
		}
		public void set신규일자(String 신규일자) {
			this.신규일자 = 신규일자;
		}
	}
}
