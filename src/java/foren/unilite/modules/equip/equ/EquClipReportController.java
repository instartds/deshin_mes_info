package foren.unilite.modules.equip.equ;

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
import foren.unilite.modules.z_kd.S_equ210skrv_kdServiceImpl;


@Controller
@SuppressWarnings({ "rawtypes", "unchecked" })
public class EquClipReportController	extends UniliteCommonController {
 @InjectLogger
	public static Logger logger;
	final static String CRF_PATH = "Clipreport4/Equip/";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@Resource( name = "equ210skrvService" )
	private Equ210skrvServiceImpl equ210skrvService;

	@Resource( name = "s_equ210skrv_kdService" )
	private S_equ210skrv_kdServiceImpl s_equ210skrv_kdService;

	/**
	 * 장비보유현황조회
	 * @param _req
	 * @param user
	 * @param reportType
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/equip/equ210clskrv.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView equ210clskrvPrint( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();

		Map param = _req.getParameterMap();
		String resultKey = "";
		String crfFile = "";
		String connectionName = "";
		String datasetName = "";
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		param.put("COMP_CODE", param.get("S_COMP_CODE"));
		
		connectionName = "JDBC1";
		datasetName = "SQLDS1";

//		ServletContext context = request.getServletContext();
//		String path = context.getRealPath("/");
//		String imagePathFirst = path.split(":")[0] + ":" ;
//		param.put("IMAGE_PATH_FIRST",imagePathFirst);
		
		List<Map<String, Object>> report_data = null;
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();

		List equListArr = new ArrayList();

		String[] equLists = param.get("EQU_LIST").toString().split(",");

		for(String equList : equLists) {
			equListArr.add(equList);
		}
		param.put("EQU_LIST"	, equListArr);
		
		if(param.get("SITE_GUBUN").equals("KDG")){
			report_data = s_equ210skrv_kdService.printList(param);
			crfFile = "Clipreport4/Z_kd/"+ "s_equ210clskrv_kd.crf";
		}
//		else if{
//			
//		}
		resultKey = doc.generateReport(crfFile, connectionName,  datasetName, param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success", "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}
}