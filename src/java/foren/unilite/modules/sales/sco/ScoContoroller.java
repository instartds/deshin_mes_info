package foren.unilite.modules.sales.sco;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.lib.listop.ListOp;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.model.NavigatorInfo;
import foren.framework.utils.ObjUtils;
import foren.framework.web.view.FileDownloadInfo;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class ScoContoroller extends UniliteCommonController {
	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name="sco110ukrvService")
	private Sco110ukrvServiceImpl sco110ukrvService;

	@Resource(name = "sco300skrvService")
	private Sco300skrvServiceImpl sco300skrvService;

	final static String		JSP_PATH	= "/sales/sco/";
	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());


	@RequestMapping(value = "/sales/sco110ukrv.do")
	public String sco110ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("S012", "7");	//자동채번여부(수금번호)정보 조회
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

		cdo = codeInfo.getCodeInfo("B078", "10");	//프로젝트코드 사용유무
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPjtCodeYN",cdo.getRefCode1());
		} else {
			model.addAttribute("gsPjtCodeYN", "N");
		}

		List<CodeDetailVO> gsCollectCd = codeInfo.getCodeList("S017", "", false);	//외화계산(환율적용)대상 수금유형
		for(CodeDetailVO map : gsCollectCd) {
			if("Y".equals(map.getRefCode5())){
				model.addAttribute("gsCollectCd", map.getCodeNo());
			}
		}

		cdo = codeInfo.getCodeInfo("S115", "01");	//환차손익 자동계산 반영여부
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsExchangeDiffAmt",cdo.getRefCode1());
		} else {
			model.addAttribute("gsExchangeDiffAmt", "N");
		}

		List<CodeDetailVO> salePrsn = codeInfo.getCodeList("S010");	//영업담당 가져오기
		if(!ObjUtils.isEmpty(salePrsn))	model.addAttribute("salePrsn",ObjUtils.toJsonStr(salePrsn));

		List<Map<String, Object>> editableYN = sco110ukrvService.getEditableYN(param);	//프로그램 수정/삭제 사용자 ID : 권한등록 및 수정/삭제 여부 조회
		if(ObjUtils.isEmpty(editableYN)){
			editableYN = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("REGIST_YN", "N");
			map.put("MODIFY_YN", "Y");
			map.put("PGM_ID", "sco110ukrv");
			editableYN.add(map);
		}
		model.addAttribute("editableYN",ObjUtils.toJsonStr(editableYN));

		List<Map<String, Object>> gsPLCode = sco110ukrvService.getGsPLCode(param);	//수금유형 환차손익 여부
		if(ObjUtils.isEmpty(gsPLCode)){
			gsPLCode = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("P_CODE", "");
			map.put("L_CODE", "");
			gsPLCode.add(map);
		}
		model.addAttribute("gsPLCode",ObjUtils.toJsonStr(gsPLCode));

		List<CodeDetailVO> cdList = codeInfo.getCodeList("S017");			//수금유형 list
		if(!ObjUtils.isEmpty(cdList))	model.addAttribute("grsOutType",ObjUtils.toJsonStr(cdList));

		return JSP_PATH + "sco110ukrv";
	}

	@RequestMapping(value = "/sales/sco120ukrv.do")
	public String sco120ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "sco120ukrv";
	}

	/**
	 * 거래처별잔액현황 (sco150skrv) - 20200109 신규 프로그램 추가: 회계 데이터
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sco150skrv.do")
	public String sco150skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "sco150skrv";
	}

	/**
	 * 미수금현황 조회 (sco160skrv) - 20200109 신규 프로그램 추가: 회계 데이터
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sco160skrv.do")
	public String sco160skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "sco160skrv";
	}

	/**
	 * 수금현황(연세대학교 생협)
	 */
	@RequestMapping(value = "/sales/sco300skrv.do")
	public String sco300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B078", "10");	//자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPjtCodeYN",cdo.getRefCode1());
		} else {
			model.addAttribute("gsPjtCodeYN", "N");
		}
		return JSP_PATH + "sco300skrv";
	}

	@RequestMapping(value="/sales/sco300skrvSign.do")
	public ModelAndView signViewer(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		Map param = new HashMap();
		param.put("DIV_CODE", _req.getP("DIV_CODE"));
		param.put("COLLECT_NUM", _req.getP("COLLECT_NUM"));
		param.put("COLLECT_SEQ", _req.getP("COLLECT_SEQ"));

		File sign = sco300skrvService.getSign(param, loginVO);

		return ViewHelper.getImageView(sign);
	}

	/**
	 * sco3oorkrv Report
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sco300rkrv.do")
	public String sco300rkrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		return JSP_PATH + "sco300rkrv";
	}

	/**
	 * 수금현황(정규)
	 */
	@RequestMapping(value = "/sales/sco301skrv.do")
	public String sco301skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B078", "10");   //자동채번여부(출고번호)정보 조회
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("gsPjtCodeYN",cdo.getRefCode1());
		} else {
			model.addAttribute("gsPjtCodeYN", "N");
		}
		return JSP_PATH + "sco301skrv";
	}

	@RequestMapping(value = "/sales/sco330ukrv.do")
	public String sco330ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("COMBO_ITEM_LEVEL1", comboService.getItemLevel1(param));
		model.addAttribute("COMBO_ITEM_LEVEL2", comboService.getItemLevel2(param));
		model.addAttribute("COMBO_ITEM_LEVEL3", comboService.getItemLevel3(param));

		return JSP_PATH + "sco330ukrv";
	}

	@RequestMapping(value = "/sales/sco400skrv.do")
	public String sco400skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sco400skrv";
	}

	@RequestMapping(value = "/sales/sco410skrv.do")
	public String sco410skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		return JSP_PATH + "sco410skrv";
	}

	/**
	 * 미수금현황 조회 - 20190925 추가
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sco700skrv.do")
	public String sco700skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "sco700skrv";
	}

	/**
	 * 미수금현황 조회 (sco170skrv) - 20200409 신규 프로그램 추가: 회계 데이터
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sco170skrv.do")
	public String sco170skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		return JSP_PATH + "sco170skrv";
	}
}
