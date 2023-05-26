package foren.unilite.modules.prodt.pmr;

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
public class PmrCrystalReportController  extends UniliteCommonController {
    @InjectLogger
    public static Logger logger;
    
    final static String            RPT_PATH           = "/WEB-INF/Reports2011/Prodt";
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@RequestMapping(value = "/prodt/pmr140crkrv.do", method = RequestMethod.GET)
	 public ModelAndView ssa460crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map param = _req.getParameterMap();
	      param.put("sWorkShop", "");
	      ReportUtils.setCreportPram(user, param,dao);
	      ReportUtils.setCreportSanctionParam(param, dao);
	      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	      String sql="";
	      try{
	    	  String rdoPrintItem = ReportUtils.nvl(param.get("rdoPrintItem"));
	    	  String opt = ReportUtils.nvl(param.get("opt"));
	    	  String rptId ;
	    	  if("1".equals(rdoPrintItem)){
	    		  if("1".equals(opt)){
	    			  rptId="pmr140rkrv1";
	    			  sql  = null;
	    			  List subReports = new ArrayList();
	    			  Map<String,String> subMap1 = new HashMap<String,String>();
	    			  subMap1.put("NAME", "pmr140rkrv1_sub1.rpt");
	    			  subMap1.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printListSub1", param));
	    			  subReports.add(subMap1);
	    			  /*second*/
	    			  Map<String, String> subMap2 =new HashMap<String,String>();
	    			  subMap2.put("NAME", "pmr140rkrv1_sub2.rpt");
	    			  subMap2.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printListSub2", param));
	    			  subReports.add(subMap2);
	    			  /*third*/
	    			  Map<String, String> subMap3 =new HashMap<String,String>();
	    			  subMap3.put("NAME", "pmr140rkrv1_sub3.rpt");
	    			  subMap3.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printListSub3", param));
	    			  subReports.add(subMap3);
	    			 /* fourth*/
	    			  Map<String, String> subMap4 =new HashMap<String,String>();
	    			  subMap4.put("NAME", "pmr140rkrv1_sub4.rpt");
	    			  subMap4.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printListSub4", param));
	    			  subReports.add(subMap4);
	    			 /* fifth*/
	    			  Map<String, String> subMap5 =new HashMap<String,String>();
	    			  subMap5.put("NAME", "pmr140rkrv1_sub5.rpt");
	    			  subMap5.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printListSub5", param));
	    			  subReports.add(subMap5);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,subReports, request);
	    		  }else  if("2".equals(opt)){
	    			  rptId="pmr140rkrv2";
	    			  sql = dao.mappedSqlString("pmr140rkrvServiceImpl.printList1Sub2", param);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,null, request);
	    		  }else  if("3".equals(opt)){
	    			  rptId="pmr140rkrv3";
	    			  sql = dao.mappedSqlString("pmr140rkrvServiceImpl.printList1Sub3", param);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,null, request);
	    		  }else  if("4".equals(opt)){
	    			  rptId="pmr140rkrv4";
	    			  sql = dao.mappedSqlString("pmr140rkrvServiceImpl.printList1Sub4", param);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,null, request);
	    		  }else {
	    			  rptId="pmr140rkrv5";
	    			  sql = dao.mappedSqlString("pmr140rkrvServiceImpl.printList5", param);
	    			  List subReports = new ArrayList();
	    			  Map<String,String> subMap = new HashMap<String,String>();
	    			  subMap.put("NAME", "pmr140rkrv5_sub1.rpt");
	    			  subMap.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printList1Sub5", param));
	    			  subReports.add(subMap);
	    			  Map<String, String> subMap2 = new HashMap<String,String>();
	    			  subMap2.put("NAME", "pmr140rkrv5_sub2.rpt");
	    			  subMap2.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printList1Sub6", param));
	    			  subReports.add(subMap2);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,subReports, request);
	    		  }
	    	  }else{
	    		  if("1".equals(opt)){
	    			  rptId = "pmr140rkrv6";
	    			  sql = null;
	    			  List subReports = new ArrayList();
	    			  Map<String, String> subMap = new HashMap<String,String>();
	    			  subMap.put("NAME", "pmr120p_sub1.rpt");
	    			  subMap.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printList2Sub1", param));
	    			  subReports.add(subMap);
	    			  /*seconed*/
	    			  Map<String, String> subMap2 = new HashMap<String,String>();
	    			  subMap2.put("NAME", "pmr120p_sub2.rpt");
	    			  subMap2.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printList2Sub2", param));
	    			  subReports.add(subMap2);
	    			  /*third*/
	    			  Map<String, String> subMap3 = new HashMap<String,String>();
	    			  subMap3.put("NAME", "pmr120p_sub3.rpt");
	    			  subMap3.put("SQL", dao.mappedSqlString("pmr140rkrvServiceImpl.printList2Sub3", param));
	    			  subReports.add(subMap3);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,subReports, request);
	    		  }else  if("2".equals(opt)){
	    			  rptId = "pmr140rkrv7";
	    			  sql = dao.mappedSqlString("pmr140rkrvServiceImpl.printList2Sub1", param);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,null, request);
	    		  }else  if("3".equals(opt)){
	    			  rptId = "pmr140rkrv8";
	    			  sql = dao.mappedSqlString("pmr140rkrvServiceImpl.printList2Sub4", param);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,null, request);
	    		  }else {
	    			  rptId = "pmr140rkrv9";
	    			  sql = dao.mappedSqlString("pmr140rkrvServiceImpl.printList2Sub5", param);
	    			  clientDoc = cDoc.generateReport(RPT_PATH+"/"+rptId, rptId, param,  sql,null, request);
	    		  }
	    	  }
	         
	      }catch (Throwable e2) {
	          e2.printStackTrace();
	      }
	      clientDoc.setPrintFileName("pmr140crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }    

	/**
	 * 생산실적조회출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr200crkrv.do", method = RequestMethod.GET)
	public ModelAndView pmr200crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		

	    String[] wkordNumArry = null;
	    
	    String wkordNum= ObjUtils.getSafeString(param.get("WKORD_NUM"));
	    if(ObjUtils.isNotEmpty(wkordNum)){
	    	wkordNumArry = wkordNum.split(",");
	    }
	    
	    param.put("WKORD_NUM", wkordNumArry);
	    
		String sql = "";
		try {
			sql = dao.mappedSqlString("pmr200rkrvServiceImpl.printList", param);
			
			/**
            * 결재란관련     san_top_sub.rpt
            */
			/*List subReports = new ArrayList();
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "san_top_sub.rpt");
			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
			subReports.add(subMap);*/
			
			
			
			if(param.get("USER_LANG").equals("VI")){

	    		  param.put("sTxtValue2_fileTitle", "Danh sách số lượng thực tế sản xuất");
	        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"pmr200rkrv_vi", "pmr200rkrv_vi", param,  sql,null, request);
			}else{
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,null, request);
			}
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("pmr200crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	
	/**
	 * 생산자재출고출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prodt/pmr200crkrv2.do", method = RequestMethod.GET)
	public ModelAndView pmr200crkrv2Print(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		

	    String[] lotNoArry = null;
	    
	    String lotNo= ObjUtils.getSafeString(param.get("LOT_NO"));
	    if(ObjUtils.isNotEmpty(lotNo)){
	    	lotNoArry = lotNo.split(",");
	    }
	    
	    param.put("LOT_NO", lotNoArry);
	    
		String sql = "";
		try {
			sql = dao.mappedSqlString("pmr200ukrvServiceImpl.printList", param);
			
			/**
            * 결재란관련     san_top_sub.rpt
            */
			List subReports = new ArrayList();
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "san_top_sub.rpt");
			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
			subReports.add(subMap);
			
			
			
			if(param.get("USER_LANG").equals("VI")){

	    		  param.put("sTxtValue2_fileTitle", "Phiếu nhập kho");
	        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"pmr200rkrv2_vi", "pmr200rkrv2_vi", param,  sql,subReports, request);
			}else{
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,subReports, request);
			}
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("pmr200crkrv2");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	
	
}