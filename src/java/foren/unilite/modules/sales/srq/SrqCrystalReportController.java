package foren.unilite.modules.sales.srq;

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
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class SrqCrystalReportController {
	@InjectLogger
	 public static   Logger  logger  ;
	 final static String            RPT_PATH           = "/WEB-INF/Reports2011/Sales";
	 final static String            RPT_PATH2           = "/WEB-INF/Reports2011/Z_jw";
	 @Resource(name = "tlabAbstractDAO")
	 protected TlabAbstractDAO dao;
	 @RequestMapping(value = "/sales/srq200crkrv.do", method = RequestMethod.GET)
	 public ModelAndView srq200crkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response) throws Exception {
		  CrystalReportDoc cDoc = new CrystalReportDoc();
	      CrystalReportFactory clientDoc = null;
	      Map param = _req.getParameterMap();
	      ReportUtils.setCreportPram(user, param,dao);
	      ReportUtils.setCreportSanctionParam(param, dao);
	      param.put("txtContents1", "");
	      param.put("txtContents2", "");
	      param.put("txtContents3", "");
	      param.put("txtContents4", "");
	      param.put("txtContents5", "");
	      Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
	      String sql="";
	      try{
	    	  if(param.get("RPT_ID1").equals("s_srq200rkrv_jw")){ // 제이월드 용
	    		  param.put("sTxtValue2_fileTitle", "출 하 지 시 서");
	    		  sql = dao.mappedSqlString("srq200rkrvServiceImpl.s_srq200rkrv_jw_printList", param);
		          List subReports = new ArrayList();
		          /**
		           * 결재란관련     san_top_sub.rpt
		           */
		          Map<String, String> subMap = new HashMap<String, String>();
		          subMap.put("NAME", "san_top_sub.rpt");
		          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
		          subReports.add(subMap);
		          
		          if(param.get("USER_LANG").equals("VI")){

		    		  param.put("sTxtValue2_fileTitle", "Bản chỉ thị xuất hàng");
		        	  
		        	  clientDoc = cDoc.generateReport(RPT_PATH2+"/"+"s_srq200rkrv_jw_vi", "s_srq200rkrv_jw_vi", param,  sql,subReports, request);
		          }else{
		        	  clientDoc = cDoc.generateReport(RPT_PATH2+"/"+"s_srq200rkrv_jw", "s_srq200rkrv_jw", param,  sql,subReports, request);
		          }
	    	  }else{
	    		  sql = dao.mappedSqlString("srq200rkrvServiceImpl.selectList", param);
		          List subReports = new ArrayList();
	              /**
	           	   * 결재란관련     san_top_sub.rpt
	               */
		          Map<String, String> subMap = new HashMap<String, String>();
		          subMap.put("NAME", "san_top_sub.rpt");
		          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
		          subReports.add(subMap);
		          clientDoc = cDoc.generateReport(RPT_PATH+"/srq200rkrv", "srq200rkrv", param,  sql,subReports, request);
	    	  }
	          
	      }catch (Throwable e2) {
	          e2.getStackTrace();
	      }
	      clientDoc.setPrintFileName("srq200crkrv");
	      clientDoc.setReportType(reportType);
	      return ViewHelper.getCrystalReportView(clientDoc);
	 }
}
