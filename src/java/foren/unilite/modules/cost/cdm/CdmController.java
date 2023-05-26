package foren.unilite.modules.cost.cdm;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class CdmController extends UniliteCommonController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String JSP_PATH = "/cost/cdm/";

	public final static String FILE_TYPE_OF_PHOTO = "stampPhoto";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;
	
	@Resource(name="cdm105ukrvService")
	private Cdm105ukrvServiceImpl cdm105ukrvService;

	@Resource(name="cdm420skrvService")
	private Cdm420skrvServiceImpl cdm420skrvService;

	@Resource(name="cdm437skrvService")
	private Cdm437skrvServiceImpl cdm437skrvService;
	
	
	/**
	 * 원가계산(유형1)
	 * @return
	 * @throws Exception
	 */
 	/*@RequestMapping(value = "/cost/cdm100ukrv.do")
	public String cdm100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		Map refConfig = (Map)cdm105ukrvService.selectRefConfig(param);
        model.addAttribute("REF_CC05", ObjUtils.isNotEmpty(refConfig) ? refConfig.get("REF_CC05") : "02");

		return JSP_PATH + "cdm100ukrv";
	}*/
 	
 	/**
	 * 원가
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm101ukrv.do")
	public String cdm101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "cdm101ukrv";
	}
	/**
	 * 원가계산(유형2)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm105ukrv.do")
	public String cdm105ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		Map refConfig = (Map)cdm105ukrvService.selectRefConfig(param);
        model.addAttribute("REF_CC05", ObjUtils.isNotEmpty(refConfig) ? refConfig.get("REF_CC05") : "02");

		return JSP_PATH + "cdm105ukrv";
	}

 	/**
	 * 원가마감(유형1)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm400ukrv.do")
	public String cdm400ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm400ukrv";
	}

	/**
	 * 원가마감(유형2)
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm405ukrv.do")
	public String cdm405ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm405ukrv";
	}

	/**
	 * 부문별 생산 집계현황
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm416skrv.do")
	public String cdm416skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm416skrv";
	}

	/**
	 * 품목별 재료비 집계 현황
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm755skrv.do")
	public String cdm755skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm755skrv";
	}

	/**
	 * 제조경비 집계현황
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm420skrv.do")
	public String cdm420skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		List<Map<String, Object>> costcenter = cdm420skrvService.selectCostCenterList(param);
		
		model.addAttribute("COST_CENTER_LIST", ObjUtils.isNotEmpty(costcenter) ? JsonUtils.toJsonStr(costcenter): "[]");  
		
		return JSP_PATH + "cdm420skrv";
	}

 	/**
	 * 부문별 제조경비 집계현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cost/cdm437skrv.do")
	public String cdm437skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		List<Map<String, Object>> costcenter = cdm437skrvService.selectCostCenterList(param);
		model.addAttribute("COST_CENTER_LIST", ObjUtils.isNotEmpty(costcenter) ? JsonUtils.toJsonStr(costcenter): "[]");  
		
		List<Map<String, Object>> costpool = cdm437skrvService.selectCostPoolList(param);
		model.addAttribute("COST_POOL_LIST", ObjUtils.isNotEmpty(costpool) ? JsonUtils.toJsonStr(costpool): "[]");  

		return JSP_PATH + "cdm437skrv";
	}

	/**
	 * 품목별 제조경비 집계현황
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm455skrv.do")
	public String cdm455skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm455skrv";
	}

	/**
	 * 부문별 배부기준 집계현황
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm410skrv.do")
	public String cdm410skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm410skrv";
	}

	/**
	 * 원가계산 log 정보조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm305skrv.do")
	public String cdm305skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm305skrv";
	}

	/**
	 * 원가계산 작업 정보조회
	 * @return
	 * @throws Exception
	 */
 	@RequestMapping(value = "/cost/cdm310skrv.do")
	public String cdm310skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		
		param.put("DIV_CODE",loginVO.getDivCode());
		
		return JSP_PATH + "cdm310skrv";
	}

 	@RequestMapping(value = "/cost/cdm200skrv.do")
	public String cdm200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "cdm200skrv";
	}
	
	@RequestMapping(value = "/cost/cdm300skrv.do")
	public String cdm300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "cdm300skrv";
	}
}