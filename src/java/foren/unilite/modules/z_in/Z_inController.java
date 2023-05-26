package foren.unilite.modules.z_in;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;

@Controller
public class Z_inController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/z_in/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;

	@Resource(name="accntCommonService")
	private AccntCommonServiceImpl accntCommonService;

	@Resource(name="s_opo110skrv_inService")
	private S_opo110skrv_inServiceImpl s_opo110skrv_inService;

	@Resource(name="s_pmr360skrv_inService")
	private S_pmr360skrv_inServiceImpl s_pmr360skrv_inService;

	
	@Resource(name="s_hrt700ukr_inService")
	private S_hrt700ukr_inServiceImpl s_hrt700ukr_inService;


	/**
	 * 월별 수불부 조회(이노베이션) - 20190927 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_biv330skrv_in.do")
	public String s_biv330skrv_in(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_biv330skrv_in";
	}


	/**
	 * 출고예정표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_sof120ukrv_in.do")
	public String s_sof120ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		//20200515 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		return JSP_PATH + "s_sof120ukrv_in";
	}

	 /**
	 * 구매요청등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_mre100ukrv_in.do",method = RequestMethod.GET)
	public String s_mre100ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//화폐단위(기본화폐단위설정
		for(CodeDetailVO map : gsDefaultMoney)  {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M101", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("B609", "GW_URL");   //그룹웨어 호출 url
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("groupUrl",cdo.getCodeName());

		Map getPersonName = (Map)accntCommonService.getPersonName(param, loginVO);// 로그인 ID에 따른 사번 , 사원명 관련
//		model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
		if(getPersonName == null){
			model.addAttribute("personName", "");
		}else{
			model.addAttribute("personName", getPersonName.get("PERSON_NAME"));
		}

		System.out.println("========s_s_mre101ukrv_kd_kd ===========================");
		return JSP_PATH + "s_mre100ukrv_in";
	}

	/**
	 * 작업지시현황(요약)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_pmp100skrv_in.do")
	public String s_pmp100skrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_pmp100skrv_in".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "s_pmp100skrv_in";
	}

	/**
	 * 일괄제조오더
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_pmp102ukrv_in.do", method = RequestMethod.GET)
	public String s_pmp102ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

	   List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP01", "", false);			// 작지설비 관리여부
	   for(CodeDetailVO map : gsEquipCode) {
		   if("Y".equals(map.getRefCode1()))   {
			   model.addAttribute("gsEquipCode", map.getCodeNo());
		   }
	   }

		List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP02", "", false);			// 작지금형 관리여부
		for(CodeDetailVO map : gsMoldCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoldCode", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "",   false);
		for(CodeDetailVO map :   gsReportGubun)	{
			if("s_pmp102ukrv_in".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
				}
		}


		return JSP_PATH + "s_pmp102ukrv_in";
	}

/**
	 *
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_ppl100ukrv_in.do")
	public String s_ppl100ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));


		cdo = codeInfo.getCodeInfo("S048", "PP");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageTimeYN",			cdo.getRefCode1());

		return JSP_PATH + "s_ppl100ukrv_in";
	}

	/**
	 * 자재입고등록(INNO)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_mms510ukrv_in.do",method = RequestMethod.GET)
	public String s_mms510ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
//		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);		//입고유형
		for(CodeDetailVO map : gsInoutTypeDetail)	{
				model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
		}

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsn)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}

		List<CodeDetailVO> cdList = codeInfo.getCodeList("M103");	//기표대상여부관련
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));


		cdo = codeInfo.getCodeInfo("M102", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());	//과입고허용률\

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리



		List<CodeDetailVO> gsProcessFlag = codeInfo.getCodeList("BS07", "", false);		//처리방법 분류
		for(CodeDetailVO map : gsProcessFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsProcessFlag", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q003", "", false);		//검사프로그램사용여부
		for(CodeDetailVO map : gsInspecFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInspecFlag", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("M024", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsMap100UkrLink",	cdo.getCodeName());		//링크프로그램정보(지급결의등록)


		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());	//재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());	//재고합산유형:창고 Cell. 합산

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//기본 화폐단위
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()))	{
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

		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

		List<CodeDetailVO> gsQ008Sub = codeInfo.getCodeList("Q008", "", false);		//가입고사용여부 관련
		for(CodeDetailVO map : gsQ008Sub)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsQ008Sub", map.getCodeNo());
			}
		}

		//출력라벨 선택을 위한 로직
		List<CodeDetailVO> gsSelectLabel = codeInfo.getCodeList("B706", "", false);
		for(CodeDetailVO map : gsSelectLabel)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSelectLabel", map.getCodeNo());
			}
		}

		//라벨출력을 위한 작업자 가져오는 로직
		List<CodeDetailVO> gsWorker = codeInfo.getCodeList("B705", "", false);
		for(CodeDetailVO map : gsWorker)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsWorker", map.getCodeName());
			}
		}
		return JSP_PATH + "s_mms510ukrv_in";
	}

	/**
	 * 긴급작업지시 등록(inno)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_pmp110ukrv_in.do")
	public String s_pmp110ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		cdo = codeInfo.getCodeInfo("P005", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoNo", cdo.getRefCode1());	 // 생산자동채번유무

		cdo = codeInfo.getCodeInfo("P000", "3");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsBadInputYN",cdo.getRefCode1());  // 자동입고시 불량입고 반영여부

		cdo = codeInfo.getCodeInfo("P121", "01");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChildStockPopYN",cdo.getRefCode1());  // 자재부족팝업 호출여부

		List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("WP01", "", false);			// 작지설비 관리여부
		for(CodeDetailVO map : gsMoldCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsMoldCode", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsEquipCode = codeInfo.getCodeList("WP02", "", false);			// 작지금형 관리여부
		for(CodeDetailVO map : gsEquipCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsEquipCode", map.getCodeNo());
			}
		}

		int i = 0;
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);   // BOM PATH 관리여부
		for(CodeDetailVO map : gsBomPathYN) {
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());

				i++;  // RecordCount
			}
		}
		if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

		cdo = codeInfo.getCodeInfo("B090", "PA");   //							  // LOT 관리기준 설정 재고와 작업지시 LOT 연계여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		cdo = codeInfo.getCodeInfo("P000", "4");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsGoodsInputYN",cdo.getRefCode1());  // 긴급작지시 상품입력 가능여부

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoType",cdo.getRefCode1());	  //Y:의뢰번호(txtOrderNum) lock,disable


		cdo = codeInfo.getCodeInfo("B907", "pmp110ukrv");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseWorkColumnYn", cdo.getRefCode1());	 // 생산자동채번유무

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_pmp110ukrv_in".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "s_pmp110ukrv_in";
	}

	@RequestMapping(value = "/z_in/s_sof130rkrv_in.do")
	public String s_sof130rkrv_in(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_sof130rkrv_in";
	}

	@RequestMapping(value = "/z_in/s_opo100ukrv_in.do")
	public String s_opo100ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "s_opo100ukrv_in";
	}

	@RequestMapping(value = "/z_in/s_opo110ukrv_in.do")
	public String s_opo110ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "s_opo110ukrv_in";
	}
	/**
	 * 작업실적 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_pmr100ukrv_in.do")
	public String s_pmr100ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		//20200423 추가
		 model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		cdo = codeInfo.getCodeInfo("B090", "PB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1()); // 작업지시와 생산실적LOT 연계여부 설정 값 알기

		cdo = codeInfo.getCodeInfo("P000", "6");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsChkProdtDateYN",cdo.getRefCode1()); // 작업실적 등록시 착수예정일 체크여부

		cdo = codeInfo.getCodeInfo("P100", "1");	 										  // 생산완료시점 (100%)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("glEndRate",cdo.getRefCode1());
		}

		cdo = codeInfo.getCodeInfo("B084", "D");	 										  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		return JSP_PATH + "s_pmr100ukrv_in";
	}

	/**
	 * 출고예정표
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_pmr101ukrv_in.do")
	public String s_pmr101ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("CSS_TYPE", "-large");model.addAttribute("CSS_TYPE", "-large");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		//20200407 추가: 사이즈 증가
		model.addAttribute("CSS_TYPE", "-large");

		return JSP_PATH + "s_pmr101ukrv_in";
	}

	@RequestMapping(value = "/z_in/s_srq100ukrv_in.do")
	public String s_srq100ukrv_in(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		cdo = codeInfo.getCodeInfo("S012", "8");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("S026", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S036", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPrintPgID",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S048", "SR");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsTimeYN1", cdo.getRefCode1());
		}else {
			model.addAttribute("gsTimeYN1", "N");
		}

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsTimeYN2", cdo.getRefCode1());
		}else {
			model.addAttribute("gsTimeYN2", "N");
		}

		cdo = codeInfo.getCodeInfo("S071", "1");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsScmUseYN", cdo.getRefCode1());
		}else {
			model.addAttribute("gsScmUseYN", "N");
		}

		cdo = codeInfo.getCodeInfo("Z001", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsBoxQYn", "Y");
			model.addAttribute("gsMiniPackQYn", "Y");
		}else {
			model.addAttribute("gsBoxQYn", "N");
			model.addAttribute("gsMiniPackQYn", "N");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn", cdo.getRefCode1());
			model.addAttribute("gsUnitChack", cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		} else {
			model.addAttribute("gsPriceGubun",		"A");		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			"KG");		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			"L");		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}

		model.addAttribute("COMBO_WH_U_LIST", comboService.getWhUList(param));

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("srq100ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}

		return JSP_PATH + "s_srq100ukrv_in";
	}

	/**
	 * 감마의뢰 미입고 현황
	 * @retrun
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_opo110skrv_in.do", method = RequestMethod.GET)
	public String s_opo110skrv_in() throws Exception{
		return JSP_PATH + "s_opo110skrv_in";
	}
	/**
	 * 오토라벨러 출력
	 * @retrun
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_pmp900rkrv_in.do", method = RequestMethod.GET)
	public String s_pmp900rkrv_in() throws Exception{
		return JSP_PATH + "s_pmp900rkrv_in";
	}

	/**
	 * 품질자가사용현황
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_qms400skrv_in.do")
	public String s_qms400skrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_qms400skrv_in";
	}
	/**
	 * 분주QC검사현황
	 * @throws Exception
	 * */
	@RequestMapping(value = "/z_in/s_qms300skrv_in.do", method = RequestMethod.GET)
	public String s_qms300skrv_in() throws Exception{
		return JSP_PATH + "s_qms300skrv_in";
	}

	@RequestMapping(value = "/z_in/s_srq110ukrv_in.do")
	public String s_srq110ukrv_in(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;


		cdo = codeInfo.getCodeInfo("S012", "8");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("S026", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S036", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsPrintPgID",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("S037", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S037", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsStr100UkrLink",	cdo.getCodeName());				//출고등록 링크 PGM ID

		cdo = codeInfo.getCodeInfo("S048", "SR");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsTimeYN1", cdo.getRefCode1());
		}else {
			model.addAttribute("gsTimeYN1", "N");
		}

		cdo = codeInfo.getCodeInfo("S048", "SS");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsTimeYN2", cdo.getRefCode1());
		}else {
			model.addAttribute("gsTimeYN2", "N");
		}

		cdo = codeInfo.getCodeInfo("S071", "1");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsScmUseYN", cdo.getRefCode1());
		}else {
			model.addAttribute("gsScmUseYN", "N");
		}

		cdo = codeInfo.getCodeInfo("Z001", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsBoxQYn", "Y");
			model.addAttribute("gsMiniPackQYn", "Y");
		}else {
			model.addAttribute("gsBoxQYn", "N");
			model.addAttribute("gsMiniPackQYn", "N");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPointYn", cdo.getRefCode1());
			model.addAttribute("gsUnitChack", cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		cdo = codeInfo.getCodeInfo("S116", "srq101ukrv");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsPriceGubun",		cdo.getRefCode1());		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			cdo.getRefCode2());		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			cdo.getRefCode3());		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		} else {
			model.addAttribute("gsPriceGubun",		"A");		//수주내역 그리드에서 PRICE_TYPE 디폴트값으로 사용
			model.addAttribute("gsWeight",			"KG");		//수주내역 그리드에서 WGT_UNIT 디폴트값으로 사용
			model.addAttribute("gsVolume",			"L");		//수주내역 그리드에서 VOL_UNIT 디폴트값으로 사용
		}

		model.addAttribute("COMBO_WH_U_LIST", comboService.getWhUList(param));
		//20200519 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_srq110ukrv_in".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}

		return JSP_PATH + "s_srq110ukrv_in";
	}

	/**
	 * 출하지시대비재고부족현황
	 * @throws Exception
	 * */
	@RequestMapping(value = "/z_in/s_srq130skrv_in.do", method = RequestMethod.GET)
	public String s_srq130skrv_in() throws Exception{
		return JSP_PATH + "s_srq130skrv_in";
	}

	/**
	 * 실사등록모바일
	 * @throws Exception
	 * */
	@RequestMapping(value = "/z_in/Biv120ukrv_mobile.do", method = RequestMethod.GET)
	public String Biv120ukrv_mobile() throws Exception{
		return JSP_PATH + "Biv120ukrv_mobile";
	}

	/**
	 * 불량현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_pmr360skrv_in.do")
	public String s_pmr360skrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		Gson gson = new Gson();
		String colData = gson.toJson(s_pmr360skrv_inService.selectColumns(param));
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_pmr360skrv_in";
	}

	@RequestMapping(value = "/z_in/s_ssa450skrv_in.do")
	public String s_ssa450skrv_in(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "s_ssa450skrv_in";
	}

	/**
	 * 근태일괄등록(S)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_hat900ukr_in.do",method = RequestMethod.GET)
	public String s_hat900ukr_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_hat900ukr_in";
	}

	@RequestMapping(value = "/z_in/s_biv320skrv_in.do")
	public String s_biv320skrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "s_biv320skrv_in";
	}

	@RequestMapping(value = "/z_in/s_str410skrv_in.do")
	public String s_str410skrv_in(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "s_str410skrv_in";
	}

	/**
	 * 20200521 추가 - 구매입고 라벨 출력(s_mtr110skrv_in)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_mtr110skrv_in.do")
	public String s_mtr110skrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "s_mtr110skrv_in";
	}


	/**
	 * 재고이동출고 등록(IN) (s_btr111ukrv_in) - 20200615 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_btr111ukrv_in.do",method = RequestMethod.GET)
	public String s_btr111ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B022", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsInvstatus",cdo.getRefCode1());		/* 재고상태관리(+/-) */

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("SO", map.getCodeNo());
			}
		}																						/* 주화폐단위 */

		cdo = codeInfo.getCodeInfo("B090", "IA");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	/* 재고와 재고이동LOT 연계여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		cdo = codeInfo.getCodeInfo("B041", "1");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutotype",cdo.getRefCode1());

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn)); // 담당자

		List<CodeDetailVO> gsUsePabStockYn = codeInfo.getCodeList("I014", "", false);//가용재고 체크여부
		for(CodeDetailVO map : gsUsePabStockYn) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsUsePabStockYn", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_btr111ukrv_in";
	}
	
	@RequestMapping(value = "/z_in/s_cdr400skrv_in.do")
	public String cdr400skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
        
        CodeDetailVO showFinanceDefaltCode = codeInfo.getCodeInfo("CA11", "10");	
        if(showFinanceDefaltCode != null)	{
        	model.addAttribute("showFinanceDefalt", ObjUtils.nvlObj(showFinanceDefaltCode.getRefCode1(), "N"));
        } else {
        	model.addAttribute("showFinanceDefalt", "N");
        }
		return JSP_PATH + "s_cdr400skrv_in";
	}
	
	@RequestMapping(value = "/z_in/s_btr171ukrv_in.do")
	public String s_btr171ukrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("I001", "7");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("sApplyYN",cdo.getRefCode1());	/* LOT관리여부 */

		cdo = codeInfo.getCodeInfo("I001", "8");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("sCellWhCode",cdo.getRefCode1());	/* Cell관리여부 */

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeLot",cdo.getRefCode1());		/* 재고합산유형 : Lot No. 합산 */

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());		/* 재고합산유형 : 창고 Cell 합산 */

		return JSP_PATH + "s_btr171ukrv_in";
	}
	
	
	/**
	 * 퇴직연금계산 (s_hrt700ukr_in)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_hrt700ukr_in.do")
	public String s_hrt700ukr_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		Gson gson = new Gson();
		String colData = gson.toJson(s_hrt700ukr_inService.selectColumns(param));
		model.addAttribute("colData", colData);

		return JSP_PATH + "s_hrt700ukr_in";
	}
	
	
	/**
	 * 퇴직연금조회 (s_hrt700skrv_in)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_in/s_hrt700skrv_in.do")
	public String s_hrt700skrv_in(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();
		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "s_hrt700skrv_in";
	}
}