package foren.unilite.modules.human.hrt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class HrtClipReportController  extends UniliteCommonController {
	final static String CRF_PATH	= "/clipreport4/crf/human/";
	final static String CRF_PATH2	= "Clipreport4/Human/";

	@Resource( name = "hrt510rkrService" )
	private Hrt510rkrServiceImpl hrt510rkrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	/**
	 * 개인별 퇴직금정산내역 출력 (hrt510rkr) - 20200730 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hrt510clrkrPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView hrt510clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = hrt510rkrService.selectPrintMData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap = new HashMap<String ,Object>();
		subReportMap.put("HRT510RKR", "SQLDS2");

		List<Map<String, Object>> subReport_data = hrt510rkrService.selectPrintDData(param);
		subReportMap.put("SUB_DATA", subReport_data);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}