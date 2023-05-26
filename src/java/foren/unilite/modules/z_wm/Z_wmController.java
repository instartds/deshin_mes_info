package foren.unilite.modules.z_wm;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.clipsoft.jsEngine.javascript.json.JsonParser;
import com.google.gson.Gson;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.utils.AES256DecryptoUtils;

import java.io.File;											//20201016 추가
import java.io.FileInputStream;									//20201016 추가
import java.io.ByteArrayOutputStream;							//20201016 추가

import sun.misc.BASE64Encoder;									//20201016 추가

import org.apache.commons.codec.binary.Base64;
import org.apache.poi.hssf.usermodel.HSSFFormulaEvaluator;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@Controller
@SuppressWarnings("rawtypes")
public class Z_wmController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/z_wm/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	//20201110 추가 - 입고처 가져와서 동적 컬럼 구성하기 위해
	@Resource(name="s_biv310skrv_wmService")
	private S_Biv310skrv_wmServiceImpl s_biv310skrv_wmService;

	//20201021 추가 - 불량유형 가져와서 동적 컬럼 구성하기 위해
	@Resource(name="s_mba100ukrv_wmService")
	private S_Mba100ukrv_wmServiceImpl s_mba100ukrv_wmService;

	//20201214 추가 - 동적 그리드 구현(공통코드(ZM04)에서 컬럼 가져오는 로직)위해 추가
	@Resource(name="s_mis100skrv_wmService")
	private S_Mis100skrv_wmServiceImpl s_mis100skrv_wmService;

	//20201230 추가 - 동적 그리드 구현(공통코드(Q011)에서 컬럼 가져오는 로직)위해 추가
	@Resource(name="s_mms200ukrv_wmService")
	private S_Mms200ukrv_wmServiceImpl s_mms200ukrv_wmService;

	//20201016 추가 - 사용자의 서명 가져오기 위해 추가
	@Resource(name="s_mpo010ukrv_wmService")
	private S_Mpo010ukrv_wmServiceImpl s_mpo010ukrv_wmService;

	//20210330 추가 - 사용자의 서명 가져오기 위해 추가
	@Resource(name="s_mpo015ukrv_wmService")
	private S_Mpo015ukrv_wmServiceImpl s_mpo015ukrv_wmService;

	//20210322 추가
	@Resource(name="s_pmp110rkrv_wmService")
	private S_Pmp110rkrv_wmServiceImpl s_pmp110rkrv_wmService;

	//20201020 추가
	@Resource(name="s_pmp110ukrv_wmService")
	private S_Pmp110ukrv_wmServiceImpl s_pmp110ukrv_wmService;

	//20201124 추가
	@Resource( name = "s_pmr100ukrv_wmService" )
	private S_Pmr100ukrv_wmServiceImpl s_pmr100ukrv_wmService;

	@Resource(name="s_sal100ukrv_wmService")
	private S_Sal100ukrv_wmServiceImpl s_sal100ukrv_wmService;

	//20210617 추가 - 선택된 데이터만 엑셀 다운로드 하는 기능을 구현하기 위해 추가(사용 안 함 - 공통 프로세스로직 사용하도록 변경)
