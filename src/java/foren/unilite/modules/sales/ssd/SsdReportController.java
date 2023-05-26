package foren.unilite.modules.sales.ssd;

import java.io.File;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import foren.framework.logging.InjectLogger;
import foren.framework.model.ExtHtttprequestParam;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import foren.framework.web.jasperreport.JasperFactory;
import foren.framework.web.view.ViewHelper;
import foren.unilite.com.UniliteCommonController;
import foren.unilite.modules.com.report.ReportUtils;

@Controller
public class SsdReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    /**
     * 매입처별 매출현황 조회
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/ssd/ssd100rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView sfa210rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("ssd100rkr", param);
            jf.setReportType(reportType);
            
            jf.setSubReportFiles(subReportFileNames);
            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

            	Map dataParam = new HashMap();
            	dataParam.put("S_COMP_CODE"	, param.get("COMP_CODE"));
            	dataParam.put("DIV_CODE"	, param.get("DIV_CODE"));
            	dataParam.put("DEPT_CODE"	, param.get("DEPT_CODE"));
            	dataParam.put("DEPT_NAME"	, param.get("DEPT_NAME"));
            	dataParam.put("SALE_DATE_FR", param.get("SALE_DATE_FR"));
            	dataParam.put("SALE_DATE_TO", param.get("SALE_DATE_TO"));
            	dataParam.put("CUST_CODE", param.get("CUST_CODE"));
            	dataParam.put("CUST_NAME", param.get("CUST_NAME"));
            	dataParam.put("ITEM_CODE", param.get("ITEM_CODE"));
            	dataParam.put("ITEM_NAME", param.get("ITEM_NAME"));
            	dataParam.put("AGENT_TYPE", param.get("AGENT_TYPE"));
            	
            	//logger1.debug("jasper arry : " + arry[i]);
            	
            	jflist.addAll(jasperService.selectList("ssd100skrvServiceImpl.selectList", dataParam));

            
            jf.setList(jflist);

            return ViewHelper.getJasperView(jf);
        }
}
