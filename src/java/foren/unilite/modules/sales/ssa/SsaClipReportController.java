package foren.unilite.modules.sales.ssa;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.sales.ssa.Ssa430skrvServiceImpl;
import foren.unilite.modules.sales.ssa.Ssa450skrvServiceImpl;
import foren.unilite.modules.sales.ssa.Ssa540skrvServiceImpl;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class SsaClipReportController extends UniliteCommonController {
	
	final static String CRF_PATH	= "/clipreport4/crf/Sales/";
	final static String CRF_PATH2	= "Clipreport4/Sales/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "ssa430skrvService" )
	private Ssa430skrvServiceImpl ssa430skrvService;

	@Resource( name = "ssa450skrvService" )
	private Ssa450skrvServiceImpl ssa450skrvService;
	
	@Resource( name = "ssa540skrvService" )
	private Ssa540skrvServiceImpl ssa540skrvService;



	/**
	 * 거래처원장 조회 (ssa430skrv) - 거래명세서 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa430clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView ssa430clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		//출력할 리포트 파일명
		String crfFile = CRF_PATH2 + "ssa430clskrv.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = ssa430skrvService.printList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC2","SQLDS1", param, report_data, null , request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
}

	/**
	 * 매출현황 조회 (ssa450skrv) - 출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/ssa450clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView ssa450clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		//결재란 관련 로직
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		//출력할 리포트 파일명
		String crfFile = CRF_PATH2 + "ssa450clskrv.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = ssa450skrvService.printList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null , request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/sales/ssa540clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView ssa540clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		//결재란 관련 로직
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		//출력할 리포트 파일명
		String crfFile = CRF_PATH2 + "ssa540clskrv.crf";

		//Image 경로
		String imagePath = doc.getImagePath();

		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = ssa540skrvService.printList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null , request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
