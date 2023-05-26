package foren.unilite.modules.base.gve;

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
public class GveController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/base/gve/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;

	@RequestMapping(value = "/base/gve100ukrv.do", method = RequestMethod.GET)
	public String gve100ukrv() throws Exception {
		return JSP_PATH + "gve100ukrv";
	}
	
	@RequestMapping(value = "/base/gve110ukrv.do", method = RequestMethod.GET)
	public String gve110ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		
		return JSP_PATH + "gve110ukrv";
	}

	@RequestMapping(value = "/base/gve120ukrv.do", method = RequestMethod.GET)
	public String gve120ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		return JSP_PATH + "gve120ukrv";
	}
	
	@RequestMapping(value = "/base/gve100skrv.do", method = RequestMethod.GET)
	public String gve100skrv() throws Exception {
		return JSP_PATH + "gve100skrv";
	}
}
