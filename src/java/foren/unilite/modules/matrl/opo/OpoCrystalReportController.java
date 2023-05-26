package foren.unilite.modules.matrl.opo;

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
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
@Controller
public class OpoCrystalReportController extends UniliteCommonController{
	@InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Matrl";
	 
	 @Resource(name = "tlabAbstractDAO")
	 protected TlabAbstractDAO dao;
	 @RequestMapping(value = "/matrl/opo110crkrv.do", method = RequestMethod.GET)
		public ModelAndView opo110crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
				@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
				HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			param.put("sSan(1)_qty", "");
			param.put("sSan(2)_Place", "");
			param.put("sSan(3)_Title1", "");
			param.put("sSan(4)_Title2", "");
			param.put("sSan(5)_Title3", "");
			param.put("sSan(6)_Title4", "");
			param.put("sSan(7)_Title5", "");
			param.put("sSan(8)_Title6", "");
			param.put("sSan(9)_Title7", "");
			param.put("sSan(10)_Title8", "");
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("opo110rkrvServiceImpl.printList", param);
				List subReports = new ArrayList();
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,null, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("opo110crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
	 @RequestMapping(value = "/matrl/opo320crkrv.do", method = RequestMethod.GET)
		public ModelAndView opo320crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
				@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
				HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			param.put("11 sSan(1)_qty", "");
			param.put("12 sSan(2)_place", "");
			param.put("13 sSan(3)_title1", "");
			param.put("14 sSan(3)_title2", "");
			param.put("15 sSan(3)_title3", "");
			param.put("16 sSan(3)_title4", "");
			param.put("17 sSan(3)_title5", "");
			param.put("18 sSan(3)_title6", "");
			param.put("19 sSan(3)_title7", "");
			param.put("20 sSan(3)_title8", "");
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("opo320rkrvServiceImpl.printList", param);
				List subReports = new ArrayList();
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,null, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("opo320crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
	 @RequestMapping(value = "/matrl/opo330crkrv.do", method = RequestMethod.GET)
		public ModelAndView opo330crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
				@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
				HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
			ReportUtils.setCreportPram(user, param, dao);
			param.put("11 sSan(1)_qty", "");
			param.put("12 sSan(2)_place", "");
			param.put("13 sSan(3)_title1", "");
			param.put("14 sSan(3)_title2", "");
			param.put("15 sSan(3)_title3", "");
			param.put("16 sSan(3)_title4", "");
			param.put("17 sSan(3)_title5", "");
			param.put("18 sSan(3)_title6", "");
			param.put("19 sSan(3)_title7", "");
			param.put("20 sSan(3)_title8", "");
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("opo330rkrvServiceImpl.printList", param);
				List subReports = new ArrayList();
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,null, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("opo330crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
}