/*	@Resource(name="s_srq100ukrv_wmService")
	private S_Srq100ukrv_wmServiceImpl s_srq100ukrv_wmService;*/



	/**
	 * 재고현황조회(WM) (s_biv310skrv_wm) - 20201110 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_biv310skrv_wm.do")
	public String s_biv310skrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		//동적 그리드 구현(공통코드(ZM04)에서 컬럼 가져오는 로직)
		Gson gson = new Gson();
		String colData	= gson.toJson(s_biv310skrv_wmService.selectColumns(loginVO));	//공통코드(ZM04)에서 컬럼 가져오는 로직
		String colData2	= gson.toJson(s_biv310skrv_wmService.selectColumns2(loginVO));	//창고정보 테이블에서 컬럼 가져오는 로직
		model.addAttribute("colData"	, colData);
		model.addAttribute("colData2"	, colData2);

		return JSP_PATH + "s_biv310skrv_wm";
	}


	/**
	 * 기간별 수불현황 조회(WM) (s_biv360skrv_wm) - 20210506 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_biv360skrv_wm.do")
	public String s_biv360skrv_wm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));

		return JSP_PATH + "s_biv360skrv_wm";
	}


	/**
	 * 품목그룹정보등록(WM) (s_bpr210ukrv_wm) - 20201111 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_bpr210ukrv_wm.do")
	public String s_bpr210ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));

		return JSP_PATH + "s_bpr210ukrv_wm";
	}


	/**
	 * 사용자 서명등록(WM) (s_bsa315ukrv_wm) - 20201008 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_bsa315ukrv_wm.do")
	public String s_bsa315ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields = {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		return JSP_PATH + "s_bsa315ukrv_wm";
	}


	/**
	 * A/S접수현황/출력(WM) (s_esa100rkrv_wm) - 20201204 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_esa100rkrv_wm.do")
	public String s_esa100rkrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields	= {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
//		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo			= null;

		return JSP_PATH + "s_esa100rkrv_wm";
	}


	/**
	 * A/S접수등록(WM) (s_esa100ukrv_wm) - 20201126 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_esa100ukrv_wm.do")
	public String s_esa100ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields	= {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
//		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo			= null;

		//20210119 추가 - 사용자의 접수담당 가져오는 로직
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> defaultReceiptPrsn = codeInfo.getCodeList("ZM05", "", false);
		for(CodeDetailVO map : defaultReceiptPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode1().toUpperCase())) {
				model.addAttribute("defaultReceiptPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_esa100ukrv_wm";
	}




	/**
	 * 지급결의 등록(WM) (s_map100ukrv_wm) - 20210216 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_map100ukrv_wm.do",method = RequestMethod.GET)
	public String s_map100ukrv_wm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo			= null;

		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		cdo = codeInfo.getCodeInfo("M502", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAdvanUseYn",cdo.getRefCode1());	//선지급사용여부 조회
		else model.addAttribute("gsAdvanUseYn",'N');

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "4");
		if(!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAutoType1",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M101", "5");
		if(!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAutoType2",cdo.getRefCode1());

		List<CodeDetailVO> gsList1 = codeInfo.getCodeList("A022", "", false);
		Object list1= "";
		for(CodeDetailVO map : gsList1) {
			if("1".equals(map.getRefCode3()) && "Y".equals(map.getRefCode5())) {
				if(list1.equals("")){
					list1 = map.getCodeNo();
				} else {
					list1 = list1 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList1", list1);

		List<CodeDetailVO> gsList2 = codeInfo.getCodeList("M302", "", false);
		Object list2= "";
		for(CodeDetailVO map : gsList2) {
			if("Y".equals(map.getRefCode5())) {
				if(list2.equals("")){
					list2 = map.getCodeNo();
				} else {
					list2 = list2 + ";" + map.getCodeNo();
				}
			}
		}
		model.addAttribute("gsList2", list2);

		List<CodeDetailVO> AccountType = codeInfo.getCodeList("M302");
		if(!ObjUtils.isEmpty(AccountType)) model.addAttribute("AccountType",ObjUtils.toJsonStr(AccountType));

		List<CodeDetailVO> BillType = codeInfo.getCodeList("A022");
		if(!ObjUtils.isEmpty(BillType)) model.addAttribute("BillType",ObjUtils.toJsonStr(BillType));

		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			} else {
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
			model.addAttribute("gsSiteCode", "STANDARD");
		}
		return JSP_PATH + "s_map100ukrv_wm";
	}

	/**
	 * 지급결의 등록(일괄)(WM) (s_map200ukrv_wm) - 20210527 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_map200ukrv_wm.do",method = RequestMethod.GET)
	public String s_map200ukrv_wm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields	= {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo			= null;

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "4");
		if(!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAutoType1",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M101", "5");
		if(!ObjUtils.isEmpty(cdo)) model.addAttribute("gsAutoType2",cdo.getRefCode1());

		return JSP_PATH + "s_map200ukrv_wm";
	}


	/**
	 * 외상매입현황 조회(WM) (s_map110skrv_wm) - 20210222 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_map110skrv_wm.do")
	public String map110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));

		return JSP_PATH + "s_map110skrv_wm";
	}


	/**
	 * 매입단가등록(WM) (s_mba033ukrv_wm) - 20200820 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mba033ukrv_wm.do")
	public String s_mba033ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session				= _req.getSession();
		Map<String, Object> param	= navigator.getParam();
//		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo			= null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_mba033ukrv_wm";
	}


	/**
	 * 기획상품단가 등록(WM) (s_mba035ukrv_wm) - 20210224 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mba035ukrv_wm.do")
	public String mba033ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo			= null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_mba035ukrv_wm";
	}


	/**
	 * 매입단가결정(WM) (s_mba100ukrv_wm) - 20200917 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mba100ukrv_wm.do")
	public String s_mba100ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= { };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		LoginVO session = _req.getSession();
//		String page			= _req.getP("page");

		//20201021 추가 - 사용자의 영업담당 가져오는 로직
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> defaultSalesPrsn = codeInfo.getCodeList("S010", "", false);
		for(CodeDetailVO map : defaultSalesPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode5()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode5().toUpperCase())) {		//20201028 수정
				model.addAttribute("defaultSalesPrsn"	, map.getCodeNo());
			}
		}
		//20201021 추가 - 동적 그리드 구현(공통코드(입고처, Q012)에서 컬럼 가져오는 로직)
		Gson gson = new Gson();
		String colData = gson.toJson(s_mba100ukrv_wmService.selectColumns(loginVO));
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_mba100ukrv_wm";
	}


	/**
	 * 견적서 출력(WM) (s_mba200rkrv_wm) - 20201012 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mba200rkrv_wm.do")
	public String s_mba200rkrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		LoginVO session		= _req.getSession();
//		String page			= _req.getP("page");

		//사용자의 발신메일주소 가져오는 로직
		CodeInfo codeInfo				= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> sendMailAddr	= codeInfo.getCodeList("S010", "", false);
		for(CodeDetailVO map : sendMailAddr) {
			if(ObjUtils.isNotEmpty(map.getRefCode5()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode5().toUpperCase())) {		//20201028 수정
				model.addAttribute("sendMailAddr", map.getRefCode7());
			}
		}
		return JSP_PATH + "s_mba200rkrv_wm";
	}


	/**
	 * 매입단가승인(WM) (s_mba200ukrv_wm) - 20200921 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mba200ukrv_wm.do")
	public String s_mba200ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		String page			= _req.getP("page");
//		CodeInfo codeInfo	= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		return JSP_PATH + "s_mba200ukrv_wm";
	}


	/**
	 * 종합현황판(WM) (s_mis100skrv_wm) - 20201211 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mis100skrv_wm.do")
	public String s_mis100skrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields = {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		//동적 그리드 구현(공통코드(Z006)에서 컬럼 가져오는 로직)
		Gson gson		= new Gson();
		String colData	= gson.toJson(s_mis100skrv_wmService.selectColumns(loginVO));	//공통코드(Z006)에서 컬럼 가져오는 로직
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_mis100skrv_wm";
	}


	/**
	 * 생산진행현황 (WM) (s_mis200skrv_wm) - 20201103 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mis200skrv_wm.do")
	public String s_mis200skrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
//		final String[] searchFields = {  };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		return JSP_PATH + "s_mis200skrv_wm";
	}
	/**
	 * 생산진행현황 (WM) (s_mis200skrvb_wm) - 20201104 신규 등록 (현황판)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mis200skrvb_wm.do")
	public String s_mis200skrvb_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
		final String[] searchFields	= { };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE"					, loginVO.getCompCode());
		model.addAttribute("gsPGM_ID"			, param.get("PGM_ID"));
		model.addAttribute("gsDIV_CODE"			, param.get("DIV_CODE"));
		model.addAttribute("gsPRODT_START_DATE"	, param.get("PRODT_START_DATE"));
		model.addAttribute("gsPRODT_END_DATE"	, param.get("PRODT_END_DATE"));
		model.addAttribute("gsWORK_END_YN"		, param.get("WORK_END_YN"));
		model.addAttribute("gsWORK_SHOP_CODE"	, param.get("WORK_SHOP_CODE"));
		model.addAttribute("gsWORK_SHOP_NAME"	, param.get("WORK_SHOP_NAME"));		//20201208 추가
		model.addAttribute("gsITEM_CODE"		, param.get("ITEM_CODE"));
		model.addAttribute("gsITEM_NAME"		, param.get("ITEM_NAME"));
		model.addAttribute("gsRECEIVER_NAME"	, param.get("RECEIVER_NAME"));

		return JSP_PATH + "s_mis200skrvb_wm";
	}


	/**
	 * 기긴별 생산실적 / 생산라인별 실시간 생산현황 (WM) (s_mis300skrvb_wm) - 20201209 신규 등록 (현황판)
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mis300skrvb_wm.do")
	public String s_mis300skrvb_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		model.addAttribute("CSS_TYPE", "-largeEis");
//		final String[] searchFields	= { };
//		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
//		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
//		param.put("S_COMP_CODE"					, loginVO.getCompCode());
//		model.addAttribute("gsPGM_ID"			, param.get("PGM_ID"));
//		model.addAttribute("gsDIV_CODE"			, param.get("DIV_CODE"));
//		model.addAttribute("gsPRODT_START_DATE"	, param.get("PRODT_START_DATE"));
//		model.addAttribute("gsPRODT_END_DATE"	, param.get("PRODT_END_DATE"));
//		model.addAttribute("gsWORK_END_YN"		, param.get("WORK_END_YN"));
//		model.addAttribute("gsWORK_SHOP_CODE"	, param.get("WORK_SHOP_CODE"));
//		model.addAttribute("gsWORK_SHOP_NAME"	, param.get("WORK_SHOP_NAME"));		//20201208 추가
//		model.addAttribute("gsITEM_CODE"		, param.get("ITEM_CODE"));
//		model.addAttribute("gsITEM_NAME"		, param.get("ITEM_NAME"));
//		model.addAttribute("gsRECEIVER_NAME"	, param.get("RECEIVER_NAME"));

		return JSP_PATH + "s_mis300skrvb_wm";
	}


	/**
	 * 검사등록(WM) (s_mms200ukrv_wm) - 20200916 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mms200ukrv_wm.do")
	public String s_mms200ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("M025", "", false);				//수입검사후 자동입고여부
		for(CodeDetailVO map : gsInspecFlag) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsAutoInputFlag", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B090", "IB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준 설정

		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1() == null || "".equals(cdo.getRefCode1()) ? "N" : cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2() == null || "".equals(cdo.getRefCode2()) ? "N" : cdo.getRefCode2());

		List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);				//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
		for(CodeDetailVO map : gsInspecPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode3())) {
				model.addAttribute("gsInspecPrsn", map.getCodeNo());
			}
		}
		//20201230 추가 - 동적 그리드 구현(공통코드(Q011)에서 컬럼 가져오는 로직)
		Gson gson = new Gson();
		String colData	= gson.toJson(s_mms200ukrv_wmService.selectColumns(loginVO));	//공통코드(ZM04)에서 컬럼 가져오는 로직
		model.addAttribute("colData"	, colData);
		//20210119 추가 - 조회조건 "품목분류" 추가
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_mms200ukrv_wm";
	}


	/**
	 * 입고등록(WM) (s_mms510ukrv_wm) - 20201006 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mms510ukrv_wm.do", method = RequestMethod.GET)
	public String s_mms510ukrv_wm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);			//입고유형
		for(CodeDetailVO map : gsInoutTypeDetail) {
			model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
		}

		cdo = codeInfo.getCodeInfo("M103", "20");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInoutType",cdo.getRefCode4());		//기표대상여부관련

		cdo = codeInfo.getCodeInfo("M102", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());		//과입고허용률\

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());		//재고상태관리

		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);				//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);				//검사프로그램사용여부
		for(CodeDetailVO map : gsInspecFlag) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsInspecFlag", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M024", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsMap100UkrLink", cdo.getCodeName());	//링크프로그램정보(지급결의등록)

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot"	, cdo.getRefCode1());	//재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell"	, cdo.getRefCode1());	//재고합산유형:창고 Cell. 합산

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004"	, "", false);			//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M503", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsOScmYn",StringUtils.isBlank(cdo.getRefCode1())?"N":cdo.getRefCode1());

		if(StringUtils.isNotBlank(cdo.getRefCode1()) && "Y".equalsIgnoreCase(cdo.getRefCode1())){
			cdo = codeInfo.getCodeInfo("B605", "1");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsDbName",StringUtils.isBlank(cdo.getRefCode3())?null:cdo.getRefCode3()+"..");
		}

		List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
		for(CodeDetailVO map : gsGwYn) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsGwYn", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		String sDivCode = loginVO.getDivCode();;
		String divChkYn = "N";

		//q008(가입고 사용여부)의 refCode2,refCode3에 값이 들어가 있으면 사업장 별로 미입고(가입고 사용 안할 경우), 무검사 참조(가입고 사용시)버튼 제어하도록 변경
		for(CodeDetailVO divChkMap : gsQ008Sub) {
			if(!ObjUtils.isEmpty(divChkMap.getRefCode2()) || !ObjUtils.isEmpty(divChkMap.getRefCode3())){
				divChkYn = "Y";
			}
		}
		for(CodeDetailVO map : gsQ008Sub) {
			if(divChkYn.equals("N")){//사업장별로 가입고 사용여부 안하고 기존대로 세팅
				if("Y".equals(map.getRefCode1().toUpperCase())) {
					model.addAttribute("gsQ008Sub", map.getCodeNo());
				}
			} else {//사업장별로 가입고 사용여부 사용
				if(sDivCode.equals("01")){
					if("Y".equals(map.getRefCode1().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				} else if(sDivCode.equals("02")){
					if("Y".equals(map.getRefCode2().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				} else if(sDivCode.equals("03")){
					if("Y".equals(map.getRefCode3().toUpperCase())){
						model.addAttribute("gsQ008Sub", map.getCodeNo());
					}
				}
			}
		}

		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			} else {
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
			model.addAttribute("gsSiteCode", "STANDARD");
		}

		List<CodeDetailVO> gsExchangeRate = codeInfo.getCodeList("T124", "", false);//입고환율적용시점
		for(CodeDetailVO map : gsExchangeRate) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsExchangeRate", map.getCodeNo());
			}
		}
		//20210319 추가
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));

		//20210602 수정: 입고창고, 입고창고CELL 가져오는 로직 추가
		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		String defaultWhCode			= "";
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getDivCode().equals(map.getRefCode1())) {
				model.addAttribute("gsInOutPrsn"	, map.getCodeNo());
				model.addAttribute("gsDefaultWhCode", map.getRefCode9());
				defaultWhCode = map.getRefCode9();
			}
		}
		if(ObjUtils.isNotEmpty(defaultWhCode)) {
			param.put("DIV_CODE", loginVO.getDivCode());
			param.put("WH_CODE"	, defaultWhCode);
			model.addAttribute("gsDefaultWhCellCode", s_sal100ukrv_wmService.getWhCellCode(param));
		}
		return JSP_PATH + "s_mms510ukrv_wm";
	}


	/**
	 * 매입등록(WM) (s_mms520ukrv_wm) - 20210209 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mms520ukrv_wm.do", method = RequestMethod.GET)
	public String s_mms520ukrv_wm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);			//입고유형
		for(CodeDetailVO map : gsInoutTypeDetail) {
			model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
		}

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);				//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getDivCode().equals(map.getRefCode1())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M103", "20");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInoutType",cdo.getRefCode4());		//기표대상여부관련

		cdo = codeInfo.getCodeInfo("M102", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());		//과입고허용률\

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());		//재고상태관리

		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);				//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);				//검사프로그램사용여부
		for(CodeDetailVO map : gsInspecFlag) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsInspecFlag", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M024", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsMap100UkrLink", cdo.getCodeName());	//링크프로그램정보(지급결의등록)

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot"	, cdo.getRefCode1());	//재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell"	, cdo.getRefCode1());	//재고합산유형:창고 Cell. 합산

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004"	, "", false);			//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M503", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsOScmYn",StringUtils.isBlank(cdo.getRefCode1())?"N":cdo.getRefCode1());

		if(StringUtils.isNotBlank(cdo.getRefCode1()) && "Y".equalsIgnoreCase(cdo.getRefCode1())){
			cdo = codeInfo.getCodeInfo("B605", "1");
			if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsDbName",StringUtils.isBlank(cdo.getRefCode3())?null:cdo.getRefCode3()+"..");
		}

		List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
		for(CodeDetailVO map : gsGwYn) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsGwYn", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			} else {
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
			model.addAttribute("gsSiteCode", "STANDARD");
		}

		List<CodeDetailVO> gsExchangeRate = codeInfo.getCodeList("T124", "", false);//입고환율적용시점
		for(CodeDetailVO map : gsExchangeRate) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsExchangeRate", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_mms520ukrv_wm";
	}


	/**
	 * 접수현황조회(WM) (s_mpo010skrv_wm) - 20201102 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mpo010skrv_wm.do")
	public String s_mpo010skrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= { };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE"	, loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//사용자의 접수담당 가져오는 로직
		List<CodeDetailVO> defaultRectiptPrsn = codeInfo.getCodeList("ZM02", "", false);
		for(CodeDetailVO map : defaultRectiptPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode1().toUpperCase())) {		//20201103 수정
				model.addAttribute("defaultRectiptPrsn", map.getCodeNo());
			}
		}

		//사용자의 영업담당 가져오는 로직
		List<CodeDetailVO> defaultSalesPrsn = codeInfo.getCodeList("S010", "", false);
		for(CodeDetailVO map : defaultSalesPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode5()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode5().toUpperCase())) {		//20201028 수정
				model.addAttribute("defaultSalesPrsn"	, map.getCodeNo());
			}
		}
		return JSP_PATH + "s_mpo010skrv_wm";
	}


	/**
	 * 매입접수등록(WM) (s_mpo010ukrv_wm) - 20200902 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mpo010ukrv_wm.do")
	public String s_mpo010ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= { };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE"	, loginVO.getCompCode());
		param.put("S_USER_ID"	, loginVO.getUserID());		//20201016 추가 - 사용자의 서명 가져오기 위해 추가

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//사용자의 접수담당 가져오는 로직
		List<CodeDetailVO> defaultRectiptPrsn = codeInfo.getCodeList("ZM02", "", false);
		for(CodeDetailVO map : defaultRectiptPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode1().toUpperCase())) {		//20200103 수정
				model.addAttribute("defaultRectiptPrsn", map.getCodeNo());
			}
		}

		//20200921 추가 - 사용자의 영업담당 가져오는 로직
		List<CodeDetailVO> defaultSalesPrsn = codeInfo.getCodeList("S010", "", false);
		for(CodeDetailVO map : defaultSalesPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode5()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode5().toUpperCase())) {		//20201028 수정
				model.addAttribute("defaultSalesPrsn"	, map.getCodeNo());
				model.addAttribute("sendMailAddr"		, map.getRefCode7());		//20201016 추가 - 사용자의 발신메일주소
			}
		}
		//20201016 추가 - 사용자의 서명 가져오는 로직
		Map userSign		= s_mpo010ukrv_wmService.getUserSign(param);
		String PRE_PROCESS	= (String) userSign.get("USER_SIGN");
		//20201229 주석: 이미지 데이터 변환로직 화면오픈 시에서 팝업오픈 시로 이동
//		String TXT_PART1	= "";										//사용자 서명 중, text 앞 부분
//		String TXT_PART2	= "";										//사용자 서명 중, text 뒷 부분
//		String IMG_PART		= "";										//사용자 서명 중, image 부분
//		String IMG_FILE		= "";										//IMG_PART에서 추출한 image 파일명
//		String IMG_PATH		= "";										//IMG_PART에서 추출한 image 파일 경로
		String WHOLE_SIGN	= "";										//최종 데이터

//		if(PRE_PROCESS.contains("<img")) {
//			TXT_PART1					= PRE_PROCESS.substring(0, PRE_PROCESS.indexOf("<img"));
//			TXT_PART2					= PRE_PROCESS.substring(PRE_PROCESS.indexOf("bin\">") + 5);
//			IMG_PART					= PRE_PROCESS.substring(PRE_PROCESS.indexOf("<img"), PRE_PROCESS.indexOf("bin\">") + 5);
//			IMG_PATH					= IMG_PART.substring(0, IMG_PART.lastIndexOf("/") + 1);
//			IMG_FILE					= IMG_PART.substring(IMG_PART.lastIndexOf("/") + 1, IMG_PART.lastIndexOf("\""));
//			//이미지 파일 binary로 변경
//			byte[] imageBytes			= extractBytes("E:\\OmegaPlus\\upload\\temp\\" + IMG_FILE);		//20201204 수정: 절대경로 하드코딩 문제(서버는 E드라이브에 설치 됨)
//			String baseIncodingBytes	= Base64.encodeBase64String(imageBytes);
//			//변경된 binary 데이터 적용
//			IMG_PART					= IMG_PART.replace(IMG_PATH + IMG_FILE, "<img src=\"data:image/png;base64," + baseIncodingBytes);
//			WHOLE_SIGN = TXT_PART1 + IMG_PART + TXT_PART2;
//		} else {
			//이미지 파일이 없을 때는 SIGN 데이터 그대로 리턴
			WHOLE_SIGN = PRE_PROCESS;
//		}
		logger.debug(WHOLE_SIGN);
		model.addAttribute("gsUserSign", WHOLE_SIGN);

		return JSP_PATH + "s_mpo010ukrv_wm";
	}
	/**
	 * 이미지 / 해당 경로 byte로 변경
	 * @param inmageName
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("resource")
	public static byte[] extractBytes(String inmageName) throws Exception {
		File imgPath				= new File(inmageName);
		FileInputStream fis			= new FileInputStream(imgPath);
		ByteArrayOutputStream baos	= new ByteArrayOutputStream();
		int len						= 0;
		byte[] buf					= new byte[1024];

		while((len = fis.read(buf)) != -1) {
			baos.write(buf, 0, len);
		}
		byte[] fileArray = baos.toByteArray();
		return fileArray;
	}

	/**
	 * 매입접수(개인)(WM) (s_mpo015ukrv_wm) - 20210330 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mpo015ukrv_wm.do")
	public String s_mpo015ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= { };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE"	, loginVO.getCompCode());
		param.put("S_USER_ID"	, loginVO.getUserID());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//사용자의 접수담당 가져오는 로직
		List<CodeDetailVO> defaultRectiptPrsn = codeInfo.getCodeList("ZM02", "", false);
		for(CodeDetailVO map : defaultRectiptPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode1().toUpperCase())) {		//20200103 수정
				model.addAttribute("defaultRectiptPrsn", map.getCodeNo());
			}
		}

		//사용자의 영업담당 가져오는 로직
		List<CodeDetailVO> defaultSalesPrsn = codeInfo.getCodeList("S010", "", false);
		for(CodeDetailVO map : defaultSalesPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode5()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode5().toUpperCase())) {		//20201028 수정
				model.addAttribute("defaultSalesPrsn"	, map.getCodeNo());
				model.addAttribute("sendMailAddr"		, map.getRefCode7());
			}
		}

		//사용자의 서명 가져오는 로직
		Map userSign		= s_mpo010ukrv_wmService.getUserSign(param);
		String PRE_PROCESS	= (String) userSign.get("USER_SIGN");
		String WHOLE_SIGN	= "";
		WHOLE_SIGN = PRE_PROCESS;
		logger.debug(WHOLE_SIGN);
		model.addAttribute("gsUserSign", WHOLE_SIGN);


		//사용자의 수불담당 정보 가져오는 로직 - 20210525 추가
		List<CodeDetailVO> defaultInoutPrsn	= codeInfo.getCodeList("B024", "", false);
		String defaultWhCode				= "";
		for(CodeDetailVO map : defaultInoutPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode10()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode10().toUpperCase())) {
				model.addAttribute("defaultInoutPrsn"	, map.getCodeNo());
				model.addAttribute("defaultWhCode"		, map.getRefCode9());
				defaultWhCode = map.getRefCode9();
			}
		}
		if(ObjUtils.isNotEmpty(defaultWhCode)) {
			param.put("DIV_CODE", loginVO.getDivCode());
			param.put("WH_CODE"	, defaultWhCode);
			model.addAttribute("defaultWhCellCode", s_sal100ukrv_wmService.getWhCellCode(param));
		}
		//창고cell 정보 가져오는 로직 - 20210525 추가
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));
		//매입접수자동입고여부 정보 가져오는 로직 - 20210525 추가
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("Z007", "10");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInYn", cdo.getRefCode1());

		return JSP_PATH + "s_mpo015ukrv_wm";
	}


	/**
	 * 접수/도착등록(간편) (WM) (s_mpo020ukrv_wm) - 20200908 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mpo020ukrv_wm.do")
	public String s_mpo020ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//사용자의 접수담당 가져오는 로직
		List<CodeDetailVO> defaultRectiptPrsn = codeInfo.getCodeList("ZM02", "", false);
		for(CodeDetailVO map : defaultRectiptPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode1().toUpperCase())) {	//20201103 수정
				model.addAttribute("defaultRectiptPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_mpo020ukrv_wm";
	}


	/**
	 * 분해등록(WM) (s_mpp100ukrv_wm) - 20200909 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mpp100ukrv_wm.do")
	public String s_mpp100ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
//		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		String page = _req.getP("page");

//		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//사용자의 접수담당 가져오는 로직
//		List<CodeDetailVO> defaultRectiptPrsn = codeInfo.getCodeList("ZM02", "", false);
//		for(CodeDetailVO map : defaultRectiptPrsn) {
//			if(loginVO.getUserID().toUpperCase().equals(map.getRefCode1().toUpperCase())) {
//				model.addAttribute("defaultRectiptPrsn", map.getCodeNo());
//			}
//		}
		return JSP_PATH + "s_mpp100ukrv_wm";
	}


	/**
	 * 자재출고등록(WM) (s_mtr200ukrv_wm) - 20201124 추가
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_mtr200ukrv_wm.do",method = RequestMethod.GET)
	public String s_mtr200ukrv_wm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		//20210208 추가
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList)) model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);		//화폐단위
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:입출고번호자동채번(txtOrderNum) lock,disable

		List<CodeDetailVO> gsInoutCodeType = codeInfo.getCodeList("B005", "", false);		//수불처구분
		for(CodeDetailVO map : gsInoutCodeType) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsInoutCodeType", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준설정
		else if(ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN","N");

		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);		//BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
				model.addAttribute("gsBomPathYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsSumTypeCell","N");

		List<CodeDetailVO> gsOutDetailType = codeInfo.getCodeList("M104", "", false);	//
		List<Map<String, Object>>  listOutDetailType = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOutDetailType) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("GOOD_BAD", map.getRefCode4());
			listOutDetailType.add(aMap);
		}
		model.addAttribute("gsOutDetailType", listOutDetailType);

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCheckStockYn",cdo.getRefCode1());	//재고상태관리
		else if(ObjUtils.isEmpty(cdo)) model.addAttribute("gsCheckStockYn","+");

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("mtr202ukrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "s_mtr200ukrv_wm";
	}




	/**
	 * 작업지시등록(일괄)(WM) (s_pmp110ukrv_wm) - 20200907 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_pmp110ukrv_wm.do")
	public String s_pmp110ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= { };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		//사용자의 접수담당 가져오는 로직
		List<CodeDetailVO> defaultRegiPrsn = codeInfo.getCodeList("P510", "", false);
		for(CodeDetailVO map : defaultRegiPrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode1().toUpperCase())) {
				model.addAttribute("defaultRegiPrsn", map.getCodeNo());
			}
		}
		param.put("DIV_CODE", loginVO.getDivCode());
		//20201020 추가: 공정정보 포함한 작업장 콤보데이터 가져오는 로직
		model.addAttribute("gsWorkShopList"		, s_pmp110ukrv_wmService.getWorkShopList(param));
		//20210323 추가
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));

		return JSP_PATH + "s_pmp110ukrv_wm";
	}


	/**
	 * 작업지시서 출력(WM) (s_pmp110rkrv_wm) - 20201019 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_pmp110rkrv_wm.do")
	public String s_pmp110rkrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= { };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
		param.put("S_COMP_CODE", loginVO.getCompCode());
//		LoginVO session = _req.getSession();
//		String page = _req.getP("page");

		return JSP_PATH + "s_pmp110rkrv_wm";
	}

	/**
	 * 작업지시서 출력(WM) (s_pmp110rkrv_wm): 바른서비스 엑셀 다운로드 - 20210322 추가
	 * @param _req
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/z_wm/pmp110rkrvExcelDown.do")
	public ModelAndView pmp110rkrvExcelDown(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{	
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb		= s_pmp110rkrv_wmService.makeExcel(paramMap);
		String title	= "바른서비스";
		return ViewHelper.getExcelDownloadView(wb, title);
	}


	/**
	 * 작업실적등록(WM) (s_pmr100ukrv_wm) - 20201124 신규 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_pmr100ukrv_wm.do")
	public String s_pmr100ukrv_wm(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo			= null;
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		cdo = codeInfo.getCodeInfo("B090", "PB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	// 작업지시와 생산실적LOT 연계여부 설정 값 알기

		cdo = codeInfo.getCodeInfo("P000", "6");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsChkProdtDateYN",cdo.getRefCode1());	// 작업실적 등록시 착수예정일 체크여부

		cdo = codeInfo.getCodeInfo("P100", "1");												// 생산완료시점 (100%)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("glEndRate",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B084", "D");												// 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		} else {
			model.addAttribute("gsSumTypeCell", "N");
		}
		cdo = codeInfo.getCodeInfo("P516", "1");												// 생산작업시간(점심)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLunchFr",cdo.getRefCode1());
			model.addAttribute("gsLunchTo",cdo.getRefCode2());
		} else {
			model.addAttribute("gsLunchFr","12:00");
			model.addAttribute("gsLunchTo","13:00");
		}

		Gson gson		= new Gson();
		String colData	= gson.toJson(s_pmr100ukrv_wmService.selectBadcodes(loginVO.getCompCode()));
		String colData2	= gson.toJson(s_pmr100ukrv_wmService.selectBadcodeRemarks(loginVO.getCompCode()));
		model.addAttribute("colData"	, colData);
		model.addAttribute("colData2"	, colData2);

		String gsSiteCode = "STANDARD";
		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				gsSiteCode = cdo.getCodeName().toUpperCase();
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			} else {
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
				model.addAttribute("gsSiteCode", "STANDARD");
		}

		cdo = codeInfo.getCodeInfo("BS83", loginVO.getDivCode());	//작업실적데이터연동정보 (우선 본인 사업장에서 연동 여부와 본인 사업장의 연동 주소를 가져온다)
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsIfCode", cdo.getRefCode1().toUpperCase());
				model.addAttribute("gsIfSiteCode", cdo.getRefCode2());
			} else {
				model.addAttribute("gsIfCode", "N");
				model.addAttribute("gsIfSiteCode", "");
			}
		} else {
			model.addAttribute("gsIfCode", "N");
			model.addAttribute("gsIfSiteCode", "");
		}

		cdo = codeInfo.getCodeInfo("BS83", loginVO.getDivCode());	//작업실적데이터연동정보
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsIfCode"		, cdo.getRefCode1().toUpperCase());
				model.addAttribute("gsIfSiteCode"	, cdo.getRefCode2());
			} else {
				model.addAttribute("gsIfCode"		, "N");
				model.addAttribute("gsIfSiteCode"	, "");
			}
		} else {
			model.addAttribute("gsIfCode"		, "N");
			model.addAttribute("gsIfSiteCode"	, "");
		}

		cdo = codeInfo.getCodeInfo("BS82", loginVO.getDivCode());	//작업지시데이터연동정보
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsIfCodePlan"		, cdo.getRefCode1().toUpperCase());
				model.addAttribute("gsIfSiteCodePlan"	, cdo.getRefCode2());
			} else {
				model.addAttribute("gsIfCodePlan"		, "N");
				model.addAttribute("gsIfSiteCodePlan"	, "");
			}
		} else {
			model.addAttribute("gsIfCodePlan"		, "N");
			model.addAttribute("gsIfSiteCodePlan"	, "");
		}

		//20210302 추가: 입고담당 기본값 설정을 위해 추가
		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getUserID().equals(map.getRefCode10())) {
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_pmr100ukrv_wm";
	}




	/**
	 * 판매현황 조회(WM) (s_sal100skrv_wm) - 20210205 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_sal100skrv_wm.do")
	public String s_sal100skrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE"					, loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));

		return JSP_PATH + "s_sal100skrv_wm";
	}


	/**
	 * 판매등록(WM) (s_sal100ukrv_wm) - 20200911 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_sal100ukrv_wm.do")
	public String s_sal100ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList)) model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");									//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		} else {
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

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str103ukrv");							//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		} else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");									//LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false);	//출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)   {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsInoutAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1") || map.getCodeNo().equals("3")){
					model.addAttribute("gsInoutAutoYN", "Y");
				} else {
					model.addAttribute("gsInoutAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvstatus", cdo.getRefCode1());
		} else {
			model.addAttribute("gsInvstatus", "+");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn"	, cdo.getRefCode1());
			model.addAttribute("gsUnitChack", cdo.getRefCode2());
		} else {
			model.addAttribute("gsPointYn"	, "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn)  {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				} else {
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
			if(!ObjUtils.isEmpty(cdList))   model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell", cdo.getRefCode1());
		} else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");	//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode",cdo.getRefCode1());
		} else {
			model.addAttribute("gsRefWhCode", "1");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		} else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("S048", "SI");	//시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
		} else {
			model.addAttribute("gsManageTimeYN", "N");
		}

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn)) model.addAttribute("salePrsn", ObjUtils.toJsonStr(salePrsn));

		//사용자의 영업담당자 정보 가져오는 로직, 20210316 수정: 수불담당으로 변경 (S010 -> B024)
		List<CodeDetailVO> defaultSalePrsn = codeInfo.getCodeList("B024", "", false);
		String defaultCustomCd	= "";
		String defaultWhCode	= "";

		for(CodeDetailVO map : defaultSalePrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && ObjUtils.isNotEmpty(map.getRefCode10()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode10().toUpperCase())) {	//20201028 수정, 20210316 수정: 수불담당으로 변경 (getRefCode5 -> getRefCode10)
				model.addAttribute("defaultSalePrsn", map.getCodeNo());			//영업담당 - 매출정보에도 같이 입력되어야 함, 20210316 수정: 수불담당으로 변경 (S010 -> B024), 단 매출담당은 B024.REF_CODE6으로 대체
				model.addAttribute("defaultCustomCd", map.getRefCode8());		//거래처 - 20210316 수정: 수불담당으로 변경 (S010 -> B024), map.getRefCode9() -> map.getRefCode8()
				model.addAttribute("defaultWhCode"	, map.getRefCode9());		//출고창고 - 20210316 수정: 수불담당으로 변경 (S010 -> B024), map.getRefCode10() -> map.getRefCode9()
				defaultCustomCd	= map.getRefCode8();							//20210316 수정: 수불담당으로 변경 (S010 -> B024), map.getRefCode9() -> map.getRefCode8()
				defaultWhCode	= map.getRefCode9();							//20210316 수정: 수불담당으로 변경 (S010 -> B024), map.getRefCode10() -> map.getRefCode9()
			}
		}
		if(ObjUtils.isNotEmpty(defaultCustomCd)) {
			param.put("CUSTOM_CODE", defaultCustomCd);
			Map customInfo = s_sal100ukrv_wmService.getCustomNm(param);
			model.addAttribute("defaultCustomNm"	, customInfo.get("CUSTOM_NAME"));	//거래처명
			model.addAttribute("defaultTaxInout"	, customInfo.get("TAX_TYPE"));		//거래처에 따른 세액 포함여부
			model.addAttribute("defaultAgentType"	, customInfo.get("AGENT_TYPE"));	//거래처 분류
			model.addAttribute("defaultCreditYn"	, customInfo.get("CREDIT_YN"));		//거래처에 따른 여신적용 여부
			model.addAttribute("defaultWonCalcBas"	, customInfo.get("WON_CALC_BAS"));	//거래처에 따른 원미만 처리 방법
			model.addAttribute("defaultBusiPrsn"	, customInfo.get("BUSI_PRSN"));		//거래처에 따른 주담당자
			model.addAttribute("defaultMoneyUnit"	, customInfo.get("MONEY_UNIT"));	//거래처에 따른 화폐
		}
		if(ObjUtils.isNotEmpty(defaultWhCode)) {
			param.put("DIV_CODE", loginVO.getDivCode());
			param.put("WH_CODE"	, defaultWhCode);
			model.addAttribute("defaultWhCellCode", s_sal100ukrv_wmService.getWhCellCode(param));		//거래처
		}
		return JSP_PATH + "s_sal100ukrv_wm";
	}


	/**
	 * 주문조회(WM) (s_sof103skrv_wm) - 20201216 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_sof103skrv_wm.do")
	public String s_sof103skrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
//		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		//사용자의 영업담당자 정보 가져오는 로직
		List<CodeDetailVO> defaultSalePrsn = codeInfo.getCodeList("S010", "", false);
		for(CodeDetailVO map : defaultSalePrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && ObjUtils.isNotEmpty(map.getRefCode5()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode5().toUpperCase())) {	//20201028 수정
				model.addAttribute("defaultSalePrsn", map.getCodeNo());			//영업담당 - 매출정보에도 같이 입력되어야 함
			}
		}
		return JSP_PATH + "s_sof103skrv_wm";
	}


	/**
	 * 주문등록(일괄)(WM) (s_sof103ukrv_wm) - 20200914 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_sof103ukrv_wm.do")
	public String s_sof103ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());			//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType"	, cdo.getRefCode1());		//Y:수주번호(txtOrderNum) lock,disable
		//20191014 추가:수주번호 수동입력일 경우, 자릿수 가져오는 로직
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSNMaxLen"	, cdo.getRefCode4());

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());			//부가세율

		List<CodeDetailVO> gsProdtDtAutoYN = codeInfo.getCodeList("S031", "", false);			//수주등록내 생산완료일설정 자도여부
		for(CodeDetailVO map : gsProdtDtAutoYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsProdtDtAutoYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("S035", "", false);				//매출등록시 자동출고생성/삭제여부
		for(CodeDetailVO map : gsSaleAutoYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsSaleAutoYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsDraftFlag = codeInfo.getCodeList("S044", "", false);				//수주승인방식
		for(CodeDetailVO map : gsDraftFlag) {
			if("Y".equals(map.getRefCode1())) {
				if(map.getCodeNo().equals("1")){
					model.addAttribute("gsDraftFlag", "Y");					//Y:수주승인관련 필드
				} else {
					model.addAttribute("gsDraftFlag", "N");					//N:자동승인관련 필드
				}
			}
		}

		cdo = codeInfo.getCodeInfo("S045", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp1AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp1AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S045", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsApp2AmtInfo",		cdo.getRefCode2());				//수주승인사용일 경우 lblApp2AmtInfo,lblApp3AmtInfo 값 표시

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsTimeYN",			cdo.getRefCode1());				//시/분/초 필드 처리여부

		cdo = codeInfo.getCodeInfo("S061", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsScmUseYN",		cdo.getRefCode1());				//Y:SCM연계탭 enable

		cdo = codeInfo.getCodeInfo("B078", "10");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPjtCodeYN",		cdo.getRefCode1());				//Y:수주검색팝업에 txtPlanNum enable

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsPointYn",			cdo.getRefCode1());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
			model.addAttribute("gsUnitChack",		cdo.getRefCode2());				//수주내역 그리드에서 ORDER_VOL_Q,ORDER_WGT_Q 입력값 체크시 사용
		}

		List<CodeDetailVO> gsOrderTypeSaleYN = codeInfo.getCodeList("S044", "", false);
		List<Map<String, Object>>  listOrderTypeSaleYN = new ArrayList<Map<String, Object>>();
		for(CodeDetailVO map : gsOrderTypeSaleYN) {
			Map<String, Object> aMap = new HashMap<String, Object>();
			aMap.put("SUB_CODE", map.getCodeNo());
			aMap.put("CODE_NAME", map.getCodeName());
			aMap.put("REF_CODE1", map.getRefCode1());
			listOrderTypeSaleYN.add(aMap);
		}
		model.addAttribute("gsOrderTypeSaleYN", listOrderTypeSaleYN);

		List<CodeDetailVO> gsProdSaleQ_WS03 = codeInfo.getCodeList("WS03", "", false);						//수주시 생산량생성기준
		for(CodeDetailVO map : gsProdSaleQ_WS03) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsProdSaleQ_WS03", map.getCodeNo());
			} else {
				model.addAttribute("gsProdSaleQ_WS03", "N");
			}
		}
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		//사용자의 영업담당자 정보 가져오는 로직
		List<CodeDetailVO> defaultSalePrsn = codeInfo.getCodeList("S010", "", false);

		for(CodeDetailVO map : defaultSalePrsn) {
			if(ObjUtils.isNotEmpty(map.getRefCode1()) && ObjUtils.isNotEmpty(map.getRefCode5()) && loginVO.getUserID().toUpperCase().equals(map.getRefCode5().toUpperCase())) {	//20201028 수정
				model.addAttribute("defaultSalePrsn", map.getCodeNo());			//영업담당 - 매출정보에도 같이 입력되어야 함
			}
		}
		//20210319 추가: 주문 수집시작일 가져오는 로직 추가
		cdo = codeInfo.getCodeInfo("ZM10", "01");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsFromDate", cdo.getRefCode2());

		return JSP_PATH + "s_sof103ukrv_wm";
	}


	/**
	 * 출하지시등록(WM) (s_srq100ukrv_wm) - 20201117 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_srq100ukrv_wm.do")
	public String s_srq100ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "8");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("S026", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());				//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S036", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPrintPgID",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());		//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());		//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S048", "SR");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsTimeYN1", cdo.getRefCode1());
		} else {
			model.addAttribute("gsTimeYN1", "N");
		}

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsTimeYN2", cdo.getRefCode1());
		} else {
			model.addAttribute("gsTimeYN2", "N");
		}

		cdo = codeInfo.getCodeInfo("S071", "1");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsScmUseYN", cdo.getRefCode1());
		} else {
			model.addAttribute("gsScmUseYN", "N");
		}

		cdo = codeInfo.getCodeInfo("Z001", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsBoxQYn", "Y");
			model.addAttribute("gsMiniPackQYn", "Y");
		} else {
			model.addAttribute("gsBoxQYn", "N");
			model.addAttribute("gsMiniPackQYn", "N");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsPointYn", cdo.getRefCode1());
			model.addAttribute("gsUnitChack", cdo.getRefCode2());
		} else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo)) {
			model.addAttribute("gsPriceGubun"	, cdo.getRefCode1());	//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight"		, cdo.getRefCode2());	//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume"		, cdo.getRefCode3());	//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		} else {
			model.addAttribute("gsPriceGubun"	, "A");					//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight"		, "KG");				//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume"		, "L");					//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}

		model.addAttribute("COMBO_WH_U_LIST", comboService.getWhUList(param));
		
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun) {
			if("srq100ukrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}

		cdo = codeInfo.getCodeInfo("B090", "SE");							//출하지시 등록(SE)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1());	//입력형태(Y/E/N)
			model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2());	//필수여부(Y/N)
			model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3());	//품목계정(필수Y,문자열)
		}

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_srq100ukrv_wm";
	}

	/**
	 * 출하지시등록(WM) (s_srq100ukrv_wm): 선택된 데이터만 엑셀 다운로드 하는 기능을 구현하기 위해 추가 - 20210617 추가, (사용 안 함 - 공통 프로세스로직 사용하도록 변경)
	 * @param _req
	 * @param response
	 * @return
	 * @throws Exception
	 */
