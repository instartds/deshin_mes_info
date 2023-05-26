package foren.unilite.modules.z_mek;

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

@Controller
public class Z_mekController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/z_mek/";
	
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource( name = "s_qbs100ukrv_mekService" )
	private S_qbs100ukrv_mekServiceImpl s_qbs100ukrv_mekService;

	@Resource( name = "s_qbs200ukrv_mekService" )
	private S_qbs200ukrv_mekServiceImpl s_qbs200ukrv_mekService;

//	@Resource( name = "s_qbs400ukrv_mekService" )
//	private S_qbs400ukrv_mekServiceImpl s_qbs400ukrv_mekService;

	@RequestMapping(value = "/z_mek/s_mms200ukrv_mek.do",method = RequestMethod.GET)
	public String s_mms200ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("M025", "", false);		//수입검사후 자동입고여부
		for(CodeDetailVO map : gsInspecFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsAutoInputFlag", map.getCodeNo());
			}
		}
		
		cdo = codeInfo.getCodeInfo("B090", "IB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준 설정
		
		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1()) ? "N" : cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential"  ,cdo.getRefCode2() == null || "".equals(cdo.getRefCode2()) ? "N" : cdo.getRefCode2());
		
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_mms200ukrv_mek".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);		//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
		for(CodeDetailVO map : gsInspecPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode3()))	{
				model.addAttribute("gsInspecPrsn", map.getCodeNo());
			}
		}
		
		return JSP_PATH + "s_mms200ukrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_mms200skrv_mek.do",method = RequestMethod.GET)
	public String s_mms200skrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);		//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
		for(CodeDetailVO map : gsInspecPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode3()))	{
				model.addAttribute("gsInspecPrsn", map.getCodeNo());
			}
		}
		
		return JSP_PATH + "s_mms200skrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_qms100ukrv_mek.do",method = RequestMethod.GET)
	public String s_qms100ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "s_qms100ukrv_mek";
	}
	
	@RequestMapping(value = "/z_mek/s_bmd100ukrv_mek.do",method = RequestMethod.GET)
	public String s_bmd100ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "s_bmd100ukrv_mek";
	}
	
	@RequestMapping(value = "/z_mek/s_bmd110ukrv_mek.do",method = RequestMethod.GET)
	public String s_bmd110ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "s_bmd110ukrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_qms100skrv_mek.do",method = RequestMethod.GET)
	public String s_qms100skrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "s_qms100skrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_qms500ukrv_mek.do",method = RequestMethod.GET)
	public String s_qms500ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("M025", "", false);		//수입검사후 자동입고여부
		for(CodeDetailVO map : gsInspecFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsAutoInputFlag", map.getCodeNo());
			}
		}
		
		cdo = codeInfo.getCodeInfo("B090", "IB");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsManageLotNoYN",cdo.getRefCode1());	//LOT관리기준 설정
		
		cdo = codeInfo.getCodeInfo("B090", "OA");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1()) ? "N" : cdo.getRefCode1());
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential"  ,cdo.getRefCode2() == null || "".equals(cdo.getRefCode2()) ? "N" : cdo.getRefCode2());
		
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("s_qms500ukrv_mek".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}
		
		List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);		//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
		for(CodeDetailVO map : gsInspecPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode3()))	{
				model.addAttribute("gsInspecPrsn", map.getCodeNo());
			}
		}
		
		return JSP_PATH + "s_qms500ukrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_qms500skrv_mek.do",method = RequestMethod.GET)
	public String s_qms500skrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);		//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
		for(CodeDetailVO map : gsInspecPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode3()))	{
				model.addAttribute("gsInspecPrsn", map.getCodeNo());
			}
		}
		
		return JSP_PATH + "s_qms500skrv_mek";
	}
	
	@RequestMapping(value = "/z_mek/s_qbs100ukrv_mek.do",method = RequestMethod.GET)
	public String s_qbs100ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		Map<String, Object> columnList = s_qbs100ukrv_mekService.selectColumnList(param);
		model.addAttribute("gsColumnList", ObjUtils.toJsonStr(columnList));
		
		return JSP_PATH + "s_qbs100ukrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_qbs200ukrv_mek.do",method = RequestMethod.GET)
	public String s_qbs200ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("COMBO_WS_LIST", s_qbs200ukrv_mekService.getWsList(param));

		Map<String, Object> columnList = s_qbs100ukrv_mekService.selectColumnList(param);
		model.addAttribute("gsColumnList", ObjUtils.toJsonStr(columnList));
		
		return JSP_PATH + "s_qbs200ukrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_qbs400ukrv_mek.do",method = RequestMethod.GET)
	public String s_qbs400ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "s_qbs400ukrv_mek";
	}

	
	@RequestMapping(value = "/z_mek/s_str106ukrv_mek.do")
	public String s_str106ukrv_mek(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))	model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");	//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str103ukrv");	//영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");	//LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false);	//출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInoutAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1") || map.getCodeNo().equals("3")){
					model.addAttribute("gsInoutAutoYN", "Y");
				}else{
					model.addAttribute("gsInoutAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsInoutAutoYN", "Y");

		cdo = codeInfo.getCodeInfo("B022", "1");	//재고상태관리정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsInvstatus",cdo.getRefCode1());
		}else {
			model.addAttribute("gsInvstatus", "+");
		}

		cdo = codeInfo.getCodeInfo("B117", "S");	//중량단위 계산시 판매단위수량 소수점 허용여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPointYn",cdo.getRefCode1());
			model.addAttribute("gsUnitChack",cdo.getRefCode2());
		}else {
			model.addAttribute("gsPointYn", "Y");
			model.addAttribute("gsUnitChack", "EA");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsCreditYn", "N");

		 List<CodeDetailVO> cdList = codeInfo.getCodeList("S007");
			if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");	//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode",cdo.getRefCode1());
		}else {
			model.addAttribute("gsRefWhCode", "1");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");	//부가세율정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsVatRate",cdo.getRefCode1());
		}else {
			model.addAttribute("gsVatRate", 10);
		}

		cdo = codeInfo.getCodeInfo("S048", "SI");	//시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsManageTimeYN", "N");
		}
		cdo = codeInfo.getCodeInfo("S120", "1");   //셀 자동LOT 배정여부(Y/N)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("useLotAssignment",cdo.getRefCode1());
		}else {
			model.addAttribute("useLotAssignment", "N");
		}
		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		List<CodeDetailVO> gsBoxYN = codeInfo.getCodeList("S149", "", false);
		for(CodeDetailVO map : gsBoxYN)   {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsBoxYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("str103ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		/*List<CodeDetailVO> gsDefaultType = codeInfo.getCodeList("S148", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsDefaultType)	{
				model.addAttribute("gsReportGubun", map.getRefCode1());
		}*/

		int j = 0;
		List<CodeDetailVO> gsDefaultType = codeInfo.getCodeList("S148", "", false);   //자국화폐단위 정보
		for(CodeDetailVO map : gsDefaultType) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsDefaultType", map.getCodeNo());
				j++;
			}
		}
		if(j == 0) model.addAttribute("gsDefaultType", "10");

		//20200108 공통코드(S033 - 출고등록시 자동매출생성/삭제여부) 가져오는 로직 추가: 1 자동, 2 수동(값이 없을 때는 수동)
		List<CodeDetailVO> gsAutoSalesYN = codeInfo.getCodeList("S033", "", false);
		for(CodeDetailVO map : gsAutoSalesYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsAutoSalesYN", map.getCodeNo());
			}
		}
		//20200116 공통코드(S156 - LOT팝업에 Main Grid에 적용된 LOT표시 여부) 가져오는 로직 추가
		List<CodeDetailVO> gsShowExistLotNo = codeInfo.getCodeList("S156", "", false);
		for(CodeDetailVO map : gsShowExistLotNo) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsShowExistLotNo", map.getCodeNo());
			}
		}
		return JSP_PATH + "s_str106ukrv_mek";
	}

	@RequestMapping(value = "/z_mek/s_pmp110ukrv_mek.do",method = RequestMethod.GET)
	public String s_pmp110ukrv_mek(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {};
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "s_pmp110ukrv_mek";
	}
	
}
