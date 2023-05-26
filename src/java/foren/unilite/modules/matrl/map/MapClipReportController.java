package foren.unilite.modules.matrl.map;

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
import foren.unilite.com.code.CodeInfo;
import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.prodt.pmp.Pmp100ukrvServiceImpl;
import foren.unilite.modules.z_jw.S_pmp130rkrv_jwServiceImpl;
import foren.unilite.modules.matrl.mms.Mms110ukrvServiceImpl;
import foren.unilite.modules.accnt.agj.*;
@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MapClipReportController  extends UniliteCommonController {

	final static String			CRF_PATH		= "Clipreport4/Matrl/";

	@InjectLogger
	 public static Logger logger  ;
	 final static String RPT_PATH = "/WEB-INF/Reports2011/Matrl";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "agj270rkrService" )
	private Agj270rkrServiceImpl agj270rkrService;

	@Resource( name = "map100ukrvService" )
	private Map100ukrvServiceImpl map100ukrvService;

	@Resource( name = "map110skrvService" )
	private Map110skrvServiceImpl map110skrvService;

	/**
	 * 지출결의서 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/matrl/map100clukrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView mms210clrkrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));


		crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data =  map100ukrvService.selectMainReportList(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();

		subReportMap.put("map100clukrv_sub", "SQLDS2");
		param.put("SLIP_DIVI", "2");//지출결의전표
		param.put("AC_DATE", (String) param.get("EX_DATE") + (String) param.get("EX_NUM"));
		List<Map<String, Object>> subReport_data = map100ukrvService.selectPrimaryDataList2(param);
		subReportMap.put("SUB_DATA", subReport_data);

		subReports.add(subReportMap);


		resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 외상매입현황 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/map/map110clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView map110clskrv( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));


		crfFile = CRF_PATH+ ObjUtils.getSafeString(param.get("RPT_ID1"));
		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data =  map110skrvService.selectMainReportList(param);

			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}

