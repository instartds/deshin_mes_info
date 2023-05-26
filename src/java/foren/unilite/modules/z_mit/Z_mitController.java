package foren.unilite.modules.z_mit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.accnt.agb.Agb200skrServiceImpl;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.cost.CostCommonServiceImpl;
import foren.unilite.modules.eis.em.Ems100skrvServiceImpl;
import foren.unilite.modules.human.hat.Hat500ukrServiceImpl;
import foren.unilite.modules.stock.biv.Biv300skrvServiceImpl;
import foren.unilite.modules.z_hs.S_Emp120skrv_hsServiceImpl;
import foren.unilite.modules.z_hs.S_emp100skr_hsServiceImpl;

@Controller
public class Z_mitController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/z_mit/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

	@Resource(name="s_pmr100ukrv_mitService")
	private S_pmr100ukrv_mitServiceImpl s_pmr100ukrv_mitService;

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;

	@Resource(name = "s_hpa900rkr_mitService")
	private S_Hpa900rkr_mitServiceImpl s_hpa900rkr_mitService;
	
	@Resource( name = "s_hat500ukr_mitService" )
	private S_Hat500ukr_mitServiceImpl	   s_hat500ukr_mitService;

	@Resource(name="s_biv300skrv_mitService")
	private S_Biv300skrv_mitServiceImpl s_biv300skrv_mitService;
	
	@Resource(name="costCommonService")
	private CostCommonServiceImpl costCommonService;
	
	@Resource(name="ems100skrvService")
	private Ems100skrvServiceImpl ems100skrvService;	

	@Resource(name="s_etv100skrv_mitService")
	private S_Etv100skrv_mitServiceImpl s_etv100skrv_mitService;	
	
	@Resource(name="s_etv110skrv_mitService")
	private S_Etv110skrv_mitServiceImpl s_etv110skrv_mitService;	
	
	@Resource(name="s_etv120skrv_mitService")
	private S_Etv120skrv_mitServiceImpl s_etv120skrv_mitService;

	@Resource(name="s_etv130skrv_mitService")
	private S_Etv130skrv_mitServiceImpl s_etv130skrv_mitService;	

	@Resource(name="s_etv140skrv_mitService")
	private S_Etv140skrv_mitServiceImpl s_etv140skrv_mitService;	

	@Resource(name="s_etv150skrv_mitService")
	private S_Etv150skrv_mitServiceImpl s_etv150skrv_mitService;	

	@Resource(name="s_biv305skrv_mitService")
	private S_biv305skrv_mitServiceImpl s_biv305skrv_mitService;
	
	@Resource(name="s_biv302skrv_mitService")
	private S_biv302skrv_mitServiceImpl s_biv302skrv_mitService;
	
	/**
	 * 스텐트/열처리 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_etv100skrv_mit.do" )
	public String s_etv100skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_etv100skrv_mit");

		String nextPgmId = s_etv100skrv_mitService.selectNextPgmId(param);
		Integer interval = s_etv100skrv_mitService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> contentsList = s_etv100skrv_mitService.selectContents(param);

		model.put("contentsList", JsonUtils.toJsonStr(contentsList));	
		
		Gson gson = new Gson();
        String colData = gson.toJson(s_etv100skrv_mitService.selectCaldate(loginVO.getCompCode()));
        model.addAttribute("colData", colData);		
		
		return JSP_PATH + "s_etv100skrv_mit";
	}
	
	/**
	 * 코팅 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_etv110skrv_mit.do" )
	public String s_etv110skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_etv110skrv_mit");

		String nextPgmId = s_etv110skrv_mitService.selectNextPgmId(param);
		Integer interval = s_etv110skrv_mitService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> contentsList = s_etv110skrv_mitService.selectContents(param);

		model.put("contentsList", JsonUtils.toJsonStr(contentsList));	
		
		Gson gson = new Gson();
        String colData = gson.toJson(s_etv110skrv_mitService.selectCaldate(loginVO.getCompCode()));
        model.addAttribute("colData", colData);		
		
		return JSP_PATH + "s_etv110skrv_mit";
	}	
	
	/**
	 * 삽입기구 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_etv120skrv_mit.do" )
	public String s_etv120skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_etv120skrv_mit");

		String nextPgmId = s_etv120skrv_mitService.selectNextPgmId(param);
		Integer interval = s_etv120skrv_mitService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> contentsList = s_etv120skrv_mitService.selectContents(param);

		model.put("contentsList", JsonUtils.toJsonStr(contentsList));	
		
		Gson gson = new Gson();
        String colData = gson.toJson(s_etv120skrv_mitService.selectCaldate(loginVO.getCompCode()));
        model.addAttribute("colData", colData);		
		
		return JSP_PATH + "s_etv120skrv_mit";
	}	

	/**
	 * 조립/포장 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_etv130skrv_mit.do" )
	public String s_etv130skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_etv130skrv_mit");

		String nextPgmId = s_etv130skrv_mitService.selectNextPgmId(param);
		Integer interval = s_etv130skrv_mitService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> contentsList = s_etv130skrv_mitService.selectContents(param);

		model.put("contentsList", JsonUtils.toJsonStr(contentsList));	
		
		Gson gson = new Gson();
        String colData = gson.toJson(s_etv130skrv_mitService.selectCaldate(loginVO.getCompCode()));
        model.addAttribute("colData", colData);		
		
		return JSP_PATH + "s_etv130skrv_mit";
	}

	/**
	 * 조립/포장 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_etv140skrv_mit.do" )
	public String s_etv140skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_etv140skrv_mit");

		String nextPgmId = s_etv140skrv_mitService.selectNextPgmId(param);
		Integer interval = s_etv140skrv_mitService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> contentsList = s_etv140skrv_mitService.selectContents(param);

		model.put("contentsList", JsonUtils.toJsonStr(contentsList));	
		
		return JSP_PATH + "s_etv140skrv_mit";
	}
	
	/**
	 * 조립/포장 조회
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_etv150skrv_mit.do" )
	public String s_etv150skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_etv150skrv_mit");

		String nextPgmId = s_etv150skrv_mitService.selectNextPgmId(param);
		Integer interval = s_etv150skrv_mitService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> contentsList = s_etv150skrv_mitService.selectContents(param);

		model.put("contentsList", JsonUtils.toJsonStr(contentsList));	
		
		return JSP_PATH + "s_etv150skrv_mit";
	}
	
	/**
	 * 월별재무제표 출력(MIT) (s_agc170rkr_mit) - 20200619 추가
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( "unused" )
	@RequestMapping( value = "/z_mit/s_agc170rkr_mit.do" )
	public String agc170rkr( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false);		/* 재무제표 양식차수 */
		for (CodeDetailVO map : gsFinancialY) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsFinancialY", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_agc170rkr_mit".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);	//title
		model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);				//당기시작년월
		model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));

		return JSP_PATH + "s_agc170rkr_mit";
	}

	/**
	 * 품목추가정보 등록(MIT) (s_bpr200ukrv_mit) - 20191210 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_bpr200ukrv_mit.do")
	public String s_bpr200ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_bpr200ukrv_mit";
	}

	/**
	 * 제조BOM 등록(매출처)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_bpr560ukrv_mit.do", method = RequestMethod.GET)
	public String s_bpr560ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		Map<String, Object> comboParam = new HashMap<String, Object>();
		comboParam.put("COMP_CODE", loginVO.getCompCode());
		comboParam.put("TYPE", "DIV_PRSN");
		model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		//BOM PATH 관리여부(B082)
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}
		//대체품목 등록여부(B081)
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}
		//20190607 SAMPLE코드 사용여부(B912.REF_CODE1), 품목계정(B912.REF_CODE2)
		cdo = codeInfo.getCodeInfo("B912", "1");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSampleCodeYn"	, cdo.getRefCode1());
			model.addAttribute("gsItemAccount"	, cdo.getRefCode2());
		} else {
			model.addAttribute("gsSampleCodeYn"	, "N");
			model.addAttribute("gsItemAccount"	, "*");
		}
		//20190617 자품목 순번증가 단위 설정(B913)
		cdo = codeInfo.getCodeInfo("B913", "1");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSeqIncUit", cdo.getRefCode1());
		} else {
			model.addAttribute("gsSeqIncUit", "1");
		}
		return JSP_PATH + "s_bpr560ukrv_mit";
	}


	/**
	 * 제품라벨정보 업로드(MIT) (s_bpr600ukrv_mit) - 20190930 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_bpr600ukrv_mit.do")
	public String s_bpr600ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_bpr600ukrv_mit";
	}

	/**
	 * 긴급작업지시등록 MIT
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp110ukrv_mit.do")
	public String s_pmp110ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B907", "pmp100ukrv");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseWorkColumnYn", cdo.getRefCode1());	 // 생산자동채번유무

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp100ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "s_pmp110ukrv_mit";
	}

	/**
	 * 반제품 작업지시
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp111ukrv_mit.do")
	public String s_pmp111ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B907", "pmp100ukrv");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseWorkColumnYn", cdo.getRefCode1());	 // 생산자동채번유무

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp100ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		List<CodeDetailVO> gsComboList1 = codeInfo.getCodeList("P505", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsComboList1)	{
			if("Y".equals(map.getRefCode1()))	{
				if(list1.equals("")){
					list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsComboList1", list1);
		
		return JSP_PATH + "s_pmp111ukrv_mit";
	}

	/**
	 * 스텐트 완제품 작업지시
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp112ukrv_mit.do")
	public String s_pmp112ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B907", "pmp100ukrv");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseWorkColumnYn", cdo.getRefCode1());	 // 생산자동채번유무

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp100ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "s_pmp112ukrv_mit";
	}


	/**
	 * 자재소요량 계획 및 계산(MIT) (s_pmp113ukrv_mit) - 20200210 신규 생성
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp113ukrv_mit.do")
	public String s_pmp113ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
//		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmp113ukrv_mit";
	}


	/**
	 * 작업지시체크리스트(MIT) (s_pmp120ukrv_mit) - 20200212 신규 생성
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp120ukrv_mit.do")
	public String s_pmp120ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
//		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmp120ukrv_mit";
	}

	@RequestMapping(value = "/z_mit/s_pmp130rkrv_mit.do")
	public String s_pmp130rkrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST"	  , comboService.getWsList(param));

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp130rkrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "s_pmp130rkrv_mit";
	}

	/**
	 * 작업실적 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmr100ukrv_mit.do")
	public String s_pmr100ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		 model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		cdo = codeInfo.getCodeInfo("B090", "PB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1()); // 작업지시와 생산실적LOT 연계여부 설정 값 알기

		cdo = codeInfo.getCodeInfo("P000", "6");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsChkProdtDateYN",cdo.getRefCode1()); // 작업실적 등록시 착수예정일 체크여부

		cdo = codeInfo.getCodeInfo("P100", "1");	 										  // 생산완료시점 (100%)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("glEndRate",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B084", "D");	 										  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}
		cdo = codeInfo.getCodeInfo("P516", "1");	 										  // 생산작업시간(점심)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLunchFr",cdo.getRefCode1());
			model.addAttribute("gsLunchTo",cdo.getRefCode2());
		}else{
			model.addAttribute("gsLunchFr","12:00");
			model.addAttribute("gsLunchTo","13:00");
		}

		Gson gson = new Gson();
		String colData = gson.toJson(s_pmr100ukrv_mitService.selectBadcodes(loginVO.getCompCode()));
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_pmr100ukrv_mit";
	}

	/** 출고예정표(MIT) (s_sof120ukrv_mit)
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sof120ukrv_mit.do")
	public String s_sof120ukrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_sof120ukrv_mit";
	}

	/**
	 * 주문의뢰서 출력(MIT) (s_sof130skrv_mit) - 20191022 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_sof130skrv_mit.do")
	public String s_sof130skrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");			//영업담당 가져오기
		if(!ObjUtils.isEmpty(salePrsn)) {
//			model.addAttribute("salePrsn", ObjUtils.toJsonStr(salePrsn));
			for(CodeDetailVO map : salePrsn) {
				if(loginVO.getUserID().equals(map.getRefCode5())) {
					model.addAttribute("gsSalesPrsn", map.getCodeNo());		//로그인 유저의 영업담당 가져오기
				}
			}
		}
		List<CodeDetailVO> printInfo = codeInfo.getCodeList("Z026");		//주문의뢰서 수신부서 가져오기
		if(!ObjUtils.isEmpty(printInfo)) {
			for(CodeDetailVO map : printInfo) {
				if(loginVO.getUserID().equals(map.getCodeNo())) {
					model.addAttribute("gsSendInfo", map.getCodeName());	//출력 시 로그인 유저의 발신부서 정보
					model.addAttribute("gsReciInfo", map.getRefCode1());	//출력 시 로그인 유저의  수신부서 정보
				}
			}
		}
		//20191224 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		return JSP_PATH + "s_sof130skrv_mit";
	}

	/**
	 * 출하지시 등록(MIT) (s_srq100ukrv_mit) - 20200227 신규 생성 시작
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_srq100ukrv_mit.do")
	public String s_srq100ukrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "8");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("S026", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S036", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPrintPgID",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S048", "SR");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsTimeYN1", cdo.getRefCode1());
		}else {
			model.addAttribute("gsTimeYN1", "N");
		}

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsTimeYN2", cdo.getRefCode1());
		}else {
			model.addAttribute("gsTimeYN2", "N");
		}

		cdo = codeInfo.getCodeInfo("S071", "1");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsScmUseYN", cdo.getRefCode1());
		}else {
			model.addAttribute("gsScmUseYN", "N");
		}

		cdo = codeInfo.getCodeInfo("Z001", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsBoxQYn", "Y");
			model.addAttribute("gsMiniPackQYn", "Y");
		}else {
			model.addAttribute("gsBoxQYn", "N");
			model.addAttribute("gsMiniPackQYn", "N");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn", cdo.getRefCode1());
			model.addAttribute("gsUnitChack", cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		} else {
			model.addAttribute("gsPriceGubun",		"A");		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			"KG");		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			"L");		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}

		model.addAttribute("COMBO_WH_U_LIST", comboService.getWhUList(param));
		
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("srq100ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}

		//20190925 - LOT 관리기준 설정
		cdo = codeInfo.getCodeInfo("B090", "SE");		//출하지시 등록(SE)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1());	//입력형태(Y/E/N)
			model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2());	//필수여부(Y/N)
			model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3());	//품목계정(필수Y,문자열)
		}
		return JSP_PATH + "s_srq100ukrv_mit";
	}

	/** 출고등록(MIT)(s_str105ukrv_mit) - 바코드
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str105ukrv_mit.do")
	public String s_str105ukrv_mit (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))	model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");	//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str103ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");	//LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false);	//출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInoutAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1") || map.getCodeNo().equals("3")){
					model.addAttribute("gsInoutAutoYN", "Y");
				}else{
					model.addAttribute("gsInoutAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvstatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvstatus", "+");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
			if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");	//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode",cdo.getRefCode1());
		}else {
			model.addAttribute("gsRefWhCode", "1");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("S048", "SI");	//시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsManageTimeYN", "N");
		}
		cdo = codeInfo.getCodeInfo("S120", "1");   //셀 자동LOT 배정여부(Y/N)
	   if(!ObjUtils.isEmpty(cdo)){
		   model.addAttribute("useLotAssignment",cdo.getRefCode1());
	   }else {
		   model.addAttribute("useLotAssignment", "N");
	   }
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		cdo = codeInfo.getCodeInfo("B703", "01");	//선입선출 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_str105ukrv_mit".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		int j = 0;
		List<CodeDetailVO> gsDefaultType = codeInfo.getCodeList("S148", "", false);		//거래명세서 유형
		for(CodeDetailVO map : gsDefaultType) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsDefaultType"	, map.getCodeNo());			//거래명세서 유형
				model.addAttribute("gsDefaultCrf"	, map.getRefCode2());		//CRF레포트 파일명
				model.addAttribute("gsDefaultFolder", map.getRefCode3());		//CRF레포트 기본 폴더(사이트 일때만 입력)
				j++;
			}
		}
		if(j == 0) model.addAttribute("gsDefaultType", "10");


		return JSP_PATH + "s_str105ukrv_mit";
	}

	/** 생산입고등록(MIT)(s_str130ukrv_mit)
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str130ukrv_mit.do")
	public String s_str130ukrv_mit (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))	model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");	//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str103ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");	//LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false);	//출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInoutAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1") || map.getCodeNo().equals("3")){
					model.addAttribute("gsInoutAutoYN", "Y");
				}else{
					model.addAttribute("gsInoutAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvstatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvstatus", "+");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
			if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");	//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode",cdo.getRefCode1());
		}else {
			model.addAttribute("gsRefWhCode", "1");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("S048", "SI");	//시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsManageTimeYN", "N");
		}
		cdo = codeInfo.getCodeInfo("S120", "1");   //셀 자동LOT 배정여부(Y/N)
	   if(!ObjUtils.isEmpty(cdo)){
		   model.addAttribute("useLotAssignment",cdo.getRefCode1());
	   }else {
		   model.addAttribute("useLotAssignment", "N");
	   }
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		cdo = codeInfo.getCodeInfo("B703", "01");	//선입선출 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_str105ukrv_mit".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		int j = 0;
		List<CodeDetailVO> gsDefaultType = codeInfo.getCodeList("S148", "", false);		//거래명세서 유형
		for(CodeDetailVO map : gsDefaultType) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsDefaultType"	, map.getCodeNo());			//거래명세서 유형
				model.addAttribute("gsDefaultCrf"	, map.getRefCode2());		//CRF레포트 파일명
				model.addAttribute("gsDefaultFolder", map.getRefCode3());		//CRF레포트 기본 폴더(사이트 일때만 입력)
				j++;
			}
		}
		if(j == 0) model.addAttribute("gsDefaultType", "10");


		return JSP_PATH + "s_str130ukrv_mit";
	}

	@RequestMapping(value = "/z_mit/s_hat900ukr_mit.do")
	public String s_hat900ukr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_hat900ukr_mit";
	}

	@RequestMapping(value = "/z_mit/s_hat900skr_mit.do")
	public String s_hat900skr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_hat900skr_mit";
	}

	/**
	 * 제품라벨출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pms500rkrv_mit.do",method = RequestMethod.GET)
	public String s_pms500rkrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_pms500rkrv_mit";
	}

	/**
	 * 거래처별집계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_mit/s_agb200skr_mit.do")
	public String s_agb200skr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "s_agb200skr_mit";
	}

	/**
	 * 거래처별원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_mit/s_agb210skr_mit.do")
	public String s_agb210skr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "s_agb210skr_mit";
	}

	//지급조서출력
	@RequestMapping( value = "/z_mit/s_hpa900rkr_mit.do" )
	public String s_hpa900rkr_mit( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		Gson gson = new Gson();
		String colData = gson.toJson(s_hpa900rkr_mitService.selectColumns(loginVO));
		model.addAttribute("colData", colData);

		//S_COMP_CODE 가져오기
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE", loginVO.getCompCode());

		//조회조건(사업명 : CBM600T 참조하여 콤보 가져오는 것)
		model.addAttribute("COMBO_HUMAN_COST_POOL", comboService.getHumanCostPool(param));

		List<Map<String, Object>> getCostPoolName = s_hpa900rkr_mitService.getCostPoolName(param);
		model.addAttribute("getCostPoolName", ObjUtils.toJsonStr(getCostPoolName));

		return JSP_PATH + "s_hpa900rkr_mit";
	}


	/**
	 * 생산입고현황 (s_str130skrv_mit) - 20200316 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str130skrv_mit.do")
	public String s_str130skrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_str130skrv_mit";
	}

	/**
	 * 생산현황 (s_str139skrv_mit) - 20210121 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str139skrv_mit.do")
	public String s_str139skrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_str139skrv_mit";
	}


	/**
	 * 오더생산진행현황(MIT) (s_str140skrv_mit) - 20200325 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str140skrv_mit.do")
	public String s_str140skrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "s_str140skrv_mit";
	}

	/**
	 * 반품의뢰서 출력(MIT) (s_str320skrv_mit) - 20191004 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str320skrv_mit.do")
	public String s_str320skrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "s_str320skrv_mit";
	}


	/**
	 * 출고확인서 출력(MIT) (s_str330skrv_mit) - 20191106 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str330skrv_mit.do")
	public String s_str330skrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");		//수불담당 가져오기
		if(!ObjUtils.isEmpty(inoutPrsn)) {
			for(CodeDetailVO map : inoutPrsn) {
				if(loginVO.getUserID().equals(map.getRefCode10())) {
					model.addAttribute("gsInoutPrsn", map.getCodeNo());		//로그인 유저의 수불담당 가져오기
				}
			}
		}
		List<CodeDetailVO> printInfo = codeInfo.getCodeList("Z027");		//출고확인서 수신부서 가져오기
		if(!ObjUtils.isEmpty(printInfo)) {
			for(CodeDetailVO map : printInfo) {
				if(loginVO.getUserID().equals(map.getCodeNo())) {
					model.addAttribute("gsSendInfo"	, map.getCodeName());	//출력 시 로그인 유저의 발신부서 정보
					model.addAttribute("gsReciInfo1", map.getRefCode1());	//출력 시 로그인 유저의  수신부서 정보(국내)
					model.addAttribute("gsReciInfo2", map.getRefCode2());	//출력 시 로그인 유저의  수신부서 정보(해외)
				}
			}
		}
		return JSP_PATH + "s_str330skrv_mit";
	}

	/**
	 * 반품결과 등록(MIT) (s_str330ukrv_mit) - 20191007 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str330ukrv_mit.do")
	public String s_str330ukrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		//20200204 추가
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));
		//20191017 추가
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		//20200204 추가
		CodeInfo codeInfo				= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> inoutPrsn	= codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn)) {
			for(CodeDetailVO map : inoutPrsn) {
				if(loginVO.getUserID().equals(map.getRefCode10())) {
					model.addAttribute("gsInoutPrsn", map.getCodeNo());		//로그인 유저의 수불담당 가져오기
				}
			}
		}

		return JSP_PATH + "s_str330ukrv_mit";
	}

	/**
	 * 월별반품현황 조회(MIT) (s_str340skrv_mit) - 20191014 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_str340skrv_mit.do")
	public String s_str340skrv_mit(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "s_str340skrv_mit";
	}

	/**
	 * 엠아이텍 랜딩이동출고 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_btr111ukrv_mit.do",method = RequestMethod.GET)
	public String s_btr111ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		model.addAttribute("COMBO_WH_LIST2", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST2", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* 재고상태관리(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																				   /* 주화폐단위 */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* 재고와 재고이동LOT 연계여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	   /* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	  /* 재고합산유형 : 창고 Cell 합산 */

		cdo = codeInfo.getCodeInfo("B041", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn)); // 담당자

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
		for(CodeDetailVO map : gsUsePabStockYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsUsePabStockYn", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
		for(CodeDetailVO map : gsGwYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsGwYn", map.getCodeNo());
			}
		}

		return JSP_PATH + "s_btr111ukrv_mit";
	}

	/**
	 * 엠아이텍 재고이동 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_btr112ukrv_mit.do",method = RequestMethod.GET)
	public String s_btr112ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		model.addAttribute("COMBO_WH_LIST2", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST2", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* 재고상태관리(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}																				   /* 주화폐단위 */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* 재고와 재고이동LOT 연계여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	   /* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	  /* 재고합산유형 : 창고 Cell 합산 */

		cdo = codeInfo.getCodeInfo("B041", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn)); // 담당자

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
		for(CodeDetailVO map : gsUsePabStockYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsUsePabStockYn", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
		for(CodeDetailVO map : gsGwYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsGwYn", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_btr112ukrv_mit";
	}

	/**
	 * 엠아이텍 일근태 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/z_mit/s_hat500ukr_mit.do" )
	public String s_hat500ukr_mit( LoginVO loginVO, ModelMap model ) throws Exception {
		Gson gson = new Gson();
		String dutyRule = s_hat500ukr_mitService.getDutyRule(loginVO.getCompCode());
		Map<String, String> param = new HashMap<String, String>();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("DUTY_RULE", dutyRule);
		param.put("PAY_CODE", "0");
		String colData = gson.toJson(s_hat500ukr_mitService.getDutycode(param));
		model.addAttribute("dutyRule", dutyRule);
		model.addAttribute("colData", colData);
		return JSP_PATH + "s_hat500ukr_mit";
	}

	@RequestMapping(value = "/z_mit/s_biv300skrv_mit.do")
	public String s_biv300skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("I004", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAvgPHiddenYN",cdo.getRefCode1());

		List<Map<String, Object>> gsWHGroupYN = s_biv300skrv_mitService.getgsWHGroupYN(param);
		if(ObjUtils.isEmpty(gsWHGroupYN) || gsWHGroupYN.get(0).get("GROUP_CD").equals("")){
			gsWHGroupYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			model.addAttribute("gsWHGroupYN","N");  
			gsWHGroupYN.add(map);	
		} else {
			model.addAttribute("gsWHGroupYN","Y");
		}	
		return JSP_PATH + "s_biv300skrv_mit";
	}
	@RequestMapping( value = "/z_mit/getDutycode.do" )
	public ModelAndView getDutycode( @RequestParam Map<String, String> param ) throws Exception {
		Gson gson = new Gson();
		String dutyList = gson.toJson(s_hat500ukr_mitService.getDutycode(param));
		return ViewHelper.getJsonView(dutyList);
	}

	/**
	 * 작업지시현황 조회(작업지시별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_pmp120skrv_mit.do")
	public String s_pmp120skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		return JSP_PATH + "s_pmp120skrv_mit";
	}

	/**
	 * 월별재무제표
	 * 
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( "unused" )
	@RequestMapping( value = "/z_mit/s_agc170skr_mit.do" )
	public String s_agc170skr_mit( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<CodeDetailVO> gsFinancialY = codeInfo.getCodeList("A093", "", false); /* 재무제표 양식차수 */
		for (CodeDetailVO map : gsFinancialY) {
			if ("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsFinancialY", map.getCodeNo());
			}
		}
		List<Map<String, Object>> fnSetFormTitle = accntCommonService.fnSetFormTitle(param);	//title
		model.addAttribute("fnSetFormTitle", ObjUtils.toJsonStr(fnSetFormTitle));
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH + "s_agc170skr_mit";
	}

	/* 급상여자동기표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_agd100ukr_mit.do")
	public String agd100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	

		return JSP_PATH + "s_agd100ukr_mit";
	}

	/* 급상여자동기표방법 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_aga110ukr_mit.do")
	public String s_aga110ukr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	

		return JSP_PATH + "s_aga110ukr_mit";
	}

	/* 감가상각등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_aisc150ukrv_mit.do")
	public String s_aisc150ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_aisc150ukrv_mit";
	}
	
	
	
	/* 원가수불부 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_cdr400skrv_mit.do")
	public String s_cdr400skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "s_cdr400skrv_mit";
	}
	
	
	/* 원가수불부 이력 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_cam500skrv_mit.do")
	public String s_cam500skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));  
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));   
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param)); 
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));


		Map costYear  = costCommonService.selectWorkMonthFr(param, loginVO);
		if(costYear != null)	{
			String yearEvaluationYN = ObjUtils.getSafeString(costYear.get("YEAR_EVALUATION_YN"));
			String frMonth = ObjUtils.getSafeString(costYear.get("WORK_MONTH_FR"));
			model.addAttribute("YEAR_EVALUATION_YN", yearEvaluationYN);
			model.addAttribute("WORK_MONTH_FR", frMonth);
		} else {
			model.addAttribute("YEAR_EVALUATION_YN", "N");
			model.addAttribute("WORK_MONTH_FR", "");
		}
		

		return JSP_PATH + "s_cam500skrv_mit";
	}
	
	
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 접수등록
	*/
	@RequestMapping(value = "/z_mit/s_sas100ukrv_mit.do", method = RequestMethod.GET)
	public String s_sas100ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> cdo = codeInfo.getCodeList("Z038");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("FDA",ObjUtils.toJsonStr(cdo));
		}else {
			model.addAttribute("FDA", "[]");
		}
		return JSP_PATH + "s_sas100ukrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 접수 현황 조회
	*/
	@RequestMapping(value = "/z_mit/s_sas100skrv_mit.do", method = RequestMethod.GET)
	public String s_sas100skrv_mit() throws Exception {
		return JSP_PATH + "s_sas100skrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 견적등록
	*/
	@RequestMapping(value = "/z_mit/s_sas200ukrv_mit.do", method = RequestMethod.GET)
	public String s_sas200ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> cdo = codeInfo.getCodeList("Z037");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("FDA",ObjUtils.toJsonStr(cdo));
		}else {
			model.addAttribute("FDA", "[]");
		}
		
		CodeDetailVO cdo2 = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo2))	model.addAttribute("gsVatRate",cdo2.getRefCode1());
		else model.addAttribute("gsVatRate","0");
		
		return JSP_PATH + "s_sas200ukrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 수리이력조회
	*/
	@RequestMapping(value = "/z_mit/s_sas300skrv_mit.do", method = RequestMethod.GET)
	public String s_sas300skrv_mit() throws Exception {
		return JSP_PATH + "s_sas300skrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 수리이력조회II
	*/
	@RequestMapping(value = "/z_mit/s_sas310skrv_mit.do", method = RequestMethod.GET)
	public String s_sas310skrv_mit() throws Exception {
		return JSP_PATH + "s_sas310skrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 수리등록
	*/
	@RequestMapping(value = "/z_mit/s_sas300ukrv_mit.do", method = RequestMethod.GET)
	public String s_sas300ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());
		else model.addAttribute("gsVatRate","0");
		
		Map<String, Object> param = navigator.getParam();
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		
		return JSP_PATH + "s_sas300ukrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  출고검사
	*/
	@RequestMapping(value = "/z_mit/s_sas320ukrv_mit.do", method = RequestMethod.GET)
	public String s_sas320ukrv_mit() throws Exception {
		return JSP_PATH + "s_sas320ukrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 장비출고
	*/
	@RequestMapping(value = "/z_mit/s_sas330ukrv_mit.do", method = RequestMethod.GET)
	public String s_sas330ukrv_mit() throws Exception {
		return JSP_PATH + "s_sas330ukrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  자산이력관리
	*/
	@RequestMapping(value = "/z_mit/s_sas340ukrv_mit.do", method = RequestMethod.GET)
	public String s_sas340ukrv_mit() throws Exception {
		return JSP_PATH + "s_sas340ukrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  AS 매출등록
	*/
	@RequestMapping(value = "/z_mit/s_sas400ukrv_mit.do", method = RequestMethod.GET)
	public String s_sas400ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}
		
		return JSP_PATH + "s_sas400ukrv_mit";
	}
	
	/**
	 *  쇄석기 보증기간사용비용
	*/
	@RequestMapping(value = "/z_mit/s_agc720ukr_mit.do", method = RequestMethod.GET)
	public String s_agc720ukr_mit() throws Exception {
		return JSP_PATH + "s_agc720ukr_mit";
	}
	/**
	 *  쇄석기 자재사용
	*/
	@RequestMapping(value = "/z_mit/s_agc730ukr_mit.do", method = RequestMethod.GET)
	public String s_agc730ukr_mit() throws Exception {
		return JSP_PATH + "s_agc730ukr_mit";
	}
	
	/**
	 *  쇄석기 인건비
	*/
	@RequestMapping(value = "/z_mit/s_agc740ukr_mit.do", method = RequestMethod.GET)
	public String s_agc740ukr_mit() throws Exception {
		return JSP_PATH + "s_agc740ukr_mit";
	}
	
	/**
	 *  쇄석기 원재료손상내역
	*/
	@RequestMapping(value = "/z_mit/s_agc750ukr_mit.do", method = RequestMethod.GET)
	public String s_agc750ukr_mit() throws Exception {
		return JSP_PATH + "s_agc750ukr_mit";
	}
	
	
	/**
	 *  쇄석기 연도별월별비용
	*/
	@RequestMapping(value = "/z_mit/s_agc700skr_mit.do", method = RequestMethod.GET)
	public String s_agc700skr_mit() throws Exception {
		return JSP_PATH + "s_agc700skr_mit";
	}
	
	/**
	 *  쇄석기 연도별월별매출
	*/
	@RequestMapping(value = "/z_mit/s_agc710skr_mit.do", method = RequestMethod.GET)
	public String s_agc710skr_mit() throws Exception {
		return JSP_PATH + "s_agc710skr_mit";
	}
	
	/**
	 *  충당부채_불용재고(원재료,상품)

	*/
	@RequestMapping(value = "/z_mit/s_agc600ukr_mit.do", method = RequestMethod.GET)
	public String s_agc600ukr_mit() throws Exception {
		return JSP_PATH + "s_agc600ukr_mit";
	}
	
	/**
	 *  충당부채_상품

	*/
	@RequestMapping(value = "/z_mit/s_agc610ukr_mit.do", method = RequestMethod.GET)
	public String s_agc610ukr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		return JSP_PATH + "s_agc610ukr_mit";
	}
	
	/**
	 *  충당부채_제상품

	*/
	@RequestMapping(value = "/z_mit/s_agc620ukr_mit.do", method = RequestMethod.GET)
	public String s_agc620ukr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		return JSP_PATH + "s_agc620ukr_mit";
	}
	/**
	 *  충당부채_제상품폐기리스트

	*/
	@RequestMapping(value = "/z_mit/s_agc630ukr_mit.do", method = RequestMethod.GET)
	public String s_agc630ukr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		return JSP_PATH + "s_agc630ukr_mit";
	}
	/**
	 *  충당부채 설정내역

	*/
	@RequestMapping(value = "/z_mit/s_agc760ukr_mit.do", method = RequestMethod.GET)
	public String s_agc760ukr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		return JSP_PATH + "s_agc760ukr_mit";
	}
	
	/**
	 *  매입내역 - 원재료 가격변동추이

	*/
	@RequestMapping(value = "/z_mit/s_agc800skr_mit.do", method = RequestMethod.GET)
	public String s_agc800skr_mit() throws Exception {
		return JSP_PATH + "s_agc800skr_mit";
	}
	
	/**
	 *  매입내역 - 원재료 주요매입처

	*/
	@RequestMapping(value = "/z_mit/s_agc810skr_mit.do", method = RequestMethod.GET)
	public String s_agc810skr_mit() throws Exception {
		return JSP_PATH + "s_agc810skr_mit";
	}
	
	/**
	 *  매출관리 - 매출실적
	*/
	@RequestMapping(value = "/z_mit/s_agc850ukr_mit.do", method = RequestMethod.GET)
	public String s_agc850ukr_mit() throws Exception {
		return JSP_PATH + "s_agc850ukr_mit";
	}
	
	/**
	 * 연자수당관리
	 */
	@RequestMapping( value = "/z_mit/s_hat810ukr_mit.do" )
    public String s_hat810ukr_mit() throws Exception {
        return JSP_PATH + "s_hat810ukr_mit";
    }
	/**
	 * 연자수당정산관리
	 */
	@RequestMapping( value = "/z_mit/s_hat800ukr_mit.do" )
    public String s_hat800ukr_mit() throws Exception {
        return JSP_PATH + "s_hat800ukr_mit";
    }
	/**
	 * 회계 매출내역
	 */
	@RequestMapping( value = "/z_mit/s_agc860skr_mit.do" )
    public String s_agc860skr_mit() throws Exception {
        return JSP_PATH + "s_agc860skr_mit";
    }
	/**
	 * 생산마감업로드
	 */
	@RequestMapping( value = "/z_mit/s_pmr110ukrv_mit.do" )
    public String s_pmp110ukrv_mit() throws Exception {
        return JSP_PATH + "s_pmr110ukrv_mit";
    }
	/**
	 * 생산실적업로드
	 */
	@RequestMapping( value = "/z_mit/s_pmr120ukrv_mit.do" )
    public String s_pmp120ukrv_mit() throws Exception {
        return JSP_PATH + "s_pmr120ukrv_mit";
    }
	/**
	 * 원부자재적합관리
	 */
	@RequestMapping( value = "/z_mit/s_pmr300ukrv_mit.do" )
    public String s_pmp300ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO defaultWHCode = codeInfo.getCodeInfo("Z033", loginVO.getDivCode());

		if(defaultWHCode != null)	{
			model.addAttribute("FR_WH_CODE"			, ObjUtils.getSafeString(defaultWHCode.getRefCode1(), ""));
			model.addAttribute("FR_WH_CELL_CODE"	, ObjUtils.getSafeString(defaultWHCode.getRefCode2(), ""));
			model.addAttribute("TO_WH_CODE"			, ObjUtils.getSafeString(defaultWHCode.getRefCode3(), ""));
			model.addAttribute("TO_WH_CELL_CODE"	, ObjUtils.getSafeString(defaultWHCode.getRefCode4(), ""));
		} else {
			model.addAttribute("FR_WH_CODE"			, "");
			model.addAttribute("FR_WH_CELL_CODE"	, "");
			model.addAttribute("TO_WH_CODE"			, "");
			model.addAttribute("TO_WH_CELL_CODE"	, "");
		}
        return JSP_PATH + "s_pmr300ukrv_mit";
    }
	/**
	 * 생산 인력정보
	 */
	@RequestMapping( value = "/z_mit/s_hpb100ukrv_mit.do" )
    public String s_hpb100ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
		List<ComboItemModel> workerList = comboService.getComboList("AU", "P505", loginVO, param, null);
		List<ComboItemModel> workerList2 = new ArrayList();
		for(ComboItemModel comboModel : workerList)	{
			if("Y".equals(comboModel.getRefCode1()))	{
				workerList2.add(comboModel);
			}
		}
		model.addAttribute("WORKER_CODE", workerList2);
        return JSP_PATH + "s_hpb100ukrv_mit";
    }
	
	/**
	 * 생산 교육정보
	 */
	@RequestMapping( value = "/z_mit/s_out100ukrv_mit.do" )
    public String s_out100ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
		List<ComboItemModel> workerList = comboService.getComboList("AU", "P505", loginVO, param, null);
		List<ComboItemModel> workerList2 = new ArrayList();
		for(ComboItemModel comboModel : workerList)	{
			if("Y".equals(comboModel.getRefCode1()))	{
				workerList2.add(comboModel);
			}
		}
		model.addAttribute("WORKER_CODE", workerList2);
        return JSP_PATH + "s_out100ukrv_mit";
    }
	
	/**
	 * 생산 스텐트단가 관리
	 */
	@RequestMapping( value = "/z_mit/s_out200ukrv_mit.do" )
    public String s_out200ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
        return JSP_PATH + "s_out200ukrv_mit";
    }
	
	/**
	 * 생산 스텐트 생산집계
	 */
	@RequestMapping( value = "/z_mit/s_out210ukrv_mit.do" )
    public String s_out210ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
	
        return JSP_PATH + "s_out210ukrv_mit";
    }
	
	/**
	 * 생산 소급비용
	 */
	@RequestMapping( value = "/z_mit/s_out220ukrv_mit.do" )
    public String s_out220ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
		List<ComboItemModel> workerList = comboService.getComboList("AU", "P505", loginVO, param, null);
		List<ComboItemModel> workerList2 = new ArrayList();
		for(ComboItemModel comboModel : workerList)	{
			if("Y".equals(comboModel.getRefCode1()))	{
				workerList2.add(comboModel);
			}
		}
		model.addAttribute("WORKER_CODE", workerList2);
        return JSP_PATH + "s_out220ukrv_mit";
    }
	
	/**
	 * 생산 외주용역비 계산
	 */
	@RequestMapping( value = "/z_mit/s_out300ukrv_mit.do" )
    public String s_out300ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
		List<ComboItemModel> workerList = comboService.getComboList("AU", "P505", loginVO, param, null);
		List<ComboItemModel> workerList2 = new ArrayList();
		for(ComboItemModel comboModel : workerList)	{
			if("Y".equals(comboModel.getRefCode1()))	{
				workerList2.add(comboModel);
			}
		}
		model.addAttribute("WORKER_CODE", workerList2);
        return JSP_PATH + "s_out300ukrv_mit";
    }
	
	/**
	 * 제품제작의뢰(연구소)
	 */
	@RequestMapping( value = "/z_mit/s_bpr110ukrv_mit.do" )
	public String s_bpr1100ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
        return JSP_PATH + "s_bpr110ukrv_mit";
    }
	
	/**
	 * 반제품제작의뢰(연구소)
	 */
	@RequestMapping( value = "/z_mit/s_bpr120ukrv_mit.do" )
	public String s_bpr1200ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		
		Map<String, Object> param = navigator.getParam();
		
        return JSP_PATH + "s_bpr120ukrv_mit";
    }
	/**
	 * 매출채권연령표_대손충당금
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_agc870ukr_mit.do", method = RequestMethod.GET)
	public String s_agc870ukr_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		return JSP_PATH + "s_agc870ukr_mit";
	}
	
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  대리점 AS 수리이력조회
	*/
	@RequestMapping(value = "/z_mit/s_sas305skrv_mit.do", method = RequestMethod.GET)
	public String s_sas305skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_DIV_CODE", s_biv305skrv_mitService.getDivCode(param));
		return JSP_PATH + "s_sas305skrv_mit";
	}
	/**
	 *  엠아이텍 고도화 프로젝트 - AS 관리
	 *  대리점 AS 수리이력조회II
	*/
	@RequestMapping(value = "/z_mit/s_sas315skrv_mit.do", method = RequestMethod.GET)
	public String s_sas315skrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_DIV_CODE", s_biv305skrv_mitService.getDivCode(param));
		

		return JSP_PATH + "s_sas315skrv_mit";
	}
	/**
	 * 
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_biv305skrv_mit.do")
	public String biv305skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_DIV_CODE", s_biv305skrv_mitService.getDivCode(param));
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("I004", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAvgPHiddenYN",cdo.getRefCode1());
		
		return JSP_PATH + "s_biv305skrv_mit";
	}
	
	/** 대리점 품목정보 Upload
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_bpr130ukrv_mit.do", method = RequestMethod.GET)
	public String bpr130ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_bpr130ukrv_mit";
	}
	
	@RequestMapping(value = "/z_mit/s_sas500ukrv_mit.do",method = RequestMethod.GET)
	public String s_sas500ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		return JSP_PATH + "s_sas500ukrv_mit";
	}
	
	@RequestMapping(value = "/z_mit/s_sas600ukrv_mit.do",method = RequestMethod.GET)
	public String s_sas600ukrv_mit(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		return JSP_PATH + "s_sas600ukrv_mit";
	}
	
	/**
	 * 재고현황조회(대리점용)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_mit/s_biv302skrv_mit.do")
	public String biv302skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_DIV_CODE", s_biv302skrv_mitService.getDivCode(param));
		
		model.addAttribute("COMBO_WH_CODE", s_biv302skrv_mitService.getWhCode(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = codeInfo.getCodeInfo("I004", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAvgPHiddenYN",cdo.getRefCode1());
		
		CodeDetailVO cdo2 = codeInfo.getCodeInfo("B267", "10");
		if(!ObjUtils.isEmpty(cdo2))	model.addAttribute("gsDivCode",cdo2.getRefCode1());
		if(!ObjUtils.isEmpty(cdo2))	model.addAttribute("gsWhCode",cdo2.getRefCode3());
		
		return JSP_PATH + "s_biv302skrv_mit";
	}
}