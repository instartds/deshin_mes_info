package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;


/**
 *	프로그램명 : 작업지시조정
 *	작  성  자 : (주)포렌 개발실
 */
@Controller
public class AgbController extends UniliteCommonController {

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;

	@Resource(name="agb260skrService")
	private Agb260skrServiceImpl agb260skrService;

	@Resource(name="agb200skrService")
	private Agb200skrServiceImpl agb200skrService;

	@Resource(name="agb270skrService")
	private Agb270skrServiceImpl agb270skrService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String JSP_PATH = "/accnt/agb/";


	/** 회계장부 재집계작업
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb090ukr.do")
	public String agb090ukr(ExtHtttprequestParam _req, LoginVO loginVO, ModelMap model) throws Exception {
		
		return JSP_PATH + "agb090ukr";
	}
	
	/**
	 * 총계정원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb100skr.do")
	public String agb100skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		
		cdo = codeInfo.getCodeInfo("A214", "A");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("lightColor",cdo.getRefCode1());	//소계합계컬럼색상밝은
		cdo = codeInfo.getCodeInfo("A214", "A");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("normalColor",cdo.getRefCode2());	//소계합계컬럼색상보통
		
		return JSP_PATH + "agb100skr";
	}
	
	/* 총계정원장 Print
	 * @return
	 * @throws Exception
	 * dev: abchen  2016-10-21
	 */
	@RequestMapping(value = "/accnt/agb100rkr.do")
	public String agb100rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		
		cdo = codeInfo.getCodeInfo("A214", "A");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("lightColor",cdo.getRefCode1());	//소계합계컬럼색상밝은
		cdo = codeInfo.getCodeInfo("A214", "A");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("normalColor",cdo.getRefCode2());	//소계합계컬럼색상보통
		
