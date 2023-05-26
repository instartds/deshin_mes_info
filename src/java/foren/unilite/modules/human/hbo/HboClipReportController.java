package foren.unilite.modules.human.hbo;

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
public class HboClipReportController  extends UniliteCommonController {
	final static String CRF_PATH	= "/clipreport4/crf/human/";
	final static String CRF_PATH2	= "Clipreport4/Human/";

	@Resource( name = "hbo800rkrService" )
	private Hbo800rkrServiceImpl hbo800rkrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	/**
	 * 상여지급조서출력 (hbo800rkr) - 20200807 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hbo800clrkrPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView hrt510clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";

		if("4".equals(param.get("DOC_KIND"))) {
			crfFile = CRF_PATH2 + "hbo800clrkr_2.crf";
		} else {
			crfFile = CRF_PATH2 + "hbo800clrkr_1.crf";
		}
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = hbo800rkrService.selectPrintMData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data= hbo800rkrService.selectPrintDData(param);
		subReportMap.put("HBO800RKR", "SQLDS2");
		subReportMap.put("SUB_DATA"	, subReport_data);
		subReports.add(subReportMap);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}