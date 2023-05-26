package foren.unilite.modules.accnt.agc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

@Controller
public class AgcClipReportController extends UniliteCommonController {

	final static String	CRF_PATH	= "Clipreport4/Accnt/";
	final static String	CRF_PATH2	= "/clipreport4/crf/accnt/";

	@Resource( name = "agc100rkrService" )
	private Agc100rkrServiceImpl agc100rkrService;

	@Resource( name = "agc110rkrService" )
	private Agc110rkrServiceImpl agc110rkrService;

	@Resource( name = "agc130rkrService" )
	private Agc130rkrServiceImpl agc130rkrService;

	@Resource( name = "agc140rkrService" )
	private Agc140rkrServiceImpl agc140rkrService;

	@Resource( name = "agc150rkrService" )
	private Agc150rkrServiceImpl agc150rkrService;

	@Resource( name = "agc160rkrService" )
	private Agc160rkrServiceImpl agc160rkrService;

	@Resource( name = "agc170rkrService" )
	private Agc170rkrServiceImpl agc170rkrService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@RequestMapping(value = "/accnt/agc100clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc100clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = agc100rkrService.selectList1(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agc110clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc110clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = agc110rkrService.selectList(param);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agc130clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc130clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		
		if(param.get("PAGE_TYPE").equals("1")) {
			crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID6"));
		}
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = agc130rkrService.selectList(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agc140clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc140clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = agc140rkrService.selectList(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agc150clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc150clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = agc150rkrService.selectList(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agc160clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc160clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = agc160rkrService.selectList(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/accnt/agc170clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView agc170clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = agc170rkrService.selectList(param, user);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

}
