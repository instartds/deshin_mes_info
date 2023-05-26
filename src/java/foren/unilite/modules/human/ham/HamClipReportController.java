package foren.unilite.modules.human.ham;

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
import foren.unilite.modules.human.had.Had421rkrServiceImpl;
import foren.unilite.modules.human.had.Had840rkrServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class HamClipReportController extends UniliteCommonController {
	@InjectLogger
	public static Logger logger;
	final static String CRF_PATH	= "/clipreport4/crf/human/";
	final static String CRF_PATH2	= "Clipreport4/Human/";

	@Resource( name = "ham910rkrService" )
	private Ham910rkrServiceImpl ham910rkrService;

	@Resource( name = "ham800ukrService" )					//20200706 추가
	private Ham800ukrServiceImpl ham800ukrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	//소즉자료제출집계표
	@RequestMapping(value = "/human/ham910clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView ham910clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String rptType = ObjUtils.getSafeString(param.get("DOC_KIND"));
		String crfFile = "";
		List<Map<String, Object>> report_data = null;
		
		//연말정산, 중도퇴사
		if("1".equals(rptType) || "2".equals(rptType)){
			crfFile = CRF_PATH2 + "ham910clrkr_2.crf";
			report_data = ham910rkrService.fnHam911nQ_2(param);
		//퇴직정산
		} else {
			crfFile = CRF_PATH2 + "ham910clrkr_1.crf";
			report_data = ham910rkrService.fnHam911nQ_2(param);
		}
		//String crfFile = CRF_PATH2 + "had910clrkr_1.crf";

		//Image 경로 
		//String imagePath = doc.getImagePath();

		//Main Report
		//List<Map<String, Object>> report_data = had910rkrService.selectToPrintYN(param);
		
		////report_data.get(0).get("ORDER_NUM");
		
		//Sub Report use data
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
	 
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("subReport1", "SQLDS2");
		
		List<Map<String, Object>> subReport_data1 = ham910rkrService.ds_sub01(param);
		subReportMap.put("REPORT_FILE", "subReport1");
		subReportMap.put("DATA_SET", "SQLDS2"); 
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}


	/**
	 * 일용직급여등록 (ham800ukr) - 일용근로지급명세서(1), 일용근로소득집계표(2) 출력: 20200706 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/ham800clukrv.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView ham800clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		String crfFile		= "";
		String printGubun	= ObjUtils.getSafeString(param.get("PRINT_GUBUN"));

		ReportUtils.setCreportPram(user				, param, dao);
		ReportUtils.setCreportSanctionParam(param	, dao);
		ReportUtils.clipReportLogoPath(param		, dao, request);
		ReportUtils.clipReportSteampPath(param		, dao, request);

		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		//일용근로지급명세서(1)
		if("1".equals(printGubun)){
			crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//일용근로소득집계표(2)
		} else {
			crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID6"));
		}
		List<Map<String, Object>> report_data = ham800ukrService.fnPrintData(param);

		//서브리포트 있을 때 사용
//		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
//		Map<String, Object> subReportMap = new HashMap<String ,Object>();
//		subReportMap.put("ham800UKRV", "SQLDS2");
//
//		List<Map<String, Object>> subReport_data = ham800ukrvService.fnPrintData(param);
//		subReportMap.put("SUB_DATA", subReport_data);
//		subReports.add(subReportMap);
//		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS1", param, report_data, subReports, request);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}