/*	@ResponseBody
	@RequestMapping(value = "/z_wm/s_srq100ukrvExcelDown.do")
	public ModelAndView s_srq100ukrvExcelDown(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb		= s_srq100ukrv_wmService.makeExcel(paramMap);
		String title	= "출하지시등록WM";
		return ViewHelper.getExcelDownloadView(wb, title);
	}*/


	/**
	 * 일일결산보고(WM) (s_ssa700skrv_wm) - 20210513 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_ssa700skrv_wm.do")
	public String s_ssa700skrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());

		return JSP_PATH + "s_ssa700skrv_wm";
	}


	/**
	 * 출고 등록(WM) (s_str104ukrv_wm) - 20210108 신규 등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_str104ukrv_wm.do")
	public String s_str104ukrv_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param	= navigator.getParam();
//		LoginVO session				= _req.getSession();
//		String page					= _req.getP("page");

		param.put("S_COMP_CODE"					, loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST"		, comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST"	, comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList)) model.addAttribute("whList", ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");									//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		} else {
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

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");

		cdo = codeInfo.getCodeInfo("S116", "s_str104ukrv_wm");						//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun"	, cdo.getRefCode1());
			model.addAttribute("gsWeight"		, cdo.getRefCode2());
			model.addAttribute("gsVolume"		, cdo.getRefCode3());
		} else {
			model.addAttribute("gsPriceGubun"	, "A");
			model.addAttribute("gsWeight"		, "KG");
			model.addAttribute("gsVolume"		, "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");									//LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3());
		}

		cdo = codeInfo.getCodeInfo("B022", "1");									//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvstatus",cdo.getRefCode1());
		} else {
			model.addAttribute("gsInvstatus", "+");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");									//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		} else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				} else {
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
			if(!ObjUtils.isEmpty(cdList)) model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");									//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell", cdo.getRefCode1());
		} else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");									//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode", cdo.getRefCode1());
		} else {
			model.addAttribute("gsRefWhCode", "1");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");									//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate", cdo.getRefCode1());
		} else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("S048", "SI");									//시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN", cdo.getRefCode1());
		} else {
			model.addAttribute("gsManageTimeYN", "N");
		}
		cdo = codeInfo.getCodeInfo("S120", "1");									//셀 자동LOT 배정여부(Y/N)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("useLotAssignment", cdo.getRefCode1());
		} else {
			model.addAttribute("useLotAssignment", "N");
		}

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn)) model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> gsBoxYN = codeInfo.getCodeList("S149", "", false);
		for(CodeDetailVO map : gsBoxYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBoxYN", map.getCodeNo());
			}
		}

		//공통코드(S033 - 출고등록시 자동매출생성/삭제여부) 가져오는 로직 추가: 1 자동, 2 수동(값이 없을 때는 수동)
		List<CodeDetailVO> gsAutoSalesYN = codeInfo.getCodeList("S033", "", false);
		for(CodeDetailVO map : gsAutoSalesYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsAutoSalesYN", map.getCodeNo());
			}
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false);	//출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsInoutAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1") || map.getCodeNo().equals("3")){
					model.addAttribute("gsInoutAutoYN", "Y");
				} else {
					model.addAttribute("gsInoutAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

		//공통코드(S156 - LOT팝업에 Main Grid에 적용된 LOT표시 여부) 가져오는 로직
		List<CodeDetailVO> gsShowExistLotNo = codeInfo.getCodeList("S156", "", false);
		for(CodeDetailVO map : gsShowExistLotNo) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsShowExistLotNo", map.getCodeNo());
			}
		}
		//20210317 추가
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));


		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn)) model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		//20210602 추가: 입고창고, 입고창고CELL 가져오는 로직 추가
		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		String defaultWhCode			= "";
		for(CodeDetailVO map : gsInOutPrsn) {
			if(loginVO.getDivCode().equals(map.getRefCode1())) {
				model.addAttribute("gsInOutPrsn"	, map.getCodeNo());
				model.addAttribute("gsDefaultWhCode", map.getRefCode9());
				defaultWhCode = map.getRefCode9();
			}
		}
		if(ObjUtils.isNotEmpty(defaultWhCode)) {
			param.put("DIV_CODE", loginVO.getDivCode());
			param.put("WH_CODE"	, defaultWhCode);
			model.addAttribute("gsDefaultWhCellCode", s_sal100ukrv_wmService.getWhCellCode(param));
		}
		return JSP_PATH + "s_str104ukrv_wm";
	}







	/**
	 * Oracle DB 테스트용
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_wm/s_externalDBskrv_wm.do")
	public String s_ExternalDB_wm(String popupID, ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "s_externalDBskrv_wm";
	}
}