package foren.unilite.modules.sales.sof;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.hum.Hum100ukrServiceImpl;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Controller
@SuppressWarnings("unchecked")
public class SofContoroller extends UniliteCommonController {
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name = "salesCommonService")
	private SalesCommonServiceImpl salesCommonService;

	@Resource( name = "sof100ukrvService")
	private Sof100ukrvServiceImpl sof100ukrvService;

	@Resource( name = "sof104ukrvService")				//20210614 추가: user combo 생성하기 위해 추가
	private Sof104ukrvServiceImpl sof104ukrvService;


	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/sales/sof/";


	@RequestMapping(value = "/sales/sof100rkrv.do")
	public String sof100rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		return JSP_PATH + "sof100rkrv";
	}

	@RequestMapping(value = "/sales/sof100skrv.do")
	public String sof100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "sof100skrv";
	}

	/**
	 * 수주현황 조회(품목별) (sof102skrv)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof102skrv.do")
	public String sof102skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "sof102skrv";
	}

	/**
	 * 수주일괄등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof102ukrv.do")
	public String sof102ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		return JSP_PATH + "sof102ukrv";
	}

	/**
	 * 수주일괄등록II (sof103ukrv) - 20191028 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof103ukrv.do")
	public String sof103ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		return JSP_PATH + "sof103ukrv";
	}

	/**
	 * 수주납기변경등록 (sof104ukrv) - 20210614 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof104ukrv.do")
	public String sof104ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		model.addAttribute("userCombo", sof104ukrvService.getUserInfo(param));

		return JSP_PATH + "sof104ukrv";
	}

	@RequestMapping(value = "/sales/sof110skrv.do")
	public String sof110skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "sof110skrv";
	}

	@RequestMapping(value = "/sales/sof115skrv.do")
	public String sof115skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "sof115skrv";
	}

	@RequestMapping(value = "/sales/sof120skrv.do")
	public String sof120skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "sof120skrv";
	}

	@RequestMapping(value = "/sales/sof200skrv.do")
	public String sof200skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "sof200skrv";
	}

	@RequestMapping(value = "/sales/sof200rkrv.do")
	public String sof200rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		return JSP_PATH + "sof200rkrv";
	}

	/**
	 * 수주별BOM정보조회 (sof210skrv) - 20200821 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof210skrv.do")
	public String sof210skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields = {  };
//		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
//		Map<String, Object> param = navigator.getParam();
//		String page = _req.getP("page");

//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "sof210skrv";
	}


	/**
	 * 초도수주현황 (sof220skrv) - 20210908 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof220skrv.do")
	public String sof220skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));

		return JSP_PATH + "sof220skrv";
	}

	@RequestMapping(value = "/sales/sof300skrv.do")
	public String sof300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "sof300skrv";
	}

	@RequestMapping(value = "/sales/sof320skrv.do")
	public String sof320skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "sof320skrv";
	}

	@RequestMapping(value = "/sales/sof101skrv.do")
	public String sof101skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "sof101skrv";
	}

	/**
	 * 수주등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof100ukrv.do",method = RequestMethod.GET)
	public String sof100ukrv( LoginVO loginVO, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		/* 신용여신액 초과시 메세지 설정 */
		List<CodeDetailVO> gsCreditMsgCode = codeInfo.getCodeList("S181", "", false);
		String gsCreditMsg = "W"; // 경고 default
		for(CodeDetailVO map : gsCreditMsgCode) {
			if("Y".equals(map.getRefCode1())){
				gsCreditMsg = map.getCodeNo();
				break;
			}
		}
		model.addAttribute("gsCreditMsg", gsCreditMsg);
		
		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());		//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType"	, cdo.getRefCode1());		//Y:수주번호(txtOrderNum) lock,disable
		//20191014 추가:수주번호 수동입력일 경우, 자릿수 가져오는 로직
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSNMinLen"	, cdo.getRefCode4());		//수동입력시 수주번호 자릿수 (min) 
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSNMaxLen"	, cdo.getRefCode5());		//수동입력시 수주번호 자릿수 (max) 
		
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsBalanceOut = codeInfo.getCodeList("WB06", "", false);			//B/OUT 체크
		for(CodeDetailVO map : gsBalanceOut) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBalanceOut", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);
		for(CodeDetailVO map : gsProdtDtAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);
		for(CodeDetailVO map : gsSaleAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSaleAutoYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S037", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSof100ukrLink",	cdo.getCodeName());


		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());			//출하지시등록 링크 PGM ID
			model.addAttribute("gsSrq100UkrPath",	cdo.getRefCode5());			//20210203 추가: 출하지시등록 링크 PGM PATH
		}

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "4");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSsa100UkrLink",	cdo.getCodeName());				//매출등록 링크 PGM ID

		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);
		for(CodeDetailVO map : gsProcessFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsCondShowFlag = codeInfo.getCodeList("S043", "", false);
		for(CodeDetailVO map : gsCondShowFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCondShowFlag", map.getCodeNo());				//Y:수주내역의 할인율,할인율일괄적용,해당행 visible
			}
		}

		List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);
		for(CodeDetailVO map : gsDraftFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				if(map.getCodeNo().equals("1")){
					model.addAttribute("gsDraftFlag", "Y");					//Y:수주승인관련 필드
				}else{
					model.addAttribute("gsDraftFlag", "N");					//N:자동승인관련 필드
				}
			}
		}

		cdo = codeInfo.getCodeInfo("S045", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp1AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp1AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S045", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp2AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsTimeYN",			cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S061", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmUseYN",		cdo.getRefCode1());				//Y:SCM연계탭 enable

		cdo = codeInfo.getCodeInfo("B078", "10");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPjtCodeYN",		cdo.getRefCode1());				//Y:수주검색팝업에 txtPlanNum enable

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn",			cdo.getRefCode1());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
			model.addAttribute("gsUnitChack",		cdo.getRefCode2());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}

		List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
		List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOrderTypeSaleYN)	{
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			aMap.put("REF_CODE1", map.getRefCode1());
			listOrderTypeSaleYN.add(aMap);
		}
		model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

		List<CodeDetailVO> gsProdSaleQ_WS03 = codeInfo.getCodeList("WS03", "", false);
		for(CodeDetailVO map : gsProdSaleQ_WS03) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsProdSaleQ_WS03", map.getCodeNo());
			} else {
				model.addAttribute("gsProdSaleQ_WS03", "N");
			}
		}

		List<CodeDetailVO> gsProdDate_WS04 = codeInfo.getCodeList("WS04", "", false);
		for(CodeDetailVO map : gsProdDate_WS04) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsProdDate_WS04", map.getCodeNo());
			} else {
				model.addAttribute("gsProdDate_WS04", "N");
			}
		}

		List<CodeDetailVO> salesPrsn = codeInfo.getCodeList("S010", "", false);
		List<Map> divPrsn = new ArrayList<Map>();
		for(CodeDetailVO map : salesPrsn)	{
			Map rMap = new HashMap();
			rMap.put("value",map.getCodeNo());
			rMap.put("text", map.getCodeName());
			rMap.put("option",map.getRefCode1());
			divPrsn.add(rMap);
		}
		model.addAttribute("divPrsn", divPrsn);

		//SRM 데이터수신 사용여부 확인 (공통코드 S146의 SUB_CODE = '1'의 REF_CODE1)
		cdo = codeInfo.getCodeInfo("S146", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseReceiveSrmYN", cdo.getRefCode1());	 // 생산자동채번유무

		List<CodeDetailVO> gsSalesPrsn = codeInfo.getCodeList("S010", "", false);//로그인 유저와 같은 영업담당자 가져오기
		for(CodeDetailVO map : gsSalesPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode5()))	{
				model.addAttribute("gsSalesPrsn",map.getCodeNo());
			}
		}

		//영업납기리드타임 관련
		Map<String, Object> tempParam = new HashMap<String, Object>();
		tempParam.put("S_COMP_CODE", loginVO.getCompCode());
		Map tempMap = (Map) sof100ukrvService.selectGsDvry(tempParam);

		model.addAttribute("gsDvryDate",tempMap.get("gsDvryDate"));

		tempParam.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(tempParam));
		//model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(tempParam));

		//20190607 SAMPLE코드 사용여부(B912)
		cdo = codeInfo.getCodeInfo("B912", "1");
		if(!ObjUtils.isEmpty(cdo)){
				model.addAttribute("gsSampleCodeYn", cdo.getRefCode1());
		} else {
				model.addAttribute("gsSampleCodeYn", "N");
		}

		//20190625 재료수량을 가용재고로 표시할지 여부(S513)
		cdo = codeInfo.getCodeInfo("S153", "1");
		if(!ObjUtils.isEmpty(cdo)){
				model.addAttribute("gsPStockYn", cdo.getRefCode1());
		} else {
				model.addAttribute("gsPStockYn", "N");
		}

		//20190827 내부기록 필수여부 체크로직(S154)
		cdo = codeInfo.getCodeInfo("S154", "1");
		if(!ObjUtils.isEmpty(cdo)){
				model.addAttribute("gsRemarkInYn", cdo.getRefCode1());
		} else {
				model.addAttribute("gsRemarkInYn", "N");
		}

		//20190925 OFFER_NO 자동채번 여부
		cdo = codeInfo.getCodeInfo("T100", "01");
		if(!ObjUtils.isEmpty(cdo)){
				model.addAttribute("gsAutoOfferNo", cdo.getRefCode1());
		} else {
				model.addAttribute("gsAutoOfferNo", "N");
		}

		 cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
		}else {
			model.addAttribute("gsSiteCode", "STANDARD");
		}
		//20210507 추가
		cdo = codeInfo.getCodeInfo("S037", "1");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsButtonLink1",	cdo.getRefCode5());			//20210507 추가: 미수채권현황(정규), 매입/매출조회(WM)
			model.addAttribute("gsButtonLink2",	cdo.getRefCode6());			//20210507 추가: 기간별수불현황 조회(정규), 기간별 수불현황 조회(WM)(WM)
		}
		
		cdo = codeInfo.getCodeInfo("S044", "2");
		if(!ObjUtils.isEmpty(cdo)){
				model.addAttribute("gsConfirmeYn", cdo.getRefCode1());
		} else {
				model.addAttribute("gsConfirmeYn", "N");
		}		
		return JSP_PATH + "sof100ukrv";
	}


	/**
	 * 수주 확정
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof190ukrv.do",method = RequestMethod.GET)
	public String sof190ukrv( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "sof190ukrv";
	}

	/**
	 * 수주번호검색 팝업
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sof100ukrp1v.do",method = RequestMethod.GET)
	public String sof100ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "sof100ukrp1v";
	}

	@RequestMapping(value = "/sales/sof300ukrv.do")
	public String sof300ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "sof300ukrv";
	}

	@RequestMapping(value = "/sales/sof301ukrv.do")
	public String sof301ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "sof301ukrv";
	}

	@RequestMapping(value = "/sales/sof200ukrv.do")
	public String sof200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "sof200ukrv";
	}

	/*
	 * 납기일 일괄변경
	 * */
	@RequestMapping(value = "/sales/sof201ukrv.do")
	public String sof201ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "sof201ukrv";
	}

	@RequestMapping(value = "/sales/sof130ukrv.do", method = RequestMethod.GET)
	public String sof130ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "sof130ukrv";
	}
	
	/*pivot 테스트 */
	@RequestMapping(value = "/sales/sof197skrv.do", method = RequestMethod.GET)
	public String bsa9998ukrv() throws Exception {
		return JSP_PATH + "sof197skrv";
	}

	@RequestMapping(value = "/sales/sof198skrv.do", method = RequestMethod.GET)
	public String bsa9997ukrv() throws Exception {
		return JSP_PATH + "sof198skrv";
	}
}