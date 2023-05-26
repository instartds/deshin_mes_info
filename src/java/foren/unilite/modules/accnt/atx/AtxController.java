package foren.unilite.modules.accnt.atx;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

/**
 * 프로그램명 : 작업지시조정 작 성 자 : (주)포렌 개발실
 */
@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class AtxController extends UniliteCommonController {

	private final Logger logger			= LoggerFactory.getLogger(this.getClass());
	final static String JSP_PATH		= "/accnt/atx/";
	private static final LoginVO LoginVO= null;

	@Resource( name = "accntCommonService" )
	private AccntCommonServiceImpl accntCommonService;

	@Resource( name = "UniliteComboServiceImpl" )
	private ComboServiceImpl comboService;

	@Resource( name = "atx100ukrService" )
	private Atx100ukrServiceImpl atx100ukrService;

	@Resource( name = "atx110skrService" )
	private Atx110skrServiceImpl atx110skrService;

	@Resource( name = "atx110ukrService" )
	private Atx110ukrServiceImpl atx110ukrService;

	@Resource( name = "atx170ukrService" )
	private Atx170ukrServiceImpl atx170ukrService;

	@Resource( name = "atx200ukrService" )
	private Atx200ukrServiceImpl atx200ukrService;

	@Resource( name = "atx300ukrService" )
	private Atx300ukrServiceImpl atx300ukrService;

	@Resource( name = "atx305ukrService" )
	private Atx305ukrServiceImpl atx305ukrService;

	@Resource( name = "atx360ukrService" )
	private Atx360ukrServiceImpl atx360ukrService;

	@Resource( name = "atx490ukrService" )
	private Atx490ukrServiceImpl atx490ukrService;

	@Resource( name = "atx326ukrService" )
	private Atx326ukrServiceImpl atx326ukrService;

	/**
	 * 고정자산대장조회
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx110skr.do" )
	public String atx110skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("PGM_ID", "atx110skr");
		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param); // 프로그램별 사용 컬럼 관련
		model.addAttribute("useColList", ObjUtils.toJsonStr(useColList));
		
		List<Map<String, Object>> linkId = atx110skrService.getLinkID(param); // 링크
																			 // 이동프로그램ID관련
		model.addAttribute("linkId", ObjUtils.toJsonStr(linkId));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("A165", "70");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("useLinkYn", cdo.getRefCode1()); // 링크 사용 유무 관련
		
		List<CodeDetailVO> sortNumber = codeInfo.getCodeList("A166", "", false); // sort순서
																				// 관련
		for (CodeDetailVO map : sortNumber) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("sortNumber", map.getCodeNo());
			}
		}
		List<CodeDetailVO> moneyUnit = codeInfo.getCodeList("B004", "", false); // MONEY_UNIT관련
		for (CodeDetailVO map : moneyUnit) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("moneyUnit", map.getCodeNo());
			}
		}
		return JSP_PATH + "atx110skr";
	}
	
	@RequestMapping( value = "/accnt/atx110rkr.do" )
	public String atx110rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("PGM_ID", "atx110skr");
		param.put("SHEET_ID", "grdSheet1");
		
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param); // 프로그램별 사용 컬럼 관련
		model.addAttribute("useColList", ObjUtils.toJsonStr(useColList));
		
		List<Map<String, Object>> linkId = atx110skrService.getLinkID(param); // 링크
																			 // 이동프로그램ID관련
		model.addAttribute("linkId", ObjUtils.toJsonStr(linkId));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("A165", "70");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("useLinkYn", cdo.getRefCode1()); // 링크 사용 유무 관련
		
		List<CodeDetailVO> sortNumber = codeInfo.getCodeList("A166", "", false); // sort순서
																				// 관련
		for (CodeDetailVO map : sortNumber) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("sortNumber", map.getCodeNo());
			}
		}
		List<CodeDetailVO> moneyUnit = codeInfo.getCodeList("B004", "", false); // MONEY_UNIT관련
		for (CodeDetailVO map : moneyUnit) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("moneyUnit", map.getCodeNo());
			}
		}
		return JSP_PATH + "atx110rkr";
	}

	/**
	 * 세금계산서발행현황조회(atx115skr)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx115skr.do" )
	public String atx115skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param); // 프로그램별 사용 컬럼 관련
		model.addAttribute("useColList", ObjUtils.toJsonStr(useColList));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "atx115skr";
	}

	/**
	 * 합계표
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx120skr.do" )
	public String atx120skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("PGM_ID", "atx120skr");
		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param); // 프로그램별 사용 컬럼 관련
		model.addAttribute("useColList", ObjUtils.toJsonStr(useColList));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "atx120skr";
	}

	/**
	 * 세금계산서합계표 (atx130skr)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx130skr.do" )
	public String atx130skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");

		//20200728 추가: clip report 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("atx130skr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "atx130skr";
	}

	/**
	 * 계산서합계표 (atx140skr)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx140skr.do" )
	public String atx140skr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");

		//20200728 추가: clip report 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("atx140skr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "atx140skr";
	}

	@RequestMapping( value = "/accnt/atx150skr.do" )
	public String atx150skr() throws Exception {
		return JSP_PATH + "atx150skr";
	}

	@RequestMapping( value = "/accnt/atx210skr.do" )
	public String atx210skr() throws Exception {
		return JSP_PATH + "atx210skr";
	}

	/**
	 * 세금계산서등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx100ukr.do", method = RequestMethod.GET )
	public String atx100ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("PGM_ID", "atx100ukr");
		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param); // 프로그램별 사용 컬럼 관련
		model.addAttribute("useColList", ObjUtils.toJsonStr(useColList));
		
		List<Map<String, Object>> linkId = atx100ukrService.getLinkID(param); // 링크
																			 // 이동프로그램ID관련
		model.addAttribute("linkId", ObjUtils.toJsonStr(linkId));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("A165", "70");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("useLinkYn", cdo.getRefCode1()); // 링크 사용 유무 관련
		
		List<CodeDetailVO> sortNumber = codeInfo.getCodeList("A166", "", false); // sort순서
																				// 관련
		for (CodeDetailVO map : sortNumber) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("sortNumber", map.getCodeNo());
			}
		}
		List<CodeDetailVO> moneyUnit = codeInfo.getCodeList("B004", "", false); // MONEY_UNIT관련
		for (CodeDetailVO map : moneyUnit) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("moneyUnit", map.getCodeNo());
			}
		}
		List<ComboItemModel> reasonGb = comboService.getComboList("AU", "A070",  loginVO, null, null, false); // 매입세액불공제사유 
		List<ComboItemModel> reasonGbList = new ArrayList<ComboItemModel>();
		for (ComboItemModel map : reasonGb) {
			if (!"N".equals(map.getRefCode3())) {
				reasonGbList.add(map);
			}
		}
		model.addAttribute("reasonGbList", reasonGbList);
		return JSP_PATH + "atx100ukr";
	}

	/**
	 * 휴폐업조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx101ukr.do", method = RequestMethod.GET )
	public String atx101ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "atx101ukr";
	}

	@RequestMapping( value = "/accnt/atx110ukr.do", method = RequestMethod.GET )
	public String atx110ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//사업장 전체 콤보 가져오기
		model.addAttribute("DIV_CODE_USE", atx110ukrService.getDivCode(param));				 //카드번호콤보
		
		//매출사업장 콤보 가져오기
		model.addAttribute("SALE_DIV_CODE", atx110ukrService.getSaleDivCode(param));				 //카드번호콤보
		
		// 자국화폐단위 정보 확인
		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for (CodeDetailVO map : gsMoneyUnit) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if (i == 0) model.addAttribute("gsMoneyUnit", "KRW");
		
		// 영업담당 가져오기
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if (!ObjUtils.isEmpty(salePrsn)) model.addAttribute("salePrsn", ObjUtils.toJsonStr(salePrsn));
		
		// 세금계산서 영업담당 필수입력여부
		cdo = codeInfo.getCodeInfo("S028", "1");
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsVatRate", cdo.getRefCode1());
		}
		
		// 전자세금계산서 사용 여부 확인
		i = 0;
		List<CodeDetailVO> gsBillYn = codeInfo.getCodeList("S084", "", false);
		for (CodeDetailVO map : gsBillYn) {
			if ("Y".equals(map.getRefCode1())) {
				String billYn = "";
				if ("00".equals(map.getCodeNo())) {
					billYn = "Y";
					
				} else {
					billYn = "N";
				}
				model.addAttribute("gsBillYn", billYn);
				i++;
			}
		}
		if (i == 0) model.addAttribute("gsBillYn", "");
		
		// 전자세금계산서 종류 확인
		List<CodeDetailVO> gsBillConnect = codeInfo.getCodeList("S084", "", false);
		for (CodeDetailVO map : gsBillConnect) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBillConnect", map.getCodeNo());
				model.addAttribute("gsBillDbUser", map.getRefCode10());
				i++;
			}
		}
		
		// 거래유형(매출) 리스트
		List<CodeDetailVO> gsListA012 = codeInfo.getCodeList("A012", "", false);
		Object list1 = "";
		for (CodeDetailVO map : gsListA012) {
			if ("2".equals(map.getRefCode1())) {
				if (list1.equals("")) {
					list1 = map.getCodeNo();
					
				} else {
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsListA012", list1);
		
		// 증빙유형 (세금계산서등록용 : REF_CODE7 = 'Y', 20161203 수정)
		List<CodeDetailVO> gsListA022 = codeInfo.getCodeList("A022", "", false);
		Object list2 = "";
		for (CodeDetailVO map : gsListA022) {
			if ("Y".equals(map.getRefCode7())) {
				if (list2.equals("")) {
					list2 = map.getCodeNo();
				} else {
					list2 = list2 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsListA022", list2);
		/*
		 * //자동채번여부(수금번호)정보 관련 로직은 회계에서는 사용하지 않음 cdo = codeInfo.getCodeInfo("S012", "6"); if(!ObjUtils.isEmpty(cdo)){ model.addAttribute("gsAutoType",cdo.getRefCode1()); }else { model.addAttribute("gsAutoType", "N"); } //수금예정일 관련 로직은 회계에서는 사용하지 않음 (true : 사용안함도 가져옴 false: 사용함만 가져옴) i = 0; List<CodeDetailVO> gsCollectDayFlg = codeInfo.getCodeList("B071", "", false); for(CodeDetailVO map : gsCollectDayFlg) { if(map.isInUse()){ model.addAttribute("gsCollectDayFlg", map.getCodeNo()); i++; } } if(i == 0) model.addAttribute("gsCollectDayFlg", "1"); //자거래처 참조 관련 로직은 회계에서는 사용하지 않음 cdo = codeInfo.getCodeInfo("S110", "01"); if(!ObjUtils.isEmpty(cdo)){ model.addAttribute("gsCustomGubun",cdo.getRefCode1()); }else { model.addAttribute("gsCustomGubun", "N"); } //프로젝트코드 관련 로직은 회계에서는 사용하지 않음 cdo = codeInfo.getCodeInfo("B078", "10"); if(!ObjUtils.isEmpty(cdo)){ model.addAttribute("gsPjtCodeYN",cdo.getRefCode1()); }else { model.addAttribute("gsPjtCodeYN", "N"); } cdo = codeInfo.getCodeInfo("S000",
		 * "03"); if(!ObjUtils.isEmpty(cdo)){ model.addAttribute("gsBillPrsnEssYN",cdo.getRefCode1()); }else { model.addAttribute("gsBillPrsnEssYN", "N"); }
		 */
		
		return JSP_PATH + "atx110ukr";
	}

	@RequestMapping( value = "/accnt/atx200ukr.do" )
	public String atx200ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx200ukr";
	}

	/**
	 * 세금계산서 엑셀 업로드
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx111ukr.do", method = RequestMethod.GET )
	public String atx111ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("PGM_ID", "atx111ukr");
		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> useColList = accntCommonService.getUseColList(param); // 프로그램별 사용 컬럼 관련
		model.addAttribute("useColList", ObjUtils.toJsonStr(useColList));
		
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		// List<Map<String, Object>> linkId = atx111ukrService.getLinkID(param);
		// //링크 이동프로그램ID관련
		// model.addAttribute("linkId",ObjUtils.toJsonStr(linkId));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("A165", "70");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("useLinkYn", cdo.getRefCode1()); // 링크 사용 유무 관련
		
		List<CodeDetailVO> sortNumber = codeInfo.getCodeList("A166", "", false); // sort순서
																				// 관련
		for (CodeDetailVO map : sortNumber) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("sortNumber", map.getCodeNo());
			}
		}
		List<CodeDetailVO> moneyUnit = codeInfo.getCodeList("B004", "", false); // MONEY_UNIT관련
		for (CodeDetailVO map : moneyUnit) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("moneyUnit", map.getCodeNo());
			}
		}
		return JSP_PATH + "atx111ukr";
	}

	/**
	 * 전산매체작성(atx200ukr) 파일 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	// @RequestMapping(value="/base/printBarcode", method = RequestMethod.POST)
	// public ModelAndView fileDown( ExtHtttprequestParam _req) throws Exception
	// {
	//
	// //Map pData = _req.getParameterMap();
	//
	// // List<Map> paramList = mapper.readValue(
	// ObjUtils.getSafeString((_req.getP("data"))),
	// // TypeFactory.defaultInstance().constructCollectionType(List.class,
	// Map.class));
	//
	// ObjectMapper mapper = new ObjectMapper();
	// Map<String, Object> param = mapper.readValue(
	// ObjUtils.getSafeString((_req.getP("data"))),
	// TypeFactory.defaultInstance().constructCollectionType(List.class,
	// Map.class));
	//
	// File dir = new File(ConfigUtil.getUploadBasePath("omegapluslabel"));
	// if(!dir.exists()) dir.mkdir();
	// FileDownloadInfo fInfo = new
	// FileDownloadInfo(ConfigUtil.getUploadBasePath("omegapluslabel"),
	// "omegapluslabel.txt");
	//
	// FileOutputStream fos = new FileOutputStream(fInfo.getFile());
	// String data = "";
	// for(Map param: paramList) {
	//
	// if(param.get("PRINT_P_YN").toString().equals("true")){//단가 출력여부..
	// data += param.get("ITEM_CODE") + "|" + param.get("ITEM_NAME") + "|" +
	// param.get("SALE_BASIS_P") + "|" + param.get("PRINT_Q") + "\r\n";
	// }else{
	// data += param.get("ITEM_CODE") + "|" + param.get("ITEM_NAME") + "||" +
	// param.get("PRINT_Q") + "\r\n";
	// }
	//
	// }
	// byte[] bytesArray = data.getBytes();
	// fos.write(bytesArray);
	//
	// fos.flush();
	// fos.close();
	// fInfo.setStream(fos);
	//
	// return ViewHelper.getFileDownloadView(fInfo);
	//
	// }
	// 전산매체작성(atx200ukr) 파일 저장
	@RequestMapping( value = "/accnt/fileDown", method = RequestMethod.POST )
	public ModelAndView fileDown( Atx200ukrModel dataMaster, LoginVO user ) throws Exception {
		
		// ObjectMapper mapper = new ObjectMapper();
		// Map<String, Object> param = mapper.readValue(
		// ObjUtils.getSafeString((_req.getP("data"))),
		// TypeFactory.defaultInstance().constructCollectionType(List.class,
		// Map.class));
		//
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("BILL_DIV_CODE", dataMaster.getBILL_DIV_CODE());
		spParam.put("PUB_DATE_FR", dataMaster.getPUB_DATE_FR());
		spParam.put("PUB_DATE_TO", dataMaster.getPUB_DATE_TO());
		spParam.put("WRITE_DATE", dataMaster.getWRITE_DATE());
		spParam.put("FILE_GUBUN", dataMaster.getFILE_GUBUN());
		spParam.put("COMP_CODE", user.getCompCode());
		
		Map<String, Object> spResult = atx200ukrService.fnGetFileText(spParam, user);
		// Map result = (Map)
		// super.commonDao.select("atx200ukrServiceImpl.sp_getFileText", param);
		String returnText = (String)spResult.get("RETURN_TEXT");
		String fileName = (String)spResult.get("COMPANY_NUM");
		// String errorDesc = (String) spResult.get("ERROR_DESC");
		// System.out.print(returnText);
		// if(!ObjUtils.isEmpty(errorDesc)){
		// throw new UniDirectValidateException(errorDesc);
		// }
		fileName = "K" + fileName.substring(0, 7) + "." + fileName.substring(7, 10);
		File dir = new File(ConfigUtil.getUploadBasePath("omegaplusAccntFile")); // 디렉토리
																				// create
		if (!dir.exists()) dir.mkdir(); // 디렉토리 없을시 디렉토리 생성
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegaplusAccntFile"), fileName); // 파일명
																													// 및
																													// 파일이
																													// 생길
																													// 경로
																													// 지정..
		
		FileOutputStream fos = new FileOutputStream(fInfo.getFile()); // txt파일을
																	 // 경로에
																	 // 생성..
		String data = returnText;
		
		byte[] bytesArray = data.getBytes();
		fos.write(bytesArray);
		
		fos.flush();
		fos.close();
		fInfo.setStream(fos);
		
		return ViewHelper.getFileDownloadView(fInfo);
		
		// if(errorDesc != null){
		// throw new Exception(errorDesc);
		// }
	}

	// 부가세전자신고 파일생성
	@RequestMapping( value = "/accnt/fileDown2.do", method = RequestMethod.POST )
	public ModelAndView fileDown2( ExtHtttprequestParam _req, LoginVO user ) throws Exception {
		_req.getParameterMap();
		Map<String, Object> spParam = _req.getParameterMap();
		spParam.put("COMP_CODE", user.getCompCode());
		
		AES256DecryptoUtils decrypto = new AES256DecryptoUtils(); // 계좌번호 암호 복호화
		List<String> divList = new ArrayList(); // 작업대상 사업장
		
		List<Map<String, Object>> paramDivList = null;
		//if (!ObjUtils.isEmpty(spParam.get("DIV_CODE"))) {
			String[] paramDivArry = ( (String)spParam.get("BILL_DIV_CODE") ).split(",");
			for (String divCode : paramDivArry) {
				divList.add(divCode);
			}
/*		} else {
			paramDivList = (List<Map<String, Object>>)atx305ukrService.getDivList(spParam);
			for (Map divCode : paramDivList) {
				divList.add((String)divCode.get("DIV_CODE"));
			}
		}*/
		Map<String, Object> spResult = null;
		String returnText = "";
		// String errorDesc = "";
		int divCnt = 0;
		for (String divCd : divList) {
			spParam.put("DIV_CODE", divCd);
			spParam.put("DIV_COUNT", divCnt);
			divCnt++;
			Map<String, Object> bankAccnt = new HashMap();
			bankAccnt = (Map<String, Object>)atx305ukrService.getBankAccnt(spParam); // 암호화된 계좌 가져오기
			String decriptBkAccnt = decrypto.getDecrypto("1", "myDNdKQquyYJ1p7I62FtHQ==");  // 000556018008571
			if (ObjUtils.isEmpty(decriptBkAccnt)) {
				spParam.put("BANK_ACCOUNT", "");
			} else {
				spParam.put("BANK_ACCOUNT", decriptBkAccnt);
			}
			spResult = atx305ukrService.fnGetFileText(spParam, user);
			if(spResult != null)	{
				if(!ObjUtils.isEmpty(spResult.get("ERROR_DESC")))	{
					logger.info(" spResult.get(ERROR_DESC) : "+spResult.get("ERROR_DESC"));
					throw new Exception(ObjUtils.getSafeString(spResult.get("ERROR_DESC")));
				}
				if(spResult.get("RETURN_TEXT") != null)	{
					returnText = returnText + spResult.get("RETURN_TEXT").toString();//ObjUtils.getSafeString method에서 trim 되므로 사용할 수 없음
				}
				if(ObjUtils.isEmpty(returnText))	{
					logger.info(" returnText is null : 부가세 처리할 대상이 없습니다.");
					throw new Exception("부가세 처리할 대상이 없습니다.");
				}
			}else {
				logger.info(" spResult is null : 부가세 처리할 대상이 없습니다.");
				throw new Exception("부가세 처리할 대상이 없습니다.");
			}
		}
		String fileName = spParam.get("WRITE_DATE") + ".101";
		String path = ConfigUtil.getUploadBasePath("omegaplusAccntFile");
		File dir = new File(path);
		if(!dir.exists()) {
			dir.mkdir(); 
		}
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegaplusAccntFile"), fileName); // 파일명 및 파일이 생길 경로지정..
		FileOutputStream fos = new FileOutputStream(fInfo.getFile()); // txt파일을 경로에 생성..
		
		String[] sdata = returnText.split("\r");
		
		for (int i = 0; i < sdata.length; i++) {
			fos.write(sdata[i].getBytes("euckr"));	//국세청 자료 신고용 ansi용 파일 저장..
			fos.write("\r\n".getBytes());
		}
		fos.close();
		
		/*
		 * byte[] bytesArray = data.getBytes(); fos.write(bytesArray); OutputStreamWriter. fos.flush(); fos.close(); fInfo.setStream(fos);
		 */
		return ViewHelper.getFileDownloadView(fInfo);
		
	}

	@RequestMapping( value = "/accnt/atx205ukr.do" )
	public String atx205ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx205ukr";
	}

	/**
	 * 부가세신고서
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx300ukr.do", method = RequestMethod.GET )
	public String atx300ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);

		Map<String, Object> param = navigator.getParam();
		LoginVO session = _req.getSession();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		// param setting
		Map paramA = new HashMap();
		paramA.put("S_COMP_CODE", loginVO.getCompCode());
		paramA.put("S_USER_ID", loginVO.getUserID());
		
		// 신고사업장 총괄 관련 조회
		Map taxBaseMap = (Map)accntCommonService.getTaxBase(paramA);
		
		model.addAttribute("getTaxBase", taxBaseMap.get("TAX_BASE"));
		model.addAttribute("getBillDivCode", taxBaseMap.get("BILL_DIV_CODE"));
		
		return JSP_PATH + "atx300ukr";
	}
	
	/**
	 * 부가세신고서
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx301ukr.do", method = RequestMethod.GET )
	public String atx301ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);

		Map<String, Object> param = navigator.getParam();
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		// param setting
		Map paramA = new HashMap();
		paramA.put("S_COMP_CODE", loginVO.getCompCode());
		paramA.put("S_USER_ID", loginVO.getUserID());
		
		// 신고사업장 총괄 관련 조회
		Map taxBaseMap = (Map)accntCommonService.getTaxBase(paramA);
		
		model.addAttribute("getTaxBase", taxBaseMap.get("TAX_BASE"));
		model.addAttribute("getBillDivCode", taxBaseMap.get("BILL_DIV_CODE"));
		
		return JSP_PATH + "atx301ukr";
	}

	/**
	 * 부가세전자신고
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx305ukr.do", method = RequestMethod.GET )
	public String atx305ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		Map paramA = new HashMap();
		paramA.put("S_COMP_CODE", loginVO.getCompCode());
		paramA.put("S_USER_ID", loginVO.getUserID());		
		Map taxBaseMap = (Map)accntCommonService.getTaxBase(paramA);
		model.addAttribute("getTaxBase", taxBaseMap.get("TAX_BASE"));
		model.addAttribute("getBillDivCode", taxBaseMap.get("BILL_DIV_CODE"));		
		
		model.addAttribute("BILL_DIV_CODE", atx305ukrService.getBillDivList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "atx305ukr";
	}

	@RequestMapping( value = "/accnt/atx315ukr.do", method = RequestMethod.GET )
	public String atx315ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "atx315ukr";
	}

	@RequestMapping( value = "/accnt/atx326ukr.do", method = RequestMethod.GET )
	public String atx326ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//
		// cdo = codeInfo.getCodeInfo("A022", "55");
		// if(!ObjUtils.isEmpty(cdo))
		// model.addAttribute("gsTaxRate",cdo.getRefCode2()); //부가세율 관련
		
		return JSP_PATH + "atx326ukr";
	}

	/**
	 * 영세율첨부서류제출명세서
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx330ukr.do", method = RequestMethod.GET )
	public String atx330ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "atx330ukr";
	}

	@RequestMapping( value = "/accnt/atx355ukr.do" )
	public String atx355ukr() throws Exception {
		return JSP_PATH + "atx355ukr";
	}

	@RequestMapping( value = "/accnt/atx340ukr.do" )
	public String atx340ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx340ukr";
	}

	@RequestMapping( value = "/accnt/atx360ukr.do" )
	public String atx360ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getTaxBase = atx360ukrService.fnGetTaxBase(param); // 대손세액공제율
		model.addAttribute("getTaxBase", ObjUtils.toJsonStr(getTaxBase));
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx360ukr";
	}

	@RequestMapping( value = "/accnt/atx412ukr.do" )
	public String atx412ukr() throws Exception {
		return JSP_PATH + "atx412ukr";
	}

	@RequestMapping( value = "/accnt/atx400ukr.do" )
	public String atx400ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx400ukr";
	}

	@RequestMapping( value = "/accnt/atx410ukr.do" )
	public String atx410ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx410ukr";
	}

	@RequestMapping( value = "/accnt/atx425ukr.do", method = RequestMethod.GET )
	public String atx425ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("A022", "55");
		if (!ObjUtils.isEmpty(cdo)) model.addAttribute("gsTaxRate", cdo.getRefCode2()); // 부가세율 관련
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		// 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport) -- 20210726 추가
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);
		for(CodeDetailVO map : gsReportGubun) {
			if("atx425ukr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		return JSP_PATH + "atx425ukr";
	}

	@RequestMapping( value = "/accnt/atx480ukr.do", method = RequestMethod.GET )
	public String atx480ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx480ukr";
	}

	@RequestMapping( value = "/accnt/atx500ukr.do" )
	public String atx500ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx500ukr";
	}

	@RequestMapping( value = "/accnt/atx510ukr.do" )
	public String atx510ukr() throws Exception {
		return JSP_PATH + "atx510ukr";
	}

	@RequestMapping( value = "/accnt/atx520ukr.do", method = RequestMethod.GET )
	public String atx520ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx520ukr";
	}

	@RequestMapping( value = "/accnt/atx530ukr.do" )
	public String atx530ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx530ukr";
	}

	@RequestMapping( value = "/accnt/atx540ukr.do" )
	public String atx540ukr() throws Exception {
		return JSP_PATH + "atx540ukr";
	}
	
	@RequestMapping( value = "/accnt/atx450ukr.do" )
	public String atx450ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		//20200727 추가: clip report 추가
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);
		for(CodeDetailVO map : gsReportGubun) {
			if("atx450ukr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		return JSP_PATH + "atx450ukr";
	}

	@RequestMapping( value = "/accnt/atx460ukr.do", method = RequestMethod.GET )
	public String atx460ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Map paramA = new HashMap();
		paramA.put("S_COMP_CODE", loginVO.getCompCode());
		Map licenseeInformMap = (Map)accntCommonService.getLicenseeInform(paramA);
		model.addAttribute("getTaxBase", licenseeInformMap.get("TAX_BASE"));
		model.addAttribute("getAppNum", licenseeInformMap.get("APP_NUM"));
		model.addAttribute("getCompanyNum", licenseeInformMap.get("COMPANY_NUM"));
		
		
		// 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport) -- 20210726 추가
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);
		for(CodeDetailVO map : gsReportGubun) {
			if("atx460ukr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		return JSP_PATH + "atx460ukr";
	}

	/**
	 * 사업장별 부가가치세 과세표준 및 납부세액(환급세액) 신고명세서 (atx470ukr) - 20200624 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx470ukr.do", method = RequestMethod.GET )
	public String atx470ukr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields	= {};
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session				= _req.getSession();
		String page					= _req.getP("page");
		Map<String, Object> param	= navigator.getParam();

		param.put("S_COMP_CODE", loginVO.getCompCode());

		Map licenseeInformMap = (Map)accntCommonService.getLicenseeInform(param);
		model.addAttribute("getTaxBase"		, licenseeInformMap.get("TAX_BASE"));
		model.addAttribute("getAppNum"		, licenseeInformMap.get("APP_NUM"));
		model.addAttribute("getCompanyNum"	, licenseeInformMap.get("COMPANY_NUM"));

		return JSP_PATH + "atx470ukr";
	}

	/**
	 * 국세청신고자료대사
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx490ukr.do" )
	public String atx490ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Map selectCheck1Map = (Map)atx490ukrService.selectCheck1(param);
		if (selectCheck1Map == null) {
			model.addAttribute("sRefcode2", "11");
		} else {
			if (selectCheck1Map.get("SUB_CODE").equals("")) {
				model.addAttribute("sRefcode2", "11");
			} else {
				model.addAttribute("sRefcode2", selectCheck1Map.get("SUB_CODE"));
			}
		}
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx490ukr";
	}

	/**
	 * 수입집계표 (atx550ukr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx550ukr.do" )
	public String atx550ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		//신고사업장 정보 가져오기
		Map param1 = new HashMap();
		param1.put("DIV_CODE", loginVO.getDivCode());
		param1.put("S_COMP_CODE", loginVO.getCompCode());
		Map billDivMap = (Map)accntCommonService.fnGetBillDivCode(param1);
		model.addAttribute("gsBillDivCode", ObjUtils.isNotEmpty(billDivMap) ? billDivMap.get("BILL_DIV_CODE") : "");
		
		return JSP_PATH + "atx550ukr";
	}

	/**
	 * 전자세금계산서 발행 (ATX170UKR) - 조인스 회계용
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/atx170ukr.do" )
	public String atx170ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("A125", "3"); // (회계) 링크프로그램정보(개별세금계산서등록)
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsAtx110UkrLink", cdo.getRefCode3());
		} else {
			model.addAttribute("gsAtx110UkrLink", "atx110ukr");
		}
		
		List<Map<String, Object>> gsBillYN = atx170ukrService.getGsBillYN(param); // 연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		if (ObjUtils.isEmpty(gsBillYN)) {
			gsBillYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("SUB_CODE", "01"); // 01센드빌 02웹캐시
			map.put("REF_CODE4", "NAME"); // 품목표시컬럼설정
			map.put("REF_CODE5", "N"); // 품명수정여부
			map.put("REF_CODE6", "N"); // 출력여부
			map.put("REF_CODE7", ""); // 출력파일명
			map.put("REF_CODE8", "8"); // 페이지내 최대건수
			map.put("REF_CODE9", "N"); // 합계표시여부
			gsBillYN.add(map);
		}
		model.addAttribute("gsBillYN", ObjUtils.toJsonStr(gsBillYN));
		
		return JSP_PATH + "atx170ukr";
	}

	// 테스트
	@RequestMapping( value = "/accnt/atx999ukr.do", method = RequestMethod.GET )
	public String atx999ukr( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		cdo = codeInfo.getCodeInfo("S012", "6"); // 자동채번여부(수금번호)정보 조회
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsAutoType", cdo.getRefCode1());
		} else {
			model.addAttribute("gsAutoType", "N");
		}
		
		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false); // 자국화폐단위 정보
		for (CodeDetailVO map : gsMoneyUnit) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if (i == 0) model.addAttribute("gsMoneyUnit", "KRW");
		
		cdo = codeInfo.getCodeInfo("S036", "4"); // 링크프로그램정보(세금계산서출력) 조회
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsBusiPrintPgm", cdo.getCodeName());
		} else {
			model.addAttribute("gsBusiPrintPgm", "ssa560Rkrv");
		}
		
		cdo = codeInfo.getCodeInfo("S037", "7"); // 링크프로그램정보(자동기표등록) 조회
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsAutoreg", cdo.getCodeName());
		} else {
			model.addAttribute("gsAutoreg", "agj260Ukr");
		}
		
		i = 0; // true : 사용안함도 가져옴 false: 사용함만 가져옴
		List<CodeDetailVO> gsCollectDayFlg = codeInfo.getCodeList("B071", "", false); // 수금일설정정보 조회
		for (CodeDetailVO map : gsCollectDayFlg) {
			if (map.isInUse()) {
				model.addAttribute("gsCollectDayFlg", map.getCodeNo());
				i++;
			}
		}
		if (i == 0) model.addAttribute("gsCollectDayFlg", "1");
		
		cdo = codeInfo.getCodeInfo("S110", "01"); // 자거래처 참조 사용 유무
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsCustomGubun", cdo.getRefCode1());
		} else {
			model.addAttribute("gsCustomGubun", "N");
		}
		
		cdo = codeInfo.getCodeInfo("B078", "10"); // 프로젝트코드 사용유무
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsPjtCodeYN", cdo.getRefCode1());
		} else {
			model.addAttribute("gsPjtCodeYN", "N");
		}
		
		cdo = codeInfo.getCodeInfo("S000", "03"); // 세금계산서 영업담당 필수입력여부
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsBillPrsnEssYN", cdo.getRefCode1());
		} else {
			model.addAttribute("gsBillPrsnEssYN", "N");
		}
		
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010"); // 영업담당 가져오기
		if (!ObjUtils.isEmpty(salePrsn)) model.addAttribute("salePrsn", ObjUtils.toJsonStr(salePrsn));
		
		cdo = codeInfo.getCodeInfo("S028", "1"); // 세금계산서 영업담당 필수입력여부
		if (!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsVatRate", cdo.getRefCode1());
		}
		
		i = 0; // true : 사용안함도 가져옴 false: 사용함만 가져옴
		List<CodeDetailVO> gsBillYn = codeInfo.getCodeList("S084", "", false); // 수금일설정정보
																			  // 조회
		for (CodeDetailVO map : gsBillYn) {
			if ("Y".equals(map.getRefCode1())) {
				String billYn = "";
				if ("00".equals(map.getCodeNo())) {
					billYn = "Y";
				} else {
					billYn = "N";
				}
				model.addAttribute("gsBillYn", billYn);
				i++;
			}
		}
		if (i == 0) model.addAttribute("gsBillYn", "");
		
		List<CodeDetailVO> gsBillConnect = codeInfo.getCodeList("S084", "", false); // 센드빌인지 웹캐쉬 검색
		for (CodeDetailVO map : gsBillConnect) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBillConnect", map.getCodeNo());
				model.addAttribute("gsBillDbUser", map.getRefCode10());
				i++;
			}
		}
		List<CodeDetailVO> gsListA012 = codeInfo.getCodeList("A012", "", false);
		Object list1 = "";
		for (CodeDetailVO map : gsListA012) {
			if ("2".equals(map.getRefCode1())) {
				if (list1.equals("")) {
					list1 = map.getCodeNo();
				} else {
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsListA012", list1);
		List<CodeDetailVO> gsListA022 = codeInfo.getCodeList("A022", "", false);
		Object list2 = "";
		for (CodeDetailVO map : gsListA022) {
			if ("2".equals(map.getRefCode3())) {
				if (list2.equals("")) {
					list2 = map.getCodeNo();
				} else {
					list2 = list2 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsListA022", list2);
		return JSP_PATH + "atx999ukr";
	}

	/**
	 * 신용카드매출전표수령명세서 파일저장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/accnt/fileDown.do" )
	public ModelAndView fileDown( ExtHtttprequestParam _req, LoginVO user ) throws Exception {
		Map<String, Object> spParam = _req.getParameterMap();
		Map<String, Object> spResult = null;
		String returnText = "";
		String returnFileNm = "";
		
		spParam.put("COMP_CODE", user.getCompCode());
		spParam.put("USER_ID", user.getUserID());
		
		logger.info("spParam :: {}", spParam);
		
		// HPB100T테이블에서 암호화 대상 조회후  T_HPB100T테이블에 복호화된걸 insert함.. sp에서  T_HPB100T를 참조해 파일 생성함..
		spResult = atx326ukrService.fnGetFileText(spParam);
		
		returnText = (String)spResult.get("RETURN_TEXT");
		returnFileNm = (String)spResult.get("FILE_NAME");
		
		FileDownloadInfo fInfo = new FileDownloadInfo(ConfigUtil.getUploadBasePath("omegaplusAccntFile"), returnFileNm); // 파일명 및 파일이 생길 경로지정..
		FileOutputStream fos = new FileOutputStream(fInfo.getFile()); // txt파일을 경로에 생성..
		
		String data = returnText;
		logger.info("data :: \n" + data);
		String[] sdata = data.split("\r");
		logger.info("sdata.length " + sdata.length);
		for (int i = 0; i < sdata.length; i++) {
			fos.write(sdata[i].getBytes("euckr"));  //국세청 자료 신고용 ansi용 파일 저장..
			fos.write("\r\n".getBytes());
		}
		fos.close();
		
		// 복호화 했던 필드 초기화
		atx326ukrService.updateInit(spParam, user);
		
		return ViewHelper.getFileDownloadView(fInfo);
	}
}