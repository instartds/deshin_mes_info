package foren.unilite.modules.matrl.otr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class OtrController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/matrl/otr/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="otr110ukrvService")
	private Otr110ukrvServiceImpl otr110ukrvService;

	@RequestMapping(value = "/otr/otr110SelectProductNumInWh.do", method = RequestMethod.POST)
    public ModelAndView  otr110SelectProductNumInWh(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request) throws Exception {
		Map map = new HashMap();
		map.put("ITEM_CODE", _req.getParameter("ITEM_CODE"));
		map.put("WH_CODE", _req.getParameter("WH_CODE"));
		map.put("S_COMP_CODE", _req.getParameter("S_COMP_CODE"));

        Object result = otr110ukrvService.selectProductNumInWh(map);
        return ViewHelper.getJsonView(result);
    }

	@Resource(name="otr111ukrvService")
	private Otr111ukrvServiceImpl otr111ukrvService;

	@RequestMapping(value = "/otr/otr111SelectProductNumInWh.do", method = RequestMethod.POST)
    public ModelAndView  otr111SelectProductNumInWh(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request) throws Exception {
		Map map = new HashMap();
		map.put("ITEM_CODE", _req.getParameter("ITEM_CODE"));
		map.put("WH_CODE", _req.getParameter("WH_CODE"));
		map.put("S_COMP_CODE", _req.getParameter("S_COMP_CODE"));

        Object result = otr111ukrvService.selectProductNumInWh(map);
        return ViewHelper.getJsonView(result);
    }



	@RequestMapping(value = "/matrl/otr300skrv.do")
	public String otr300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "otr300skrv";
	}

	@RequestMapping(value = "/matrl/otr310skrv.do")
	public String otr310skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "otr310skrv";
	}

	@RequestMapping(value = "/matrl/otr320skrv.do")
	public String otr320skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "otr320skrv";
	}

	@RequestMapping(value = "/matrl/otr330skrv.do")
	public String otr330skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "otr330skrv";
	}

	@RequestMapping(value = "/matrl/otr340skrv.do")
	public String otr340skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "otr340skrv";
	}
	@RequestMapping(value = "/matrl/otr100ukrv.do",method = RequestMethod.GET)
	public String otr100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "otr100ukrv";
	}

	@RequestMapping(value = "/matrl/otr110ukrv.do")
	public String otr110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "otr110ukrv";
	}

	@RequestMapping(value = "/matrl/otr111ukrv.do")
	public String otr111ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("M027", "", false);//가용재고 체크여부      I014 -> M027 로 변경
        for(CodeDetailVO map : gsUsePabStockYn) {
            if("Y".equals(map.getRefCode1()))   {
                model.addAttribute("gsUsePabStockYn", map.getCodeNo());
            }
        }
		return JSP_PATH + "otr111ukrv";
	}


	/**
	 * 외주출고등록(바코드) (otr112ukrv)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/otr112ukrv.do")
	public String otr112ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("B703", "02");	//선입선출(자재) 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}

		return JSP_PATH + "otr112ukrv";
	}




	@RequestMapping(value = "/matrl/otr120ukrv.do")
	public String otr120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		/*cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	 재고상태관리(+/-) */

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);
		for(CodeDetailVO map : gsInspecFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInspecFlag", map.getCodeNo());						/* 검사프로그램 사용여부  */
			}
		}

		cdo = codeInfo.getCodeInfo("M102", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("glPerCent",cdo.getRefCode1());	/* 발주량 대비 입고율 */

		cdo = codeInfo.getCodeInfo("M503", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmLinkFlag",cdo.getRefCode1());	/* 입고등록(SCM연계) 사용여부 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	/* 재고합산유형 : 창고 Cell 합산 */

		List<CodeDetailVO> gsCheckMath = codeInfo.getCodeList("M031", "", false);
		for(CodeDetailVO map : gsCheckMath)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCheckMath", map.getCodeNo());						/* 검사프로그램 사용여부  */
			}
		}

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());						/* 화폐단위  */
			}
		}

