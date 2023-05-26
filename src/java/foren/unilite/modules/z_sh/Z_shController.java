package foren.unilite.modules.z_sh;

import java.text.SimpleDateFormat;
import java.util.Calendar;
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
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.sales.SalesCommonServiceImpl;


@Controller
public class Z_shController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_sh/";

	@Resource(name="s_mpo080ukrv_shService")
	private S_Mpo080ukrv_shServiceImpl s_mpo080ukrv_shService;

	@Resource(name="UniliteComboServiceImpl")
    private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;
	
	@Resource( name = "s_pmr350skrv_shService" )
	private S_pmr350skrv_shServiceImpl s_pmr350skrv_shService;

	@Resource(name = "salesCommonService")
	private SalesCommonServiceImpl salesCommonService;
	/**
	 * 근태일괄등록(S)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_hat900ukr_sh.do",method = RequestMethod.GET)
	public String s_hat900ukr_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

		return JSP_PATH + "s_hat900ukr_sh";
	}

	/**
	 * 근태현황(S)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_hat900skr_sh.do",method = RequestMethod.GET)
	public String s_hat900skr_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

		return JSP_PATH + "s_hat900skr_sh";
	}


	/**
	 * 작업지시 라인배정 및 조정
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_pmp170ukrv_sh.do",method = RequestMethod.GET)
	public String s_pmp170ukrv_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("I811", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				 model.addAttribute("gsCoreUse", cdo.getRefCode1().toUpperCase());
			 }else{
			 	model.addAttribute("gsCoreUse", "N");
			 }
	     }else {
	            model.addAttribute("gsCoreUse", "N");
	     }
		return JSP_PATH + "s_pmp170ukrv_sh";
	}

	/**
	 * 조립대기 현황판
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_pmr200skrv_sh.do",method = RequestMethod.GET)
	public String s_pmr200skrv_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
        final String[] searchFields = {};
        NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
        LoginVO session = _req.getSession();
        Map<String, Object> param = navigator.getParam();
        String page = _req.getP("page");

		return JSP_PATH + "s_pmr200skrv_sh";
	}

	/**
	 * 생산현황 조회(작업자별)(SH) (s_pmr210skrv_sh) - 20200316 신규 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_pmr210skrv_sh.do")
	public String s_pmr210skrv_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "s_pmr210skrv_sh";
	}

	@RequestMapping(value = "/z_sh/s_otr100ukrv_sh.do",method = RequestMethod.GET)
	public String s_otr100ukrv_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}																					/* 대체품목 등록여부 */

		List<CodeDetailVO> gsCheckMath = codeInfo.getCodeList("M031", "", false);
		for(CodeDetailVO map : gsCheckMath)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCheckMath", map.getCodeNo());
			}
		}																					/* 외주입고시 외주출고량 체크방법 */

		return JSP_PATH + "s_otr100ukrv_sh";
	}

	@RequestMapping(value = "/z_sh/s_otr110ukrv_sh.do")
	public String s_otr110ukrv_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	/* 재고상태관리(+/-) */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		cdo = codeInfo.getCodeInfo("B095", "MB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsBaseWhCode",cdo.getRefCode2());		/* 기준창고 */

		cdo = codeInfo.getCodeInfo("B095", "MB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsBaseWhCodeCell",cdo.getRefCode3());		/* 기준창고 Cell */

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("M027", "", false);//가용재고 체크여부
        for(CodeDetailVO map : gsUsePabStockYn) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsUsePabStockYn", map.getCodeNo());
            }
        }

        List<CodeDetailVO> gsBoxYN = codeInfo.getCodeList("S149", "", false);
		for(CodeDetailVO map : gsBoxYN)   {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBoxYN", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_otr110ukrv_sh";
	}


	/**
	 * 수주진행현황 조회(SH) (s_sof110skrv_sh) - 20200224 신규 생성
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_sof110skrv_sh.do")
	public String sof110skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "s_sof110skrv_sh";
	}

	/**
	 * 출하대기 현황판(신환) (s_srq400skrv_sh) - 20190827
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_srq400skrv_sh.do")
	public String srq400skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "s_srq400skrv_sh";
	}

	/**
	 * 20190213 신규
	 * 구매요청등록(생산계획)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_mpo080ukrv_sh.do")
	public String s_mpo080ukrv_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_mpo080ukrv_sh";
	}

	@ResponseBody
	@RequestMapping(value = "/z_sh/s_mpo080_shExcelDown.do")
	public ModelAndView s_mpo080_shDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = s_mpo080ukrv_shService.makeExcel(paramMap);
		String title = "소요량내역(여러건)";

		return ViewHelper.getExcelDownloadView(wb, title);
	}

	/**
	 * 불량현황 조회(이노코스텍)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_pmr350skrv_sh.do")
	public String s_pmr350skrv_sh(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		Gson gson = new Gson();
		String colData = gson.toJson(s_pmr350skrv_shService.selectColumns(loginVO));
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_pmr350skrv_sh";
	}
	
	
	@RequestMapping(value = "/sales/s_sof100skrv_sh.do")
	public String s_sof100skrv_sh(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//기본 화폐단위, 환산 화폐단위, 환산 환율 가져오기 위한 로직
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		String moneyUnit = "";
		Map<String, Object> exchgRate = new HashMap<String, Object>();

		//기본 화폐단위
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		//default 환산 화폐단위
		List<CodeDetailVO> gsMoneyUnitRef4 = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnitRef4)	{
			if("Y".equals(map.getRefCode4()))	{
				model.addAttribute("gsMoneyUnitRef4", map.getCodeNo());
				moneyUnit = map.getCodeNo();
			}
		}
		//default 환산 환율
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar c1 = Calendar.getInstance();
		String strToday = sdf.format(c1.getTime());

		param.put("AC_DATE"		, strToday);
		param.put("MONEY_UNIT"	, moneyUnit);
		exchgRate = (Map<String, Object>) salesCommonService.fnExchgRateO(param);
		model.addAttribute("gsExchangeRate", exchgRate.get("BASE_EXCHG"));

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_sof100skrv_sh";
	}
	
}
