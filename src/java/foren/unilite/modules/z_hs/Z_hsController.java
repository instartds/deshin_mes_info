package foren.unilite.modules.z_hs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
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
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.eis.em.Ems100skrvServiceImpl;
import foren.unilite.modules.human.HumanCommonServiceImpl;

@Controller
public class Z_hsController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_hs/";
	
	@Resource(name="UniliteComboServiceImpl")
    private ComboServiceImpl comboService;
	
	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;
	
    @Resource( name = "humanCommonService" )
    private HumanCommonServiceImpl humanCommonService;
    
    @Resource( name = "accntCommonService" )
    private AccntCommonServiceImpl accntCommonService;
	
    @Resource( name = "s_hat910ukr_hsService" )
    private S_Hat910ukr_hsServiceImpl       s_hat910ukr_hsService;
    
    @Resource( name = "s_hat530rkr_hsService" )
    private S_Hat530rkr_hsServiceImpl       s_hat530rkr_hsService;
    
    @Resource( name = "s_afs100rkr_hsService" )
    private S_Afs100rkr_hsServiceImpl       s_afs100rkr_hsService;
    
	@Resource( name = "s_pmr140rkrv_hsService" )
	private S_Pmr140rkrv_hsServiceImpl s_pmr140rkrv_hsService;

	@Resource(name="ems100skrvService")
	private Ems100skrvServiceImpl ems100skrvService;

	
	
	@Resource( name = "s_emp100skr_hsService" )
	private S_emp100skr_hsServiceImpl s_emp100skr_hsService;
	
	@Resource( name = "s_emp110skr_hsService" )
	private S_emp110skr_hsServiceImpl s_emp110skr_hsService;

	@Resource(name="s_emp120skrv_hsService")
	private S_Emp120skrv_hsServiceImpl s_emp120skrv_hsService;

	@Resource(name="s_emp130skrv_hsService")
	private S_Emp130skrv_hsServiceImpl s_emp130skrv_hsService;

    @RequestMapping( value = "/z_hs/s_hat910ukr_hs.do" )
    public String s_hat910ukr_hs(LoginVO loginVO, ModelMap model ) throws Exception {
    	
        Gson gson = new Gson();
        String dutyRule = s_hat910ukr_hsService.getDutyRule(loginVO.getCompCode());
        
        Map<String, String> param = new HashMap<String, String>();
        param.put("S_COMP_CODE", loginVO.getCompCode());
        param.put("DUTY_RULE", dutyRule);
        param.put("PAY_CODE", "0");
        String colData = gson.toJson(s_hat910ukr_hsService.getDutycode(param));
        model.addAttribute("dutyRule", dutyRule);
        model.addAttribute("colData", colData);
        
        List<ComboItemModel> attendList = s_hat910ukr_hsService.getComboList(param);
        model.addAttribute("COMBO_ATTEND", attendList);

        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        
        boolean gsBUseColHidden = false;
        
        List<CodeDetailVO> gsUseColHidden = codeInfo.getCodeList("H175", "", false);
        for (CodeDetailVO map : gsUseColHidden) {
            if ("18".equals(map.getCodeNo()) && "Y".equals(map.getRefCode1())) {
            	gsBUseColHidden = true;
            }
        }
        model.addAttribute("gsBUseColHidden", gsBUseColHidden);
        
        return JSP_PATH + "s_hat910ukr_hs";
    }
    
    @RequestMapping( value = "/z_hs/s_hat530rkr_hs.do" )
    public String s_hat530rkr_hs() throws Exception {
        return JSP_PATH + "s_hat530rkr_hs";
    }
    
	/**
	 * 출퇴근현황
	 * @param _req
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/z_hs/s_hat530rkr_hsExcelDownLoad.do")
	public ModelAndView bpr130ukrvDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		
		Workbook wb = s_hat530rkr_hsService.makeExcelData(paramMap);
		String title = "출퇴근현황";
		
		return ViewHelper.getExcelDownloadView(wb, title);
	}
	
    /**
     * 전표출력
     * 
     * @return
     * @throws Exception
     */
    @SuppressWarnings( { "unused" } )
    @RequestMapping( value = "/z_hs/s_agj270skr_hs.do", method = RequestMethod.GET )
    public String s_agj270skr_hs( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
        
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");
        
        param.put("S_COMP_CODE", loginVO.getCompCode());
        
        CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;
        //입력자 코드/명
        param.put("S_USER_ID", loginVO.getUserID());
        Map chargeMap = (Map)accntCommonService.fnGetChargeInfo(param);
        if (ObjUtils.isNotEmpty(chargeMap)) {
            model.addAttribute("chargeCode", chargeMap.get("CHARGE_CODE"));
            model.addAttribute("chargeName", chargeMap.get("CHARGE_NAME"));
            model.addAttribute("chargeDivi", chargeMap.get("CHARGE_DIVI"));
            model.addAttribute("chargePNumb", chargeMap.get("CHARGE_PNUMB"));
        } else {
        	model.addAttribute("chargeCode", "");
            model.addAttribute("chargeName", "");
            model.addAttribute("chargeDivi", "");
            model.addAttribute("chargePNumb", "");
        }
        //List<Map<String, Object>> getReturnYn = accntCommonService.fnGetAccntBasicInfo(param);		//프린트		
        //model.addAttribute("getReturnYn",ObjUtils.toJsonStr(getReturnYn));
        
        return JSP_PATH + "s_agj270skr_hs";
    }
    
	@RequestMapping(value = "/z_hs/s_pmp200rkrv_hs.do")
	public String s_pmp200rkrv_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmp200rkrv_hs";
	}
	
	/* 자금일보
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_hs/s_afs100rkr_hs.do")
	public String s_afs100rkr_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		List<Map<String, Object>> getStDt = accntCommonService.fnGetStDt(param);        //당기시작년월        
        model.addAttribute("getStDt", ObjUtils.toJsonStr(getStDt));
        

		return JSP_PATH + "s_afs100rkr_hs";
	}
	/*
	 * 자금일보
	 * @param _req
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/z_hs/s_afs100rkr_hsExcelDownLoad.do")
	public ModelAndView s_afs100rkr_hsDownLoadExcel(ExtHtttprequestParam _req, LoginVO login, HttpServletResponse response) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		
		Workbook wb = s_afs100rkr_hsService.makeExcelData(paramMap, login);
		String title = "자금일보";
		
		return ViewHelper.getExcelDownloadView(wb, title);
	}
	
	@SuppressWarnings( { "unused" } )
	@RequestMapping( value = "/z_hs/s_pmr140rkrv_hs.do" )
	public String s_pmr140rkrv_hs( ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_pmr140rkrv_hs";
	}
	
	@RequestMapping(value = "/z_hs/s_pmr140rkrv_hsExcelDown.do")
	public ModelAndView s_pmr140rkrv_hsDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response, LoginVO login) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		String templateType = ObjUtils.getSafeString(paramMap.get("TEMPLATE_TYPE"));
		Workbook wb = null;
		String title = "일일업무보고";
		if("1".equals(templateType))	{
			 wb = s_pmr140rkrv_hsService.makeExcel1(paramMap, login);
			 title = "공장업무일지";
		} else {
			wb = s_pmr140rkrv_hsService.makeExcel2(paramMap, login);
			 title = "제품원재료수불명세서";
		}
        return ViewHelper.getExcelDownloadView(wb, title);
	}

	/**
	 * 생산현황
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_hs/s_emp100skrv_hs.do" )
		public String s_emp100skrv_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			model.addAttribute("CSS_TYPE", "-largeEis");
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			param.put("S_COMP_CODE",loginVO.getCompCode());
			param.put("PGM_ID", "s_emp100skrv_hs");

			String nextPgmId = ems100skrvService.selectNextPgmId(param);
			Integer interval = ems100skrvService.selectNextPgmInterval(param);

			model.addAttribute("nextPgmId", nextPgmId);
			model.addAttribute("glInterval", interval);
			
			List<Map> exchgList = s_emp100skr_hsService.selectExchg(param);

			model.put("exchgList", JsonUtils.toJsonStr(exchgList));
			
			return JSP_PATH + "s_emp100skrv_hs";
	}
	
	/**
	 * 출하현황
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_hs/s_emp110skrv_hs.do" )
		public String s_emp110skrv_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			model.addAttribute("CSS_TYPE", "-largeEis");
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			param.put("S_COMP_CODE",loginVO.getCompCode());
			param.put("PGM_ID", "s_emp110skrv_hs");

			String nextPgmId = ems100skrvService.selectNextPgmId(param);
			Integer interval = ems100skrvService.selectNextPgmInterval(param);

			model.addAttribute("nextPgmId", nextPgmId);
			model.addAttribute("glInterval", interval);
			
			List<Map> exchgList = s_emp110skr_hsService.selectExchg(param);

			model.put("exchgList", JsonUtils.toJsonStr(exchgList));
			
			return JSP_PATH + "s_emp110skrv_hs";
	}
	
	@RequestMapping(value = "/z_hs/s_emp120skrv_hs.do" )
	public String s_emp120skrv_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_emp120skrv_hs");

		String nextPgmId = ems100skrvService.selectNextPgmId(param);
		Integer interval = ems100skrvService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> exchgList = s_emp120skrv_hsService.selectExchg(param);

		model.put("exchgList", JsonUtils.toJsonStr(exchgList));
		
		return JSP_PATH + "s_emp120skrv_hs";
	}
	
	@RequestMapping(value = "/z_hs/s_emp130skrv_hs.do" )
	public String s_emp130skrv_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("PGM_ID", "s_emp130skrv_hs");

		String nextPgmId = ems100skrvService.selectNextPgmId(param);
		Integer interval = ems100skrvService.selectNextPgmInterval(param);

		model.addAttribute("nextPgmId", nextPgmId);
		model.addAttribute("glInterval", interval);
		
		List<Map> exchgList = s_emp130skrv_hsService.selectExchg(param);

		model.put("exchgList", JsonUtils.toJsonStr(exchgList));
		
		return JSP_PATH + "s_emp130skrv_hs";
	}

	/**
	 * 미결현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_hs/s_agb160skr_hs.do")
	public String s_agb160skr_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		List<Map<String, Object>> getChargeCode = accntCommonService.fnGetChargeCode(param, loginVO);		// ChargeCode관련
		model.addAttribute("getChargeCode",ObjUtils.toJsonStr(getChargeCode));

		return JSP_PATH + "s_agb160skr_hs";
	}

	/**
	 * 미결현황출력
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/z_hs/s_agb160rkr_hs.do")
	public String s_agb160rkr_hs(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model)throws Exception{
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
			if("s_agb160rkr_hs".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "s_agb160rkr_hs";
	}

}
