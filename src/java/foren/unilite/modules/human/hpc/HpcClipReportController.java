package foren.unilite.modules.human.hpc;

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
public class HpcClipReportController extends UniliteCommonController {
	final static String	CRF_PATH	= "Clipreport4/human/";

	@Resource(name = "hpc950ukrService")
	private Hpc950ukrServiceImpl hpc950ukrService;
	
	@Resource(name = "hpc952ukrService")
	private Hpc952ukrServiceImpl hpc952ukrService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	/**
	 * 홈텍스-원천징수이행상황전자신고 (hpa990ukr) - 20200814 추가
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/human/hpc950clukrPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView hpa990clukrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		//String crfFile		= CRF_PATH + "hpa990clukr.crf";
		String crfFile		= CRF_PATH + "hpc950clukr.crf";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Main Report
		List<Map<String, Object>> report_data = hpc950ukrService.printMainData(param);

		//Sub Report use data
		List<Map<String, Object>> subReports	= new ArrayList<Map<String, Object>>();
		Map<String, Object> subReportMap		= new HashMap<String ,Object>();
		//원천징수 명세 및 납부세액 조회
		List<Map<String, Object>> subReport_data1 = hpc950ukrService.printDetailData(param);
		subReportMap.put("DATA_SET", "SQLDS2");
		subReportMap.put("SUB_DATA", subReport_data1);
		subReports.add(subReportMap);
		//환급세액 데이터 조회
		Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data2 = hpc950ukrService.refundedAaxAmt(param);
		subReportMap2.put("DATA_SET", "SQLDS3");
		subReportMap2.put("SUB_DATA", subReport_data2);
		subReports.add(subReportMap2);
		//주민세 합계 계산
		Map<String, Object> subReportMap3 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data3 = hpc950ukrService.calResidentTax(param);
		subReportMap3.put("DATA_SET", "SQLDS4");
		subReportMap3.put("SUB_DATA", subReport_data3);
		subReports.add(subReportMap3);
		//주민세 납부 신고
		Map<String, Object> subReportMap4 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data4 = hpc950ukrService.printResidentNapTax(param);
		subReportMap4.put("DATA_SET", "SQLDS5");
		subReportMap4.put("SUB_DATA", subReport_data4);
		subReports.add(subReportMap4);
		//주민세 종업원분
		Map<String, Object> subReportMap5 = new HashMap<String ,Object>();
		List<Map<String, Object>> subReport_data5 = hpc950ukrService.printResidentEmployee(param);
		subReportMap5.put("DATA_SET", "SQLDS6");
		subReportMap5.put("SUB_DATA", subReport_data5);
		subReports.add(subReportMap5);

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, subReports, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/human/hpc952clrkr.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpa994clrkrPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);

		String rptType = ObjUtils.getSafeString(param.get("PRINT"));
		String crfFile = "";

		if("1".equals(rptType)){
			crfFile = CRF_PATH + "hpc952rkr1.crf";
		} else {
			crfFile = CRF_PATH + "hpc952rkr2.crf";
		};
		List<Map<String, Object>> report_data = null;

		if("1".equals(rptType)){
			//Main Report
			report_data = hpc952ukrService.selectList1(param);
		} else {
			//Main Report
			report_data = hpc952ukrService.selectList2(param);
		};

		//Main Report
		//report_data = hpa994ukrService.selectList1(param);

		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}