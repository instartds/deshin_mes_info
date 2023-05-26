package foren.unilite.modules.cost.cbm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.cost.CostCommonServiceImpl;

@Controller
public class CbmController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String	JSP_PATH = "/cost/cbm/";	
	
	
	@Resource(name = "costCommonService")
    private CostCommonServiceImpl costCommonService;
	
	@Resource( name = "tlabCodeService" )
    protected TlabCodeService tlabCodeService;
	
	@Resource(name = "cbm140ukrvService")
    private Cbm140ukrvServiceImpl cbm140ukrvService;
	
	/**
	 * 원가업무설정(유형1)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm010ukrv.do")
	public String cbm010ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = _req.getParameterMap();
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO applyType = codeInfo.getCodeInfo("CC05","ref_code1", "Y");
		model.addAttribute("applyType",applyType.getCodeNo());
		
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC06","ref_code1", "Y");
		model.addAttribute("applyUnit",applyUnit.getCodeNo());
		
		CodeDetailVO distKind = codeInfo.getCodeInfo("C101","ref_code1", "Y");
		model.addAttribute("distKind",distKind.getCodeNo());
		
		return JSP_PATH + "cbm010ukrv";
	}
	
	/**
	 * 기본정보등록(유형1)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm020ukrv.do")
	public String cbm020ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = _req.getParameterMap();
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC06","ref_code1", "Y");
		model.addAttribute("applyUnit",applyUnit.getCodeNo());
		
		return JSP_PATH + "cbm020ukrv";
	}
	/**
	 * 기준코드 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm030ukrv.do")
	public String cbm030ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "cbm030ukrv";
	}
	
	/**
	 * 원가업무설정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm040ukrv.do")
	public String cbm040ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = _req.getParameterMap();
		List<ComboItemModel> costCenter = costCommonService.selectCostCenterCombo(param, loginVO);
		model.addAttribute("COST_CETNER_COMBO", costCenter);

		List<ComboItemModel> costPool = costCommonService.selectCostPoolCombo(param, loginVO);
		model.addAttribute("COST_POOL_COMBO", costPool);

		List<ComboItemModel> distrPool = costCommonService.selectDistrPoolCombo(param, loginVO);
		model.addAttribute("DISTR_POOL_COMBO", distrPool);
		
		return JSP_PATH + "cbm040ukrv";
	}

	/**
	 * 기본정보 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm050ukrv.do")
	public String cbm050ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = _req.getParameterMap();
		List<ComboItemModel> manageCodeCombo = costCommonService.selectManageCodeCombo(param, loginVO);
		model.addAttribute("MANAGE_CODE_COMBO", manageCodeCombo);
		
		return JSP_PATH + "cbm050ukrv";
	}
	/**
	 * 원가업무설정
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm100ukrv.do")
	public String cbm100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC05","ref_code1", "Y");
		if(applyUnit != null)	{
			model.addAttribute("applyUnit",applyUnit.getCodeNo());
		} else {
			model.addAttribute("applyUnit","");
		}
		CodeDetailVO distKind = codeInfo.getCodeInfo("C101","ref_code1", "Y");
		if(distKind != null)	{
			model.addAttribute("distKind",distKind.getCodeNo());
		} else {
			model.addAttribute("distKind","");
		}
		CodeDetailVO distKind2 = codeInfo.getCodeInfo("C102","ref_code1", "Y");
		if(distKind2 != null)	{
			model.addAttribute("distKind2",distKind2.getCodeNo());
		} else {
			model.addAttribute("distKind2","");
		}
		CodeDetailVO distKind3 = codeInfo.getCodeInfo("CA08","ref_code1", "Y");
		if(distKind3 != null)	{
			model.addAttribute("distKind3",distKind3.getCodeNo());
		} else {
			model.addAttribute("distKind3","");
		}
		CodeDetailVO distKind4 = codeInfo.getCodeInfo("CA13","ref_code1", "Y");
		if(distKind4 != null)	{
			model.addAttribute("distKind4",distKind4.getCodeNo());
		} else {
			model.addAttribute("distKind4","");
		}
		return JSP_PATH + "cbm100ukrv";
	}
	/**
	 * 월별배부기준 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm130ukrv.do")
	public String cbm130ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO detailData = codeInfo.getCodeInfo("C007","01");
		
		model.addAttribute("ALLOCATION_COST_POOL", detailData.getRefCode1());
		return JSP_PATH + "cbm130ukrv";
	}
	/**
	 * 월별배부기준 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm140ukrv.do")
	public String cbm140ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		CodeDetailVO defaultAllocation = codeInfo.getCodeInfo("CA04", "ref_code1", "Y");
		if(defaultAllocation != null)	{
			model.addAttribute("DEFAULT_ALLOCATION_CODE", defaultAllocation.getCodeNo());
		} else {
			model.addAttribute("DEFAULT_ALLOCATION_CODE", "");
		}
		Map paramMap = new HashMap();
		paramMap.put("S_COMP_CODE", loginVO.getCompCode());
 		paramMap.put("ALLOCATION_YN", "Y");
 		paramMap.put("USE_YN", "Y");
		List<Map> allocationCosts = cbm140ukrvService.getCostPools(paramMap, loginVO);
		if(allocationCosts != null && allocationCosts.size() > 0)	{
			model.addAttribute("ALLOCATION_COST_POOL", ObjUtils.toJsonStr(allocationCosts));
		} else {
			model.addAttribute("ALLOCATION_COST_POOL", "[]");
		}
		
		return JSP_PATH + "cbm140ukrv";
	}
	/**
	 * 부문 정보 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm700ukrv.do")
	public String cbm700ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = _req.getParameterMap();
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		
		CodeDetailVO applyUnit = codeInfo.getCodeInfo("CC06","ref_code1", "Y");
		if(applyUnit != null ) {
			model.addAttribute("applyUnit",applyUnit.getCodeNo());
		}else {
			model.addAttribute("applyUnit","");
		}
		
		CodeDetailVO distKind = codeInfo.getCodeInfo("C101","ref_code1", "Y");
		if(distKind != null ) {
			model.addAttribute("distKind",distKind.getCodeNo());
		}else {
			model.addAttribute("distKind","");
		}
		
		return JSP_PATH + "cbm700ukrv";
	}
	/**
	 * 부문 - 부서 매핑 정보 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm710ukrv.do")
	public String cbm710ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = _req.getParameterMap();
		List<ComboItemModel> costPool = costCommonService.selectCostPoolCombo700(param, loginVO);
		model.addAttribute("COST_POOL_COMBO", costPool);

		return JSP_PATH + "cbm710ukrv";
	}
	/**
	 * 부분 - 작업장 매핑정보등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm720ukrv.do")
	public String cbm720ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = _req.getParameterMap();
		
		List<ComboItemModel> costPool = costCommonService.selectCostPoolCombo700(param, loginVO);
		model.addAttribute("COST_POOL_COMBO", costPool);

		return JSP_PATH + "cbm720ukrv";
	}
	
	/**
	 * 사용자정의 배부유형 코드 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cbm200ukrv.do")
	public String cbm200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "cbm200ukrv";
	}
	
 	/**
	 * (1차배부)품목별 가중치등록
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cbm150ukrv.do")
	public String cbm150ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
 		final String[] searchFields = {  };
 		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("DIV_CODE", loginVO.getDivCode());
		return JSP_PATH + "cbm150ukrv";
	}
}