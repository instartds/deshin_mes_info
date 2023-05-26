package foren.unilite.modules.sales.sat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
public class SatClipReportController	extends UniliteCommonController {

	final static String		CRF_PATH		= "Clipreport4/Sales/";
	
	 private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource( name = "sat200skrvService" )
	private Sat200skrvServiceImpl sat200skrvService;
	
	@Resource( name = "sat600ukrvService" )
	private Sat600ukrvServiceImpl sat600ukrvService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;


	/**
	 * 출고요청조회 (sat200clskrv)
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sales/sat200clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView sat200clskrvPrint(ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		// 신청서 : APPLY , 인수증 : TAKE
		String gubun = ObjUtils.getSafeString(param.get("GUBUN"));
  
		String resultKey = null;

		//Image 경로 
		String imagePath = doc.getImagePath();
		// 신청서
		if("APPLY".equals(gubun)) {
			String crfFile = CRF_PATH +  ObjUtils.getSafeString(param.get("RPT_ID1"));
			//Main Report
			List<Map<String, Object>> report_data = sat200skrvService.selectPrintList1Master(param);
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
  
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = sat200skrvService.selectPrintList1Detail(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);
  
			// report 실행
			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
			
			
			// 인수증
		} else if("TAKE".equals(gubun)){
			String crfFile = CRF_PATH + ObjUtils.getSafeString(param.get("RPT_ID2"));
			//Main Report
			List<Map<String, Object>> report_data = sat600ukrvService.selectPrintList2Master(param);
			
			//Sub Report
			List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();
  
			Map<String, Object> subReportMap = new HashMap<String ,Object>();
			subReportMap.put("SUB_SECTION1", "SQLDS2");

			List<Map<String, Object>> subReport_data = sat600ukrvService.selectPrintList2Detail(param);
			subReportMap.put("SUB_DATA", subReport_data);
			subReports.add(subReportMap);
  
			// report 실행
			resultKey = doc.generateReport(crfFile, "JDBC1","SQLDS1", param, report_data, subReports, request);
		}

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
