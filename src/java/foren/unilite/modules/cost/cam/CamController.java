package foren.unilite.modules.cost.cam;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.cost.CostCommonServiceImpl;
import foren.unilite.modules.cost.cbm.Cbm700ukrvServiceImpl;

@Controller
public class CamController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String JSP_PATH = "/cost/cam/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="costCommonService")
	private CostCommonServiceImpl costCommonService;
	
	@Resource(name="cam100ukrvService")
	private Cam100ukrvServiceImpl cam100ukrvService;
	
	@Resource(name="cam110ukrvService")
	private Cam110ukrvServiceImpl cam110ukrvService;
	
	@Resource(name="cam120ukrvService")
	private Cam120ukrvServiceImpl cam120ukrvService;
	
	@Resource(name="cam310skrvService")
	private Cam310skrvServiceImpl cam310skrvService;

	@Resource(name="cam315skrvService")
	private Cam315skrvServiceImpl cam315skrvService;

	@Resource(name="cbm700ukrvService")
	private Cbm700ukrvServiceImpl cbm700ukrvService;

 	/**
	 * 원가계산
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam100ukrv.do")
	public String cam100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		Map param = new HashMap();
 		param.put("S_COMP_CODE", loginVO.getCompCode());
 		List<Map<String,Object>> costPoolList = cbm700ukrvService.selectList2(param);
		int i = 0;
		int nProduct = 0;
		int nSupport = 0;
		String[] COST_POOL_NAME = new  String[costPoolList.size()];
		for(Map<String, Object> costPool : costPoolList){
			if("01".equals(ObjUtils.getSafeString(costPool.get("COST_POOL_GB"))))	{
				nProduct++;
			}else {
				nSupport++;
			}
		}

		model.addAttribute("COST_POOL_LIST", ObjUtils.toJsonStr(costPoolList));
		model.addAttribute("NUM_PRODUCT", ObjUtils.getSafeString(nProduct));
		model.addAttribute("NUM_SUPPORT", ObjUtils.getSafeString(nSupport));
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
		Map costYear  = costCommonService.selectDivYearEvaluation(param, loginVO);
		String yearEvaluationYN = ObjUtils.getSafeString(costYear.get("YEAR_EVALUATION_YN"));
		String frMonth = ObjUtils.getSafeString(costYear.get("FR_MONTH"));
		model.addAttribute("YEAR_EVALUATION_YN", yearEvaluationYN);
		model.addAttribute("FR_MONTH", frMonth);
		
		param.put("DIV_CODE", loginVO.getDivCode());
		Map<String, Object> lastWorkInfo = (Map<String, Object>) cam100ukrvService.selectLastWorkInfo(param);
		Map<String, Object> lastCloseInfo = (Map<String, Object>) cam100ukrvService.selectLastCloseInfo(param);
		if(lastWorkInfo != null)	{
			model.addAttribute("lastWorkInfo", ObjUtils.toJsonStr(lastWorkInfo));
		}else {
			model.addAttribute("lastWorkInfo", "{}");
		}
		if(lastCloseInfo != null)	{
			model.addAttribute("lastCloseInfo", ObjUtils.toJsonStr(lastCloseInfo));
		}else {
			model.addAttribute("lastCloseInfo", "{}");
		}
		
		return JSP_PATH + "cam100ukrv";
	}

 	/**
	 * 원가계산(누적집계)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam110ukrv.do")
	public String cam110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		Map param = new HashMap();
 		param.put("S_COMP_CODE", loginVO.getCompCode());
 		List<Map<String,Object>> costPoolList = cbm700ukrvService.selectList2(param);
		int i = 0;
		int nProduct = 0;
		int nSupport = 0;
		String[] COST_POOL_NAME = new  String[costPoolList.size()];
		for(Map<String, Object> costPool : costPoolList){
			if("01".equals(ObjUtils.getSafeString(costPool.get("COST_POOL_GB"))))	{
				nProduct++;
			}else {
				nSupport++;
			}
		}
		
		model.addAttribute("COST_POOL_LIST", ObjUtils.toJsonStr(costPoolList));
		model.addAttribute("NUM_PRODUCT", ObjUtils.getSafeString(nProduct));
		model.addAttribute("NUM_SUPPORT", ObjUtils.getSafeString(nSupport));
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
		Map costYear  = costCommonService.selectDivYearEvaluation(param, loginVO);
		String yearEvaluationYN = ObjUtils.getSafeString(costYear.get("YEAR_EVALUATION_YN"));
		String frMonth = ObjUtils.getSafeString(costYear.get("FR_MONTH"));
		model.addAttribute("YEAR_EVALUATION_YN", yearEvaluationYN);
		model.addAttribute("FR_MONTH", frMonth);
		
		param.put("DIV_CODE", loginVO.getDivCode());
		Map<String, Object> lastWorkInfo = (Map<String, Object>) cam110ukrvService.selectLastWorkInfo(param);
		Map<String, Object> lastCloseInfo = (Map<String, Object>) cam110ukrvService.selectLastCloseInfo(param);
		if(lastWorkInfo != null)	{
			model.addAttribute("lastWorkInfo", ObjUtils.toJsonStr(lastWorkInfo));
		}else {
			model.addAttribute("lastWorkInfo", "{}");
		}
		if(lastCloseInfo != null)	{
			model.addAttribute("lastCloseInfo", ObjUtils.toJsonStr(lastCloseInfo));
		}else {
			model.addAttribute("lastCloseInfo", "{}");
		}
		return JSP_PATH + "cam110ukrv";
	}
 	
 	/**
	 * 원가계산
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam120ukrv.do")
	public String cam120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		Map param = new HashMap();
 		param.put("S_COMP_CODE", loginVO.getCompCode());
 		List<Map<String,Object>> costPoolList = cbm700ukrvService.selectList2(param);
		int i = 0;
		int nProduct = 0;
		int nSupport = 0;
		String[] COST_POOL_NAME = new  String[costPoolList.size()];
		for(Map<String, Object> costPool : costPoolList){
			if("01".equals(ObjUtils.getSafeString(costPool.get("COST_POOL_GB"))))	{
				nProduct++;
			}else {
				nSupport++;
			}
		}

		model.addAttribute("COST_POOL_LIST", ObjUtils.toJsonStr(costPoolList));
		model.addAttribute("NUM_PRODUCT", ObjUtils.getSafeString(nProduct));
		model.addAttribute("NUM_SUPPORT", ObjUtils.getSafeString(nSupport));
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
		Map costYear  = costCommonService.selectDivYearEvaluation(param, loginVO);
		String yearEvaluationYN = ObjUtils.getSafeString(costYear.get("YEAR_EVALUATION_YN"));
		String frMonth = ObjUtils.getSafeString(costYear.get("FR_MONTH"));
		model.addAttribute("YEAR_EVALUATION_YN", yearEvaluationYN);
		model.addAttribute("FR_MONTH", frMonth);
		
		param.put("DIV_CODE", loginVO.getDivCode());
		Map<String, Object> lastWorkInfo = (Map<String, Object>) cam120ukrvService.selectLastWorkInfo(param);
		Map<String, Object> lastCloseInfo = (Map<String, Object>) cam120ukrvService.selectLastCloseInfo(param);
		if(lastWorkInfo != null)	{
			model.addAttribute("lastWorkInfo", ObjUtils.toJsonStr(lastWorkInfo));
		}else {
			model.addAttribute("lastWorkInfo", "{}");
		}
		if(lastCloseInfo != null)	{
			model.addAttribute("lastCloseInfo", ObjUtils.toJsonStr(lastCloseInfo));
		}else {
			model.addAttribute("lastCloseInfo", "{}");
		}
		
		return JSP_PATH + "cam120ukrv";
	}

 	/**
	 * 원가계산내역조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam100skrv.do")
	public String cam100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		return JSP_PATH + "cam100skrv";
	}
 	/**
	 * 품목별 배부기준내역 조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam010skrv.do")
	public String cam010skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		Map param = new HashMap();
 		param.put("S_COMP_CODE", loginVO.getCompCode());
 		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		return JSP_PATH + "cam010skrv";
	}
 	/**
	 * 품목별 재료비투입 내역 조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam400skrv.do")
	public String cam400skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
 		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		return JSP_PATH + "cam400skrv";
	}
 	/**
	 * 부문별 배부기준내역 조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam020skrv.do")
	public String cam020skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		Map<String, Object> param = new HashMap();
 		param.put("S_COMP_CODE", loginVO.getCompCode());
 		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		
		return JSP_PATH + "cam020skrv";
	}
 	
 	/**
	 * 간접재료비 품목별 집계현황(1단계)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam210skrv.do")
	public String cam210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		
		return JSP_PATH + "cam210skrv";
	}
 	/**
	 * 부문별 제조경비 집계내역 조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam310skrv.do")
	public String cam310skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("USE_YN", "Y");

		List<Map<String, Object>> costPool = cbm700ukrvService.selectList2(param);
		model.addAttribute("COST_POOL_LIST", ObjUtils.isNotEmpty(costPool) ? JsonUtils.toJsonStr(costPool): "[]");
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		
		return JSP_PATH + "cam310skrv";
	}
 	/**
	 * 부문별 제조경비 배부내역 조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam315skrv.do")
	public String cam315skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		List<Map<String, Object>> costpool = cam315skrvService.selectCostPoolList(param, loginVO);
		model.addAttribute("COST_POOL_LIST", ObjUtils.isNotEmpty(costpool) ? JsonUtils.toJsonStr(costpool): "[]");
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		return JSP_PATH + "cam315skrv";
	}

 	/**
	 * 제조경비 사용자 입력
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam350ukrv.do")
	public String cam350skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("USE_YN", "Y");
		
		List<Map<String, Object>> costPool = cbm700ukrvService.selectList2(param);
		model.addAttribute("COST_POOL_LIST", ObjUtils.isNotEmpty(costPool) ? JsonUtils.toJsonStr(costPool): "[]");

		return JSP_PATH + "cam350ukrv";
	}
 	/**
	 * 품목별 원가계산내역 조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam450skrv.do")
	public String cam450skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		return JSP_PATH + "cam450skrv";
	}
 	
	/**
	 * 품목별 원가집계표(투입비율)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam451skrv.do")
	public String cam451skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		
		return JSP_PATH + "cam451skrv";
	}

 	/**
	 * 장비별 원가집계표(투입비율)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam452skrv.do")
	public String cam452skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		
		return JSP_PATH + "cam452skrv";
	}
 	/**
	 * 품목별 원가집계표 (재공포함)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam453skrv.do")
	public String cam453skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO wipYN = codeInfo.getCodeInfo("CA12","10");
		if(wipYN == null || !ObjUtils.isEmpty(wipYN))	{
			model.addAttribute("WIP_YN",ObjUtils.getSafeString(wipYN.getRefCode1(),"N"));
		} else {
			model.addAttribute("WIP_YN", "N");
		}
		return JSP_PATH + "cam453skrv";
	}
 	/**
	 * 비목을 부문별로 집계시 배부기준 등록
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam030ukrv.do")
	public String cam030ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
 		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("DIV_CODE", loginVO.getDivCode());
 		model.addAttribute("COST_POOL", cbm700ukrvService.selectCombo(param));
		return JSP_PATH + "cam030ukrv";
	}

 	/**
	 * 비목을 부문별로 집계시 배부기준 등록
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam040ukrv.do")
	public String cam040ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
 		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		param.put("COST_POOL_GB", "01");
 		model.addAttribute("COST_POOL", cbm700ukrvService.selectCombo(param));
		return JSP_PATH + "cam040ukrv";
	}

	/**
	 * 품목별 원가계산내역 조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cam460skrv.do")
	public String cam460skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		
		param.put("S_DIV_CODE", loginVO.getDivCode());
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
		
		return JSP_PATH + "cam460skrv";
	}
 	/*
 	 * 원가 수불 이력 조회
 	 */
 	@RequestMapping(value = "/cost/cam500skrv.do")
	public String cam500skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		
		return JSP_PATH + "cam500skrv";
	}
}