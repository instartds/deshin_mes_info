package foren.unilite.modules.crm.popup;

import java.util.HashMap;
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
import foren.unilite.com.UniliteCommonController;

/**
 *    프로그램명 : 작업지시조정
 *    작  성  자 : (주)포렌 개발실
 */
@Controller
public class CmPopupController extends UniliteCommonController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	final static String JSP_PATH = "/crm/popup/";
	
	
	@RequestMapping(value="/crm/cmClientProjectPopup.do")
	public String cmClientProjectPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		return JSP_PATH+"cmClientProjectPopup";
	}
	@RequestMapping(value="/app/Unilite/app/popup/cmClientProjectPopup.do")
	public String cmClientProjectPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		return JSP_PATH+"cmClientProjectPopupWin";
	}
	
	
	/**
	 * 고객정보 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/crm/ClientPopup.do")
	public String clientPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "ClientPopup";
		
	}
	@RequestMapping(value = "/app/Unilite/app/popup/ClientPopup.do")
	public String clientPopupWin(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		return JSP_PATH + "ClientPopupWin";
		
	}
	

	/**
	 * 경영정보 팝업
	 * @param popupID
	 * @param _req
	 * @param loginVO
	 * @param listOp
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/crm/CustomInfoPopup.do")
	public String customInfoPopup(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		
		return JSP_PATH + "cmb200skpv";

	}
}