		return JSP_PATH + "agb100rkr";
	}
	
	
	/* 총계정원장 (agb101skr) - 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb101skr.do")
	public String agb101skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		return JSP_PATH + "agb101skr";
	}
	
	/* 보조부
	 * @return
	 * @throws Exception
	 * add by zhongshl 20161101
	 */
	@RequestMapping(value="/accnt/agb110rkr.do")
	public String agb110rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("agb110rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}
		
		return JSP_PATH+"agb110rkr";
	}
	/* 보조부
	 * @return
	 * @throws Exception
	 * add by zhongshl 20161107
	 */
	@RequestMapping(value="/accnt/agb111rkr.do")
	public String agb111rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH+"agb111rkr";
	}
	/* 보조부
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb110skr.do")
	public String agb110skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH+"agb110skr";
	}
	
	/* 일계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb120skr.do")
	public String agb120skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		return JSP_PATH + "agb120skr";
	}
	
	@RequestMapping(value = "/accnt/agb120rkr.do")
	public String agb120ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		//20200724 추가: clip report 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("agb120rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "agb120rkr";
	}

	/* 일계표(2)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb125skr.do")
	public String agb125skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		return JSP_PATH + "agb125skr";
	}

	/* 일계표(2)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb125rkr.do")
	public String agb125rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		return JSP_PATH + "agb125rkr";
	}

	
	/**
	/* 현금출납장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb130skr.do")
	public String agb130skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "agb130skr";
	}
	
	/**
	/* 현금출납장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb130rkr.do")
	public String agb130rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "agb130rkr";
	}
	
	
	
	/**
	 * 거래처별채권채무현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb270skr.do")
	public String agb270skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		Gson gson = new Gson();
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		String colData = gson.toJson(agb270skrService.getAccntInfo(param));
		model.addAttribute("colData", colData);
		
		return JSP_PATH+"agb270skr";
	}
	
	/**
	 * 계정명세
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb140skr.do")
	public String agb140skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb140skr";
	}
	
	/**
	 * add by zhongshl
	 * 계정명세
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb140rkr.do")
	public String agb140rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb140rkr";
	}
	
	/**
	 * 미결현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb160skr.do")
	public String agb160skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH+"agb160skr";
	}

	/**
	 * 미결현황출력 (agb160rkr)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb160rkr.do")
	public String agb160rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		//20200803 추가: clip report 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("agb160rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH+"agb160rkr";
	}

	/**
	 * 미결현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb161skr.do")
	public String agb161skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);	   // ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb161skr";
	}

	/**
	 * 미결현황(2)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb165skr.do")
	public String agb165skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb165skr";
	}

	@RequestMapping(value="/accnt/agb165rkr.do")
	public String agb165rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		//20200804 추가: clip report 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("agb165rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH+"agb165rkr";
	}

	/**
	 * 기간비용
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb170skr.do")
	public String agb170skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		return JSP_PATH+"agb170skr";
	}

	@RequestMapping(value="/accnt/agb170rkr.do")
	public String agb170rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		return JSP_PATH+"agb170rkr";
	}

	/**
	 * 관리항목별집계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb190skr.do")
	public String agb190skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH+"agb190skr";
	}
	
	/**
	 * 관리항목별원장출력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb190rkr.do")
	public String agb190rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH+"agb190rkr";
	}	

	/**
	 * 관리항목별원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb180skr.do")
	public String agb180skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH+"agb180skr";
	}
	
	/**
	 * 관리항목별집계출력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb180rkr.do")
	public String agb180rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH+"agb180rkr";
	}		

	/**
	 * 거래처별집계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb200skr.do")
	public String agb200skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		List<Map<String, Object>> fnAgb200Init = agb200skrService.fnAgb200Init(param, loginVO);		// ChargeCode관련
		model.addAttribute("fnAgb200Init",ObjUtils.toJsonStr(fnAgb200Init));
		
		return JSP_PATH+"agb200skr";
	}

	@RequestMapping(value="/accnt/agb200rkr.do")
	public String agb200rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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

		List<Map<String, Object>> fnAgb200Init = agb200skrService.fnAgb200Init(param, loginVO);		// ChargeCode관련
		model.addAttribute("fnAgb200Init",ObjUtils.toJsonStr(fnAgb200Init));

		//20200727 추가: clip report 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("agb200rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH+"agb200rkr";
	}

	/**
	 * 거래처별원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb210skr.do")
	public String agb210skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH+"agb210skr";
	}

	/**
	 * add by zhongshl
	 * 거래처별원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb210rkr.do")
	public String agb210rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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

		//20200727 추가: clip report 추가
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("A126", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("agb210rkr".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH+"agb210rkr";
	}

	/**
	 * 계정별거래처원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb240skr.do")
	public String agb240skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb240skr";
	}

	/** 
	 * 계정별거래처원장 출력 (agb240rkr) - 20200723 추가
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/agb240rkr.do")
	public String agb240rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("A214", "A");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("lightColor",cdo.getRefCode1());		//소계합계컬럼색상밝은
		cdo = codeInfo.getCodeInfo("A214", "A");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("normalColor",cdo.getRefCode2());	//소계합계컬럼색상보통

		return JSP_PATH + "agb240rkr";
	}

	/**
	 * 관리항목별집계표(관리항목기준)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb290skr.do")
	public String agb290skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH+"agb290skr";
	}

	/**
	 * 관리항목별원장(관리항목기준)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb280skr.do")
	public String agb280skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb280skr";
	}

	/**
	 * 부서별경비명세서
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb260skr.do")
	public String agb260skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> deptList = agb260skrService.getAllDeptList(param);		//부서목록 조회			
		model.addAttribute("deptList",ObjUtils.toJsonStr(deptList));
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		return JSP_PATH+"agb260skr";
	}

	/**
	 * 매출채권연령표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb250skr.do")
	public String agb250skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb250skr";
	}

	/**
	 * 매출채권연령표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb251skr.do")
	public String agb251skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb251skr";
	}
	
	/**
	 * 매출채권연령표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb252skr.do")
	public String agb252skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb252skr";
	}
	
	/**
	 * 매출채권연령표_일반NEW
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb253skr.do")
	public String agb253skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb253skr";
	}
	
	/**
	 * 계정명세(화폐단위별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb150skr.do")
	public String agb150skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}
		return JSP_PATH+"agb150skr";
	}
	
	/**
	 * 계정명세(화폐단위별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb150rkr.do")
	public String agb150rkr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb150rkr";
	}
		

	/**
	 * 거래처별계정별 집계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb310skr.do")
	public String agb310skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH+"agb310skr";
	}

	/**
	 * 계정별 관리항목별 보조부조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb320skr.do")
	public String agb320skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH+"agb320skr";
	}

	/**
	 * 계정별 관리항목별 보조부조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb330skr.do")
	public String agb330skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH+"agb330skr";
	}

	/**
	 * 환평가 월별조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb340skr.do")
	public String agb340skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH+"agb340skr";
	}
	
	/**
	 * 선수금/외상매출금 상계
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/agb500skr.do")
	public String agb500skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
		
		return JSP_PATH+"agb500skr";
	}
}