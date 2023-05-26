package foren.unilite.modules.equip.esa;

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
import foren.unilite.modules.equip.esa.Esa101ukrvServiceImpl;

@Controller
public class EsaClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/human/";
  final static String            CRF_PATH2           = "Clipreport4/Sales/";
  
  @Resource( name = "esa101ukrvService" )
  private Esa101ukrvServiceImpl esa101ukrvService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;

  @RequestMapping(value = "/equip/esa101clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView esa101clukrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();

	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  ReportUtils.clipReportLogoPath(param, dao,request);
	  ReportUtils.clipReportSteampPath(param, dao,request);
	  String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));

	//Image 경로 
	  String imagePath = doc.getImagePath();

	  //Main Report
	  List<Map<String, Object>> report_data = esa101ukrvService.mainReport(param);
	  //report_data.get(0).get("ORDER_NUM");
	  //Sub Report use data
	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     
	  Map<String, Object> subReportMap = new HashMap<String ,Object>();
     //subReportMap.put("subReport1", "SQLDS2");
	  List<Map<String, Object>> subReport_data1 = esa101ukrvService.subReport(param);
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
  
}
