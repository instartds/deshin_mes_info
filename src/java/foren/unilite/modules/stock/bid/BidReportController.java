package foren.unilite.modules.stock.bid;

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
public class BidReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    /**
     * 분류별 제품별 재고현황
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/bid/bid100rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView bid100rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            param.put("COMP_CODE", user.getCompCode());
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("bid100rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            //jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            // Primary data source

            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

            	Map dataParam = new HashMap();
            	dataParam.put("COMP_CODE"	, param.get("COMP_CODE"));
            	dataParam.put("DIV_CODE"	, param.get("DIV_CODE"));
            	dataParam.put("WH_CODE"		, param.get("WH_CODE"));
            	dataParam.put("DEPT_CODE"	, param.get("DEPT_CODE"));
            	dataParam.put("DEPT_NAME"	, param.get("DEPT_NAME"));
            	dataParam.put("TXTLV_L1"	, param.get("TXTLV_L1"));
            	dataParam.put("TXTLV_L2"	, param.get("TXTLV_L2"));
            	dataParam.put("TXTLV_L3"	, param.get("TXTLV_L3"));
            	dataParam.put("CUSTOM_CODE"	, param.get("CUSTOM_CODE"));
            	dataParam.put("CUSTOM_NAME"	, param.get("CUSTOM_NAME"));
            	dataParam.put("AGENT_TYPE"	, param.get("AGENT_TYPE"));
            	dataParam.put("STOCK_ZERO"	, param.get("STOCK_ZERO"));
            	
            	
            	//logger1.debug("jasper arry : " + arry[i]);
            	
            	jflist.addAll(jasperService.selectList("bid100rkrServiceImpl.selectPrimaryDataList", dataParam));

            
            jf.setList(jflist);
            
            
            // sub report data sources
            
            // 레포트 자체의 SQL 사용시에만 사용 
            //super.jasperService.setDbConnection(jParam);
            
            //jf.addSubDS("DS_SUB01", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB01", param));
            //jf.addSubDS("DS_SUB02", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB02", param));
            //jf.addSubDS("DS_SUB03", jasperService.selectList("mpo501rkrServiceImpl.DS_SUB03", param));

            return ViewHelper.getJasperView(jf);
        }
}
