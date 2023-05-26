package foren.unilite.modules.com.common;

import foren.framework.model.BaseVO;

/**
 * 한도조회  Model
 */
public class CMS700ukrModel extends BaseVO {

	private static final long serialVersionUID = -2510600153438235552L;
	
	class InputClass {
		private String 조회구분;
		private String 카드번호;
		private String 구분;
		private String 카드비밀번호;
		
		public String get조회구분() {
			return 조회구분;
		}
		public void set조회구분(String 조회구분) {
			this.조회구분 = 조회구분;
		}
		public String get카드번호() {
			return 카드번호;
		}
		public void set카드번호(String 카드번호) {
			this.카드번호 = 카드번호;
		}
		public String get구분() {
			return 구분;
		}
		public void set구분(String 구분) {
			this.구분 = 구분;
		}
		public String get카드비밀번호() {
			return 카드비밀번호;
		}
		public void set카드비밀번호(String 카드비밀번호) {
			this.카드비밀번호 = 카드비밀번호;
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
		private Limit[] 한도조회;

		public Limit[] get한도조회() {
			return 한도조회;
		}
		public void set한도조회(Limit[] 한도조회) {
			this.한도조회 = 한도조회;
		}
	}
	// 한도조회
	class Limit{
		private String 카드번호;
		private String 카드종류;
		private String 카드사용_한도금액;
		private String 카드사용한도_사용금액;
		private String 카드사용한도_잔여금액;
		private String 일시불_한도금액;
		private String 일시불_사용금액;
		private String 일시불_한도잔여금액;
		private String 할부_한도금액;
		private String 할부_사용금액;
		private String 할부_한도잔여금액;
		private String 해외_한도금액;
		private String 해외_사용금액;
		private String 해외_한도잔여금액;
		private String 현금서비스_한도금액;
		private String 현금서비스_사용금액;
		private String 현금서비스_한도잔여금액;
		private String 통화코드;
		private String 회원사;
		private String 카드번호형식;
		private String 일한도;
		private String 월한도;
		
		public String get카드번호() {
			return 카드번호;
		}
		public void set카드번호(String 카드번호) {
			this.카드번호 = 카드번호;
		}
		public String get카드종류() {
			return 카드종류;
		}
		public void set카드종류(String 카드종류) {
			this.카드종류 = 카드종류;
		}
		public String get카드사용_한도금액() {
			return 카드사용_한도금액;
		}
		public void set카드사용_한도금액(String 카드사용_한도금액) {
			this.카드사용_한도금액 = 카드사용_한도금액;
		}
		public String get카드사용한도_사용금액() {
			return 카드사용한도_사용금액;
		}
		public void set카드사용한도_사용금액(String 카드사용한도_사용금액) {
			this.카드사용한도_사용금액 = 카드사용한도_사용금액;
		}
		public String get카드사용한도_잔여금액() {
			return 카드사용한도_잔여금액;
		}
		public void set카드사용한도_잔여금액(String 카드사용한도_잔여금액) {
			this.카드사용한도_잔여금액 = 카드사용한도_잔여금액;
		}
		public String get일시불_한도금액() {
			return 일시불_한도금액;
		}
		public void set일시불_한도금액(String 일시불_한도금액) {
			this.일시불_한도금액 = 일시불_한도금액;
		}
		public String get일시불_사용금액() {
			return 일시불_사용금액;
		}
		public void set일시불_사용금액(String 일시불_사용금액) {
			this.일시불_사용금액 = 일시불_사용금액;
		}
		public String get일시불_한도잔여금액() {
			return 일시불_한도잔여금액;
		}
		public void set일시불_한도잔여금액(String 일시불_한도잔여금액) {
			this.일시불_한도잔여금액 = 일시불_한도잔여금액;
		}
		public String get할부_한도금액() {
			return 할부_한도금액;
		}
		public void set할부_한도금액(String 할부_한도금액) {
			this.할부_한도금액 = 할부_한도금액;
		}
		public String get할부_사용금액() {
			return 할부_사용금액;
		}
		public void set할부_사용금액(String 할부_사용금액) {
			this.할부_사용금액 = 할부_사용금액;
		}
		public String get할부_한도잔여금액() {
			return 할부_한도잔여금액;
		}
		public void set할부_한도잔여금액(String 할부_한도잔여금액) {
			this.할부_한도잔여금액 = 할부_한도잔여금액;
		}
		public String get해외_한도금액() {
			return 해외_한도금액;
		}
		public void set해외_한도금액(String 해외_한도금액) {
			this.해외_한도금액 = 해외_한도금액;
		}
		public String get해외_사용금액() {
			return 해외_사용금액;
		}
		public void set해외_사용금액(String 해외_사용금액) {
			this.해외_사용금액 = 해외_사용금액;
		}
		public String get해외_한도잔여금액() {
			return 해외_한도잔여금액;
		}
		public void set해외_한도잔여금액(String 해외_한도잔여금액) {
			this.해외_한도잔여금액 = 해외_한도잔여금액;
		}
		public String get현금서비스_한도금액() {
			return 현금서비스_한도금액;
		}
		public void set현금서비스_한도금액(String 현금서비스_한도금액) {
			this.현금서비스_한도금액 = 현금서비스_한도금액;
		}
		public String get현금서비스_사용금액() {
			return 현금서비스_사용금액;
		}
		public void set현금서비스_사용금액(String 현금서비스_사용금액) {
			this.현금서비스_사용금액 = 현금서비스_사용금액;
		}
		public String get현금서비스_한도잔여금액() {
			return 현금서비스_한도잔여금액;
		}
		public void set현금서비스_한도잔여금액(String 현금서비스_한도잔여금액) {
			this.현금서비스_한도잔여금액 = 현금서비스_한도잔여금액;
		}
		public String get통화코드() {
			return 통화코드;
		}
		public void set통화코드(String 통화코드) {
			this.통화코드 = 통화코드;
		}
		public String get회원사() {
			return 회원사;
		}
		public void set회원사(String 회원사) {
			this.회원사 = 회원사;
		}
		public String get카드번호형식() {
			return 카드번호형식;
		}
		public void set카드번호형식(String 카드번호형식) {
			this.카드번호형식 = 카드번호형식;
		}
		public String get일한도() {
			return 일한도;
		}
		public void set일한도(String 일한도) {
			this.일한도 = 일한도;
		}
		public String get월한도() {
			return 월한도;
		}
		public void set월한도(String 월한도) {
			this.월한도 = 월한도;
		}
	}
}
