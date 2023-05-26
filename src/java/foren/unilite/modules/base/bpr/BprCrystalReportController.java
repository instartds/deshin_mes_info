package foren.unilite.modules.base.bpr;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.dao.TlabAbstractDAO;
import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.framework.web.crystalreport.CrystalReportDoc;
import foren.framework.web.crystalreport.CrystalReportFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class BprCrystalReportController extends UniliteCommonController {
	@InjectLogger
	public static Logger logger;
	final static String RPT_PATH = "/WEB-INF/Reports2011/Base";

	@Resource(name = "tlabAbstractDAO")
	protected TlabAbstractDAO dao;

	@RequestMapping(value = "/base/bpr520crkrv.do", method = RequestMethod.GET)
	public ModelAndView bpr520crkrvPrint(ExtHtttprequestParam _req, LoginVO user,
	    @RequestParam(value = "reportType", required = false, defaultValue = "pdf") String reportType,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
		CrystalReportDoc cDoc = new CrystalReportDoc();
		CrystalReportFactory clientDoc = null;
		Map<String, Object> param = _req.getParameterMap();
        ReportUtils.setCreportSanctionParam(param, dao);

		String sql = "";
		
		//레포트 제목 출력 관련
	    if(ObjUtils.isEmpty(param.get("PT_TITLENAME"))){
	        param.put("PT_TITLENAME", "");
	    }
	    //레포트 회사명 출력 관련
	    if(ObjUtils.isEmpty(user.getCompName())){
	        param.put("S_COMP_NAME", "");
	    }else{
	        param.put("S_COMP_NAME", user.getCompName());
	    }
	    //레포트 출력일 출력 관련
	    Date nDate = new Date();
	    String sDate = "";
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	    sDate = sdf.format(nDate);
	    
	    if(ObjUtils.isEmpty(param.get("PT_OUTPUTDATE"))){
	        param.put("PT_OUTPUTDATE", sDate);
	    }
	    

        param.put("COMP_CODE", user.getCompCode());

        param.put("ITEM_CODE_PARAM", param.get("ITEM_CODE"));
        param.put("ITEM_NAME_PARAM", param.get("ITEM_NAME"));
        param.put("DISPLAY_TYPE_PARAM", param.get("DISPLAY_TYPE"));
	    
	    
		try {
		    sql = dao.mappedSqlString("bpr520rkrvServiceImpl.printList", param);
		    List subReports = new ArrayList();
		    /**
             * 결재란관련     san_top_sub.rpt
             */
            Map<String, String> subMap = new HashMap<String, String>();
            subMap.put("NAME", "san_top_sub.rpt");
            subMap.put("SQL", dao.mappedSqlString("commonReportServiceImpl.getSanctionInfo", param));
            subReports.add(subMap);
		    
		    
			clientDoc = cDoc.generateReport(RPT_PATH + "/bpr520rkrv", "bpr520rkrv", param, sql, subReports, request);
		} catch (Throwable e2) {
			e2.printStackTrace();
		}
		clientDoc.setPrintFileName("bpr520rkrv");
		clientDoc.setReportType(reportType);
		return ViewHelper.getCrystalReportView(clientDoc);
	}
}
