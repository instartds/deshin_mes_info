package foren.unilite.modules.prodt.pmp;

import java.io.DataOutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.equip.esa.EsaExcelServiceImpl;
import foren.unilite.modules.prodt.ProdtCommonServiceImpl;

@Controller
public class PmpController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/prodt/pmp/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="prodtCommonService")
	private ProdtCommonServiceImpl prodtCommonService;

	@Resource(name="pmp110ukrvService")
	private Pmp110ukrvServiceImpl pmp110ukrvService;


	@Resource(name="pmpExcelService")
	private PmpExcelServiceImpl pmpExcelService;
	/**
	 * 제조오더 조정/확정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp070ukrv.do")
	public String pmp070ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M400", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("ConfirmPeriod",	cdo.getRefCode1());		// MRP 관련 기준 설정 (확정기간)

		cdo = codeInfo.getCodeInfo("M400", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("PrePeriod", cdo.getRefCode1());			// MRP 관련 기준 설정 (예시기간)

		cdo = codeInfo.getCodeInfo("P005", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoYN", cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("P121", "01");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsChildStockPopYN", cdo.getRefCode1());



		return JSP_PATH + "pmp070ukrv";
	}

	/**
	 * 공정수순등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp072ukrv.do")
	public String pmp072ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M400", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("ConfirmPeriod", cdo.getRefCode1());	 // MRP 관련 기준 설정 (확정기간)

		cdo = codeInfo.getCodeInfo("M400", "3");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("PrePeriod", cdo.getRefCode1());		 // MRP 관련 기준 설정 (예시기간)

		cdo = codeInfo.getCodeInfo("P005", "2");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsAutoYN", cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("P121", "01");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsChildStockPopYN", cdo.getRefCode1());



		return JSP_PATH + "pmp072ukrv";
	}

	/**
	 * 제조오더 조정/확정(사출)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp060ukrv.do")
	public String pmp060ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp060ukrv";
	}

	/**
	 * 일괄제조오더 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp100ukrv.do")
	public String pmp100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		cdo = codeInfo.getCodeInfo("B907", "pmp100ukrv");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseWorkColumnYn", cdo.getRefCode1());	 // 생산자동채번유무

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp100ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		//출력 관련해서 제이월드 report만 따로 사용... 하기 위해 comp_name 가져오는 로직
		model.addAttribute("gsCompName", prodtCommonService.getCompName(param));

		return JSP_PATH + "pmp100ukrv";
	}

	@RequestMapping(value = "/prodt/pmp100rkrvExcelDown.do")
	public ModelAndView pmp100rkrvDownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = pmpExcelService.makeExcel(paramMap);
        String title = "제조지시 및 기록서";

        return ViewHelper.getExcelDownloadView(wb, title);
	}
	/**
	 * 일괄제조오더 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp101ukrv.do")
	public String pmp101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp101ukrv";
	}

	/**
	 * 긴급작업지시 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp110ukrv.do")
	public String pmp110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
			if("pmp110ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		//출력 관련해서 제이월드 report만 따로 사용... 하기 위해 comp_name 가져오는 로직
		model.addAttribute("gsCompName", prodtCommonService.getCompName(param));

		return JSP_PATH + "pmp110ukrv";
	}


	/**
	 * 포장작업지시 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp120ukrv.do")
	public String pmp120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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


		cdo = codeInfo.getCodeInfo("B907", "pmp120ukrv");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseWorkColumnYn", cdo.getRefCode1());	 // 생산자동채번유무

		return JSP_PATH + "pmp120ukrv";
	}


	/**
	 * 작업지시 조정/마감 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp180ukrv.do")
	public String pmp180ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp180ukrv";
	}

	/**
	 * 작업지시 수주번호연계
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp181ukrv.do")
	public String pmp181ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp181ukrv";
	}
	/**
	 * 작업지시서출력(조회후 출력)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp190skrv.do")
	public String pmp190skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pmp190skrv";
	}

	/**
	 * 작업지시서출력(조회후 출력)(코디)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp270skrv.do")
	public String pmp270skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

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

		return JSP_PATH + "pmp270skrv";
	}

	/**
	 * 자재예약출고조정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp142ukrv.do")
	public String pmp142ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "pmp142ukrv";
	}

	/**
	 * 품목 LOT추적 현황 (pmp150skrv)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp150skrv.do")
	public String pmp150skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));

		return JSP_PATH + "pmp150skrv";
	}

	/**
	 * 자재예약 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp160ukrv.do")
	public String pmp160ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		//대체품목 등록여부(공통코드 B081에서 설정) - refcode를 가져올 때 cdo 사용, subcode를 가져올 때 List 사용
		List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("B081", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}
		}

		//출고요청자동생성여부 공통코드에서 가져오기(P109)
		List<CodeDetailVO> gsAutomatedIssuance = codeInfo.getCodeList("P109", "", false);
		for (CodeDetailVO map : gsAutomatedIssuance) {
			if ("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
				model.addAttribute("gsAutomatedIssuance", map.getCodeNo());
			} else {
				model.addAttribute("gsAutomatedIssuance", "N");
			}
		}

		//작지가용재고 체크여부 공통코드에서 가져오기(P112)
		List<CodeDetailVO> gsAvailibleStockCheck = codeInfo.getCodeList("P112", "", false);
		for (CodeDetailVO map : gsAvailibleStockCheck) {
			if ("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1())) {
				model.addAttribute("gsAvailibleStockCheck", map.getCodeNo());
			} else {
				model.addAttribute("gsAvailibleStockCheck", "N");
			}
		}

		//자재예약 삭제시 출고요청 삭제여부 공통코드에서 가져오기(P115)
		cdo = codeInfo.getCodeInfo("P115", "A");
		if(!ObjUtils.isEmpty(cdo) && ("Y".equals(cdo.getRefCode1()) || "y".equals(cdo.getRefCode1()))){
			model.addAttribute("gsIssueRequestDelete", cdo.getRefCode1());
		} else {
			model.addAttribute("gsIssueRequestDelete", "N");
		}

		//생산가공창고적용시 자재예약창고를 출고방법에따라 설정여부(Y/N) 공통코드에서 가져오기(P000)
		cdo = codeInfo.getCodeInfo("P000", "7");
		if(!ObjUtils.isEmpty(cdo) && ("Y".equals(cdo.getRefCode1()) || "y".equals(cdo.getRefCode1()))){
			model.addAttribute("gsWorkWhcode", cdo.getRefCode1());
		} else {
			model.addAttribute("gsWorkWhcode", "N");
		}

		return JSP_PATH + "pmp160ukrv";
	}

	@RequestMapping(value = "/prodt/pmp200ukrv.do")
	public String pmp200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		// BOM PATH 관리여부
		int i = 0;
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());
				i++;  // RecordCount
			}
		}
		if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

		//출고요청 승인방식(수동/자동승인) 공통코드에서 가져오기(P118)
		List<CodeDetailVO> gsAutoAgree = codeInfo.getCodeList("P118", "", false);
		for(CodeDetailVO map : gsAutoAgree)	{
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsAutoAgree", map.getCodeNo());
			}
		}

		//자동채번 공통코드에서 가져오기(P005)
		cdo = codeInfo.getCodeInfo("P005", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutotype",cdo.getRefCode1());

		//승인자 ID 가져오기(P119)에서 출고요청자에 따른 승인자ID 가져오기
		/*
		 * List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("P119", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if(사용자명.equals(map.getCodeName()))	{
				model.addAttribute("gsAgreePrsn", map.getRefCode1());
			}
		}
		*/
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp200ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "pmp200ukrv";
	}

	/**
	 * 출고요청 조정
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp203ukrv.do",method = RequestMethod.GET)
	public String pmp203ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));



		int i = 0;
		List<CodeDetailVO>  gsSaleAutoYN= codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsSaleAutoYN)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map.getCodeNo());

				i++;  // RecordCount
			}
			if(i == 0) model.addAttribute("gsBomPathYN", "N");
		}



		return JSP_PATH + "pmp203ukrv";
	}

	/**
	 * 출고요청 승인
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp250ukrv.do")
	public String pmp250ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model, CodeDetailVO map) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		int i = 0;
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);	// BOM PATH 관리여부 (클래스 파일에서 SUBCODE를 SELECT하는 쿼리)
		for(CodeDetailVO map1 : gsBomPathYN)	{
			if("Y".equals(map1.getRefCode1())||"y".equals(map1.getRefCode1()))	{
				model.addAttribute("gsBomPathYN", map1.getCodeNo());

				i++;  // RecordCount
			}
		}
		if(i == 0) model.addAttribute("gsBomPathYN", "N");

		return JSP_PATH + "pmp250ukrv";
	}

	/**
	 * 작업지시현황 조회(작업지시별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp120skrv.do")
	public String pmp120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("CSS_TYPE", "-large2"); //폰트크기 늘리기

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pmp120skrv";
	}
	/**
	 * 작업지시현황 조회(공정별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp170skrv.do")
	public String pmp170skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp170skrv";
	}
	/**
	 * 작업지시현황 조회(공정달력)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp171skrv.do")
	public String pmp171skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp171skrv";
	}
	/**
	 * 자재예약현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp140skrv.do")
	public String pmp140skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp140skrv";
	}
	/**
	 * 자재예약/촐고현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp141skrv.do")
	public String pmp141skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp141skrv";
	}
	/**
	 * 출고요청현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp210skrv.do")
	public String pmp210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp210skrv";
	}

	@RequestMapping(value = "/prodt/pmp130rkrv.do")
	public String pmp130rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST"	  , comboService.getWsList(param));

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp130rkrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		return JSP_PATH + "pmp130rkrv";
	}


	@RequestMapping(value = "/prodt/pmp220rkrv.do")
	public String pmp220rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp220rkrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}

		return JSP_PATH + "pmp220rkrv";
	}

	@RequestMapping(value = "/prodt/test123.do")
	public String test123(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());


		return JSP_PATH + "test123";
	}
	@RequestMapping(value="/prodt/selectProgInfo.do")
	public ModelAndView selectProgInfo(ExtHtttprequestParam _req,LoginVO user, ListOp listOp,Model model) throws Exception{
		Map param = new HashMap<>();
		String workShopCode = _req.getParameter("WORK_SHOP_CODE");
		String itemCode = _req.getParameter("ITEM_CODE");
		String compCode = _req.getParameter("S_COMP_CODE");
		String divCode = _req.getParameter("DIV_CODE");
		param.put("WORK_SHOP_CODE", workShopCode);
		param.put("ITEM_CODE", itemCode);
		param.put("S_COMP_CODE", compCode);
		param.put("DIV_CODE", divCode);

		return ViewHelper.getJsonView(pmp110ukrvService.selectProgInfo(param));
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
	@RequestMapping(value = "/prodt/pmp121skrv.do")
	public String pmp121skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "pmp121skrv";
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
	@RequestMapping(value = "/prodt/pmp122skrv.do")
	public String pmp122skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "pmp122skrv";
	}

	/**
	 * 긴급작업지시 등록(코디)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp260ukrv.do")
	public String pmp260ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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


		cdo = codeInfo.getCodeInfo("B907", "pmp260ukrv");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsUseWorkColumnYn", cdo.getRefCode1());	 // 생산자동채번유무

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp260ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		//출력 관련해서 제이월드 report만 따로 사용... 하기 위해 comp_name 가져오는 로직
		model.addAttribute("gsCompName", prodtCommonService.getCompName(param));

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

		cdo = codeInfo.getCodeInfo("BS82", loginVO.getDivCode());    //작업지시데이터연동정보
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
			 	model.addAttribute("gsIfCode", cdo.getRefCode1().toUpperCase());
			 	model.addAttribute("gsIfSiteCode", cdo.getRefCode2());
			 }else{
			 	model.addAttribute("gsIfCode", "N");
			 	model.addAttribute("gsIfSiteCode", "");
			 }
	     }else {
			 	model.addAttribute("gsIfCode", "N");
			 	model.addAttribute("gsIfSiteCode", "");
	     }


		return JSP_PATH + "pmp260ukrv";
	}

	/**
	 * 칭량출고등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp280ukrv.do")
	public String pmp280ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

//		model.addAttribute("CSS_TYPE", "-large");

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("M514", "", false);			// 칭량출고 조건
		for(CodeDetailVO map : gsMoldCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsOutGubun", map.getCodeNo());
			}
		}

		return JSP_PATH + "pmp280ukrv";
	}

	/**
	 * 일자별생산지시량
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp290skrv.do")
	public String pmp290skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "pmp290skrv";
	}

	/**
	 * 칭량출고등록(키오스크)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp281ukrv.do")
	public String pmp281ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		model.addAttribute("CSS_TYPE", "-large2");

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("M514", "", false);			// 칭량출고 조건
		for(CodeDetailVO map : gsMoldCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsOutGubun", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsn)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		List<CodeDetailVO> gsKioskUrl = codeInfo.getCodeList("P523", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsKioskUrl)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsKioskConUrl", map.getRefCode2());
			}
		}

		List<CodeDetailVO> gsInOutPrsnLogin = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsnLogin)	{
			if(loginVO.getUserID().equals(map.getRefCode10()))	{
				model.addAttribute("gsInOutPrsnLogin", map.getCodeNo());
			}
		}
		return JSP_PATH + "pmp281ukrv";
	}

	/**
	 * 칭량출고등록(키오스크)(제조 작업장 재공창고 사용할 경우)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp282ukrv.do")
	public String pmp282ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		model.addAttribute("CSS_TYPE", "-large2");  //화면크기조정(POP)

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("M514", "", false);			// 칭량출고 조건
		for(CodeDetailVO map : gsMoldCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsOutGubun", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsn)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}
		List<CodeDetailVO> gsKioskUrl = codeInfo.getCodeList("P523", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsKioskUrl)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsKioskConUrl", map.getRefCode2());
			}
		}

		List<CodeDetailVO> gsInOutPrsnLogin = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsnLogin)	{
			if(loginVO.getUserID().equals(map.getRefCode10()))	{
				model.addAttribute("gsInOutPrsnLogin", map.getCodeNo());
			}
		}
		return JSP_PATH + "pmp282ukrv";
	}

	/**
	 * 자재생산출고(재공창고 사용)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp295ukrv.do")
	public String pmp295ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("CSS_TYPE", "-large2");  //화면크기조정(POP)

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		// BOM PATH 관리여부
		int i = 0;
		List<CodeDetailVO> gsBomPathYN = codeInfo.getCodeList("B082", "", false);
		for(CodeDetailVO map : gsBomPathYN)	{
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsShowBtnReserveYN", map.getCodeNo());
				i++;  // RecordCount
			}
		}
		if(i == 0) model.addAttribute("gsShowBtnReserveYN", "N");

		//출고요청 승인방식(수동/자동승인) 공통코드에서 가져오기(P118)
		List<CodeDetailVO> gsAutoAgree = codeInfo.getCodeList("P118", "", false);
		for(CodeDetailVO map : gsAutoAgree)	{
			if("Y".equals(map.getRefCode1())||"y".equals(map.getRefCode1()))	{
				model.addAttribute("gsAutoAgree", map.getCodeNo());
			}
		}

		//자동채번 공통코드에서 가져오기(P005)
		cdo = codeInfo.getCodeInfo("P005", "3");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutotype",cdo.getRefCode1());

		//승인자 ID 가져오기(P119)에서 출고요청자에 따른 승인자ID 가져오기
		/*
		 * List<CodeDetailVO> gsExchgRegYN = codeInfo.getCodeList("P119", "", false);
		for(CodeDetailVO map : gsExchgRegYN)	{
			if(사용자명.equals(map.getCodeName()))	{
				model.addAttribute("gsAgreePrsn", map.getRefCode1());
			}
		}
		*/
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmp295ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "pmp295ukrv";
	}

	/**
	 * 제조이력-출고요청
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp284ukrv.do",method = RequestMethod.GET)
	public String pmp284ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))   model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		return JSP_PATH + "pmp284ukrv";
	}

	@RequestMapping(value = "/prodt/pmp285skrv.do")
	public String pmp285skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmp285skrv";
	}
	/**
	 * 비가동등록(신규)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp300ukrv.do")
	public String pmp300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("CSS_TYPE", "-large2"); //폰트크기 늘리기

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pmp300ukrv";
	}
	/**
	 * 자재생산출고(재공창고 사용)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp400ukrv.do")
	public String pmp400ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {



		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		model.addAttribute("CSS_TYPE", "-large");  //화면크기조정(POP)


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsMoldCode = codeInfo.getCodeList("M514", "", false);			// 칭량출고 조건
		for(CodeDetailVO map : gsMoldCode) {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsOutGubun", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsn)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsInOutPrsn", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInOutPrsnLogin = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsInOutPrsnLogin)	{
			if(loginVO.getUserID().equals(map.getRefCode10()))	{
				model.addAttribute("gsInOutPrsnLogin", map.getCodeNo());
			}
		}
		return JSP_PATH + "pmp400ukrv";
	}

}
