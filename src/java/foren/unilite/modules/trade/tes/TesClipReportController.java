package foren.unilite.modules.trade.tes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.framework.logging.InjectLogger;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class TesClipReportController  extends UniliteCommonController {
	public static Logger logger;
	
	final static String CRF_PATH	= "Clipreport4/Trade/";
	final static String CRF_PATH2	= "/clipreport4/crf/trade/";
	
	//packing list 클립레포트 - 20201216 추가
	@Resource( name = "tes100ukrvService" )
	private Tes100ukrvServiceImpl tes100ukrvService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@RequestMapping(value = "/trade/tes100clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView tes100clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "tes100clrkr1.crf";
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = tes100ukrvService.selectList(param);
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/trade/tes100clrkrPrint2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView tes100clrkrPrint2(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "tes100clrkr2.crf";
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = tes100ukrvService.selectList2(param);
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}