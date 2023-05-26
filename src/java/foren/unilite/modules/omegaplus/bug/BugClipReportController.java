package foren.unilite.modules.omegaplus.bug;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class BugClipReportController	extends UniliteCommonController {
	@InjectLogger
	public static Logger logger;
	final static String CRF_PATH	= "Clipreport4/bug/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@Resource(name = "bug100ukrvService")
	private Bug100ukrvServiceImpl bug100ukrvService;



	/**
	 * 견적서 출력(WM) (s_mba200rkrv_wm) - 20201013 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/bug/bug100clukrv.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView bug100clukrv(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile		= CRF_PATH + "bug100clukrv.crf";
//		String crfFile		= CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
//		String imagePath = doc.getImagePath();

		String[] pgmIdArry		= param.get("pgmIds").toString().split(",");
		List<Map> pgmIdList	= new ArrayList<Map>();

		for(int i=0; i<ObjUtils.parseInt(param.get("dataCount")); i++){
			Map map = new HashMap();
			map.put("pgmId", pgmIdArry[i]);
			pgmIdList.add(map);
		}
		param.put("PGM_ID_LIST", pgmIdList);

		//Main Report
		List<Map<String, Object>> report_data = bug100ukrvService.selectPrintList(param);
/*
		//추가 SUB Report 있을 때,
		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();

		//SUB REPORT 1
		List<Map<String, Object>> subReport_data1 = s_mba200rkrv_wmService.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);

		//SUB REPORT 2
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = s_mba200rkrv_wmService.refundedAaxAmt(param);
		subReportMap2.put("DATA_SET", "SQLDS3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);

		//SUB REPORT 3
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data3 = s_mba200rkrv_wmService.calResidentTax(param);
		subReportMap3.put("DATA_SET", "SQLDS4");
		subReportMap3.put("SUB_DATA", subReport_data3);
		subReports.add(subReportMap3);
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
*/
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}