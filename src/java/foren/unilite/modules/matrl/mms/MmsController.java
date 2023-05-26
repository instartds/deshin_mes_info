package foren.unilite.modules.matrl.mms;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.stock.qba.Qba120ukrvServiceImpl;

@Controller
public class MmsController extends UniliteCommonController {
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH	= "/matrl/mms/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="qba120ukrvService")
	private Qba120ukrvServiceImpl qba120ukrvService;

	@Resource(name="mms130ukrvService")
	private Mms130ukrvServiceImpl mms130ukrvService;

	@Resource(name="mms230skrvService")				//20210805 추가: 검사방식, 불량유형 가져오기 위해 추가
	private Mms230skrvServiceImpl mms230skrvService;

	

	@RequestMapping(value = "/matrl/mms100skrv.do")
	public String mms100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mms100skrv";
	}

	@RequestMapping(value = "/matrl/mms101skrv.do")
	public String mms101skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mms101skrv";
	}

	@RequestMapping(value = "/matrl/mms102skrv.do")
	public String mms102skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mms102skrv";
	}

	@RequestMapping(value = "/matrl/mms200skrv.do")
	public String mms200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "mms200skrv";
	}


	/**
	 * 수입검사현황II (mms230skrv) - 20210805 신규 생성
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mms230skrv.do")
	public String mms230skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields	= {  };
		NavigatorInfo navigator		= new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session				= _req.getSession();
		Map<String, Object> param	= navigator.getParam();
		String page					= _req.getP("page");
		param.put("S_COMP_CODE", loginVO.getCompCode());
		CodeInfo codeInfo			= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo			= null;

		cdo = codeInfo.getCodeInfo("B259", "1");	//사이트 구분 운영코드
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			}else{
				model.addAttribute("gsSiteCode", "STANDARD");
			}
		} else {
			model.addAttribute("gsSiteCode", "STANDARD");
		}

		Gson gson = new Gson();
		//동적 그리드 구현(공통코드(Q005)에서 컬럼 가져오는 로직)
		String colData	= gson.toJson(mms230skrvService.selectQ005(loginVO));
		model.addAttribute("colData", colData);

		//동적 그리드 구현(공통코드(Q014)에서 컬럼 가져오는 로직)
		String colData4	= gson.toJson(mms230skrvService.selectQ014(loginVO));
		model.addAttribute("colData4", colData4);

		return JSP_PATH + "mms230skrv";
	}

	@RequestMapping(value = "/matrl/mms300skrv.do")
	public String mms300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsReceiptPrsn = codeInfo.getCodeList("Q021", "", false);	//접수담당 정보 조회
		for(CodeDetailVO map : gsReceiptPrsn)	{

			if(loginVO.getUserID().equals(map.getRefCode2()))	{
				model.addAttribute("gsReceiptPrsn", map.getCodeNo());
			}
		}

		return JSP_PATH + "mms300skrv";
	}

	@RequestMapping(value = "/matrl/mms300ukrv.do")
	public String mms300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsReceiptPrsn = codeInfo.getCodeList("Q021", "", false);	//접수담당 정보 조회
		for(CodeDetailVO map : gsReceiptPrsn)	{

			if(loginVO.getUserID().equals(map.getRefCode2()))	{
				model.addAttribute("gsReceiptPrsn", map.getCodeNo());
			}
		}
		return JSP_PATH + "mms300ukrv";
	}

@RequestMapping(value = "/matrl/mms201ukrv.do")
	public String mms201ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mms201ukrv";
	}



@RequestMapping(value = "/matrl/mms550ukrv.do")
public String mms550ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	return JSP_PATH + "mms550ukrv";
}



/**
 * 입고등록(예외입고)
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms501ukrp1v.do",method = RequestMethod.GET)
public String mms501ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
	return JSP_PATH + "mms501ukrp1v";
}


@RequestMapping(value = "/matrl/mms501ukrv.do",method = RequestMethod.GET)
public String mms501ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	param.put("S_COMP_CODE",loginVO.getCompCode());
	model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;

	List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);		//입고유형
	for(CodeDetailVO map : gsInoutTypeDetail)	{
			model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
	}
/*
	List<CodeDetailVO> gsInTypeAccountYN = codeInfo.getCodeList("M103", "", false);
    List<Map<String, Object>>  listInTypeAccountYN = new ArrayList<Map<String, Object>>();
	for(CodeDetailVO map : gsInTypeAccountYN)	{
		Map<String, Object> aMap = new HashMap<String, Object>();
		aMap.put("IN_TYPE_CODE", map.getCodeNo());
		aMap.put("IN_TYPE_NAME", map.getCodeName());
		aMap.put("ACCOUNT_YN", map.getRefCode4());
		listInTypeAccountYN.add(aMap);

		//model.addAttribute("gsInTypeCode", map.getCodeNo());

	}

	model.addAttribute("gsInTypeAccountYN", listInTypeAccountYN);
	*/

	List<CodeDetailVO> cdList = codeInfo.getCodeList("M103");	//기표대상여부관련
	if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));


	cdo = codeInfo.getCodeInfo("M102", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());	//과입고허용률

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
	return JSP_PATH + "mms501ukrv";
}



