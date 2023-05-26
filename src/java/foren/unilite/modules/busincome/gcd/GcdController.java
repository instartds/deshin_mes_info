package foren.unilite.modules.busincome.gcd;

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
public class GcdController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_income/gcd/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;
	
	@RequestMapping(value = "/bus_income/gcd100skrv.do", method = RequestMethod.GET)
	public String gcd100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("ROUTE_COMBO", comboService.routeComboForIncome(param));  
		model.addAttribute("ROUTEGROUP_COMBO", comboService.routeGroupForIncome(param));
		
		return JSP_PATH + "gcd100skrv";
	}
	
	@RequestMapping(value = "/bus_income/gcd200skrv.do", method = RequestMethod.GET)
	public String gcd200skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("ROUTE_COMBO", comboService.routeComboForIncome(param));  
		model.addAttribute("ROUTEGROUP_COMBO", comboService.routeGroupForIncome(param));
		return JSP_PATH + "gcd200skrv";
	}
	
	@RequestMapping(value = "/bus_income/gcd300skrv.do", method = RequestMethod.GET)
	public String gcd300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("ROUTE_COMBO", comboService.routeComboForIncome(param));  
		model.addAttribute("ROUTEGROUP_COMBO", comboService.routeGroupForIncome(param));
		return JSP_PATH + "gcd300skrv";
	}
	
	@RequestMapping(value = "/bus_income/gcd400skrv.do", method = RequestMethod.GET)
	public String gcd400skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("ROUTE_COMBO", comboService.routeComboForIncome(param));  
		model.addAttribute("ROUTEGROUP_COMBO", comboService.routeGroupForIncome(param));
		return JSP_PATH + "gcd400skrv";
	}

	
	@RequestMapping(value = "/bus_income/gcd500skrv.do", method = RequestMethod.GET)
	public String gcd500skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		model.addAttribute("ROUTE_COMBO", comboService.routeComboForIncome(param));  
		model.addAttribute("ROUTEGROUP_COMBO", comboService.routeGroupForIncome(param));
		return JSP_PATH + "gcd500skrv";
	}
	
	@RequestMapping(value = "/bus_income/gcd100ukrv.do", method = RequestMethod.GET)
	public String gcd100ukrv() throws Exception {		
		return JSP_PATH + "gcd100ukrv";
	}
	
	@RequestMapping(value = "/bus_income/gcd200ukrv.do", method = RequestMethod.GET)
	public String gcd200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeComboForIncome(param));  
		model.addAttribute("ROUTEGROUP_COMBO", comboService.routeGroupForIncome(param));
		
		return JSP_PATH + "gcd200ukrv";
	}
	
	@RequestMapping(value = "/bus_income/gcd300ukrv.do", method = RequestMethod.GET)
	public String gcd300ukrv() throws Exception {
		return JSP_PATH + "gcd300ukrv";
	}
}
