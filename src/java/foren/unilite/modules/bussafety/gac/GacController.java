package foren.unilite.modules.bussafety.gac;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import foren.unilite.modules.busoperate.GopCommonServiceImpl;

@Controller
public class GacController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_safety/gac/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;

	@RequestMapping(value = "/bus_safety/gac100ukrv.do", method = RequestMethod.GET)
	public String gac100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		return JSP_PATH + "gac100ukrv";
	}
	
	@RequestMapping(value = "/bus_safety/gac200ukrv.do", method = RequestMethod.GET)
	public String gac200ukrv() throws Exception {		
		return JSP_PATH + "gac200ukrv";
	}
	
	@RequestMapping(value = "/bus_safety/gac100skrv.do", method = RequestMethod.GET)
	public String gac100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
			
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		return JSP_PATH + "gac100skrv";
	}
	
	@RequestMapping(value = "/bus_safety/gac200skrv.do", method = RequestMethod.GET)
	public String gac200skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
			
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		return JSP_PATH + "gac200skrv";
	}
	
	@RequestMapping(value = "/bus_safety/gac300skrv.do", method = RequestMethod.GET)
	public String gac300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
			
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		return JSP_PATH + "gac300skrv";
	}

}
