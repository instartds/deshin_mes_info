package foren.unilite.modules.prodt.pmr;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import foren.framework.dao.TlabAbstractDAO;
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
import foren.unilite.modules.human.hpa.Hpa950skrServiceImpl;

@Controller
public class PmrController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/prodt/pmr/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource( name = "pmr150skrvService" )
	private Pmr150skrvServiceImpl pmr150skrvService;

	@Resource( name = "pmr200ukrvService" )
	private Pmr200ukrvServiceImpl pmr200ukrvService;

	@Resource( name = "pmr350skrvService" )
	private Pmr350skrvServiceImpl pmr350skrvService;

	@Resource( name = "pmr355skrvService" )
	private Pmr355skrvServiceImpl pmr355skrvService;

	@Resource( name = "pmr360skrvService" )
	private Pmr360skrvServiceImpl pmr360skrvService;

	@Resource( name = "pmr100ukrvService" )
	private Pmr100ukrvServiceImpl pmr100ukrvService;

	@Resource(name = "tlabAbstractDAO")
    protected TlabAbstractDAO dao;

	@RequestMapping(value = "/prodt/pmr100skrv.do")
	public String pmr100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr100skrv";
	}

	/**
	 * 작업실적 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr100ukrv.do")
	public String pmr100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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
		cdo = codeInfo.getCodeInfo("P516", "1");	 										  // 생산작업시간(점심)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLunchFr",cdo.getRefCode1());
			model.addAttribute("gsLunchTo",cdo.getRefCode2());
		}else{
			model.addAttribute("gsLunchFr","12:00");
			model.addAttribute("gsLunchTo","13:00");
		}

		Gson gson = new Gson();
        String colData = gson.toJson(pmr100ukrvService.selectBadcodes(loginVO.getCompCode()));
        String colData2 = gson.toJson(pmr100ukrvService.selectBadcodeRemarks(loginVO.getCompCode()));
        model.addAttribute("colData", colData);
        model.addAttribute("colData2", colData2);

        String gsSiteCode = "STANDARD";
        cdo = codeInfo.getCodeInfo("B259", "1");    //사이트 구분 운영코드
		 if(ObjUtils.isNotEmpty(cdo)){
			 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				 gsSiteCode = cdo.getCodeName().toUpperCase();
				 model.addAttribute("gsSiteCode", cdo.getCodeName().toUpperCase());
			 }else{
			 	model.addAttribute("gsSiteCode", "STANDARD");
			 }
	     }else {
	            model.addAttribute("gsSiteCode", "STANDARD");
	     }

		 cdo = codeInfo.getCodeInfo("BS83", loginVO.getDivCode());    //작업실적데이터연동정보 (우선 본인 사업장에서 연동 여부와 본인 사업장의 연동 주소를 가져온다)
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

		if(gsSiteCode.equals("KODI")){ //코디인 경우
			//작업실적연동정보
			List<CodeDetailVO> gsMesSiteInfo = codeInfo.getCodeList("BS83", "",   false);
			for(CodeDetailVO map :   gsMesSiteInfo)	{				//코디의 경우 김천과 화성 두개의 사업장 주소가 모두 필요하다.
				if("01".equals(map.getCodeNo())) {
					model.addAttribute("gsIfSiteCode1", map.getRefCode2());
				}else if("02".equals(map.getCodeNo())){
					model.addAttribute("gsIfSiteCode2", map.getRefCode2());
				}
			}
			 cdo = codeInfo.getCodeInfo("BS82", loginVO.getDivCode());    //작업지시데이터연동정보
			 if(ObjUtils.isNotEmpty(cdo)){
				 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				 	model.addAttribute("gsIfCodePlan", cdo.getRefCode1().toUpperCase());
				 	model.addAttribute("gsIfSiteCodePlan", cdo.getRefCode2());
				 }else{
				 	model.addAttribute("gsIfCodePlan", "N");
				 	model.addAttribute("gsIfSiteCodePlan", "");
				 }
		     }else {
				 	model.addAttribute("gsIfCodePlan", "N");
				 	model.addAttribute("gsIfSiteCodePlan", "");
		     }
		}else{
			cdo = codeInfo.getCodeInfo("BS83", loginVO.getDivCode());    //작업실적데이터연동정보
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

			 cdo = codeInfo.getCodeInfo("BS82", loginVO.getDivCode());    //작업지시데이터연동정보
			 if(ObjUtils.isNotEmpty(cdo)){
				 if(ObjUtils.isNotEmpty(cdo.getCodeName())){
				 	model.addAttribute("gsIfCodePlan", cdo.getRefCode1().toUpperCase());
				 	model.addAttribute("gsIfSiteCodePlan", cdo.getRefCode2());
				 }else{
				 	model.addAttribute("gsIfCodePlan", "N");
				 	model.addAttribute("gsIfSiteCodePlan", "");
				 }
		     }else {
				 	model.addAttribute("gsIfCodePlan", "N");
				 	model.addAttribute("gsIfSiteCodePlan", "");
		     }
		}


		return JSP_PATH + "pmr100ukrv";
	}

	/**
	 * 생산자재 출고
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr200ukrv.do")
	public String pmr200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("B703", "03");	//선입선출(생산) 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}

		//출력(Report 종류 확인)
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "",   false);
		for(CodeDetailVO map :   gsReportGubun)	{
			if("pmr200ukrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "pmr200ukrv";
	}

	/**
	 * 생산입고자재검증
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr210ukrv.do")
	public String pmr210ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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



		return JSP_PATH + "pmr210ukrv";
	}

	/**
	 * 인원현황 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr800ukrv.do")
	public String pmr800ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {

		model.addAttribute("CSS_TYPE", "-large");  //화면크기조정(POP)

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
		model.addAttribute("COMBO_WP_LIST", comboService.getProgWork(param));

		/*List<ComboItemModel> wpList = comboService.getProgWork(param);
		if(!ObjUtils.isEmpty(wpList))	model.addAttribute("wpList",ObjUtils.toJsonStr(wpList));*/

		return JSP_PATH + "pmr800ukrv";
	}

	/**
	 * 작업일보 조회(작지별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr110skrv.do")
	public String pmr110skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr110skrv";
	}

	/**
	 * 작업일보 조회(공정별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr120skrv.do")
	public String pmr120skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr120skrv";
	}

	/**
	 * 작업월보 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr130skrv.do")
	public String pmr130skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr130skrv";
	}

	/**
	 * 제조이력 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr150skrv.do")
	public String pmr150skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE"	, loginVO.getCompCode());
		param.put("S_USER_ID"	, loginVO.getUserID());
		param.put("DIV_CODE"	, loginVO.getDivCode());

		return JSP_PATH + "pmr150skrv";
	}

	/**
	 * 재공현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr310skrv.do")
	public String pmr310skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr310skrv";
	}

	/**
	 * 불량현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr350skrv.do")
	public String pmr350skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		Gson gson = new Gson();
		String colData = gson.toJson(pmr350skrvService.selectColumns(loginVO));
		model.addAttribute("colData", colData);

		return JSP_PATH + "pmr350skrv";
	}
	/**
	 * 불량유형조회(통합)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr355skrv.do")
	public String pmr355skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		Gson gson = new Gson();
		String colData = gson.toJson(pmr355skrvService.selectColumns(loginVO));
		model.addAttribute("colData", colData);

		return JSP_PATH + "pmr355skrv";
	}
	/**
	 * 생산현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr200skrv.do")
	public String pmr200skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr200skrv";
	}

	/**
	 * 생산진척 현황 조회(품목별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr300skrv.do")
	public String pmr300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr300skrv";
	}

	/**
	 * 생산진척 현황 조회(수주별)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr320skrv.do")
	public String pmr320skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr320skrv";
	}

	/**
	 * 월생산실적 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr210skrv.do")
	public String pmr210skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pmr210skrv";
	}

	@RequestMapping(value = "/prodt/pmr140rkrv.do")
	public String pmr140rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pmr140rkrv";
	}

	/**
	 * 검수실적 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr400skrv.do")
	public String pmr400skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
//		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
//		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
//		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
//		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pmr400skrv";
	}

	@RequestMapping(value = "/prodt/pmr810skrv.do")
	public String pmr810skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "pmr810skrv";
	}

	@RequestMapping(value = "/prodt/pmr820skrv.do")
	public String pmr820skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		return JSP_PATH + "pmr820skrv";
	}


	/**
	 * 생산현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr200rkrv.do")
	public String pmr200rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "pmr200rkrv";
	}




	@RequestMapping(value = "/wkordIn", method = RequestMethod.GET)
	public void wkordIn(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();

		dao.insert("wkordininfoukrvServiceImpl.wkordIn", param);
	}

	/**
	 * 공정코드, ip, status 값 받는 용
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/wkordSts", method = RequestMethod.GET)
	public void wkordSts(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();

		dao.insert("wkordininfoukrvServiceImpl.wkordSts", param);
	}
	/**
	 * wkordIn조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/wkordininfoskrv.do")
	public String wkordininfoskrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "wkordininfoskrv";
	}

	/**
	 * wkordIn등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/wkordininfoukrv.do")
	public String wkordininfoukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "wkordininfoukrv";
	}

	/**
	 * 공정검사성적서 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr360skrv.do")
	public String pmr360skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		Gson gson = new Gson();
		String colData = gson.toJson(pmr360skrvService.selectColumns(loginVO));
		model.addAttribute("colData", colData);

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pmr360skrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "pmr360skrv";
	}

	/**
	 * 생산자재 출고(엠아이텍 쇄석기)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr202ukrv.do")
	public String pmr202ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		cdo = codeInfo.getCodeInfo("B703", "03");	//선입선출(생산) 사용여부 체크
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsFifo",cdo.getRefCode1());
		}else {
			model.addAttribute("gsFifo", "N");
		}

		//출력(Report 종류 확인)
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "",   false);
		for(CodeDetailVO map :   gsReportGubun)	{
			if("pmr202ukrv".equals(map.getCodeName())) {
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "pmr202ukrv";
	}

	/**
	 * 생산현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr250skrv.do")
	public String pmr250skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "pmr250skrv";
	}

	/**
	 * 작업실적 등록(키오스크)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr101ukrv.do")
	public String pmr101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("CSS_TYPE", "-large2");

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
		cdo = codeInfo.getCodeInfo("P516", "1");	 										  // 생산작업시간(점심)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLunchFr",cdo.getRefCode1());
			model.addAttribute("gsLunchTo",cdo.getRefCode2());
		}else{
			model.addAttribute("gsLunchFr","12:00");
			model.addAttribute("gsLunchTo","13:00");
		}

		Gson gson = new Gson();
        String colData = gson.toJson(pmr100ukrvService.selectBadcodes(loginVO.getCompCode()));
        model.addAttribute("colData", colData);

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

		List<CodeDetailVO> gsKioskUrl = codeInfo.getCodeList("P523", "", false);	//입고담당 정보 조회
		for(CodeDetailVO map : gsKioskUrl)	{

			if(loginVO.getDivCode().equals(map.getRefCode1()))	{
				model.addAttribute("gsKioskConUrl", map.getRefCode2());
			}
		}

		return JSP_PATH + "pmr101ukrv";
	}

	@RequestMapping(value = "/prodt/pmr830ukrv.do")
	public String pmr830ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "pmr830ukrv";
	}

	@RequestMapping(value = "/prodt/pmr820ukrv.do")
	public String pmr820ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "pmr820ukrv";
	}

}
