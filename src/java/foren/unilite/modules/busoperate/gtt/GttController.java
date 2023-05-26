package foren.unilite.modules.busoperate.gtt;

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
public class GttController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_operate/gtt/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;
	
	@RequestMapping(value = "/bus_operate/gtt100skrv.do", method = RequestMethod.GET)
	public String gtt100skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> driverTypeListAll = codeInfo.getCodeList("H024", "", false);
		List<ComboItemModel> driverTypeList = new ArrayList<ComboItemModel>();
		for(CodeDetailVO map : driverTypeListAll)	{
			if("Y".equals(map.getRefCode3()))	{
				ComboItemModel listMap = new ComboItemModel();
				listMap.setValue(map.getCodeNo());
				listMap.setText(map.getCodeName());
				driverTypeList.add(listMap);
			}
		}
		model.addAttribute("DRIVER_TYPE", driverTypeList);
		
		return JSP_PATH + "gtt100skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt101skrv.do", method = RequestMethod.GET)
	public String gtt101skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> driverTypeListAll = codeInfo.getCodeList("H024", "", false);
		List<ComboItemModel> driverTypeList = new ArrayList<ComboItemModel>();
		for(CodeDetailVO map : driverTypeListAll)	{
			if("Y".equals(map.getRefCode3()))	{
				ComboItemModel listMap = new ComboItemModel();
				listMap.setValue(map.getCodeNo());
				listMap.setText(map.getCodeName());
				driverTypeList.add(listMap);
			}
		}
		model.addAttribute("DRIVER_TYPE", driverTypeList);
		
		return JSP_PATH + "gtt101skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt102skrv.do", method = RequestMethod.GET)
	public String gtt102skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> driverTypeListAll = codeInfo.getCodeList("H024", "", false);
		List<ComboItemModel> driverTypeList = new ArrayList<ComboItemModel>();
		for(CodeDetailVO map : driverTypeListAll)	{
			if("Y".equals(map.getRefCode3()))	{
				ComboItemModel listMap = new ComboItemModel();
				listMap.setValue(map.getCodeNo());
				listMap.setText(map.getCodeName());
				driverTypeList.add(listMap);
			}
		}
		model.addAttribute("DRIVER_TYPE", driverTypeList);
		
		return JSP_PATH + "gtt102skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt103skrv.do", method = RequestMethod.GET)
	public String gtt103skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> driverTypeListAll = codeInfo.getCodeList("H024", "", false);
		List<ComboItemModel> driverTypeList = new ArrayList<ComboItemModel>();
		for(CodeDetailVO map : driverTypeListAll)	{
			if("Y".equals(map.getRefCode3()))	{
				ComboItemModel listMap = new ComboItemModel();
				listMap.setValue(map.getCodeNo());
				listMap.setText(map.getCodeName());
				driverTypeList.add(listMap);
			}
		}
		model.addAttribute("DRIVER_TYPE", driverTypeList);
		
		return JSP_PATH + "gtt103skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt104skrv.do", method = RequestMethod.GET)
	public String gtt104skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> driverTypeListAll = codeInfo.getCodeList("H024", "", false);
		List<ComboItemModel> driverTypeList = new ArrayList<ComboItemModel>();
		for(CodeDetailVO map : driverTypeListAll)	{
			if("Y".equals(map.getRefCode3()))	{
				ComboItemModel listMap = new ComboItemModel();
				listMap.setValue(map.getCodeNo());
				listMap.setText(map.getCodeName());
				driverTypeList.add(listMap);
			}
		}
		model.addAttribute("DRIVER_TYPE", driverTypeList);
		
		return JSP_PATH + "gtt104skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt110skrv.do", method = RequestMethod.GET)
	public String gtt110skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		return JSP_PATH + "gtt110skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt200skrv.do", method = RequestMethod.GET)
	public String gtt200skrv() throws Exception {
		
		return JSP_PATH + "gtt200skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt300skrv.do", method = RequestMethod.GET)
	public String gtt300skrv() throws Exception {
		
		return JSP_PATH + "gtt300skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt400skrv.do", method = RequestMethod.GET)
	public String gtt400skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
	
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> driverTypeListAll = codeInfo.getCodeList("H181", "", false);
		List<ComboItemModel> driverTypeList = new ArrayList<ComboItemModel>();
		for(CodeDetailVO map : driverTypeListAll)	{
			if("Y".equals(map.getRefCode1()))	{
				ComboItemModel listMap = new ComboItemModel();
				listMap.setValue(map.getCodeNo());
				listMap.setText(map.getCodeName());
				driverTypeList.add(listMap);
			}
		}
		model.addAttribute("EMP_DIV", driverTypeList);
		return JSP_PATH + "gtt400skrv";
	}
	
	@RequestMapping(value = "/bus_operate/gtt500skrv.do", method = RequestMethod.GET)
	public String gtt500skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");

		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		return JSP_PATH + "gtt500skrv";
	}
}
