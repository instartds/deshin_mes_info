package foren.unilite.modules.busevaluation.grg;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.modules.busevaluation.grb.GrbExcelServiceImpl;
import foren.unilite.modules.busoperate.GopCommonServiceImpl;

@Controller
public class GrgController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_evaluation/grg/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;
	
	@Resource(name="grgExcelService")
	private GrgExcelServiceImpl excelService;
	
	@RequestMapping(value = "/bus_evaluation/grg100ukrv.do", method = RequestMethod.GET)
	public String grg100ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		return JSP_PATH + "grg100ukrv";
	}
	
	 @RequestMapping(value="/busevaluation/excel/grg100out")
	  public  ModelAndView grg100out( ExtHtttprequestParam _req) throws Exception {
	      
	      Workbook wb = excelService.selectExcel1(_req.getParameterMap());
	      String title = "G1.손익계산서";
	      return ViewHelper.getExcelDownloadView(wb, title);
	  }
	
	@RequestMapping(value = "/bus_evaluation/grg200ukrv.do", method = RequestMethod.GET)
	public String grg200ukrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param));  
		
		return JSP_PATH + "grg200ukrv";
	}
	
	 @RequestMapping(value="/busevaluation/excel/grg200out")
	  public  ModelAndView grg200out( ExtHtttprequestParam _req) throws Exception {
	      
	      Workbook wb = excelService.selectlist(_req.getParameterMap());
	      String title = "G2.운송원가명세서";
	      return ViewHelper.getExcelDownloadView(wb, title);
	  }
	
	
}
