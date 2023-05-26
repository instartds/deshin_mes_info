package foren.unilite.modules.com.common;

import foren.framework.model.BaseVO;

/**
 * 보유카드조회  Model
 */
public class CMS400ukrModel extends BaseVO {

	private static final long serialVersionUID = -5554319291222919339L;
	
	class InputClass {
		private String 조회구분;
		private Certification 인증서;
		
		public String get조회구분() {
			return 조회구분;
		}
		public void set조회구분(String 조회구분) {
			this.조회구분 = 조회구분;
		}
		public Certification get인증서() {
			return 인증서;
		}
		public void set인증서(Certification 인증서) {
			this.인증서 = 인증서;
		}
	}
	
	class Certification {
		private String 이름;
		private String 만료일자;
		private String 비밀번호;
		public String get이름() {
			return 이름;
		}
		public void set이름(String 이름) {
			this.이름 = 이름;
		}
		public String get만료일자() {
			return 만료일자;
		}
		public void set만료일자(String 만료일자) {
			this.만료일자 = 만료일자;
		}
		public String get비밀번호() {
			return 비밀번호;
		}
		public void set비밀번호(String 비밀번호) {
			this.비밀번호 = 비밀번호;
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
	class Result {
		private String 계정권한;
		private CardHistory[] 보유카드조회;
		
		public String get계정권한() {
			return 계정권한;
		}
		public void set계정권한(String 계정권한) {
			this.계정권한 = 계정권한;
		}
		public CardHistory[] get보유카드조회() {
			return 보유카드조회;
		}
		public void set보유카드조회(CardHistory[] 보유카드조회) {
			this.보유카드조회 = 보유카드조회;
		}
	}
	// 보유카드조회
	class CardHistory {
		private String 카드명;
		private String 회원사;
		private String 카드번호;
		private String 결제일;
		private String 당월결제액;
		private String 카드번호형식;
		private String 사업장번호;
		private String 사업장명;
		private String 사업장구분;
		private String 부서코드;
		
		public String get카드명() {
			return 카드명;
		}
		public void set카드명(String 카드명) {
			this.카드명 = 카드명;
		}
		public String get회원사() {
			return 회원사;
		}
		public void set회원사(String 회원사) {
			this.회원사 = 회원사;
		}
		public String get카드번호() {
			return 카드번호;
		}
		public void set카드번호(String 카드번호) {
			this.카드번호 = 카드번호;
		}
		public String get결제일() {
			return 결제일;
		}
		public void set결제일(String 결제일) {
			this.결제일 = 결제일;
		}
		public String get당월결제액() {
			return 당월결제액;
		}
		public void set당월결제액(String 당월결제액) {
			this.당월결제액 = 당월결제액;
		}
		public String get카드번호형식() {
			return 카드번호형식;
		}
		public void set카드번호형식(String 카드번호형식) {
			this.카드번호형식 = 카드번호형식;
		}
		public String get사업장번호() {
			return 사업장번호;
		}
		public void set사업장번호(String 사업장번호) {
			this.사업장번호 = 사업장번호;
		}
		public String get사업장명() {
			return 사업장명;
		}
		public void set사업장명(String 사업장명) {
			this.사업장명 = 사업장명;
		}
		public String get사업장구분() {
			return 사업장구분;
		}
		public void set사업장구분(String 사업장구분) {
			this.사업장구분 = 사업장구분;
		}
		public String get부서코드() {
			return 부서코드;
		}
		public void set부서코드(String 부서코드) {
			this.부서코드 = 부서코드;
		}
	}
}