@RequestMapping(value = "/matrl/mms502ukrv.do")
public String mms502ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

	return JSP_PATH + "mms502ukrv";
}

/**
 * 접수등록(통합)
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms110ukrp1v.do",method = RequestMethod.GET)
public String mms110ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
	return JSP_PATH + "mms110ukrp1v";
}


@RequestMapping(value = "/matrl/mms110ukrv.do",method = RequestMethod.GET)
public String mms110ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;

	cdo = codeInfo.getCodeInfo("M415", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("glPerCent",cdo.getRefCode1());	//발주량 대비 접수율

	List<CodeDetailVO> gsReceiptPrsn = codeInfo.getCodeList("Q021", "", false);	//접수담당 정보 조회
	model.addAttribute("gsReceiptPrsn", "");
	for(CodeDetailVO map : gsReceiptPrsn)	{
		if(loginVO.getUserID().equals(map.getRefCode3()))	{//refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
			model.addAttribute("gsReceiptPrsn", map.getCodeNo());
		}
	}

	List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
	for(CodeDetailVO map : gsReportGubun)	{
		if("mms110ukrv".equals(map.getCodeName()))	{
			model.addAttribute("gsReportGubun", map.getRefCode10());
		}
	}

	cdo = codeInfo.getCodeInfo("M510", "Y");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVmiReferYn",cdo.getRefCode2());	//vmi(거래처납품등록확정참조)

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
	return JSP_PATH + "mms110ukrv";
}

/**
 * 접수(가입고)등록(무상포함)
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */

@RequestMapping(value = "/matrl/mms100ukrv.do",method = RequestMethod.GET)
public String mms100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;

	cdo = codeInfo.getCodeInfo("M415", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("glPerCent",cdo.getRefCode1());	//발주량 대비 접수율

	List<CodeDetailVO> gsReceiptPrsn = codeInfo.getCodeList("Q021", "", false);	//접수담당 정보 조회
	model.addAttribute("gsReceiptPrsn", "");
	for(CodeDetailVO map : gsReceiptPrsn)	{
		if(loginVO.getUserID().equals(map.getRefCode3()))	{//refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
			model.addAttribute("gsReceiptPrsn", map.getCodeNo());
		}
	}

	List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
	for(CodeDetailVO map : gsReportGubun)	{
		if("mms100ukrv".equals(map.getCodeName()))	{
			model.addAttribute("gsReportGubun", map.getRefCode10());
		}
	}

	cdo = codeInfo.getCodeInfo("M510", "Y");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVmiReferYn",cdo.getRefCode2());	//vmi(거래처납품등록확정참조)

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
	return JSP_PATH + "mms100ukrv";
}
/**
 * 입고등록(SP+통합)
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms510ukrp1v.do",method = RequestMethod.GET)
public String mms510ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
	return JSP_PATH + "mms510ukrp1v";
}


@RequestMapping(value = "/matrl/mms510ukrv.do",method = RequestMethod.GET)
public String mms510ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
/*
	List<CodeDetailVO> cdList = codeInfo.getCodeList("M103");	//기표대상여부관련
	if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));*/

	cdo = codeInfo.getCodeInfo("M103", "20");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInoutType",cdo.getRefCode4());	//기표대상여부관련

	cdo = codeInfo.getCodeInfo("M102", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());	//과입고허용률\

	cdo = codeInfo.getCodeInfo("B022", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리

	cdo = codeInfo.getCodeInfo("M518", "Y");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCalculate",cdo.getRefCode1());	//구매입고시 단가 재계산 여부

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

	List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
    for(CodeDetailVO map : gsGwYn) {
        if("Y".equals(map.getRefCode1()))   {
            model.addAttribute("gsGwYn", map.getCodeNo());
        }
    }

	cdo = codeInfo.getCodeInfo("B090", "OA");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

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

	List<CodeDetailVO> gsExchangeRate = codeInfo.getCodeList("T124", "", false);//입고환율적용시점
    for(CodeDetailVO map : gsExchangeRate) {
        if("Y".equals(map.getRefCode1()))   {
            model.addAttribute("gsExchangeRate", map.getCodeNo());
        }
    }

	List<CodeDetailVO> gaItemAccnt = codeInfo.getCodeList("B020", "", false);		//품목계정
	String gsItemAccnt = "";
	for(CodeDetailVO map : gaItemAccnt)	{
		if(!"10".equals(ObjUtils.nvl(map.getRefCode3(), "")) && !"20".equals(ObjUtils.nvl(map.getRefCode3(), ""))) {
			if(gsItemAccnt.length() < 1) {
				gsItemAccnt = map.getCodeNo().toString();
			}
			else {
				gsItemAccnt += "," + map.getCodeNo().toString();
			}
		}
	}
	model.addAttribute("gsItemAccnt", gsItemAccnt);

	return JSP_PATH + "mms510ukrv";
}

