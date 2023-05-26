package foren.unilite.modules.stock.biv;

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
public class BivReportController  extends UniliteCommonController {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());
    private final Logger logger1 = LoggerFactory.getLogger(this.getClass());

    
    /**
     * 실사내역 집계조회
     * 
     * @param _req
     * @return
     * @throws Exception
     */
       @RequestMapping(value = "/biv/biv121rkrPrint.do", method = RequestMethod.GET)
        public ModelAndView biv121rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
           String[] subReportFileNames = {
           };
           
           // Report와 SQL용 파라미터 구성
            Map param = _req.getParameterMap();
            
            param.put("S_USER_ID",user.getUserID());
            
            
            // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
            // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
            JasperFactory jf  = jasperService.createJasperFactory("biv121rkr", param);
            jf.setReportType(reportType);
            // SubReport 파일명 목록을 전달
            // 레포트 수행시 compile을 상황에 따라 수행함.
            jf.setSubReportFiles(subReportFileNames);
            
            
            jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
            
            List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

        	Map dataParam = new HashMap();
        		dataParam.put("S_COMP_CODE"			, param.get("COMP_CODE"));
        		dataParam.put("S_USER_ID"			, param.get("S_USER_ID"));
		    	dataParam.put("DIV_CODE"			, param.get("DIV_CODE"));
		    	dataParam.put("COUNT_DATE"			, param.get("JASPER_DATE"));
		    	dataParam.put("WH_CODE"				, param.get("WH_CODE"));
		    	dataParam.put("ITEM_LEVEL1"			, param.get("ITEM_LEVEL1"));
		    	dataParam.put("ITEM_LEVEL2"			, param.get("ITEM_LEVEL2"));
		    	dataParam.put("ITEM_LEVEL3"			, param.get("ITEM_LEVEL3"));
		    	dataParam.put("COUNT_DATE_TITLE"	, param.get("COUNT_DATE"));

        	//logger1.debug("jasper arry : " + arry[i]);
        	
        	jflist.addAll(jasperService.selectList("biv121skrvServiceImpl.report", dataParam));

        	jf.setList(jflist);
            
        	return ViewHelper.getJasperView(jf);
    }
       
       
   /**
    * 재고 조사 검수 리스트
    * 
    * @param _req
    * @return
    * @throws Exception
    */
      @RequestMapping(value = "/biv/biv122rkrPrint.do", method = RequestMethod.GET)
       public ModelAndView biv122rkrPrint(ExtHtttprequestParam _req, LoginVO user, HttpServletRequest request, @RequestParam(value="reportType" , required = false, defaultValue = "pdf") String reportType) throws Exception {
          String[] subReportFileNames = {
          };
          
          // Report와 SQL용 파라미터 구성
           Map param = _req.getParameterMap();
           
           param.put("S_USER_ID",user.getUserID());
           
           
           // Jasper Factpry생성(파라미터는 prefix("P_") 뭍어 report로 전달 됨.
           // 기본 경로 체계가 아닌 경우 File 전달 방식을 이용            
           JasperFactory jf  = jasperService.createJasperFactory("biv122rkr", param);
           jf.setReportType(reportType);
           // SubReport 파일명 목록을 전달
           // 레포트 수행시 compile을 상황에 따라 수행함.
           jf.setSubReportFiles(subReportFileNames);
           
           
           jf.addParam("IMAGE_PATH", ReportUtils.getImagePath(request));
           
           List<Map<String, Object>> jflist = new ArrayList<Map<String, Object>>();

       	Map dataParam = new HashMap();
       		dataParam.put("S_COMP_CODE"			, param.get("COMP_CODE"));
	    	dataParam.put("DIV_CODE"			, param.get("DIV_CODE"));
	    	dataParam.put("WH_CODE"				, param.get("WH_CODE"));
	    	dataParam.put("COUNT_DATE"			, param.get("COUNT_DATE"));
	    	dataParam.put("DEPT_CODE"			, param.get("DEPT_CODE"));
	    	dataParam.put("SECTOR"				, param.get("SECTOR"));
       	//logger1.debug("jasper arry : " + arry[i]);
       	
       	jflist.addAll(jasperService.selectList("biv121ukrvServiceImpl.report", dataParam));

       	jf.setList(jflist);
           
       	return ViewHelper.getJasperView(jf);
   }
}
