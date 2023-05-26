package foren.unilite.modules.com.common;

import foren.framework.model.BaseVO;

/**
 * 청구내역  Model
 */
public class CMS600ukrModel extends BaseVO {

	private static final long serialVersionUID = 8494636547402626092L;
	
	class InputClass {
		private String 조회구분;
		private String 사업장구분;
		private String 사업장번호;
		private String 카드번호;
		private String 구분;
		private String 결제일;
		private String 카드비밀번호;
		private String 부서코드;
		
		public String get조회구분() {
			return 조회구분;
		}
		public void set조회구분(String 조회구분) {
			this.조회구분 = 조회구분;
		}
		public String get사업장구분() {
			return 사업장구분;
		}
		public void set사업장구분(String 사업장구분) {
			this.사업장구분 = 사업장구분;
		}
		public String get사업장번호() {
			return 사업장번호;
		}
		public void set사업장번호(String 사업장번호) {
			this.사업장번호 = 사업장번호;
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
		public String get결제일() {
			return 결제일;
		}
		public void set결제일(String 결제일) {
			this.결제일 = 결제일;
		}
		public String get카드비밀번호() {
			return 카드비밀번호;
		}
		public void set카드비밀번호(String 카드비밀번호) {
			this.카드비밀번호 = 카드비밀번호;
		}
		public String get부서코드() {
			return 부서코드;
		}
		public void set부서코드(String 부서코드) {
			this.부서코드 = 부서코드;
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
		private String 내역정렬순서;
		private String 월청구금액;
		private String 결제계좌은행;
		private String 결제계좌번호;
		private ClaimHistory[] 청구내역조회;
		
		public String get내역정렬순서() {
			return 내역정렬순서;
		}
		public void set내역정렬순서(String 내역정렬순서) {
			this.내역정렬순서 = 내역정렬순서;
		}
		public String get월청구금액() {
			return 월청구금액;
		}
		public void set월청구금액(String 월청구금액) {
			this.월청구금액 = 월청구금액;
		}
		public String get결제계좌은행() {
			return 결제계좌은행;
		}
		public void set결제계좌은행(String 결제계좌은행) {
			this.결제계좌은행 = 결제계좌은행;
		}
		public String get결제계좌번호() {
			return 결제계좌번호;
		}
		public void set결제계좌번호(String 결제계좌번호) {
			this.결제계좌번호 = 결제계좌번호;
		}
		public ClaimHistory[] get청구내역조회() {
			return 청구내역조회;
		}
		public void set청구내역조회(ClaimHistory[] 청구내역조회) {
			this.청구내역조회 = 청구내역조회;
		}
	}
	// 청구내역조회
	class ClaimHistory {
		private String 카드번호;
		private String 카드종류;
		private String 결제일;
		private String 이용일자;
		private String 가맹점명;
		private String 할부개월;
		private String 입금회차;
		private String 이용대금;
		private String 청구금액;
		private String 수수료;
		private String 결제후잔액;
		private String 가맹점사업자번호;
		private String 가맹점업종;
		private String 가맹점주소;
		private String 가맹점전화번호;
		private String 가맹점대표자명;
		private String 회원사;
		private String 카드번호형식;
		private String 청구내역포인트;
		
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
		public String get결제일() {
			return 결제일;
		}
		public void set결제일(String 결제일) {
			this.결제일 = 결제일;
		}
		public String get이용일자() {
			return 이용일자;
		}
		public void set이용일자(String 이용일자) {
			this.이용일자 = 이용일자;
		}
		public String get가맹점명() {
			return 가맹점명;
		}
		public void set가맹점명(String 가맹점명) {
			this.가맹점명 = 가맹점명;
		}
		public String get할부개월() {
			return 할부개월;
		}
		public void set할부개월(String 할부개월) {
			this.할부개월 = 할부개월;
		}
		public String get입금회차() {
			return 입금회차;
		}
		public void set입금회차(String 입금회차) {
			this.입금회차 = 입금회차;
		}
		public String get이용대금() {
			return 이용대금;
		}
		public void set이용대금(String 이용대금) {
			this.이용대금 = 이용대금;
		}
		public String get청구금액() {
			return 청구금액;
		}
		public void set청구금액(String 청구금액) {
			this.청구금액 = 청구금액;
		}
		public String get수수료() {
			return 수수료;
		}
		public void set수수료(String 수수료) {
			this.수수료 = 수수료;
		}
		public String get결제후잔액() {
			return 결제후잔액;
		}
		public void set결제후잔액(String 결제후잔액) {
			this.결제후잔액 = 결제후잔액;
		}
		public String get가맹점사업자번호() {
			return 가맹점사업자번호;
		}
		public void set가맹점사업자번호(String 가맹점사업자번호) {
			this.가맹점사업자번호 = 가맹점사업자번호;
		}
		public String get가맹점업종() {
			return 가맹점업종;
		}
		public void set가맹점업종(String 가맹점업종) {
			this.가맹점업종 = 가맹점업종;
		}
		public String get가맹점주소() {
			return 가맹점주소;
		}
		public void set가맹점주소(String 가맹점주소) {
			this.가맹점주소 = 가맹점주소;
		}
		public String get가맹점전화번호() {
			return 가맹점전화번호;
		}
		public void set가맹점전화번호(String 가맹점전화번호) {
			this.가맹점전화번호 = 가맹점전화번호;
		}
		public String get가맹점대표자명() {
			return 가맹점대표자명;
		}
		public void set가맹점대표자명(String 가맹점대표자명) {
			this.가맹점대표자명 = 가맹점대표자명;
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
		public String get청구내역포인트() {
			return 청구내역포인트;
		}
		public void set청구내역포인트(String 청구내역포인트) {
			this.청구내역포인트 = 청구내역포인트;
		}
	}
}
