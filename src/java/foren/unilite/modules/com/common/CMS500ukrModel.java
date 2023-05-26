package foren.unilite.modules.com.common;

import org.apache.commons.lang.StringUtils;

import foren.framework.model.BaseVO;

/**
 * 승인내역  Model
 */
public class CMS500ukrModel extends BaseVO {

	private static final long serialVersionUID = 2904845568917737324L;
	
	class InputClass {
		private String 조회구분;
		private String 카드번호;
		private String 회원사;
		private String 조회시작일;
		private String 조회종료일;		

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
		public String get회원사() {
			return 회원사;
		}
		public void set회원사(String 회원사) {
			this.회원사 = 회원사;
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
	class Result {
		private String 내역정렬순서;
		private ProveHistory[] 승인내역조회;
		public String get내역정렬순서() {
			return 내역정렬순서;
		}
		public void set내역정렬순서(String 내역정렬순서) {
			this.내역정렬순서 = 내역정렬순서;
		}
		public ProveHistory[] get승인내역조회() {
			for(ProveHistory p : 승인내역조회) {
				p.set승인일자(p.get승인일자());
				p.set승인시간(p.get승인시간());
				p.set승인번호(p.get승인번호());
				p.set카드종류(p.get카드종류());
				p.set카드번호(p.get카드번호());
				p.set가맹점명(p.get가맹점명());
				p.set매출종류(p.get매출종류());
				p.set할부기간(p.get할부기간());
				p.set승인금액(p.get승인금액());
				p.set취소년월일(p.get취소년월일());
				p.set결제예정일(p.get결제예정일());
				p.set가맹점사업자번호(p.get가맹점사업자번호());
				p.set가맹점코드(p.get가맹점코드());
				p.set가맹점업종(p.get가맹점업종());
				p.set가맹점주소(p.get가맹점주소());
				p.set가맹점전화번호(p.get가맹점전화번호());
				p.set가맹점대표자명(p.get가맹점대표자명());
				p.set부가세(p.get부가세());
				p.set매입상태(p.get매입상태());
				p.set통화코드(p.get통화코드());
				p.set국내외구분(p.get국내외구분());
				p.set카드번호형식(p.get카드번호형식());
			}
			
			return 승인내역조회;
		}
		public void set승인내역조회(ProveHistory[] 승인내역조회) {
			this.승인내역조회 = 승인내역조회;
		}
	}
	// 승인내역조회
	class ProveHistory {
		private String 승인일자;
		private String 승인시간;
		private String 승인번호;
		private String 카드종류;
		private String 카드번호;
		private String 가맹점명;
		private String 매출종류;
		private String 할부기간;
		private String 승인금액;
		private String 취소년월일;
		private String 결제예정일;
		private String 가맹점사업자번호;
		private String 가맹점코드;
		private String 가맹점업종;
		private String 가맹점주소;
		private String 가맹점전화번호;
		private String 가맹점대표자명;
		private String 부가세;
		private String 매입상태;
		private String 통화코드;
		private String 국내외구분;
		private String 카드번호형식;
		public String get승인일자() {
			return 승인일자;
		}
		public void set승인일자(String 승인일자) {
			this.승인일자 = this.nvl(승인일자, "");
		}
		public String get승인시간() {
			return 승인시간;
		}
		public void set승인시간(String 승인시간) {
			this.승인시간 = this.nvl(승인시간, "");
		}
		public String get승인번호() {
			return 승인번호;
		}
		public void set승인번호(String 승인번호) {
			this.승인번호 = this.nvl(승인번호, "");
		}
		public String get카드종류() {
			return 카드종류;
		}
		public void set카드종류(String 카드종류) {
			this.카드종류 = this.nvl(카드종류, "");
		}
		public String get카드번호() {
			return 카드번호;
		}
		public void set카드번호(String 카드번호) {
			this.카드번호 = this.nvl(카드번호, "");
		}
		public String get가맹점명() {
			return 가맹점명;
		}
		public void set가맹점명(String 가맹점명) {
			this.가맹점명 = this.nvl(가맹점명, "");
		}
		public String get매출종류() {
			return 매출종류;
		}
		public void set매출종류(String 매출종류) {
			this.매출종류 = this.nvl(매출종류, "");
		}
		public String get할부기간() {
			return 할부기간;
		}
		public void set할부기간(String 할부기간) {
			this.할부기간 = this.nvl(할부기간, "");
		}
		public String get승인금액() {
			return 승인금액;
		}
		public void set승인금액(String 승인금액) {
			this.승인금액 = this.nvl(승인금액, "0");
		}
		public String get취소년월일() {
			return 취소년월일;
		}
		public void set취소년월일(String 취소년월일) {
			this.취소년월일 = this.nvl(취소년월일, "");
		}
		public String get결제예정일() {
			return 결제예정일;
		}
		public void set결제예정일(String 결제예정일) {
			this.결제예정일 = this.nvl(결제예정일, "");
		}
		public String get가맹점사업자번호() {
			return 가맹점사업자번호;
		}
		public void set가맹점사업자번호(String 가맹점사업자번호) {
			this.가맹점사업자번호 = this.nvl(가맹점사업자번호, "");
		}
		public String get가맹점코드() {
			return 가맹점코드;
		}
		public void set가맹점코드(String 가맹점코드) {
			this.가맹점코드 = this.nvl(가맹점코드, "");
		}
		public String get가맹점업종() {
			return 가맹점업종;
		}
		public void set가맹점업종(String 가맹점업종) {
			this.가맹점업종 = this.nvl(가맹점업종, "");
		}
		public String get가맹점주소() {
			return 가맹점주소;
		}
		public void set가맹점주소(String 가맹점주소) {
			this.가맹점주소 = this.nvl(가맹점주소, "");
		}
		public String get가맹점전화번호() {
			return 가맹점전화번호;
		}
		public void set가맹점전화번호(String 가맹점전화번호) {
			this.가맹점전화번호 = this.nvl(가맹점전화번호, "");
		}
		public String get가맹점대표자명() {
			return 가맹점대표자명;
		}
		public void set가맹점대표자명(String 가맹점대표자명) {
			this.가맹점대표자명 = this.nvl(가맹점대표자명, "");
		}
		public String get부가세() {
			return this.nvl(this.부가세, "0");
		}
		public void set부가세(String 부가세) {
			this.부가세 = this.nvl(부가세, "0");
		}
		public String get매입상태() {
			return 매입상태;
		}
		public void set매입상태(String 매입상태) {
			this.매입상태 = this.nvl(매입상태, "");
		}
		public String get통화코드() {
			return 통화코드;
		}
		public void set통화코드(String 통화코드) {
			this.통화코드 = this.nvl(통화코드, "");
		}
		public String get국내외구분() {
			return 국내외구분;
		}
		public void set국내외구분(String 국내외구분) {
			this.국내외구분 = this.nvl(국내외구분, "");
		}
		public String get카드번호형식() {
			return 카드번호형식;
		}
		public void set카드번호형식(String 카드번호형식) {
			this.카드번호형식 = this.nvl(카드번호형식, "");
		}
		
		private String nvl(String str, String alterStr) {
			if(StringUtils.isEmpty(str)) {
				return alterStr;
			}
			return str;
		}
	}
}
