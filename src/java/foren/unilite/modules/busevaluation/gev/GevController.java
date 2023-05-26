package foren.unilite.modules.busevaluation.gev;

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
import foren.unilite.modules.busoperate.GopCommonServiceImpl;

import org.springframework.web.servlet.ModelAndView;

@Controller
public class GevController extends UniliteCommonController {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());

	final static String		JSP_PATH	= "/bus_evaluation/gev/";
	
	@Resource(name="gopCommonService")
	private GopCommonServiceImpl comboService;
	
	@Resource(name="gevExcelService")
	private GevExcelServiceImpl excelService;
	
	@RequestMapping(value = "/bus_evaluation/gev120skrv.do", method = RequestMethod.GET)
	public String gev120skrv(String popupID, ExtHtttprequestParam _req, LoginVO loginVO,ListOp listOp, ModelMap model) throws Exception {
		final String[] searchFields = {  };
		NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);
		LoginVO session = _req.getSession();
		Map<String, Object> param = navigator.getParam();
		String page = _req.getP("page");
		
		model.addAttribute("ROUTE_COMBO", comboService.routeCombo(param)); 
		
		return JSP_PATH + "gev120skrv";
	}
	
  @RequestMapping(value="/busevaluation/excel/gev120out")
  public  ModelAndView gev120out( ExtHtttprequestParam _req) throws Exception {
      
      Workbook wb = excelService.selectList(_req.getParameterMap());
      String title = "gev120out";
      return ViewHelper.getExcelDownloadView(wb, title);
  }
	
}
