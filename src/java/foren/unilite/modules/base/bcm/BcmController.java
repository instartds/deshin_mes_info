package foren.unilite.modules.base.bcm;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

@Controller
public class BcmController extends UniliteCommonController {

	@Resource( name = "UniliteComboServiceImpl" )
	private ComboServiceImpl	  comboService;

	@Resource( name = "bcm105ukrvService" )
	private Bcm105ukrvServiceImpl bcm105ukrvService;

	private final Logger		  logger   = LoggerFactory.getLogger(this.getClass());

	final static String		   JSP_PATH = "/base/bcm/";

	@RequestMapping( value = "/base/bcm100ukrv.do", method = RequestMethod.GET )
	public String bcm100ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B244", "10");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsHiddenField", cdo.getRefCode1());
		cdo = codeInfo.getCodeInfo("B915", "01");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsCompanyNumChk", cdo.getRefCode1());
		return JSP_PATH + "bcm100ukrv";
	}

	@RequestMapping( value = "/base/bcm102ukrv.do", method = RequestMethod.GET )
	public String bcm102ukrv() throws Exception {
		return JSP_PATH + "bcm102ukrv";
	}

	@RequestMapping( value = "/base/bcm103ukrv.do", method = RequestMethod.GET )
	public String bcm103ukrv() throws Exception {
		return JSP_PATH + "bcm103ukrv";
	}

	@RequestMapping( value = "/base/bcm104ukrv.do", method = RequestMethod.GET )
	public String bcm104ukrv( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> cdList = codeInfo.getCodeList("B015");
		if (!ObjUtils.isEmpty(cdList)) model.addAttribute("grsCustomType", ObjUtils.toJsonStr(cdList));//거래처구분
		return JSP_PATH + "bcm104ukrv";
	}

	@RequestMapping( value = "/base/bcm104skrv.do", method = RequestMethod.GET )
	public String bcm104skrv( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> cdList = codeInfo.getCodeList("B015");
		if (!ObjUtils.isEmpty(cdList)) model.addAttribute("grsCustomType", ObjUtils.toJsonStr(cdList));//거래처구분
		return JSP_PATH + "bcm104skrv";
	}

	@RequestMapping( value = "/base/bcm105ukrv.do", method = RequestMethod.GET )
	public String bcm105ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B244", "10");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsHiddenField", cdo.getRefCode1());

		return JSP_PATH + "bcm105ukrv";
	}

	/**
	 * 거래처정보등록 - Excel 다운로드
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/bcm105excel.do" )
	public ModelAndView bcm105excel( ExtHtttprequestParam _req, LoginVO loginVO ) throws Exception {
		AES256DecryptoUtils decrypto = new AES256DecryptoUtils();
		String excelFileName = "거래처정보목록";

		Workbook workbook = new HSSFWorkbook();
		Sheet sheet = workbook.createSheet("Sheet1");
		Row headerRow = null;
		Row row = null;

		DataFormat formet = workbook.createDataFormat();

		// Style 00 : 기본
		CellStyle style00 = workbook.createCellStyle();
		style00.setBorderBottom(CellStyle.BORDER_HAIR);
		style00.setBorderLeft(CellStyle.BORDER_HAIR);
		style00.setBorderRight(CellStyle.BORDER_HAIR);
		style00.setBorderTop(CellStyle.BORDER_HAIR);

		// Style 01 : 중앙정렬
		CellStyle style01 = workbook.createCellStyle();
		style01.setBorderBottom(CellStyle.BORDER_HAIR);
		style01.setBorderLeft(CellStyle.BORDER_HAIR);
		style01.setBorderRight(CellStyle.BORDER_HAIR);
		style01.setBorderTop(CellStyle.BORDER_HAIR);
		style01.setAlignment(CellStyle.ALIGN_CENTER);
		style01.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		// Style 03 : 숫자
		CellStyle style03 = workbook.createCellStyle();
		style03.setBorderBottom(CellStyle.BORDER_HAIR);
		style03.setBorderLeft(CellStyle.BORDER_HAIR);
		style03.setBorderRight(CellStyle.BORDER_HAIR);
		style03.setBorderTop(CellStyle.BORDER_HAIR);
		style03.setDataFormat(formet.getFormat("#,##0"));

		headerRow = sheet.createRow(0);

		String[] titleA = { "거래처코드", "구분", "거래처명", "거래처명(전명)", "사업자번호", "대표자", "업태", "업종", "거래처분류", "연락처", "비고", "거래처명1", "거래처명2", "국가코드", "법인/구분", "거래처분류2", "거래처분류3", "지역", "우편번호", "주소1", "주소2", "FAX번호", "홈페이지", "E-mail", "거래시작일", "거래중단일", "송신주소", "세액계산법", "결제기간", "기준화폐", "세액포함여부", "계산서유형", "결제방법", "세율", "마감종류", "수금일", "여신적용여부", "여신(담보)액", "신용여신액", "신용여신만료일", "미수관리방법", "주담당자", "집계거래처", "집계거래처명", "수금거래처", "수금거래처명", "금융기관", "금융기관명", "계좌번호", "예금주", "구매카드은행", "구매카드은행명", "전자문서담당자", "핸드폰번호", "전자문서E-mail", "전자문서담당자2", "핸드폰번호2", "전자문서E-mail2", "전자세금계산서", "신/구주소 구분", "CHANNEL", "계산서거래처코드", "계산서거래처", "관련부서", "관련부서명", "전자세금계산서발행유형" };

		logger.info("titleA.length :: {}", titleA.length);

		// Cell 생성
		for (int j = 0; j < titleA.length; j++) {
			headerRow.createCell(j);
		}

		// Cell Title
		for (int j = 0; j < titleA.length; j++) {
			headerRow.getCell(j).setCellValue(titleA[j]);
		}

		// Cell Style
		for (int j = 0; j < titleA.length; j++) {
			headerRow.getCell(j).setCellStyle(style01);
		}

		// Cell Width
		for (int j = 0; j < titleA.length; j++) {
			sheet.setColumnWidth(j, 18 * 256);  //  n * 256의 형태로 한 이유는 1글자가 256의 크기를 갖기 때문 ....
		}

		String CUSTOM_CODE = _req.getP("CUSTOM_CODE");
		String CUSTOM_NAME = _req.getP("CUSTOM_NAME");
		String CUSTOM_TYPE = _req.getP("CUSTOM_TYPE");

		Map<String, Object> param = new HashMap<String, Object>();

		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_USER_ID", loginVO.getUserID());
		param.put("CUSTOM_CODE", CUSTOM_CODE);
		param.put("CUSTOM_NAME", CUSTOM_NAME);
		param.put("CUSTOM_TYPE", CUSTOM_TYPE);

		logger.info("param :: {}", param);

		List<Map<String, Object>> list01 = bcm105ukrvService.selectExcelList(param);

		/*******************************************************************************************
		 * 0. Excel 다운로드 시작
		 *******************************************************************************************/

		if (list01.size() > 0) {

			int i = 0;

			for (Map<String, Object> map : list01) {
				++i;
				row = sheet.createRow(i);

				row.createCell(0).setCellValue((String)map.get("CUSTOM_CODE"));		 // 거래처코드
				row.createCell(1).setCellValue((String)map.get("CUSTOM_TYPE"));		 // 구분
				row.createCell(2).setCellValue((String)map.get("CUSTOM_NAME"));		 // 거래처명
				row.createCell(3).setCellValue((String)map.get("CUSTOM_FULL_NAME"));	// 거래처명(전명)
				row.createCell(4).setCellValue((String)map.get("COMPANY_NUM"));		 // 사업자번호
				row.createCell(5).setCellValue((String)map.get("TOP_NAME"));			// 대표자
				row.createCell(6).setCellValue((String)map.get("COMP_TYPE"));		   // 업태
				row.createCell(7).setCellValue((String)map.get("COMP_CLASS"));		  // 업종
				row.createCell(8).setCellValue((String)map.get("AGENT_TYPE"));		  // 거래처분류
				row.createCell(9).setCellValue((String)map.get("TELEPHON"));			// 연락처
				row.createCell(10).setCellValue((String)map.get("REMARK"));			 // 비고
				row.createCell(11).setCellValue((String)map.get("CUSTOM_NAME1"));	   // 거래처명1
				row.createCell(12).setCellValue((String)map.get("CUSTOM_NAME2"));	   // 거래처명2
				row.createCell(13).setCellValue((String)map.get("NATION_CODE"));		// 국가코드
				row.createCell(14).setCellValue((String)map.get("BUSINESS_TYPE"));	  // 법인/구분
				row.createCell(15).setCellValue((String)map.get("AGENT_TYPE2"));		// 거래처분류2
				row.createCell(16).setCellValue((String)map.get("AGENT_TYPE3"));		// 거래처분류3
				row.createCell(17).setCellValue((String)map.get("AREA_TYPE"));		  // 지역
				row.createCell(18).setCellValue((String)map.get("ZIP_CODE"));		   // 우편번호
				row.createCell(19).setCellValue((String)map.get("ADDR1"));			  // 주소1
				row.createCell(20).setCellValue((String)map.get("ADDR2"));			  // 주소2
				row.createCell(21).setCellValue((String)map.get("FAX_NUM"));			// FAX번호
				row.createCell(22).setCellValue((String)map.get("HTTP_ADDR"));		  // 홈페이지
				row.createCell(23).setCellValue((String)map.get("MAIL_ID"));			// E-mail
				row.createCell(24).setCellValue((String)map.get("START_DATE"));		 // 거래시작일
				row.createCell(25).setCellValue((String)map.get("STOP_DATE"));		  // 거래중단일
				row.createCell(26).setCellValue((String)map.get("TO_ADDRESS"));		 // 송신주소
				row.createCell(27).setCellValue((String)map.get("TAX_CALC_TYPE"));	  // 세액계산법
				row.createCell(28).setCellValue((String)map.get("RECEIPT_DAY"));		// 결제기간
				row.createCell(29).setCellValue((String)map.get("MONEY_UNIT"));		 // 기준화폐
				row.createCell(30).setCellValue((String)map.get("TAX_TYPE"));		   // 세액포함여부
				row.createCell(31).setCellValue((String)map.get("BILL_TYPE"));		  // 계산서유형
				row.createCell(32).setCellValue((String)map.get("SET_METH"));		   // 결제방법

				double VAT_RATE = map.get("VAT_RATE") == null ? 0 : ( (BigDecimal)map.get("VAT_RATE") ).doubleValue();

				row.createCell(33).setCellValue(VAT_RATE);	// 세율
				row.createCell(34).setCellValue((String)map.get("TRANS_CLOSE_DAY"));	// 마감종류
				row.createCell(35).setCellValue((String)map.get("COLLECT_DAY"));		// 수금일
				row.createCell(36).setCellValue((String)map.get("CREDIT_YN"));		  // 여신적용여부

				double TOT_CREDIT_AMT = map.get("TOT_CREDIT_AMT") == null ? 0 : ( (BigDecimal)map.get("TOT_CREDIT_AMT") ).doubleValue();
				double CREDIT_AMT = map.get("CREDIT_AMT") == null ? 0 : ( (BigDecimal)map.get("CREDIT_AMT") ).doubleValue();

				row.createCell(37).setCellValue(TOT_CREDIT_AMT);						// 여신(담보)액
				row.createCell(38).setCellValue(CREDIT_AMT);							// 신용여신액
				row.createCell(39).setCellValue((String)map.get("CREDIT_YMD"));		 // 신용여신만료일
				row.createCell(40).setCellValue((String)map.get("COLLECT_CARE"));	   // 미수관리방법
				row.createCell(41).setCellValue((String)map.get("BUSI_PRSN"));		  // 주담당자
				row.createCell(42).setCellValue((String)map.get("MANAGE_CUSTOM"));	  // 집계거래처
				row.createCell(43).setCellValue((String)map.get("MCUSTOM_NAME"));	   // 집계거래처명
				row.createCell(44).setCellValue((String)map.get("COLLECTOR_CP"));	   // 수금거래처
				row.createCell(45).setCellValue((String)map.get("COLLECTOR_CP_NAME"));  // 수금거래처명
				row.createCell(46).setCellValue((String)map.get("BANK_CODE"));		  // 금융기관
				row.createCell(47).setCellValue((String)map.get("BANK_NAME"));		  // 금융기관명

				if (map.get("BANKBOOK_NUM") == null || ( (String)map.get("BANKBOOK_NUM") ).length() == 0) {
					row.createCell(48).setCellValue("");								// 계좌번호
				} else {
					row.createCell(48).setCellValue(decrypto.getDecrypto("1", (String)map.get("BANKBOOK_NUM")));	// 계좌번호
				}

				row.createCell(49).setCellValue((String)map.get("BANKBOOK_NAME"));	  // 예금주
				row.createCell(50).setCellValue((String)map.get("PURCHASE_BANK"));	  // 구매카드은행
				row.createCell(51).setCellValue((String)map.get("PURBANKNAME"));		// 구매카드은행명
				row.createCell(52).setCellValue((String)map.get("BILL_PRSN"));		  // 전자문서담당자
				row.createCell(53).setCellValue((String)map.get("HAND_PHON"));		  // 핸드폰번호
				row.createCell(54).setCellValue((String)map.get("BILL_MAIL_ID"));	   // 전자문서E-mail
				row.createCell(55).setCellValue((String)map.get("BILL_PRSN2"));		 // 전자문서담당자2
				row.createCell(56).setCellValue((String)map.get("HAND_PHON2"));		 // 핸드폰번호2
				row.createCell(57).setCellValue((String)map.get("BILL_MAIL_ID2"));	  // 전자문서E-mail2
				row.createCell(58).setCellValue((String)map.get("BILL_MEM_TYPE"));	  // 전자세금계산서
				row.createCell(59).setCellValue((String)map.get("ADDR_TYPE"));		  // 신/구주소 구분
				row.createCell(60).setCellValue((String)map.get("CHANNEL"));			// CHANNEL
				row.createCell(61).setCellValue((String)map.get("BILL_CUSTOM"));		// 계산서거래처코드
				row.createCell(62).setCellValue((String)map.get("BILL_CUSTOM_NAME"));   // 계산서거래처
				row.createCell(63).setCellValue((String)map.get("DEPT_CODE"));		  // 관련부서
				row.createCell(64).setCellValue((String)map.get("DEPT_NAME"));		  // 관련부서명
				row.createCell(65).setCellValue((String)map.get("BILL_PUBLISH_TYPE"));  // 전자세금계산서발행유형

				row.getCell(0).setCellStyle(style00);
				row.getCell(1).setCellStyle(style00);
				row.getCell(2).setCellStyle(style00);
				row.getCell(3).setCellStyle(style00);
				row.getCell(4).setCellStyle(style00);
				row.getCell(5).setCellStyle(style00);
				row.getCell(6).setCellStyle(style00);
				row.getCell(7).setCellStyle(style00);
				row.getCell(8).setCellStyle(style00);
				row.getCell(9).setCellStyle(style00);
				row.getCell(10).setCellStyle(style00);
				row.getCell(11).setCellStyle(style00);
				row.getCell(12).setCellStyle(style00);
				row.getCell(13).setCellStyle(style00);
				row.getCell(14).setCellStyle(style00);
				row.getCell(15).setCellStyle(style00);
				row.getCell(16).setCellStyle(style00);
				row.getCell(17).setCellStyle(style00);
				row.getCell(18).setCellStyle(style00);
				row.getCell(19).setCellStyle(style00);
				row.getCell(20).setCellStyle(style00);
				row.getCell(21).setCellStyle(style00);
				row.getCell(22).setCellStyle(style00);
				row.getCell(23).setCellStyle(style00);
				row.getCell(24).setCellStyle(style00);
				row.getCell(25).setCellStyle(style00);
				row.getCell(26).setCellStyle(style00);
				row.getCell(27).setCellStyle(style00);
				row.getCell(28).setCellStyle(style00);
				row.getCell(29).setCellStyle(style00);
				row.getCell(30).setCellStyle(style00);
				row.getCell(31).setCellStyle(style00);
				row.getCell(32).setCellStyle(style00);
				row.getCell(33).setCellStyle(style03);   // 숫자
				row.getCell(34).setCellStyle(style00);
				row.getCell(35).setCellStyle(style00);
				row.getCell(36).setCellStyle(style00);
				row.getCell(37).setCellStyle(style03);   // 숫자
				row.getCell(38).setCellStyle(style03);   // 숫자
				row.getCell(39).setCellStyle(style00);
				row.getCell(40).setCellStyle(style00);
				row.getCell(41).setCellStyle(style00);
				row.getCell(42).setCellStyle(style00);
				row.getCell(43).setCellStyle(style00);
				row.getCell(44).setCellStyle(style00);
				row.getCell(45).setCellStyle(style00);
				row.getCell(46).setCellStyle(style00);
				row.getCell(47).setCellStyle(style00);
				row.getCell(48).setCellStyle(style00);
				row.getCell(49).setCellStyle(style00);
				row.getCell(50).setCellStyle(style00);
				row.getCell(51).setCellStyle(style00);
				row.getCell(52).setCellStyle(style00);
				row.getCell(53).setCellStyle(style00);
				row.getCell(54).setCellStyle(style00);
				row.getCell(55).setCellStyle(style00);
				row.getCell(56).setCellStyle(style00);
				row.getCell(57).setCellStyle(style00);
				row.getCell(58).setCellStyle(style00);
				row.getCell(59).setCellStyle(style00);
				row.getCell(60).setCellStyle(style00);
				row.getCell(61).setCellStyle(style00);
				row.getCell(62).setCellStyle(style00);
				row.getCell(63).setCellStyle(style00);
				row.getCell(64).setCellStyle(style00);
				row.getCell(65).setCellStyle(style00);

			}
		}

		return ViewHelper.getExcelDownloadView(workbook, excelFileName);
	}


	/**
	 * 거래처정보등록(통합)
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bcm106ukrv.do")
	public String bcm106ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo	= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo	= null;

		cdo					= codeInfo.getCodeInfo("B244", "10");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsHiddenField", cdo.getRefCode1());

		//거래처코드 자동채번 구분이 'Y'인 데이터의 REFCODE2 SELECT (자동채번일 경우 채번 SP)
		List<CodeDetailVO> gsAutoCustomCodeYN = codeInfo.getCodeList("B243", "", false);
		for (CodeDetailVO map : gsAutoCustomCodeYN) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("GetAutoCustomCodeYN", map.getCodeNo());			//자동(10)/수동채번(20)
				model.addAttribute("GetAutoCustomCodeSP", map.getRefCode2());		//자동채번일 경우, 호출 SP
			}
		}

	   	 cdo = codeInfo.getCodeInfo("B257", "1");	//추가항목 필드셋
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsAutoCustomCode", "./customCode_" + cdo.getCodeName().toUpperCase() + ".jsp");
			 }else{
			 	model.addAttribute("gsAutoCustomCode", "./customCode_STANDARD.jsp");
			 }
		 }else {
				model.addAttribute("gsAutoCustomCode", "./customCode_STANDARD.jsp");
		 }
		cdo = codeInfo.getCodeInfo("S028", "1");		//20210514 추가: 부가세 가져오는 로직 추가
		if(ObjUtils.isNotEmpty(cdo) && ObjUtils.isNotEmpty(cdo.getRefCode1())){
			model.addAttribute("gsVatRate", cdo.getRefCode1());
		} else {
			model.addAttribute("gsVatRate", "10");
		}

		return JSP_PATH + "bcm106ukrv";
	}

	@RequestMapping( value = "/base/bcm110ukrv.do", method = RequestMethod.GET )
	public String bcm110ukrv() throws Exception {
		return JSP_PATH + "bcm110ukrv";
	}

	@RequestMapping( value = "/base/bcm130skrv.do", method = RequestMethod.GET )
	public String bcm130skrv( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "bcm130skrv";
	}

	@RequestMapping( value = "/base/bcm300ukrv.do", method = RequestMethod.GET )
	public String bcm300ukrv() throws Exception {
		return JSP_PATH + "bcm300ukrv";
	}

	@RequestMapping( value = "/base/bcm500ukrv.do", method = RequestMethod.GET )
	public String bcm500ukrv() throws Exception {
		return JSP_PATH + "bcm500ukrv";
	}

	@RequestMapping( value = "/base/bcm200ukrv.do", method = RequestMethod.GET )
	public String bcm200ukrv() throws Exception {
		return JSP_PATH + "bcm200ukrv";
	}

	@RequestMapping( value = "/base/bcm400ukrv.do", method = RequestMethod.GET )
	public String bcm400ukrv() throws Exception {
		return JSP_PATH + "bcm400ukrv";
	}

	@RequestMapping( value = "/base/bcm101ukrv.do", method = RequestMethod.GET )
	public String bcm101ukrv() throws Exception {
		return JSP_PATH + "bcm101ukrv";
	}

	@RequestMapping( value = "/base/bcm120ukrv.do", method = RequestMethod.GET )
	public String bcm120ukrv( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "D");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsCellCodeYN", cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
		 }else {
				model.addAttribute("gsSiteCode", "STANDARD");
		 }

		return JSP_PATH + "bcm120ukrv";
	}

	@RequestMapping( value = "/base/bcm150ukrv.do", method = RequestMethod.GET )
	public String bcm150ukrv( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "D");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsCellCodeYN", cdo.getRefCode1());

		return JSP_PATH + "bcm150ukrv";
	}

	@RequestMapping( value = "/base/bcm600ukrv.do", method = RequestMethod.GET )
	public String bcm600ukrv() throws Exception {
		return JSP_PATH + "bcm600ukrv";
	}

	@RequestMapping( value = "/base/bcm620ukrv.do", method = RequestMethod.GET )
	public String bcm620ukrv() throws Exception {
		return JSP_PATH + "bcm620ukrv";
	}

	@RequestMapping( value = "/base/bcm621ukrv.do", method = RequestMethod.GET )
	public String bcm621ukrv() throws Exception {
		return JSP_PATH + "bcm621ukrv";
	}

	@RequestMapping( value = "/base/bcm610ukrv.do", method = RequestMethod.GET )
	public String bcm610ukrv( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		return JSP_PATH + "bcm610ukrv";
	}

	@RequestMapping( value = "/base/bcm700ukrv.do", method = RequestMethod.GET )
	public String bcm700ukrv() throws Exception {
		return JSP_PATH + "bcm700ukrv";
	}

	/* 외상카드 등록 */
	@RequestMapping( value = "/base/bcm800ukrv.do", method = RequestMethod.GET )
	public String bcm800ukrv() throws Exception {
		return JSP_PATH + "bcm800ukrv";
	}

	/* 단말기관리 */
	@RequestMapping( value = "/base/bcm900ukrv.do", method = RequestMethod.GET )
	public String bcm900ukrv() throws Exception {
		return JSP_PATH + "bcm900ukrv";
	}

	@RequestMapping( value = "/base/bcm190ukrv.do", method = RequestMethod.GET )
	public String bcm190ukrv( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		return JSP_PATH + "bcm190ukrv";
	}
}