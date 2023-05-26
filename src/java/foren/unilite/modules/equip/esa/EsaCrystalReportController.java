package foren.unilite.modules.equip.esa;

import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class EsaCrystalReportController extends UniliteCommonController {
	 @InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Sales";
	 
	 @Resource(name = "tlabAbstractDAO")
	 protected TlabAbstractDAO dao;
	 
	 @RequestMapping(value = "/sales/esa100crkrv.do", method = RequestMethod.GET)
	 public ModelAndView esa100crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
        CrystalReportDoc cDoc = new CrystalReportDoc();
        CrystalReportFactory clientDoc = null;
        Map<String, Object> param = _req.getParameterMap();
        SimpleDateFormat matter1=new SimpleDateFormat("yyyy-MM-dd");
        String str = matter1.format(new Date()); 
        Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

        ReportUtils.setCreportPram(user, param, dao);
        ReportUtils.setCreportSanctionParam(param, dao);
	      
        String aa= (String) param.get("FR_DATE");
        String bb= (String) param.get("TO_DATE");
        if(aa==null || bb==null){
            param.put("FrToDate", "");
        }else{
            String farDate = param.get("FR_DATE").toString();
            String toDate = param.get("TO_DATE").toString();
            String cc = farDate.substring(0, 4) +"."+ farDate.substring(4, 6)+"."+ farDate.substring(6, 8);
            String dd = toDate.substring(0, 4) +"." + toDate.substring(4, 6)+"." + toDate.substring(6, 8);
            String farToD = cc + "~" + dd;
            param.put("FrToDate", farToD);
        }
        
	      
/*	      //PT_OUTPUTDATE_YN  PT_OUTPUTDATE PT_PAGENUM_YN PT_TITLENAME PT_SANCTION_YN PT_COMPANY_YN
	      //회사명인쇄여부
	      if(ObjUtils.getSafeString(param.get("PT_COMPANY_YN")).equals("Y")){
	    	  param.put("5 sChkValue1_company", user.getCompName());
	      }
	      //페이지인쇄여부
	      if(ObjUtils.getSafeString(param.get("PT_PAGENUM_YN")).equals("Y")){
	    	  param.put("6 sChkValue2_page", "TRUE");
	      }else{
	    	  param.put("6 sChkValue2_page", "FALSE");
	      }
	      //결재란인쇄여부
	      if(ObjUtils.getSafeString(param.get("PT_SANCTION_YN")).equals("Y")){
	    	  param.put("7 sChkValue3_decide", "TRUE");
	      }else{
	    	  param.put("7 sChkValue3_decide", "FALSE");
	      }
	      //출력일인쇄여부
	      if(ObjUtils.getSafeString(param.get("PT_OUTPUTDATE_YN")).equals("Y")){
	    	  param.put("8 sChkValue4_printDate", "TRUE");
	      }else{
	    	  param.put("8 sChkValue4_printDate", "FALSE");
	      }
	      
	      
	      param.put("sFrToDt", ObjUtils.getSafeString(param.get("FR_DATE")) + "~" + ObjUtils.getSafeString(param.get("TO_DATE")));
	      
	      //출력일자변경 || 출력일
	      if(null == param.get("PT_OUTPUTDATE") 
	    		  || "".equals(ObjUtils.getSafeString(param.get("PT_OUTPUTDATE")))){
	    	  param.put("sReportDt", "");
	      }else{
	    	  param.put("sReportDt", param.get("PT_OUTPUTDATE"));
	      }
	      //보고서제목변경 || 제목
	      if(null == param.get("PT_TITLENAME") 
	    		  || "".equals(ObjUtils.getSafeString(param.get("PT_TITLENAME")))){
	    	  param.put("sTitle", "");
	      }else{
	    	  param.put("sTitle", param.get("PT_TITLENAME"));
	      }
	      
	      //출력자
	      param.put("USER_NAME", user.getUserName());
	      */
	      String sql="";
	      try{
	          sql = dao.mappedSqlString("esa100rkrvServiceImpl.printList", param);
	          List subReports = new ArrayList();
              /**
             * 결재란관련     san_top_sub.rpt
             */
            Map<String, String> subMap = new HashMap<String, String>();
            subMap.put("NAME", "san_top_sub.rpt");
            subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
            subReports.add(subMap);
	          clientDoc = cDoc.generateReport(RPT_PATH+"/esa100rkrv", "esa100rkrv", param,  sql,subReports, request);
	      }catch (Throwable e2) {
	          e2.getStackTrace();
	      }
	      clientDoc.setPrintFileName("esa100crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
		@RequestMapping(value = "/equit/esa110crkrv.do", method = RequestMethod.GET)
		public ModelAndView esa110crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
				@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
				HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			ReportUtils.setCreportSanctionParam(param, dao);
			
			String aa= (String) param.get("FR_DATE");
	        String bb= (String) param.get("TO_DATE");
	        if(aa==null || bb==null){
	            param.put("FrToDate", "");
	        }else{
	            String farDate = param.get("FR_DATE").toString();
	            String toDate = param.get("TO_DATE").toString();
	            String cc = farDate.substring(0, 4) +"."+ farDate.substring(4, 6)+"."+ farDate.substring(6, 8);
	            String dd = toDate.substring(0, 4) +"." + toDate.substring(4, 6)+"." + toDate.substring(6, 8);
	            String farToD = cc + "~" + dd;
	            param.put("FrToDate", farToD);
	        }
			
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("esa110rkrvServiceImpl.printList", param);
				List subReports = new ArrayList(); 
				/**
	             * 결재란관련     san_top_sub.rpt
	             */
	            Map<String, String> subMap = new HashMap<String, String>();
	            subMap.put("NAME", "san_top_sub.rpt");
	            subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	            subReports.add(subMap);
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,null, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("esa110crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
}
