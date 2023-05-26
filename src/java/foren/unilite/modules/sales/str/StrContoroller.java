package foren.unilite.modules.sales.str;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.context.FwContext;
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
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.human.HumanUtils;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Controller
public class StrContoroller extends UniliteCommonController {

	final static String		JSP_PATH	= "/sales/str/";
	public final static String FILE_TYPE_OF_PHOTO = "stampPhoto";


	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;


	@Resource(name="str120ukrvService")
	private Str120ukrvServiceImpl str120ukrvService;

	@Resource(name="str400rkrvServiceImpl")
	private Str400rkrvServiceImpl str400rkrvServiceImpl;

	@Resource(name="str410ukrvService")
	private Str410ukrvServiceImpl str410ukrvService;

	@Resource(name="str410skrvService")
	private Str410skrvServiceImpl str410skrvService;

	@Resource(name="str411ukrvService")
	private Str411ukrvServiceImpl str411ukrvService;

	@Resource(name="str412ukrvService")
	private Str412ukrvServiceImpl str412ukrvService;

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl salesCommonService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	@RequestMapping(value = "/sales/str300skrv.do")
	public String str300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "str300skrv";
	}

    @RequestMapping( value = "/sales/str300ukrv.do", method = RequestMethod.GET )
    public String bcm200ukrv() throws Exception {
        return JSP_PATH + "str300ukrv";
    }

	@RequestMapping(value = "/sales/str301skrv.do")
	public String str301skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "str301skrv";
	}

	@RequestMapping(value = "/sales/str302skrv.do")
	public String str302skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "str302skrv";
	}

	@RequestMapping(value = "/sales/str102ukrv.do")
	public String str102ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

		cdo = codeInfo.getCodeInfo("S012", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:수주번호(txtOrderNum) lock,disable

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
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
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

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
				model.addAttribute("gsDraftFlag", map.getCodeNo());					//Y:수주승인관련 필드 visible
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
		return JSP_PATH + "str102ukrv";
	}

	@RequestMapping(value = "/sales/downloadJasperSample.do", method = RequestMethod.GET)
	public ModelAndView pdfSampleDownload(ExtHtttprequestParam _req) throws Exception {

		Map param = _req.getParameterMap();

//		JasperParam jParam = JasperUtils.convertKey("str400rkrv", new HashMap());
		JasperFactory jParam = super.jasperService.createJasperFactory("str400rkrv", param);
//		List list = new ArrayList();
//		list.add(new HashMap());
//		jParam.setList(str400rkrvServiceImpl.getTransactionReceipt(param));

		return ViewHelper.getJasperView(jParam);
	}

	@RequestMapping(value = "/sales/str100ukrv.do")
	public String str100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))   model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");	//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);   //자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);  //매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str103ukrv");   //영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");   //LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false); //출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)   {
			if("Y".equals(map.getRefCode1()))   {
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
		for(CodeDetailVO map : gsCreditYn)  {
			if("Y".equals(map.getRefCode1()))   {
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
			if(!ObjUtils.isEmpty(cdList))   model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");   //멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
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

		cdo = codeInfo.getCodeInfo("S048", "SI");   //시/분/초 필드 처리여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsManageTimeYN",cdo.getRefCode1());
		}else {
			model.addAttribute("gsManageTimeYN", "N");
		}

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn)) model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));
		return JSP_PATH + "str100ukrv";
	}

	@RequestMapping(value = "/sales/str103ukrv.do")
	public String str103ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		//20200303 추가: 사이트 구분 운영코드(B259) 가져오는 로직 추가
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

		return JSP_PATH + "str103ukrv";
	}

	@RequestMapping(value = "/sales/str104ukrv.do")
	public String str104ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<ComboItemModel> whList = comboService.getWhList(param);
		if(!ObjUtils.isEmpty(whList))   model.addAttribute("whList",ObjUtils.toJsonStr(whList));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "3");	//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);   //자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsMoneyUnit", "KRW");

		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S029", "", false);  //매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");


		cdo = codeInfo.getCodeInfo("S116", "str104ukrv");   //영업 중량및 부피 단위관련 Default 설정
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPriceGubun",cdo.getRefCode1());
			model.addAttribute("gsWeight",cdo.getRefCode2());
			model.addAttribute("gsVolume",cdo.getRefCode3());
		}else {
			model.addAttribute("gsPriceGubun", "A");
			model.addAttribute("gsWeight", "KG");
			model.addAttribute("gsVolume", "L");
		}

		cdo = codeInfo.getCodeInfo("B090", "SB");   //LOT 연계여부 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		i = 0;
		List<CodeDetailVO> gsInoutAutoYN = codeInfo.getCodeList("S033", "", false); //출고등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsInoutAutoYN)   {
			if("Y".equals(map.getRefCode1()))   {
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
		for(CodeDetailVO map : gsCreditYn)  {
			if("Y".equals(map.getRefCode1()))   {
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
			if(!ObjUtils.isEmpty(cdList))   model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		cdo = codeInfo.getCodeInfo("B084", "D");	//재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		cdo = codeInfo.getCodeInfo("S112", "30");   //멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
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

		cdo = codeInfo.getCodeInfo("S048", "SI");   //시/분/초 필드 처리여부 조회
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
		if(!ObjUtils.isEmpty(salePrsn)) model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		List<CodeDetailVO> gsBoxYN = codeInfo.getCodeList("S149", "", false);
		for(CodeDetailVO map : gsBoxYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsBoxYN", map.getCodeNo());
			}
		}
		//20200108 공통코드(S033 - 출고등록시 자동매출생성/삭제여부) 가져오는 로직 추가: 1 자동, 2 수동(값이 없을 때는 수동)
		List<CodeDetailVO> gsAutoSalesYN = codeInfo.getCodeList("S033", "", false);
		for(CodeDetailVO map : gsAutoSalesYN) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsAutoSalesYN", map.getCodeNo());
			}
		}
		//20200115 공통코드(S156 - LOT팝업에 Main Grid에 적용된 LOT표시 여부) 가져오는 로직 추가
		List<CodeDetailVO> gsShowExistLotNo = codeInfo.getCodeList("S156", "", false);
		for(CodeDetailVO map : gsShowExistLotNo) {
			if("Y".equals(map.getRefCode1())) {
				model.addAttribute("gsShowExistLotNo", map.getCodeNo());
			}
		}
		return JSP_PATH + "str104ukrv";
	}

	/** 출고등록(개별)(str105ukrv) - 바코드
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str105ukrv.do")
	public String str105ukrv (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("B703", "01");	//선입선출 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("str105ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		int j = 0;
		List<CodeDetailVO> gsDefaultType = codeInfo.getCodeList("S148", "", false);		//거래명세서 유형
		for(CodeDetailVO map : gsDefaultType) {
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsDefaultType"	, map.getCodeNo());			//거래명세서 유형
				model.addAttribute("gsDefaultCrf"	, map.getRefCode2());		//CRF레포트 파일명
				model.addAttribute("gsDefaultFolder", map.getRefCode3());		//CRF레포트 기본 폴더(사이트 일때만 입력)
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
		return JSP_PATH + "str105ukrv";
	}

	/**
	 * 출고등록(건별)(LOT팝업) 20190909 - 신규 생성
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str106ukrv.do")
	public String str106ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "str106ukrv";
	}

	@RequestMapping(value = "/sales/str110ukrv.do")
	public String str110ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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


		cdo = codeInfo.getCodeInfo("S012", "4");	//자동채번여부(반품번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsAutoType",cdo.getRefCode1());
		}else {
			model.addAttribute("gsAutoType", "N");
		}

		int i = 0;
		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);	//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
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

		cdo = codeInfo.getCodeInfo("B084", "D");  //재고합산유형 : 창고 Cell 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		List<CodeDetailVO> gsReturnDetailType = codeInfo.getCodeList("S008", "", false);	//반품유형정보
		for(CodeDetailVO map : gsReturnDetailType)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsReturnDetailType", map.getCodeNo());
			}
		}

		i = 0;
		List<CodeDetailVO> gsReturnAutoYN = codeInfo.getCodeList("S034", "", false);	//반품등록시 자동매출생성/삭제여부정보 조회
		for(CodeDetailVO map : gsReturnAutoYN)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsReturnAutoYN", map.getCodeNo());
				if(map.getCodeNo().equals("1")){
					model.addAttribute("gsReturnAutoYN", "Y");
				}else{
					model.addAttribute("gsReturnAutoYN", "N");
				}
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsReturnAutoYN", "Y");


		i = 0;
		List<CodeDetailVO> gsOptDivCode = codeInfo.getCodeList("S034", "", false);	//매출사업장지정정보 조회
		for(CodeDetailVO map : gsOptDivCode)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsOptDivCode", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptDivCode", "1");

		cdo = codeInfo.getCodeInfo("S037", "4");	//링크프로그램정보(거래명세서) 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPringPgID",cdo.getCodeName());
		}

		cdo = codeInfo.getCodeInfo("S112", "30");	//멀티품목팝업시 반품창고 참조방법(1=품목의 주창고, 2=첫번째행의 출고창고)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefWhCode",cdo.getRefCode1());
		}else {
			model.addAttribute("gsRefWhCode", "1");
		}

		i = 0;
		List<CodeDetailVO> gsCreditYn = codeInfo.getCodeList("S026", "", false);	//여신적용시점정보 조회(1.수주,2.출고,3.매출,4.미적용)
		for(CodeDetailVO map : gsCreditYn)  {
			if("Y".equals(map.getRefCode1()))   {
				model.addAttribute("gsCreditYn", map.getCodeNo());
				if(map.getCodeNo().equals("2")){
					model.addAttribute("gsCreditYn", "Y");
				}else{
					model.addAttribute("gsCreditYn", "N");
				}
				i++;
			}
		}

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		List<CodeDetailVO> cdList = codeInfo.getCodeList("S008");	//반품유형정보 조회 jsp에서 fnAccountYN()처리용
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsOutType",ObjUtils.toJsonStr(cdList));


		cdo = codeInfo.getCodeInfo("S147", "10");	//반품창고를 품목의 주창고로 사용할지 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsRefMainWhCode",cdo.getRefCode1());
		}else {
			model.addAttribute("gsRefMainWhCode", "empty");
		}

		cdo = codeInfo.getCodeInfo("B092", "RI");	//Barcode 연계여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsBarcodeYn", cdo.getRefCode1());
		}else {
			model.addAttribute("gsBarcodeYn", "N");
		}

		List<CodeDetailVO> gsItemStatusType = codeInfo.getCodeList("S160", "", false);	//양품구분 기본값
		for(CodeDetailVO map : gsItemStatusType)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsItemStatusType", map.getCodeNo());
			}
		}
		//20210331 추가: 사이트 구분 운영코드(B259) 가져오는 로직 추가
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
		return JSP_PATH + "str110ukrv";
	}

	@RequestMapping(value = "/sales/str120ukrv.do")
	public String str120ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("S012", "5");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());				//Y:입고번호

		List<CodeDetailVO> gsMoneyUnit = codeInfo.getCodeList("B004", "", false);					//자국화폐단위 정보
		for(CodeDetailVO map : gsMoneyUnit)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsMoneyUnit", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsInspecFlag = codeInfo.getCodeList("Q004", "", false);
		for(CodeDetailVO map : gsInspecFlag){
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsInspecFlag", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "D");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSumTypeCell",cdo.getRefCode1());			//Y:창고Cell 합산


		//Lot 연계여부 조회
		cdo = codeInfo.getCodeInfo("B090", "SC");
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("mngLot",cdo.getRefCode1());
			model.addAttribute("essYn",cdo.getRefCode2());
			model.addAttribute("essAccount",cdo.getRefCode3());
		}

		List<CodeDetailVO> inoutPrsn = codeInfo.getCodeList("B024");
		if(!ObjUtils.isEmpty(inoutPrsn))	model.addAttribute("inoutPrsn",ObjUtils.toJsonStr(inoutPrsn));

		List<Map<String, Object>> gsWkShopDivCode = str120ukrvService.getWkShopDivCode(param);	//작업장의 사업장 조회
		model.addAttribute("gsWkShopDivCode",ObjUtils.toJsonStr(gsWkShopDivCode));

//		Map<String, Object> comboParam = new HashMap<String, Object>();
//		comboParam.put("COMP_CODE", loginVO.getCompCode());
//		comboParam.put("TYPE", "BSA225T");
//		model.addAttribute("WH_CELL",  salesCommonService.fnRecordCombo(comboParam, session));







		/*


		cdo = codeInfo.getCodeInfo("S026", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCreditYn",cdo.getRefCode1());	//Y:여신잔액(txtRemainCredit) visible

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
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSrq100UkrLink",	cdo.getCodeName());				//출하지시등록 링크 PGM ID

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
				model.addAttribute("gsDraftFlag", map.getCodeNo());					//Y:수주승인관련 필드 visible
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
		*/
		return JSP_PATH + "str120ukrv";
	}

	/**
	 * 입고현황조회(집계) (str303skrv) - 20191010 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str303skrv.do")
	public String str303skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "str303skrv";
	}

	@RequestMapping(value = "/sales/str310skrv.do")
	public String str310skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "str310skrv";
	}

	@RequestMapping(value = "/sales/str320skrv.do")
	public String str320skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "str320skrv";
	}

	@RequestMapping(value = "/sales/str410skrv.do")
	public String str410skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "str410skrv";
	}

	@RequestMapping(value = "/sales/str410ukrv.do")
	public String str410ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		int i = 0;
		List<CodeDetailVO> gsOptQ = codeInfo.getCodeList("S053", "", false);	//수량단위구분
		for(CodeDetailVO map : gsOptQ)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptQ", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptQ", "1");

		i = 0;
		List<CodeDetailVO> gsOptP = codeInfo.getCodeList("S054", "", false);	//단가금액출력여부
		for(CodeDetailVO map : gsOptP)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptP", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptP", "1");

		List<Map<String, Object>> gsBillYN = str410ukrvService.getGsBillYN(param);	//연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		if(ObjUtils.isEmpty(gsBillYN)){
			gsBillYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("REF_CODE4", "NAME");		//품목표시컬럼설정
			map.put("REF_CODE5", "N");		//품명수정여부
			map.put("REF_CODE6", "N");		//출력여부
			map.put("REF_CODE7", "");		//출력파일명
			map.put("REF_CODE8", "8");		//페이지내 최대건수
			map.put("REF_CODE9", "N");		//합계표시여부
			gsBillYN.add(map);
		}
		model.addAttribute("gsBillYN",ObjUtils.toJsonStr(gsBillYN));

		return JSP_PATH + "str410ukrv";
	}

	@RequestMapping(value = "/sales/str411ukrv.do")
	public String str411ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S037", "5");	//링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsStr411UkrLink", cdo.getRefCode1());
		}else {
			model.addAttribute("gsStr411UkrLink", "ssa560Ukrv");
		}

		int i = 0;
		List<CodeDetailVO> gsOptQ = codeInfo.getCodeList("S053", "", false);	//수량단위구분
		for(CodeDetailVO map : gsOptQ)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptQ", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptQ", "1");

		List<Map<String, Object>> gsBillYN = str411ukrvService.getGsBillYN(param);	//연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		if(ObjUtils.isEmpty(gsBillYN)){
			gsBillYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("SUB_CODE"	, "02");	//01센드빌 02웹캐시
			map.put("REF_CODE4"	, "NAME");	//품목표시컬럼설정
			map.put("REF_CODE5"	, "N");		//품명수정여부
			map.put("REF_CODE6"	, "N");		//출력여부
			map.put("REF_CODE7"	, "");		//출력파일명
			map.put("REF_CODE8"	, "8");		//페이지내 최대건수
			map.put("REF_CODE9"	, "N");		//합계표시여부
			gsBillYN.add(map);
		}
		model.addAttribute("gsBillYN", ObjUtils.toJsonStr(gsBillYN));

		return JSP_PATH + "str411ukrv";
	}

	@RequestMapping(value = "/sales/str412ukrv.do")
	public String str412ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S037", "5");	//링크프로그램정보(개별세금계산서등록)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsStr100UkrLink",cdo.getRefCode1());
		}else {
			model.addAttribute("gsStr100UkrLink", "ssa560Ukrv");
		}

		int i = 0;
		List<CodeDetailVO> gsOptQ = codeInfo.getCodeList("S053", "", false);	//수량단위구분
		for(CodeDetailVO map : gsOptQ)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptQ", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptQ", "1");


		List<Map<String, Object>> gsBillYN = str412ukrvService.getGsBillYN(param);	//연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		if(ObjUtils.isEmpty(gsBillYN)){
			gsBillYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("SUB_CODE", "01");		//01센드빌 02웹캐시
			map.put("REF_CODE4", "NAME");	//품목표시컬럼설정
			map.put("REF_CODE5", "N");		//품명수정여부
			map.put("REF_CODE6", "N");		//출력여부
			map.put("REF_CODE7", "");		//출력파일명
			map.put("REF_CODE8", "8");		//페이지내 최대건수
			map.put("REF_CODE9", "N");		//합계표시여부
			gsBillYN.add(map);
		}
		model.addAttribute("gsBillYN",ObjUtils.toJsonStr(gsBillYN));

		return JSP_PATH + "str412ukrv";
	}

	@RequestMapping(value = "/sales/str400skrv.do")
	public String str401skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "str400skrv";
	}

	@RequestMapping(value = "/sales/str400rkrv.do")
	public String str400rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "str400rkrv";
	}




	/** 박스포장 등록(str800ukrv)
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str800ukrv.do")
	public String str800ukrv (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		//20181127 추가: 라벨출력을 위해 LOT 이니셜 확인
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsLotInitail = codeInfo.getCodeList("Z011", "", false);
		for(CodeDetailVO map : gsLotInitail)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsLotInitail", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("str800ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "str800ukrv";
	}

	/** 박스포장 조회(str800skrv)
	 *
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/str800skrv.do")
	public String str800skrv (String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//20181127 추가: 라벨출력을 위해 LOT 이니셜 확인
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsLotInitail = codeInfo.getCodeList("Z011", "", false);
		for(CodeDetailVO map : gsLotInitail)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsLotInitail", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("str800skrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "str800skrv";
	}

    @RequestMapping( value = "/sales/str500skrv.do", method = RequestMethod.GET )
    public String str500skrv() throws Exception {
        return JSP_PATH + "str500skrv";
    }

    @RequestMapping(value = "/sales/str107ukrv.do")
	public String str107ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		//20200303 추가: 사이트 구분 운영코드(B259) 가져오는 로직 추가
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

		cdo = codeInfo.getCodeInfo("S176", "Y");	//운송관리여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsDvryYn",cdo.getRefCode1());
		}
		return JSP_PATH + "str107ukrv";
	}

    @RequestMapping(value = "/sales/str413skrv.do")
	public String str413skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		int i = 0;
		List<CodeDetailVO> gsOptQ = codeInfo.getCodeList("S053", "", false);	//수량단위구분
		for(CodeDetailVO map : gsOptQ)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptQ", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptQ", "1");

		i = 0;
		List<CodeDetailVO> gsOptP = codeInfo.getCodeList("S054", "", false);	//단가금액출력여부
		for(CodeDetailVO map : gsOptP)	{
			if("Y".equals(map.getRefCode1())){
				model.addAttribute("gsOptP", map.getCodeNo());
				i++;
			}
		}
		if(i == 0) model.addAttribute("gsOptP", "1");

		List<Map<String, Object>> gsBillYN = str410ukrvService.getGsBillYN(param);	//연계시스템 및 품명수정여부, 출력여부, 출력파일명 조회
		if(ObjUtils.isEmpty(gsBillYN)){
			gsBillYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("REF_CODE4", "NAME");		//품목표시컬럼설정
			map.put("REF_CODE5", "N");		//품명수정여부
			map.put("REF_CODE6", "N");		//출력여부
			map.put("REF_CODE7", "");		//출력파일명
			map.put("REF_CODE8", "8");		//페이지내 최대건수
			map.put("REF_CODE9", "N");		//합계표시여부
			gsBillYN.add(map);
		}
		model.addAttribute("gsBillYN",ObjUtils.toJsonStr(gsBillYN));

		return JSP_PATH + "str413skrv";
	}
    
    @RequestMapping(value = "/sales/str414skrv.do")
	public String str414skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "str414skrv";
	}
}