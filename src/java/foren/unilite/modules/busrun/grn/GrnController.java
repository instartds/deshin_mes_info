package foren.unilite.modules.busrun.grn;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.busoperate.GopCommonServiceImpl;

@Controller
public class GrnController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_run/grn/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;
	
	@RequestMapping(value = "/bus_run/grn100skrv.do", method = RequestMethod.GET)
	public String grn100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		
		return JSP_PATH + "grn100skrv";
	}
	@RequestMapping(value = "/bus_run/grn200skrv.do", method = RequestMethod.GET)
	public String grn200skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		
		return JSP_PATH + "grn200skrv";
	}
	@RequestMapping(value = "/bus_run/grn300skrv.do", method = RequestMethod.GET)
	public String grn300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		
		return JSP_PATH + "grn300skrv";
	}
}
