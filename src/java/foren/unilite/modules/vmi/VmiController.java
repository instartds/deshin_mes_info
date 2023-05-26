package foren.unilite.modules.vmi;

import java.io.File;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.combo.ComboServiceImpl;
import foren.unilite.modules.com.popup.PopupServiceImpl;
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import net.sf.jasperreports.engine.JRConstants;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRRuntimeException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;


@Controller
public class VmiController extends UniliteCommonController {
	public static String path;
	private final Logger	logger						= LoggerFactory.getLogger(this.getClass());
	final static String		JSP_PATH					= "/vmi/";
	public final static		String FILE_TYPE_OF_PHOTO	= "stempPhoto";

	@Resource(name="UniliteComboServiceImpl")
	private ComboServiceImpl comboService;

	@Resource(name = "popupService")
	private PopupServiceImpl popupService;

	@Resource(name = "vmiCommonService")
	private VmiCommonServiceImpl vmiCommonService;

	/**
	 * VMI 재고현황조회
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/vmi100skrv.do")
	public String vmi100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;
		model.addAttribute("COMBO_WH_LIST", comboService.getWhList(param));

		return JSP_PATH + "vmi100skrv";
	}

	/**
	 * 비밀번호변경
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/vmi300ukrv.do")
	public String vmi300ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		cdo = codeInfo.getCodeInfo("B110", "40");						//대소문자 구분
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("caseSensYN", cdo.getRefCode5());		//20210426 수정: 외부사용자는 refcode5사용
		}
		cdo = codeInfo.getCodeInfo("B110", "20");						//최근비밀번호체크갯수
		if(!ObjUtils.isEmpty(cdo)){
			model.addAttribute("numberPast", cdo.getRefCode5());		//20210426 수정: 외부사용자는 refcode5사용
		}
		return JSP_PATH + "vmi300ukrv";
	}

	/**
	 * VMI 납품예정등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/vmi200ukrv.do")
	public String vmi200ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		Map getVmiUserLevel = (Map) vmiCommonService.getVmiUserLevel(param);
		model.addAttribute("getVmiUserLevel", getVmiUserLevel.get("USER_LEVEL"));

		return JSP_PATH + "vmi200ukrv";
	}

	/**
	 * VMI 납품등록
	 * @param loginVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/vmi210ukrv.do")
	public String vmi210ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		Map getVmiUserLevel = (Map) vmiCommonService.getVmiUserLevel(param);
		model.addAttribute("getVmiUserLevel", getVmiUserLevel.get("USER_LEVEL"));

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
		return JSP_PATH + "vmi210ukrv";
	}

	/**
	 * 주문현황
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/ord100skrv.do")
	public String ord100skrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "ord100skrv";
	}

	/**
	 * 주문등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/ord100ukrv.do")
	public String ord100ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		Map<String, Object> paramTemp = navigator.getParam();
		paramTemp.put("TXT_SEARCH2"		, param.get("S_USER_ID"));
		List<Map<String, Object>> customInfo = popupService.agentCustPopup(paramTemp);
		if(customInfo.size() > 0){
			model.addAttribute("gsAgentType",customInfo.get(0).get("AGENT_TYPE"));
			model.addAttribute("gsMoneyUnit",customInfo.get(0).get("MONEY_UNIT"));
		}else{
			model.addAttribute("gsAgentType","");
			model.addAttribute("gsMoneyUnit","");
		}
		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "ord100ukrv";
	}

	/**
	 * 주문등록(배송) (ord101ukrv) - 20210317 신규 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/ord101ukrv.do")
	public String ord101ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields		= {  };
		NavigatorInfo navigator			= new NavigatorInfo(_req, listOp, searchFields);
		Map<String, Object> param		= navigator.getParam();
		CodeInfo codeInfo				= this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo				= null;
		Map<String, Object> paramTemp	= navigator.getParam();
//		LoginVO session					= _req.getSession();
//		String page						= _req.getP("page");
		paramTemp.put("TXT_SEARCH2", param.get("S_USER_ID"));

		List<Map<String, Object>> customInfo = popupService.agentCustPopup(paramTemp);
		if(customInfo.size() > 0){
			model.addAttribute("gsAgentType",customInfo.get(0).get("AGENT_TYPE"));
			model.addAttribute("gsMoneyUnit",customInfo.get(0).get("MONEY_UNIT"));
		}else{
			model.addAttribute("gsAgentType","");
			model.addAttribute("gsMoneyUnit","");
		}
		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		param.put("S_COMP_CODE", loginVO.getCompCode());
		return JSP_PATH + "ord101ukrv";
	}

	/**
	 * 주문확정
	 * 20190702 추가
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/vmi/ord109ukrv.do")
	public String ord109ukrv(ExtHtttprequestParam _req, LoginVO loginVO, ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		CodeDetailVO cdo = null;

		Map<String, Object> paramTemp = navigator.getParam();
		paramTemp.put("TXT_SEARCH2"		, param.get("S_USER_ID"));
		List<Map<String, Object>> customInfo = popupService.agentCustPopup(paramTemp);
		if(customInfo.size() > 0){
			model.addAttribute("gsAgentType",customInfo.get(0).get("AGENT_TYPE"));
			model.addAttribute("gsMoneyUnit",customInfo.get(0).get("MONEY_UNIT"));
		}else{
			model.addAttribute("gsAgentType","");
			model.addAttribute("gsMoneyUnit","");
		}

		cdo = codeInfo.getCodeInfo("S028", "1");
		if(!ObjUtils.isEmpty(cdo))	model.addAttribute("gsVatRate",cdo.getRefCode1());

		param.put("S_COMP_CODE",loginVO.getCompCode());
		return JSP_PATH + "ord109ukrv";
	}
}