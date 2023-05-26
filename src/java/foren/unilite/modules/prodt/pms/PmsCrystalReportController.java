package foren.unilite.modules.prodt.pms;

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
public class PmsCrystalReportController extends UniliteCommonController {
	@InjectLogger
	public static Logger logger  ;
	final static String RPT_PATH = "/WEB-INF/Reports2011/Prodt";
	 
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@RequestMapping(value = "/prodt/pms400crkrv.do", method = RequestMethod.GET)
	public ModelAndView pms400crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
		@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map param = _req.getParameterMap();
	    ReportUtils.setCreportPram(user, param, dao);
	    ReportUtils.setCreportSanctionParam(param, dao);
	    
	    String[] inspecNumArry = null;
	    String[] inspecSeqArry = null;
	    
	    String inspecNum = ObjUtils.getSafeString(param.get("INSPEC_NUM"));
	    if(ObjUtils.isNotEmpty(inspecNum)){
	        inspecNumArry = inspecNum.split(",");
	    }
	    String inspecSeq = ObjUtils.getSafeString(param.get("INSPEC_SEQ"));
	    if(ObjUtils.isNotEmpty(inspecSeq)){
	    	inspecSeqArry = inspecSeq.split(",");
	    }

		List<Map> inspecNumSeqList = new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			
			Object SELECT_INSPEC_NUM =  inspecNumArry[i];
			Object SELECT_INSPEC_SEQ =  inspecSeqArry[i];

			map.put("INSPEC_NUM", SELECT_INSPEC_NUM);
			map.put("INSPEC_SEQ", SELECT_INSPEC_SEQ);			
			
			inspecNumSeqList.add(map);
		}
		
	    param.put("INSPEC_NUM_SEQ", inspecNumSeqList);
	    
		Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
		String sql = "";
		try {
			sql = dao.mappedSqlString("pms400rkrvServiceImpl.printList", param);
			List subReports = new ArrayList();
			/**
            * 결재란관련     san_top_sub.rpt
            */
			Map<String, String> subMap = new HashMap<String, String>();
			subMap.put("NAME", "san_top_sub.rpt");
			subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
			subReports.add(subMap);
			clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,subReports, request);

		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("pms400crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
	 
		@RequestMapping(value = "/prodt/pms410crkrv.do", method = RequestMethod.GET)
		public ModelAndView pms410crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
			@RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
			CrystalReportDoc cDoc = new CrystalReportDoc();
			CrystalReportFactory clientDoc = null;
			Map param = _req.getParameterMap();
		    ReportUtils.setCreportPram(user, param, dao);
		    ReportUtils.setCreportSanctionParam(param, dao);
			

		    String[] inspecNumArry = null;
		    String[] inspecSeqArry = null;
		    
		    String inspecNum = ObjUtils.getSafeString(param.get("INSPEC_NUM"));
		    if(ObjUtils.isNotEmpty(inspecNum)){
		        inspecNumArry = inspecNum.split(",");
		    }
		    String inspecSeq = ObjUtils.getSafeString(param.get("INSPEC_SEQ"));
		    if(ObjUtils.isNotEmpty(inspecSeq)){
		    	inspecSeqArry = inspecSeq.split(",");
		    }

			List<Map> inspecNumSeqList = new ArrayList<Map>();

			for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
				Map map = new HashMap();
				
				Object SELECT_INSPEC_NUM =  inspecNumArry[i];
				Object SELECT_INSPEC_SEQ =  inspecSeqArry[i];

				map.put("INSPEC_NUM", SELECT_INSPEC_NUM);
				map.put("INSPEC_SEQ", SELECT_INSPEC_SEQ);			
				
				inspecNumSeqList.add(map);
			}
			
		    param.put("INSPEC_NUM_SEQ", inspecNumSeqList);
		    
			Map<String, ResultSet> rsMap = new HashMap<String, ResultSet>();
			String sql = "";
			try {
				sql = dao.mappedSqlString("pms410skrvServiceImpl.printList", param);
				List subReports = new ArrayList();
				/**
	            * 결재란관련     san_top_sub.rpt
	            */
				Map<String, String> subMap = new HashMap<String, String>();
				subMap.put("NAME", "san_top_sub.rpt");
				subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
				subReports.add(subMap);
				clientDoc = cDoc.generateReport(RPT_PATH + "/" + param.get("RPT_ID"), param.get("RPT_ID") + "", param, sql,subReports, request);

			} catch (Throwable e2) {
				e2.printStackTrace();
			}
			clientDoc.setPrintFileName("pms410crkrv");
			clientDoc.setReportType(reportType);
			return ViewHelper.getCrystalReportView(clientDoc);
		}
}
