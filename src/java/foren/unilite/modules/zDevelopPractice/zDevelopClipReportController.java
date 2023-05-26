package foren.unilite.modules.zDevelopPractice;

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
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.human.ham.Ham910rkrServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class zDevelopClipReportController extends UniliteCommonController {
	final static String	CRF_PATH	= "Clipreport4/ZZ_dev/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "zDevelopPracticeService" )
	private zDevelopPracticeServiceImpl zDevelopPracticeService;


	/**
	 * 출력연습1 - 20210409
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/practiceClip1.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView practiceClip1Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = zDevelopPracticeService.selectList(param);

		//Sub Report use data
//		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

//		List<Map<String, Object>> subReport_data1 = zDevelopPracticeServiceImpl.selectList2(param);
//		subReportMap.put("DATA_SET", "SQLDS2");
//		subReportMap.put("SUB_DATA", subReport_data1);
//		subReports.add(subReportMap);

//		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	/**
	 * 출력연습3 - 20210409
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/base/practiceClip3.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView practiceClip3Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = zDevelopPracticeService.print1(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		List<Map<String, Object>> subReport_data1 = zDevelopPracticeService.print2(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
//		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	

	
}