package foren.unilite.modules.com.common;

import foren.framework.model.BaseVO;
/**
 * 전자세금계산서통합조회  Model
 */
public class CMS100ukrModel extends BaseVO{

	private static final long serialVersionUID = 2055336427374212505L;

	class InputClass {
		private String 분류;
		private String 매입매출구분;
		private String 조회기준;
		private String 조회시작일;
		private String 조회종료일;
		private String 공급자구분;
		private String 공급받는자_등록번호;
		private String 공급자_사업자등록번호;
		private String 전자세금계산서종류_대분류;
		private String 전자세금계산서종류_중분류;
		private String 페이지별건수;
		

		public String get분류() {
			return 분류;
		}
		public void set분류(String 분류) {
			this.분류 = 분류;
		}
		public String get매입매출구분() {
			return 매입매출구분;
		}
		public void set매입매출구분(String 매입매출구분) {
			this.매입매출구분 = 매입매출구분;
		}
		public String get조회기준() {
			return 조회기준;
		}
		public void set조회기준(String 조회기준) {
			this.조회기준 = 조회기준;
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
		public String get공급자구분() {
			return 공급자구분;
		}
		public void set공급자구분(String 공급자구분) {
			this.공급자구분 = 공급자구분;
		}
		public String get공급받는자_등록번호() {
			return 공급받는자_등록번호;
		}
		public void set공급받는자_등록번호(String 공급받는자_등록번호) {
			this.공급받는자_등록번호 = 공급받는자_등록번호;
		}
		public String get공급자_사업자등록번호() {
			return 공급자_사업자등록번호;
		}
		public void set공급자_사업자등록번호(String 공급자_사업자등록번호) {
			this.공급자_사업자등록번호 = 공급자_사업자등록번호;
		}
		public String get전자세금계산서종류_대분류() {
			return 전자세금계산서종류_대분류;
		}
		public void set전자세금계산서종류_대분류(String 전자세금계산서종류_대분류) {
			this.전자세금계산서종류_대분류 = 전자세금계산서종류_대분류;
		}
		public String get전자세금계산서종류_중분류() {
			return 전자세금계산서종류_중분류;
		}
		public void set전자세금계산서종류_중분류(String 전자세금계산서종류_중분류) {
			this.전자세금계산서종류_중분류 = 전자세금계산서종류_중분류;
		}
		public String get페이지별건수() {
			return 페이지별건수;
		}
		public void set페이지별건수(String 페이지별건수) {
			this.페이지별건수 = 페이지별건수;
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
		private String 페이지번호;
		private Integrate[] 전자세금계산서통합조회;
		
		public String get페이지번호() {
			return 페이지번호;
		}
		public void set페이지번호(String 페이지번호) {
			this.페이지번호 = 페이지번호;
		}
		public Integrate[] get전자세금계산서통합조회() {
			return 전자세금계산서통합조회;
		}
		public void set전자세금계산서통합조회(Integrate[] 전자세금계산서통합조회) {
			this.전자세금계산서통합조회 = 전자세금계산서통합조회;
		}
	}
	// 전자세금계산서통합조회
	class Integrate {
		private String 작성일자;
		private String 승인번호;
		private String 발급일자;
		private String 전송일자;
		private String 공급받는자등록번호;
		private String 공급자사업자등록번호;
		private String 종사업장번호;
		private String 상호;
		private String 대표자명;
		private String 합계금액;
		private String 공급가액;
		private String 세액;
		private String 전자세금계산서종류;
		private String 전자계산서종류;
		private String 발급유형;
		private String 비고;
		private String 영수_청구;
		private String 공급자이메일;
		private String 공급받는자이메일1;
		private String 공급받는자이메일2;
		private IntegrateDetail[] 전자세금계산서통합조회_상세조회;
		
		public String get작성일자() {
			return 작성일자;
		}
		public void set작성일자(String 작성일자) {
			this.작성일자 = 작성일자;
		}
		public String get승인번호() {
			return 승인번호;
		}
		public void set승인번호(String 승인번호) {
			this.승인번호 = 승인번호;
		}
		public String get발급일자() {
			return 발급일자;
		}
		public void set발급일자(String 발급일자) {
			this.발급일자 = 발급일자;
		}
		public String get전송일자() {
			return 전송일자;
		}
		public void set전송일자(String 전송일자) {
			this.전송일자 = 전송일자;
		}
		public String get공급받는자등록번호() {
			return 공급받는자등록번호;
		}
		public void set공급받는자등록번호(String 공급받는자등록번호) {
			this.공급받는자등록번호 = 공급받는자등록번호;
		}
		public String get공급자사업자등록번호() {
			return 공급자사업자등록번호;
		}
		public void set공급자사업자등록번호(String 공급자사업자등록번호) {
			this.공급자사업자등록번호 = 공급자사업자등록번호;
		}
		public String get종사업장번호() {
			return 종사업장번호;
		}
		public void set종사업장번호(String 종사업장번호) {
			this.종사업장번호 = 종사업장번호;
		}
		public String get상호() {
			return 상호;
		}
		public void set상호(String 상호) {
			this.상호 = 상호;
		}
		public String get대표자명() {
			return 대표자명;
		}
		public void set대표자명(String 대표자명) {
			this.대표자명 = 대표자명;
		}
		public String get합계금액() {
			return 합계금액;
		}
		public void set합계금액(String 합계금액) {
			this.합계금액 = 합계금액;
		}
		public String get공급가액() {
			return 공급가액;
		}
		public void set공급가액(String 공급가액) {
			this.공급가액 = 공급가액;
		}
		public String get세액() {
			return 세액;
		}
		public void set세액(String 세액) {
			this.세액 = 세액;
		}
		public String get전자세금계산서종류() {
			return 전자세금계산서종류;
		}
		public void set전자세금계산서종류(String 전자세금계산서종류) {
			this.전자세금계산서종류 = 전자세금계산서종류;
		}
		public String get전자계산서종류() {
			return 전자계산서종류;
		}
		public void set전자계산서종류(String 전자계산서종류) {
			this.전자계산서종류 = 전자계산서종류;
		}
		public String get발급유형() {
			return 발급유형;
		}
		public void set발급유형(String 발급유형) {
			this.발급유형 = 발급유형;
		}
		public String get비고() {
			return 비고;
		}
		public void set비고(String 비고) {
			this.비고 = 비고;
		}
		public String get영수_청구() {
			return 영수_청구;
		}
		public void set영수_청구(String 영수_청구) {
			this.영수_청구 = 영수_청구;
		}
		public String get공급자이메일() {
			return 공급자이메일;
		}
		public void set공급자이메일(String 공급자이메일) {
			this.공급자이메일 = 공급자이메일;
		}
		public String get공급받는자이메일1() {
			return 공급받는자이메일1;
		}
		public void set공급받는자이메일1(String 공급받는자이메일1) {
			this.공급받는자이메일1 = 공급받는자이메일1;
		}
		public String get공급받는자이메일2() {
			return 공급받는자이메일2;
		}
		public void set공급받는자이메일2(String 공급받는자이메일2) {
			this.공급받는자이메일2 = 공급받는자이메일2;
		}
		public IntegrateDetail[] get전자세금계산서통합조회_상세조회() {
			return 전자세금계산서통합조회_상세조회;
		}
		public void set전자세금계산서통합조회_상세조회(IntegrateDetail[] 전자세금계산서통합조회_상세조회) {
			this.전자세금계산서통합조회_상세조회 = 전자세금계산서통합조회_상세조회;
		}
	}
	// 전자세금계산서통합조회_상세조회
	class IntegrateDetail {
		private String detailerror;
		private String 작성일자;
		private String 공급가액;
		private String 세액;
		private String 수정사유;
		private String 비고;
		private String 합계금액;
		private String 현금;
		private String 수표;
		private String 어음;
		private String 외상미수금;
		private supInfo[] 공급자;
		private supInfo[] 공급받는자;
		private supInfo[] 수탁자;
		private billDetail[] 전자세금계산서_상세;
		
		public String getDetailerror() {
			return detailerror;
		}
		public void setDetailerror(String detailerror) {
			this.detailerror = detailerror;
		}
		public String get작성일자() {
			return 작성일자;
		}
		public void set작성일자(String 작성일자) {
			this.작성일자 = 작성일자;
		}
		public String get공급가액() {
			return 공급가액;
		}
		public void set공급가액(String 공급가액) {
			this.공급가액 = 공급가액;
		}
		public String get세액() {
			return 세액;
		}
		public void set세액(String 세액) {
			this.세액 = 세액;
		}
		public String get수정사유() {
			return 수정사유;
		}
		public void set수정사유(String 수정사유) {
			this.수정사유 = 수정사유;
		}
		public String get비고() {
			return 비고;
		}
		public void set비고(String 비고) {
			this.비고 = 비고;
		}
		public String get합계금액() {
			return 합계금액;
		}
		public void set합계금액(String 합계금액) {
			this.합계금액 = 합계금액;
		}
		public String get현금() {
			return 현금;
		}
		public void set현금(String 현금) {
			this.현금 = 현금;
		}
		public String get수표() {
			return 수표;
		}
		public void set수표(String 수표) {
			this.수표 = 수표;
		}
		public String get어음() {
			return 어음;
		}
		public void set어음(String 어음) {
			this.어음 = 어음;
		}
		public String get외상미수금() {
			return 외상미수금;
		}
		public void set외상미수금(String 외상미수금) {
			this.외상미수금 = 외상미수금;
		}
		public supInfo[] get공급자() {
			return 공급자;
		}
		public void set공급자(supInfo[] 공급자) {
			this.공급자 = 공급자;
		}
		public supInfo[] get공급받는자() {
			return 공급받는자;
		}
		public void set공급받는자(supInfo[] 공급받는자) {
			this.공급받는자 = 공급받는자;
		}
		public supInfo[] get수탁자() {
			return 수탁자;
		}
		public void set수탁자(supInfo[] 수탁자) {
			this.수탁자 = 수탁자;
		}
		public billDetail[] get전자세금계산서_상세() {
			return 전자세금계산서_상세;
		}
		public void set전자세금계산서_상세(billDetail[] 전자세금계산서_상세) {
			this.전자세금계산서_상세 = 전자세금계산서_상세;
		}
	}
	// 공급자, 공급받는자, 수탁자
	class supInfo {
		private String 등록번호;
		private String 종사업장번호;
		private String 상호;
		private String 성명;
		private String 사업장;
		private String 업태;
		private String 종목;
		private String 이메일;
		public String get등록번호() {
			return 등록번호;
		}
		public void set등록번호(String 등록번호) {
			this.등록번호 = 등록번호;
		}
		public String get종사업장번호() {
			return 종사업장번호;
		}
		public void set종사업장번호(String 종사업장번호) {
			this.종사업장번호 = 종사업장번호;
		}
		public String get상호() {
			return 상호;
		}
		public void set상호(String 상호) {
			this.상호 = 상호;
		}
		public String get성명() {
			return 성명;
		}
		public void set성명(String 성명) {
			this.성명 = 성명;
		}
		public String get사업장() {
			return 사업장;
		}
		public void set사업장(String 사업장) {
			this.사업장 = 사업장;
		}
		public String get업태() {
			return 업태;
		}
		public void set업태(String 업태) {
			this.업태 = 업태;
		}
		public String get종목() {
			return 종목;
		}
		public void set종목(String 종목) {
			this.종목 = 종목;
		}
		public String get이메일() {
			return 이메일;
		}
		public void set이메일(String 이메일) {
			this.이메일 = 이메일;
		}
	}
	// 계산서 상세
	class billDetail {
		private String 월일;
		private String 품목;
		private String 규격;
		private String 수량;
		private String 단가;
		private String 공급가액;
		private String 세액;
		private String 비고;
		public String get월일() {
			return 월일;
		}
		public void set월일(String 월일) {
			this.월일 = 월일;
		}
		public String get품목() {
			return 품목;
		}
		public void set품목(String 품목) {
			this.품목 = 품목;
		}
		public String get규격() {
			return 규격;
		}
		public void set규격(String 규격) {
			this.규격 = 규격;
		}
		public String get수량() {
			return 수량;
		}
		public void set수량(String 수량) {
			this.수량 = 수량;
		}
		public String get단가() {
			return 단가;
		}
		public void set단가(String 단가) {
			this.단가 = 단가;
		}
		public String get공급가액() {
			return 공급가액;
		}
		public void set공급가액(String 공급가액) {
			this.공급가액 = 공급가액;
		}
		public String get세액() {
			return 세액;
		}
		public void set세액(String 세액) {
			this.세액 = 세액;
		}
		public String get비고() {
			return 비고;
		}
		public void set비고(String 비고) {
			this.비고 = 비고;
		}
	}
}
