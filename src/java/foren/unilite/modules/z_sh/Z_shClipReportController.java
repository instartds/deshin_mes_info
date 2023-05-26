package foren.unilite.modules.z_sh;

import java.io.File;
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
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.JndiUtils;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.str.Str410skrvServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_shClipReportController	extends UniliteCommonController {
 @InjectLogger
	public static Logger logger;
	final static String			CRF_PATH	= "Clipreport4/Z_sh/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "s_pmp170ukrv_shService" )
	private S_pmp170ukrv_shServiceImpl s_pmp170ukrv_shService;

	@Resource( name = "str410skrvService" )
	private Str410skrvServiceImpl str410skrvService;

	@Resource( name = "s_mms200skrv_shService" )
	private S_mms200skrv_shServiceImpl s_mms200skrv_shService;

	/**
	 * 작업지시 라인배정 및 조정
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_pmp170clukrv_sh.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp170clukrv_mitPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String crfFile = null;
		List<Map<String, Object>> report_data = null;
		crfFile = CRF_PATH + "s_pmp170clukrv_sh.crf";
		//Main Report
		report_data = s_pmp170ukrv_shService.printList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	/**
	 * 납품거래명세서(shin) (str410skrv) - 20191219 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_str410clskrv_sh.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_str410clskrv_shPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH + "s_str410clskrv_sh.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = str410skrvService.clipselect_sh_main(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("s_str410clskrv_sh_sub", "SQLDS2");

		List<Map<String, Object>> subReport_data = str410skrvService.clipselect_sh_sub(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC2", "SQLDS2", param, report_data, subReport_data, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	
	/**
	 * 수입검사현황조회 - 부적합품 발생 통보서
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_sh/s_mms200clskrv_sh.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_mms200clskrv_sh(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		
		String[] inspecNumSeqList = null;

		String iNSL = ObjUtils.getSafeString(param.get("inspecNumSeqList"));
		if(ObjUtils.isNotEmpty(iNSL)){
			inspecNumSeqList = iNSL.split(",");
		}

		
//		List<Map<String, Object>> rMap2 = null;
		
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		String crfFile = null;
		List<Map<String, Object>> report_data = null;
		crfFile = CRF_PATH + "s_mms200clskrv_sh.crf";
		
		
		param.put("INSPEC_NUM_SEQ", inspecNumSeqList);
		
		//Main Report
		report_data = s_mms200skrv_shService.printList(param);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
