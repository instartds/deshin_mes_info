package foren.unilite.modules.matrl.mtr;

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
import foren.unilite.modules.matrl.mtr.Mtr202ukrvServiceImpl;
import foren.unilite.modules.matrl.mtr.Mtr260skrvServiceImpl;


@Controller
public class MtrClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/human/";
  final static String            CRF_PATH2           = "Clipreport4/Matrl/";

  @Resource( name = "mtr202ukrvService" )
  private Mtr202ukrvServiceImpl mtr202ukrvService;

  @Resource( name = "mtr260skrvService" )
  private Mtr260skrvServiceImpl mtr260skrvService;

  @Resource( name = "mtr280skrvService" )
  private Mtr280skrvServiceImpl mtr280skrvService;

  @Resource( name = "mtr250skrvService" )
  private Mtr250skrvServiceImpl mtr250skrvService;

  @Resource( name = "mtr290skrvService" )
  private Mtr290skrvServiceImpl mtr290skrvService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  @RequestMapping(value = "/matrl/mtr202clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
   public ModelAndView mtr202clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = mtr202ukrvService.printList(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
      String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

      Map<String, Object> rMap = new HashMap<String, Object>();
      rMap.put("success", "true");
      rMap.put("resultKey", resultKey);
      return ViewHelper.getJsonView(rMap);
   }

  @RequestMapping(value = "/matrl/mtr260clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView mtr260clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = mtr260skrvService.mainReport(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
	  Map<String, Object> subReportMap = new HashMap<String ,Object>();
	  List<Map<String, Object>> subReport_data1 = mtr260skrvService.subReport(param);
	  subReportMap.put("REPORT_FILE", "mtr260clskrv_sub");
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

  @RequestMapping(value = "/matrl/mtr280clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView mtr280clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));
	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = mtr280skrvService.mainReport(param);

	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
	  Map<String, Object> subReportMap = new HashMap<String ,Object>();
	  List<Map<String, Object>> subReport_data1 = mtr280skrvService.subReport(param);
	  subReportMap.put("REPORT_FILE", "mtr280clskrv_sub");
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

  @RequestMapping(value = "/mtr/mtr250clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView mtr250clskrv(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();
	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  String sDivCode = (String) param.get("DIV_CODE");
	  String crfFile = null;
		if( sDivCode.equals("01")){//사업장이 김천일 경우
			crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));
		}else if(sDivCode.equals("02")){//사업장이 화성일 경우
			crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID2"));
		}else{// 그외
			crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));
		}


	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = mtr250skrvService.printList(param);

	  //String resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, subReports, request);
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }

  /**
	 * 외주 출고 거래명세서 2장 (mtr290clskrv)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mtr/mtr290clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mtr290clskrv(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2+ ObjUtils.getSafeString(param.get("RPT_ID1"));

		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = mtr290skrvService.clipselect(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("MTR290SKRV_2_01", "SQLDS2");
		subReportMap.put("MTR290SKRV_2_02", "SQLDS2");

		List<Map<String, Object>> subReport_data = mtr290skrvService.clipselectsub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
