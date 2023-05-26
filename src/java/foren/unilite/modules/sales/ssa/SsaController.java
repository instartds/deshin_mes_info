package foren.unilite.modules.sales.ssa;

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
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.modules.sales.ssa.Ssa720ukrvServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
@SuppressWarnings("unchecked")
public class SsaController extends UniliteCommonController {

	@Resource(name = "salesCommonService")
	private SalesCommonServiceImpl salesCommonService;

	@Resource(name="ssa700ukrvService")
	private Ssa700ukrvServiceImpl ssa700ukrvService;

	@Resource(name="ssa100ukrvService")
	private Ssa100ukrvServiceImpl ssa100ukrvService;

	@Resource(name="ssa790skrvService")
	private Ssa790skrvServiceImpl ssa790skrvService;

	@Resource( name = "ssa720ukrvService" )
	private Ssa720ukrvServiceImpl   ssa720ukrvService;

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	final static String JSP_PATH = "/sales/ssa/";



	@RequestMapping(value = "/sales/ssa200rkrv.do")
	public String ssa200rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ssa200rkrv";
	}

	@RequestMapping(value = "/sales/ssa200skrv.do")
	public String ssa200skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "ssa200skrv";
	}

	@RequestMapping(value = "/sales/ssa300skrv.do")
	public String ssa300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa300skrv";
	}

	@RequestMapping(value = "/sales/ssa430rkrv.do")
	public String ssa430rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false); //자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");
		return JSP_PATH + "ssa430rkrv";
	}

	@RequestMapping(value = "/sales/ssa430skrv.do")
	public String ssa430skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false); //자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa430skrv";
	}

	@RequestMapping(value = "/sales/ssa450rkrv.do")
	public String ssa450rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa450rkrv";
	}

	@RequestMapping(value = "/sales/ssa450skrv.do")
	public String ssa450skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		//20200526 추가
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B259", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
	     }else {
	            model.addAttribute("gsSiteCode", "STANDARD");
	     }
		return JSP_PATH + "ssa450skrv";
	}
	
	@RequestMapping(value = "/sales/ssa453skrv.do")
	public String ssa453skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		//20200526 추가
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B259", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
	     }else {
	            model.addAttribute("gsSiteCode", "STANDARD");
	     }
		 
		List<CodeDetailVO> salePrsnCdList = codeInfo.getCodeList("S010");		//영업담당 List
		if(!ObjUtils.isEmpty(salePrsnCdList))	model.addAttribute("grsSalePrsn",ObjUtils.toJsonStr(salePrsnCdList));		 
		 
		List<CodeDetailVO> gsSalesPrsn = codeInfo.getCodeList("S010", "", false);//로그인 유저와 같은 영업담당자 가져오기
		for(CodeDetailVO map : gsSalesPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode5()))	{
				model.addAttribute("gsSalesPrsn",map.getCodeNo());
			}
		}		 
		return JSP_PATH + "ssa453skrv";
	}
	

	/**
	 * 매출현황조회(ITEM) (ssa452skrv)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa452skrv.do")
	public String ssa452skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		//default 환산 화폐단위
		List<CodeDetailVO> gsMoneyUnitRef4 = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnitRef4) {
			if("Y".equals(map.getRefCode4())) {
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

		return JSP_PATH + "ssa452skrv";
	}

	@RequestMapping(value = "/sales/ssa455skrv.do")
	public String ssa455skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa455skrv";
	}

	@RequestMapping(value = "/sales/ssa456skrv.do")
	public String ssa456skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa456skrv";
	}

	/**
	 * 매출집계현황 (ssa460skrv)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa460skrv.do")
	public String ssa460skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		//default 환산 화폐단위
		List<CodeDetailVO> gsMoneyUnitRef4 = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnitRef4) {
			if("Y".equals(map.getRefCode4())) {
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

		return JSP_PATH + "ssa460skrv";
	}

	/**
	 * 매출집계현황II (ssa461skrv): 20191016 신규 생성
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa461skrv.do")
	public String ssa461skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//기본 화폐단위, 환산 화폐단위, 환산 환율 가져오기 위한 로직
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		return JSP_PATH + "ssa461skrv";
	}

	@RequestMapping(value = "/sales/ssa500skrv.do")
	public String ssa500skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa500skrv";
	}

	/**
	 * 매출실적집계표 (ssa501skrv) - 20191016 신규 생성
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa501skrv.do")
	public String ssa501skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");	//영업담당 가져오기
		if(!ObjUtils.isEmpty(salePrsn)) {
//			model.addAttribute("salePrsn", ObjUtils.toJsonStr(salePrsn));
			for(CodeDetailVO map : salePrsn) {
				if(loginVO.getUserID().equals(map.getRefCode5())) {
					model.addAttribute("gsSalesPrsn", map.getCodeNo());	//로그인 유저의 영업담당 가져오기
				}
			}
		}

		return JSP_PATH + "ssa501skrv";
	}

	@RequestMapping(value = "/sales/ssa510skrv.do")
	public String ssa510skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa510skrv";
	}

	@RequestMapping(value = "/sales/ssa511skrv.do")
	public String ssa511skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa511skrv";
	}
	
	@RequestMapping(value = "/sales/ssa540skrv.do")
	public String ssa540skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		//20200526 추가
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B259", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
	     }else {
	            model.addAttribute("gsSiteCode", "STANDARD");
	     }
		return JSP_PATH + "ssa540skrv";
	}

	@RequestMapping(value = "/sales/ssa550skrv.do")
	public String ssa550skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_POS_NO", comboService.getPosNo(param));

		return JSP_PATH + "ssa550skrv";
	}

	@RequestMapping(value = "/sales/ssa610skrv.do")
	public String ssa610skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa610skrv";
	}

	/**
	 * 거래처원장 조회(매출/매입) (ssa615skrv) - 20210330 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa615skrv.do")
	public String ssa615skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session				= _req.getSession();
		Map<String, Object> param	= navigator.getParam();
		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//20210331 추가: 링크 프로그램 정보 가져오는 로직 추가
		List<CodeDetailVO> linkPaths = codeInfo.getCodeList("S037", "", false);		//기본 화폐단위
		for(CodeDetailVO map : linkPaths) {
			if("ssa615skrv".equals(map.getCodeName())) {
				model.addAttribute("gsLinkPgID1", map.getRefCode5());	//지급결의 등록
				model.addAttribute("gsLinkPgID2", map.getRefCode6());	//매출등록
				model.addAttribute("gsLinkPgID3", map.getRefCode7());	//수금등록
				model.addAttribute("gsLinkPgID4", map.getRefCode8());	//회계전표입력
			}
		}
		return JSP_PATH + "ssa615skrv";
	}

	/**
	 * 거래처원장 조회(세금계산서) - 20190816 신규 생성
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa620skrv.do")
	public String ssa620skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa620skrv";
	}

	/**
	 * 일별업무현황(매입/매출) (ssa625skrv) - 20210503 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa625skrv.do")
	public String ssa625skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session				= _req.getSession();
		Map<String, Object> param	= navigator.getParam();
		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> linkPaths = codeInfo.getCodeList("S037", "", false);		//기본 화폐단위
		for(CodeDetailVO map : linkPaths) {
			if("ssa615skrv".equals(map.getCodeName())) {				//ssa615skrv와 동일하게 링크
				model.addAttribute("gsLinkPgID1", map.getRefCode5());	//지급결의 등록
				model.addAttribute("gsLinkPgID2", map.getRefCode6());	//매출등록
				model.addAttribute("gsLinkPgID3", map.getRefCode7());	//수금등록
			}
		}
		return JSP_PATH + "ssa625skrv";
	}

	/**
	 * 일일업무(II) (ssa626skrv) - 20210614 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa626skrv.do")
	public String ssa626skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session				= _req.getSession();
		Map<String, Object> param	= navigator.getParam();
		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> linkPaths = codeInfo.getCodeList("S037", "", false);		//기본 화폐단위
		for(CodeDetailVO map : linkPaths) {
			if("ssa615skrv".equals(map.getCodeName())) {				//ssa615skrv와 동일하게 링크
				model.addAttribute("gsLinkPgID1", map.getRefCode5());	//지급결의 등록
				model.addAttribute("gsLinkPgID2", map.getRefCode6());	//매출등록
				model.addAttribute("gsLinkPgID3", map.getRefCode7());	//수금등록
			}
		}
		return JSP_PATH + "ssa626skrv";
	}

	/**
	 * 채권채무현황 (ssa630skrv) - 20210504 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa630skrv.do")
	public String ssa630skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session				= _req.getSession();
		Map<String, Object> param	= navigator.getParam();
		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> linkPaths = codeInfo.getCodeList("S037", "", false);		//기본 화폐단위
		for(CodeDetailVO map : linkPaths) {
			if("ssa615skrv".equals(map.getCodeName())) {				//ssa615skrv와 동일하게 링크
				model.addAttribute("gsLinkPgID1", map.getRefCode5());	//지급결의 등록
				model.addAttribute("gsLinkPgID2", map.getRefCode6());	//매출등록
				model.addAttribute("gsLinkPgID3", map.getRefCode7());	//수금등록
			}
		}
		return JSP_PATH + "ssa630skrv";
	}

	@RequestMapping(value = "/sales/ssa600skrv.do")
	public String ssa600skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		i = 0;
		List<CodeDetailVO> gsAmtBase = codeInfo.getCodeList("S117", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsAmtBase) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsAmtBase", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsAmtBase", "1");

		//20210331 추가: 사이트 구분 운영코드(B259) 가져오는 로직 추가
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B259", "1");
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			} else {
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
			model.addAttribute("gsSiteCode", "STANDARD");
		}
		return JSP_PATH + "ssa600skrv";
	}

	@RequestMapping(value = "/sales/ssa660skrv.do")
	public String ssa660skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa660skrv";
	}

	@RequestMapping(value = "/sales/ssa530skrv.do")
	public String ssa530skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa530skrv";
	}

	@RequestMapping(value = "/sales/ssa520skrv.do")
	public String ssa520skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa520skrv";
	}

	@RequestMapping(value = "/sales/ssa580skrv.do")
	public String ssa580skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa580skrv";
	}
	@RequestMapping(value = "/sales/ssa580rkrv.do")
	public String ssa580rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		return JSP_PATH + "ssa580rkrv";
	}
	@RequestMapping(value = "/sales/ssa590skrv.do")
	public String ssa590skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa590skrv";
	}
	@RequestMapping(value = "/sales/ssa590rkrv.do")
	public String ssa590rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa590rkrv";
	}
	@RequestMapping(value = "/sales/ssa300ukrv.do")
	public String ssa300ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa300ukrv";
	}

	@RequestMapping(value = "/sales/ssa670ukrv.do")
	public String ssa670ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa670ukrv";
	}

	@RequestMapping(value = "/sales/ssa700skrv.do")
	public String ssa700skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa700skrv";
	}

	@RequestMapping(value = "/sales/ssa710skrv.do")
	public String ssa710skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa710skrv";
	}

	@RequestMapping(value = "/sales/ssa740skrv.do")
	public String ssa740skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa740skrv";
	}

	@RequestMapping(value = "/sales/ssa750skrv.do")
	public String ssa750skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa750skrv";
	}

	@RequestMapping(value = "/sales/ssa760skrv.do")
	public String ssa760skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa760skrv";
	}

	@RequestMapping(value = "/sales/ssa770skrv.do")
	public String ssa770skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa770skrv";
	}

	@RequestMapping(value = "/sales/ssa780skrv.do")
	public String ssa780skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa780skrv";
	}

	@RequestMapping(value = "/sales/ssa790skrv.do")
	public String ssa790skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		List<Map<String, Object>> deptList = ssa790skrvService.getDeptList(param);		//부서목록 조회
		model.addAttribute("deptList",ObjUtils.toJsonStr(deptList));
		return JSP_PATH + "ssa790skrv";
	}

	@RequestMapping(value = "/sales/ssa720skrv.do")
	public String ssa720skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa720skrv";
	}

	@RequestMapping(value = "/sales/ssa730skrv.do")
	public String ssa730skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa730skrv";
	}

	@RequestMapping(value = "/sales/ssa800skrv.do")
	public String ssa800skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa800skrv";
	}

	@RequestMapping(value = "/sales/ssa810skrv.do")
	public String ssa810skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "ssa810skrv";
	}

	@RequestMapping(value = "/sales/ssa820skrv.do")
	public String ssa820skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "ssa820skrv";
	}


	/*
	 *  전자세금계산서
	 */

	@RequestMapping(value = "/sales/ssa700ukrv.do")
	public String ssa700ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S037", "5");	// (영업) 링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSsa560UkrLink",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSsa560UkrLink", "ssa560Ukrv");
		}

		cdo = codeInfo.getCodeInfo("T113", "53");	// (무역) 링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsTem100UkrLink",cdo.getRefCode2());
		}else {
			model.addAttribute("gsTem100UkrLink", "tem100ukrv");
		}

		cdo = codeInfo.getCodeInfo("A125", "3");	// (회계) 링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAtx110UkrLink",cdo.getRefCode3());
		}else {
			model.addAttribute("gsAtx110UkrLink", "atx110ukr");
		}

		int i = 0;
		List<CodeDetailVO> gsOptQ = codeInfo.getCodeList("S053", "", false);	//수량단위구분
		for(CodeDetailVO map : gsOptQ) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptQ", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptQ", "1");

		List<Map<String, Object>> gsBillYN = ssa700ukrvService.getGsBillYN(param);	//연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		if(ObjUtils.isEmpty(gsBillYN)){
			gsBillYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("SUB_CODE", "01");		//01센드빌 02웹캐시
			map.put("REF_CODE4", "NAME");	 //품목표시컬럼설정
			map.put("REF_CODE5", "N");		//품명수정여부
			map.put("REF_CODE6", "N");		//출력여부
			map.put("REF_CODE7", "");		//출력파일명
			map.put("REF_CODE8", "8");		//페이지내 최대건수
			map.put("REF_CODE9", "N");		//합계표시여부
			gsBillYN.add(map);
		}
		model.addAttribute("gsBillYN",ObjUtils.toJsonStr(gsBillYN));


		model.addAttribute("SALES_PRSN", ssa700ukrvService.getSalesPrsn(param));

		String jspPath =  JSP_PATH ;
		List<CodeDetailVO> invoiceType = codeInfo.getCodeList("S084", "", false);	//전자세금계산서 구분
		for(CodeDetailVO map : invoiceType) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("invoiceType", map.getCodeNo());
				if("01".equals(map.getCodeNo())) {
					jspPath +="ssa700ukrv1";			   //센드빌
				}else if("02".equals(map.getCodeNo())) {
					jspPath +="ssa700ukrv2";			   //웹캐시
				}
			}
		}
		return jspPath;
	}

	@RequestMapping(value = "/sales/ssa110ukrv.do")
	public String ssa110ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa110ukrv";
	}

	@RequestMapping(value = "/sales/ssa671ukrv.do")
	public String ssa671ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa671ukrv";
	}

	@RequestMapping(value = "/sales/ssa710ukrv.do")
	public String ssa710ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa710ukrv";
	}

	@RequestMapping(value = "/sales/ssa120ukrv.do")
	public String ssa120ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa120ukrv";
	}
	@RequestMapping(value = "/sales/ssa451skrv.do")
	public String ssa451skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa451skrv";
	}
	@RequestMapping(value = "/sales/ssa200ukrv.do")
	public String ssa200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa200ukrv";
	}

	@RequestMapping(value = "/sales/ssa500ukrv.do")
	public String ssa500ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa500ukrv";
	}

	@RequestMapping(value = "/sales/ssa560rkrv.do")
	public String ssa560rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "ssa560rkrv";
	}

	@RequestMapping(value = "/sales/ssa560ukrv.do")
	public String ssa560ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		cdo = codeInfo.getCodeInfo("S012", "6");	//자동채번여부(수금번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		cdo = codeInfo.getCodeInfo("S036", "4");	//링크프로그램정보(세금계산서출력) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintPgm",cdo.getCodeName());
		}else {
			model.addAttribute("gsBusiPrintPgm", "ssa560Rkrv");
		}

		cdo = codeInfo.getCodeInfo("S037", "7");	//링크프로그램정보(자동기표등록) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoreg",cdo.getCodeName());
		}else {
			model.addAttribute("gsAutoreg", "agj260Ukr");
		}

		i = 0;																//true : 사용안함도  가져옴  false: 사용함만 가져옴
		List<CodeDetailVO> gsCollectDayFlg = codeInfo.getCodeList("B071", "", false);	//수금일설정정보 조회
		for(CodeDetailVO map : gsCollectDayFlg) {
			if(map.isInUse()){
				model.addAttribute("gsCollectDayFlg", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCollectDayFlg", "1");


		cdo = codeInfo.getCodeInfo("S110", "01");	//자거래처 참조 사용 유무
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsCustomGubun",cdo.getRefCode1());
		}else {
			model.addAttribute("gsCustomGubun", "N");
		}

		cdo = codeInfo.getCodeInfo("B078", "10");	//프로젝트코드 사용유무
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPjtCodeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsPjtCodeYN", "N");
		}

		cdo = codeInfo.getCodeInfo("S000", "03");	//세금계산서 영업담당 필수입력여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBillPrsnEssYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsBillPrsnEssYN", "N");
		}

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");	//영업담당 가져오기
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		i = 0;																//true : 사용안함도  가져옴  false: 사용함만 가져옴
		List<CodeDetailVO> gsBillYn = codeInfo.getCodeList("S084", "", false);	//수금일설정정보 조회
		for(CodeDetailVO map : gsBillYn) {
			if("Y".equals(map.getRefCode1())){
				String billYn = "";
				if("00".equals(map.getCodeNo())){
					billYn = "Y";
				}else{
					billYn = "N";
				}
				model.addAttribute("gsBillYn", billYn);
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsBillYn", "");

		List<CodeDetailVO> gsBillConnect = codeInfo.getCodeList("S084", "", false);	//센드빌인지 웹캐쉬 검색
		for(CodeDetailVO map : gsBillConnect) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsBillConnect", map.getCodeNo());
				model.addAttribute("gsBillDbUser", map.getRefCode10());
				i++;
			}
		}

		return JSP_PATH + "ssa560ukrv";
	}


	/**
	 * 개별세금계산서등록2(ssa561ukrv)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa561ukrv.do")
	public String ssa561ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		cdo = codeInfo.getCodeInfo("S012", "6");	//자동채번여부(수금번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		cdo = codeInfo.getCodeInfo("S036", "4");	//링크프로그램정보(세금계산서출력) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintPgm",cdo.getCodeName());
		}else {
			model.addAttribute("gsBusiPrintPgm", "ssa560Rkrv");
		}

		cdo = codeInfo.getCodeInfo("S037", "7");	//링크프로그램정보(자동기표등록) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoreg",cdo.getCodeName());
		}else {
			model.addAttribute("gsAutoreg", "agj260Ukr");
		}

		i = 0;																//true : 사용안함도  가져옴  false: 사용함만 가져옴
		List<CodeDetailVO> gsCollectDayFlg = codeInfo.getCodeList("B071", "", false);	//수금일설정정보 조회
		for(CodeDetailVO map : gsCollectDayFlg) {
			if(map.isInUse()){
				model.addAttribute("gsCollectDayFlg", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCollectDayFlg", "1");


		cdo = codeInfo.getCodeInfo("S110", "01");	//자거래처 참조 사용 유무
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsCustomGubun",cdo.getRefCode1());
		}else {
			model.addAttribute("gsCustomGubun", "N");
		}

		cdo = codeInfo.getCodeInfo("B078", "10");	//프로젝트코드 사용유무
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPjtCodeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsPjtCodeYN", "N");
		}

		cdo = codeInfo.getCodeInfo("S000", "03");	//세금계산서 영업담당 필수입력여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBillPrsnEssYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsBillPrsnEssYN", "N");
		}

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");	//영업담당 가져오기
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		i = 0;																//true : 사용안함도  가져옴  false: 사용함만 가져옴
		List<CodeDetailVO> gsBillYn = codeInfo.getCodeList("S084", "", false);	//수금일설정정보 조회
		for(CodeDetailVO map : gsBillYn) {
			if("Y".equals(map.getRefCode1())){
				String billYn = "";
				if("00".equals(map.getCodeNo())){
					billYn = "Y";
				}else{
					billYn = "N";
				}
				model.addAttribute("gsBillYn", billYn);
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsBillYn", "");

		List<CodeDetailVO> gsBillConnect = codeInfo.getCodeList("S084", "", false);	//센드빌인지 웹캐쉬 검색
		for(CodeDetailVO map : gsBillConnect) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsBillConnect", map.getCodeNo());
				model.addAttribute("gsBillDbUser", map.getRefCode10());
				i++;
			}
		}

		return JSP_PATH + "ssa561ukrv";
	}


	@RequestMapping(value = "/sales/ssa570ukrv.do")
	public String ssa570ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "6");	//자동채번여부(세금계산서번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		cdo = codeInfo.getCodeInfo("B078", "10");	//프로젝트코드 사용유무
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPjtCodeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsPjtCodeYN", "N");
		}

		cdo = codeInfo.getCodeInfo("S000", "03");	//영업담당 필수유무
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSalePrsnEssYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSalePrsnEssYN", "N");
		}
		//20190924 추가 - 사업장에 대한 사업자번호 가져오는 로직
		param.put("COMP_CODE"	, loginVO.getCompCode());
		param.put("DIV_CODE"	, loginVO.getDivCode());
		Object gsOwnNum = salesCommonService.fnGetOrgInfo(param);
		model.addAttribute("gsOwnNum",ObjUtils.toJsonStr(gsOwnNum));

		return JSP_PATH + "ssa570ukrv";
	}

	@RequestMapping(value = "/sales/ssa600ukrv.do")
	public String ssa600ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		return JSP_PATH + "ssa600ukrv";
	}

	@RequestMapping(value = "/sales/ssa100ukrv.do",method = RequestMethod.GET)
	public String ssa100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

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
		
		int i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//매출등록시 여신적용여부정보 조회
		for(CodeDetailVO map : gsCreditYn) {
			if("Y".equals(map.getRefCode1())){
				if(map.getCodeNo().equals("3")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		cdo = codeInfo.getCodeInfo("S012", "6");	//자동채번여부(매출번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvStatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvStatus", '+');
		}

		//출하창고정보 조회?
		//담당자정보 조회?

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");

		//매출등록(출고자동)
		cdo = codeInfo.getCodeInfo("S035", "1");
		if(!ObjUtils.isEmpty(cdo)){
			if("Y".equals(cdo.getRefCode1())){
				model.addAttribute("gsSaleAutoYN","Y");//자동
			}else{
				model.addAttribute("gsSaleAutoYN","N");//수동
			}
		}

		//링크프로그램정보 조회

		i = 0;
		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);	//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsProcessFlag", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsProcessFlag", "ZZZ");

		cdo = codeInfo.getCodeInfo("S053", "1");	//매출등록시 거래명세서 출력여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsBusiPrintYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("S036", "3");	//링크프로그램정보(거래명세서) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintPgm",cdo.getCodeName());
		}else {
			model.addAttribute("gsBusiPrintPgm", "Str400RKrv");
		}

		cdo = codeInfo.getCodeInfo("S056", "1");	//화폐환율 표시여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsMoneyExYn",cdo.getRefCode1());
		}else {
			model.addAttribute("gsMoneyExYn", 'N');
		}

		cdo = codeInfo.getCodeInfo("S058", "1");	//선매출사용여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAdvanUseYn", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "01");	//매출디테일 주거래처 표시여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsCustManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsCustManageYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "02");	//매출디테일 영업담당 관리여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPrsnManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsPrsnManageYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", 'Y');
			model.addAttribute("gsUnitChack", "EA");
		}

		cdo = codeInfo.getCodeInfo("S116", "ssa100ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		List<Map<String, Object>> gsManageLotNoYN = ssa100ukrvService.getGsManageLotNoYN(param);		//LOT 연계여부 조회
		if(ObjUtils.isEmpty(gsManageLotNoYN)){
			gsManageLotNoYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("MNG_LOT", "");
			map.put("ESS_YN", "");
			map.put("ESS_ACCOUNT", "");
			gsManageLotNoYN.add(map);
		}
		model.addAttribute("gsManageLotNoYN",ObjUtils.toJsonStr(gsManageLotNoYN));

		List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");		//출고유형 List
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		List<CodeDetailVO> salePrsnCdList = codeInfo.getCodeList("S010");		//영업담당 List
		if(!ObjUtils.isEmpty(salePrsnCdList))	model.addAttribute("grsSalePrsn",ObjUtils.toJsonStr(salePrsnCdList));

		//20191113 로그인한 유저의 영업담당 가져오는 로직 추가
		List<CodeDetailVO> gsSalesPrsn = codeInfo.getCodeList("S010", "", false);//로그인 유저와 같은 영업담당자 가져오기
		for(CodeDetailVO map : gsSalesPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode5()))	{
				model.addAttribute("gsSalesPrsn",map.getCodeNo());
			}
		}

		return JSP_PATH + "ssa100ukrv";
	}

	@RequestMapping(value = "/sales/ssa101ukrv.do",method = RequestMethod.GET)
	public String ssa101ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		int i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//매출등록시 여신적용여부정보 조회
		for(CodeDetailVO map : gsCreditYn) {
			if("Y".equals(map.getRefCode1())){
				if(map.getCodeNo().equals("3")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");





		cdo = codeInfo.getCodeInfo("S012", "6");	//자동채번여부(매출번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}





		i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");





		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}





		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvStatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvStatus", '+');
		}



		//출하창고정보 조회?
		//담당자정보 조회?



		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");




		//출고등록(매출자동),반품등록(매출자동),매출등록(출고자동),매출등록(반품자동)
		//링크프로그램정보 조회




		i = 0;
		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);	//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsProcessFlag", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsProcessFlag", "ZZZ");







		cdo = codeInfo.getCodeInfo("S053", "1");	//매출등록시 거래명세서 출력여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsBusiPrintYN", 'N');
		}





		cdo = codeInfo.getCodeInfo("S036", "3");	//링크프로그램정보(거래명세서) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintPgm",cdo.getCodeName());
		}else {
			model.addAttribute("gsBusiPrintPgm", "Str400RKrv");
		}





		cdo = codeInfo.getCodeInfo("S056", "1");	//화폐환율 표시여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsMoneyExYn",cdo.getRefCode1());
		}else {
			model.addAttribute("gsMoneyExYn", 'N');
		}




		cdo = codeInfo.getCodeInfo("S058", "1");	//선매출사용여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAdvanUseYn", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "01");	//매출디테일 주거래처 표시여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsCustManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsCustManageYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "02");	//매출디테일 영업담당 관리여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPrsnManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsPrsnManageYN", 'N');
		}





		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", 'Y');
			model.addAttribute("gsUnitChack", "EA");
		}






		cdo = codeInfo.getCodeInfo("S116", "ssa100ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}
		return JSP_PATH + "ssa101ukrv";
	}

	 /**
	 * 전자세금계산서 발행 (ATX170UKR) - 조인스 회계용
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/sales/ssa720ukrv.do" )
	public String ssa720ukrv( String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model ) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S037", "5");	// (영업) 링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSsa560UkrLink", cdo.getCodeName());
		}else {
			model.addAttribute("gsSsa560UkrLink", "ssa560Ukrv");
		}

		cdo = codeInfo.getCodeInfo("T113", "53"); // (무역) 링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsTem100UkrLink", cdo.getCodeName());
		}else {
			model.addAttribute("gsTem100UkrLink", "tem100ukrv");
		}

		cdo = codeInfo.getCodeInfo("A125", "3");	// (회계) 링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAtx110UkrLink", cdo.getCodeName());
		}else {
			model.addAttribute("gsAtx110UkrLink", "atx110ukr");
		}

		int i = 0;
		List<CodeDetailVO> gsOptQ = codeInfo.getCodeList("S053", "", false);	//수량단위구분
		for(CodeDetailVO map : gsOptQ)  {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptQ", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptQ", "1");

		List<Map<String, Object>> gsBillYN = ssa720ukrvService.getGsBillYN(param);//연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		if(ObjUtils.isEmpty(gsBillYN)){
			gsBillYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("SUB_CODE", "01");		//01센드빌 02웹캐시
			map.put("REF_CODE4", "NAME");	 //품목표시컬럼설정
			map.put("REF_CODE5", "N");		//품명수정여부
			map.put("REF_CODE6", "N");		//출력여부
			map.put("REF_CODE7", "");		//출력파일명
			map.put("REF_CODE8", "8");		//페이지내 최대건수
			map.put("REF_CODE9", "N");		//합계표시여부
			gsBillYN.add(map);
		}
		model.addAttribute("gsBillYN",ObjUtils.toJsonStr(gsBillYN));

		model.addAttribute("SALES_PRSN", ssa720ukrvService.getSalesPrsn(param));

		return JSP_PATH + "ssa720ukrv";
	}
	@RequestMapping(value = "/sales/ssa460rkrv.do")
	public String ssa460rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "ssa460rkrv";
	}




	/**
	 * 임대매출현황 (ssa390skrv)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa390skrv.do",method = RequestMethod.GET)
	public String ssa390skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "ssa390skrv";
	}

	/**
	 * 임대매출등록 (ssa390ukrv)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa390ukrv.do",method = RequestMethod.GET)
	public String ssa390ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		int i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//매출등록시 여신적용여부정보 조회
		for(CodeDetailVO map : gsCreditYn) {
			if("Y".equals(map.getRefCode1())){
				if(map.getCodeNo().equals("3")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		cdo = codeInfo.getCodeInfo("S012", "6");	//자동채번여부(매출번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvStatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvStatus", '+');
		}

		//출하창고정보 조회?
		//담당자정보 조회?

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");

		//매출등록(출고자동)
		cdo = codeInfo.getCodeInfo("S035", "1");
		if(!ObjUtils.isEmpty(cdo)){
			if("Y".equals(cdo.getRefCode1())){
				model.addAttribute("gsSaleAutoYN","Y");//자동
			}else{
				model.addAttribute("gsSaleAutoYN","N");//수동
			}
		}

		//링크프로그램정보 조회

		i = 0;
		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);	//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsProcessFlag", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsProcessFlag", "ZZZ");

		cdo = codeInfo.getCodeInfo("S053", "1");	//매출등록시 거래명세서 출력여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsBusiPrintYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("S036", "3");	//링크프로그램정보(거래명세서) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintPgm",cdo.getCodeName());
		}else {
			model.addAttribute("gsBusiPrintPgm", "Str400RKrv");
		}

		cdo = codeInfo.getCodeInfo("S056", "1");	//화폐환율 표시여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsMoneyExYn",cdo.getRefCode1());
		}else {
			model.addAttribute("gsMoneyExYn", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "01");	//매출디테일 주거래처 표시여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsCustManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsCustManageYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "02");	//매출디테일 영업담당 관리여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPrsnManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsPrsnManageYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", 'Y');
			model.addAttribute("gsUnitChack", "EA");
		}

		cdo = codeInfo.getCodeInfo("S116", "ssa100ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		List<Map<String, Object>> gsManageLotNoYN = ssa100ukrvService.getGsManageLotNoYN(param);		//LOT 연계여부 조회
		if(ObjUtils.isEmpty(gsManageLotNoYN)){
			gsManageLotNoYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("MNG_LOT", "");
			map.put("ESS_YN", "");
			map.put("ESS_ACCOUNT", "");
			gsManageLotNoYN.add(map);
		}
		model.addAttribute("gsManageLotNoYN",ObjUtils.toJsonStr(gsManageLotNoYN));

		List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");		//출고유형 List
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		List<CodeDetailVO> salePrsnCdList = codeInfo.getCodeList("S010");		//영업담당 List
		if(!ObjUtils.isEmpty(salePrsnCdList))	model.addAttribute("grsSalePrsn",ObjUtils.toJsonStr(salePrsnCdList));

		return JSP_PATH + "ssa390ukrv";
	}

	/**
	 * 유지보수매출등록 (ssa400ukrv)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa400ukrv.do",method = RequestMethod.GET)
	public String ssa400ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		int i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//매출등록시 여신적용여부정보 조회
		for(CodeDetailVO map : gsCreditYn) {
			if("Y".equals(map.getRefCode1())){
				if(map.getCodeNo().equals("3")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		cdo = codeInfo.getCodeInfo("S012", "6");	//자동채번여부(매출번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvStatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvStatus", '+');
		}

		//출하창고정보 조회?
		//담당자정보 조회?

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");

		//매출등록(출고자동)
		cdo = codeInfo.getCodeInfo("S035", "1");
		if(!ObjUtils.isEmpty(cdo)){
			if("Y".equals(cdo.getRefCode1())){
				model.addAttribute("gsSaleAutoYN","Y");//자동
			}else{
				model.addAttribute("gsSaleAutoYN","N");//수동
			}
		}

		//링크프로그램정보 조회

		i = 0;
		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);	//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsProcessFlag", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsProcessFlag", "ZZZ");

		cdo = codeInfo.getCodeInfo("S053", "1");	//매출등록시 거래명세서 출력여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsBusiPrintYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("S036", "3");	//링크프로그램정보(거래명세서) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBusiPrintPgm",cdo.getCodeName());
		}else {
			model.addAttribute("gsBusiPrintPgm", "Str400RKrv");
		}

		cdo = codeInfo.getCodeInfo("S056", "1");	//화폐환율 표시여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsMoneyExYn",cdo.getRefCode1());
		}else {
			model.addAttribute("gsMoneyExYn", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "01");	//매출디테일 주거래처 표시여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsCustManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsCustManageYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("S000", "02");	//매출디테일 영업담당 관리여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPrsnManageYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsPrsnManageYN", 'N');
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", 'Y');
			model.addAttribute("gsUnitChack", "EA");
		}

		cdo = codeInfo.getCodeInfo("S116", "ssa100ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");		//출고유형 List
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		List<CodeDetailVO> salePrsnCdList = codeInfo.getCodeList("S010");		//영업담당 List
		if(!ObjUtils.isEmpty(salePrsnCdList))	model.addAttribute("grsSalePrsn",ObjUtils.toJsonStr(salePrsnCdList));

		return JSP_PATH + "ssa400ukrv";
	}
}
