package foren.unilite.modules.accnt.agj;

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

@Controller
public class AgjClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/accnt/";
  final static String            CRF_PATH2          = "Clipreport4/Accnt/";

  @Resource( name = "agj270rkrService" )
  private Agj270rkrServiceImpl agj270rkrService;
  
  @Resource( name = "agj400ukrService" )
  private Agj400ukrServiceImpl agj400ukrService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  
  //소즉자료제출집계표
  @RequestMapping(value = "/accnt/agj270clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView agj270clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	  ClipReportDoc doc = new ClipReportDoc();

	  Map param = _req.getParameterMap();

	  ReportUtils.setCreportPram(user, param, dao);
	  ReportUtils.setCreportSanctionParam(param, dao);
	  
  	  Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
  	  List<String> slipnumLite = new ArrayList<String>();
  	  String sql="";
  	  String acDate  = "";
  	  String acDate2  = "";
  	  String slipnum = "";
  	  
  	  if(ObjUtils.isNotEmpty(param.get("AC_DATE"))){
    	acDate2 = ObjUtils.getSafeString(param.get("AC_DATE"));      	
      }
      if(ObjUtils.isNotEmpty(param.get("FR_AC_DATE"))){
    	acDate = ObjUtils.getSafeString(param.get("FR_AC_DATE"));      	
      }
      if(ObjUtils.isNotEmpty(param.get("FR_SLIP_NUM"))){
    	slipnum = ObjUtils.getSafeString(param.get("FR_SLIP_NUM"));      	
      }
      
      String[] arry1  = acDate2.split(",");
  	  String[] arry  = acDate.split(",");
  	  String[] arry2 = slipnum.split(",");
  	  for(int i = 0 ; i < arry2.length ; i++){
  		slipnumLite.add(arry2[i]); 
  		
  	  }
  	 param.put("AC_DATE"  , arry1);
 	 param.put("FR_AC_DATE"  , arry[0]);
 	 param.put("FR_SLIP_NUM", slipnumLite);
	  
//	  String sql="";
//  	  String acDate  = "";
//    
//      if(ObjUtils.isNotEmpty(param.get("AC_DATE"))){
//    	acDate = ObjUtils.getSafeString(param.get("AC_DATE"));      	
//      }
    
//  	  String[] arry  = acDate.split(",");

//  	  String acData1 = "";
//  	  for(String dData : arry)	{
//  		  acData1 = acData1+"'"+dData+"',";
//  	  }
//  	  if(!"".equals(acData1))	{
//  		  acData1 = acData1.substring(0, acData1.length()-1);
//  		  param.put("AC_DATE"  , acData1);
//  	  }
	  
	  String printType = ObjUtils.getSafeString(param.get("PRINT_TYPE"));
	  String printLine = ObjUtils.getSafeString(param.get("PRINT_LINE"));
	  
	  String crfFile = "";
	  
	  List<Map<String, Object>> report_data = null;
	  
	  //세로2장, 귀속(부서사업장)보이기
	  if("P1".equals(printType)){
		  crfFile = CRF_PATH2 + "agj270kr_P1.crf";
		  report_data = agj270rkrService.selectPrimaryDataList2(param);
		  
	  //세로2장, 귀속(부서사업장)숨기기
	  } else if("P2".equals(printType)){
		  crfFile = CRF_PATH2 + "agj270kr_P2.crf";
		  report_data = agj270rkrService.selectPrimaryDataList2(param);
		  
	  } else if("P3".equals(printType)){
		  crfFile = CRF_PATH2 + "agj270kr_P3.crf";
		  report_data = agj270rkrService.selectPrimaryDataList2(param);
		  
	  } else if("P4".equals(printType)){
		  crfFile = CRF_PATH2 + "agj270kr_P4.crf";
		  report_data = agj270rkrService.selectPrimaryDataList2(param);
		  
	  } else if("L1".equals(printType)){
		  crfFile = CRF_PATH2 + "agj270kr_L1.crf";
		  report_data = agj270rkrService.selectPrimaryDataList2(param);
		  
	  } else if("L2".equals(printType)){
		  crfFile = CRF_PATH2 + "agj270kr_L2.crf";
		  report_data = agj270rkrService.selectPrimaryDataList2(param);
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
  
  	@RequestMapping(value = "/accnt/agj400clukrv.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView s_mms200clukrv_wm(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH2 + "agj400clukr.crf";
		//Image 경로 
//		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = agj400ukrService.selectPrintMaster(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = agj400ukrService.selectPrintDetail(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
