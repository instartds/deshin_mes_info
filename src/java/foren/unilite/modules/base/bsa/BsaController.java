package foren.unilite.modules.base.bsa;

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
import foren.unilite.modules.base.BaseCommonServiceImpl;
import foren.unilite.modules.com.combo.ComboServiceImpl;

@Controller
public class BsaController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/base/bsa/";

	@Resource(name = "bsa110ukrvService")
	private Bsa110ukrvService bsa110ukrvService;

	@Resource(name = "bsa560ukrvService")
	private Bsa560ukrvServiceImpl bsa560ukrvService;


	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;


	@RequestMapping(value = "/base/bsa100ukrv.do", method = RequestMethod.GET)
	public String bsa100skrv() throws Exception {
		return JSP_PATH + "bsa100ukrv";
	}


	/** 운영자공통코드등록 (bsa101ukrv)
	 *
	 * 대상테이블 변경 (bsa100t -> bsa100g) && table replication
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bsa101ukrv.do", method = RequestMethod.GET)
	public String bsa101ukrv() throws Exception {
		return JSP_PATH + "bsa101ukrv";
	}


	@RequestMapping(value = "/base/bsa250ukrv.do")
	public String bsa250ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
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

		return JSP_PATH + "bsa250ukrv";
	}

	@RequestMapping(value = "/base/bsa300ukrv.do", method = RequestMethod.GET)
	public String bsa300ukrv( LoginVO loginVO, ModelMap model) throws Exception {

		CodeDetailVO cdo = null;
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		cdo = codeInfo.getCodeInfo("B265", "Y");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsSyTalkYn",cdo.getRefCode1());	//LOT관리기준 설정
		return JSP_PATH + "bsa300ukrv";
	}



	@RequestMapping(value = "/base/bsa301ukrv.do", method = RequestMethod.GET)
	public String bsa301ukrv() throws Exception {
		return JSP_PATH + "bsa301ukrv";
	}

	@RequestMapping(value = "/base/bsa310ukrv.do", method = RequestMethod.GET)
	public String bsa310ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {

		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN",cdo.getRefCode1());
		}
		cdo = codeInfo.getCodeInfo("B110", "20");	//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("numberPast",cdo.getRefCode1());
		}
		return JSP_PATH + "bsa310ukrv";
	}

	@RequestMapping(value = "/base/bsa110ukrv.do", method = RequestMethod.GET)
	public String bsa110ukrv(LoginVO login, ModelMap model) throws Exception {
		model.addAttribute("WORK_TYPE_COMBO", bsa110ukrvService.getWorkTypeList(login));
		return JSP_PATH + "bsa110ukrv";
	}

	@RequestMapping(value = "/base/bsa350ukrv.do")
	public String bsa350ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "bsa350ukrv";
	}

	@RequestMapping(value = "/base/bsa351ukrv.do", method = RequestMethod.GET)
	public String bsa351ukrv() throws Exception {
		return JSP_PATH + "bsa351ukrv";
	}

	@RequestMapping(value = "/base/bsa360ukrv.do", method = RequestMethod.GET)
	public String bsa360ukrv() throws Exception {
		return JSP_PATH + "bsa360ukrv";
	}

	@RequestMapping(value = "/base/bsa400ukrv.do", method = RequestMethod.GET)
	public String bsa400ukrv() throws Exception {
		return JSP_PATH + "bsa400ukrv";
	}

	/** 프로그램정보등록 (bsa401ukrv)
	 *
	 * 대상테이블 변경 (BSA400T -> BSA400G) && table replication
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bsa401ukrv.do", method = RequestMethod.GET)
	public String bsa401ukrv() throws Exception {
		return JSP_PATH + "bsa401ukrv";
	}

	@RequestMapping(value = "/base/bsa402ukrv.do", method = RequestMethod.GET)
	public String bsa402ukrv() throws Exception {
		return JSP_PATH + "bsa402ukrv";
	}

	@RequestMapping(value = "/base/bsa421ukrv.do", method = RequestMethod.GET)
	public String bsa421ukrv() throws Exception {
		return JSP_PATH + "bsa421ukrv";
	}

	@RequestMapping(value = "/base/bsa500ukrv.do", method = RequestMethod.GET)
	public String bsa500ukrv() throws Exception {
		return JSP_PATH + "bsa500ukrv";
	}

	@RequestMapping(value = "/base/bsa500skrv.do", method = RequestMethod.GET)
	public String bsa500skrv() throws Exception {
		return JSP_PATH + "bsa500skrv";
	}

	@RequestMapping(value = "/base/bsa510ukrv.do", method = RequestMethod.GET)
	public String bsa510ukrv() throws Exception {
		return JSP_PATH + "bsa510ukrv";
	}


	@RequestMapping(value = "/base/bsa510skrv.do")
	public String bsa510skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");



		return JSP_PATH + "bsa510skrv";
	}

	@RequestMapping(value = "/base/bsa520ukrv.do", method = RequestMethod.GET)
	public String bsa520ukrv() throws Exception {
		return JSP_PATH + "bsa520ukrv";
	}

	@RequestMapping(value = "/base/bsa530ukrv.do", method = RequestMethod.GET)
	public String bsa530ukrv() throws Exception {
		return JSP_PATH + "bsa530ukrv";
	}

	@RequestMapping(value = "/base/bsa531ukrv.do")
	public String bsa531ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");



		return JSP_PATH + "bsa531ukrv";
	}

	@RequestMapping(value = "/base/bsa540ukrv.do", method = RequestMethod.GET)
	public String bsa540ukrv() throws Exception {
		return JSP_PATH + "bsa540ukrv";
	}

	@RequestMapping(value = "/base/bsa550ukrv.do", method = RequestMethod.GET)
	public String bsa550ukrv() throws Exception {
		return JSP_PATH + "bsa550ukrv";
	}

	@RequestMapping(value = "/base/bsa560ukrv.do", method = RequestMethod.GET)
	public String bsa560ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		//소속지점 콤보 가져오는 쿼리 호출
		model.addAttribute("getCompCode", bsa560ukrvService.getCompCode(param));


		return JSP_PATH + "bsa560ukrv";
	}

	@RequestMapping(value = "/base/bsa580ukrv.do", method = RequestMethod.GET)
	public String bsa580ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());

		//소속지점 콤보 가져오는 쿼리 호출
		model.addAttribute("getCompCode", bsa560ukrvService.getCompCode(param));


		return JSP_PATH + "bsa580ukrv";
	}

	@RequestMapping(value = "/base/bsa600ukrv.do", method = RequestMethod.GET)
	public String bsa600ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		return JSP_PATH + "bsa600ukrv";
	}

	@RequestMapping(value = "/base/bsa710skrv.do", method = RequestMethod.GET)
	public String bsa710skrv() throws Exception {
		return JSP_PATH + "bsa710skrv";
	}

	@RequestMapping(value = "/base/bsa700ukrv.do", method = RequestMethod.GET)
	public String bsa700ukrv() throws Exception {
		return JSP_PATH + "bsa700ukrv";
	}

	@RequestMapping(value = "/base/bsa720skrv.do", method = RequestMethod.GET)
	public String bsa720skrv() throws Exception {
		return JSP_PATH + "bsa720skrv";
	}


	@RequestMapping(value = "/base/bsa750skrv.do", method = RequestMethod.GET)
	public String bsa750skrv() throws Exception {
		return JSP_PATH + "bsa750skrv";
	}

	@RequestMapping(value = "/base/bsa900skrv.do", method = RequestMethod.GET)
	public String bsa900skrv() throws Exception {
		return JSP_PATH + "bsa900skrv";
	}
	@RequestMapping(value = "/base/bsa920skrv.do", method = RequestMethod.GET)
    public String bsa920skrv() throws Exception {
        return JSP_PATH + "bsa920skrv";
    }
	@RequestMapping(value = "/base/bsa800ukrv.do", method = RequestMethod.GET)
	public String bsa800ukrv() throws Exception {
		return JSP_PATH + "bsa800ukrv";
	}
	@RequestMapping(value = "/base/bsa610ukrv.do", method = RequestMethod.GET)
	public String bsa610ukrv() throws Exception {
		return JSP_PATH + "bsa610ukrv";
	}


	/**
	 * 개발일정관리
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/bsa950ukrv.do", method = RequestMethod.GET)
	public String bsa950ukrv() throws Exception {
		return JSP_PATH + "bsa950ukrv";
	}


	@Resource(name="baseCommonService")
	private BaseCommonServiceImpl baseCommonService;
	@RequestMapping(value = "/base/bsa9999ukrv.do", method = RequestMethod.GET)
	public String bsa9999ukrv() throws Exception {
		return JSP_PATH + "bsa9999ukrv";
	}

	@RequestMapping(value = "/base/bsa990ukrv.do", method = RequestMethod.GET)
	public String bsa990ukrv() throws Exception {
		return JSP_PATH + "bsa990ukrv";
	}

	@RequestMapping(value = "/base/bsa570ukrv.do", method = RequestMethod.GET)
	public String bsa570ukrv() throws Exception {
		return JSP_PATH + "bsa570ukrv";
	}


	@RequestMapping(value = "/base/bsa960skrv.do", method = RequestMethod.GET)
	public String bsa960skrv() throws Exception {
		return JSP_PATH + "bsa960skrv";
	}
}
