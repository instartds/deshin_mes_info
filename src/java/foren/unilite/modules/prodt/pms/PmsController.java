package foren.unilite.modules.prodt.pms;

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

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.stock.qba.Qba120ukrvServiceImpl;

@Controller
public class PmsController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/prodt/pms/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="qba120ukrvService")
	private Qba120ukrvServiceImpl qba120ukrvService;

	@Resource(name="pms300skrvService")				//20210910 추가
	private Pms300skrvServiceImpl pms300skrvService;


	/**
	 * 접수 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms300ukrv.do")
	public String pms300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pms300ukrv";
	}
	/**
	 * 완제품검사현황
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms400skrv.do")
	public String pms400skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pms400skrv";
	}
	/**
	 * 완제품검사현황출력
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms400rkrv.do")
	public String pms400rkrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pms400rkrv";
	}

	/**
	 * 검사등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms401ukrv.do",method = RequestMethod.GET)
	public String pms401ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//model.addAttribute("CSS_TYPE", "-large");  //화면크기조정(POP)


		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부

		cdo = codeInfo.getCodeInfo("B090", "PC");	//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		List<CodeDetailVO> gsSyTalkFlag = codeInfo.getCodeList("B265", "", false);		//시너지톡 발송 옵션
		for(CodeDetailVO map : gsSyTalkFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSyTalkFlag", map.getCodeNo());
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
		return JSP_PATH + "pms401ukrv";
	}

	/**
	 * 공정검사 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms402ukrv.do",method = RequestMethod.GET)
	public String pms402ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		//model.addAttribute("CSS_TYPE", "-large");  //화면크기조정(POP)

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		 model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부

		cdo = codeInfo.getCodeInfo("B090", "PC");	//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}
		model.addAttribute("COMBO_TEST_CODE", qba120ukrvService.getTestCode(param));
		cdo = codeInfo.getCodeInfo("B084", "D");	 										  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		List<CodeDetailVO> gsSyTalkFlag = codeInfo.getCodeList("B265", "", false);		//시너지톡 발송 옵션
		for(CodeDetailVO map : gsSyTalkFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSyTalkFlag", map.getCodeNo());
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
		return JSP_PATH + "pms402ukrv";
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
	@RequestMapping(value = "/prodt/pms410skrv.do")
	public String pms410skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("P010", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("pms410skrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
			}
		}

		return JSP_PATH + "pms410skrv";
	}

	/**
	 * 공정출하검사현황 (pms420skrv) - 20210909 추가
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms420skrv.do")
	public String pms420skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		return JSP_PATH + "pms420skrv";
	}

	/**
	 * 불량(제품)등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms430ukrv.do",method = RequestMethod.GET)
	public String pms430ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("CSS_TYPE", "-large2");  //화면크기조정(POP)


		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST", comboService.getWsList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부

		cdo = codeInfo.getCodeInfo("B090", "PC");	//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}

		List<CodeDetailVO> gsSyTalkFlag = codeInfo.getCodeList("B265", "", false);		//시너지톡 발송 옵션
		for(CodeDetailVO map : gsSyTalkFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSyTalkFlag", map.getCodeNo());
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
		return JSP_PATH + "pms430ukrv";
	}

	/**
	 * 공정검사 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms440ukrv.do",method = RequestMethod.GET)
	public String pms440ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("CSS_TYPE", "-large2");  //화면크기조정(POP)

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		 model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("P000", "2");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsAutoInputFlag",cdo.getRefCode1());	// 출하검사 후 자동입고여부

		cdo = codeInfo.getCodeInfo("B090", "PC");	//생산실적과 출하검사 LOT 연계 여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod",cdo.getRefCode1());
			model.addAttribute("gsLotNoEssential",cdo.getRefCode2());
			model.addAttribute("gsEssItemAccount",cdo.getRefCode3());
		}
		model.addAttribute("COMBO_TEST_CODE", qba120ukrvService.getTestCode(param));
		cdo = codeInfo.getCodeInfo("B084", "D");	 										  // 재고대체 합산
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsSumTypeCell",cdo.getRefCode1());
		}else {
			model.addAttribute("gsSumTypeCell", "N");
		}

		List<CodeDetailVO> gsSyTalkFlag = codeInfo.getCodeList("B265", "", false);		//시너지톡 발송 옵션
		for(CodeDetailVO map : gsSyTalkFlag)	{
			if("Y".equals(map.getRefCode1()))	{
				model.addAttribute("gsSyTalkFlag", map.getCodeNo());
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
		return JSP_PATH + "pms440ukrv";
	}

	/**
	 * 검증검사 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms500ukrv.do")
	public String pms500ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pms500ukrv";
	}

	/**
	 * 접수현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms300skrv.do")
	public String pms300skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param = navigator.getParam();

		param.put("S_COMP_CODE", loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1"	, comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2"	, comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3"	, comboService.getItemLevel3(param));
		model.addAttribute("COMBO_WS_LIST"		, comboService.getWsList(param));

		model.addAttribute("gsReportSettingYn"	, pms300skrvService.getReportSettingYn(param));			//20210910 추가
		return JSP_PATH + "pms300skrv";
	}

	/**
	 * 검사현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms301skrv.do")
	public String pms301skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pms301skrv";
	}

	/**
	 * 불량현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms302skrv.do")
	public String pms302skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pms302skrv";
	}

	/**
	 * 출하검사현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms401skrv.do")
	public String pms401skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pms401skrv";
	}

	/**
	 * 검증검사현황 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pms500skrv.do")
	public String pms500skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "pms500skrv";
	}
}
