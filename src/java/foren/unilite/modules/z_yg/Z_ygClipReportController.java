package foren.unilite.modules.z_yg;

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
public class Z_ygClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/Z_yg/";
  final static String            CRF_PATH2           = "Clipreport4/Z_yg/";

  @Resource( name = "s_agj270skr_ygService" )
  private S_Agj270skr_ygServiceImpl s_agj270skr_ygService;
  

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  
  //소즉자료제출집계표
  @RequestMapping(value = "/z_yg/s_agj270clrkr_yg.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView agj270clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();

	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  
	  String sql="";
  	  String acDate  = "";
    
      if(ObjUtils.isNotEmpty(param.get("AC_DATE"))){
    	acDate = ObjUtils.getSafeString(param.get("AC_DATE"));      	
      }
    
  	  String[] arry  = acDate.split(",");
 	  //param.put("AC_DATE"  , arry);
  	  String acData1 = "";
  	  for(String dData : arry)	{
  		  acData1 = acData1+"'"+dData+"',";
  	  }
  	  if(!"".equals(acData1))	{
  		  acData1 = acData1.substring(0, acData1.length()-1);
  		  param.put("AC_DATE"  , acData1);
  	  }
	  
	  String printType = ObjUtils.getSafeString(param.get("PRINT_TYPE"));
	  String printLine = ObjUtils.getSafeString(param.get("PRINT_LINE"));
	  
	  String crfFile = "";
	  
	  List<Map<String, Object>> report_data = null;
	  
	  if("P1".equals(printType)){
		  crfFile = CRF_PATH2 + "s_agj270kr_P1_yg.crf";
		  
		  report_data = s_agj270skr_ygService.selectPrimaryDataList(param);
	  
	  } else if("P2".equals(printType)){
		  crfFile = CRF_PATH2 + "s_agj270kr_P2_yg.crf";
		  
		  report_data = s_agj270skr_ygService.selectPrimaryDataList(param);
	  } else {
		  crfFile = CRF_PATH2 + "s_agj270kr_L1_yg.crf";
		  
		  report_data = s_agj270skr_ygService.selectPrimaryDataList(param);
	  }
	  
	  
	  //String crfFile = CRF_PATH2 + "had910clrkr_1.crf";

	//Image 경로 
	  //String imagePath = doc.getImagePath();

	  //Main Report
	  //List<Map<String, Object>> report_data = had910rkrService.selectToPrintYN(param);
	  
	  ////report_data.get(0).get("ORDER_NUM");
	  
	  //Sub Report use data
	  List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     
	  //Map<String, Object> subReportMap = new HashMap<String ,Object>();
      //subReportMap.put("subReport1", "SQLDS2");
	  
      //List<Map<String, Object>> subReport_data1 = ham910rkrService.ds_sub01(param);
	  //subReportMap.put("REPORT_FILE", "subReport1");
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
