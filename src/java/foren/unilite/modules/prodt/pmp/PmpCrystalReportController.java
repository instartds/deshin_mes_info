package foren.unilite.modules.prodt.pmp;

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
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class PmpCrystalReportController  extends UniliteCommonController {
	@InjectLogger
    public static Logger logger;
	final static String            RPT_PATH           = "/WEB-INF/Reports2011/Prodt";
	final static String            RPT_PATH_JW           = "/WEB-INF/Reports2011/Z_jw";
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@RequestMapping(value = "/prodt/pmp220crkrv.do", method = RequestMethod.GET)
	 public ModelAndView pmp220crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map<String, Object> param = _req.getParameterMap();
	      ReportUtils.setCreportPram(user, param,dao);
	      ReportUtils.setCreportSanctionParam(param, dao);
	      String sql="";
	      try{
	    	  
	    	  if(ObjUtils.getSafeString(param.get("opt")).equals("1")){
	    		  sql = dao.mappedSqlString("pmp220rkrvServiceImpl.printList", param);		//출고요청번호별
	    	  }else{
	    		  sql = dao.mappedSqlString("pmp220rkrvServiceImpl.printList2", param);		//품목합계별
	    	  }
	          List subReports = new ArrayList();
	            /**
	             * 결재란관련     san_top_sub.rpt
	             */
	            Map<String, String> subMap = new HashMap<String, String>();
	            subMap.put("NAME", "san_top_sub.rpt");
	            subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	            subReports.add(subMap);
	          clientDoc = cDoc.generateReport(RPT_PATH+"/pmp220rkrv", "pmp220rkrv", param, sql, subReports, request);
	      }catch (Throwable e2) {
	          e2.printStackTrace();
	      }
	      clientDoc.setPrintFileName("pmp220crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
	
	@RequestMapping(value = "/prodt/pmp130crkrv.do", method = RequestMethod.GET)
	 public ModelAndView pmp130crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map<String, Object> param = _req.getParameterMap();
	      ReportUtils.setCreportPram(user, param, dao);
	      ReportUtils.setCreportSanctionParam(param, dao);
//	      param.put("sTxtValue2_fileTitle", "");
	      param.put("FrToDate", param.get("PRODT_START_DATE") + "~" + param.get("PRODT_END_DATE"));
	      String sql="";
	      try{
	          sql = dao.mappedSqlString("pmp130rkrvServiceImpl.printList", param);
	          
	          List subReports = new ArrayList();
              /**
             * 결재란관련     san_top_sub.rpt
             */
            Map<String, String> subMap = new HashMap<String, String>();
            subMap.put("NAME", "san_top_sub.rpt");
            subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
            subReports.add(subMap);
	          clientDoc = cDoc.generateReport(RPT_PATH+"/pmp130rkrv", "pmp130rkrv", param, sql, subReports, request);
	      }catch (Throwable e2) {
	          e2.printStackTrace();
	      }
	      clientDoc.setPrintFileName("pmp130crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
	
	@RequestMapping(value = "/prodt/testbarcodecrkr.do", method = RequestMethod.GET)
    public ModelAndView testbarcodecrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
         CrystalReportDoc cDoc = new CrystalReportDoc();
         CrystalReportFactory clientDoc = null;
         Map<String, Object> param = _req.getParameterMap();
//         ReportUtils.setCreportPram(user, param,dao);
//         ReportUtils.setCreportSanctionParam(param, dao);
         String sql="";
         try{
             if(ObjUtils.getSafeString(param.get("RPT_ID")).equals("testbarcoderkr")){
                 sql = dao.mappedSqlString("testbarcoderkrServiceImpl.selectList", param);
             }else if(ObjUtils.getSafeString(param.get("RPT_ID")).equals("testDataMatrixrkr")){
                 sql = dao.mappedSqlString("testbarcoderkrServiceImpl.selectList2", param);
             }
             clientDoc = cDoc.generateReport(RPT_PATH+"/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql, null, request);
             
             
             
         }catch (Throwable e2) {
             e2.printStackTrace();
         }
         clientDoc.setPrintFileName("testbarcodecrkr");
         clientDoc.setReportType(reportType);
         return ViewHelper.getCrystalReportView(clientDoc);
    }
	
	/**
	 * 작업지시서 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp110crkrv.do", method = RequestMethod.GET)
	public ModelAndView pmp110crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		
		String sql = "";
		try {
			/**
            * 결재란관련     san_top_sub.rpt
            */
		List subReports = new ArrayList();
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "san_top_sub.rpt");
			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
			subReports.add(subMap);

			Map<String, String> subMap2 = new HashMap<String, String>();
	        subMap2.put("SQL", dao.mappedSqlString("pmp110ukrvServiceImpl.subPrintList1", param));
			sql = dao.mappedSqlString("pmp110ukrvServiceImpl.printList1", param);
			
			
			if(param.get("USER_LANG").equals("VI")){

	    		param.put("sTxtValue2_fileTitle", "Yêu cầu sản xuất");
	    		subMap2.put("NAME", "s_pmp100rkrv1_jw_vi_sub1");
				subReports.add(subMap2);
			      
	        	clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+"s_pmp100rkrv1_jw_vi", "s_pmp100rkrv1_jw_vi", param,  sql,subReports, request);
	        }else{
	        	  
	        	subMap2.put("NAME", "s_pmp100rkrv1_jw_sub1");
				subReports.add(subMap2);
	        	clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+ObjUtils.getSafeString(param.get("RPT_ID1")), ObjUtils.getSafeString(param.get("RPT_ID1")), param,  sql,subReports, request);
	        }
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("pmp110crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	/**
	 * 제조지시서, 출고요청서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp100crkrv.do", method = RequestMethod.GET)
	public ModelAndView pmp100crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		
		String sql = "";
		try {
			/**
            * 결재란관련     san_top_sub.rpt
            */
			List subReports = new ArrayList();
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "san_top_sub.rpt");
			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
			subReports.add(subMap);
			
			
			if(param.get("printGubun").equals("1")){

				 Map<String, String> subMap2 = new HashMap<String, String>();
		         subMap2.put("SQL", dao.mappedSqlString("pmp100ukrvServiceImpl.subPrintList1", param));
				 sql = dao.mappedSqlString("pmp100ukrvServiceImpl.printList1", param);
				
				
				if(param.get("USER_LANG").equals("VI")){

		    		  param.put("sTxtValue2_fileTitle", "Yêu cầu sản xuất");
		    		  subMap2.put("NAME", "s_pmp100rkrv1_jw_vi_sub1");
				      subReports.add(subMap2);
				      
		        	  clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+"s_pmp100rkrv1_jw_vi", "s_pmp100rkrv1_jw_vi", param,  sql,subReports, request);
		          }else{
		        	  
		        	  subMap2.put("NAME", "s_pmp100rkrv1_jw_sub1");
				      subReports.add(subMap2);
		        	  clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+ObjUtils.getSafeString(param.get("RPT_ID1")), ObjUtils.getSafeString(param.get("RPT_ID1")), param,  sql,subReports, request);
		          }
				
			}else if(param.get("printGubun").equals("2")){
				sql = dao.mappedSqlString("pmp100ukrvServiceImpl.printList2", param);
				
				if(param.get("USER_LANG").equals("VI")){

		    		  param.put("sTxtValue2_fileTitle", "Bản yêu cầu xuất kho liệu");
		        	  
		        	  clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+"s_pmp100rkrv2_jw_vi", "s_pmp100rkrv2_jw_vi", param,  sql,subReports, request);
		          }else{
		        	  clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+ObjUtils.getSafeString(param.get("RPT_ID2")), ObjUtils.getSafeString(param.get("RPT_ID2")), param,  sql,subReports, request);
		          }
				
				
				
			}
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("pmp100crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	/**
	 * 출고요청서출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmp200crkrv.do", method = RequestMethod.GET)
	public ModelAndView pmp200crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		
		String sql = "";
		try {
			/**
            * 결재란관련     san_top_sub.rpt
            */
			List subReports = new ArrayList();
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "san_top_sub.rpt");
			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
			subReports.add(subMap);
			
			sql = dao.mappedSqlString("pmp200ukrvServiceImpl.printList", param);
			
			
			if(param.get("USER_LANG").equals("VI")){

	    		  param.put("sTxtValue2_fileTitle", "Bản yêu cầu xuất kho liệu");
			      
	        	  clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+"s_pmp200rkrv_jw_vi", "s_pmp200rkrv_jw_vi", param,  sql,subReports, request);
	          }else{
			
			
	        	  clientDoc = cDoc.generateReport(RPT_PATH_JW+"/"+ObjUtils.getSafeString(param.get("RPT_ID1")), ObjUtils.getSafeString(param.get("RPT_ID1")), param,  sql,subReports, request);
	          }
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("pmp200crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
}