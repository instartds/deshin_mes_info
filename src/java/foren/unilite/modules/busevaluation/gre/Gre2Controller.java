package foren.unilite.modules.busevaluation.gre;

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
public class Gre2Controller extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_evaluation/gre/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;

	@RequestMapping(value = "/bus_evaluation/gre800ukrv.do", method = RequestMethod.GET)
	public String gre800ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		return JSP_PATH + "gre800ukrv";
	}
	
	@RequestMapping(value = "/bus_evaluation/gre900ukrv.do", method = RequestMethod.GET)
	public String gre900ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		return JSP_PATH + "gre900ukrv";
	}

}
