package foren.unilite.modules.human.had;

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

@Controller
public class HadClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/human/";
  final static String            CRF_PATH2           = "Clipreport4/Human/";

  @Resource( name = "had421rkrService" )
  private Had421rkrServiceImpl had421rkrService;
  
  @Resource( name = "had840rkrService" )
  private Had840rkrServiceImpl had840rkrService;
  
  @Resource( name = "had910rkrService" )
  private Had910rkrServiceImpl had910rkrService;

  @Resource( name = "had850rkrService" )
  private Had850rkrServiceImpl had850rkrService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  @RequestMapping(value = "/human/had421clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView had421clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();

	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + "had421clrkr.crf";

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = had421rkrService.selectListToPrint(param);
	  //report_data.get(0).get("ORDER_NUM");
	  //Sub Report use data
	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     
	  Map<String, Object> subReportMap = new HashMap<String ,Object>();
     //subReportMap.put("subReport1", "SQLDS2");
	  List<Map<String, Object>> subReport_data1 = had421rkrService.selectListToPrintSub1(param);
	  subReportMap.put("REPORT_FILE", "subReport2");
	  subReportMap.put("DATA_SET", "SQLDS2"); 
	  subReportMap.put("SUB_DATA", subReport_data1);
	  subReports.add(subReportMap);
     
	  Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
	  //subReportMap2.put("subReport2", "SQLDS3");
	  List<Map<String, Object>> subReport_data2 = had421rkrService.selectListToPrintSub2(param);
	  subReportMap2.put("REPORT_FILE", "subReport1");
	  subReportMap2.put("DATA_SET", "SQLDS3"); 
	  subReportMap2.put("SUB_DATA", subReport_data2);
	  subReports.add(subReportMap2);
     

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }
  
  @RequestMapping(value = "/human/had840clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView had840clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();

	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + "had840clrkr.crf";

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //로고, 스탬프 패스 추가
	  ReportUtils.clipReportLogoPath(param, dao, request);
	  ReportUtils.clipReportSteampPath(param, dao, request);
	  
	  //param.put("steampImagePath", "C:\\OmegaPlus\\upload\\sdc\\clipreport4\\images\\company_steamp.png");  ;
	  
	  //Main Report
	  List<Map<String, Object>> report_data = had840rkrService.selectList2018_Query1(param);
	  //report_data.get(0).get("ORDER_NUM");
	  //Sub Report use data
	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     
	  Map<String, Object> subReportMap = new HashMap<String ,Object>();
     //subReportMap.put("subReport1", "SQLDS2");
	  List<Map<String, Object>> subReport_data1 = had840rkrService.selectList2018_Query2(param);
	  subReportMap.put("REPORT_FILE", "subReport2");
	  subReportMap.put("DATA_SET", "SQLDS2"); 
	  subReportMap.put("SUB_DATA", subReport_data1);
	  subReports.add(subReportMap);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

	@RequestMapping(value = "/human/had840clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView had840clrkr2019Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		
		//Image 경로 
		String imagePath = doc.getImagePath();

		//로고, 스탬프 패스 추가
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		
		//Main Report
		List<Map<String, Object>> report_data = new ArrayList<Map<String, Object>>();
		
		//Sub Report use data
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		
		List<Map<String, Object>> subReport_data1 = new ArrayList<Map<String, Object>>();
		

		if (param.get("YEAR_YYYY").equals("2019")) {
			crfFile = CRF_PATH2 + "had840clrkr_2019.crf";
			
			report_data		= had840rkrService.selectList2019_Query1(param);
			subReport_data1 = had840rkrService.selectList2019_Query2(param);
		}
		else {
			crfFile = CRF_PATH2 + "had840clrkr_2020.crf";
			
			report_data		= had840rkrService.selectList2020_Query1(param);
			subReport_data1 = had840rkrService.selectList2020_Query2(param);
		}
		
		subReportMap.put("REPORT_FILE", "subReport2");
		subReportMap.put("DATA_SET", "SQLDS2"); 
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/had850clrkr2020.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView had850clrkr2020Print(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + "had850clrkrv2020.crf";

		//Image 경로 
		String imagePath = doc.getImagePath();

		//로고, 스탬프 패스 추가
		ReportUtils.clipReportLogoPath(param, dao, request);
		ReportUtils.clipReportSteampPath(param, dao, request);
		
		//Main Report
		List<Map<String, Object>> report_data = had850rkrService.selectList2020Clip(param);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		
		return ViewHelper.getJsonView(rMap);
	}

  //소즉자료제출집계표
  @RequestMapping(value = "/human/had910clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView had910clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();

	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  
	  String rptType = ObjUtils.getSafeString(param.get("RETR_TYPE"));
	  String crfFile = "";
	  
	  List<Map<String, Object>> report_data = null;
	  
	  //연말정산, 중도퇴사
	  if("Y".equals(rptType) || "N".equals(rptType)){
		  crfFile = CRF_PATH2 + "had910clrkr_1.crf";
		  
		  report_data = had910rkrService.selectToPrintYN(param);
	  
	  //퇴직정산
	  } else if("R".equals(rptType)){
		  crfFile = CRF_PATH2 + "had910clrkr_2.crf";
		  
		  report_data = had910rkrService.selectToPrintR(param);
		  
	  //사업소득, 기타소득, 이자소득, 배당소득
	  } else {
		  crfFile = CRF_PATH2 + "had910clrkr_3.crf";
		  
		  report_data = had910rkrService.selectToPrintOther(param);
	  }
	  
	  
	  //String crfFile = CRF_PATH2 + "had910clrkr_1.crf";

	//Image 경로 
	  //String imagePath = doc.getImagePath();

	  //Main Report
	  //List<Map<String, Object>> report_data = had910rkrService.selectToPrintYN(param);
	  
	  ////report_data.get(0).get("ORDER_NUM");
	  
	  //Sub Report use data
	  //List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     
	  Map<String, Object> subReportMap = new HashMap<String ,Object>();
     //subReportMap.put("subReport1", "SQLDS2");
	  //List<Map<String, Object>> subReport_data1 = had840rkrService.selectList2018_Query2(param);
	  //subReportMap.put("REPORT_FILE", "subReport2");
	  //subReportMap.put("DATA_SET", "SQLDS2"); 
	  //subReportMap.put("SUB_DATA", subReport_data1);
	  //subReports.add(subReportMap);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }
  
}
