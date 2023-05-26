package foren.unilite.modules.accnt.afb;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.accnt.afb.Afb500skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb510skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb555skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb520skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb540skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb540ukrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb560skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb600skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb800skrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb520ukrServiceImpl;
import foren.unilite.modules.accnt.afb.Afb530ukrServiceImpl;
import foren.unilite.modules.accnt.agb.Agb260skrServiceImpl;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class AfbController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/accnt/afb/";
 
	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;
	
	@Resource(name="afb600skrService")
	private Afb600skrServiceImpl afb600skrService;
	@Resource(name="afb500skrService")
	private Afb500skrServiceImpl afb500skrService;
	@Resource(name="afb510skrService")
	private Afb510skrServiceImpl afb510skrService;
	@Resource(name="afb540skrService")
	private Afb540skrServiceImpl afb540skrService;
	@Resource(name="afb540ukrService")
	private Afb540ukrServiceImpl afb540ukrService;
	@Resource(name="afb555skrService")
	private Afb555skrServiceImpl afb555skrService;
	@Resource(name="afb520skrService")
	private Afb520skrServiceImpl afb520skrService;
	@Resource(name="afb800skrService")
	private Afb800skrServiceImpl afb800skrService;
	@Resource(name="afb560skrService")
	private Afb560skrServiceImpl afb560skrService;
	@Resource(name="afb600ukrService")
	private Afb600ukrServiceImpl afb600ukrService;
	@Resource(name="afb700ukrService")
	private Afb700ukrServiceImpl afb700ukrService;
	@Resource(name="afb800ukrService")
	private Afb800ukrServiceImpl afb800ukrService;
	@Resource(name="afb900ukrService")
	private Afb900ukrServiceImpl afb900ukrService;
	@Resource(name="afb520ukrService")
	private Afb520ukrServiceImpl afb520ukrService;
	@Resource(name="afb530ukrService")
	private Afb530ukrServiceImpl afb530ukrService;
	@Resource(name="afb720skrService")
	private Afb720skrServiceImpl afb720skrService;
	@Resource(name="afb240skrService")
	private Afb240skrServiceImpl afb240skrService;
	@Resource(name="afb130ukrService")
	private Afb130ukrServiceImpl afb130ukrService;
	/* 예산실적조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb200skr.do")
	public String afb200skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH + "afb200skr";
	}
	
	@RequestMapping(value="/accnt/afb020ukr.do",method = RequestMethod.GET)
	public String afb020ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		return JSP_PATH+"afb020ukr";
	}	
	
	@RequestMapping(value="/accnt/afb210skr.do")
	public String afb210skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH + "afb210skr";
	}
	
	@RequestMapping(value="/accnt/afb220skr.do")
	public String afb220skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		return JSP_PATH + "afb220skr";
	}
	
	@RequestMapping(value="/accnt/afb230skr.do")
	public String afb230skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
		
		
		return JSP_PATH + "afb230skr";
	}
	
	
	@RequestMapping(value = "/accnt/afb240skr.do")
	
	public String afb240skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		
		List<Map<String, Object>> deptList = afb240skrService.getAllDeptList(param);		//부서목록 조회			
		model.addAttribute("deptList",ObjUtils.toJsonStr(deptList));	
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH + "afb240skr";
	}
	
	/**
	 * 예산신청입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb100ukr.do",method = RequestMethod.GET)
	public String afb100ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);			
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));	
		
		
		Map<String, Object> cdparam = navigator.getParam();
		cdparam.put("ADD_QUERY1", "REF_CODE2");
		cdparam.put("MAIN_CODE", "A009");
		cdparam.put("SUB_CODE", getChargeCode.get(0).get("SUB_CODE"));
//		Object gsChargeDivi = accntCommonService.fnGetRefCode(cdparam);			
//		model.addAttribute("gsChargeDivi",ObjUtils.toJsonStr(gsChargeDivi));
		
		Map gsChargeDivi = (Map)accntCommonService.fnGetRefCode(cdparam);	
		model.addAttribute("gsChargeDivi", gsChargeDivi.get(""));
		
		
		return JSP_PATH + "afb100ukr";
	}
	/**
	 * 예산조정입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb110ukr.do",method = RequestMethod.GET)
	public String afb110ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);     // ChargeCode관련         
        model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));
        
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);			
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH + "afb110ukr";
	}
	/**
	 * 예산전용입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb120ukr.do",method = RequestMethod.GET)
	public String afb120ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);			
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH + "afb120ukr";
	}
	
	/**
	 * 예산전용신청입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb121ukr.do",method = RequestMethod.GET)
	public String afb121ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}	
		
		return JSP_PATH + "afb121ukr";
	}
	
	/**
	 * 예산추가신청입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb122ukr.do",method = RequestMethod.GET)
	public String afb122ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}	
		
		return JSP_PATH + "afb122ukr";
	}
	
	/**
	 * 예산이월신청입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb123ukr.do",method = RequestMethod.GET)
	public String afb123ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		//ChargeCode 가져오기
		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);			
		if(getChargeCode.size() > 0){
			model.addAttribute("getChargeCode",getChargeCode.get(0).get("SUB_CODE"));
		}else{
			model.addAttribute("getChargeCode","");
		}	
		
		return JSP_PATH + "afb123ukr";
	}
	
	
	@RequestMapping(value="/accnt/afb130ukr.do")
	public String afb130ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		List<Map<String, Object>> chargeInfoList = afb130ukrService.selectChargeInfo(param);	// 사용자ID로부터 회계담당자 코드, 담당자명, 사용부서, 사번 정보 가져오기
		model.addAttribute("chargeInfoList",ObjUtils.toJsonStr(chargeInfoList));
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);				//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getToDt = accntCommonService.fnGetToDt(param);				//당기종료년월		
		model.addAttribute("getToDt",ObjUtils.toJsonStr(getToDt));
		
		return JSP_PATH+"afb130ukr";
	}
	
	@RequestMapping(value="/accnt/afb600skr.do")
	public String afb600skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		
		return JSP_PATH+"afb600skr";
	}
	/**
	 * 테스트
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afb999skr.do")
	public String afb999skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH+"afb999skr";
	}
	
	
	/**
	 * 예산기안(추산)등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afb600ukr.do")
	public String afb600ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);					
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		
		Map selectCheck1Map = (Map)afb600ukrService.selectCheck1(param);
		model.addAttribute("gsIdMapping", selectCheck1Map.get("MAPPING"));	
		model.addAttribute("gsLinkedGW", selectCheck1Map.get("GWIF"));
		model.addAttribute("gsConfirm", selectCheck1Map.get("CONFIRM"));
		model.addAttribute("gsConButtonYN", selectCheck1Map.get("CON_BUTTON_YN"));
		model.addAttribute("gsLineCopy", selectCheck1Map.get("LINE_COPY"));
		
		Map selectCheck2Map = (Map)afb600ukrService.selectCheck2(param);
		model.addAttribute("gsDrafter", selectCheck2Map.get("PERSON_NUMB"));	
		model.addAttribute("gsDrafterNm", selectCheck2Map.get("NAME"));
		model.addAttribute("gsDeptCode", selectCheck2Map.get("DEPT_CODE"));
		model.addAttribute("gsDeptName", selectCheck2Map.get("DEPT_NAME"));
		model.addAttribute("gsDivCode", selectCheck2Map.get("DIV_CODE"));
		
		Map selectCheck3Map = (Map)afb600ukrService.selectCheck3(param);
		model.addAttribute("gsPathInfo1", selectCheck3Map.get("PATH_INFO_1"));	
		model.addAttribute("gsPathInfo3", selectCheck3Map.get("PATH_INFO_3"));
		model.addAttribute("gsPathInfo4", selectCheck3Map.get("PATH_INFO_4"));
		
		Map selectCheck4Map = (Map)afb600ukrService.selectCheck4(param);
		if (ObjUtils.isNotEmpty(selectCheck4Map)) {
			model.addAttribute("selectCheck4", selectCheck4Map.get("SUB_CODE"));
		} else {
			model.addAttribute("selectCheck4", "");
		}
		
		Map selectCheck5Map = (Map)afb600ukrService.selectCheck5(param);
		if (ObjUtils.isNotEmpty(selectCheck5Map)) {
			model.addAttribute("selectCheck5", selectCheck5Map.get("SUB_CODE"));	
		} else {
			model.addAttribute("selectCheck5", "");
		}

		
		return JSP_PATH+"afb600ukr";
	}
	/**
	 * 지출결의등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afb700ukr.do")
	public String afb700ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		/**
		 * 프로그램별 사용 컬럼 관련	
		 */
		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "afb700ukr");
		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> useColList1 = accntCommonService.getUseColList(param);				
		model.addAttribute("useColList1",ObjUtils.toJsonStr(useColList1));	

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "afb700ukr");
		param.put("SHEET_ID", "grdSheet2");
		List<Map<String, Object>> useColList2 = accntCommonService.getUseColList(param);				
		model.addAttribute("useColList2",ObjUtils.toJsonStr(useColList2));	
		/**
		 * 문서서식구분 콤보 관련
		 */
		List<CodeDetailVO> gsListA171 = codeInfo.getCodeList("A171", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsListA171)	{
			if("0".equals(map.getRefCode2()) || "1".equals(map.getRefCode2()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsListA171", list1);
		
		
		/**
		 * 기본 셋팅 값 관련
		 */
		param.put("COL","AMT_POINT");
		Map fnGetAccntBasicInfo_aMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param);
		model.addAttribute("gsAmtPoint", fnGetAccntBasicInfo_aMap.get("OPTION"));
		

		/**
		 * 공공예산관련 옵션 
		 */
		Map selectCheck1Map = (Map)afb700ukrService.selectCheck1(param);
		model.addAttribute("gsIdMapping", selectCheck1Map.get("MAPPING"));
		model.addAttribute("gsLinkedGW", selectCheck1Map.get("GWIF"));
		model.addAttribute("gsDraftRef", selectCheck1Map.get("DRAFT_REF"));
		model.addAttribute("gsDtlMaxRows", selectCheck1Map.get("DTL_MAX_ROWS"));
		model.addAttribute("gsContents", selectCheck1Map.get("CONTENTS"));
		model.addAttribute("gsMultiCode", selectCheck1Map.get("MULTI_CODE"));
		model.addAttribute("gsTotAmtIn", selectCheck1Map.get("TOT_AMT_IN"));
		model.addAttribute("gsAppBtnUse", selectCheck1Map.get("APP_BTN_USE"));
		model.addAttribute("gsPendCodeYN", selectCheck1Map.get("PEND_CODE_YN"));
		model.addAttribute("gsCrdtRef", selectCheck1Map.get("CRDT_REF"));
		model.addAttribute("gsPayDtlRef", selectCheck1Map.get("PAY_DTL_REF"));

		/**
		 * 지출결의 - 회계구분 기본값 설정 
		 */
		Map selectCheck2Map = (Map)afb700ukrService.selectCheck2(param);
		model.addAttribute("gsAccntGubun", selectCheck2Map.get("ACCNT_GUBUN"));

		/**
		 * 예산과목구분 가져오기
		 */
		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);					
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		/**
		 * 회계담당자
		 */
		Map selectCheck3Map = (Map)afb700ukrService.selectCheck3(param);
		if(!ObjUtils.isEmpty(selectCheck3Map)){
		    model.addAttribute("gsChargeCode", selectCheck3Map.get("CHARGE_CODE"));
	        model.addAttribute("gsChargeDivi", selectCheck3Map.get("CHARGE_DIVI"));
		}		

		/**
		 * 로그인사용자의 사번, 이름, 예산부서, 사업장
		 */
		Map selectCheck4Map = (Map)afb700ukrService.selectCheck4(param);
		model.addAttribute("gsDrafter", selectCheck4Map.get("PERSON_NUMB"));	
		model.addAttribute("gsDrafterNm", selectCheck4Map.get("NAME"));
		model.addAttribute("gsDeptCode", selectCheck4Map.get("DEPT_CODE"));
		model.addAttribute("gsDeptName", selectCheck4Map.get("DEPT_NAME"));
		model.addAttribute("gsDivCode", selectCheck4Map.get("DIV_CODE"));

		/**
		 * 지출결의_수정자ID
		 */
		Map selectCheck5Map = (Map)afb700ukrService.selectCheck5(param);
		if(ObjUtils.isEmpty(selectCheck5Map) || selectCheck5Map.get("SUB_CODE").equals("")) {
//		if(selectCheck5Map.get("SUB_CODE").equals("")){
			model.addAttribute("gsAmender", "N");
		}else{
			model.addAttribute("gsAmender", "Y");
		}

		/**
		 * 세부업부적요 default값
		 */
		Map selectCheck6Map = (Map)afb700ukrService.selectCheck6(param);
		model.addAttribute("gsBizRemark", selectCheck6Map.get("SUB_CODE"));
		model.addAttribute("gsBizGubun", selectCheck6Map.get("BIZ_GUBUN"));

		/**
		 * 지급명세서참조 Link PGM ID
		 */
		Map selectCheck7Map = (Map)afb700ukrService.selectCheck7(param);
		if(ObjUtils.isEmpty(selectCheck7Map) || selectCheck7Map.get("PAYDTL_PGMID").equals("")) {
//		if(selectCheck7Map.get("PAYDTL_PGMID").equals("")){
			model.addAttribute("gsPayDtlLinkedPgmID", "afb720ukr");
		}else{
			model.addAttribute("gsPayDtlLinkedPgmID", selectCheck7Map.get("PAYDTL_PGMID"));
		}

		/**
		 * 결재상신 경로정보
		 */
		Map selectCheck8Map = (Map)afb700ukrService.selectCheck8(param);
		model.addAttribute("gsPathInfo1", selectCheck8Map.get("PATH_INFO_1"));	
		model.addAttribute("gsPathInfo3", selectCheck8Map.get("PATH_INFO_3"));
		model.addAttribute("gsPathInfo4", selectCheck8Map.get("PATH_INFO_4"));

		/**
		 * 세부구분항목 명칭 참조
		 */
		Map selectCheck9Map = (Map)afb700ukrService.selectCheck9(param);
		if(ObjUtils.isEmpty(selectCheck9Map) || selectCheck9Map.get("BIZ_GUBUN_NAME").equals("")) {
//		if(selectCheck9Map.get("BIZ_GUBUN_NAME").equals("")){
			model.addAttribute("gsBizGubunName", "세부구분항목");
		}else{
			model.addAttribute("gsBizGubunName", selectCheck9Map.get("BIZ_GUBUN_NAME"));
		}
		
		/**
		 * 지출결의_승인버튼 사용자ID
		 */
		Map selectCheck10Map = (Map)afb700ukrService.selectCheck10(param);
		if(ObjUtils.isEmpty(selectCheck10Map) || selectCheck10Map.get("SUB_CODE").equals("")) {
//		if(selectCheck10Map.get("SUB_CODE").equals("")){
			model.addAttribute("gsAppBtnUser", "N");
		}else{
			model.addAttribute("gsAppBtnUser", "Y");
		}

		
		return JSP_PATH+"afb700ukr";
	}
	/**
	 * 지출결의내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb700skr.do",method = RequestMethod.GET)
	public String afb700skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));	
			
		return JSP_PATH + "afb700skr";
	}
	
	/**
	 * 지출부조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb710skr.do",method = RequestMethod.GET)
	public String afb710skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));	
			
		return JSP_PATH + "afb710skr";
	}
	
	/**
	 * 세부항목별 예산집계표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb720skr.do",method = RequestMethod.GET)
	public String afb720skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		Map selectCheck1Map = (Map)afb720skrService.selectCheck1(param);
		model.addAttribute("gsDateOpt", selectCheck1Map.get("SUB_CODE"));
		
		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));	
		
		List<Map<String, Object>> bizGubunAllList = afb720skrService.selectbizGubunAll(param, loginVO);			
		model.addAttribute("bizGubunAllList",ObjUtils.toJsonStr(bizGubunAllList));	
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		return JSP_PATH + "afb720skr";
	}
	
	/**
	 * 지출예산통제원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb730skr.do",method = RequestMethod.GET)
	public String afb730skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
//		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);			
//		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));	
//			
		return JSP_PATH + "afb730skr";
	}
	
	/**
	 * 지출예산통제원장
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/s_afb730ukr_gl.do",method = RequestMethod.GET)
	public String s_afb730ukr_gl(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		return JSP_PATH + "s_afb730ukr_gl";
	}
	
	@RequestMapping(value="/accnt/afb800skr.do")
	public String afb800skr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//param에 COMP_CODE 정보 추가
		param.put("S_COMP_CODE",loginVO.getCompCode());

		//CODE_NAME 가져오기
		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));	
		
		return JSP_PATH+"afb800skr";
	}
	
	/**
	 * 수입결의등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afb800ukr.do")
	public String afb800ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		/**
		 * 예산과목구분 가져오기
		 */
		List<Map<String, Object>> budgNameList = accntCommonService.selectBudgName(param, loginVO);					
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		/**
		 * 문서서식구분 콤보 관련
		 */
		List<CodeDetailVO> gsListA171 = codeInfo.getCodeList("A171", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsListA171)	{
			if("0".equals(map.getRefCode2()) || "2".equals(map.getRefCode2()))	{
				if(list1.equals("")){
				list1 =  map.getCodeNo();
				}else{
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsListA171", list1);
		
		
		/**
		 * 기본 셋팅 값 관련
		 */
		param.put("COL","AMT_POINT");
		Map fnGetAccntBasicInfo_aMap = (Map)accntCommonService.fnGetAccntBasicInfo_a(param);
		model.addAttribute("gsAmtPoint", fnGetAccntBasicInfo_aMap.get("OPTION"));
		

		/**
		 * 공공예산관련 옵션 
		 */
		Map selectCheck1Map = (Map)afb800ukrService.selectCheck1(param);
		model.addAttribute("gsIdMapping", selectCheck1Map.get("MAPPING"));
		model.addAttribute("gsLinkedGW", selectCheck1Map.get("GWIF"));
		
		/**
		 * 수입결의 - 회계구분 기본값 설정 
		 */
		Map selectCheck2Map = (Map)afb800ukrService.selectCheck2(param);
		model.addAttribute("gsAccntGubun", selectCheck2Map.get("ACCNT_GUBUN"));

		/**
		 * 회계담당자
		 */
		Map selectCheck3Map = (Map)afb800ukrService.selectCheck3(param);
		model.addAttribute("gsChargeCode", selectCheck3Map.get("CHARGE_CODE"));
		model.addAttribute("gsChargeDivi", selectCheck3Map.get("CHARGE_DIVI"));

		/**
		 * 로그인사용자의 사번, 이름, 예산부서, 사업장
		 */
		Map selectCheck4Map = (Map)afb800ukrService.selectCheck4(param);
		model.addAttribute("gsDrafter", selectCheck4Map.get("PERSON_NUMB"));	
		model.addAttribute("gsDrafterNm", selectCheck4Map.get("NAME"));
		model.addAttribute("gsDeptCode", selectCheck4Map.get("DEPT_CODE"));
		model.addAttribute("gsDeptName", selectCheck4Map.get("DEPT_NAME"));
		model.addAttribute("gsDivCode", selectCheck4Map.get("DIV_CODE"));

		/**
		 * 수입결의_수정자ID
		 */
		Map selectCheck5Map = (Map)afb800ukrService.selectCheck5(param);
		if(ObjUtils.isEmpty(selectCheck5Map) || selectCheck5Map.get("SUB_CODE").equals("")) {
//		if(selectCheck5Map.get("SUB_CODE").equals("")){
			model.addAttribute("gsAmender", "N");
		}else{
			model.addAttribute("gsAmender", "Y");
		}

		/**
		 * 영수구분 기본값
		 */
		Map selectCheck6Map = (Map)afb800ukrService.selectCheck6(param);
//		if(selectCheck6Map.get("BILL_GUBUN").equals("")){ //테스트 필
//			model.addAttribute("gsBillGubun", "");
//		}else{
			model.addAttribute("gsBillGubun", selectCheck6Map.get("BILL_GUBUN"));
//		}

		/**
		 * 계산서적요 기본값
		 */
		Map selectCheck7Map = (Map)afb800ukrService.selectCheck7(param);
//		if(selectCheck7Map.get("BILL_REMARK").equals("")){ //테스트 필
//			model.addAttribute("gsBillRemark", "");
//		}else{
			model.addAttribute("gsBillRemark", selectCheck7Map.get("BILL_REMARK"));
//		}

		/**
		 * 결재상신 경로정보
		 */
		Map selectCheck8Map = (Map)afb800ukrService.selectCheck8(param);
		model.addAttribute("gsPathInfo1", selectCheck8Map.get("PATH_INFO_1"));	
		model.addAttribute("gsPathInfo3", selectCheck8Map.get("PATH_INFO_3"));
		model.addAttribute("gsPathInfo4", selectCheck8Map.get("PATH_INFO_4"));


		
		return JSP_PATH+"afb800ukr";
	}
	
	/**
	 * 자금이체등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/accnt/afb900ukr.do")
	public String afb900ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		/**
		 * 프로그램별 사용 컬럼 관련	
		 */
		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "afb900ukr");
		param.put("SHEET_ID", "grdSheet1");
		List<Map<String, Object>> useColList1 = accntCommonService.getUseColList(param);				
		model.addAttribute("useColList1",ObjUtils.toJsonStr(useColList1));	

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "afb900ukr");
		param.put("SHEET_ID", "grdSheet2");
		List<Map<String, Object>> useColList2 = accntCommonService.getUseColList(param);				
		model.addAttribute("useColList2",ObjUtils.toJsonStr(useColList2));	
		
		/**
		 * 이체지급등록 브랜치연계 사용
		 */
		Map selectCheck1Map = (Map)afb900ukrService.selectCheck1(param);
		model.addAttribute("gsBranchUse", selectCheck1Map.get("BRANCH_USE"));
		
		if(selectCheck1Map.get("BRANCH_USE").equals("Y")){
			model.addAttribute("gsModelName", "Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,"
					+ "	listeners: {"
					+ "select: function(grid, selectRecord, index, rowIndex, eOpts ){"
					+ "var sm = detailGrid.getSelectionModel();"
					+ "var selRecords = detailGrid.getSelectionModel().getSelection();"
					+ "var records = directDetailStore.data.items;"
					+ "Ext.each(records, function(record, index){"
					+ "if(selectRecord.get('PROV_DRAFT_NO') == record.get('PROV_DRAFT_NO')){selRecords.push(record);}"
					+ "});"
					+ "sm.select(selRecords);"
					+ "},"
					+ "deselect:  function(grid, selectRecord, index, eOpts ){"
					+ "var sm = detailGrid.getSelectionModel();"
					+ "var selRecords = detailGrid.getSelectionModel().getSelection();"
					+ "var records = directDetailStore.data.items;"
					+ "Ext.each(records, function(record, index){"
					+ "if(selectRecord.get('PROV_DRAFT_NO') != record.get('PROV_DRAFT_NO')){selRecords.splice(0, 10000);}"
					+ "});"
					+ "Ext.each(records, function(record, index){"
					+ "if(selectRecord.get('PROV_DRAFT_NO') == record.get('PROV_DRAFT_NO')){selRecords.push(record);}"
					+ "});"
					+ "sm.deselect(selRecords);"
					+ "}"
					+ "}"
					+ "})");
		}else{
			model.addAttribute("gsModelName", "'rowmodel'");
		}
		/**
		 * 브랜치연계 시스템명
		 */
		Map selectCheck2Map = (Map)afb900ukrService.selectCheck2(param);
		model.addAttribute("gsBranchName", selectCheck2Map.get("BRANCH_NAME"));
		
		
