package foren.unilite.modules.z_hs;

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
public class Z_hsClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/hs/";
  final static String            CRF_PATH2          = "Clipreport4/Z_hs/";

  @Resource( name = "s_agj270rkr_hsService" )
  private S_Agj270rkr_hsServiceImpl s_agj270rkr_hsService;
  
	//20200806 추가: 사원명부출력 (hum950rkr)
	@Resource(name = "s_pmp200rkrv_hsService")
	private S_Pmp200rkrv_hsServiceImpl s_pmp200rkrv_hsService;

	@Resource( name = "s_agb160skr_hsService" )
	private S_Agb160skr_hsServiceImpl s_agb160skr_hsService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  
  //소즉자료제출집계표
  @RequestMapping(value = "/hs/s_agj270clrkr_hs.do", method = {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView s_agj270clrkrPrint_hs(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
	  
	  //세로2장
	  if("P1".equals(printType)){
		  crfFile = CRF_PATH2 + "s_agj270kr_P1_hs.crf";
		  report_data = s_agj270rkr_hsService.selectPrimaryDataList2(param);
		  
	  //세로1장
	  }  else if("P3".equals(printType)){
		  crfFile = CRF_PATH2 + "s_agj270kr_P3_hs.crf";
		  report_data = s_agj270rkr_hsService.selectPrimaryDataList2(param);
		  
	  } 
	  
	  	  
	 //Sub Report use data
	 List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
     
     String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

     Map<String, Object> rMap = new HashMap<String, Object>();
     rMap.put("success", "true");
     rMap.put("resultKey", resultKey);
     return ViewHelper.getJsonView(rMap);
  }
  
  
	@RequestMapping(value = "/hs/s_pmp200clrkr_hs.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp200clrkrPrint_hs( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		
		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		String crfFile = CRF_PATH2 + "s_pmp200rkrv_hs.crf";
		//Image 경로 
		//String imagePath = doc.getImagePath();
		
		String queryString = param.get("QUERY_STRING").toString();
		String[] querys = queryString.split("\\|");
		List<Map<String, Object>> queryParams = new ArrayList<Map<String, Object>>();
		
		for(String query : querys) {
			String[] Els = query.split("\\^");
			Map<String, Object> ElMap = new HashMap<String, Object>();

			if(Els.length >= 1) {	ElMap.put("WKORD_NUM"	, Els[0]);	}	else {	ElMap.put("WKORD_NUM"	, "");	}
			if(Els.length >= 2) {	ElMap.put("ITEM_CODE"	, Els[1]);	}	else {	ElMap.put("ITEM_CODE"	, "");	}
			if(Els.length >= 3) {	ElMap.put("ITEM_NAME"	, Els[2]);	}	else {	ElMap.put("ITEM_NAME"	, "");	}
			if(Els.length >= 4) {	ElMap.put("LOT_NO"		, Els[3]);	}	else {	ElMap.put("LOT_NO"		, "");	}
			if(Els.length >= 5) {	ElMap.put("PACK_QTY"	, Els[4]);	}	else {	ElMap.put("PACK_QTY"	, "1");	}
			if(Els.length >= 6) {	ElMap.put("STOCK_UNIT"	, Els[5]);	}	else {	ElMap.put("STOCK_UNIT"	, "");	}
			if(Els.length >= 7) {	ElMap.put("START_NUM"	, Els[6]);	}	else {	ElMap.put("START_NUM"	, "1");	}
			if(Els.length >= 8) {	ElMap.put("END_NUM"		, Els[7]);	}	else {	ElMap.put("END_NUM"		, "0");	}
			if(Els.length >= 9) {	ElMap.put("PRINT_QTY"	, Els[8]);	}	else {	ElMap.put("PRINT_QTY"	, "0");	}
			
			queryParams.add(ElMap);
		}
		
		param.put("QUERY_PARAMS", queryParams);

		List<Map<String, Object>> report_data	= s_pmp200rkrv_hsService.selectPrint(param);
		//List<Map<String, Object>> report_data	= null;
		
		//sub report 있을 때 사용
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 미결현황출력 (agb160rkr)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_hs/s_agb160clrkrPrint.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_agb160clrkrPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + "s_agb160clrkrv_hs.crf";
		//Image 경로 
		String imagePath = doc.getImagePath();

		if(ObjUtils.isNotEmpty(param.get("ACCNT_DIV_CODE"))) {
			List divList		= new ArrayList();
			String[] divCodes	= param.get("ACCNT_DIV_CODE").toString().split(",");
			for(String divCode : divCodes) {
				divList.add(divCode);
			}
			param.put("ACCNT_DIV_CODE", divList);
		}

		List<Map<String, Object>> report_data = s_agb160skr_hsService.fnAgb160QRpt(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

}
