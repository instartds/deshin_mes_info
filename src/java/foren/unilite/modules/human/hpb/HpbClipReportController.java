package foren.unilite.modules.human.hpb;

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
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class HpbClipReportController extends UniliteCommonController {

	final static String	CRF_PATH	= "Clipreport4/human/";

	@Resource(name = "hpb400rkrService")
	private Hpb400rkrServiceImpl hpb400rkrService;

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@RequestMapping(value = "/human/hpb400clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView hpb400clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		String crfFile = "";
		String resultKey = "";

		//Image 경로 
		String imagePath = doc.getImagePath();

		//20200807 추가: 기타(사업)소득 집계표일 경우 출력 로직
		if(param.get("REPORT_TYPE").equals("3")) {
			crfFile = CRF_PATH + "hpb400clrkrv8.crf";
			//Main Report
			List<Map<String, Object>> report_data = hpb400rkrService.selectList8(param);
			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
		} else {
			//이자배당소득원천징수영수증
			if(param.containsKey("MEDIUM_TYPE") && param.get("MEDIUM_TYPE").equals("4")) {
				crfFile = CRF_PATH + "hpb400clrkrv6.crf";
				//Main Report
				List<Map<String, Object>> report_data = hpb400rkrService.selectList6Header(param);
				//Sub Report
				List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
				Map<String, Object> subReportMap = new HashMap<String ,Object>();
				subReportMap.put("SUB_SECTION1", "SQLDS2");
				List<Map<String, Object>> subReport_data = hpb400rkrService.selectList6(param);
				subReportMap.put("SUB_DATA", subReport_data);
				subReports.add(subReportMap);
				resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
			//거주자 사업소득
			} else if(param.containsKey("MEDIUM_TYPE") && param.get("MEDIUM_TYPE").equals("1")) {
				//발행자보고용
				if(param.get("REPORT_TYPE").equals("0")) {
					crfFile = CRF_PATH + "hpb400clrkrv1.crf";
					//Main Report
					List<Map<String, Object>> report_data = hpb400rkrService.selectList1(param);

					//Sub Report
					List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
					//Sub Report1
					Map<String, Object> subReportMap = new HashMap<String ,Object>();
					List<Map<String, Object>> subReport_data1 = hpb400rkrService.selectList1sub1(param);
					subReportMap.put("REPORT_FILE"	, "subReport1");
					subReportMap.put("DATA_SET"		, "SQLDS2");
					subReportMap.put("SUB_DATA"		, subReport_data1);
					subReports.add(subReportMap);
					//Sub Report2
					Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
					List<Map<String, Object>> subReport_data2 = hpb400rkrService.selectList1sub2(param);
					subReportMap2.put("REPORT_FILE"	, "subReport2");
					subReportMap2.put("DATA_SET"	, "SQLDS3");
					subReportMap2.put("SUB_DATA"	, subReport_data2);
					subReports.add(subReportMap2);
					resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
				//소득자/발행자보관용
				} else {
					crfFile = CRF_PATH + "hpb400clrkrv2.crf";
					//Main Report
					List<Map<String, Object>> report_data = hpb400rkrService.selectList2(param);
					resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
				}
			//거주자 기타소득
			} else if(param.containsKey("MEDIUM_TYPE") && param.get("MEDIUM_TYPE").equals("2")) {
				//발행자보고용
				if(param.get("REPORT_TYPE").equals("0")) {
					crfFile = CRF_PATH + "hpb400clrkrv3.crf";
					//Main Report
					List<Map<String, Object>> report_data = hpb400rkrService.selectList3(param);

					//Sub Report
					List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
					//Sub Report1
					Map<String, Object> subReportMap = new HashMap<String ,Object>();
					List<Map<String, Object>> subReport_data1 = hpb400rkrService.selectList3sub1(param);
					subReportMap.put("REPORT_FILE"	, "subReport1");
					subReportMap.put("DATA_SET"		, "SQLDS2");
					subReportMap.put("SUB_DATA"		, subReport_data1);
					subReports.add(subReportMap);
					//Sub Report2
					Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
					List<Map<String, Object>> subReport_data2 = hpb400rkrService.selectList3sub2(param);
					subReportMap2.put("REPORT_FILE"	, "subReport2");
					subReportMap2.put("DATA_SET"	, "SQLDS3");
					subReportMap2.put("SUB_DATA"	, subReport_data2);
					subReports.add(subReportMap2);
					resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
				//소득자/발행자보관용
				} else {
					crfFile = CRF_PATH + "hpb400clrkrv4.crf";
					//Main Report
					List<Map<String, Object>> report_data = hpb400rkrService.selectList4(param);
					resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
				}
			//비거주자 사업기타소득
			} else if(param.containsKey("MEDIUM_TYPE") && param.get("MEDIUM_TYPE").equals("3")) {
				//발행자보고용
				if(param.get("REPORT_TYPE").equals("0")) {
					crfFile = CRF_PATH + "hpb400clrkrv5.crf";
					//Main Report
					List<Map<String, Object>> report_data = hpb400rkrService.selectList5(param);

					//Sub Report
					List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
					//Sub Report1
					Map<String, Object> subReportMap = new HashMap<String ,Object>();
					List<Map<String, Object>> subReport_data1 = hpb400rkrService.selectList5sub1(param);
					subReportMap.put("REPORT_FILE"	, "subReport1");
					subReportMap.put("DATA_SET"		, "SQLDS2");
					subReportMap.put("SUB_DATA"		, subReport_data1);
					subReports.add(subReportMap);
					//Sub Report2
					Map<String, Object> subReportMap2 = new HashMap<String ,Object>();
					List<Map<String, Object>> subReport_data2 = hpb400rkrService.selectList5sub2(param);
					subReportMap2.put("REPORT_FILE"	, "subReport2");
					subReportMap2.put("DATA_SET"	, "SQLDS3");
					subReportMap2.put("SUB_DATA"	, subReport_data2);
					subReports.add(subReportMap2);
					resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
				//소득자/발행자보관용
				} else {
					crfFile = CRF_PATH + "hpb400clrkrv7.crf";
					//Main Report
					List<Map<String, Object>> report_data = hpb400rkrService.selectList7(param);
					resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);
				}
			}
		}
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}