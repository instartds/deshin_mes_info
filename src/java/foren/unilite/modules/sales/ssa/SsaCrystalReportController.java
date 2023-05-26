package foren.unilite.modules.sales.ssa;

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
public class SsaCrystalReportController extends UniliteCommonController {
	@InjectLogger
	public static Logger logger;
	final static String RPT_PATH = "/WEB-INF/Reports2011/Sales";
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	@RequestMapping(value = "/sales/ssa430crkrv.do", method = RequestMethod.GET)
	public ModelAndView ssa430crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		SimpleDateFormat matter1 = new SimpleDateFormat("yyyy-MM-dd");
		String str = matter1.format(new Date());
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
		param.put("paramDivCode", param.get("DIV_NAME"));
		param.put("sTradeYN", param.get("tradeYN"));
		Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
		String sql = "";
		try {
			if("S".equals(ObjUtils.getSafeString(param.get("rdoSelect1")))){
				sql = dao.mappedSqlString("ssa430rkrvServiceImpl.printList", param);
			}else{
				sql = dao.mappedSqlString("ssa430rkrvServiceImpl.printList1", param);
			}
			List subReports = new ArrayList();
			clientDoc = cDoc.generateReport(RPT_PATH + "/ssa430rkrv", "ssa430rkrv", param, sql, null, request);
		} catch (Throwable e2) {
			e2.getStackTrace();
		}
		clientDoc.setPrintFileName("ssa430crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}

	@RequestMapping(value = "/sales/ssa460crkrv.do", method = RequestMethod.GET)
	public ModelAndView ssa460crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();

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
		String sql = "";
		try {
			sql = dao.mappedSqlString("ssa460rkrvServiceImpl.printList", param);
			List subReports = new ArrayList();
			clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,null, request);

		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("ssa460crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}

	@RequestMapping(value = "/sales/ssa450crkrv.do", method = RequestMethod.GET)
	public ModelAndView ssa450crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
		param.put("TRADE_OUT", param.get("TRADE_OUT"));
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
		String sql = "";
		try {
			sql = dao.mappedSqlString("ssa450rkrvServiceImpl.printList", param);
			List subReports = new ArrayList();
            /**
           * 결재란관련     san_top_sub.rpt
           */
          Map<String, String> subMap = new HashMap<String, String>();
          subMap.put("NAME", "san_top_sub.rpt");
          subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
          subReports.add(subMap);
			clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,
			        subReports, request);

		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("ssa450crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}

	@RequestMapping(value = "/sales/ssa560crkrv.do", method = RequestMethod.GET)
	public ModelAndView ssa560crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		param.put("Account", "");

		Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
		String sql = "";
		try {
			if ("11".equals(ObjUtils.getSafeString(param.get("ITEM_TYPE")))) { // 개별 표시
				sql = dao.mappedSqlString("ssa560rkrvServiceImpl.printList1", param);
			} else { // 20 동일품목 합하여 표시
				sql = dao.mappedSqlString("ssa560rkrvServiceImpl.printList2", param);
			}

			List subReports = new ArrayList();
			clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,
					null, request);
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("ssa560crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	@RequestMapping(value = "/sales/ssa200crkrv.do", method = RequestMethod.GET)
	public ModelAndView ssa200crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
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
	    if(ObjUtils.isEmpty(param.get("SALE_PRSN"))){
            param.put("SalePrsn", "");
        }else{
            param.put("SalePrsn", param.get("SALE_PRSN"));
        }
	    if(ObjUtils.isEmpty(param.get("WH_NAME"))){
            param.put("WhName", "");
        }else{
            param.put("WhName", param.get("WH_NAME"));
        }


	    param.put("DivCode", param.get("DIV_NAME"));
	    if(ObjUtils.isEmpty(param.get("DivCode"))){
	    	param.put("DivCode","");
	    }
	    param.put("TradeYN_Name", "");
		Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
		String sql = "";
		try {
			if(ObjUtils.getSafeString(param.get("TRADE_YN")).equals("Y")){
				sql = dao.mappedSqlString("ssa200rkrvServiceImpl.printList1", param);
			}else{
				sql = dao.mappedSqlString("ssa200rkrvServiceImpl.printList2", param);
			}
			List subReports = new ArrayList();
			/**
	         * 결재란관련     san_top_sub.rpt
	         */
	        Map<String, String> subMap = new HashMap<String, String>();
	        subMap.put("NAME", "san_top_sub.rpt");
	        subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	        subReports.add(subMap);
			clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,
					subReports, request);
			}catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("ssa200crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	@RequestMapping(value = "/sales/ssa580crkrv.do", method = RequestMethod.GET)
	public ModelAndView ssa580crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
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
			sql = dao.mappedSqlString("ssa580rkrvServiceImpl.printList", param);
			List subReports = new ArrayList();

			/**
			 * 결재란관련     san_top_sub.rpt
			 */
			Map<String, String> subMap = new HashMap<String, String>();
	        subMap.put("NAME", "san_top_sub.rpt");
	        subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	        subReports.add(subMap);

			clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,
			        subReports, request);
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("ssa580crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}

	@RequestMapping(value = "/sales/ssa590crkrv.do", method = RequestMethod.GET)
	public ModelAndView ssa590crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
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
			sql = dao.mappedSqlString("ssa590rkrvServiceImpl.printList", param);
			List subReports = new ArrayList();
			/**
			 * 결재란관련     san_top_sub.rpt
			 */
			Map<String, String> subMap = new HashMap<String, String>();
	        subMap.put("NAME", "san_top_sub.rpt");
	        subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
	        subReports.add(subMap);
			clientDoc = cDoc.generateReport(RPT_PATH + "/" + ObjUtils.getSafeString(param.get("RPT_ID")), ObjUtils.getSafeString(param.get("RPT_ID")), param, sql,
					subReports, request);
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("ssa590crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
}
