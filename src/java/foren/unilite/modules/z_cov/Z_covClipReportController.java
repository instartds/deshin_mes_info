package foren.unilite.modules.z_cov;

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
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.clipreport.ClipReportDoc;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;
import foren.unilite.modules.human.hum.Hum950rkrServiceImpl;

@Controller
public class Z_covClipReportController  extends UniliteCommonController {
 @InjectLogger
  public static Logger logger;
  final static String            CRF_PATH           = "/clipreport4/crf/cov/";
  final static String            CRF_PATH2          = "Clipreport4/Z_cov/";

	//20201231 추가: 코브 생산제품라벨출력
	@Resource(name = "s_pmp200rkrv_covService")
	private S_Pmp200rkrv_covServiceImpl s_pmp200rkrv_covService;

  @Resource(name = "tlabAbstractDAO")
  protected TlabAbstractDAO dao;


  
  @RequestMapping(value = "/cov/s_pmp200clrkr_cov.do", method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView s_pmp200clrkrPrint_cov( ExtHtttprequestParam _req, LoginVO user, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ClipReportDoc doc = new ClipReportDoc();
		
		Map param = _req.getParameterMap();
		
		ReportUtils.setCreportPram(user, param, dao);
		ReportUtils.setCreportSanctionParam(param, dao);
		
		String crfFile = CRF_PATH2 + "s_pmp200rkrv_cov.crf";
		//Image 경로 
		//String imagePath = doc.getImagePath();
		
		String queryString = param.get("QUERY_STRING").toString();
		String[] querys = queryString.split("\\|");
		List<Map<String, Object>> queryParams = new ArrayList<Map<String, Object>>();
		
		for(String query : querys) {
			String[] Els = query.split("\\^");
			Map<String, Object> ElMap = new HashMap<String, Object>();

			if(Els.length >= 1) {	ElMap.put("WKORD_NUM"		, Els[0]);	}	else {	ElMap.put("WKORD_NUM"		, "");	}
			if(Els.length >= 2) {	ElMap.put("ITEM_CODE"		, Els[1]);	}	else {	ElMap.put("ITEM_CODE"		, "");	}
			if(Els.length >= 3) {	ElMap.put("ITEM_NAME"		, Els[2]);	}	else {	ElMap.put("ITEM_NAME"		, "");	}
			if(Els.length >= 4) {	ElMap.put("LOT_NO"			, Els[3]);	}	else {	ElMap.put("LOT_NO"			, "");	}
			if(Els.length >= 5) {	ElMap.put("WKORD_Q"			, Els[4]);	}	else {	ElMap.put("WKORD_Q"			, "1");	}
			if(Els.length >= 6) {	ElMap.put("WORK_SHOP_NAME"	, Els[5]);	}	else {	ElMap.put("WORK_SHOP_NAME"	, "");	}
			if(Els.length >= 7) {	ElMap.put("PRODT_WKORD_DATE", Els[6]);	}	else {	ElMap.put("PRODT_WKORD_DATE", "");	}
			if(Els.length >= 8) {	ElMap.put("REMARK"			, Els[7]);	}	else {	ElMap.put("REMARK"			, "");	}
			
			queryParams.add(ElMap);
		}
		
		param.put("QUERY_PARAMS", queryParams);

		List<Map<String, Object>> report_data	= s_pmp200rkrv_covService.selectPrint(param);
		//List<Map<String, Object>> report_data	= null;
		
		//sub report 있을 때 사용
		List<Map<String, Object>> subReports = new ArrayList<Map<String, Object>>();

		String resultKey = doc.generateReport(crfFile, "JDBC1", "SQLDS2", param, report_data, null, request);

		Map<String, Object> rMap = new HashMap<String, Object>();
		rMap.put("success"	, "true");
		rMap.put("resultKey", resultKey);
		return ViewHelper.getJsonView(rMap);
	}

  
}