/*		*//**
		 * 브랜치 관련
		 *//*
		ObjectMapper mapper = new ObjectMapper();
		List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("data"))),
		TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));
		
		afb900ukrService.sendBranchTest(paramList);
		*/
		return JSP_PATH+"afb900ukr";
	}

/*	@RequestMapping(value="/accnt/sendBranchTest", method = RequestMethod.POST)
	  public  boolean sendBranchTest( ExtHtttprequestParam _req, LoginVO loginVO) throws Exception {
		
		*//**
		 * 브랜치 관련
		 *//*
		ObjectMapper mapper = new ObjectMapper();
		List<Map> paramList = mapper.readValue( ObjUtils.getSafeString((_req.getP("dataDetail"))),
		TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));
		Map paramMaster = mapper.readValue( ObjUtils.getSafeString((_req.getP("dataMaster"))),
		TypeFactory.defaultInstance().constructCollectionType(List.class,   Map.class));
		afb900ukrService.sendBranchTest(paramList,paramMaster,loginVO);
		
		return true;
	}*/
	
	/**
	 * 예산마감등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb010ukr.do",method = RequestMethod.GET)
	public String afb010ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		

		return JSP_PATH + "afb010ukr";
	}
	/**
	 * 예산업무설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb300ukr.do",method = RequestMethod.GET)
	public String afb300ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		

		return JSP_PATH + "afb300ukr";
	}
	/**
	 * 예산코드등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb400ukr.do",method = RequestMethod.GET)
	public String afb400ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		

		return JSP_PATH + "afb400ukr";
	}
	/**
	 * 부서별예산코드등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb410ukr.do",method = RequestMethod.GET)
	public String afb410ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		

		return JSP_PATH + "afb410ukr";
	}
	/**
	 * 예산총괄표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb500skr.do",method = RequestMethod.GET)
	public String afb500skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		
		List<Map<String, Object>> chargeGubunList = afb500skrService.selectChargeGubun(param);		// 집계구분 셋팅		
		model.addAttribute("chargeGubunList",ObjUtils.toJsonStr(chargeGubunList));
		
		List<Map<String, Object>> amtPointList = afb500skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));
		

		return JSP_PATH + "afb500skr";
	}
	/**
	 * 예산편성입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb500ukr.do",method = RequestMethod.GET)
	public String afb500ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		

		return JSP_PATH + "afb500ukr";
	}
	@RequestMapping(value="/accnt/afb501ukr.do")
	public String afb501ukr(	)throws Exception{
		return JSP_PATH+"afb501ukr";
	}
	/**
	 * 예산실적비교표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb510skr.do",method = RequestMethod.GET)
	public String afb510skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		
		List<Map<String, Object>> chargeGubunList = afb510skrService.selectChargeGubun(param);		// 집계구분 셋팅		
		model.addAttribute("chargeGubunList",ObjUtils.toJsonStr(chargeGubunList));
		
		List<Map<String, Object>> amtPointList = afb510skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));

		return JSP_PATH + "afb510skr";
	}
	/**
	 * 예산확정입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb510ukr.do",method = RequestMethod.GET)
	public String afb510ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));

		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		

		return JSP_PATH + "afb510ukr";
	}
	/**
	 * 비교수지예산표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb520skr.do",method = RequestMethod.GET)
	public String afb520skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		
		List<Map<String, Object>> amtPointList = afb555skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));
		
		return JSP_PATH + "afb520skr";
	}
	/**
	 * 예산전용/배정입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb520ukr.do",method = RequestMethod.GET)
	public String afb520ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());			
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> chargeInfoList = afb520ukrService.selectChargeInfo(param);	// ChargeCode 가져오기
		model.addAttribute("chargeInfoList",ObjUtils.toJsonStr(chargeInfoList));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		// 부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		
		return JSP_PATH + "afb520ukr";
	}
	/**
	 * 예산이월입력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb530ukr.do",method = RequestMethod.GET)
	public String afb530ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<Map<String, Object>> chargeInfoList = afb530ukrService.selectChargeInfo(param);	// 사용자ID로부터 회계담당자 코드, 담당자명, 사용부서, 사번 정보 가져오기
		model.addAttribute("chargeInfoList",ObjUtils.toJsonStr(chargeInfoList));
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);				//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> getToDt = accntCommonService.fnGetToDt(param);				//당기종료년월		
		model.addAttribute("getToDt",ObjUtils.toJsonStr(getToDt));

		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));
		

		return JSP_PATH + "afb530ukr";
	}
	/**
	 * 예산집행현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb540skr.do",method = RequestMethod.GET)
	public String afb540skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);					
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		List<Map<String, Object>> chargeGubunList = afb540skrService.selectChargeGubun(param);		// 집계구분 셋팅		
		model.addAttribute("chargeGubunList",ObjUtils.toJsonStr(chargeGubunList));
		
		List<Map<String, Object>> amtPointList = afb540skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));
		

		return JSP_PATH + "afb540skr";
	}
	/**
	 * 예산전용/배정승인
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb540ukr.do",method = RequestMethod.GET)
	public String afb540ukr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		

		return JSP_PATH + "afb540ukr";
	}
	/**
	 * 예산실적 재집계
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb550ukr.do",method = RequestMethod.GET)
	public String afb550ukr(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		

		return JSP_PATH + "afb550ukr";
	}
	/**
	 * 예산집행상세내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb555skr.do",method = RequestMethod.GET)
	public String afb555skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		
		List<Map<String, Object>> amtPointList = afb555skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));

		return JSP_PATH + "afb555skr";
	}
	
	/**
	 * 예산집행상세내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb551skr.do",method = RequestMethod.GET)
	public String afb551skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		
		List<Map<String, Object>> amtPointList = afb555skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));

		return JSP_PATH + "afb551skr";
	}
	
	/**
	 * 예산집행상세내역조회2
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb556skr.do",method = RequestMethod.GET)
	public String afb556skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		
		List<Map<String, Object>> amtPointList = afb555skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));

		return JSP_PATH + "afb556skr";
	}
	/**
	 * 예산전용내역조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accnt/afb560skr.do",method = RequestMethod.GET)
	public String afb560skr(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);		//당기시작년월		
		model.addAttribute("getStDt",ObjUtils.toJsonStr(getStDt));
		
		List<Map<String, Object>> budgNameList = afb600skrService.selectBudgName(param);		//부서목록 조회			
		model.addAttribute("budgNameList",ObjUtils.toJsonStr(budgNameList));

		
		List<Map<String, Object>> amtPointList = afb560skrService.selectAmtPoint(param);		//AMT_POINT 조회			
		model.addAttribute("amtPointList",ObjUtils.toJsonStr(amtPointList));
		

		return JSP_PATH + "afb560skr";
	}
	
}