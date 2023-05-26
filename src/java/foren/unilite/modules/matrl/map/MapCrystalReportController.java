package foren.unilite.modules.matrl.map;

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
public class MapCrystalReportController extends UniliteCommonController {
	 @InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Matrl";
	 
	 @Resource(name = "tlabAbstractDAO")
	 protected TlabAbstractDAO dao;
/**
 * 외상매입금 내역출력
 * @param _req
 * @param user
 * @param reportType
 * @param request
 * @param response
 * @return
 * @throws Exception
 */
		@RequestMapping(value = "/matrl/map130crkrv.do", method = RequestMethod.GET)
		public ModelAndView map130crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
				@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
				HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			ReportUtils.setCreportSanctionParam(param, dao);
			
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("map130rkrvServiceImpl.printList", param);
				List subReports = new ArrayList();
				/**
		         * 결재란관련     san_top_sub.rpt
		         */
		        Map<String, String> subMap = new HashMap<String, String>();
		        subMap.put("NAME", "san_top_sub.rpt");
		        subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
		        subReports.add(subMap);
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,subReports, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("map130crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
	/**
	 * 외상매입금 집계출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */	
		@RequestMapping(value = "/matrl/map160crkrv.do", method = RequestMethod.GET)
		public ModelAndView map160crkrv(ExtHtttprequestParam _req, LoginVO user,
				@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
				HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
            ReportUtils.setCreportSanctionParam(param, dao);
			
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("map160rkrvServiceImpl.printList", param);
				List subReports = new ArrayList();
				/**
		         * 결재란관련     san_top_sub.rpt
		         */
		        Map<String, String> subMap = new HashMap<String, String>();
		        subMap.put("NAME", "san_top_sub.rpt");
		        subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
		        subReports.add(subMap);
				
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,subReports, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("map160crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
		/**
		 * 미지급결의 출력
		 * @param _req
		 * @param user
		 * @param reportType
		 * @param request
		 * @param response
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/matrl/map150crkrv.do", method = RequestMethod.GET)
		public ModelAndView map150crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
				@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
				HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
            ReportUtils.setCreportSanctionParam(param, dao);
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("map150rkrvServiceImpl.printList", param);
				List subReports = new ArrayList();
				/**
		         * 결재란관련     san_top_sub.rpt
		         */
		        Map<String, String> subMap = new HashMap<String, String>();
		        subMap.put("NAME", "san_top_sub.rpt");
		        subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
		        subReports.add(subMap);
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,subReports, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("map150crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
}
