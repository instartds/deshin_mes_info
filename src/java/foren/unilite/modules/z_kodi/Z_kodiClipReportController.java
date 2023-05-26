package foren.unilite.modules.z_kodi;

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
import foren.unilite.modules.human.hpa.Hpa900rkrServiceImpl;
import foren.unilite.modules.z_mit.S_pmp110ukrv_mitServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Z_kodiClipReportController	extends UniliteCommonController {
 @InjectLogger
	public static Logger logger;
	final static String CRF_PATH = "Clipreport4/Z_kodi/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "s_pmr910rkrv_kodiService" )
	private S_pmr910rkrv_kodiServiceImpl s_pmr910rkrv_kodiService;

	/**
	 * 작업지시 태그출력
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/z_kodi/s_pmr910clrkrv_kodi.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmr910clrkrv_kodiPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		
		crfFile = CRF_PATH+ "s_pmr910clrkrv_kodi.crf";
		
		connectionName ="JDBC1";
		datasetName ="SQLDS1";

		ServletContext context = request.getServletContext();
		String path = context.getRealPath("/");
		String imagePathFirst = path.split(":")[0] + ":" ;
		param.put("IMAGE_PATH_FIRST",imagePathFirst);

		List<Map<String, Object>> report_data = s_pmr910rkrv_kodiService.selectList1(param);

		
		resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}