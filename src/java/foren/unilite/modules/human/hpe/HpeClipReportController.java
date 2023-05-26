package foren.unilite.modules.human.hpe;

import java.util.ArrayList;
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
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class HpeClipReportController extends UniliteCommonController {

	final static String	CRF_PATH	= "Clipreport4/human/";

	@Resource(name = "hpe600rkrService")
	private Hpe600rkrServiceImpl hpe600rkrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@RequestMapping(value = "/human/hpe600clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpe600clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String resultKey = "";

		//Image 경로 
		String imagePath = doc.getImagePath();
		
		if(param.containsKey("PRINT_TYPE") && param.get("PRINT_TYPE").equals("2")) {
			crfFile = CRF_PATH + "hpe600clrkrv_2.crf";
			//Main Report
			List<Map<String, Object>> report_data = hpe600rkrService.selectBusiPayLiveInMaster(param);
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = hpe600rkrService.selectBusiPayLiveInDetail(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}
		else if(param.containsKey("PRINT_TYPE") && param.get("PRINT_TYPE").equals("3")) {
			crfFile = CRF_PATH + "hpe600clrkrv_3.crf";
			//Main Report
			List<Map<String, Object>> report_data = hpe600rkrService.selectBusiPayLiveOutMaster(param);
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = hpe600rkrService.selectBusiPayLiveOutDetail(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}
		else {
			crfFile = CRF_PATH + "hpe600clrkrv_1.crf";
			//Main Report
			List<Map<String, Object>> report_data = hpe600rkrService.selectWorkPayPrintMaster(param);
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");
			
			List<Map<String, Object>> subReport_data = hpe600rkrService.selectWorkPayPrintDetail(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

}
