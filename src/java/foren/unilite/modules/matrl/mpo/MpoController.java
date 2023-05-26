package foren.unilite.modules.matrl.mpo;

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
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class MpoController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/matrl/mpo/";
	public final static String FILE_TYPE_OF_PHOTO = "stampPhoto";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="mpo130skrvService")
	private Mpo130skrvServiceImpl mpo130skrvService;

	@Resource(name="mpo150skrvService")
	private Mpo150skrvServiceImpl mpo150skrvService;

	@Resource(name="mpo080ukrvService")
	private Mpo080ukrvServiceImpl mpo080ukrvService;

	@Resource(name="mpo250skrvService")
	private Mpo250skrvServiceImpl mpo250skrvService;

	@Resource(name="mpo090ukrvService")
	private Mpo090ukrvServiceImpl mpo090ukrvService;

	@RequestMapping(value = "/matrl/mpo050ukrv.do")
	public String mpo050ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mpo050ukrv";
	}

	@RequestMapping(value = "/matrl/mpo070ukrv.do")
	public String mpo070ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "mpo070ukrv";
	}

	/**
	 * 20190213 신규
	 * 구매요청등록(생산계획)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo080ukrv.do")
	public String mpo080ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "mpo080ukrv";
	}

	@ResponseBody
	@RequestMapping(value = "/matrl/mpo080ExcelDown.do")
	public ModelAndView mpo080DownLoadExcel(ExtHtttprequestParam _req, HttpServletResponse response) throws Exception{
		Map<String, Object> paramMap = _req.getParameterMap();
		Workbook wb = mpo080ukrvService.makeExcel(paramMap);
		String title = "소요량내역(여러건)";

		return ViewHelper.getExcelDownloadView(wb, title);
	}

	/**
	 * 20190529 신규
	 * 구매요청등록(수주정보)
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo090ukrv.do")
	public String mpo090ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ORDER_WEEK", mpo090ukrvService.getOrderWeek(param));

		return JSP_PATH + "mpo090ukrv";
	}
	@RequestMapping(value = "/matrl/mpo130skrv.do")
	public String mpo130skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<CodeDetailVO> gsOrderPrsn = codeInfo.getCodeList("M201", "", false);	//구매담당 정보 조회
		model.addAttribute("gsOrderPrsn", "");
		for(CodeDetailVO map : gsOrderPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode4()))	{
				model.addAttribute("gsOrderPrsn", map.getCodeNo());
			}
		}

		//LINK PG 정보 가져오기
		param.put("PGM_ID", "mpo130skrv");
		List<Map<String, Object>> linkPgmInfo = mpo130skrvService.getLinkList(param);	//구매담당 정보 조회
		model.addAttribute("gslinkPgmInfo", ObjUtils.toJsonStr(linkPgmInfo));

		return JSP_PATH + "mpo130skrv";
	}

	@RequestMapping(value = "/matrl/mpo133skrv.do")
	public String mpo133skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mpo133skrv";
	}

	@RequestMapping(value = "/matrl/mpo135skrv.do")
	public String mpo135skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mpo135skrv";
	}


	@RequestMapping(value = "/matrl/mpo136skrv.do")
	public String mpo136skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mpo136skrv";
	}

	@RequestMapping(value = "/matrl/mpo140skrv.do")
	public String mpo140skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mpo140skrv";
	}

	/**
	 * 미입고사유등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo140ukrv.do", method = RequestMethod.GET)
	public String mpo140ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "mpo140ukrv";
	}

	/**
	 * 협력사납품등록현황 조회 (mpo260skrv) - 20200122 신규 등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo260skrv.do")
	public String mpo260skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

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
		return JSP_PATH + "mpo260skrv";
	}

	@RequestMapping(value = "/matrl/mpo320skrv.do")
	public String mpo320skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mpo320skrv";
	}

	@RequestMapping(value = "/matrl/mpo350ukrv.do")
	public String mpo350ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "mpo350ukrv";
}


	@RequestMapping(value = "/matrl/mpo150skrv.do")
	public String mpo150skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		//발주서 메일 미승인건 전송 여부(M507): 전송(Y)/미전송(N)
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = codeInfo.getCodeInfo("M507", "1");
		if(!ObjUtils.isEmpty(cdo) && !ObjUtils.isEmpty(cdo.getRefCode1())){
			model.addAttribute("gsAgreeStatusSendYN", cdo.getRefCode1());
		}else {
			model.addAttribute("gsAgreeStatusSendYN", 'N');
		}

		//발주서메일 로그인 유저정보 사용여부(M508): 사용(Y)/미사용(N)
		cdo = codeInfo.getCodeInfo("M508", "1");
		if(!ObjUtils.isEmpty(cdo) && ("Y".equals(cdo.getRefCode1()) || "y".equals(cdo.getRefCode1()))) {
			//보내는 사람 주소(BSA300T에서 가져올 경우)
			param.put("S_USER_ID",loginVO.getUserID());
			Map<String, Object> loginUserMailInfo = (Map<String, Object>) mpo150skrvService.getLoginUserMailInfo(param);	//사용자명,메일주소,메일 비밀번호 가져오기

			if(!ObjUtils.isEmpty(loginUserMailInfo) && !ObjUtils.isEmpty(loginUserMailInfo.get("EMAIL_ADDR"))) {
				model.addAttribute("gsUserId"	,loginUserMailInfo.get("USER_NAME"));
				model.addAttribute("gsMailAddr"	,loginUserMailInfo.get("EMAIL_ADDR"));

			} else {
				//발주서 메일: 로그인 유저정보에 email 주소가 없을 경우, BSA100T (M416)에서 가져온다
				Map<String, Object> mailInfo = (Map<String, Object>) mpo150skrvService.getUserMailInfo(param);	//사용자명,메일주소,메일 비밀번호 가져오기
				model.addAttribute("gsUserId"	,mailInfo.get("USER_NAME"));
				model.addAttribute("gsMailAddr"	,mailInfo.get("EMAIL_ADDR"));
				model.addAttribute("gsMailPass"	,mailInfo.get("EMAIL_PASS"));
			}

		} else {
			//발주서 메일: 보내는 사람 주소(BSA100T (M416)에서 가져올 경우)
			Map<String, Object> mailInfo = (Map<String, Object>) mpo150skrvService.getUserMailInfo(param);	//사용자명,메일주소,메일 비밀번호 가져오기
			model.addAttribute("gsUserId"	,mailInfo.get("USER_NAME"));
			model.addAttribute("gsMailAddr"	,mailInfo.get("EMAIL_ADDR"));
			model.addAttribute("gsMailPass"	,mailInfo.get("EMAIL_PASS"));
		}

		int siteFormChk = mpo150skrvService.getCustomFormYn(param);	//발주서 메일 사이트 양식 사용여부 가져오기
		if(siteFormChk > 0){
			model.addAttribute("gsCustomFormYn"	,"Y");
		}else{
			model.addAttribute("gsCustomFormYn"	,"N");
		}

		cdo = codeInfo.getCodeInfo("M516", "1");	//추가항목 필드셋
		if(ObjUtils.isNotEmpty(cdo)){
			if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				model.addAttribute("gsPurchaseMailForm", "./PurchaseForm_" + cdo.getCodeName().toUpperCase() + ".jsp");
			}else{
				model.addAttribute("gsPurchaseMailForm", "./PurchaseForm_STANDARD.jsp");
			}
		}else {
			model.addAttribute("gsPurchaseMailForm", "./PurchaseForm_STANDARD.jsp");
		}

		//발송자 정보 가져오기(우선은 극동이지만 추후 다른 곳도 활용가능)
		Map<String, Object> mailInfoFromNm = (Map<String, Object>) mpo150skrvService.getUserMailInfo(param);	//사용자명,메일주소,메일 비밀번호 가져오기
		model.addAttribute("gsFromName"		,mailInfoFromNm.get("FROM_NAME"));
		model.addAttribute("gsFromNameEng"	,mailInfoFromNm.get("FROM_NAME_ENG"));

		return JSP_PATH + "mpo150skrv";
}


	@RequestMapping(value = "/matrl/mpo210skrv.do")
	public String mpo210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		return JSP_PATH + "mpo210skrv";
	}

	@RequestMapping(value = "/matrl/mpo150rkrv.do")
	public String mpo150rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("mpo150rkrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "mpo150rkrv";
}

	/**
	 * 긴급발주등록(SP)
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo501ukrp1v.do",method = RequestMethod.GET)
	public String mpo501ukrp1v( LoginVO loginVO, ModelMap model) throws Exception {
		return JSP_PATH + "mpo501ukrp1v";
	}


	@RequestMapping(value = "/matrl/mpo501ukrv.do",method = RequestMethod.GET)
	public String mpo501ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsOrderPrsn = codeInfo.getCodeList("M201", "", false);	//구매담당 정보 조회
		model.addAttribute("gsOrderPrsn", "");
		model.addAttribute("gsOrderPrsnYN", "N");
		for(CodeDetailVO map : gsOrderPrsn)	{

			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode4())) 	{
				model.addAttribute("gsOrderPrsn", map.getCodeNo());
				model.addAttribute("gsOrderPrsnYN", "Y");
			}
		}

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//화폐단위(기본화폐단위설정
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);		//발주승인 방식
		for(CodeDetailVO map : gsApproveYN)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsApproveYN", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());   //재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("M101", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

		cdo = codeInfo.getCodeInfo("M506", "1");	//발주등록에서 재고단위와 구매단위가 같들때도 입수 수정 가능 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsTrnsRateEdtYn",cdo.getRefCode1());
		}else {
			model.addAttribute("gsTrnsRateEdtYn", "N");
		}

		 List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
	 	for(CodeDetailVO map : gsReportGubun)	{
	 		if("mpo501ukrv".equals(map.getCodeName()))	{
	 			model.addAttribute("gsReportGubun", map.getRefCode10());

	 		}
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

		return JSP_PATH + "mpo501ukrv";
	}

	@RequestMapping(value = "/matrl/mpo502ukrv.do",method = RequestMethod.GET)
	public String mpo502ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("M030", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("mpo502ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		List<CodeDetailVO> gsOrderPrsn = codeInfo.getCodeList("M201", "", false);	//구매담당 정보 조회
		model.addAttribute("gsOrderPrsn", "");
		model.addAttribute("gsOrderPrsnYN", "N");
		for(CodeDetailVO map : gsOrderPrsn)	{

			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode4())) 	{
				model.addAttribute("gsOrderPrsn", map.getCodeNo());
				model.addAttribute("gsOrderPrsnYN", "Y");
			}
		}

		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//화폐단위(기본화폐단위설정
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);		//발주승인 방식
		for(CodeDetailVO map : gsApproveYN)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsApproveYN", map.getCodeNo());
				model.addAttribute("gsM008Ref3", map.getRefCode3());
			}
		}

		cdo = codeInfo.getCodeInfo("B084", "C");
		if(!ObjUtils.isEmpty(cdo))  model.addAttribute("gsSumTypeLot",cdo.getRefCode1());   //재고합산유형:Lot No. 합산

		cdo = codeInfo.getCodeInfo("M101", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoType",cdo.getRefCode1());

		List<CodeDetailVO> gsCusomItemYn = codeInfo.getCodeList("B911", "", false);		//품목팝업 거래처단가에 등록된 것만 가져오도록 설정 여부
		for(CodeDetailVO map : gsCusomItemYn)	{
			if("mpo502ukrv".equals(map.getCodeName()))	{
				model.addAttribute("gsCusomItemYn", map.getRefCode1());
			}
		}

		cdo = codeInfo.getCodeInfo("Q034", "Y"); //불량반품 재접수 가능여부
		if(cdo.getRefCode1().toUpperCase().equals("Y")){
			model.addAttribute("gsBadReceiveYn", 'Y');
		}else{
			model.addAttribute("gsBadReceiveYn", 'N');
		}

		return JSP_PATH + "mpo502ukrv";
	}

	/**
	 * 발주승인등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo120ukrv.do",method = RequestMethod.GET)
	public String mpo120ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");


		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("M024", "3");
		if(!ObjUtils.isEmpty(cdo))	{
			model.addAttribute("gsLinkedPgmID",	cdo.getCodeName());		//링크프로그램정보
		}else{
			model.addAttribute("gsLinkedPgmID",	"mpo501ukrv");
		}


		List<CodeDetailVO> gsDefaultMoney = codeInfo.getCodeList("B004", "", false);		//화폐단위(기본화폐단위설정
		for(CodeDetailVO map : gsDefaultMoney)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsDefaultMoney", map.getCodeNo());
			}
		}

		return JSP_PATH + "mpo120ukrv";
	}

	@RequestMapping(value = "/matrl/mpo060ukrv.do",method = RequestMethod.GET)
	public String mpo060ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<CodeDetailVO> gsOrderPrsn = codeInfo.getCodeList("M201", "", false);	//구매담당 정보 조회
		model.addAttribute("gsOrderPrsn", "");
		model.addAttribute("gsOrderPrsnYN", "N");
		for(CodeDetailVO map : gsOrderPrsn)	{

			if(loginVO.getUserID().equals(map.getRefCode2()) && loginVO.getDivCode().equals(map.getRefCode4()))	{
				model.addAttribute("gsOrderPrsn", map.getCodeNo());
				model.addAttribute("gsOrderPrsnYN", "Y");
			}
		}

		return JSP_PATH + "mpo060ukrv";
	}

	@RequestMapping(value = "/matrl/mpo200ukrv.do",method = RequestMethod.GET)
	public String mpo200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);	   //발주승인 방식
		for(CodeDetailVO map : gsApproveYN) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
				model.addAttribute("gsApproveYN", map.getCodeNo());
			}
		}

		List<CodeDetailVO> gsExchgRegYNList = codeInfo.getCodeList("B081", "", false);	   //대체품목 등록여부
		for(CodeDetailVO map : gsExchgRegYNList) {
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))  {
				model.addAttribute("gsExchgRegYN", map.getCodeNo());
			}else{
				model.addAttribute("gsExchgRegYN", "N");
			}
		}
		return JSP_PATH + "mpo200ukrv";
	}

	@RequestMapping(value = "/matrl/mpo201ukrv.do",method = RequestMethod.GET)
	public String mpo201ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		List<CodeDetailVO> gsApproveYN = codeInfo.getCodeList("M008", "", false);		//발주승인 방식
		for(CodeDetailVO map : gsApproveYN)	{
			if("Y".equals(map.getRefCode1()) || "y".equals(map.getRefCode1()))	{
				model.addAttribute("gsApproveYN", map.getCodeNo());
			}
		}

		return JSP_PATH + "mpo201ukrv";
	}

	@RequestMapping(value = "/matrl/mpo030ukrv.do")
	public String mpo030ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "mpo030ukrv";
	}

	@RequestMapping(value = "/matrl/mpo220skrv.do",method = RequestMethod.GET)
	public String mpo220skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "mpo220skrv";
	}

	@RequestMapping(value = "/matrl/mpo230skrv.do",method = RequestMethod.GET)
	public String mpo230skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "mpo230skrv";
	}

	@RequestMapping(value = "/matrl/mpo240skrv.do",method = RequestMethod.GET)
	public String mpo240skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "mpo240skrv";
	}

	@RequestMapping(value = "/matrl/mpo170skrv.do",method = RequestMethod.GET)
	public String mpo170skrv(ExtHtttprequestParam _req,  LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception{
		return JSP_PATH + "mpo170skrv";
	}

	@RequestMapping(value = "/matrl/mpo131skrv.do")
	public String mpo131skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "mpo131skrv";
	}
	@RequestMapping(value = "/matrl/mpo132skrv.do")
	public String mpo132skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "mpo132skrv";
	}
	@RequestMapping(value = "/matrl/mpo250skrv.do")
	public String mpo250skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		model.addAttribute("COMBO_ORDER_WEEK", mpo250skrvService.getOrderWeek(param));


		return JSP_PATH + "mpo250skrv";
	}
	/**
	 * 입고라벨출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo152rkrv.do")
	public String mpo152rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "mpo152rkrv";
	}
	@RequestMapping(value = "/matrl/mpo151rkrv.do")
	public String mpo151skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "mpo151rkrv";
	}
	
	/**
	 * 구매대장등록
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo310ukrv.do")
	public String mpo310ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "mpo310ukrv";
	}
	
	
	
	/**
	 * 발주납기변경 등록 --20210428 신규
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/mpo340ukrv.do")
	public String mpo340ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "mpo340ukrv";
	}
}