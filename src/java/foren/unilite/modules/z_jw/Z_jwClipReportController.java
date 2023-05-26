package foren.unilite.modules.z_jw;

import java.sql.ResultSet;
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
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.str.Str800ukrvServiceImpl;
import foren.unilite.modules.z_jw.S_mms510ukrv_jwServiceImpl;
import foren.unilite.modules.z_jw.S_otr120ukrv_jwServiceImpl;
import foren.unilite.modules.z_jw.S_pmr100ukrv_jwServiceImpl;
import foren.unilite.modules.z_jw.S_pmp130rkrv_jwServiceImpl;
import foren.unilite.modules.z_jw.S_pmp101ukrv_jwServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_jwClipReportController	extends UniliteCommonController {
 @InjectLogger
	public static Logger logger;
	//final static String			CRF_PATH	= "/clipreport4/crf/human/";
	final static String				CRF_PATH2	= "Clipreport4/Z_jw/";

	@Resource( name = "s_mms510ukrv_jwService" )
	private S_mms510ukrv_jwServiceImpl s_mms510ukrv_jwService;
	
	@Resource( name = "s_otr120ukrv_jwService" )
	private S_otr120ukrv_jwServiceImpl s_otr120ukrv_jwService;
	
	@Resource( name = "s_pmr100ukrv_jwService" )
	private S_pmr100ukrv_jwServiceImpl s_pmr100ukrv_jwService;

	@Resource( name = "s_mpo501ukrv_jwService" )
	private S_mpo501ukrv_jwServiceImpl s_mpo501ukrv_jwService;

	@Resource( name = "s_mpo150rkrv_jwService" )
	private S_mpo150rkrv_jwServiceImpl s_mpo150rkrv_jwService;
	
	@Resource( name = "s_pmp130rkrv_jwService" )
	private S_pmp130rkrv_jwServiceImpl s_pmp130rkrv_jwService;
	
	@Resource( name = "s_pmp101ukrv_jwService" )
	private S_pmp101ukrv_jwServiceImpl s_pmp101ukrv_jwService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	@RequestMapping(value = "/z_jw/s_mms510clukrv_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_mms510clukrv_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		List itemCodeList = new ArrayList();
		List lotNoList = new ArrayList();
		List whCodeList = new ArrayList();
		
		String[] itemCodes = param.get("ITEM_CODE").toString().split(",");
		String[] lotNos = param.get("LOT_NO").toString().split(",");
		String[] whCodes = param.get("WH_CODE").toString().split(",");
		
		for(String itemcode : itemCodes) {
			itemCodeList.add(itemcode);
		}
		for(String lotno : lotNos) {
			lotNoList.add(lotno);
		}
		for(String whcode : whCodes) {
			whCodeList.add(whcode);
		}
		param.put("ITEM_CODE", itemCodeList);
		param.put("LOT_NO", lotNoList);
		param.put("WH_CODE", whCodeList);
		logger.debug("[param]" + param);
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
	 // List<Map<String, Object>> report_data = str800ukrvService.selectPrintList(param);
		List<Map<String, Object>> report_data = s_mms510ukrv_jwService.selectClipList(param);
		//List<Map<String, Object>> report_data = null;
		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_otr120clukrv_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_otr120clukrv_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		List itemCodeList = new ArrayList();
		List lotNoList = new ArrayList();
		List whCodeList = new ArrayList();
		
		String[] itemCodes = param.get("ITEM_CODE").toString().split(",");
		String[] lotNos = param.get("LOT_NO").toString().split(",");
		String[] whCodes = param.get("WH_CODE").toString().split(",");
		
		for(String itemcode : itemCodes) {
			itemCodeList.add(itemcode);
		}
		for(String lotno : lotNos) {
			lotNoList.add(lotno);
		}
		for(String whcode : whCodes) {
			whCodeList.add(whcode);
		}
		param.put("ITEM_CODE", itemCodeList);
		param.put("LOT_NO", lotNoList);
		param.put("WH_CODE", whCodeList);
		logger.debug("[param]" + param);
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
	 // List<Map<String, Object>> report_data = str800ukrvService.selectPrintList(param);
		List<Map<String, Object>> report_data = s_otr120ukrv_jwService.selectClipList(param);
		//List<Map<String, Object>> report_data = null;
		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_pmr100clukrv_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmr100clukrv_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		List itemCodeList = new ArrayList();
		List lotNoList = new ArrayList();
		
		String[] itemCodes = param.get("PRODT_NUM").toString().split(",");
		String[] lotNos = param.get("PROG_WORK_CODE").toString().split(",");

		for(String itemcode : itemCodes) {
			itemCodeList.add(itemcode);
		}
		for(String lotno : lotNos) {
			lotNoList.add(lotno);
		}

		param.put("PRODT_NUM", itemCodeList);
		param.put("PROG_WORK_CODE", lotNoList);

		logger.debug("[param]" + param);
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"))+".crf";
	//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
	 // List<Map<String, Object>> report_data = str800ukrvService.selectPrintList(param);
		List<Map<String, Object>> report_data = s_pmr100ukrv_jwService.selectClipList(param);
		//List<Map<String, Object>> report_data = null;
		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_pmr100clukrv2_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmr100clukrv2_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID2"))+".crf";;

		  //Main Report
		  List<Map<String, Object>> report_data = s_pmr100ukrv_jwService.printList2(param);
		  
		  //Sub Report use data
		  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
	     Map<String, Object> subReportMap = new HashMap<String ,Object>();
	     subReportMap.put("subReport1", "SQLDS2");
	     subReportMap.put("subReport2", "SQLDS2");

	    List<Map<String, Object>> subReport_data = s_pmr100ukrv_jwService.printList2(param);
	     subReportMap.put("SUB_DATA", subReport_data);
	     subReports.add(subReportMap);

		  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
	     String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);
		

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_mpo501clukrv_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_mpo501clukrv_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";;

	    List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> report_data = s_mpo501ukrv_jwService.mainReport(param);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_mpo150clrkrv_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_mpo150clrkrv_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1")) + ".crf";;

	    List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> report_data = s_mpo150rkrv_jwService.mainReport(param);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_pmp130rkrv1_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp130rkrv1_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));

		List<Map<String, Object>> report_data = s_pmp130rkrv_jwService.printList1(param);
	    
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
	     subReportMap.put("s_pmp130rkrv_jw_sub1", "SQLDS2");

	    List<Map<String, Object>> subReport_data = s_pmp130rkrv_jwService.subPrintList1(param);
	     subReportMap.put("SUB_DATA", subReport_data);
	     subReports.add(subReportMap);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_pmp130rkrv2_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp130rkrv2_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID4"));

	    List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> report_data = s_pmp130rkrv_jwService.printList2(param);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/z_jw/s_pmp101clrkrv_jw.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp101rkrv_jwPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));

		List<Map<String, Object>> report_data = s_pmp101ukrv_jwService.printList(param);
	    
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
	     subReportMap.put("s_pmp130rkrv_jw_sub1", "SQLDS2");

	    List<Map<String, Object>> subReport_data = s_pmp101ukrv_jwService.subPrintList(param);
	     subReportMap.put("SUB_DATA", subReport_data);
	     subReports.add(subReportMap);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
