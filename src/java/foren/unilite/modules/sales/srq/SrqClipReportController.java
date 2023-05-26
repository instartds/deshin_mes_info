package foren.unilite.modules.sales.srq;

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
public class SrqClipReportController	extends UniliteCommonController {
	final static String	CRF_PATH2	= "Clipreport4/Sales/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource(name = "srq200rkrvService")
	private Srq200rkrvServiceImpl srq200rkrvService;

	@Resource(name = "srq300rkrvService")
	private Srq300rkrvServiceImpl srq300rkrvService;

	@Resource(name = "srq110skrvService")
	private Srq110skrvServiceImpl srq110skrvService;

	@Resource(name = "srq500rkrvService")
	private Srq500rkrvServiceImpl srq500rkrvService;


	@RequestMapping(value = "/sales/srq110clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView srq110clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		String crfFile = CRF_PATH2+"srq110clskrv.crf";

		//Image 경로 
		String imagePath = doc.getImagePath();

		List orderNumList		= new ArrayList();
		List serNumList		= new ArrayList();

		String[] orderNums	= param.get("ORDER_NUM").toString().split(",");
		//String[] serNums	= param.get("SER_NO").toString().split(",");

		for(String orderNum : orderNums) {
			orderNumList.add(orderNum);
		}

//		for(String serNum : serNums) {
//			serNumList.add(serNum);
//		}

		param.put("ORDER_NUM", orderNumList);
		//param.put("SER_NO", serNumList);
		//Report use data
		List<Map<String, Object>> report_data = srq110skrvService.printList(param);

		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null , request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

	@RequestMapping(value = "/sales/srq200clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView srq200clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user				, param, dao);
		ReportUtils.setCreportSanctionParam(param	, dao);
		
		//String crfFile = CRF_PATH2 + "srq200clrkrv_cov.crf";
		String crfFile = CRF_PATH2 + "srq200clrkrv.crf";
		if(ObjUtils.isNotEmpty(ObjUtils.getSafeString(param.get("RPT_ID5")))){
			crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		}		
		
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = srq200rkrvService.clipselectsub(param);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
			String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

			Map<String, Object> rMap = new HashMap<String, Object>();
			rMap.put("success", "true");
			rMap.put("resultKey", resultKey);
			return ViewHelper.getJsonView(rMap);
	}
	
	@RequestMapping(value = "/sales/srq300clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView srq300clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user				, param, dao);
		ReportUtils.setCreportSanctionParam(param	, dao);

		String crfFile = CRF_PATH2+"srq300clrkrv.crf";
		if(ObjUtils.getSafeString(param.get("RPT_ID1")).equals("s_srq300rkrv_kd.crf")){
			crfFile = "Clipreport4/Z_kd/" + ObjUtils.getSafeString(param.get("RPT_ID1"));

			//Image 경로 
			String imagePath = doc.getImagePath();

			//Report use data
			List<Map<String, Object>> report_data = srq300rkrvService.clipselectsub_kd(param);

			//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
			String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

			Map<String, Object> rMap = new HashMap<String, Object>();
			rMap.put("success", "true");
			rMap.put("resultKey", resultKey);
			return ViewHelper.getJsonView(rMap);
		} else {
			if(ObjUtils.isNotEmpty(ObjUtils.getSafeString(param.get("RPT_ID1")))){
				crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID1"));
			}

			//Image 경로 
			String imagePath = doc.getImagePath();

			//Report use data
			List<Map<String, Object>> report_data = srq300rkrvService.clipselectsub(param);

			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("Report1", "SQLDS2");

			List<Map<String, Object>> subReport_data = srq300rkrvService.clipselectsub(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);

			//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
			String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);

			Map<String, Object> rMap = new HashMap<String, Object>();
			rMap.put("success", "true");
			rMap.put("resultKey", resultKey);
			return ViewHelper.getJsonView(rMap);
		}
	}

	@RequestMapping(value = "/sales/srq500clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView srq500clrkrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc	= new ClipReportDoc();
		Map param			= _req.getParameterMap();
		ReportUtils.setCreportPram(user				, param, dao);
		ReportUtils.setCreportSanctionParam(param	, dao);
		
		String crfFile = CRF_PATH2 + "srq500clrkrv.crf";
		if(ObjUtils.isNotEmpty(ObjUtils.getSafeString(param.get("RPT_ID5")))){
			crfFile = CRF_PATH2 + ObjUtils.getSafeString(param.get("RPT_ID5"));
		}		
		
		//Image 경로 
		String imagePath = doc.getImagePath();

		//Report use data
		List<Map<String, Object>> report_data = srq500rkrvService.selectPrintList(param);

		//String resultKey = doc.generateReport(crfFile, connectionName,	datasetName, param, report_data, subReports, request);
		String resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
	
}