@RequestMapping(value = "/matrl/mms512ukrv.do",method = RequestMethod.GET)
public String mms512ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
/*
	List<CodeDetailVO> cdList = codeInfo.getCodeList("M103");	//기표대상여부관련
	if(!ObjUtils.isEmpty(cdList))	model.addAttribute("gsInTypeAccountYN",ObjUtils.toJsonStr(cdList));*/

	cdo = codeInfo.getCodeInfo("M103", "20");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInoutType",cdo.getRefCode4());	//기표대상여부관련

	cdo = codeInfo.getCodeInfo("M102", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsExcessRate",cdo.getRefCode1());	//과입고허용률\

	cdo = codeInfo.getCodeInfo("B022", "1");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsInvstatus",cdo.getRefCode1());	//재고상태관리

	cdo = codeInfo.getCodeInfo("M518", "Y");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsCalculate",cdo.getRefCode1());	//구매입고시 단가 재계산 여부

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

	List<CodeDetailVO> gsGwYn = codeInfo.getCodeList("B610", "", false);//그룹웨어 사용여부
    for(CodeDetailVO map : gsGwYn) {
        if("Y".equals(map.getRefCode1()))   {
            model.addAttribute("gsGwYn", map.getCodeNo());
        }
    }

	cdo = codeInfo.getCodeInfo("B090", "OA");
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsEssItemAccount",cdo.getRefCode3() == null || "".equals(cdo.getRefCode3())?"":cdo.getRefCode3());

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

	List<CodeDetailVO> gsExchangeRate = codeInfo.getCodeList("T124", "", false);//입고환율적용시점
    for(CodeDetailVO map : gsExchangeRate) {
        if("Y".equals(map.getRefCode1()))   {
            model.addAttribute("gsExchangeRate", map.getCodeNo());
        }
    }
	return JSP_PATH + "mms512ukrv";
}