/*		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		for(CodeDetailVO map : gsQ008Sub)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsQ008Sub", map.getCodeNo());
			}
		}*/
		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		String sDivCode = loginVO.getDivCode();;
		String divChkYn = "N";
		//q008(가입고 사용여부)의 refCode2,refCode3에 값이 들어가 있으면 사업장 별로 미입고(가입고 사용 안할 경우), 무검사 참조(가입고 사용시)버튼 제어하도록 변경
		for(CodeDetailVO divChkMap : gsQ008Sub)	{
			if(!ObjUtils.isEmpty(divChkMap.getRefCode2()) || !ObjUtils.isEmpty(divChkMap.getRefCode3())){
				divChkYn = "Y";
			}
		}
		for(CodeDetailVO map : gsQ008Sub)	{
			if(divChkYn.equals("N")){//사업장별로 가입고 사용여부 안하고 기존대로 세팅
				if("Y".equals(map.getRefCode1().toUpperCase()))	{
					model.addAttribute("gsQ008Sub", map.getCodeNo());
				}
			}else{//사업장별로 가입고 사용여부 사용
				if(sDivCode.equals("01")){
					if("Y".equals(map.getRefCode1().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				}else if(sDivCode.equals("02")){
					if("Y".equals(map.getRefCode2().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				}else if(sDivCode.equals("03")){
					if("Y".equals(map.getRefCode3().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				}
			}
		}


		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		List<CodeDetailVO> gsBoxYN = codeInfo.getCodeList("S149", "", false);
		for(CodeDetailVO map : gsBoxYN)   {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBoxYN", map.getCodeNo());
			}
		}

		return JSP_PATH + "otr120ukrv";
	}
	@RequestMapping(value = "/matrl/otr121ukrv.do")
	public String otr121ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		/*cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	 재고상태관리(+/-) */

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);
		for(CodeDetailVO map : gsInspecFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInspecFlag", map.getCodeNo());						/* 검사프로그램 사용여부  */
			}
		}

		cdo = codeInfo.getCodeInfo("M102", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("glPerCent",cdo.getRefCode1());	/* 발주량 대비 입고율 */

		cdo = codeInfo.getCodeInfo("M503", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmLinkFlag",cdo.getRefCode1());	/* 입고등록(SCM연계) 사용여부 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	/* 재고합산유형 : 창고 Cell 합산 */

		List<CodeDetailVO> gsCheckMath = codeInfo.getCodeList("M031", "", false);
		for(CodeDetailVO map : gsCheckMath)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCheckMath", map.getCodeNo());						/* 검사프로그램 사용여부  */
			}
		}

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());						/* 화폐단위  */
			}
		}

/*		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		for(CodeDetailVO map : gsQ008Sub)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsQ008Sub", map.getCodeNo());
			}
		}*/
		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		String sDivCode = loginVO.getDivCode();;
		String divChkYn = "N";
		//q008(가입고 사용여부)의 refCode2,refCode3에 값이 들어가 있으면 사업장 별로 미입고(가입고 사용 안할 경우), 무검사 참조(가입고 사용시)버튼 제어하도록 변경
		for(CodeDetailVO divChkMap : gsQ008Sub)	{
			if(!ObjUtils.isEmpty(divChkMap.getRefCode2()) || !ObjUtils.isEmpty(divChkMap.getRefCode3())){
				divChkYn = "Y";
			}
		}
		for(CodeDetailVO map : gsQ008Sub)	{
			if(divChkYn.equals("N")){//사업장별로 가입고 사용여부 안하고 기존대로 세팅
				if("Y".equals(map.getRefCode1().toUpperCase()))	{
					model.addAttribute("gsQ008Sub", map.getCodeNo());
				}
			}else{//사업장별로 가입고 사용여부 사용
				if(sDivCode.equals("01")){
					if("Y".equals(map.getRefCode1().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				}else if(sDivCode.equals("02")){
					if("Y".equals(map.getRefCode2().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				}else if(sDivCode.equals("03")){
					if("Y".equals(map.getRefCode3().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				}
			}
		}


		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		List<CodeDetailVO> gsBoxYN = codeInfo.getCodeList("S149", "", false);
		for(CodeDetailVO map : gsBoxYN)   {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBoxYN", map.getCodeNo());
			}
		}

		return JSP_PATH + "otr121ukrv";
	}
	@RequestMapping(value = "/matrl/otr330rkrv.do")
	public String otr330rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "otr330rkrv";
	}
}
