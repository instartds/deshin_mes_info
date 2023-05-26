package foren.unilite.modules.z_sd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class Z_sdClipReportController extends UniliteCommonController {

	final static String	CRF_PATH	= "Clipreport4/Z_sd/";

	@Resource(name = "s_hum970rkr_sdService")
	private S_Hum970rkr_sdServiceImpl s_hum970rkr_sdService;
	
	@Resource(name = "s_hpa902rkr_sdcService")
	private S_Hpa902rkr_sdcServiceImpl s_hpa902rkr_sdcService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@RequestMapping(value = "/human/s_hum970clrkrv_sd.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_hum970clrkrv_sdPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "s_hum970clrkrv_sd.crf";
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = s_hum970rkr_sdService.selectPrintMaster(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("CAREER_DETAIL", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = s_hum970rkr_sdService.selectPrintDetail(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/s_hpa902clrkrv_sdc.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_hpa902clrkrv_sdcPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "s_hpa902clrkrv_sdc.crf";
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = s_hpa902rkr_sdcService.selectPrintList(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("HEADER", "SQLDS2");
		
		List<Map<String, Object>> subReport_data = s_hpa902rkr_sdcService.selectPrintHeader(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		String printHeader01YN = "Y";
		String printHeader02YN = "Y";
		String printHeader03YN = "Y";
		String printHeader04YN = "Y";
		String printHeader05YN = "Y";
		String printHeader06YN = "Y";
		String printHeader07YN = "Y";
		String printHeader08YN = "Y";
		String printHeader09YN = "Y";
		String printHeader10YN = "Y";
		String printHeader11YN = "Y";
		String printHeader12YN = "Y";
		String printHeader13YN = "Y";
		String printHeader14YN = "Y";
		String printHeader15YN = "Y";
		String printHeader16YN = "Y";
		String printHeader17YN = "Y";
		String printHeader18YN = "Y";
		String printHeader19YN = "Y";
		String printHeader30YN = "Y";
		
		if(subReport_data.size() > 0) {
			Map<String, Object> headerParam = subReport_data.get(0);

			if(headerParam.containsKey("S01") && headerParam.get("S01").toString().equals("")) printHeader01YN = "N";
			if(headerParam.containsKey("S02") && headerParam.get("S02").toString().equals("")) printHeader02YN = "N";
			if(headerParam.containsKey("S03") && headerParam.get("S03").toString().equals("")) printHeader03YN = "N";
			if(headerParam.containsKey("S04") && headerParam.get("S04").toString().equals("")) printHeader04YN = "N";
			if(headerParam.containsKey("S05") && headerParam.get("S05").toString().equals("")) printHeader05YN = "N";
			if(headerParam.containsKey("S06") && headerParam.get("S06").toString().equals("")) printHeader06YN = "N";
			if(headerParam.containsKey("S07") && headerParam.get("S07").toString().equals("")) printHeader07YN = "N";
			if(headerParam.containsKey("S08") && headerParam.get("S08").toString().equals("")) printHeader08YN = "N";
			if(headerParam.containsKey("S09") && headerParam.get("S09").toString().equals("")) printHeader09YN = "N";
			if(headerParam.containsKey("S10") && headerParam.get("S10").toString().equals("")) printHeader10YN = "N";
			if(headerParam.containsKey("S11") && headerParam.get("S11").toString().equals("")) printHeader11YN = "N";
			if(headerParam.containsKey("S12") && headerParam.get("S12").toString().equals("")) printHeader12YN = "N";
			if(headerParam.containsKey("S13") && headerParam.get("S13").toString().equals("")) printHeader13YN = "N";
			if(headerParam.containsKey("S14") && headerParam.get("S14").toString().equals("")) printHeader14YN = "N";
			if(headerParam.containsKey("S15") && headerParam.get("S15").toString().equals("")) printHeader15YN = "N";
			if(headerParam.containsKey("S16") && headerParam.get("S16").toString().equals("")) printHeader16YN = "N";
			if(headerParam.containsKey("S17") && headerParam.get("S17").toString().equals("")) printHeader17YN = "N";
			if(headerParam.containsKey("S18") && headerParam.get("S18").toString().equals("")) printHeader18YN = "N";
			if(headerParam.containsKey("S19") && headerParam.get("S19").toString().equals("")) printHeader19YN = "N";
			if(headerParam.containsKey("S20") && headerParam.get("S20").toString().equals("")) printHeader30YN = "N";
		}

		param.put("PRINT_S01_YN", printHeader01YN);
		param.put("PRINT_S02_YN", printHeader02YN);
		param.put("PRINT_S03_YN", printHeader03YN);
		param.put("PRINT_S04_YN", printHeader04YN);
		param.put("PRINT_S05_YN", printHeader05YN);
		param.put("PRINT_S06_YN", printHeader06YN);
		param.put("PRINT_S07_YN", printHeader07YN);
		param.put("PRINT_S08_YN", printHeader08YN);
		param.put("PRINT_S09_YN", printHeader09YN);
		param.put("PRINT_S10_YN", printHeader10YN);
		param.put("PRINT_S11_YN", printHeader11YN);
		param.put("PRINT_S12_YN", printHeader12YN);
		param.put("PRINT_S13_YN", printHeader13YN);
		param.put("PRINT_S14_YN", printHeader14YN);
		param.put("PRINT_S15_YN", printHeader15YN);
		param.put("PRINT_S16_YN", printHeader16YN);
		param.put("PRINT_S17_YN", printHeader17YN);
		param.put("PRINT_S18_YN", printHeader18YN);
		param.put("PRINT_S19_YN", printHeader19YN);
		param.put("PRINT_S30_YN", printHeader30YN);
		
		//String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/s_hum973clrkrv_sdc.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_hum973clrkrv_sdcPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH + "s_hum973clrkrv_sdc.crf";
		
		//Image 경로 
		String imagePath = doc.getImagePath();
		
		//Main Report
		List<Map<String, Object>> report_data = s_hum970rkr_sdService.selectPrintMaster(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


}
