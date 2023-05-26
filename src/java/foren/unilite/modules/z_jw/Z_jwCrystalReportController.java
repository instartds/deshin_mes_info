package foren.unilite.modules.z_jw;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.crystaldecisions.report.web.viewer.CrPrintMode;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class Z_jwCrystalReportController  extends UniliteCommonController {
  @InjectLogger
  public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
  
  final static String            RPT_PATH           = "/WEB-INF/Reports2011/Z_jw";
  
  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;
   

	
	/**
	 * 생산실적목록
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmr100rkrv_jwcrkrv.do", method = RequestMethod.GET)
	public ModelAndView s_pmr100rkrv_jwcrkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		

	    String[] prodtNumArry = null;
	    
	    String prodtNum= ObjUtils.getSafeString(param.get("PRODT_NUM"));
	    if(ObjUtils.isNotEmpty(prodtNum)){
	    	prodtNumArry = prodtNum.split(",");
	    }
	    
	    param.put("PRODT_NUM", prodtNumArry);
	    
		String sql = "";
		try {
			sql = dao.mappedSqlString("s_pmr100ukrv_jwServiceImpl.printList", param);
			
			
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
	        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_pmr100rkrv_jw_vi", "s_pmr100rkrv_jw_vi", param,  sql,null, request);
			}else{
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,null, request);
			}
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("s_pmr100rkrv_jw");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
    
	/**
	 * 재단작업지시등록(JW)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmp101crkrv.do", method = RequestMethod.GET)
	public ModelAndView s_pmp101rkrv_jwcrkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		

	    String[] prodtNumArry = null;
	    
	    String prodtNum= ObjUtils.getSafeString(param.get("PRODT_NUM"));
	    if(ObjUtils.isNotEmpty(prodtNum)){
	    	prodtNumArry = prodtNum.split(",");
	    }
	    
	    param.put("PRODT_NUM", prodtNumArry);
	    
		String sql = "";
		try {
			List subReports = new ArrayList();
			/**
            * 결재란관련     san_top_sub.rpt
            */
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "san_top_sub.rpt");
			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
			subReports.add(subMap);
			
			Map<String, String> subMap2 = new HashMap<String, String>();
	        subMap2.put("SQL", dao.mappedSqlString("s_pmp101ukrv_jwServiceImpl.subPrintList", param));
			sql = dao.mappedSqlString("s_pmp101ukrv_jwServiceImpl.printList", param);
			
			if(param.get("USER_LANG").equals("VI")){

	    		  param.put("sTxtValue2_fileTitle", "Yêu cầu sản xuất");
	    		  subMap2.put("NAME", "s_pmp101rkrv_jw_vi_sub");
			      subReports.add(subMap2);
			      
	        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_pmp101rkrv_jw_vi", "s_pmp101rkrv_jw_vi", param,  sql,subReports, request);
	          }else{
	        	  
	        	  subMap2.put("NAME", "s_pmp101rkrv_jw_sub");
			      subReports.add(subMap2);
			      clientDoc = cDoc.generateReport(RPT_PATH+"/"+ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param,  sql,subReports, request);
	          }
			
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("s_pmp101rkrv_jw");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	
	/**
	 * 제조지시서 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_pmp130crkrv_jw.do", method = RequestMethod.GET)
	public ModelAndView s_pmp130crkrv_jwPrint(ExtHtttprequestParam _req, LoginVO user,
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
		         subMap2.put("SQL", dao.mappedSqlString("s_pmp130rkrv_jwServiceImpl.subPrintList1", param));
				 sql = dao.mappedSqlString("s_pmp130rkrv_jwServiceImpl.printList1", param);
				
				
				 if(param.get("USER_LANG").equals("VI")){

		    		  param.put("sTxtValue2_fileTitle", "Yêu cầu sản xuất");
		    		  subMap2.put("NAME", "s_pmp100rkrv1_jw_vi_sub1");
				      subReports.add(subMap2);
				      
		        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_pmp100rkrv1_jw_vi", "s_pmp100rkrv1_jw_vi", param,  sql,subReports, request);
		          }else{
		        	  
		    		  param.put("sTxtValue2_fileTitle", "작업지시서");
		        	  subMap2.put("NAME", "s_pmp100rkrv1_jw_sub1");
				      subReports.add(subMap2);
		        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_pmp100rkrv1_jw", "s_pmp100rkrv1_jw", param,  sql,subReports, request);
		          }
				
			}else if(param.get("printGubun").equals("2")){
				sql = dao.mappedSqlString("s_pmp130rkrv_jwServiceImpl.printList2", param);
				
				if(param.get("USER_LANG").equals("VI")){

					param.put("sTxtValue2_fileTitle", "Bản yêu cầu xuất kho liệu");
	        	  
					clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_pmp100rkrv2_jw_vi", "s_pmp100rkrv2_jw_vi", param,  sql,subReports, request);
				}else{
		    		param.put("sTxtValue2_fileTitle", "자재출고요청서");
					clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_pmp100rkrv2_jw", "s_pmp100rkrv2_jw", param,  sql,subReports, request);
				}
			}
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("s_pmp130crkrv_jw");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	
	/**
	 * 급여보고서출력(S)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_hpa910crkrv_jw.do", method = RequestMethod.GET)
	public ModelAndView s_hpa910crkrv_jwPrint(ExtHtttprequestParam _req, LoginVO user,
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
//			List subReports = new ArrayList();
//			Map<String, String> subMap = new HashMap<String, String>();
//			subMap.put("NAME", "san_top_sub.rpt");
//			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
//			subReports.add(subMap);
			
			if(param.get("printGubun").equals("1")){
				 sql = dao.mappedSqlString("S_hpa910rkr_jwServiceImpl.selectList1", param);
		        	  clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_hpa910rkrv1_jw", "s_hpa910rkrv1_jw", param,  sql,null, request);
//		          }
				
			}else if(param.get("printGubun").equals("2")){
				sql = dao.mappedSqlString("S_hpa910rkr_jwServiceImpl.selectList2", param);
					clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_hpa910rkrv2_jw", "s_hpa910rkrv2_jw", param,  sql,null, request);
			}
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("s_hpa910crkrv_jw");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	/**
	 * 급여정보조회(S)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_jw/s_hpa900cskrv_jw.do", method = RequestMethod.GET)
	public ModelAndView s_hpa900cskrv_jwPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
		
		String sql = "";
		try {
			List subReports = new ArrayList();
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "s_hpa900skr_jw_sub01");
	        subMap.put("SQL", dao.mappedSqlString("S_hpa900skr_jwServiceImpl.selectSubPrint", param));
		    subReports.add(subMap);
		    sql = dao.mappedSqlString("S_hpa900skr_jwServiceImpl.selectPrint", param);
		    clientDoc = cDoc.generateReport(RPT_PATH+"/"+"s_hpa900skr_jw", "s_hpa900skr_jw", param,  sql,subReports, request);
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("s_hpa900cskrv_jw");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
    
}