/**
 * 입고등록(SP+통합)연세대용
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms511ukrp1v.do",method = RequestMethod.GET)
public String mms511ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
	return JSP_PATH + "mms511ukrp1v";
}


@RequestMapping(value = "/matrl/mms511ukrv.do",method = RequestMethod.GET)
public String mms511ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	param.put("S_COMP_CODE",loginVO.getCompCode());
	model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;

	List<CodeDetailVO> gsInoutTypeDetail = codeInfo.getCodeList("M103", "", false);		//입고유형
	for(CodeDetailVO map : gsInoutTypeDetail)	{
			model.addAttribute("gsInoutTypeDetail", map.getCodeNo());
	}
/*
	List<CodeDetailVO> gsInTypeAccountYN = codeInfo.getCodeList("M103", "", false);
    List<Map<String, Object>>  listInTypeAccountYN = new ArrayList<Map<String, Object>>();
	for(CodeDetailVO map : gsInTypeAccountYN)	{
		Map<String, Object> aMap = new HashMap<String, Object>();
		aMap.put("IN_TYPE_CODE", map.getCodeNo());
		aMap.put("IN_TYPE_NAME", map.getCodeName());
		aMap.put("ACCOUNT_YN", map.getRefCode4());
		listInTypeAccountYN.add(aMap);

		//model.addAttribute("gsInTypeCode", map.getCodeNo());

	}

	model.addAttribute("gsInTypeAccountYN", listInTypeAccountYN);
	*/
	List<CodeDetailVO> gsInOutPrsn = codeInfo.getCodeList("B024", "", false);	//입고담당 정보 조회
	for(CodeDetailVO map : gsInOutPrsn)	{
		if(/*loginVO.getUserID().equals(map.getRefCode2()) &&*/ loginVO.getDivCode().equals(map.getRefCode1()))	{
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

	return JSP_PATH + "mms511ukrv";
}


private Object getMin(String codeNo) {
	// TODO Auto-generated method stub
	return null;
}

private int Integer(String codeNo) {
	// TODO Auto-generated method stub
	return 0;
}

/**
 * 검사등록
 * @param loginVO
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms200ukrp1v.do",method = RequestMethod.GET)
public String mms200ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
	return JSP_PATH + "mms200ukrp1v";
}


@RequestMapping(value = "/matrl/mms200ukrv.do",method = RequestMethod.GET)

public String mms200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

	final String[] searchFields = {  };
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
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());


	List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
	for(CodeDetailVO map : gsReportGubun)	{
		if("mms200ukrv".equals(map.getCodeName()))	{
			model.addAttribute("gsReportGubun", map.getRefCode10());
		}
	}

	List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);		//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
	for(CodeDetailVO map : gsInspecPrsn)	{
		if(loginVO.getUserID().equals(map.getRefCode3()))	{
			model.addAttribute("gsInspecPrsn", map.getCodeNo());
		}
	}

	List<CodeDetailVO> gsSyTalkFlag = codeInfo.getCodeList("B265", "", false);		//시너지톡 발송 옵션
	for(CodeDetailVO map : gsSyTalkFlag)	{
		if("Y".equals(map.getRefCode1()))	{
			model.addAttribute("gsSyTalkFlag", map.getCodeNo());
		}
	}
//	cdo = codeInfo.getCodeInfo("B265", "Y");
//	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSyTalkYn",cdo.getRefCode1());	//LOT관리기준 설정

	return JSP_PATH + "mms200ukrv";
}

@RequestMapping(value = "/matrl/mms202ukrv.do",method = RequestMethod.GET)
public String mms202ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

	final String[] searchFields = {  };
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
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());

	model.addAttribute("COMBO_TEST_CODE", qba120ukrvService.getTestCode(param));



	List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);		//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
	for(CodeDetailVO map : gsInspecPrsn)	{
		if(loginVO.getUserID().equals(map.getRefCode3()))	{
			model.addAttribute("gsInspecPrsn", map.getCodeNo());
		}
	}
	return JSP_PATH + "mms202ukrv";
}

@RequestMapping(value = "/matrl/mms203ukrv.do",method = RequestMethod.GET)
public String mms203ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

	final String[] searchFields = {  };
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
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1() == null || "".equals(cdo.getRefCode1())?"N":cdo.getRefCode1());
	if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsLotNoEssential",cdo.getRefCode2() == null || "".equals(cdo.getRefCode2())?"N":cdo.getRefCode2());
	param.put("DIV_CODE",loginVO.getDivCode());
	model.addAttribute("COMBO_TEST_CODE", qba120ukrvService.getTestCode(param));



	List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("Q022", "", false);		//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
	for(CodeDetailVO map : gsInspecPrsn)	{
		if(loginVO.getUserID().equals(map.getRefCode3()))	{
			model.addAttribute("gsInspecPrsn", map.getCodeNo());
		}
	}
	return JSP_PATH + "mms203ukrv";
}

@RequestMapping(value = "/matrl/testskrv001.do")

public String testskrv001(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	param.put("S_COMP_CODE",loginVO.getCompCode());

	return JSP_PATH + "testskrv001";
}
@RequestMapping(value = "/matrl/mms200rkrv.do",method = RequestMethod.GET)
public String mms200rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	return JSP_PATH + "mms200rkrv";
}


/**
 * 검사결과서출력
 * @param _req
 * @param loginVO
 * @param listOp
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms210skrv.do")
public String mms210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	param.put("S_COMP_CODE",loginVO.getCompCode());

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
	for(CodeDetailVO map : gsReportGubun)	{
		if("mms210skrv".equals(map.getCodeName()))	{
			model.addAttribute("gsReportGubun", map.getRefCode10());
		}
	}

	return JSP_PATH + "mms210skrv";
}

/**
 * 미검사현황 (mms220skrv) - 20191218 신규 생성
 * @param _req
 * @param loginVO
 * @param listOp
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms220skrv.do")
public String mms220skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	param.put("S_COMP_CODE",loginVO.getCompCode());
//	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

	return JSP_PATH + "mms220skrv";
}

/**
 * 검사결과서출력
 * @param _req
 * @param loginVO
 * @param listOp
 * @param model
 * @return
 * @throws Exception
 */
@RequestMapping(value = "/matrl/mms120skrv.do")
public String mms120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	param.put("S_COMP_CODE",loginVO.getCompCode());

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
	for(CodeDetailVO map : gsReportGubun)	{
		if("mms110ukrv".equals(map.getCodeName()))	{
			model.addAttribute("gsReportGubun", map.getRefCode10());
		}
	}
	return JSP_PATH + "mms120skrv";
}

@RequestMapping(value = "/matrl/mms130ukrv.do")
public String mms130ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");
//	model.addAttribute("CSS_TYPE", "-largeEis");

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;

	return JSP_PATH + "mms130ukrv";
}

@RequestMapping(value = "/matrl/mms131ukrv.do")
public String mms131ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
	final String[] searchFields = {  };
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
	LoginVO session = _req.getSession();
	Map<String, Object> param = navigator.getParam();
	String page = _req.getP("page");

	CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
	CodeDetailVO cdo = null;

	return JSP_PATH + "mms131ukrv";
}
}