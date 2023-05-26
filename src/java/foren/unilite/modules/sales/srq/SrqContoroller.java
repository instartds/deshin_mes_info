package foren.unilite.modules.sales.srq;

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

@Controller
public class SrqContoroller extends UniliteCommonController {
	final static String		JSP_PATH	= "/sales/srq/";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/sales/srq100skrv.do")
	public String srq100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());
		//20200604 추가: 창고cell 콤보데이터 가져오는 로직 추가
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));
		return JSP_PATH + "srq100skrv";
	}

	@RequestMapping(value = "/sales/srq100ukrv.do")
	public String srq100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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

		//20190925 - LOT 관리기준 설정
		cdo = codeInfo.getCodeInfo("B090", "SE");		//출하지시 등록(SE)
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsLotNoInputMethod"	, cdo.getRefCode1());	//입력형태(Y/E/N)
			model.addAttribute("gsLotNoEssential"	, cdo.getRefCode2());	//필수여부(Y/N)
			model.addAttribute("gsEssItemAccount"	, cdo.getRefCode3());	//품목계정(필수Y,문자열)
		}
		return JSP_PATH + "srq100ukrv";
	}

	@RequestMapping(value = "/sales/srq101ukrv.do")
	public String srq101ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
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
		return JSP_PATH + "srq101ukrv";
	}

	/* 출하지시미등록 현황
	 * 
	 * */
	@RequestMapping(value = "/sales/srq110skrv.do", method = RequestMethod.GET)
	public String srq110skrv() throws Exception {
		return JSP_PATH + "srq110skrv";
	}

	/* 출하대비 미출고 현황
	 * 
	 * */
	@RequestMapping(value = "/sales/srq120skrv.do", method = RequestMethod.GET)
	public String srq120skrv() throws Exception {
		return JSP_PATH + "srq120skrv";
	}

	@RequestMapping(value = "/sales/srq150ukrv.do")
	public String srq150ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());
		return JSP_PATH + "srq150ukrv";
	}

	@RequestMapping(value = "/sales/srq155skrv.do")
	public String srq155skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());
		return JSP_PATH + "srq155skrv";
	}

	@RequestMapping(value = "/sales/srq160ukrv.do")
	public String srq160ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());
		return JSP_PATH + "srq160ukrv";
	}

	@RequestMapping(value = "/sales/srq200rkrv.do")
	public String srq200rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));
		model.addAttribute("TIMESHOW",this.tlabCodeService.getCodeInfo(loginVO.getCompCode()).getCodeInfo("S048", "SR").getRefCode1());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		
		List<CodeDetailVO> gsReportGubun = codeInfo.getCodeList("S036", "", false);		//모듈별 출력 설정에서 ClipReport추가로 인한 리포트 프로그램 설정값 가져오기(크리스탈,jasper 또는 ClipReport)
		for(CodeDetailVO map : gsReportGubun)	{
			if("srq200rkrv".equals(map.getCodeName()))	{
				model.addAttribute("gsReportGubun", map.getRefCode10());
				logger.debug("[[map.getRefCode10()]]" + map.getRefCode10());
			}
		}
		return JSP_PATH + "srq200rkrv";
	}

	/**
	 * 거래처출하품목등록 (srq200ukrv) - 20191226 신규 생성
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/srq200ukrv.do")
	public String srq200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "srq200ukrv";
	}

	/**
	 * 출하예정표등록 (srq210ukrv) - 20191231 신규 생성
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/srq210ukrv.do")
	public String srq210ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "srq210ukrv";
	}

	@RequestMapping(value = "/sales/srq300rkrv.do")
	public String srq300rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "srq300rkrv";
	}

	/**
	 * 출하대기 현황판 - 20190827
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/srq400skrv.do")
	public String srq400skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "srq400skrv";
	}

	/**
	 * 패킹번호 출력
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/srq500rkrv.do")
	public String srq500rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "srq500rkrv";
	}

	/**
	 * 패킹등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/srq500ukrv.do")
	public String srq500ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		
		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_CELL_LIST", comboService.getWhCellList(param));

		List<CodeDetailVO> gsInspecPrsn = codeInfo.getCodeList("B024", "", false);		//로그인사용자에 해당하는 수불담당자 정보
		for(CodeDetailVO map : gsInspecPrsn)	{
			if(loginVO.getUserID().equals(map.getRefCode10()))	{
				model.addAttribute("gsInoutPrsn", map.getCodeNo());
			}
		}

		return JSP_PATH + "srq500ukrv";
	}

	/**
	 * 패킹출고등록
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/srq600ukrv.do")
	public String srq600ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "srq600ukrv";
	}

}