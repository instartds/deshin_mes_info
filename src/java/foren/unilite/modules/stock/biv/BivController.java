package foren.unilite.modules.stock.biv;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.sales.str.Str412ukrvServiceImpl;
import foren.unilite.modules.stock.biv.Biv121ukrvServiceImpl;

@Controller
public class BivController extends UniliteCommonController {

	@Resource(name="biv300skrvService")
	private Biv300skrvServiceImpl biv300skrvService;

	@Resource(name="biv301skrvService")
	private Biv301skrvServiceImpl biv301skrvService;
	
	@Resource(name="biv302skrvService")
	private Biv302skrvServiceImpl biv302skrvService;

	@Resource(name="biv321skrvService")
	private Biv321skrvServiceImpl biv321skrvService;

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/stock/biv/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="biv121ukrvService")
	private Biv121ukrvServiceImpl biv121ukrvService;

	@Resource(name="biv123ukrvService")
	private Biv123ukrvServiceImpl biv123ukrvService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

	@RequestMapping(value = "/stock/biv121skrv.do")
	public String biv121skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv121skrv";
	}

	@RequestMapping(value = "/stock/biv140skrv.do")
	public String biv140skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		return JSP_PATH + "biv140skrv";
	}

	@RequestMapping(value = "/stock/biv160skrv.do")
	public String biv160skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv160skrv";
	}
	@RequestMapping(value = "/stock/biv200skrv.do")
	 public String biv200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
	  return JSP_PATH + "biv200skrv";
	 }

	@RequestMapping(value = "/stock/biv200ukrv.do")
	 public String biv200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
	  return JSP_PATH + "biv200ukrv";
	 }

	@RequestMapping(value = "/stock/biv201skrv.do")
	 public String biv201skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
	  return JSP_PATH + "biv201skrv";
	 }
	@RequestMapping(value = "/stock/biv202ukrv.do")
	 public String biv202ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
	  return JSP_PATH + "biv202ukrv";
	 }

	@RequestMapping(value = "/stock/biv300skrv.do")
	public String biv300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<Map<String, Object>> gsWHGroupYN = biv300skrvService.getgsWHGroupYN(param);
		if(ObjUtils.isEmpty(gsWHGroupYN) || gsWHGroupYN.get(0).get("GROUP_CD").equals("")){
			gsWHGroupYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			model.addAttribute("gsWHGroupYN","N");
			gsWHGroupYN.add(map);
		} else {
			model.addAttribute("gsWHGroupYN","Y");
		}
		return JSP_PATH + "biv300skrv";
	}
	
	@RequestMapping(value = "/stock/biv302skrv.do")
	public String biv302skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<Map<String, Object>> gsWHGroupYN = biv302skrvService.getgsWHGroupYN(param);
		if(ObjUtils.isEmpty(gsWHGroupYN) || gsWHGroupYN.get(0).get("GROUP_CD").equals("")){
			gsWHGroupYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			model.addAttribute("gsWHGroupYN","N");
			gsWHGroupYN.add(map);
		} else {
			model.addAttribute("gsWHGroupYN","Y");
		}
		return JSP_PATH + "biv302skrv";
	}


	@RequestMapping(value = "/stock/biv310skrv.do")
	public String biv310skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv310skrv";
	}


	@RequestMapping(value = "/stock/biv410skrv.do")
	public String biv410skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv410skrv";
	}

	@RequestMapping(value = "/stock/biv380skrv.do")
	public String biv380skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv380skrv";
	}


	@RequestMapping(value = "/stock/biv320skrv.do")
	public String biv320skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv320skrv";
	}

	/**
	 * 월별수불현황조회(누계) (biv321skrv) - 20200326 신규 생성
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/biv321skrv.do")
	public String biv321skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE"	, loginVO.getCompCode());
		param.put("DIV_CODE"	, loginVO.getDivCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		//20200427 추가: 사업장 정보의 재고평가기간 설정 가져오는 로직 추가
		List<Map<String, Object>> gsYearEvaluationYN = biv321skrvService.getYearEvaluation(param);	//연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		model.addAttribute("gsYearEvaluationYN", ObjUtils.toJsonStr(gsYearEvaluationYN));

		return JSP_PATH + "biv321skrv";
	}

	/**
	 * 월별 수불현황 조회(수불유형별) (biv325skrv)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/biv325skrv.do")
	public String biv325skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv325skrv";
	}

	@RequestMapping(value = "/stock/biv330skrv.do")
	public String biv330skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv330skrv";
	}

	@RequestMapping(value = "/stock/biv360skrv.do")
	public String biv360skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv360skrv";
	}

	@RequestMapping(value = "/stock/biv340skrv.do")
	public String biv340skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "biv340skrv";
	}


	 @RequestMapping(value = "/stock/biv350skrv.do")
	 public String biv350skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  return JSP_PATH + "biv350skrv";
	 }

	 @RequestMapping(value = "/stock/biv370skrv.do")
	 public String biv370skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  return JSP_PATH + "biv370skrv";
	 }



	 @RequestMapping(value = "/stock/biv420skrv.do")
	 public String biv420skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  return JSP_PATH + "biv420skrv";
	 }

	/**
	 * Aging Report (biv500skrv) - 20191119 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/biv500skrv.do")
	public String biv500skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"	, comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M513", "10");						//1번째 조회기간
		if(!ObjUtils.isEmpty(cdo) && !ObjUtils.isEmpty(cdo.getRefCode1()) && cdo.getRefCode1().matches("^[0-9]*$")) {
			model.addAttribute("period1", cdo.getRefCode1());
		} else {
			model.addAttribute("period1", 3);
		}

		cdo = codeInfo.getCodeInfo("M513", "20");						//2번째 조회기간
		if(!ObjUtils.isEmpty(cdo) && !ObjUtils.isEmpty(cdo.getRefCode1()) && cdo.getRefCode1().matches("^[0-9]*$")) {
			model.addAttribute("period2", cdo.getRefCode1());
		} else {
			model.addAttribute("period2", 3);
		}

		cdo = codeInfo.getCodeInfo("M513", "30");						//3번째 조회기간
		if(!ObjUtils.isEmpty(cdo) && !ObjUtils.isEmpty(cdo.getRefCode1()) && cdo.getRefCode1().matches("^[0-9]*$")) {
			model.addAttribute("period3", cdo.getRefCode1());
		} else {
			model.addAttribute("period3", 6);
		}

		cdo = codeInfo.getCodeInfo("M513", "40");						//4번째 조회기간
		if(!ObjUtils.isEmpty(cdo) && !ObjUtils.isEmpty(cdo.getRefCode1()) && cdo.getRefCode1().matches("^[0-9]*$")) {
			model.addAttribute("period4", cdo.getRefCode1());
		} else {
			model.addAttribute("period4", 12);
		}

		return JSP_PATH + "biv500skrv";
	}

	 @RequestMapping(value = "/stock/biv600skrv.do")
	 public String biv600skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  return JSP_PATH + "biv600skrv";
	 }


	 @RequestMapping(value = "/stock/biv130ukrv.do")
	 public String biv130ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("sWhCellFlagYN",cdo.getRefCode1());

	  return JSP_PATH + "biv130ukrv";
	 }
	 @RequestMapping(value = "/stock/biv120ukrv.do",method = RequestMethod.GET)
		public String biv120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		 final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			param.put("S_COMP_CODE",loginVO.getCompCode());
			model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
			model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
			model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
			model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
			model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));			//20210510 추가

			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;

			cdo = codeInfo.getCodeInfo("B084", "C");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

			cdo = codeInfo.getCodeInfo("B084", "D");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

			return JSP_PATH + "biv120ukrv";
		}


	/** 재고실사등록(barcode) (biv122ukrv)
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/stock/biv122ukrv.do",method = RequestMethod.GET)
	public String biv122ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		return JSP_PATH + "biv122ukrv";
	}


	 @RequestMapping(value = "/stock/biv150ukrv.do")
	 public String biv150ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());

	  return JSP_PATH + "biv150ukrv";
	 }

	@RequestMapping(value = "/stock/biv160ukrv.do")
	public String biv160ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		//20200526 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());

		return JSP_PATH + "biv160ukrv";
	}



	 @RequestMapping(value = "/stock/biv113ukrv.do")
	 public String biv113ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  return JSP_PATH + "biv113ukrv";
	 }

	 @RequestMapping(value = "/stock/biv114ukrv.do")
	 public String biv114ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  return JSP_PATH + "biv114ukrv";
	 }
	 
	 @RequestMapping(value = "/stock/biv115ukrv.do")
	 public String biv115ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	  CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	  CodeDetailVO cdo = null;

	  cdo = codeInfo.getCodeInfo("B049", "3");
	  if(!ObjUtils.isEmpty(cdo))	{
		  model.addAttribute("gsPeriod",ObjUtils.getSafeString(cdo.getRefCode6(), "1"));
	  } else {
		  model.addAttribute("gsPeriod", "1");
	  }

		
	  return JSP_PATH + "biv115ukrv";
	 }

	@RequestMapping(value = "/stock/biv060ukrv.do")
	public String biv060ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "biv060ukrv";
	}

	 @RequestMapping(value = "/stock/biv100ukrv.do")
	 public String biv100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		return JSP_PATH + "biv100ukrv";
	 }

	 @RequestMapping(value = "/stock/biv105ukrv.do")
	 public String biv105ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* ����ջ����� : Lot No. �ջ� */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* ����ջ����� : â�� Cell �ջ� */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		return JSP_PATH + "biv105ukrv";
	 }

	 @RequestMapping(value = "/stock/biv121ukrv.do")
	 public String biv121ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_SECTOR_LIST", biv121ukrvService.getSectorList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* ����ջ����� : Lot No. �ջ� */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* ����ջ����� : â�� Cell �ջ� */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		return JSP_PATH + "biv121ukrv";
	 }

	 @RequestMapping(value = "/stock/biv170ukrv.do")
	 public String biv170ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

	  return JSP_PATH + "biv170ukrv";
	 }

	 @RequestMapping(value = "/stock/biv430skrv.do")
		public String biv430skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

			return JSP_PATH + "biv430skrv";
		}

	  @RequestMapping(value = "/stock/biv120rkrv.do")
	  public String mpo150rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	      final String[] searchFields = {  };
	      NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	      LoginVO session = _req.getSession();
	      Map<String, Object> param = navigator.getParam();
	      String page = _req.getP("page");

	      CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	      CodeDetailVO cdo = null;

	      cdo = codeInfo.getCodeInfo("B084", "C");
	      if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot", cdo.getRefCode1());

	      cdo = codeInfo.getCodeInfo("B084", "D");
	      if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell", cdo.getRefCode1());

	      param.put("S_COMP_CODE",loginVO.getCompCode());

	      model.addAttribute("COMBO_WH_LIST",      comboService.getWhList(param));
	      model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
	      model.addAttribute("COMBO_ITEM_LEVEL1",  comboService.getItemLevel1(param));
	      model.addAttribute("COMBO_ITEM_LEVEL2",  comboService.getItemLevel2(param));
	      model.addAttribute("COMBO_ITEM_LEVEL3",  comboService.getItemLevel3(param));

	      return JSP_PATH + "biv120rkrv";
	  }


	  @RequestMapping(value = "/stock/biv610skrv.do")
		 public String biv610skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		  final String[] searchFields = {  };
		  NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		  LoginVO session = _req.getSession();
		  Map<String, Object> param = navigator.getParam();
		  String page = _req.getP("page");

		  param.put("S_COMP_CODE",loginVO.getCompCode());
		  model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		  model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		  model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		  return JSP_PATH + "biv610skrv";
		 }

		@RequestMapping(value = "/stock/biv470skrv.do")
		public String biv470skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

			return JSP_PATH + "biv470skrv";
		}

		@RequestMapping(value = "/stock/biv123ukrv.do")
		 public String biv123ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			param.put("S_COMP_CODE",loginVO.getCompCode());

			model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
			model.addAttribute("COMBO_SECTOR_LIST", biv123ukrvService.getSectorList(param));

			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;

			cdo = codeInfo.getCodeInfo("B084", "C");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* ����ջ����� : Lot No. �ջ� */

			cdo = codeInfo.getCodeInfo("B084", "D");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* ����ջ����� : â�� Cell �ջ� */

			List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
			for(CodeDetailVO map : gsMoneyUnit)	{
				if("Y".equals(map.getRefCode1()))	{
					model.addAttribute("gsMoneyUnit", map.getCodeNo());
				}
			}

			return JSP_PATH + "biv123ukrv";
		 }

		@RequestMapping(value = "/stock/biv301skrv.do")
		public String biv301skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;

			cdo = codeInfo.getCodeInfo("I004", "1");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAvgPHiddenYN",cdo.getRefCode1());

			List<Map<String, Object>> gsWHGroupYN = biv301skrvService.getgsWHGroupYN(param);
			if(ObjUtils.isEmpty(gsWHGroupYN) || gsWHGroupYN.get(0).get("GROUP_CD").equals("")){
				gsWHGroupYN = new ArrayList<Map<String, Object>>();
				Map<String, Object> map = new HashMap<String, Object>();
				model.addAttribute("gsWHGroupYN","N");
				gsWHGroupYN.add(map);
			} else {
				model.addAttribute("gsWHGroupYN","Y");
			}
			return JSP_PATH + "biv301skrv";
		}

		@RequestMapping(value = "/stock/biv440skrv.do")
		public String biv440skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

			return JSP_PATH + "biv440skrv";
		}

		@RequestMapping(value = "/stock/biv450ukrv.do",method = RequestMethod.GET)
		public String biv450ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

			model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
			model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
			model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

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

			cdo = codeInfo.getCodeInfo("B256", "1");	//추가항목 필드셋:
			if(ObjUtils.isNotEmpty(cdo)){
				model.addAttribute("gsSetField", cdo.getCodeName().toUpperCase());
			}

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

			return JSP_PATH + "biv450ukrv";
		}

		@RequestMapping(value = "/stock/biv305skrv.do")
		public String biv305skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
			model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
			model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
			model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
			model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

			return JSP_PATH + "biv305skrv";
		}
		
		@RequestMapping(value = "/stock/biv460skrv.do")
		public String biv460skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
			model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
			model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
			model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
			model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

			return JSP_PATH + "biv460skrv";
		}		
		/**
		 * 품목별 lot추적 현황 (biv700skrv)
		 * @param popupID
		 * @param _req
		 * @param loginVO
		 * @param listOp
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/stock/biv700skrv.do")
		public String biv700skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
			final String[] searchFields = {  };
			NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
			LoginVO session = _req.getSession();
			Map<String, Object> param = navigator.getParam();
			String page = _req.getP("page");

			Map<String, Object> comboParam = new HashMap<String, Object>();
			comboParam.put("COMP_CODE", loginVO.getCompCode());
			comboParam.put("TYPE", "DIV_PRSN");
			model.addAttribute("COMBO_DIV_PRSN",  baseCommonService.fnRecordCombo(comboParam));

			CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
			CodeDetailVO cdo = null;
			//BOM PATH 관리여부(B082)
			List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
			for(CodeDetailVO map : gsBomPathYN) {
				if("Y".equals(map.getRefCode1())) {
					model.addAttribute("gsBomPathYN", map.getCodeNo());
				}
			}
			//대체품목 등록여부(B081)
			List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
			for(CodeDetailVO map : gsExchgRegYN)	{
				if("Y".equals(map.getRefCode1())) {
					model.addAttribute("gsExchgRegYN", map.getCodeNo());
				}
			}
			return JSP_PATH + "biv700skrv";
		}
		
		/**
		 * 선입선출 내역 조회
		 * @return
		 * @throws Exception
		 */
	 	@RequestMapping(value = "/stock/biv800skrv.do")
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
			
			return JSP_PATH + "biv800skrv";
		}
}
