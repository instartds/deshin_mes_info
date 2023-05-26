package foren.unilite.modules.sales.sco;

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
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
@Controller
public class ScoCrystalReportController extends UniliteCommonController {
	@InjectLogger
	public static Logger logger;
	final static String RPT_PATH = "/WEB-INF/Reports2011/Sales";
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	@RequestMapping(value = "/sales/sco300crkrv.do", method = RequestMethod.GET)
	public ModelAndView sco300crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
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
			if(ObjUtils.getSafeString(param.get("rdoPrintItem")).equals("1")){
				sql = dao.mappedSqlString("sco300rkrvServiceImpl.printList", param);
			}else{
				sql = dao.mappedSqlString("sco300rkrvServiceImpl.printList2", param);
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
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("sco300crkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
}
