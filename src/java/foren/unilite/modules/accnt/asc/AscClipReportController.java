package foren.unilite.modules.accnt.asc;

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
public class AscClipReportController extends UniliteCommonController {
	
	final static String		CRF_PATH	= "Clipreport4/Accnt/";

	@Resource( name = "asc105skrService" )
	private Asc105skrServiceImpl asc105skrService;
	
	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;
	
	@RequestMapping(value = "/accnt/asc105clrkrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView asc105clskrvPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		Map param = _req.getParameterMap();
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		String crfFile = CRF_PATH + "asc105clskrv.crf";
		
		List<Map<String, Object>> report_data = asc105skrService.selectList(param);
		
		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS1", param, report_data, null, request);
		
		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}
