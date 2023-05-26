package foren.unilite.modules.sales.spp;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Controller
public class SppContoroller extends UniliteCommonController {

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name = "salesCommonService")
	private SalesCommonServiceImpl salesCommonService;


	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "stampPhoto";

	final static String		JSP_PATH	= "/sales/spp/";

	@RequestMapping(value = "/sales/spp100ukrv.do")
	public String spp100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

	    CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
        CodeDetailVO cdo = null;

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

////////////////////////////////견적서출력추가//////////////////////////////////////
        List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{

			if("spp100ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());// 바꾸지 말것 getRefCode10() 참조10
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}
		param.put("S_COMP_CODE",loginVO.getCompCode());
////////////////////////////////견적서출력추가//////////////////////////////////////

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());

		cdo = codeInfo.getCodeInfo("S012", "2");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());             // 자동채번여부(출하지시번호)정보

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
		model.addAttribute("gsExchangeRate", exchgRate.get("BASE_EXCHG"));                                                                                          // 자국화폐단위정보 조회

        cdo = codeInfo.getCodeInfo("S028", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsVatRate",cdo.getRefCode1());              // 부가세율정보 조회

        cdo = codeInfo.getCodeInfo("S036", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSof100rkrLink",   cdo.getCodeName());     // 링크프로그램정보(견적서) 조회


        cdo = codeInfo.getCodeInfo("S037", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSof100ukrLink",   cdo.getCodeName());     // 링크프로그램정보(수주등록) 조회

        List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("S010");
        if(!ObjUtils.isEmpty(inoutPrsn))    model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

        cdo = codeInfo.getCodeInfo("B917", "1");
        if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsFaxUseYn",   cdo.getRefCode1());     // FAX사용유무

		return JSP_PATH + "spp100ukrv";
	}

	@RequestMapping(value = "/sales/spp100skrv.do")
	public String spp100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());
		return JSP_PATH + "spp100skrv";
	}

	@RequestMapping(value = "/sales/spp200skrv.do")
	public String spp200skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());
		return JSP_PATH + "spp200skrv";
	}

	@RequestMapping(value = "/sales/srp100rkrv.do")
	public String srp100rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "srp100rkrv";
	}
}
