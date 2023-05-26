package foren.unilite.modules.busoperate.gop;

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
import foren.unilite.modules.busoperate.GopCommonServiceImpl;

@Controller
public class GopController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_operate/gop/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;

	@RequestMapping(value = "/bus_operate/gop100ukrv.do", method = RequestMethod.GET)
	public String gop100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		return JSP_PATH + "gop100ukrv";
	}
	
	@RequestMapping(value = "/bus_operate/gop200ukrv.do", method = RequestMethod.GET)
	public String gop200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		return JSP_PATH + "gop200ukrv";
	}
	
	@RequestMapping(value = "/bus_operate/gop300ukrv.do", method = RequestMethod.GET)
	public String gop300ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> driverTypeListAll = codeInfo.getCodeList("H024", "", false);
		List<Map> driverTypeList = new ArrayList<Map>();
		for(CodeDetailVO map : driverTypeListAll)	{
			if("1".equals(map.getRefCode2()))	{
				Map listMap = new HashMap();
				listMap.put("CODE", map.getCodeNo());
				listMap.put("VALUE", map.getRefCode2());
				driverTypeList.add(listMap);
			}
		}
		model.addAttribute("driverTypes", ObjUtils.toJsonStr(driverTypeList));
		
		return JSP_PATH + "gop300ukrv";
	}
	
	@RequestMapping(value = "/bus_operate/gop300skrv.do", method = RequestMethod.GET)
	public String gop300skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		
		return JSP_PATH + "gop300skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gop400skrv.do", method = RequestMethod.GET)
	public String gop400skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		
		return JSP_PATH + "gop400skrv";
	}
}
